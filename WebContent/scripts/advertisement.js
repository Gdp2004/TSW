// scripts/advertisement.js

const promos = [
  "Free shipping on orders over $50",
  "10% di sconto su tutti gli e-book!",
  "15% di sconto sui bestseller del mese!",
  "Sconto del 20% sui libri di fantascienza!",
  "Spedizione gratuita per ordini superiori a €30!"
];

let currentIndex = 0;
let promoInterval;

const promoText   = document.getElementById("promo-text");
const leftButton  = document.getElementById("left-button");
const rightButton = document.getElementById("right-button");

function animatePromo(newIndex, direction) {
  // invertiamo i sensi: "next" esce a destra e rientra da sinistra
  const outX = direction === "next" ? "100%" : "-100%";
  const inX  = direction === "next" ? "-100%" : "100%";

  // slide out
  promoText.style.transform = `translate(${outX}, -50%)`;
  promoText.style.opacity   = "0";

  setTimeout(() => {
    currentIndex = newIndex;
    promoText.textContent = promos[currentIndex];

    // fuori dallo schermo lato opposto
    promoText.style.transform = `translate(${inX}, -50%)`;

    // forziamo reflow
    void promoText.offsetWidth;

    // slide in al centro
    promoText.style.transform = "translate(0, -50%)";
    promoText.style.opacity   = "1";
  }, 500);
}

function nextPromo() {
  const newIndex = (currentIndex + 1) % promos.length;
  animatePromo(newIndex, "next");
}

function prevPromo() {
  const newIndex = (currentIndex - 1 + promos.length) % promos.length;
  animatePromo(newIndex, "prev");
}

function startAutoScroll() {
  clearInterval(promoInterval);
  promoInterval = setInterval(nextPromo, 5000);
}

leftButton.addEventListener("click", () => {
  prevPromo();
  startAutoScroll();
});
rightButton.addEventListener("click", () => {
  nextPromo();
  startAutoScroll();
});

document.addEventListener("DOMContentLoaded", () => {
  promoText.textContent = promos[currentIndex];
  startAutoScroll();
});
