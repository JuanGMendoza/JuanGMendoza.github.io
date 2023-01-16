# juangmendoza.github.io


## Directory Structure
The root directory is structured so that each website page is nested within its own directory, and its HTML file is named "index.html". This is useful because it formats your links based on its location in the project and removes the HTML extension.

For instance, the about page is located at: "/about/index.html"
and so its public URL will be "https://juangmendoza.com/about/".

Within most page directories, there is an assets folder for images, videos, and any other files linked to by that HTML page. This better organizes media files by keeping them grouped with the page they correspond to, and shortens pathnames within each HTML file.

## CSS Files
There is a main CSS file called "main.css" at the root directory of the project. This file contains presets (e.g. color variables), default styles, and reused styles across the project.

Within some page directories, a supplementary CSS file called "index.css" is used to extend "main.css" or add styles that are only used on that page. These pages will link to both files in the "head" tag of their HTML.

## Homepage
Note that the homepage is found at the root of the project in "index.html". To prevent cluttering up the root directory, the homepage assets (images and page-specific CSS) are placed in a directory named "home".

This is the only page whose assets and page-specific CSS are in a separate location from the HTML file.

## "writings" Directory
Within the writings directory, each blog post (or any other entry) should have its own sub-directory, containing any necessary assets linked to within the article. The "YYYYMMDD-template" directory provides the template HTML file that should be used for each blog post.

## "_includes" Directory
Within the root directory, there is one special sub-directory named "_includes". This folder contains JavaScript code used to inject frequently used HTML components into webpages.

This folder contains a template "header.js" and "footer.js" file which is used on all website HTML pages. Since the "header" and "footer" HTML components are prone to frequent updates, injecting them into the pages with a "script" tag makes the website more maintainable when one of these components needs to be updated. To update the header or footer on every single website page in a single step, you need only update its corresponding file in this directory.

There is also a "blogpost_breadcrumbs.js" file in this directory for use on all blog posts. Since the "breadcrumbs" element will be copy/pasted on every blog post, having it templated allows for easier changes down the road.

Lastly, there is a "blog_toc.js" file in this directory for use on all blog posts, which generates a table of contents based on the blog post's heading tags.

### ".nojekyll" File
By default, GitHub pages uses a website processor called Jekyll. Jekyll ignores all files and directories beginning with underscores. Adding the ".nojekyll" file in the root directory disables this unnecessary processing.

Thus, you can remove this file if the website is migrated from GitHub Pages to another platform later on.

If you ever wanted to implement Jekyll, the "_includes" directory would need to be renamed without the leading underscore, and pathnames linking to its files would need to be updated across the website.
