"use strict"

deps = []
module = angular.module('mage.board.dashboard', deps)

module.config ($routeProvider) ->
  $routeProvider
    .when '/dashboard',
      templateUrl: '/views/dashboard.html',
      controller: 'DashboardController',
      resolve:
        data: (Dashboard) ->
          Dashboard.get().$promise
        reactiveActivities: (MageReactive) ->
          MageReactive.connect('/activities')


module.controller 'DashboardController', ($scope, $rootScope, $location, data, reactiveActivities, MeetingService) ->
  $scope.sprint = data.sprint
  $scope.data = data

  reactiveActivities.on 'meeting.started', (meeting_params) ->
    meeting = MeetingService.from_params(meeting_params)
    $scope.$apply ->
      $rootScope.meeting = meeting
      $location.path "/meetings/#{meeting.model.id}"
# DashboardController


module.service 'DashboardResource', ($resource, Hosts) ->
  DashboardResource = $resource "#{Hosts.api}/dashboard"

  DashboardResource
# DashboardResource

module.service 'Dashboard', (DashboardResource) ->

  get = (sprint) ->
    DashboardResource.get()

  return {
    get: get
  }
# Dashboard


module.directive 'burndownChart', ($rootScope) ->
  restrict: 'E'
  scope:
    data: '='
  link: (scope, element, attr) ->
    parent = element.parent()
    
    render = resize = ->
      element.html("")
      w = parent.width()
      h = parent.height()
      chart = new BurndownChart(element.get(0), scope.data, w, h)
      chart.render()

    $rootScope.$on "windowResize", ->
      resize()
     
    render()

    return
# burndownChart


class BurndownChart

  constructor: (@element, @data, w, h) ->
    @margin = { top: 25, right: 25, bottom: 75, left: 75 }
    @height = h - @margin.top - @margin.bottom
    @width = w - @margin.left - @margin.right
    @scaleFactor = Math.min(@width, @height) / 2

  render: ->

    x = d3.scale.linear()
      .range([0, @width])
      .domain([0, @data.number_of_days])

    y = d3.scale.linear()
        .range([@height, 0])
        .domain([0, @data.amount_complete + 5])

    xAxis = d3.svg.axis()
        .scale(x)
        .ticks(@data.number_of_days)
        .orient("bottom")

    yAxis = d3.svg.axis()
        .scale(y)
        .ticks(5)
        .orient("left")

    lineFunc = d3.svg.line()
      .x((d) -> x(d.day))
      .y((d) -> y(d.amount))
      .interpolate('linear')

    svg = d3.select(@element).append("svg")
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

    d3.selectAll(".tick > text")
      .style("font-size", @scaleFactor * 0.15 + "px")

    tickTextOffset = @scaleFactor * 0.1
    tickLength = @scaleFactor * 0.06

    axisStrokeWidth = Math.max(@scaleFactor * 0.01, 1)

    d3.selectAll(".axis > path")
      .attr("stroke-width", axisStrokeWidth)

    d3.selectAll(".y.axis > .tick > text")
      .attr("x", - tickTextOffset)

    d3.selectAll(".y.axis > .tick > line")
      .attr("x2", - tickLength)
      .attr("stroke-width", axisStrokeWidth)

    d3.selectAll(".x.axis > .tick > text")
      .attr("y", tickTextOffset)

    d3.selectAll(".x.axis > .tick > line")
      .attr("y2", tickLength)
      .attr("stroke-width", axisStrokeWidth)

    svg.append('svg:path')
      .attr('class', 'actual-line')
      .attr('d', lineFunc(@data.days))
      .attr('stroke-width', Math.max(@scaleFactor * 0.02, 1))

    dataCirclesGroup = svg.append('svg:g')
    circles = dataCirclesGroup.selectAll('.data-point').data(@data.days)

    circles
      .enter()
        .append('svg:circle')
        .attr('class', 'actual-dot')
        .attr('cx', (d) -> x(d.day) )
        .attr('cy', (d) -> y(d.amount) )
        .attr('r', Math.max(@scaleFactor * 0.03, 3))
# BurndownChart


module.directive 'progressDonutChart', ($rootScope) ->
  restrict: 'E'
  scope:
    data: '='
  link: (scope, element, attr) ->
    parent = element.parent()
    
    render = resize = ->
      element.html("")
      w = parent.width()
      h = parent.height()
      chart = new ProgressDonutChart(element.get(0), scope.data, w, h)
      chart.render()

    $rootScope.$on "windowResize", ->
      resize()
      
    render()

    return
# progressDonutChart



class ProgressDonutChart

  constructor: (@element, @data, @width, @height) ->
    @radius = Math.min(@width, @height) / 2

  render: ->
    color = d3.scale.ordinal()
      .range(["#428BBA", "#FF7F0E", "#222"])
      # Colors: [Progress until yesterday, progress today, effort remaining]
    
    data = [@data.completed_until_yesterday, @data.completed_today, @data.amount_remaining]

    pie = d3.layout.pie()
      .sort(null)

    arc = d3.svg.arc()
      .outerRadius(@radius)
      .innerRadius(@radius - @radius * 0.2)

    rotation = 30

    svg = d3.select(@element).append("svg")
      .attr("width", @width)
      .attr("height", @height)
      .attr("class", "progress-donut-chart")
    .append("g")
      .attr("transform", "translate(" + @width / 2 + "," + @height / 2 + ") rotate(-#{rotation})")

    svg.append("text")
      .attr("text-anchor", "middle")
      .attr("dominant-baseline", "central")
      .attr("class", "amount-completed")
      .style("font-size", @radius * 0.6)
      .text -> "60%"
      .attr("transform", "rotate(#{rotation})")

    path = svg.selectAll("path")
      .data(pie(data))
    .enter().append("path")
      .attr("fill", (d, i) -> color(i))
      .attr("d", arc)

    svg

# ProgressDonutChart


