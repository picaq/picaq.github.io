---
title: Debugging
permalink: blog/gists/css/debugging
parent: CSS
nav_order: 7
---

# Debugging

## CSS Reset Styles or Normalize

```css
* { margin: 0; padding: 0 }
```

## X-Ray Positioning with Pink Glass Effect

```css
* { background-color: #c001 !important}
```

### Toggle with bookmarklet

```js
javascript: (()=>{

let css = `
  * { background-color: #c001 !important}
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

<!-- ```css

``` -->