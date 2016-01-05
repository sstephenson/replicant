class Replicant.Location
  constructor: (href) ->
    element = document.createElement("a")
    element.href = href?.toString()

    {@href, @protocol, @host, @hostname,
     @port, @pathname, @search, @hash,
     @username, @password} = element

  valueOf: ->
    @href

  toString: ->
    @href
