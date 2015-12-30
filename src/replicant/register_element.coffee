#= require replicant/extend_object

Replicant.registerElement = (tagName, definition = {}) ->
  tagName = tagName.toLowerCase()
  properties = Replicant.extendObject({}, definition)

  defaultCSS = properties.defaultCSS ? "%t { display: block }"
  delete properties.defaultCSS
  installDefaultCSSForTagName(defaultCSS, tagName)

  extendedPrototype = Object.getPrototypeOf(document.createElement("div"))
  extendedPrototype.__super__ = extendedPrototype

  prototype = Object.create(extendedPrototype, properties)
  constructor = document.registerElement(tagName, prototype: prototype)
  Object.defineProperty(prototype, "constructor", value: constructor)
  constructor

installDefaultCSSForTagName = (defaultCSS, tagName) ->
  styleElement = insertStyleElementForTagName(tagName)
  styleElement.textContent = defaultCSS.replace(/%t/g, tagName)

insertStyleElementForTagName = (tagName) ->
  element = document.createElement("style")
  element.setAttribute("type", "text/css")
  element.setAttribute("data-tag-name", tagName.toLowerCase())
  document.head.insertBefore(element, document.head.firstChild)
  element
