#= require replicant/extend_object

Replicant.triggerEvent = (element, eventName, attributes = {}) ->
  event = element.ownerDocument.createEvent("Events")
  event.initEvent(eventName, true, true)
  Replicant.extendObject(event, attributes)
  element.dispatchEvent(event)
  event
