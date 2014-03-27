"use strict"

module = angular.module('mage.models', [])

class Model
  constructor: (attrs = {}) ->
    angular.extend(@, attrs)

class Backlog extends Model
  constructor: (attrs) ->
    super attrs

class BacklogItem extends Model
  constructor: (attrs) ->
    super attrs

  has_tag: (tag) ->
    !!_.find(@taggings, (tagging) -> tagging.tag.name == tag)

class BacklogItemTagging extends Model
  constructor: (attrs) ->
    super attrs


module.value 'Backlog', Backlog
module.value 'BacklogItem', BacklogItem
module.value 'BacklogItemTagging', BacklogItemTagging

