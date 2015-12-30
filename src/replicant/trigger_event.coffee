#= require replicant/extend_object

Replicant.triggerEvent = (element, eventName, attributes = {}) ->
  event = document.createEvent("Events")
  event.initEvent(eventName, true, false)
  Replicant.extendObject(event, attributes)
  element.dispatchEvent(event)
