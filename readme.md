**jsonHtml** is for those who favor general purpose languages over domain specific languages, and JSON over XML.

It allows you to write HTML directly from JavaScript (or languages that compile to JS), with all the power of
general purpose language at your hands.


## Syntax

Most of the examples here are written on CoffeScript, since, well, it has prettier JSON syntax.

**jQuery/querySelector syntax for creating id's and class'es**

    'p #someId .classA .classB': "Some paragraph here"
                        ↓
    <p id="someId" class="classA classB">Some paragraph here</p>

**Automatic attribute detection**

    a:
      href: "http://jussir.net/#/edit/jsonHtmlExample"
      target: '_blank'
      span: 'Click me!'
                        ↓
    <a href="http://jussir.net/#/edit/jsonHtmlExample" target="_blank">
      <span>Click me!</span>
    </a>

**Standard DOM event binding**<br/>
Note that events don't appear in HTML syntax, since they are bound usen *addEventListener*.

    button:
      onClick: -> alert "button clicked!"
      text: 'Me button, me alert'
                        ↓
    <button>Me button, me alert</button>
    
**Utilize the full power of general purpose language**

    ul:
      for key, val of { a: 'foo', b: 'bar', c: 'baz' }
        "li .#{key}": val
                        ↓
    <ul>
      <li class="a">foo</li>
      <li class="b">bar</li>
      <li class="c">baz</li>
    </ul>

**JavaScript example (ES6)**

    {
      ul: ['item1','item2','item3'].map( el => { li: el} )
    }
                        ↓
    <ul>
      <li>item1</li>
      <li>item2</li>
      <li>item3</li>
    </ul>
    
For more examples, go play with the syntax here: http://jussir.net/#/edit/jsonHtmlExample


## See also

**jsonStyles**

For full power, use similar syntax to create styles. Githup repo to be added.
For now you can play with it [here](http://jussir.net/#/edit/jsonHtmlStyleExample).
And source can be found [here](http://jussir.net/#/edit/coffee_styles).

**jsonReact**

Same syntax to create React's virtual DOM. Github repository not yet done, source
can be browsed [here](http://jussir.net/#/edit/react_from_obj).


## Alternative libraries

**Basic DOM**

- [CoffeeKup](http://coffeekup.org/)
- ...

**Virtual DOM / React**

- [react-no-jsx](https://github.com/jussi-kalliokoski/react-no-jsx)
- ...
