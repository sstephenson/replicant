#= require replicant/trigger_event

class Replicant.Session
  constructor: (@element) ->
    @navigating = false

  evaluate: (script, callback) ->
    defer =>
      result = @element.evaluate(script)
      callback?(result)

  goToLocation: (location, callback) ->
    @navigate callback, =>
      @element.location = location

  goBack: (callback) ->
    @navigate callback, =>
      @element.goBack()

  goForward: (callback) ->
    @navigate callback, =>
      @element.goForward()

  clickSelector: (selector, callback) ->
    @navigate callback, =>
      @clickElement(@querySelector(selector))

  wait: (callback) ->
    defer(callback)

  waitForEvent: (eventName, callback) ->
    waitForEvent(@element.window, eventName, callback)

  waitForNavigation: (callback) ->
    @navigate callback, -> true

  # Private

  navigate: (resolve, callback) ->
    if @navigating
      throw new Error "Already navigating"
    else
      @navigating = true
      waitForEvent @element, "replicant-navigate", (event) =>
        @navigating = false
        defer =>
          resolve?(action: event.action, location: @element.location)
      defer(callback)

  querySelector: (selector) ->
    @element.document?.querySelector(selector) ?
      throw new Error "No element matching selector `#{selector}'"

  clickElement: (element) ->
    event = Replicant.triggerEvent(element, "click")
    if not event.defaultPrevented and element.hasAttribute("href")
      @element.location = element.getAttribute("href")

  waitForEvent = (element, eventName, callback) ->
    element.addEventListener eventName, handler = (event) ->
      element.removeEventListener(eventName, handler)
      callback?(event)

  defer = (callback) ->
    setTimeout(callback, 1) if callback
