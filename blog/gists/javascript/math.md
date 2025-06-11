---
title: Math & Number
permalink: blog/gists/javascript/math
parent: JavaScript
nav_order: 6
---

# Math & Number Manipulations

{% include toc.html %}

## Arithmatic

[Math JS](https://gist.github.com/picaq/f111966c514437abc150fb4ee7d28c3b)
### factorial
```js
const bang = n => {
  if ( n < 2 ) return 1;
  let fact = 1, i = 2;
  while (i <= n) {fact*=i; i++};
  return fact;
}
```
### factorial big int
```js
const bigBang = n => {
  if ( n < 2n ) return 1n;
  let fact = 1n, i = 2n;
  while (i <= n) {fact*=i; i++};
  return fact;
}
```
### product
```js
arr.reduce((a, b) => a * b, 1);
```
### split num into arr of digits
```js
const digitize = int => {
  let number = parseInt(int);
  let sum = 10;
  let arr = [];

  while (number > 0) {
      val = number % 10;
      sum += val;
      arr.push(val);
      number = (number - val) / 10;
  }
  console.log(sum);
  return arr.reverse();
}
```

### sum
```js
arr.reduce((a, b) => a + b, 0);

// slow, iterative sum of 1 + 2 + 3 ... + n of known n O(n)
const sum = (n) => {
    let val = 0;
    while (n > 0) {
        val += n; n--;
    }    
    return val;
}

// faster calculation O(1)
const sum2 = n => n * (n + 1)/2;
```

### randomize
```js
let randomize = list => console.log(list[Math.floor(list.length * Math.random())]); 
```

### print natural countdown in the console

```js
(loop = (i) => {
  setTimeout(() => {
    console.log(i);
    if (i--) loop(i);
  }, 300 + Math.floor(Math.random()*200))
})(22);
```


## Time conversions

[Convert hh:mm:ss to seconds and back + number formats](https://gist.github.com/picaq/316b9b9f3be63c764f17f928b89f268a)

### convert HHMMSS to seconds

```js
const toSec = str => str.split(':').reduce((a, time) => (60 * a) + +time);
```

### convert seconds To HHMMSS

```js
const toHMS = totalSec => {
  const hours = Math.floor((totalSec % (60 * 60 * 24)) / (60 * 60));
  const minutes = Math.floor((totalSec % (60 * 60)) / (60));
  const seconds = Math.floor((totalSec % (60)) );
  // removes all leading zeros
  const hhmmss = `${ hours > 0 ? hours + ":" : "" }${ hours > 0 && minutes < 10 ? '0' + minutes : minutes }:${ seconds < 10 ? '0' + seconds : seconds }`;
  // keeps all leading zeros
  const _0_HMS = `${ hours < 10 ? '0' + hours : hours }:${ minutes < 10 ? '0' + minutes : minutes }:${ seconds < 10 ? '0' + seconds : seconds }`;
  return _0_HMS;
}
```

### quick convert milliseconds to hh:mm:ss

only works if hh < 24 or ms < 86400000 milliseconds

```js
new Date(ms).toISOString().slice(11, -5);
```

## Phone Number format

### digits to phone number format and back
```js
const formatPhone = digts => `(${digts.slice(0,3)}) ${digts.slice(3,6)}-${digts.slice(-4)}`;
const phoneToNumString = phone => phone.match(/\d/g).join("");
```

## Science

### Temperature conversion

chemistry calculations

```js
const c2f = c => ( c * 9/5 ) + 32;
const f2c = f => ( f - 32 ) * 5/9;

const c2k = c =>  c + 273.15;
const k2c = k => k - 273.15;

const f2k = f => f2c(f) + 273.15;
const k2f = k => c2f(k - 273.15);
```

## Currency conversions

This is based off of this freecodecamp guide: [How to Format a Number as Currency in JavaScript](https://www.freecodecamp.org/news/how-to-format-number-as-currency-in-javascript-one-line-of-code/) 

[currency.js](https://gist.github.com/picaq/ff2dd86c9c5ddb7888dfcb9aefc496a8#file-currency-js)
```js
// format number to US dollar
let usd = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
});

let cad = new Intl.NumberFormat('en-CA', {
    style: 'currency',
    currency: 'CAD',
});

// format number to British pounds
let pounds = Intl.NumberFormat('en-GB', {
    style: 'currency',
    currency: 'GBP',
});

// format number to Indian rupee
let rupee = new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
});

// format number to Euro
let euro = Intl.NumberFormat('en-DE', {
    style: 'currency',
    currency: 'EUR',
});

// format number to yuan
let yuan = Intl.NumberFormat('cn-CN', {
    style: 'currency',
    currency: 'CNY',
});

// format number to yen
let yen = Intl.NumberFormat('jp-JA', {
    style: 'currency',
    currency: 'JPY',
});

// format number to won
let won = Intl.NumberFormat('kr-KR', {
    style: 'currency',
    currency: 'KRW',
});

'Dollars: ' + USDollar.format(price)
// Dollars: $143,450.00

`Pounds: ${pounds.format(price)}`;
// Pounds: £143,450.00

'Rupees: ' + rupee.format(price);
// Rupees: ₹1,43,450.00

`Euro: ${euro.format(price)}`;
// Euro: €143,450.00

```

## Binary & Ascii math

[binary and ascii math](https://gist.github.com/picaq/3baa10da9ec0353ff0530fe2b681c870)

### ascii

```js
a.charCodeAt(0); // get char code int from str char
String.fromCharCode(...nums); // convert list of nums to string

// convert string to arr of char code nums
const charCodes = (string) => {
  let nums = [];
  for (i in string) nums.push(string.charCodeAt(i)); 
  return nums;
}

// convert hex to string
const hex2str = (hex) => {
  let outputNums = [];
  for (let i = 0; i < hex.length; i+=2) {
    const int = parseInt(hex[i+0] + hex[i+1], 16);
    outputNums.push(int);
  }
  return String.fromCharCode(...outputNums);
}

// convert string to hex
const str2hex = (string) => {
  hex = "";
  for (i in string) hex += string.charCodeAt(i).toString("16").padStart(2, '0');
  return hex;
}
```

### integer to binary and back

```js
const intBin = int => int.toString(2); // must be called as a function to work otherwise it will error
const binInt = bin => parseInt(bin, 2);

const intHex = int => int.toString(16); // must be called as a function to work otherwise it will error
const hexInt = hex => parseInt(hex, 16);
```

### xor encryption to hex and back

```js
const xor2hex = (input, key) => {
  let output = "";
  const len = key.length;
  const toXorHex = (a, b) => (a ^ b).toString("16").padStart(2, '0');
  for (i in input) {
    output += toXorHex(input.charCodeAt(i), key.charCodeAt(i % len));
  }; 
  return output;
}

const hex2xor = (input, key) => {
  let outputNums = [];
  const len = key.length;
  for (let i = 0; i < input.length; i+=2) {
    const int = parseInt(input[i+0] + input[i+1], 16);
    outputNums.push(int ^ key.charCodeAt(i/2 % len));
  }
  return String.fromCharCode(...outputNums);
}
```
