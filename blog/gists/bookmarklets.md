---
title: Bookmarklets
permalink: blog/gists/javascript/bookmarklets
parent: JavaScript
nav_order: 5
---

# Bookmarklets

Most javascript I write are either in the form of bookmarklets.

Here is its structure:

```js
javascript: (()=>{
    console.log("some code here");
})();
```

Here is [how to use one](https://gist.github.com/picaq/24a3c6d85583373f93c12dfae43e03ec)

## Formatting

Compared to normal javascript, a finished bookmarklet is similar to minified js with all extraneous whitespace characters removed.

Therefore, a finished bookmarklet:
- must *not* contain comments
- all lines **must end with semi-colons**, even after a closing curly bracket `}`
- new-lines, even in constants and in template strings, are interpreted differently so the use of `\n` is preferred
- it is best to have a readable formatted bookmarklet in addition to the finished minified version
