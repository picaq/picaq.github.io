---
title: CSSBattle
permalink: blog/gists/css/cssbattle
parent: CSS
nav_order: 3
---

# CSSBattle

I started to play [CSSBattle](https://cssbattle.dev/)

{% include toc.html %}

## [Target  (24/12/2025)](https://cssbattle.dev/play/H9JrvODFbvSNLt55U6CA) 
<div class="code-example">

<div></div>
<div></div>
<div></div>
<div></div>
<div></div>
</div>
<style>
  .code-example { padding: 0; min-height: 300px; width: 400px; max-width: 100%}
  @media only screen and (min-width: 1080px) { 
    .code-example { float: right; transition: transform .12s ease-in-out; }  [class*="highlighter"] { max-width: 350px;} 
    .code-example { transform: translate(1rem) 
    }
  }
  #target--24122025 + .code-example div {
    width: 170px;
    height: 40px;
    background: #0098D1;
  }
  #target--24122025 + .code-example div:nth-of-type(3n +1) {margin-bottom: 10px}
  #target--24122025 + .code-example div:nth-of-type(even) {width: 80px;height: 25px;}
  #target--24122025 + .code-example div:nth-of-type(3) {width: 220px;height: 150px;
  }
  #target--24122025 + .code-example {
    background: #302562; 
    margin: 0 !important;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    padding-top: 0
  }
</style>


```html
<div></div>
<div></div>
<div></div>
<div></div>
<div></div>
<style>
  div {
    width: 170px;
    height: 40px;
    background: #0098D1;
  }
  div:nth-of-type(3n +1) {margin-bottom: 10px}
  div:nth-of-type(even) {width: 80px;height: 25px;}
  div:nth-of-type(3) {width: 220px;height: 150px;
  }
  body {
    background: #302562; 
    margin: 0 !important;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center
  }
</style>
```

## [Target  (23/12/2025)](https://cssbattle.dev/play/CWggCCsKLlttsJS55Fl6) 

<div class="code-example">
<div></div>
<div><div></div><div></div><div></div></div>
<div></div>
</div>
<style>
  #target--23122025 + .code-example div {
    width: 80px;
    height: 80px;
    background: #dd6b4d;
  }
  #target--23122025 + .code-example > div {
    border-radius: 100%
  }

  #target--23122025 + .code-example, .code-example div:has(div)  {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    margin: 0;
    background: #DACFA3;
  }

  #target--23122025 + .code-example div:has(div) {
    flex-direction: column;
    height: calc(100% + 30px);
    background: transparent;
    gap: 10px;
  }

  #target--23122025 + .code-example div > div {
    background: #2D3464;
    height: 100px;
  } 
</style>


```html
<div></div>
  <div><div></div><div></div><div></div></div>
<div></div>
<style>
  div {
    width: 80px;
    height: 80px;
    background: #D95362;
  }
  body > div {border-radius: 100%}

  body, div:has(div)  {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    margin: 0;
    background: #DACFA3;
  }

  div:has(div) {
    flex-direction: column;
    height: calc(100% + 30px);
    background: transparent;
    gap: 10px;
  }

  div > div {
    background: #2D3464;
    height: 100px
  } 
</style>
```

## [Target  (25/12/2025)](https://cssbattle.dev/play/MjOjFgW5rP2qbY8aQxbm) 

<div class="code-example">
<div></div><div></div><div></div><div></div><div></div>
</div>

<style>
  #target--25122025 + .code-example div {
    width: 20px;
    height: 20px;
    background: #0F6B38;
  }
  
  #target--25122025 + .code-example div + div {
    width: 50px
  }
  #target--25122025 + .code-example div + div + div {
    width: 80px
  }
  #target--25122025 + .code-example div + div + div + div {
    width: 110px
  }
  #target--25122025 + .code-example div + div + div + div + div {
    width: 140px
  }

  #target--25122025 + .code-example div:first-child {
    background: #FFCA00
  }
  #target--25122025 + .code-example div:nth-child(2n) {
    background: #1BBC63
  }

  #target--25122025 + .code-example {
    background: #11092D;
    display: flex;
    flex-direction: column;
    align-items: center;
    height: calc(100% - 15px);
    justify-content: center;
    gap: 20px;
  }
</style>

```html
<div></div><div></div><div></div><div></div><div></div>
<style>
  div {
    width: 20px;
    height: 20px;
    background: #0F6B38;
  }
  
  div + div {
    width: 50px
  }
  div + div + div {
    width: 80px
  }
  div + div + div + div {
    width: 110px
  }
  div + div + div + div + div {
    width: 140px
  }

  div:first-child {
    background: #FFCA00
  }
  div:nth-child(2n) {
    background: #1BBC63
  }

  body {
    background: #11092D;
    display: flex;
    flex-direction: column;
    align-items: center;
    height: calc(100% - 15px);
    justify-content: center;
    gap: 20px;
  }
</style>
```

## [Target  (26/12/2025)](https://cssbattle.dev/play/xUfql84OBialk8b35bUv) 

<div class="code-example">
<article>
  <section>
    <div></div>
    <div></div>
  </section>
  <section>
    <div></div>
    <div></div>
  </section>
</article>
</div>
<style>
  #target--26122025 + .code-example div {
    width: 60px;
    height: 60px;
    background: #EEC8EA;
    display: inline-block;
    margin: 8px;
    transform: rotate(-10deg);
  }
  #target--26122025 + .code-example section:first-child > div:last-child,
  #target--26122025 + .code-example section:last-child > div:first-child
  {
    transform: rotate(10deg)
  }
  
  #target--26122025 + .code-example {
    background: #A82973;
    align-items: center;
    display: flex;
  }
  #target--26122025 + .code-example article {
    margin: auto;
    transform:translate(-.1px, 1.95px)
  }
</style>

```html
<article>
  <section>
    <div></div>
    <div></div>
  </section>
  <section>
    <div></div>
    <div></div>
  </section>
</article>

<style>
 div {
    width: 60px;
    height: 60px;
    background: #EEC8EA;
    display: inline-block;
    margin: 8px;
    transform: rotate(-10deg);
  }
  section:first-child > div:last-child,
  section:last-child > div:first-child
  {
    transform: rotate(10deg)
  }
  
  body {
    background: #A82973;
    align-items: center;
    display: flex;
  }
  article {
    margin: auto;
    transform:translate(-.1px, 1.95px)
  }
</style>
```

<!-- 
## [Target  (27/12/2025)](https://cssbattle.dev/play/) 

<div class="code-example">  

</div>

<style>
  #target--27122025 + .code-example {
    
  }
</style>

```html

``` -->

