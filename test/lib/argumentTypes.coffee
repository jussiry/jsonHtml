# source: http://jussir.net/#/edit/argumentTypes

# Transform arguments array to an object based on argument types,
# allowing varying argument order.

# You can use default name mapping, or give custom mapping.

# When there are multiple arguments with same type, they are grouped
# in an array (e.g. 'str' example). NOTE: don't use multiple array arguments!

_typeof = (arg)->
  return 'array' if arg instanceof Array
  return 'null'  if arg is null
  typeof arg


defaultMapping =
  string:  'str'
  number:  'num'
  object:  'obj'
  array:   'arr'
  boolean: 'boo'
  function: 'fun'
  undefined: 'nil'
  null:      'nil'

module.exports = (args, typeMapping=defaultMapping)->
  argTypes = {}
  for arg in args
    typeName = typeMapping[_typeof arg]
    if current = argTypes[typeName]
      if Array.isArray(current)
      then current.push arg
      else argTypes[typeName] = [argTypes[typeName], arg]
    else
      argTypes[typeName] = arg
  argTypes
