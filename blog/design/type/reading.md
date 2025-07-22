---
title: Typography for Reading
permalink: blog/design/type/reading
parent: Typography
nav_order: 1
---

# Fine Typography for Reading

Common fine typographic characters for optical typing.

{% include toc.html %}

original gist: [Fine typography for the web](https://gist.github.com/picaq/3b29e984db467da7c331a24e7578e739)

1. the easiest way to edit and update CSS is with the Stylus plugin to specify user styles
2. a js bookmarklet or snippet is used to inject quote classes for styling

- if no external chrome plugin is preferred, CSS can be [injected with this bookmarklet](https://gist.github.com/picaq/24a3c6d85583373f93c12dfae43e03ec#file-toggleinjectcss-js)
- chrome extension coming soon? maybe?

view the [codepen here](https://codepen.io/picaq/pen/PorGQaR)

## classes

`.hanging-quote` : content that starts with a double opening quote `“` <br>
`.single-quote` : content that starts with single opening quote `‘`

`.before-quote` : word chunk before the hanging double quote <br>
`.before-single-quote` : word chunk before the hanging single quote

## spacings
- since negative text-indent is used to hang quotes, the “before” chunk gets the same additional positive padding to the right in order to prevent collisions
- hang width proportion is _manually determined_ based on each typeface or font. The width of the double quote is measured based on the em width
- single quote is thinner than a double quote, and is approximated to be about 60% of the width of the double quote. May vary based on typeface or font

## orphans and widows
- orphans are prevented by replacing normal whitespace with `&nbsp;` at the end of each paragraph, determined by the slice depth
- slice depth should be proportional to the measure or `max-width` (more accurately, in terms of number of characters or letters) and is currently not dynamic or responsive
- currently, this method breaks all anchor tags and links in the content
- widows are generally not a problem in web typography, since multiple columns are uncommon and unpopular

## edge cases
- need to encounter more text content variations to accomodate edge cases
- unfortunately, fine typography is optically and manually adjusted, in which case the [edit content bookmarklet](https://gist.github.com/picaq/24a3c6d85583373f93c12dfae43e03ec#file-editcontent-js) comes in handy

### news typography
```css
/* ==UserStyle==
@name           news typography
@namespace      github.com/openstyles/stylus
@version        1.0.0
@description    A new userstyle
@author         PicaQ
==/UserStyle== */

@-moz-document domain("independent.co.uk"), url-prefix("https://"), domain("nytimes.com") {

    :root { 
             --open: .33em; /* Open sans*/
         --hang-nyt: .4584em; /* nyt-imperial, Indy Serif, georgia */
             --hang: var(--hang-nyt);
           --single: .593;
    }    

    .hanging-quote {
      text-indent: calc(var(--hang) * -1);
    }
    .single-quote {
      text-indent: calc(var(--hang) * var(--single) * -1);
    }

    span.hanging-quote, span.single-quote {
      display: inline-block;
    }

    .before-quote {
      padding-right: var(--hang);
    }
    .before-single-quote {
      padding-right: calc(var(--hang) * var(--single));
    }

}

@-moz-document domain("quantamagazine.org") {
    :root {
        --hang: .65em  /* Merriweather */
    }
}
```
### add quote classes
```js
javascript: (()=>{  

  const paragraphs = [...document.querySelectorAll('p')];
  // ~ 108 letters per line /3 = 36  ;  /4 = 27  ; /5 = 21
  const sliceDepth = 30;
  // removes orphans
  const noBreak = s => s.slice(0, s.length-sliceDepth) + s.slice(-sliceDepth).replace(/ /g, ' ');

  paragraphs.forEach( p => p.innerText = noBreak(p.innerText));
  paragraphs.forEach( p => p.innerText[0] === "“" ? 
                           p.className = p.className + " hanging-quote" : "");
  paragraphs.forEach( p => p.innerHTML = p.innerHTML
                            .replace(/((\w+[^\w\s]?\s)(?=“\w+))(“\w+)/g, "<span class='before-quote'>$1</span><span class='hanging-quote'>$3</span>")
                            .replace(/((\w+[^\w\s]?\s)(?=‘\w+))(‘\w+)/g, "<span class='before-single-quote'>$1</span><span class='single-quote'>$3</span>")
                    );
})();
```