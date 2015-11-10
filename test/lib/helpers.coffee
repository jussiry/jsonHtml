

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

module.exports =
  objectFromArray: objectFromArray
  extend: extend
