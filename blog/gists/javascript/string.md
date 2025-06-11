---
title: String
permalink: blog/gists/javascript/string
parent: JavaScript
nav_order: 9
---

## String

### Count Occurrences of Chars or Substring Occurances in a String

String manipulation, counting and accounting

```js
const count = (str, subst)  => str.match( new RegExp(subst, "g") )?.length || 0;
```

