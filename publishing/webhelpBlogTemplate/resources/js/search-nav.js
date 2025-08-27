document.addEventListener('DOMContentLoaded', function () {
//  console.log("test");
    
  const searchIcon = document.querySelector('.icn_qSearch');
  const closeSearchIcon = document.querySelector('.icn_qSearch_remove');
  const searchForm = document.getElementById('searchForm');
  const searchContainer = document.querySelector('.wh_search_input');
  const topMenuContainer = document.querySelector('.wh_top_menu_and_indexterms_link');
  
    // creeaza butonul
  const newButton = document.createElement("button");
  newButton.textContent = "";
  newButton.type = "button"; 

  // seteaza stilurile
  newButton.style.width = "150px"; 
  newButton.style.display = "none";

  // adauga în formular
  searchForm.appendChild(newButton);
  
  
  function showSearch() {
    if (!searchIcon || !searchForm || !searchContainer || !topMenuContainer) return;

    searchIcon.style.display = 'none';
    searchForm.classList.add('expanded');
    searchContainer.classList.add('showSearch');
    topMenuContainer.classList.add('hidden');
    searchForm.style.display = 'block';

    const input = searchForm.querySelector('input');
    if (input) input.focus();

    if (closeSearchIcon) {
      closeSearchIcon.style.display = 'inline-block';
    }
  }

  function hideSearch() {
    if (!searchForm || !searchContainer || !topMenuContainer || !searchIcon) return;

    searchForm.classList.remove('expanded');
    searchContainer.classList.remove('showSearch');
    topMenuContainer.classList.remove('hidden');
    searchForm.style.display = 'none';

    if (searchIcon) {
      searchIcon.style.display = 'initial';
    }
    if (closeSearchIcon) {
      closeSearchIcon.style.display = 'none';
    }
  }

  if (searchIcon) {
    searchIcon.addEventListener('click', function (e) {
      e.stopPropagation();
      //console.log("test")
      showSearch();
    });
  }

  if (closeSearchIcon) {
    closeSearchIcon.addEventListener('click', function (e) {
      e.stopPropagation();
      hideSearch();
    });
  }

  // Click în afara formularului închide căutarea
  document.addEventListener('click', function (e) {
    if (
      !searchForm.contains(e.target) &&
      !searchIcon.contains(e.target) &&
      (!closeSearchIcon || !closeSearchIcon.contains(e.target))
    ) {
      hideSearch();
    }
  });
});
