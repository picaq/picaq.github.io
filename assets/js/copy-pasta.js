(function (jtd, undefined) {

// Event handling

jtd.addEvent = function(el, type, handler) {
  if (el.attachEvent) el.attachEvent('on'+type, handler); else el.addEventListener(type, handler);
}
jtd.removeEvent = function(el, type, handler) {
  if (el.detachEvent) el.detachEvent('on'+type, handler); else el.removeEventListener(type, handler);
}
jtd.onReady = function(ready) {
  // in case the document is already rendered
  if (document.readyState!='loading') ready();
  // modern browsers
  else if (document.addEventListener) document.addEventListener('DOMContentLoaded', ready);
  // IE <= 8
  else document.attachEvent('onreadystatechange', function(){
      if (document.readyState=='complete') ready();
  });
}

// Copy button on code

jtd.onReady(function(){

  if (!window.isSecureContext) {
    console.log('Window does not have a secure context, therefore code clipboard copy functionality will not be available. For more details see https://web.dev/async-clipboard/#security-and-permissions');
    return;
  }

  var codeBlocks = document.querySelectorAll('div.highlighter-rouge, div.listingblock > div.content, figure.highlight');

  // note: the SVG svg-copied and svg-copy is only loaded as a Jekyll include if site.enable_copy_code_button is true; see _includes/icons/icons.html
  var svgCopied =  '<svg viewBox="0 0 24 24" class="copy-icon"><use xlink:href="#svg-copied"></use></svg>';
  var svgCopy =  '<svg viewBox="0 0 24 24" class="copy-icon"><use xlink:href="#svg-copy"></use></svg>';

  setTimeout(() => {
    var copyButtons = document.querySelectorAll('div.highlighter-rouge button, div.listingblock > div.content button, figure.highlight button');
    copyButtons.forEach(button => button.remove());
    codeBlocks.forEach(codeBlock => {
      var copyButton = document.createElement('button');
      var timeout = null;
      copyButton.type = 'button';
      copyButton.ariaLabel = 'Copy code to clipboard';
      copyButton.innerHTML = svgCopy;
      codeBlock.append(copyButton);

      copyButton.addEventListener('click', function () {
        if(timeout === null) {
          var code = (codeBlock.querySelector('pre:not(.lineno, .highlight)') || codeBlock.querySelector('code')).innerText;
          window.navigator.clipboard.writeText(code.slice(0, -1));

          copyButton.innerHTML = svgCopied;
          // console.log('Code copied to clipboard');
          var timeoutSetting = 4000;

          timeout = setTimeout(function () {
            copyButton.innerHTML = svgCopy;
            timeout = null;
          }, timeoutSetting);
        }
      });
    });
    // console.log('waited .01 seconds');
  }, 10);

});

})(window.jtd = window.jtd || {});

