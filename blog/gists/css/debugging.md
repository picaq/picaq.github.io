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

[pink glass](javascript:void%20function(){let%20a=`
%20%20*%20{ background-color:%20%23c001%20!important}
`;const%20b=a=%3E{let%20b=document.createElement(%22style%22);b.type=%22text/css%22,b.id=%22css_injection%22,b.innerText=a,document.head.appendChild(b)},c=()=%3Edocument.getElementById(%22css_injection%22)%3Fdocument.getElementById(%22css_injection%22).remove():b(a);c()}();)

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

## Related

[Squint Test](../../design/squint)