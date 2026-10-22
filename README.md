# juangmendoza.github.io

## Automatic publications

The writings page contains saved publication HTML, so papers appear without JavaScript or a live arXiv connection. `scripts/update-arxiv.ps1` refreshes only the marked publication block using the arXiv Atom API. It searches quant-ph and filters for the exact author name `Juan Gonzalez De Mendoza`. Update this filter if the author name used on future submissions changes.

Run locally with PowerShell 7: `pwsh -File scripts/update-arxiv.ps1`.

After these changes are pushed to the default branch, the **Update publications** GitHub Actions workflow checks daily at 12:23 UTC. It can also be run manually from the Actions tab. It commits changed publications and explicitly requests a GitHub Pages rebuild, since commits made by the Actions token do not automatically trigger Pages builds. This assumes Pages continues to deploy from the default branch, with Actions allowed and the workflow permitted to write repository contents and Pages builds. No personal access token is needed.

API failures, empty matching results, decreasing publication counts, and results exceeding the 100-record query limit fail the update while preserving the saved list. Check failed runs in Actions. Public-repository schedules may be disabled by GitHub after 60 days without repository activity; re-enable the workflow if that happens.


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

### ".nojekyll" File
By default, GitHub pages uses a website processor called Jekyll. Jekyll ignores all files and directories beginning with underscores. Adding the ".nojekyll" file in the root directory disables this unnecessary processing.

Thus, you can remove this file if the website is migrated from GitHub Pages to another platform later on.

If you ever wanted to implement Jekyll, the "_includes" directory would need to be renamed without the leading underscore, and pathnames linking to its files would need to be updated across the website.

The Substack section lists recent posts from https://blowthepopsiclestand.substack.com/feed. Run `pwsh -File scripts/update-substack.ps1` to refresh it locally. RSS may only include recent posts; the section links to the full publication. Both feeds run independently in the daily workflow, preserving the saved list for a failed feed while allowing the other to update. Only titles, dates, and links are displayed from Substack.

Substack may block GitHub-hosted requests with HTTP 403 or rate-limit them with HTTP 429. When saved posts exist, these responses skip the refresh with a warning in the Actions log and run summary, and the next daily run retries. Substack posts can remain out of date while access is blocked. Other errors still fail the workflow. Pages is rebuilt only when the updater commits a change; pushes that modify updater scripts or the workflow also run the updater for verification.
