// inject background element onto page
let bg = document.createElement("div");
bg.id = "bg";
document.body.insertAdjacentElement("afterbegin", bg);


// add random squares to background element
var rand_span;
var rand_x;
var rand_y;
var rand_size;
var rand_rotation;
for (i=0; i<20; i++) {
  rand_span = document.createElement("span");
  // generate random attributes
  rand_x = Math.floor(Math.random() * 100);         // 0 to 100 vw
  rand_y = Math.floor(Math.random() * 90) + 10;         // 10 to 100 vh
  rand_size = Math.floor(Math.random() * 15) + 10;  // 10 to 25 vmin
  rand_rotation = Math.floor(Math.random() * 360);  // 0 to 360 deg
  // set CSS styles
  rand_span.style.left = rand_x + "vw";
  rand_span.style.top = rand_y + "vh";
  rand_span.style.width = rand_size + "vmin";
  rand_span.style.height = rand_size + "vmin";
  rand_span.style.transform = "rotate(" + rand_rotation + "deg)";
  // place in bg
  bg.insertAdjacentElement("beforeend", rand_span);
}
