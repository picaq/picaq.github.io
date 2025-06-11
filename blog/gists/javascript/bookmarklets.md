---
title: Bookmarklets
permalink: blog/gists/javascript/bookmarklets
parent: JavaScript
nav_order: 5
---

# Bookmarklets

Most javascript I write are in the form of bookmarklets.

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

{% include toc.html %}

## Browser Utilities

### Countdown tab

```js
javascript: (()=> {
  
  const startCountdown = (ms = 1.8e+6) => {
    const countDownTime = new Date(Date.now() + ms).getTime();

    const x = setInterval(() => {
    
      const now = new Date().getTime();
        
      const distance = countDownTime - now;
        
      const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((distance % (1000 * 60)) / 1000);
        
      document.title = `${hours > 0? hours + ":" : ""}${minutes}:${seconds}`;
        
      if (distance < 0) {
        clearInterval(x);
        document.title = "done!";
      };
    }, 1000);
  };

  startCountdown();
})();
```

### highlight selection into a link

```js

javascript: (()=>{

const URL = window.location.href;

const copy = content => {    
    const tempInput = document.createElement("textarea");
    document.body.appendChild(tempInput);
    tempInput.setAttribute("id", "temporary_input_clipboard");
    document.getElementById("temporary_input_clipboard").value = content;
    tempInput.select();
    document.execCommand("copy");
    document.body.removeChild(tempInput);
};
    
const textPrefix = `#:~:text=`;
let selection = encodeURI(window.getSelection()).replaceAll('-', '%2D');
    
