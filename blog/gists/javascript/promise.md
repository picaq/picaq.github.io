---
title: Promise
permalink: blog/gists/javascript/promise
parent: JavaScript
nav_order: 10
---

## Promise

### Try Catch & Error

Try catch and await async in a network API request

```js
const getCityValues = async () => {
  try {
    const response = await fetch(
      `https://data.epa.gov/efservice/getEnvirofactsUVHourly/CITY/Seattle/STATE/WA/JSON`
    );
    const jsonData = await response.json();
    console.log(jsonData);  
  } catch (error) {
    console.error(error.message);
    console.error(userCity, 'is not found!');
  }
}
```

### Wait Before Execution

Use between batch downloads or wait before next browser action like clicks/scrolls or in between loops

usage: only works on async or top level functions
```js
const wait = ms => new Promise(response => setTimeout(response, ms));

await wait(5000); console.log('waited 5 seconds');
```

one-liner with less memory and time
```js
await new Promise(res => setTimeout(res, ms));
```

async not needed
```js
setTimeout(() => {
  console.log('waited 3 seconds');
}, 3000);
```

#### Batch download all resource links in page

a delay between clicks is needed to prevent rate limiting and browser download limits

```js
const links = [...document.querySelectorAll('a.className')]; // adjust query/class
const len = links.length;
const timing = 123;
const delay = ms => new Promise(response => setTimeout(response, ms));

(async () => {
  for (let i = 0; i < len; i++) {
    const a = links[i];
    const url = a.href;
    const filename = decodeURI(a.href.split('/').pop());
    a.download = filename;
    console.log(i + 1, '/', len , filename);
    a.click();
    await delay(timing); // adjust timing
  }
})();

```