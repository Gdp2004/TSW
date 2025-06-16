document.addEventListener('DOMContentLoaded', () => {
  const dropdownButton = document.getElementById('dropdown-button');
  dropdownButton.addEventListener('click', e => {
    e.preventDefault();                  // blocca eventuali comportamenti default
    dropdownButton.classList.toggle('active');
    // Se hai un menu dropdown, qui puoi fare:
    // const menu = document.getElementById('dropdown-menu');
    // menu.classList.toggle('visible');
  });
});
