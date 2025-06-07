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

