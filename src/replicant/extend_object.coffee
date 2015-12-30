Replicant.extendObject = (object, properties) ->
  for key, value of properties
    object[key] = value
  object
