<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8" />
<title>Navbar Circolare</title>
<style>
  @charset "UTF-8";

  :root {
    --nav-bg:     rgb(255, 255, 255);
    --link-color: #708090;
    --link-hover: #2C6FA0;
    --underline:  #A6D4C9;
    --circle-bg:  #DCECFB; /* azzurro chiaro per i cerchi */
  }

  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--nav-bg);
  }

  nav {
    background-color: var(--nav-bg);
    padding: 1rem 0;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  }

  .nav-list {
    list-style: none;
    display: flex;
    justify-content: space-around;
    align-items: center;
    margin: 0;
    padding: 0 1rem;
    flex-wrap: wrap;
  }

  .nav-list li {
    margin: 1rem 0;
  }

  .nav-list a {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 130px;
    height: 130px;
    background-color: var(--circle-bg);
    color: var(--link-color);
    text-decoration: none;
    border-radius: 50%;
    font-weight: 600;
    font-size: 1.1rem;
    box-shadow: 0 3px 8px rgba(0,0,0,0.12);
    transition: all 0.3s ease;
    text-align: center;
    padding: 0 10px;
  }

  .nav-list a:hover,
  .nav-list a:focus {
    color: var(--link-hover);
    box-shadow: 0 6px 12px rgba(44, 111, 160, 0.4);
    background-color: var(--underline);
    cursor: pointer;
  }

  /* testo multilinea centrato */
  .nav-list a {
    line-height: 1.2;
  }

  /* Responsive per schermi piccoli */
  @media (max-width: 768px) {
    .nav-list a {
      width: 100px;
      height: 100px;
      font-size: 1rem;
      padding: 0 8px;
    }
  }

  @media (max-width: 480px) {
    .nav-list {
      justify-content: center;
      gap: 15px;
    }
    .nav-list a {
      width: 80px;
      height: 80px;
      font-size: 0.9rem;
      padding: 0 6px;
    }
  }
</style>
</head>
<body>

<nav>
  <ul class="nav-list">
    <li><a href="#bestseller-carousel">Bestseller</a></li>
    <li><a href="#comingsoon-carousel">Coming soon</a></li>
    <li><a href="#">Art</a></li>
    <li><a href="#">Sci-Fi</a></li>
    <li><a href="#">History</a></li>
    <li><a href="#">Narrative</a></li>
    <li><a href="#">Technology</a></li>
    <li><a href="#">Kids</a></li>
  </ul>
</nav>

</body>
</html>
