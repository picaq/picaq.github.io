---
title: Promise
permalink: blog/gists/javascript/promise
parent: JavaScript
nav_order: 10
---

# Promise

## Async / Await & .then() chain

### Using async/await

```js
const url = `https://someapi.com/${somevars}`;

const response = await fetch(url);
const text = await response.text();
const json = await response.json();

console.log(text, json); 
```

### .then() chain

```js
const response = () => fetch(url)
  .then(response => response.json())
  .then(json => {
    console.log(json); 
  });

response();
```

### Try Catch & Error

Try catch and await async in a network API request

#### Using async/await with try/catch

```js
try {
  const response = await fetch(url);
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  const json = await response.json();
  console.log(json);
} catch (error) {
  console.error('Error fetching data:', error);
}
```

#### Using `.then()` chain with `.catch()`

```js
fetch(url)
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.text();
  })
  .then(text => {
    console.log(text); // "some string"
  })
  .catch(error => {
    console.error('Error fetching data:', error);
  });
```

#### format with es6 arrow function

```js
const functionName = async (parameters) => {
  // asynchronous operations with await
};
```

#### example

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

#### CORS

bypass CORS with a proxy

```js
const getData = async (hr = time) => {
  try {
    const response = await fetch(
      'https://corsproxy.io/' +
        `https://apidata.com/treasure/${String(hr).padStart(2,'0')}.json`,
      {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET',
          'Access-Control-Allow-Headers':
            'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With',
        },
      }
    );
    const jsonData = await response.json();
    console.log(jsonData);
    cache[hr] = jsonData; // add api response data to cache
    doSomething(hr);
    
  } catch (error) {
    console.error(error.message);
  };
};
```

### Wait Before Execution

Use between batch downloads or to wait in between loops or before a browser action such as click or scroll.

usage: only works on async or top level functions
```js
const wait = ms => new Promise(response => setTimeout(response, ms));

await wait(5000); // console.log('waited 5 seconds');
```

one-liner with less memory and time: useful if only needed once or a known hardcoded delay.
```js
await new Promise(res => setTimeout(res, 5000)); // console.log('quickly waited 5 seconds');
```

async not needed
```js
setTimeout(() => {
  console.log('waited 3 seconds');
}, 3000);
```

#### Batch download all resource links in page

a delay between clicks is needed to prevent rate limiting and browser download limits.

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
