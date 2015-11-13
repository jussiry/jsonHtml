# HELPERS

merge = (first, rest...)->
  for obj in rest
    for key,val of obj
      first[key] = val
  first

dasherize = (str)->
  str.replace /[A-Z]/g, (match,ind)->
    (if ind isnt 0 then '-' else '') + match.toLowerCase()

# ACTIONS

setAttribute = (attrName, attrVal, node)-> node.setAttribute attrName, attrVal
bindEvent    = (attrName, attrVal, node)-> node.addEventListener attrName.toLowerCase()[2..], attrVal, false

createElementAndIterateChildren = (key, subVal, node)->
  tag = create_html_node key
  iterate tag, subVal
  node.appendChild tag

# ACTION MAPS

tagsMap = {}
for tagName in @commonTags = ['a', 'body', 'br', 'button', 'canvas', 'div', 'em', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'html', 'iframe', 'img', 'input', 'li', 'ol', 'p', 'pre', 'script', 'span', 'strong', 'table', 'td', 'textarea', 'th', 'tr', 'ul']
  tagsMap[tagName] = createElementAndIterateChildren

eventAttrsMap = {}
for eventName in @eventAttrs = ['onKeyDown','onKeyUp','onKeyPress', 'onClick','onDoubleClick',
                                'onChange','onInput','onSubmit',  'onBlur','onFocus',
                                'onMouseEnter','onMouseLeave','onMouseMove','onMouseOut','onMouseOver',  'onMouseDown','onMouseUp',
                                'onDragEnter','onDragExit','onDragLeave','onDragOver','onDrag','onDragEnd','onDragStart','onDrop']
  eventAttrsMap[eventName] = bindEvent

specialActionsMap =
  RAW:  (attrName, attrVal, node)-> node.innerHTML   = attrVal
  text: (attrName, attrVal, node)-> node.textContent = attrVal

allActionsMap = merge {}, tagsMap, eventAttrsMap, specialActionsMap

@addSpecialActions = (actionsMap)-> # key: action
  merge allActionsMap, actionsMap


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
iterate = (node, val)->
  unless node instanceof Node
    throw Error "Illegal object in \:jsonHtml"
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

@parse = (tmplObj, rootNode)->
  # start iteration with empty rootNode
  rootNode ?= document.createDocumentFragment()
  iterate rootNode, tmplObj
