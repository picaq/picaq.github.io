---
title: Selectors
permalink: blog/gists/css/selectors
parent: CSS
nav_order: 8
---

# Selectors

## Complex selectors

### Page content selector

you don’t need css in js or component-level css!

For Sqarespace specifically, but applicable to any other CMS or page organization style where classNames are difficult to apply, target, use or invoke, this keeps consistent styling within their content pages without bleeding the styles into other pages.

this will select all `<h3>` in a page `body` that follows the `head` that contains meta tags `<meta content="The Title Name... etc">`

```css
head:has([content^="The Title Name"]) + body h3 > .sqsrte-text-color--white > strong {
  /* style here, like colors or drop shadows */ 
}
```

this prevents `<h3>` on other pages from being inadvertently styled if they also happen to be bold and white.
