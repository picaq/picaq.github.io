---
title: User Styles
permalink: blog/gists/css/styles
parent: CSS
nav_order: 2
---

# User Styles

Custom user-defined style sheets to better browse the web.

## Monaco & CodeMirror editors

```css
/* fixes offset cursor in editor */
.monaco-editor .view-lines .view-line, .cm-line {
    /* for iosevka: editor font size * 1.10138462 */
    font-size: 110.138462% !important; 
    font-family: Iosevka !important;
    font-feature-settings: "liga" 0;
}

code, pre, .tio-markdown_code, [id^="file"]:not(h2), .file-info, .CodeMirror-linenumber, #copilot-button-positioner, .cm-gutterElement {
    font-family: Iosevka !important;
    font-feature-settings: "liga" 0;
}

/* remove horrendous dots in coderpad */
.monaco-editor .mtkw {
    color: #0000 !important
}

/* cursor */ 
    .cursor.monaco-mouse-cursor-text,
    .cm-cursor.cm-cursor-primary
{
        background-color: #e9b6c5bf !important;
        border-color: #e9b6c5bf !important;
}

/* colors */

:root {
         --comment-green: #6a9955;
    --comment-steel-blue: rgb(97, 124, 149) !important;
          --keyword-pink: #c586c0;
         --keyword-lilac: rgb(177, 135, 232);
}

/* matching bracket colors */

.view-line .mtk3 {
    color: var(--comment-steel-blue);
}

.bracket-highlighting-0, .bracket-highlighting-3, .bracket-highlighting-6, .bracket-highlighting-9, .bracket-highlighting-12, .bracket-highlighting-15, .bracket-highlighting-18 {
    color: #ffd700a6 !important
}

.view-line .mtk13, .mtk9.bracket-highlighting-1, .bracket-highlighting-4, .bracket-highlighting-7, .bracket-highlighting-10, .bracket-highlighting-13, .bracket-highlighting-16, .bracket-highlighting-19 {
    color: var(--keyword-pink) !important;
}

.bracket-highlighting-2, .bracket-highlighting-5, .bracket-highlighting-8, .bracket-highlighting-11, .bracket-highlighting-14, .bracket-highlighting-17, .bracket-highlighting-20 {
    color: cornflowerblue !important;
}

/* colors */

div.CodeMirror span.CodeMirror-matchingbracket {
    color: rgb(115, 176, 112);
}

.cm-s-textmate span.cm-property {
    color: rgba(219, 210, 198, .89);
}

.cm-s-textmate span.cm-def {
    color: rgb(122, 158, 208);
}

.cm-s-textmate span.cm-keyword {
    color: #b187e8;
}

.cm-s-textmate span.cm-variable-2 {
    color: rgb(140, 190, 198);
}

.cm-s-textmate span.cm-comment {
    color: rgb(97, 124, 149);
}

.cm-s-textmate span.cm-operator {
    color: rgb(86, 166, 114);
}

.cm-s-textmate span.cm-number {
    color: rgb(90, 185, 196);
}

.view-lines {
      /* softer colors */
    filter: saturate(0.7) brightness(1) sepia(0.1);
}

.tio-markdown_img {
    filter: invert(.894) hue-rotate(177deg);
    opacity: .67;
}

/* top spacing for greatfrontend.com */
.lines-content,
.margin-view-overlays
{ translate: 0 0.5rem; }

```

## Light Themes & Printing


### ReMarkable

When a website is “printed” by your browser to a pdf, this prints to the exact size of the ReMarkable 2 or Paper Pro screen content size. Especially noticeable when content is on a dark background.
```css
@media print {
    @page {
    size: 210mm 280mm; /* <- width height */
    margin-top: 0.25in;
    margin-bottom: 0.25in;
    margin-left: 0;
    margin-right: 0;
    }
    
    body {
        zoom: 88%;
    }
}    
```
more info on printing [CSS print page styling | DocuSeal](https://www.docuseal.com/blog/css-print-page-style) 

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
### Remove canvas background animations
example: luma
```
[class*="canvas"], canvas {
    display: none !important;
}
```
