// Table of Contents
let article = document.getElementsByTagName("article")[0];
let headings;
let sidebar;
let nav;

// build TOC
addHeadingsClass();
if (headings.length > 1) {
  buildTOC();
  addAnchorLinks();
  article.insertAdjacentElement("afterend", sidebar);
}
removeHeadingsClass();


/**
* Temporarily give all headings in the article an identifying classname.
*/
function addHeadingsClass() {
  for (i=1; i<=6; i++) {
    headings = article.getElementsByTagName('h'+i);
    for (j=0; j<headings.length; j++) {
      headings[j].className = 'h';
    }
  }
  headings = document.getElementsByClassName('h');
}


/**
* Build main TOC component - aside with a nav inside
*/
function buildTOC() {
  sidebar = document.createElement("aside");
  toc = document.createElement("nav");
  sidebar.insertAdjacentElement("beforeend", toc);
}


/**
* Add unique id to each heading, and a corresponding anchor link to the TOC
*/
function addAnchorLinks() {
  let text_wrapper;
  let unique_ids = {};

  let h;
  let h_id;
  let h_link;
  for (i=0; i<headings.length; i++) {
    // config heading id
    h = headings[i];
    h_id = h.innerHTML.split(' ').join('_').replace(/[`~!@#$%^&*()|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '');
    unique_ids[h_id] = (unique_ids[h_id] + 1 || 0);
    (unique_ids[h_id]==0) ? (h.id=h_id) : (h.id=h_id+"_"+unique_ids[h_id]);

    // build anchor link
    h_link = document.createElement('a');
    h_link.href = '#' + h.id;
    // wrap text
    text_wrapper = document.createElement("span");
    text_wrapper.innerHTML = h.innerHTML;
    text_wrapper.classList.add(h.tagName.replace("H", "h") + '-link');
    h_link.insertAdjacentElement("beforeend", text_wrapper);

    // add link to table of contents
    toc.insertAdjacentElement("beforeend", h_link);
  }
}


/**
* remove identifying class from headings
*/
function removeHeadingsClass() {
  while (headings.length > 0) {
    h = headings[0];
    h.className = h.className.replace('h', '');
  }
}
