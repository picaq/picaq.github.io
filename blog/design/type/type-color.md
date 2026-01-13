---
title: Typographic Color
permalink: blog/design/type/color
parent: Typography
nav_order: 3
---

# Typographic Color

<!-- {% include toc.html %} -->

Debugging CSS to visually check for consistent [typographic color](https://design.tutsplus.com/articles/typographic-readability-and-legibility--webdesign-12211#toc-g8li-typographic-color)

```css
html, body {
  filter: blur(.3rem)
}
```

Toggle it on/off with this bookmarklet script

```js
javascript: (()=>{

let css = `
html, body {
  filter: blur(.3rem)
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

Source:
[Typographic Readability and Legibility \| Envato Tuts+](https://design.tutsplus.com/articles/typographic-readability-and-legibility--webdesign-12211#toc-g8li-typographic-color) 
