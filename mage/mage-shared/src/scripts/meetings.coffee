module = angular.module('mage.meetings', ['ngResource', 'mage.hosts'])

module.service 'PokerSessionResource', ($resource, Hosts) ->
  PokerSessionResource = $resource "#{Hosts.api}/meetings/:meeting_id/poker_sessions/:id", {
    meeting_id: '@meeting_id'
    id: '@id'
  }

  return PokerSessionResource


module.service 'PokerVoteResource', ($resource, Hosts) ->
  PokerVoteResource = $resource "#{Hosts.api}/meetings/:meeting_id/poker_sessions/:poker_session_id/votes", {
    meeting_id: '@meeting_id'
    poker_session_id: '@poker_session_id'
  }

  return PokerVoteResource


module.service 'PokerRoundResource', ($resource, Hosts) ->
  PokerRoundResource = $resource "#{Hosts.api}/meetings/:meeting_id/poker_sessions/:poker_session_id/rounds", {
    meeting_id: '@meeting_id'
    poker_session_id: '@poker_session_id'
  }

  return PokerRoundResource


module.service 'PokerDecisionResource', ($resource, Hosts) ->
  PokerDecisionResource = $resource "#{Hosts.api}/meetings/:meeting_id/poker_sessions/:poker_session_id/decision", {
    meeting_id: '@meeting_id'
    poker_session_id: '@poker_session_id'
  }

  return PokerDecisionResource


module.service 'PokerResultResource', ($resource, Hosts) ->
  PokerResultResource = $resource "#{Hosts.api}/meetings/:meeting_id/poker_sessions/:poker_session_id/result", {
    meeting_id: '@meeting_id'
    poker_session_id: '@poker_session_id'
  }

  return PokerResultResource


module.service 'MeetingParticipationResource', ($resource, Hosts) ->
  MeetingParticipationResource = $resource "#{Hosts.api}/meetings/:meeting_id/participations/:id", {
    meeting_id: '@meeting_id'
    id: '@id'
  }

  return MeetingParticipationResource
    

module.service 'MeetingResource', ($resource, $q, Hosts, MeetingParticipationResource) ->
  MeetingResource = $resource "#{Hosts.api}/meetings/:id", id: '@id', {
    query: {
      method: 'GET',
      isArray: false,
      transformResponse: (data, header) ->
        # Note: In case the server responds with 401, this handler is still called
        # and data will be empty. Can we check the status somehow?
        # Not sure..got no time for that now :-)
        if data.trim() != ""
          wrapped = angular.fromJson(data)
          angular.forEach wrapped.items, (item, idx) ->
            wrapped.items[idx] = new MeetingResource(item)
          return wrapped
        else return data
    }
  }

  MeetingResource.prototype.getName = ->
    if @name != "" then @name
    else "Meeting @ #{@initiator.name}"

  
  return MeetingResource


module.service 'Meeting', ($q, SessionService, MageReactive, MeetingParticipationResource, PokerSessionResource, PokerSession, PokerSessionService) ->

  Meeting = (model) ->
    @model = model
    @reactiveConn = undefined
    return null

  Meeting.prototype = Object.create(EventEmitter.prototype)

  Meeting.prototype.join = ->
    if @model.is_participating then return $q.when(@)
    participation = new MeetingParticipationResource meeting_id: @model.id
    self = @
    participation.$save().then ->
      return self

  Meeting.prototype.start_poker_session = (backlog_item) ->
    PokerSessionService.create(@, backlog_item)

  Meeting.prototype.get_poker_session = (poker_session_id) ->
    PokerSessionService.get(@, poker_session_id)

  Meeting.prototype.connect = ->
    return $q.when(@) if @isConnected()

    ns = "/meetings/#{@model.id}"
    promise = MageReactive.connect(ns, {
      identity: SessionService.getIdentity()
    })

    self = @
    promise.then (reactiveConn) ->
      self.reactiveConn = reactiveConn
      self._bindReactiveConnHandler()
      return self

    return promise.then -> @

  Meeting.prototype.notify_focus = (backlog_item) ->
    return unless @isConnected()
    @reactiveConn.broadcast 'backlog_item.focus', backlog_item

  Meeting.prototype.notify_unfocus = (backlog_item) ->
    return unless @isConnected()
    @reactiveConn.broadcast 'backlog_item.unfocus', backlog_item

  Meeting.prototype.live_update = (type, entity) ->
    return unless @isConnected()
    @reactiveConn.broadcast 'live_update', type: type, entity: entity

  Meeting.prototype.isConnected = ->
    return !!@reactiveConn

  Meeting.prototype.disconnect = ->
    if @reactiveConn
      @reactiveConn.disconnect()

  Meeting.prototype._bindReactiveConnHandler = ->
    self = @

    forward_events = [
      "backlog_item.focus", "backlog_item.unfocus",
      "live_update"
    ]

    forward_events.forEach (evtId) ->
      self.reactiveConn.on evtId, (payload) ->
        self.emit evtId, payload

    # -- planning poker ---------------------------------

    @reactiveConn.on "poker.started", (payload) ->
      poker_model = new PokerSessionResource(payload)
      poker_session = new PokerSession(self, poker_model)
      self.emit "poker.started", poker_session

    @reactiveConn.on "poker.round_completed", (result) ->
      self.emit "poker.round_completed", result

    @reactiveConn.on "poker.restarted", (result) ->
      self.emit "poker.restarted", result

    @reactiveConn.on "poker.completed", (result) ->
      self.emit "poker.completed", result

  return Meeting


