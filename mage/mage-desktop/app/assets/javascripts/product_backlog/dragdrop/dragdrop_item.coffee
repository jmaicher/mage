"use strict"

deps = []
module = angular.module('mage.desktop.product_backlog.dragdrop.item', deps)

module.directive 'dragdropItem', ($document, $window, dragdropConfig) ->
  require: ['ngModel', '^dragdropContainer']
  restrict: 'A'
  controller: ($scope) ->
    @scope = $scope
    return
  link: (scope, element, attrs, ctrls) ->
    element.addClass(dragdropConfig.itemClass)

    ngModelCtrl = ctrls[0]
    parentCtrl = ctrls[1]

    model = scope.model = undefined
    parent = parentCtrl.scope.dragdrop

    # Bind model value from ngModel to scope
    ngModelCtrl.$render = ->
      dragdrop.model = ngModelCtrl.$modelValue

    getIndex = ->
      @parent.getIndex(@model)

    # Helper
    drag = undefined
    document = $document[0]
    body = angular.element(document.body)
    createElement = (tagName) -> angular.element(document.createElement(tagName))
    tagName = (element) -> element.prop('tagName')
    width = (element) -> element.prop('offsetWidth')
    height = (element) -> element.prop('offsetHeight')

    getPageBounds = (element) ->
      bounds = element[0].getBoundingClientRect()
      
      return {
        width: bounds.width || element.prop('offsetWidth')
        height: bounds.height || element.prop('offsetHeight')
        top: bounds.top + ($window.pageYOffset || $document[0].documentElement.scrollTop)
        left: bounds.left + ($window.pageXOffset || $document[0].documentElement.scrollLeft)
      }

    initPosition = (evt, element) ->
      bounds = getPageBounds(element)

      pos = {}
      pos.offsetX = evt.pageX - bounds.left
      pos.offsetY = evt.pageY - bounds.top
      pos.startX = pos.lastX = event.pageX
      pos.startY = pos.lastY = event.pageY
      pos.nowX = pos.nowY = 0
      
      return pos

    updatePosition = (evt, drag) ->
      x = drag.pos.nowX = event.pageX - drag.pos.offsetX
      y = drag.pos.nowY = event.pageY - drag.pos.offsetY

      drag.dragElement.css
        'left': "#{x}px"
        'top': "#{y}px"

    dragParentChanged = (evt, from, to) ->
      to.element.removeClass(dragdropConfig.containerEmptyClass)
      if from.getItems().length == 1 && from.contains(drag.origin.model)
        # the only item is being dragged => show empty
        from.element.addClass(dragdropConfig.containerEmptyClass)
      else
        from.updateEmptyClass()

      relOffsetX = drag.pos.offsetX / width(drag.dragElement)
      relOffsetY = drag.pos.offsetY / height(drag.dragElement)

      from.element.removeClass(dragdropConfig.dropContainerClass)
      drag.dragElement.removeClass(from.element.attr('class'))
      drag.dragElement.addClass(to.element.attr('class'))

      x = drag.pos.nowX
      y = drag.pos.nowY
      w = width(drag.dragElement)
      h = height(drag.dragElement)

      if(evt.pageX < x || evt.pageX > (x + w) || evt.pageY < y || evt.pageY > (y + h))
        newOffsetX = drag.pos.offsetX = relOffsetX * width(drag.dragElement)
        newOffsetY = drag.pos.offsetY = relOffsetY * height(drag.dragElement)
        updatePosition(evt, drag)


    updateDragTarget = (evt, target, parent, index) ->
      if drag.targetParent != parent
        dragParentChanged(evt, drag.targetParent, parent)

      drag.target = target
      drag.targetParent = parent
      drag.targetIndex = index
    # updateDragTarget

    isDragBefore = (evt, el) ->
      bounds = getPageBounds(el)
      placeHolderBounds = getPageBounds(drag.placeHolder)
      if placeHolderBounds.top > bounds.top
        dragElementBounds = getPageBounds(drag.dragElement)
        dragBefore = dragElementBounds.top < bounds.top + height(el) / 2
      else
        dragBefore = evt.pageY < bounds.top

      dragBefore
    # isDragBefore
      
    # Insert drag before given item
    insertDragBefore = (evt, item) ->
      item.element.before(drag.placeHolder)

      if item.parent == drag.origin.parent && drag.origin.getIndex() < item.getIndex()
        index = item.getIndex() - 1
      else
        index = item.getIndex()

      updateDragTarget(evt, item, item.parent, index)

    # Insert drag after given item
    insertDragAfter = (evt, item) ->
      item.element.after(drag.placeHolder)

      if item.parent == drag.origin.parent && drag.origin.getIndex() < item.getIndex()
        index = item.getIndex()
      else
        index = item.getIndex() + 1

      updateDragTarget(evt, item, item.parent, index)

    # Insert drag into given parent (container)
    insertDrag = (evt, parent) ->
      if drag.origin.parent == parent
        # back to origin
        if drag.previousElementSibling
          drag.previousElementSibling.after(drag.placeHolder)
        else
          drag.origin.parent.element.prepend(drag.placeHolder)
        index = drag.origin.getIndex()
      else if parent.isSortable()
        # append to sortable
        parent.element.append(drag.placeHolder)
        index = parent.getItems().length
      else
        # prepend to non-sortable
        # Note: Placeholder is always first elmement => must insert after placeholder to not mess up css styles (every third child...)
        parent.element.addClass(dragdropConfig.dropContainerClass)
        firstItem = parent.element.find(".#{dragdropConfig.itemClass}")[0]
        if firstItem
          angular.element(firstItem).before(drag.placeHolder)
        else
          # empty, but placeholder is first elment => append not prepend!
          parent.element.append(drag.placeHolder)
        index = 0

      updateDragTarget(evt, null, parent, index)

    containsPlaceholder = (parent) ->
      hasPlaceholder = false
      items = parent.children()
      for item in items
        if angular.element(item).hasClass(dragdropConfig.placeHolderClass)
          hasPlaceholder = true
          break
      hasPlaceholder

    resetDragChanges = ->
      drag.targetParent.updateEmptyClass()
      drag.targetParent.element.removeClass(dragdropConfig.dropContainerClass)
      drag.placeHolder.remove()
      drag.dragElement.remove()


    dragRollback = ->
      if drag.previousElementSibling
        drag.previousElementSibling.after(drag.element)
      else
        drag.origin.parent.element.prepend(drag.element)

      resetDragChanges()

    getDragDropScope = (el) ->
      if el.scope() && el.scope().dragdrop
        return el.scope()
      else
        el = el.parents(".#{dragdropConfig.containerClass}")[0]
        if el then getDragDropScope(angular.element(el)) else undefined

    belongsToDifferentContainer = (newTarget) ->
      if newTarget.type == 'item'
        newTarget.parent != drag.targetParent
      else
        newTarget != drag.targetParent

 
    # -- Drag handler ----------------------------------

    dragStart = (evt) ->
      if drag
        return

      # Do not trigger when link is clicked
      if evt.target.tagName.toLowerCase() == 'a'
        return

      # Do not trigger on right click
      if(event.button == 2 || event.which == 3)
        return

      evt.preventDefault()

      # Note: dragElement is the clone of the (current) parent
      dragElement = createElement(tagName(parent.element))
        .addClass(dragdropConfig.dragElementClass)
        .addClass(parent.element.attr('class'))

      placeHolder = createElement(tagName(element))
        .addClass(dragdropConfig.placeHolderClass)
        .addClass(element.attr('class'))

      previousElementSibling = element[0].previousElementSibling
      if(previousElementSibling)
        previousElementSibling = angular.element(previousElementSibling)
        
      drag = {
        pos: initPosition(evt, element)
        origin: dragdrop
        targetIndex: dragdrop.getIndex(),
        targetParent: dragdrop.parent,
        target: dragdrop
        element: element,
        dragElement: dragElement,
        placeHolder: placeHolder,
        previousElementSibling: previousElementSibling
      }

      element.after(placeHolder)

      dragElement.append(element)
      body.append(dragElement)
      updatePosition(evt, drag)

      bindEvents()
    # dragStart

    dragMove = (evt) ->
      evt.preventDefault()

      updatePosition(evt, drag)

      targetX = event.pageX - $document[0].documentElement.scrollLeft
      targetY = event.pageY - ($window.pageYOffset || $document[0].documentElement.scrollTop)

      #dragElementPageBounds = getPageBounds(drag.dragElement)
      #targetTopX = (dragElementPageBounds.left + dragElementPageBounds.width / 2) - $document[0].documentElement.scrollLeft
      #targetTopY = dragElementPageBounds.top - ($window.pageYOffset || $document[0].documentElement.scrollTop) + 5
      #targetBottomX = (dragElementPageBounds.left + dragElementPageBounds.width / 2) - $document[0].documentElement.scrollLeft
      #targetBottomY = (dragElementPageBounds.top + dragElementPageBounds.height) - ($window.pageYOffset || $document[0].documentElement.scrollTop) - 5

      drag.dragElement.addClass(dragdropConfig.hiddenClass)
      #targetElementTop = angular.element(document.elementFromPoint(targetTopX, targetTopY))
      targetElement = angular.element(document.elementFromPoint(targetX, targetY))
      #targetElementBottom = angular.element(document.elementFromPoint(targetBottomX, targetBottomY))
      drag.dragElement.removeClass(dragdropConfig.hiddenClass)

      target = undefined
      # scopeTop = getDragDropScope(targetElementTop)
      scope = getDragDropScope(targetElement)
      # scopeBottom = getDragDropScope(targetElementBottom)
      
      #if scopeTop && belongsToDifferentContainer(scopeTop.dragdrop)
      #  target = scopeTop.dragdrop
      #else if scopeBottom && belongsToDifferentContainer(scopeBottom.dragdrop)
      #  target = scopeBottom.dragdrop
      #else if scope
      #  target = scope.dragdrop
      
      if scope
        target = scope.dragdrop
        
      if !target
        return

      if target.type == 'item' && target.parent.isSortable()
        if isDragBefore(evt, target.element)
          insertDragBefore(evt, target)
        else
          insertDragAfter(evt, target)
      else
        targetParent = if target.type == 'item' then target.parent else target
        if !containsPlaceholder(targetParent.element)
          insertDrag(evt, targetParent)
      # endif

    # dragMove
    
    dragEnd = (evt) ->
      if !drag
        return

      evt.preventDefault()
 
      resetDragChanges()

      model = drag.origin.model
      # Note: Do not call after modifying the model (=index) below
      originIndex = drag.origin.getIndex()
      originParent = drag.origin.parent
      targetIndex = drag.targetIndex
      targetParent = drag.targetParent

      # update model
      originParent.removeItem(originIndex)
      targetParent.insertItem(targetIndex, model)

      # Trigger callbacks
      if(originParent == targetParent)
        # same parents
        if(originIndex != targetIndex)
          # order changed
          targetParent.onItemMoved(model, targetIndex, originIndex)
      else
        # different parents
        targetParent.onItemInserted(model, targetIndex)
        originParent.onItemRemoved(model, originIndex)

      drag = undefined

      unbindEvents()
    # dragEnd

    dragCancel = (evt) ->
    # dragCancel

    bindEvents = ->
      $document.bind 'mousemove', dragMove
      $document.bind 'mouseup', dragEnd

    unbindEvents = ->
      $document.unbind 'mousemove', dragMove
      $document.unbind 'mouseup', dragEnd

    element.bind 'mousedown', dragStart


    # -- Dragdrop item API --------------------------

    dragdrop = scope.dragdrop = {
      type: 'item',
      element: element,
      model: undefined, # will be set below
      parent: parent,
      getIndex: getIndex
    }

    return
# dragdropItem

