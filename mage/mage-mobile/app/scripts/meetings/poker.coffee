"use strict"

module = angular.module('mage.mobile.meetings.poker', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:meeting_id/poker/:poker_id',
      templateUrl: '/views/meetings/poker.html'
      controller: 'meetings.PokerController'
      resolve:
        data: ($route, MeetingService) ->
          meeting_id = $route.current.params.meeting_id
          poker_id = $route.current.params.poker_id

          MeetingService.get(meeting_id).then (meeting) ->
            meeting.connect().then ->
              meeting.get_poker_session(poker_id).then (poker) ->
                return {
                  meeting: meeting,
                  poker: poker
                }

module.controller 'meetings.PokerController', ($rootScope, $scope, $location, data) ->
  $rootScope.screenName = 'poker'
  meeting = data.meeting
  poker = data.poker
  options = poker.model.estimate_options

  $scope.locked = poker.model.has_voted
  $scope.loading = false

  currentIndex = currentOption = undefined
  gotoOption = (idx) ->
    currentIndex = $scope.currentIndex = idx
    currentOption = $scope.currentOption = options[idx]
  
  defaultIdx = 0
  if poker.model.has_voted
    option = _.find options, (option) ->
      option.id == poker.model.vote.decision.id
    idx = options.indexOf(option)
    if idx > 0
      defaultIdx = idx

  gotoOption(defaultIdx)

  $scope.next = ->
    return if $scope.locked
    if(currentIndex == options.length - 1) then gotoOption(0)
    else gotoOption(currentIndex + 1)

  $scope.prev = ->
    return if $scope.locked
    if(currentIndex == 0) then gotoOption(options.length - 1)
    else gotoOption(currentIndex - 1)

  on_vote_success = ->
    $scope.locked = true

  on_vote_failure = (reason) ->
    console.error 'Something went wrong :-('
    console.log reason

  $scope.vote = (option) ->
    $scope.loading = true
    poker.vote(option).then(on_vote_success, on_vote_failure)
      .finally ->
        $scope.loading = false

  on_poker_restarted = ->
    $scope.$apply ->
      $scope.locked = false

  poker.on 'restarted', on_poker_restarted

  on_poker_completed = ->
    $scope.$apply ->
      $location.path "/meetings/#{poker.meeting.model.id}"

  poker.on 'completed', on_poker_completed

  $scope.$on '$destroy', ->
    poker.off 'restarted', on_poker_restarted
    poker.off 'completed', on_poker_completed
 
