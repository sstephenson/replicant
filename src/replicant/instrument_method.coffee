Replicant.instrumentMethod = (object, methodName, afterCallback) ->
  fn = object[methodName]
  object[methodName] = ->
    result = fn.apply(this, arguments)
    afterCallback()
    result
