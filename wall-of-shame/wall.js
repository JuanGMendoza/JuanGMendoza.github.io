const fallback = 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><path fill="#141b17" d="M0 0h400v400H0z"/><circle cx="200" cy="145" r="65" fill="#647268"/><path fill="#647268" d="M65 400v-35a135 135 0 0 1 270 0v35z"/></svg>');
const wall = document.querySelector('#wall');
const status = document.querySelector('#status');

function portraitUrl(value) {
  if (typeof value !== 'string' || !value.trim()) return fallback;
  const url = new URL(value, document.baseURI);
  return ['http:', 'https:'].includes(url.protocol) ? url.href : fallback;
}

async function openArchives() {
  try {
    const response = await fetch('people.json', { cache: 'no-cache' });
    if (!response.ok) throw new Error('Could not load the archive.');
    const people = await response.json();
    if (!Array.isArray(people) || people.some(person => !person || typeof person.name !== 'string' || !Array.isArray(person.offenses) || person.offenses.some(item => typeof item !== 'string'))) {
      throw new Error('Each entry needs a name and an offenses array.');
    }
    const entries = document.createDocumentFragment();
    people.forEach(person => {
      const card = document.createElement('article');
      card.className = 'person';
      const portrait = document.createElement('div');
      portrait.className = 'portrait';
      const photo = document.createElement('img');
      photo.alt = `Portrait of ${person.name}`;
      photo.loading = 'lazy';
      photo.addEventListener('error', () => { photo.src = fallback; }, { once: true });
      photo.src = portraitUrl(person.photo);
      portrait.append(photo);
      const details = document.createElement('div');
      details.className = 'details';
      const name = document.createElement('h2');
      name.textContent = person.name;
      const offenses = document.createElement('ul');
      person.offenses.forEach(offense => {
        const item = document.createElement('li');
        item.textContent = offense;
        offenses.append(item);
      });
      details.append(name, offenses);
      card.append(portrait, details);
      entries.append(card);
    });
    wall.replaceChildren(entries);
    status.hidden = people.length > 0;
    status.textContent = 'No entries.';
  } catch (error) {
    status.hidden = false;
    status.textContent = 'Unable to load entries. Please try again later.';
    console.error(error);
  }
}

openArchives();


