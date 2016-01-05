#= require replicant/instrument_method
#= require replicant/trigger_event

{instrumentMethod, triggerEvent} = Replicant

class Replicant.FrameController
  constructor: (@element) ->

  elementAttached: ->
    if @initialize()
      @attachIframeElement()

  getIframeElement: ->
    @iframeElement ?= (
      element = document.createElement("iframe")
      element.addEventListener("load", @iframeElementLoaded, true)
      element.src = "about:blank"
      element
    )

  isLoading: ->
    !@loaded

  # Lifecycle methods

  initialize: ->
    unless @initialized
      @triggerEvent("replicant-initialize")
      @initialized = true

  completeLoad: ->
    @triggerEvent("replicant-load")

  completeNavigationWithAction: (action) ->
    @triggerEvent("replicant-navigate", {action})

  # Iframe instrumentation

  attachIframeElement: ->
    @element.insertBefore(@getIframeElement(), @element.firstChild)

  iframeElementLoaded: =>
    defer =>
      @instrumentHistoryMethods()
      @registerEventListeners()
      @completeNavigationWithAction("load")
      @completeLoad()

  instrumentHistoryMethods: ->
    {prototype} = @element.window.history.constructor
    instrumentMethod(prototype, "pushState", @afterPushState)
    instrumentMethod(prototype, "replaceState", @afterReplaceState)

  registerEventListeners: (callback) ->
    {window} = @element.window
    window.addEventListener("popstate", @afterPopState, true)

  afterPushState: =>
    @completeNavigationWithAction("push")

  afterReplaceState: =>
    @completeNavigationWithAction("replace")

  afterPopState: =>
    @completeNavigationWithAction("pop")

  # Private

  triggerEvent: (eventName, properties) ->
    triggerEvent(@element, eventName, properties)

  defer = (callback) ->
    setTimeout(callback, 1)