module.service 'PokerSession', ($q, PokerVoteResource, PokerResultResource, PokerRoundResource, PokerDecisionResource) ->

  PokerSession = (meeting, model) ->
    @meeting = meeting
    @model = model
    @_bindMeetingHandler()
    return null

  PokerSession.prototype = Object.create(EventEmitter.prototype)

  PokerSession.prototype._bindMeetingHandler = ->
    self = @
    @meeting.on "poker.round_completed", (result) ->
      self.emit "round_completed", result

    @meeting.on "poker.restarted", (result) ->
      # Question: Send and update complete poker resource??
      new_round = result.round
      self.model.current_round = new_round
      self.emit "restarted", result

    @meeting.on "poker.completed", (result) ->
      self.emit "completed", result

  PokerSession.prototype.vote = (option) ->
    vote = new PokerVoteResource
      meeting_id: @meeting.model.id
      poker_session_id: @model.id
      round: @model.current_round
      decision: option.id

    vote.$save()

  PokerSession.prototype.get_result = ->
    result = PokerResultResource.get({
      meeting_id: @meeting.model.id
      poker_session_id: @model.id
    }).$promise


  PokerSession.prototype.restart = ->
    round = new PokerRoundResource
      meeting_id: @meeting.model.id
      poker_session_id: @model.id
    self = @
    round.$save().then (result) ->
      # Update round of the model, this is important!!!
      # Maybe respond with complete poker resource??
      self.model.current_round = result.round
      return self


  PokerSession.prototype.complete = (option) ->
    decision = new PokerDecisionResource
      meeting_id: @meeting.model.id
      poker_session_id: @model.id
      decision: option.id
    
    decision.$save()


  PokerSession


module.service 'PokerSessionService', (PokerSessionResource, PokerSession) ->

  create = (meeting, backlog_item) ->
    poker_session = new PokerSessionResource
      meeting_id: meeting.model.id
      backlog_item_id: backlog_item.id

    poker_session.$save().then (poker) ->
      return new PokerSession(meeting, poker)
  # create

  get = (meeting, poker_session_id) ->
    PokerSessionResource.get(meeting_id: meeting.model.id, id: poker_session_id).$promise.then (model) ->
      return new PokerSession(meeting, model)
  # get

  return {
    get: get
    create: create
  }


module.service 'MeetingService', ($q, $http, Hosts, Meeting, MeetingResource) ->
  meetings = {}

  get_and_update_or_create_and_cache = (model) ->
    meeting = get_and_update(model)
    unless meeting
      meeting = create_and_cache(model)
    meeting
  # get_and_update_or_create_and_cache

  get_and_update = (model) ->
    meeting = meetings[model.id]
    if meeting
      meeting.model = model
    meeting
  # get_and_update

  create_and_cache = (model) ->
    meeting = new Meeting(model)
    meetings[model.id] = meeting
    meeting
  # create_and_cache

  current = ->
    MeetingResource.query().$promise
  # current

  get = (id) ->
    MeetingResource.get(id: id).$promise.then (model) ->
      get_and_update_or_create_and_cache(model)
  # get
  
  create = (params) ->
    meeting = new MeetingResource(params)
    meeting.$save().then (model) ->
      create_and_cache(model)
  # create

  from_params = (params) ->
    model = new MeetingResource(params)
    get_and_update_or_create_and_cache(model)
  # from_params
  
  return {
    current: current
    get: get
    create: create
    from_params: from_params
  }

# MeetingService

