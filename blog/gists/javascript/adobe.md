---
title: Adobe Javascript
permalink: blog/gists/javascript/adobe
parent: JavaScript
nav_order: 7
---

# Adobe Javascript

Files can be automated within Adobe software with scripts.

Currently, I am using Adobe Acrobat Pro v.11, which supports really old js 

## Adobe Acrobat

### How to run Javascript
1. create or select an element.
2. Add/Edit js. 
3. paste desired js into it, press OK.
4. switch to selection mode and click the element to execute.

### Javascript support:
- no `let`, use `var`
- no `console.log`
- no template literals, concatenate strings with `+`
- pages are 0-indexed in js, but 1-index everywhere else

I recommend writing modern JS and using a transpiler (like Babel) to convert to ES5 and below.

### Automatically create bookmark TOC

original js
```js
// Get the root of the bookmark tree
var myRoot = this.bookmarkRoot;

for (let i = 0; i <= 42; i++) {
  console.log(i, 4 + 2*i );
  // Create a new bookmark under the root
  myRoot.createChild(`Lesson ${i}`, `this.pageNum = ${4 + 2*i};`); 
  // Create a child bookmark under the first bookmark
  var firstBookmark = myRoot.children[i];
  firstBookmark.createChild("Particle", `this.pageNum = ${4 + 2*i};`);
  firstBookmark.createChild("Particle", `this.pageNum = ${4 + 2*i};`);
  firstBookmark.createChild("Particle", `this.pageNum = ${4 + 2*i};`);
}
```
supported js
```js
// Get the root of the bookmark tree
var myRoot = this.bookmarkRoot;
var firstBookmark
// for (var i = 0; i <= 42; i++) {
for (var i = 42; i >= 0; i--) {
  // Create a new bookmark under the root
  var val = 3 + 2 * i;
  myRoot.createChild("Lesson " + i, "this.pageNum = " + val + ";");
  
  // Create a child bookmark under the first bookmark
  firstBookmark = myRoot.children[0];
  firstBookmark.createChild("Particle", "this.pageNum = " + val + ";");
  firstBookmark.createChild("Particle", "this.pageNum = " + val + ";");
  firstBookmark.createChild("Particle", "this.pageNum = " + val + ";");
}

```
