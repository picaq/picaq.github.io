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
  .code-example { padding: 0}
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