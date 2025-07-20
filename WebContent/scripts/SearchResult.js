document.addEventListener('DOMContentLoaded', function() {
  var form = document.querySelector('.search-form');
  var input = document.getElementById('search-input');
  var container = document.getElementById('search-results');

  form.addEventListener('submit', function(e) {
    e.preventDefault();
    var q = input.value.trim();
    if (!q) return;

    var xhr = new XMLHttpRequest();
    var url = form.getAttribute('action') || 
              window.location.pathname.replace(/\/[^/]+\.jsp$/, '') + '/searchservlet';
    url += '?search-query=' + encodeURIComponent(q);

    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          container.innerHTML = xhr.responseText;
        } else {
          container.innerHTML = '<p style="color:red;">Errore nella ricerca.</p>';
        }
      }
    };
    xhr.send();
  });
});
