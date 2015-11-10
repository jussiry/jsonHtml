# source: http://jussir.net/#/edit/speedTest

# compare how long two or more functions take
# to execute.

# pass funcitons as arguments, with two options
# number: how long (ms) to compare functions

argumentTypes = require './argumentTypes.coffee!'
{ capitalize, spacify } = require './str.coffee!'

precision_n2s = (n) ->
  #(n - 1) * 100 + '%'
  (if n < 1 then n.toFixed(2) else (if n < 10 then n.toFixed(1) else n.toFixed(0)))

performanceTester = (args...)->
  {methods, normalize, test_time_ms, test_this, return_type} = argumentTypes arguments,
    function: 'methods'
    boolean: 'normalize'
    number: 'test_time_ms'
    object: 'test_this'
    string: 'return_type'

  if normalize
    methods.push(->)

  max = min = null
  times_a = methods.map -> 0

  places_IsI = ["first", "second", "third", "fourth", "fifth"]
  new_repeats_n = 0
  all_repeats_n = 0
  f_now = (if performance then performance.now.bind(performance) else Date.now)
  test_round = 0
  # CALCULATE TIME
  while Math.max.apply(null, times_a) < test_time_ms
    new_repeats_n = Math.pow(2, test_round)
    min = Math.min.apply(null, times_a)
    funcInd = 0
    while funcInd < methods.length
      test_function = methods[funcInd]
      i = 0
      start_ms = f_now()
      while i < new_repeats_n
        test_function.call test_this
        i++
      res = f_now() - start_ms
      if min
        times_a[funcInd] += res
      else
        times_a[funcInd] = res
      funcInd++
    all_repeats_n += new_repeats_n  if min
    test_round++
  if normalize # umm, is this working?
    normalize_ms = times_a.pop()
    methods = methods.slice(0, -1)
    times_a = times_a.map((ms) ->
      Math.max 0, ms - normalize_ms
    )
  min = Math.min.apply(null, times_a)
  max = Math.max.apply(null, times_a)
  result_strings = []
  if methods.length > 1
    minInd = times_a.indexOf(min)
    maxInd = times_a.indexOf(max)
    preStr = capitalize methods[minInd].name or places_IsI[minInd]
    console.log str = preStr + " is " + precision_n2s(max / min) + " times faster than " + (methods[maxInd].name or places_IsI[maxInd]) + "."
    result_strings.push str
  methods.forEach (test_function, ind) ->
    time_ms = times_a[ind] / all_repeats_n
    time_ns = time_ms * 1e6
    s_time = (if time_ms > 1 \
              then time_ms.toFixed(2) + " ms"
              else spacify(precision_n2s(time_ns)) + " ns")
    console.log str = (n = test_function.name or places_IsI[ind]) +
                      ": " + " ".repeat(16 - n.length - s_time.length) + s_time
    result_strings.push str

  console.log str = spacify(all_repeats_n) + " repeats"
  result_strings.push str
  fullStr = result_strings.join('\n')

  # switch return_type # TODO
  #   when 'log'
  #     :debug.first fullStr
  #   else
  fullStr

module.exports =
  performanceTester: performanceTester
