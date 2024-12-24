let currentIndex = 0;
const images = document.querySelectorAll('.slideshow img');
const dots = document.querySelectorAll('.dot');

function showImage(index) {
    images.forEach((img, i) => {
        img.style.display = 'none';
        dots[i].classList.remove('active');
    });

    images[index].style.display = 'block';
    dots[index].classList.add('active');
}

setInterval(() => {
    currentIndex = (currentIndex + 1) % images.length;
    showImage(currentIndex);
}, 3000);

dots.forEach((dot, index) => {
    dot.addEventListener('click', () => {
        currentIndex = index;
        showImage(currentIndex);
    });
});

showImage(currentIndex);
