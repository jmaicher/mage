"use strict"

deps = []
module = angular.module('mage.board.meetings.poker', deps)

poker_resolve = ($q, $rootScope, $route, MeetingService) ->
  poker = undefined
  if $rootScope.poker
    poker = $q.when($rootScope.poker)
    # remove global tmp variable
    delete $rootScope.poker
    return poker
  else
    meeting_id = $route.current.params.meeting_id
    poker_id = $route.current.params.poker_id

    MeetingService.get(meeting_id).then (meeting) ->
      meeting.get_poker_session(poker_id).then (poker) ->
        meeting.connect()
        poker
# poker_resolve


module.config ($routeProvider) ->
  base_path = '/meetings/:meeting_id/poker/:poker_id'
  $routeProvider
    .when base_path,
      templateUrl: '/views/meetings/poker.html',
      controller: 'meetings.PokerController',
      resolve: {
        poker: poker_resolve
      }
    .when "#{base_path}/result",
      templateUrl: '/views/meetings/poker_result.html',
      controller: 'meetings.PokerResultController',
      resolve: {
        data: ($q, $rootScope, $route, MeetingService) ->
          poker_promise = poker_resolve($q, $rootScope, $route, MeetingService)
          poker_promise.then (poker) ->
            # NARF :-(
            poker.meeting.connect().then ->
              result_promise = undefined
              if $rootScope.poker_result
                result_promise = $q.when($rootScope.poker_result)
                delete $rootScope.poker_result
              else
                result_promise = poker.get_result()
                  
              return result_promise.then (result) ->
                return {
                  poker: poker,
                  result: result
                }
        # data
      }

module.controller 'meetings.PokerController', ($rootScope, $scope, $location, poker) ->
  $scope.poker = poker
  $scope.meeting = poker.meeting
  $scope.result = undefined
  $scope.estimate_options = poker.model.estimate_options
  
  on_round_completed = (result) ->
    $scope.$apply ->
      $location.path "/meetings/#{poker.meeting.model.id}/poker/#{poker.model.id}/result"

  poker.on 'round_completed', on_round_completed

  $scope.$on '$destroy', ->
    # cleanup
    poker.off 'round_completed', on_round_completed


module.controller 'meetings.PokerResultController', ($rootScope, $scope, $location, data) ->
  poker = data.poker
  result = data.result
  
  $scope.loading = false
  $scope.pokerActive = false
  $scope.pokerCompleted = poker.model.status == "completed"

  $scope.poker = poker
  $scope.result = result

  $scope.restart = ->
    $scope.loading = true
    promise = $scope.poker.restart()
    promise
      .then ->
        $scope.pokerActive = true
        $scope.result = undefined
      .finally -> $scope.loading = false
    return promise
  # restart

  $scope.complete = (option) ->
    $scope.loading = true
    promise = $scope.poker.complete(option)
    promise
      .then ->
        $location.path "/meetings/#{poker.meeting.model.id}"
      .finally ->
        $scope.loading = false
    return promise
  # complete

  on_round_completed = (result) ->
    $scope.$apply ->
      $scope.pokerActive = false
      $scope.result = result
  # on_round_completed
  
  poker.on 'round_completed', on_round_completed

  $scope.$on '$destroy', ->
    # cleanup
    poker.off 'round_completed', on_round_completed


module.directive 'pokerDecisionMenu', ->
  restrict: 'E'
  replace: true
  scope:
    poker: '=poker'
    blocked: '=blocked'
    doRestart: '&onRestart'
    doDecide: '&onDecision'
  templateUrl: '/views/meetings/poker_decision_menu.html'
  controller: ($q, $scope, $timeout) ->
    $scope.restart = ->
      $scope.doRestart()
    
    $scope.decide = (option) ->
      $scope.doDecide(option: option)

module.directive 'optionButton', ->
  restrict: 'E'
  replace: true
  scope:
    option: '=option'
    isBlocked: '=blocked'
    doDecide: '&onDecision'
  templateUrl: '/views/meetings/poker_decision_menu/option_button.html'
  controller: ($scope) ->
    $scope.decide = (option) ->
      return if $scope.isBlocked

      $scope.loading = true
      $scope.doDecide(option: option).finally ->
        $scope.loading = false

module.directive 'restartButton', ->
  restrict: 'E'
  replace: true
  scope:
    isBlocked: '=blocked'
    doRestart: '&onRestart'
  templateUrl: '/views/meetings/poker_decision_menu/restart_button.html'
  controller: ($scope) ->
    $scope.restart = ->
      return if $scope.isBlocked

      $scope.loading = true
      $scope.doRestart().finally ->
        $scope.loading = false


module.directive 'pokerResultChart', ->
  restrict: 'E'
  scope:
    pokerActive: '=pokerActive'
    estimateOptions: '=estimateOptions',
    result: '=result'
  link: (scope, element, attrs) ->
    render = ->
      element.html('')
      chart = new PokerResultChart element[0], scope.estimateOptions, scope.result
      chart.render()

    scope.$watch 'result', (result) ->
      render()


class PokerResultChart

  constructor: (@selector_or_node, estimate_options, result, options = {}) ->
    @margin = options.margin ? { top: 20, right: 20, bottom: 30, left: 50 }
    @width = (options.width ? 800) - @margin.left - @margin.right
    @height = (options.height ? 400) - @margin.top - @margin.bottom

    @estimate_options = estimate_options
    @result = @parse result
        
  parse: (result) ->
    formatted_result = @estimate_options.map (o) ->
      id: o.id
      value: o.value
      percentage: undefined
      votes: undefined
  
    votes = (result && result.votes) || []
    votes_grouped_by_decision = _.groupBy votes, (v) -> v.decision.id
    
    # Add votes and percentage to formatted results
    num_all_votes = votes.length
    formatted_result.forEach (r) ->
      votes = votes_grouped_by_decision[r.id]
      votes = votes || []
      percentage = if num_all_votes == 0 then 0 else votes.length / num_all_votes
      r.percentage = percentage
      r.votes = votes

    formatted_result

  render: ->
    formatPercentage = d3.format(".0%")

    x = d3.scale.ordinal()
        .rangeRoundBands([0, @width], .1)
        .domain(_.pluck(@result, "value"))

    y = d3.scale.linear()
        .range([@height, 0])
        .domain([0, 1])

    xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom")

    yAxis = d3.svg.axis()
        .scale(y)
        .orient("left")
        .tickFormat(formatPercentage)

    if @height <= 200
        yAxis.tickValues([0, .2, .4, .6, .8, 1])

    svg = d3.select(@selector_or_node).append("svg")
        .attr("width", @width + @margin.left + @margin.right)
        .attr("height", @height + @margin.top + @margin.bottom)
        .append("g")
            .attr("transform", "translate(#{@margin.left}, #{@margin.top})")
    
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{@height})")
        .call(xAxis)

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)

    svg.selectAll(".bar")
        .data(@result)
        .enter().append("rect")
            .attr("class", "bar")
            .attr("x", (d) => x(d.value))
            .attr("width", x.rangeBand())
            .attr("y", (d) => y(d.percentage))
            .attr("height", (d) => @height - y(d.percentage))

    return svg
# PokerResultChart
