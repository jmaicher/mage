"use strict"

module = angular.module('mage.mapper', ['mage.models'])

class Mapper
  constructor: (@Model) ->

  from_json: (json) ->
    if(_.isArray(json))
      self = @
      _.map json, (attr) -> new self.Model(self.parse(attr))
    else
      new @Model(@parse(json))

  to_json: (model) ->
  parse: (json) ->
    attr = _.clone(json)
    attr.links = attr._links || []
    delete attr._links

    attr


class BacklogMapper extends Mapper

  @$inject: ['Backlog', 'BacklogItemMapper']
  constructor: (@Backlog, @BacklogItemMapper) ->
    super @Backlog

  parse: (json) ->
    attr = super(json)
    attr.items = @BacklogItemMapper.from_json(attr.items)
    attr


class BacklogItemMapper extends Mapper

  @$inject: ['BacklogItem', 'BacklogItemTaggingMapper']
  constructor: (@BacklogItem, @BacklogItemTaggingMapper) ->
    super @BacklogItem

  parse: (json) ->
    attr = super(json)
    attr.taggings = @BacklogItemTaggingMapper.from_json(attr.taggings)
    attr
  

class BacklogItemTaggingMapper extends Mapper

  @$inject: ['BacklogItemTagging']
  constructor: (@BacklogItemTagging) ->
    super @BacklogItemTagging

  parse: (json) ->
    attr = super(json)


module.service 'BacklogMapper', BacklogMapper
module.service 'BacklogItemMapper', BacklogItemMapper
module.service 'BacklogItemTaggingMapper', BacklogItemTaggingMapper

