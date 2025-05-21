document.addEventListener("DOMContentLoaded", () => {
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
  const leftButton  = document.getElementById("advertisement-1-left-button");
  const rightButton = document.getElementById("advertisement-1-right-button");

  if (!promoText || !leftButton || !rightButton) {
    console.error("Uno o più elementi DOM non sono stati trovati.");
    return;
  }

  function animatePromo(newIndex, direction) {
    const outX = direction === "next" ? "100%" : "-100%";
    const inX  = direction === "next" ? "-100%" : "100%";

    promoText.style.transform = `translate(${outX}, -50%)`;
    promoText.style.opacity   = "0";

    setTimeout(() => {
      currentIndex = newIndex;
      promoText.textContent = promos[currentIndex];

      promoText.style.transform = `translate(${inX}, -50%)`;
      void promoText.offsetWidth; // forza il reflow

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

  promoText.textContent = promos[currentIndex];
  startAutoScroll();
});
