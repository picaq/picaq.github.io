---
title: User Styles
permalink: blog/gists/css/styles
parent: CSS
nav_order: 2
---

# User Styles

Custom user-defined style sheets to better browse the web.

## Light Themes & Printing

### Notion.site

ctrl/cmd + shift +  L swaps between light and dark themes for your own notion notes but not public ones. <br>
Here is a workaround:

```css
[style*="color: rgba(255, 255, 255, 0.81)"] {
    color: rgba(0, 0, 0, 0.81) !important
}

[style*="background: rgba(255, 255, 255, 0.13)"] {
    background: rgba(0, 0, 0, 0.03) !important
}

#main [style*="fill: rgba(255, 255, 255, 0.46)"], [style*="color: rgba(255, 255, 255, 0.46)"], #main [style*="fill: rgba(255, 255, 255"] {
    fill: rgba(0, 0, 0, 0.46) !important;
    color: rgba(0, 0, 0, 0.46) !important;
    outline: rgba(0, 0, 0, 0.46) !important;
}


[style*="color: rgb(155, 155, 155); fill: rgb(155, 155, 155);"] {
    color: rgb(95, 95, 95) !important; 
    fill: rgb(95, 95, 95) !important;

}
 
[style="display: flex; flex-direction: row;"]  { 
     filter: brightness(.3)
}

@media screen {
    [style*="background: rgb(25, 25, 25)"] {
        background: rgb(225, 225, 225) !important
    }
}

@media print {
    html > body [style*="background: rgb(25, 25, 25)"] {
        background: white !important
    }
}
```