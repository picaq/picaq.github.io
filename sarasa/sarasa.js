// window.onload = change();

let west = document.getElementsByClassName('west');
let east = document.getElementsByClassName('east');

// let all = [].concat(west, east);
let all = [...west, ...east];

function change() {
    let weight =  document.getElementById("weight").value;
    for ( i = 0; i < all.length; i++ ) {
      all[i].style.fontWeight = weight;
    }
}