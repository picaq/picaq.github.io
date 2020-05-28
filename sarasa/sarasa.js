// window.onload = change();

let west = document.getElementsByClassName('west');
let east = document.getElementsByClassName('east');

// let all = [].concat(west, east);
let all = [...west, ...east];

function change() {
    let weight = document.getElementById("weight").value;
    for ( i = 0; i < all.length; i++ ) {
      all[i].style.fontWeight = weight;
    }
}

function xLight() {
    weight.value = 200;
    change();
}

function bold() {
    weight.value = 600;
    change();
}




// // When the user scrolls the page, execute myFunction
// window.onscroll = function() {myFunction()};

// // Get the header
// var glyphs = document.getElementById("glyphs");
// var characters = document.getElementById("characters");
// var bq0 = document.getElementsByTagName("blockquote")[0];

// // Get the offset position of the navbar
// // var sticky = glyphs.offsetTop;
// var sticky = glyphs.offsetParent.offsetTop;

// // Add the sticky class to the header when you reach its scroll position. Remove "sticky" when you leave the scroll position
// function myFunction() {
//   if (window.pageYOffset > sticky) {
//     glyphs.classList.add("sticky");
//   } else {
//     glyphs.classList.remove("sticky");
//   }
// }