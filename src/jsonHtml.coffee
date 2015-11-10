
# HELPERS

identity = (el)-> el
objectFromArray = (array, valFromEl, keyFromEl)->
  valFromEl ?= identity
  keyFromEl ?= identity
  obj = {}
  for el, ind in array
    obj[keyFromEl el, ind] = valFromEl el, ind
  obj

extend = (objA, objB)->
  for key,val of objB
    objA[key] = val
  objA

# ATTRIBUTES

eventAttrs   = ['onKeyDown','onKeyUp','onKeyPress',  'onClick','onDoubleClick',  'onBlur','onFocus',  'onMouseEnter','onMouseLeave','onMouseMove','onMouseOut','onMouseOver',  'onMouseDown','onMouseUp',  'onChange','onInput','onSubmit',  'onDragEnter','onDragExit','onDragLeave','onDragOver','onDrag','onDragEnd','onDragStart','onDrop']
defaultAttrs = ["accept", "action", "alt", "async", "checked", "class", "cols", "content", "controls", "coords", "data", "defer", "dir", "disabled", "download", "draggable", "form", "height", "hidden", "href", "icon", "id", "lang", "list", "loop", "manifest", "max", "media", "method", "min", "multiple", "muted", "name", "open", "pattern", "placeholder", "poster", "preload", "rel", "required", "role", "rows", "sandbox", "scope", "scrolling", "seamless", "selected", "shape", "size", "sizes", "src", "start", "step", "style", "target", "title", "type", "value", "width", "wmode"] # "span", "label",

eventAction   = (attrName, attrVal, node)-> node.addEventListener attrName.toLowerCase()[2..], attrVal, false
defaultAction = (attrName, attrVal, node)-> node.setAttribute attrName, attrVal

defaultAttrsMap = objectFromArray defaultAttrs, -> defaultAction  #(attrName)-> eventAction.bind null, attrName
eventAttrsMap   = objectFromArray eventAttrs,   -> eventAction
specialAttrsMap =
  RAW:  (attrName, attrVal, node)-> node.innerHTML   = attrVal
  text: (attrName, attrVal, node)-> node.textContent = attrVal

allAttrActions = extend defaultAttrsMap, eventAttrsMap
extend allAttrActions, specialAttrsMap

# PARSER

create_html_node = (sKey)->
  # tag
  domElName = sKey.match(/^[^ #._]+/)?[0] or 'div' # 0123456789
  el = document.createElement domElName
  # id
  if idMatch = sKey.match(/#[^ ]+/)
    el.id = idMatch[0][1..-1]
  # classes
  if classesMatch = (sKey.match /\.[^ #.]+/g)
    el.setAttribute 'class', classesMatch.map((cStr)-> cStr[1..-1]).join ' '
  el


addToNode = (node, child)-> # node: anything that can be materialized in UI.js
  return if child is null
  if child instanceof Node #typeof node is 'string'
  then node.appendChild child
  else node.textContent = child

assertRealNode = (node)->
  unless node.setAttribute?
    throw new Error "Can't set attributes ('#{key}') for root list (#{key})"

createElementAndIterateChildren = (node,key,subVal)->
  tag = create_html_node key
  iterate tag, subVal
  addToNode node, tag

stackDepth = 0
iterate = (node, val)->
  return node unless val?
  if stackDepth > 100
    stackDepth = 0
    throw "jsonHtml stack depth > 100; endless loop?"
  stackDepth++
  val = val() if typeof val is 'function'
  if val instanceof Array
    for subVal in val
      (iterate node, subVal) #, data
  else if val instanceof Node
    addToNode node, val
  else if typeof val is 'object'
    for key, subVal of val # key is val when 1 argument
      if allAttrActions[key]
        assertRealNode node
        allAttrActions[key] key, subVal, node
      else if /^\w*[A-Z]/.test(key)
        assertRealNode node
        attrName = key.replace /[A-Z]/g, (match,ind)->
          (if ind isnt 0 then '-' else '') + match.toLowerCase()
        defaultAction attrName, subVal, node
      else
        createElementAndIterateChildren node, key, subVal
  else
    addToNode node, val
  stackDepth--
  return node

parse = (tmplObj, rootNode)->
  # start iteration with empty rootNode
  rootNode ?= document.createDocumentFragment()
  iterate rootNode, tmplObj

module.exports =
  parse: parse
