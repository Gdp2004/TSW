document.addEventListener('DOMContentLoaded', () => {
  const dropdownButton = document.getElementById('dropdown-button');
  dropdownButton.addEventListener('click', e => {
    e.preventDefault();
    dropdownButton.classList.toggle('active');
  });
});