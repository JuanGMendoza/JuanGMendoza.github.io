# Wall of Shame

Standalone page at `/wall-of-shame/`. It has no link from the personal website and uses its own styles. Once published through the existing GitHub Pages setup, its address is https://juangmendoza.com/wall-of-shame/.

## Add or remove someone

Edit `wall-of-shame/people.json` directly on GitHub or locally. Each object is a person; entries appear in file order:

```json
[
  {
    "name": "Your friend's name",
    "photo": "assets/friend.jpg",
    "offenses": [
      "Skipped game night.",
      "Blamed the controller. Again."
    ]
  }
]
```

Upload photos to `wall-of-shame/assets/`, then use their filenames in `photo` (matching capitalization). An empty or missing photo uses the silhouette. Photos crop to fill the frame; portrait or square photos work best. Every offense becomes a bullet point. Text is displayed literally, not interpreted as HTML.

Copy an object to add someone, delete an object to remove someone, or reorder objects to rearrange the wall. Separate objects and bullet strings with commas, but do not put a comma after the final item. Use `[]` to clear the wall. Replace the two clearly labeled fictional examples before sharing.

Commit changes to the branch used by GitHub Pages and wait for deployment. No build, database, or login system is needed. GitHub's file editor is the simplest management interface.

The page requests that search engines do not index it, but an unlinked page is still public to anyone with the URL. This is not password protection.

For a local preview, serve the repository over HTTP (for example `python -m http.server 8000`) and open http://localhost:8000/wall-of-shame/. Opening the HTML directly from disk will not load the JSON in most browsers. Fonts use Google Fonts with local serif fallbacks.
