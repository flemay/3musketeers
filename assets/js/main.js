document.addEventListener('DOMContentLoaded', () => {
  const navbarBurger = document.getElementById("navbar-burger");
  const navbarLinksMenu = document.getElementById("nav-show-hide");
  navbarBurger.addEventListener('click', () => {
    navbarLinksMenu.classList.toggle('hidden');
  });
});