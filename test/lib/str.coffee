

@capitalize = (str)-> str[0].toUpperCase() + str.slice(1)

@spacify = (num_or_str, blockSize=3) ->
  a_int_dec = num_or_str.toString().split(".")
  a_int_dec[0] = a_int_dec[0].split("").reverse().map((e, i) ->
    (if i % blockSize is 0 and i > 0 then e + " " else e)
  ).reverse().join("")
  a_int_dec[0] + ((if a_int_dec[1] then "." + a_int_dec[1] else ""))
