jsonHtml is for those who favor general purpose languages over domain specific languages, and JSON over XML.

It allows you to write HTML directly from JavaScript (or languages that compile to JS), with all the power of
general purpose language at your hands.


## Syntax

Most of the examples here are written on CoffeScript, since, well, it has prettier JSON syntax.

**querySelector syntax for creating id's and class'es**

    'p #someId .classA .classB': "Some paragraph here"
                        ↓
    <p id="someId" class="classA classB">Some paragraph here</p>

**automatic attribute detection**

    a:
      href: "http://jussir.net/#/edit/jsonHtmlExample"
      target: '_blank'
      text: 'Click me!'
                        ↓
    <a href="http://jussir.net/#/edit/jsonHtmlExample" target="_blank">Click me!</a>

**standard DOM event binding**

    button:
      onClick: -> alert "button clicked!"
      text: 'Me button, me alert'
    
**utilize the full power of general purpose language**

    ul:
      for key, val of { a: 'foo', b: 'bar', c: 'baz' }
        "li .#{key}": val

**JavaScript example (ES6)**

    {
      ul: ['item1','item2','item3'].map( el => { li: el} )
    }

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

**Virtual DOM / React**

- [react-no-jsx](https://github.com/jussi-kalliokoski/react-no-jsx)
