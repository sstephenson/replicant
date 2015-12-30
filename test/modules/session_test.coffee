QUnit.module "Replicant.Session"

@frameTest "navigating with a session", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation("/fixtures/default.html").then (action) ->
    assert.equal(frame.location.pathname, "/fixtures/default.html")
    assert.equal(action, "load")
    done()

@frameTest "concurrent navigation fails", (frame, assert, done) ->
  session = frame.createSession()
  failed = false
  session.goToLocation("/fixtures/default.html").then (action) ->
    assert.ok(failed)
    done()
  session.goToLocation("about:blank").catch (error) ->
    failed = true

@frameTest "clicking a link", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation("/fixtures/default.html").then (action) ->
    session.clickSelector("#pushstate-link").then (action) ->
      assert.equal(frame.location.pathname, "/fixtures/push.html")
      assert.equal(action, "push")
      done()
