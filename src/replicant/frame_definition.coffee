#= require replicant/register_element
#= require replicant/frame_controller

Replicant.registerElement "replicant-frame",
  defaultCSS: """
    %t {
      position: relative;
      display: block;
      width: 320px;
      height: 240px;
      border: 1px solid windowframe;
    }

    %t > iframe {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      border: none;
    }
  """

  # Lifecycle callbacks

  createdCallback:
    value: ->
      @controller = new Replicant.FrameController this

  attachedCallback:
    value: ->
      @controller.elementAttached()

  # Properties

  iframeElement:
    get: ->
      @controller.getIframeElement()

  window:
    get: ->
      @iframeElement?.contentWindow

  document:
    get: ->
      @window?.document

  location:
    get: ->
      @window?.location

    set: (location) ->
      @iframeElement.src = location.toString()

  title:
    get: ->
      @document?.title

  # Methods

  goBack:
    value: ->
      @window?.history.back()

  goForward:
    value: ->
      @window?.history.forward()
