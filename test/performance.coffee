
{ performanceTester } = require './lib/performanceTester.coffee!'

ck = require './lib/coffeekup.coffee!'

jsonHtml = require '../src/jsonHtml.coffee!'
#jsonHtmlAlt = require '../src/jsonHtmlAlt.coffee!'

vars =
  href: "http://jussir.net/#/edit/jsonHtmlTest"
  someStr: "foo bar baz"

htmlStr = (vars)-> """
  <div id="foo">
    <button class="bar">
      <a href="#{vars.href}">self reference</a>
    </button>
    <div>#{vars.someStr}</div>
    <ul>#{
      [1,2].map((i)->
        "<li>#{i}</li>"
      ).join('');
    }</ul>
  </div>
"""

document.querySelector('#innerHtml').textContent = htmlStr(vars);

htmlObj = (vars)->
  'div#foo':
    'button.bar':
      a:
        href: vars.href
        text: 'self reference'
    div: vars.someStr
    ul:
      for i in [1,2]
        li: i


coffeekupFunc = ->
  div '#foo', ->
    button '.bar', ->
      a
        href: @vars
        'self reference'
    div @someStr
    ul ->
      for i in [1,2]
        li(i)


# TODO: add jquery tempalte, mithril? etc


prepareTest = -> document.createElement 'div'

ckTemplate = ck.compile coffeekupFunc


#document.querySelector('#test-coffeekup').innerHTML = ckTemplate(vars);


setTimeout ->
  results = performanceTester 3000,
    (-> prepareTest().innerHTML = htmlStr(vars))
    (-> jsonHtml.parse htmlObj(vars), prepareTest())
    #(-> jsonHtmlAlt.parse htmlObj, prepareTest())
    (-> prepareTest().innerHTML = ckTemplate(vars))
    #(-> prepareTest().innerHTML = ck.render coffeekupFunc)

  document.querySelector('#test-container').textContent = results
  console.log 'done!'
, 200
