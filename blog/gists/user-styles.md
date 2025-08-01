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

### Y Combinator workatastartup.com
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap');

@media print {

    body {
        max-width: 40em;
        font-family: Inter;
        line-height: 1.3rem;
    }
    .company-logo {
        float: left;
        margin-right: 1.5rem;
    }
    
    [class="company-section my-10"] {
        clear: both;
        padding-top: 1.3rem;
    }
    
    .company-title .company-name {
        margin: 0 0 .75rem;
        display: inline-block;
    }

    .company-title .company-name + div + div {
        margin: .25rem 0 .05rem;
        display: inline-block;
    }
    
    .text-xl, .text-2xl {
        font-size: 1.2rem;
        font-weight: 600;
    }
    
    .text-2xl {
        font-size: 1.5rem;
        font-weight: 500;
    }
    
    .text-xl, .text-2xl, h1, h2, h3, h4 {
        font-family: Open Sans;
    }
    
    .flex {
        display: flex;
    }
.text-sm {
    font-size: .875rem;
    line-height: 1.25rem;
}

.gap-x-6 {
    -moz-column-gap: 1.5rem;
    column-gap: 1.5rem;
}
.flex-row {
    flex-direction: row;
}
    nav + div  {
        padding: 1.5rem 0;
    }
    nav > .flex {
        gap: .25rem;
    }
    
    [class="company-details my-2 flex flex-wrap md:my-0"] * {
        padding: .13rem .33rem 0 0 ;
    }
    a img {padding: 1.2rem 1.2rem 0 0}
/*     [data-page] */
[class="ycdc-card mt-8 sm:w-[300px]"],
    [class="w-full rounded bg-sky-100 text-sky-600 flex flex-row justify-between px-3 py-3 border-blue-200 border my-2"]
    , [class="secondary normalwidth company-other-jobs mt-10"]
    , [class="bg-brand w-full mt-2 md:mt-4 sm:px-6 lg:px-8 py-4 overflow-hidden"],
    [id^="WaasShowJobPage-react-component"] > div.mx-auto.max-w-ycdc-page > section > div > div:nth-child(2),
    [id^="WaasShowJobPage-react-component"] > div.mx-auto.max-w-ycdc-page > div,
    [id^="WaasShowJobPage-react-component"] > div.no-scroll-behind.relative.isolate.z-10,
    footer,
    [id^="WaasShowJobPage-react-component"] > div.mx-auto.max-w-ycdc-page > section > div > div.flex-grow.space-y-5 > div.ycdc-card.max-w-2xl > div.mt-6.border-t.border-gray-300.pt-6.text-sm
    {
        display: none;
    }
    
    [id^="WaasShowJobPage-react-component"] > div.mx-auto.max-w-ycdc-page > section > div > div.flex-grow.space-y-5 {
    display: block !important;
    }

}

```
