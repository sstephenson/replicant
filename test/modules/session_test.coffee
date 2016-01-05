QUnit.module "Replicant.Session"

@frameTest "navigating with a session", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation("/fixtures/default.html").then (navigation) ->
    assert.equal(navigation.location.pathname, "/fixtures/default.html")
    assert.equal(navigation.action, "load")
    done()

@frameTest "concurrent navigation fails", (frame, assert, done) ->
  session = frame.createSession()
  failed = false
  session.goToLocation("/fixtures/default.html").then ->
    assert.ok(failed)
    done()
  session.goToLocation("about:blank").catch ->
    failed = true

@frameTest "clicking a link", (frame, assert, done) ->
  session = frame.createSession()
  session.goToLocation("/fixtures/default.html").then ->
    session.clickSelector("#pushstate-link").then (navigation) ->
      assert.equal(navigation.location.pathname, "/fixtures/push.html")
      assert.equal(navigation.action, "push")
      done()
