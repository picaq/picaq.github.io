---
title: Teaching
permalink: blog/teaching
nav_order: 3
---

# Teaching

Teaching tools & scripts for a smoother classroom experience

## Browser Scripts & Bookmarklets

### Fullscreen Presentation
[fullscreen](javascript: document?.fullscreenElement || document.querySelector(%27html%27).requestFullscreen();)
```js
javascript: document?.fullscreenElement || document.querySelector('html').requestFullscreen();
```

### Class Timer

[timer](javascript:void%20function(){const%20a=new%20Date,b=a.getDay(),c=a=%3E{const%20b=a.split(%22:%22);return%2060*(60*parseInt(b[0])+parseInt(b[1]))},d=[[%229:00%22,%2210:05%22,%2210:50%22,%2212:30%22,%2214:00%22],[%228:40%22,%229:50%22,%2210:50%22,%2211:40%22,%2213:30%22],[%229:00%22,%2210:05%22,%2211:10%22],[%229:00%22,%2210:05%22,%2210:55%22,%2212:00%22],[%229:00%22,%2210:05%22,%2210:55%22,%2212:25%22]][b-1],e=d.map(a=%3Ec(a)),f=a.getHours(),g=a.getMinutes(),h=a.getSeconds(),i=`${0%3Cf%3Ff+%22:%22:%22%22}${0%3Cf%26%2610%3Eg%3F%220%22+g:g}:${10%3Eh%3F%220%22+h:h}`,j=60*(60*f)+60*g+h,k=(()=%3E{for(let%20a=0;a%3C=e.length;a++)if(e[a]%3Ej)return%20e[a]})()-j-300,l=Math.floor(k/60);window.location=`https://www.google.com/search%3Fq=set+timer+for+${l}+minutes+${k%2560}+seconds`}();)

- Each inner array of `endTimes` is indexed to the day of the weekday: Monday Tuesday Wednesday Thursday Friday
  - Times are in military time HH:mm
- `cleanup` is the number of minutes in seconds subtracted from the end of class for cleaning up
- [edit](javascript:void%20function(){let%20a=document.querySelector(%22body%22);a.contentEditable=%22true%22!==a.contentEditable}();) these values in the below codeblock before updating the bookmark if the class schedule changes

```js
javascript: (()=>{

const endTimes = [
    ['10:05', '10:50', '12:30', '14:00'],
    ['8:40', '9:50', '10:50', '11:40', '13:30'],
    ['9:00', '10:05', '11:10'],
    ['9:00', '10:05', '10:55', '13:23'],
    ['9:00', '10:05', '10:55', '12:25'],
];
const cleanup = 3 * 60;

const today = new Date();
const day = today.getDay();
const hhmmtoSeconds = (time) => {
    const split = time.split(':');
    return 60 * (60 * parseInt(split[0]) + parseInt(split[1]));
};
    
const todayEndTimes = endTimes[day-1];
const todayEndTimeSeconds = todayEndTimes.map( time => hhmmtoSeconds(time) );
    
const hours = today.getHours();
const minutes = today.getMinutes();
const seconds = today.getSeconds();  

const formattedNow = `${ hours > 0 ? hours + ":" : "" }${ hours > 0 && minutes < 10 ? '0' + minutes : minutes }:${ seconds < 10 ? '0' + seconds : seconds }`;
const secondsNow = hours * 60 * 60 + minutes * 60 + seconds; 
    
const getEndTimeSeconds = () => {
    for ( let i = 0; i <= todayEndTimeSeconds.length; i++) {
        if (todayEndTimeSeconds[i] > secondsNow) return todayEndTimeSeconds[i];
    };
};
    const diff = getEndTimeSeconds()-secondsNow-cleanup;
    const endMins = Math.floor(diff / 60);
    const endSecs = diff % 60;
    window.location = `https://www.google.com/search?q=set+timer+for+${endMins}+minutes+${endSecs}+seconds`;
})();
```
