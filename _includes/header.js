// Inject the Header code into the Webpage
document.write(`
  <header>
    <div class="wrapper">
      <a id="header-title" href="/">
        <img src="/icon.png" alt="JGM" />
      </a>

      <nav role="navigation" aria-label="Main">
        <a href="/about/">About Me</a>
        <a href="/resume/">Resume</a>
        <a href="/writings/">Writings</a>
      </nav>

      <button id="hamburger">
        <!-- bars -->
        <svg class="hamburger-bars" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
          <!--! Font Awesome Pro 6.2.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. -->
          <path d="M0 96C0 78.3 14.3 64 32 64H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32C14.3 128 0 113.7 0 96zM0 256c0-17.7 14.3-32 32-32H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32zM448 416c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32z"/>
        </svg>
        <!-- x -->
        <svg class="hamburger-x" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
          <!--! Font Awesome Pro 6.2.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. -->
          <path d="M310.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L160 210.7 54.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L114.7 256 9.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L160 301.3 265.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L205.3 256 310.6 150.6z"/>
        </svg>
      </button>
    </div>
  </header>
`);


// Add Header Functionality
var header = document.querySelector("header");
var hamburger_icon = document.getElementById("hamburger");
hamburger_icon.onclick = function() {
  header.classList.toggle("active");
}
