---
title: Object
permalink: blog/gists/javascript/object
parent: JavaScript
nav_order: 6
---

## Object

A JavaScript Object that stores key-value pairs. For frequent insertion/deletion and updating, a&nbsp;[Map&nbsp;object](./map) is preferred.

### Merge Key & Value Arrays

merge arrays of keys and values with matching indexes into an object

```js
Object.fromEntries(arrKeys.map((item,i) => [item,arrVals[i]]));
```


### Source:
[Object.entries() - JavaScript \| MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries) 
