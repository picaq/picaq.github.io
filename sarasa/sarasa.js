// window.onload = change();

// document.querySelectorAll('.west')

let west = document.getElementsByClassName('west');
let east = document.getElementsByClassName('east');

// let west = document.querySelectorAll('.west');
// let east = document.querySelectorAll('.east');

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

// let italicStore = false;
// let slabStore = false;

function italicize() {
    let italic = document.getElementById("italic");
    if (italic.checked === true) {
        for ( i = 0; i < all.length; i++ ) {
        // all[i].style.fontStyle = "italic";
        all[i].classList.add('italic');
        }
        // italicStore = true;
    }
    else if (italic.checked === false) {
        for ( i = 0; i < all.length; i++ ) {
        // all[i].style.fontStyle = "regular";
        all[i].classList.remove('italic');
        }
        // italicStore = false;
    }
}

function slabify() {
    let family = document.getElementById("slab");
    if (family.checked === true) {
        for ( i = 0; i < west.length; i++ ) {
            // west[i].style.fontFamily = 'Sarasa Mono Slab K';
            west[i].classList.add('slab');
        }
    }
    else if (family.checked !== true) {
        for ( i = 0; i < west.length; i++ ) {
        // west[i].style.fontFamily = 'Sarasa Mono Slab J';
        west[i].classList.remove('slab');
        }    
    
    }
}


document
