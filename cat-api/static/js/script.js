document.getElementById('loadCats').addEventListener('click', async () => {
    const gallery = document.getElementById('catGallery');
    gallery.innerHTML = 'Loading...';
    try {
        const response = await fetch('/api/cats');
        const data = await response.json();
        gallery.innerHTML = '';
        data.forEach(cat => {
            const img = document.createElement('img');
            img.src = cat.url;
            img.alt = "Cat Image";
            img.className = "cat-image";
            gallery.appendChild(img);
        });
    } catch (error) {
        gallery.innerHTML = 'Error loading images.';
    }
});
