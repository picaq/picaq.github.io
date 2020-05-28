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

function changer() {
    let size = document.getElementById("size").value;
    for ( i = 0; i < all.length; i++ ) {
      all[i].style.fontSize = size + "rem";
    }
}

function halfRem() {
    size.value = .5;
    changer();
}

function fiveRem() {
    size.value = 5;
    changer();
}
