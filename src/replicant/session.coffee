#= require replicant/trigger_event

class Replicant.Session
  constructor: (@element) ->
    @navigating = false

  evaluate: (script) ->
    defer =>
      @element.evaluate(script)

  goToLocation: (location) ->
    @navigate =>
      @element.location = location

  goBack: ->
    @navigate =>
      @element.goBack()

  goForward: ->
    @navigate =>
      @element.goForward()

  clickSelector: (selector) ->
    @navigate =>
      clickElement(@querySelector(selector))

  wait: ->
    new Promise (resolve, reject) ->
      defer(resolve)

  waitForEvent: (eventName, callback) ->
    if callback?
      waitForEventWithCallback(@element.window, eventName, callback)
    else
      waitForEventWithPromise(@element.window, eventName)

  waitForNavigation: ->
    @navigate -> true

  # Private

  navigate: (callback) ->
    @promiseNavigation (resolve) =>
      waitForEventWithCallback @element, "replicant-navigate", (event) =>
        resolve(action: event.action, location: @element.location)
      defer(callback)

  promiseNavigation: (callback) ->
    if @navigating
      Promise.reject(new Error "Already navigating")
    else
      @navigating = true
      new Promise(callback)
        .then (result) =>
          @navigating = false
          result
        .catch (error) =>
          @navigating = false
          throw error

  querySelector: (selector) ->
    @element.document?.querySelector(selector) ?
      throw new Error "No element matching selector `#{selector}'"

  clickElement = (element) ->
    Replicant.triggerEvent(element, "click")

  waitForEventWithCallback = (element, eventName, callback) ->
    element.addEventListener eventName, handler = (event) ->
      element.removeEventListener(eventName, handler)
      callback(event)

  waitForEventWithPromise = (element, eventName) ->
    new Promise (resolve, reject) ->
      waitForEventWithCallback(element, eventName, resolve)

  defer = (callback) ->
    setTimeout(callback, 1)
