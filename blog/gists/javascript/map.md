---
title: Map
permalink: blog/gists/javascript/map
parent: JavaScript
nav_order: 7
---

## Map Object

A JavaScript-specific data structure similar to an [Object](./object) but remembers insertion order and is iterable.
It&nbsp;also&nbsp;has far better performance when inserting and deleting keys-value pairs.

More info: [Map - JavaScript \| MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 

### Increment & Decrement

```js
let mapObj = new Map();

const incrementMapVal = (map, key) => {
  const currentValue = map.has(key) ? map.get(key) : 0;
  map.set(key, currentValue + 1);
}

const decrementMapVal = (map, key) => {
  const currentValue = map.has(key) && map.get(key);
  currentValue > 1 ? map.set(key, currentValue - 1) : map.delete(key);
}
```
