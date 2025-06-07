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

```js
const wait = ms => new Promise(response => setTimeout(response, ms));

// usage: only works on async or top level functions
await wait(5000); console.log('waited 5 seconds');

// one-liner with less memory and time
await new Promise(res => setTimeout(res, ms));

// not need async
setTimeout(() => {
  console.log('waited 3 seconds');
}, 3000);
```
