QUnit.module "<replicant-frame>"

frameTest "suppresses initial popstate event", (frame, assert, done) ->
  navigatedAfterLoad = false
  waitForEvent frame, "replicant-navigate", ->
    navigatedAfterLoad = true
  defer ->
    assert.notOk(navigatedAfterLoad)
    done()

frameTest "navigating to a page", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-navigate", (event) ->
    assert.equal(event.action, "load")
    assert.equal(frame.location.pathname, "/fixtures/default.html")
    waitForEvent frame, "replicant-load", ->
      done()

frameTest "navigating by submitting a form", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#form-submit")
    waitForEvent frame, "replicant-navigate", (event) ->
      assert.equal(event.action, "load")
      assert.equal(frame.location.pathname, "/fixtures/form.html")
      done()

frameTest "navigating with pushState", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#pushstate-link")
    waitForEvent frame, "replicant-navigate", (event) ->
      assert.equal(event.action, "push")
      assert.equal(frame.location.pathname, "/fixtures/push.html")
      observedLoadEvent = false
      waitForEvent frame, "replicant-load", ->
        observedLoadEvent = true
      defer ->
        assert.notOk(observedLoadEvent)
        done()

frameTest "navigating with replaceState", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#replacestate-link")
    waitForEvent frame, "replicant-navigate", (event) ->
      assert.equal(event.action, "replace")
      assert.equal(frame.location.pathname, "/fixtures/replace.html")
      observedLoadEvent = false
      waitForEvent frame, "replicant-load", ->
        observedLoadEvent = true
      defer ->
        assert.notOk(observedLoadEvent)
        done()

frameTest "navigating with a hash change", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#hashchange-link")
    waitForEvent frame, "replicant-navigate", (event) ->
      assert.equal(event.action, "pop")
      assert.equal(frame.location.pathname, "/fixtures/default.html")
      assert.equal(frame.location.hash, "#hash")
      observedLoadEvent = false
      waitForEvent frame, "replicant-load", ->
        observedLoadEvent = true
      defer ->
        assert.notOk(observedLoadEvent)
        done()

frameTest "navigating back", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      frame.location = "about:blank"
    waitForEvent frame, "replicant-load", ->
      assert.equal(frame.location.toString(), "about:blank")
      defer ->
        frame.goBack()
      waitForEvent frame, "replicant-navigate", (event) ->
        assert.equal(event.action, "load")
        waitForEvent frame, "replicant-load", ->
          assert.equal(frame.location.pathname, "/fixtures/default.html")
          done()

frameTest "navigating forward", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      frame.location = "about:blank"
    waitForEvent frame, "replicant-load", ->
      defer ->
        frame.goBack()
      waitForEvent frame, "replicant-load", ->
        defer ->
          frame.goForward()
        waitForEvent frame, "replicant-navigate", (event) ->
          assert.equal(event.action, "load")
          waitForEvent frame, "replicant-load", ->
            assert.equal(frame.location.toString(), "about:blank")
            done()

frameTest "navigating back from pushState", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#pushstate-link")
    waitForEvent frame, "replicant-navigate", ->
      defer ->
        frame.goBack()
      waitForEvent frame, "replicant-navigate", (event) ->
        assert.equal(event.action, "pop")
        assert.equal(frame.location.pathname, "/fixtures/default.html")
        done()

frameTest "navigating forward to pushState", (frame, assert, done) ->
  defer ->
    frame.location = "/fixtures/default.html"
  waitForEvent frame, "replicant-load", ->
    defer ->
      clickElement(frame.document, "#pushstate-link")
    waitForEvent frame, "replicant-navigate", ->
      defer ->
        frame.goBack()
      waitForEvent frame, "replicant-navigate", (event) ->
        defer ->
          frame.goForward()
        waitForEvent frame, "replicant-navigate", ->
          assert.equal(event.action, "pop")
          assert.equal(frame.location.pathname, "/fixtures/push.html")
          done()