selectedURL = URL+'#:~:text='+selection;
console.log(selectedURL);    
copy(selectedURL);    
window.location.href=selectedURL;
    
})();
```
this needs configuring for longer selections

### toggle dark mode on supported sites
- useful switching to light theme and back for printing documents into paper or pdf
- linkedin mods html class; geeks for geeks mods body `dataSet`
- cord mods body `dataSet`

```js
javascript: (()=> {  
    const html = document.querySelector('html');
    const htmlClass = html.className;
    html.className = document?.querySelector('html.theme--dark') 
                   ? htmlClass.replace('theme--dark ', '') 
                   : htmlClass.replace('theme', 'theme theme--dark');
    const bodyData = document.querySelector('body').dataset;
    bodyData.darkMode = bodyData.darkMode === "true" ? "false" : "true";
    const bodyData2 = document.querySelector('[data-theme]').dataset;
    bodyData2.theme = bodyData2.theme === "dark" ? "light" : "dark";
})();
```

### increase video playback speed

```js
javascript: (()=>{
  const originalSpeed = 1;
  const speedToggle = 1.33;
  const udemyIndicator = document.querySelector('.playback-rate--trigger-text--l7hqr');
  const video = document.querySelector('video');
  const setSpeed = (speed) => {
    video.setAttribute('data-speed', speed);
    video.playbackRate = speed;
    udemyIndicator.innerText = speed + 'x';
  };
  video.getAttribute('data-speed') == speedToggle ? video.playbackRate = setSpeed(originalSpeed) : setSpeed(speedToggle);

})();
```
- toggles a video back and forth between the `originalSpeed` (1x) to a specified preferred speed `speedToggle` (1.3x in this case) 
- this works on all html5 videos and updates the visual indicator on Udemy specifically to match
- unlike `document.designMode = 'on' || 'off'`, it displays spelling mistakes and can be applied at the element level ranther than on the whole document.

### toggle youtube video annotations 

```js
javascript: (()=>{
  document.querySelector('.ytp-ce-element')?.style?.display === 'none' 
    ? document.querySelectorAll('.ytp-ce-element').forEach(div => div.style.display = 'block') 
    : document.querySelectorAll('.ytp-ce-element').forEach(div => div.style.display = 'none');
})();
```

## Development Tools

### hard refresh

```js
javascript: (()=>{location.reload()})();
```

### edit content

```js
javascript: (()=>{
  let body = document.querySelector("body");
  body.contentEditable === 'true' ? body.contentEditable = false : body.contentEditable = true;
})();
```
- toggles `contentEditable` property on the body tag. 
- allows quick, light editing of web page format or content without needing to get into dev tools.

### remove all styles

```js
javascript: (()=>{
  [...document.querySelectorAll('style'), ...document.querySelectorAll('link[rel="stylesheet"]')].forEach( style => style.remove());
})();
```
optionally, also remove inline styles. may have unexpected results:
```js
javascript: (()=>{
  [...document.querySelectorAll('[style]')].forEach( el => el.style = null);
})();
```

### toggle inject CSS

```js
javascript: (()=>{

let css = `
  h1 {color: pink}
`;

const injectCSS = css => {
  let el = document.createElement('style');
  el.type = 'text/css';
  el.id='css_injection';
  el.innerText = css;
  document.head.appendChild(el);
};

const swap = () => !document.getElementById('css_injection') ? injectCSS(css) : document.getElementById('css_injection').remove();
const replace = (newCss=css) => {
  css = newCss;
  !document.getElementById('css_injection') ? injectCSS(css) : document.getElementById('css_injection').innerText = css;
};

swap();

})();
```
- toggle custom css to show on a page
- css needs can be predefined in the bookmarklet as `css`
- if pasted in the console or ran as chrome snippet instead, `replace()` becomes available for use and toggled css is modifiable as an argument

<!-- ### 

```js
javascript: (()=>{

})();
``` -->


## Leetcode

### copy leetcode solution into markdown
```js
javascript: (()=> {  
  
const problem = document.querySelector("[id*='content'] div > a");
const difficulty = document.querySelector("[id*='content'] [class*='text-difficulty']").innerText;
const language = document.getElementById('headlessui-popover-button-:r1e:')?.innerText || document.querySelector('[class="rounded items-center whitespace-nowrap focus:outline-none inline-flex bg-transparent dark:bg-dark-transparent text-text-secondary dark:text-text-secondary active:bg-transparent dark:active:bg-dark-transparent hover:bg-fill-secondary dark:hover:bg-fill-secondary px-1.5 py-0.5 text-sm font-normal group"]').innerText;
const codeIDE = document.querySelector('.view-lines.monaco-mouse-cursor-text');
const codeLines = [...document.querySelectorAll('.view-lines.monaco-mouse-cursor-text .view-line')];
codeLines.pop();
const sortedLines = codeLines.sort((a, b) => parseInt(a.style.top.slice(0,-2)) - parseInt(b.style.top.slice(0,-2)));
const code = sortedLines.map((line) => (line.innerText)).join('\n');
  
const copy = content => {    
  const tempInput = document.createElement("textarea");
  document.body.appendChild(tempInput);
  tempInput.setAttribute("id", "temporary_input_clipboard");
  document.getElementById("temporary_input_clipboard").value = content;
  tempInput.select();
  document.execCommand("copy");
  document.body.removeChild(tempInput);
};

const value = `[${problem.innerText} ${difficulty === 'Easy' ? '🍐' : difficulty === 'Medium' ? '🍊' : '🍎'}](${problem.href})
${language !== 'JavaScript' ? language.toLowerCase() + '\n' : ''}\`\`\`${language === 'JavaScript' ? 'js' : language === 'Ruby' ? 'rb' : language}
${code}
\`\`\`
`;

copy(value);

})();

// `value`'s `\n` at the end of each line must be explicit when minified for a bookmarklet but should be omitted if pasted in the console or chrome snippet
```

### go to leetcode problem ( from another educational source )

```js
javascript: (()=> {  
  let url = new URL(window.location.href);
  if (url.host = 'www.educative.io' || 'designgurus.io') window.location.href = 'https://leetcode.com/problems/' + url.pathname.split('/').pop().replace('solution-', '')
})();
```

## Misc

### Mychart open pdf

opens mychart pdf in a full window
```js
url = document.querySelector('.pdfobject').src;
// options:
// open in a popup
window.open(url, '_blank').focus();
// open in current tab
window.location.href = url;
```
personally preferred bookmarklet use-case
```js
javascript: (()=> {
  url = document.querySelector('.pdfobject').src; window.location.href = url;
})();
```

