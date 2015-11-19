# Export in module.exports, this, or global.jsonHtml

globalRef = window ? global
if (module? and module isnt globalRef.module)
  module.exports = module.exports or {}
  module.exports.__esModule = true # exports subvars, not whole module
  jsonHtml = module.exports
else if @ is globalRef
  @jsonHtml = jsonHtml = {}
else
  jsonHtml = @

# HELPERS

merge = (first, rest...)->
  for obj in rest
    for key,val of obj
      first[key] = val
  first

dasherize = (str)->
  str.replace /[A-Z]/g, (match,ind)->
    (if ind isnt 0 then '-' else '') + match.toLowerCase()

# COMMON ACTIONS

setAttribute = (attrName, attrVal, node)-> node.setAttribute attrName, attrVal

createElementAndIterateChildren = (key, subVal, node)->
  tag = create_html_node key
  transpile tag, subVal
  node.appendChild tag

# ACTION MAP

allActionsMap = {} #merge {}, tagsMap, eventAttrsMap, specialActionsMap

jsonHtml.addActions = (actionsMap)-> # key: action
  merge allActionsMap, actionsMap

# ACTION 'PLUGINS'

# make most common tags work also in lowercase
tagsMap = {}
for tagName in @commonTags = ['a', 'body', 'br', 'button', 'canvas', 'div', 'em', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'html', 'iframe', 'img', 'input', 'li', 'ol', 'p', 'pre', 'script', 'span', 'strong', 'table', 'td', 'textarea', 'th', 'tr', 'ul']
  tagsMap[tagName] = createElementAndIterateChildren
jsonHtml.addActions tagsMap

# bind starndard DOM events
bindEvent    = (attrName, attrVal, node)-> node.addEventListener attrName.toLowerCase()[2..], attrVal, false
eventAttrsMap = {}
for eventName in @eventAttrs = ['onKeyDown','onKeyUp','onKeyPress', 'onClick','onDoubleClick',
                                'onChange','onInput','onSubmit',  'onBlur','onFocus',
                                'onMouseEnter','onMouseLeave','onMouseMove','onMouseOut','onMouseOver',  'onMouseDown','onMouseUp',
                                'onDragEnter','onDragExit','onDragLeave','onDragOver','onDrag','onDragEnd','onDragStart','onDrop']
  eventAttrsMap[eventName] = bindEvent
jsonHtml.addActions eventAttrsMap

# raw html, textNode, transpile content to parent:
jsonHtml.addActions
  RAW:  (attrName, attrVal, node)-> node.innerHTML   = attrVal
  text: (attrName, attrVal, node)-> node.textContent = attrVal
  me:   (attrName, attrVal, node)-> transpile node, attrVal


# PARSER

create_html_node = (sKey)->
  # tag
  domElName = sKey.match(/^[^ #.]+/)
  domElName = if domElName then dasherize domElName[0] \
                           else 'div'
  el = document.createElement domElName
  # id
  if idMatch = sKey.match(/#([^ .]+)/)
    el.id = idMatch[1]
  # classes
  if classesMatch = (sKey.match /\.[^ #.]+/g)
    el.setAttribute 'class', classesMatch.map((cStr)-> cStr[1..-1]).join ' '
  el

stackDepth = 0
transpile = (node, val)->
  unless node instanceof Node
    throw Error "Illegal object in \:jsonHtml"
  return node unless val?
  if stackDepth > 100
    stackDepth = 0
    throw "jsonHtml stack depth > 100; endless loop?"
  stackDepth++
  val = val(node) if typeof val is 'function'
  if val instanceof Array
    for subVal in val
      (transpile node, subVal) #, data
  else if val instanceof Node
    node.appendChild val
  else if typeof val is 'object'
    for key, subVal of val
      if (actionMatch = key.match /^\w+/) and action = allActionsMap[actionMatch[0]]
        action key, subVal, node
      else if /^[a-z]/.test key
        attrName = dasherize key
        setAttribute attrName, subVal, node
      else
        createElementAndIterateChildren key, subVal, node
  else
    node.textContent = val
  stackDepth--
  return node

jsonHtml.createNode = (tmplObj, rootNode)->
  # start iteration with empty rootNode
  rootNode ?= document.createDocumentFragment()
  transpile rootNode, tmplObj
