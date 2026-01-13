---
title: Squint Test
permalink: blog/design/squint
parent: Design
nav_order: 3
---

# Squint Test

<!-- {% include toc.html %} -->

Debugging CSS to visually check for consistent [typographic color](https://design.tutsplus.com/articles/typographic-readability-and-legibility--webdesign-12211#toc-g8li-typographic-color).

As well as to check for the visual heirarchy of all visible elements.

This mimics the Squint Test view to determine type color consistency without causing excessive eye strain.

```css
html {
  filter: blur(.36rem);
  transition: filter .09s ease-out;
}
```

Toggle it on/off with this bookmarklet script

```js
javascript: (()=>{

let css = `
html {
  filter: blur(.36rem);
  transition: filter .09s ease-out;
}
`;

const injectCSS = css => {
  let el = document.createElement('style');
  el.type = 'text/css';
  el.id='css_injection';
  el.innerText = css;
  document.head.appendChild(el);
};

const swap = () => !document.getElementById('css_injection') ? injectCSS(css) : document.getElementById('css_injection').remove();
const replace = (newCss=css) => {
  css = newCss;
  !document.getElementById('css_injection') ? injectCSS(css) : document.getElementById('css_injection').innerText = css;
};

swap();

})();
```

Sources:
[Typographic Readability and Legibility \| Envato Tuts+](https://design.tutsplus.com/articles/typographic-readability-and-legibility--webdesign-12211#toc-g8li-typographic-color) 
[The Squint Test: Accessibility Test for Every Interface \| NUMI Blog](https://www.numi.tech/post/the-squint-test-accessibility-test-for-every-interface) 
