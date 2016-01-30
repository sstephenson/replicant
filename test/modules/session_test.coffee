QUnit.module "Replicant.Session"

@frameTest "navigating with a session", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation "/fixtures/default.html", (navigation) ->
    assert.equal(navigation.location.pathname, "/fixtures/default.html")
    assert.equal(navigation.action, "load")
    done()

@frameTest "concurrent navigation fails", (frame, assert, done) ->
  session = frame.createSession()
  failed = false
  session.goToLocation "/fixtures/default.html", ->
    assert.ok(failed)
    done()
  try
    session.goToLocation("about:blank")
  catch err
    failed = true

@frameTest "clicking a link", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation "/fixtures/default.html", ->
    session.clickSelector "#pushstate-link", (navigation) ->
      assert.equal(navigation.location.pathname, "/fixtures/push.html")
      assert.equal(navigation.action, "push")
      done()

@frameTest "waiting for an event", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation "/fixtures/event.html", (navigation) ->
    session.clickSelector("#event-link")
    session.waitForEvent "test-event", (event) ->
      assert.equal(event.data, "hello")
      session.wait ->
        assert.ok(frame.document.querySelector("#hello"))
        done()

@frameTest "waiting for an event and canceling it", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation "/fixtures/event.html", (navigation) ->
    session.clickSelector("#event-link")
    session.waitForEvent "test-event", (event) ->
      event.preventDefault()
      session.wait ->
        assert.notOk(frame.document.querySelector("#hello"))
        done()
