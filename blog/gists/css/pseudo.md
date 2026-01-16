---
title: Pseudo
permalink: blog/gists/css/pseudo
parent: CSS
nav_order: 6
---

# Pseudo

## Pseudo Elements ::before ::after

`display: block`
<div class="code-example">  
  <div class="block">div</div>
</div>

`display: inline (default)`
<div class="code-example">  
  <div>div</div>
</div>

<style>
  :root  {
        --sage: #abb8a8;
    --lavender: #9e9ed3;
  }
  .code-example > div {
    background: pink;
  }
  .code-example ::before, .code-example ::after, .code-example div {
    padding: .75rem;
    color: #27262b;
  }
  .code-example .block::before, .code-example .block::after {
    display: block;
  }
  .code-example div::before {
    content: "before";
    background: var(--lavender); 
  }
  .code-example div::after {
    content: "after";
    background: var(--sage);    
    rotate: -3deg;
    translate: 0 -1.1rem;
  }

</style>

```html
<div>

<style>
  div {
    background: pink;
  }
  div, ::before, ::after {
    padding: .75rem;
  }
  .block::before .block::after {
    display: block;
  }
  div::before {
    content: "before";  
    background: var(--lavender);  
  }
  div::after {
    content: "after";
    background: var(--sage);   
    rotate: -3deg;
    translate: 0 -1.1rem;
  }
</style>
```

### document order

```html
<div>
  ::before
  "div"
  ::after
</div> 
```

### equivalent element rendering
```xml
<div>
  div
  <before>before</before>
  <after>after</after>
</div> 
```

### stacking order
```py
# z-index
 after: 2
before: 1
   div: 0 
```