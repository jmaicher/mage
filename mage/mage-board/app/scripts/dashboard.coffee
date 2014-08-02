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

module.controller 'DashboardController', ($scope, data) ->
  console.log "WAT"
  $scope.sprint = data.sprint
  $scope.data = data


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
    @margin = { top: 50, right: 50, bottom: 50, left: 50 }
    @width = w - @margin.left - @margin.right
    @height = h - @margin.top - @margin.bottom

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

    svg.append('svg:path')
      .attr('class', 'actual-line')
      .attr('d', lineFunc(@data.days))

    dataCirclesGroup = svg.append('svg:g')
    circles = dataCirclesGroup.selectAll('.data-point').data(@data.days)

    circles
      .enter()
        .append('svg:circle')
        .attr('class', 'actual-dot')
        .attr('cx', (d) -> x(d.day) )
        .attr('cy', (d) -> y(d.amount) )
        .attr('r', 3)
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

  constructor: (@element, @data, w, h) ->
    @margin = { top: 50, right: 50, bottom: 50, left: 50 }
    @width = w - @margin.left - @margin.right
    @height = h - @margin.top - @margin.bottom
    @radius = Math.min(@width, @height) / 2

  render: ->
    #color = d3.scale.ordinal()
      #.range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"])

    color = d3.scale.category20()
    pie = d3.layout.pie()
      .sort(null)

    arc = d3.svg.arc()
      .outerRadius(@radius)
      .innerRadius(@radius - 30)

    svg = d3.select(@element).append("svg")
      .attr("width", @width)
      .attr("height", @height)
    .append("g")
      .attr("transform", "translate(" + @width / 2 + "," + @height / 2 + ")")

    path = svg.selectAll("path")
      .data(pie([5, 2, 1, 8, 4]))
    .enter().append("path")
      .attr("fill", (d, i) -> color(i))
      .attr("d", arc)

    svg

# ProgressDonutChart


