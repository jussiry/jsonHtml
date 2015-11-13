
{ performanceTester } = require './lib/performanceTester.coffee!'

ck = require './lib/coffeekup.coffee!'

jsonHtml = require '../src/jsonHtml.coffee!'
#jsonHtmlAlt = require '../src/jsonHtmlAlt.coffee!'

htmlStr = """
  <div id="foo">
    <button class="bar">
      <a href="http://jussir.net/#/edit/jsonHtmlTest">self reference</a>
    </button>
    <div>foo bar baz</div>
    <ul>
      <li>1</li>
      <li>2</li>
    </ul>
  </div>
"""

htmlObj = ->
  'div#foo':
    'button.bar':
      a:
        href:"http://jussir.net/#/edit/jsonHtmlTest"
        text: 'self reference'
    div: "foo bar baz"
    ul:
      for i in [1,2]
        li: i


coffeekupFunc = ->
  div '#foo', ->
    button '.bar', ->
      a
        href:"http://jussir.net/#/edit/jsonHtmlTest",
        'self reference'
    div "foo bar baz"
    ul ->
      for i in [1,2]
        li(i)


prepareTest = -> document.createElement 'div'

ckTemplate = ck.compile coffeekupFunc

#document.querySelector('#test-coffeekup').innerHTML = ckTemplate();

setTimeout ->
  results = performanceTester 3000,
    (-> prepareTest().innerHTML = htmlStr)
    (-> jsonHtml.parse htmlObj, prepareTest())
    #(-> jsonHtmlAlt.parse htmlObj, prepareTest())
    (-> prepareTest().innerHTML = ckTemplate())
    #(-> prepareTest().innerHTML = ck.render coffeekupFunc)

  document.querySelector('#test-container').textContent = results
  console.log 'done!'
, 200
