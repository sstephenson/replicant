#= require_self
#= require_tree ./modules

@frameTest = (name, callback) ->
  QUnit.test name, (assert) ->
    done = assert.async()
    installFrame (frame) ->
      callback frame, assert, ->
        defer ->
          removeFrame()
          done()

@installFrame = (callback) ->
  fixture = document.getElementById("qunit-fixture")
  element = document.createElement("replicant-frame")
  waitForEvent element, "replicant-initialize", ->
    callback(element)
  fixture.appendChild(element)
  element

@removeFrame = ->
  fixture = document.getElementById("qunit-fixture")
  fixture.innerHTML = ""

@waitForEvent = (element, eventName, callback) ->
  handler = (event) ->
    element.removeEventListener(eventName, handler, false)
    callback(event)
  element.addEventListener(eventName, handler, false)

@clickElement = (container, selector) ->
  if element = container.querySelector(selector)
    element.click()

@defer = (callback) ->
  setTimeout(callback, 1)
