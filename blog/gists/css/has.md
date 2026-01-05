---
title: :has()
permalink: blog/gists/css/has
parent: CSS
nav_order: 2
---

# :has()

## Parent Selector

```css
div.parent:has(#unique-descendent) {
  background: pink;
}
```

## Sibling Selector

hover over element to select all siblings *after* itself in the document flow

```css
.parent li:nth-child(5n):hover, .parent li:nth-child(5n):hover ~ li:nth-child(5n) 
```

## Previous Sibling Selector

hover over element to select all previous siblings *before* itself
```css
.parent li:nth-child(5n):hover, .parent li:nth-child(5n):has(~ li:nth-child(5n):hover)
```

## Examples

[Ceiling light button](https://codepen.io/picaq/pen/RwmQOwZ) 

hover over element to select parent and siblings

### Sarasa Gothic Mono: Human Language Support

commit: [add previous sibling selector support with  css :has() · picaq/picaq.github.io@be1657d](https://github.com/picaq/picaq.github.io/commit/be1657db35e208146f0647dc6c8bb5f3afcba744) 

demo: [picaq.github.io/sarasa/#human-language-support](/sarasa/#human-language-support)

<!-- ```css

``` -->