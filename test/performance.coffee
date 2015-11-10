
{ performanceTester } = require './lib/performanceTester.coffee!'

ck = require './lib/coffeekup.coffee!'
{ parse } = require '../src/jsonHtml.coffee!'

htmlStr = """
  <div id="foo">
    <button class="bar">
      <a href="http://jussir.net/#/edit/jsonHtmlTest">self reference</a>
    </button>
    <div>foo bar baz</div>
  </div>
"""

htmlObj = ->
  'div#foo':
    'button.bar':
      a:
        href:"http://jussir.net/#/edit/jsonHtmlTest"
        text: 'self reference'
    div: "foo bar baz"

coffeekupFunc = ->
  div '#foo', ->
    button '.bar', ->
      a
        href:"http://jussir.net/#/edit/jsonHtmlTest",
        'self reference'
    div "foo bar baz"


prepareTest = -> document.createElement 'div'

ckTemplate = ck.compile coffeekupFunc

#document.querySelector('#test-coffeekup').innerHTML = ckTemplate();

results = performanceTester 3000,
  (-> prepareTest().innerHTML = htmlStr)
  (-> parse htmlObj, prepareTest())
  (-> prepareTest().innerHTML = ckTemplate())
  #(-> prepareTest().innerHTML = ck.render coffeekupFunc)

document.querySelector('#test-container').textContent = results

console.log 'done!'
