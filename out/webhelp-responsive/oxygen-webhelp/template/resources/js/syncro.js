document.addEventListener('DOMContentLoaded', function () {
  const progressEl = document.querySelector('progress');
  const fallbackBar = document.querySelector('.progress-bar');
  const progressBar = document.getElementById('progressBar');

  function getMax() {
    return document.documentElement.scrollHeight - window.innerHeight;
  }

  function getValue() {
    return window.scrollY || window.pageYOffset;
  }

  function updateProgressValue() {
    if (progressEl) {
      progressEl.max = getMax();
      progressEl.value = getValue();
    } else if (fallbackBar) {
      const width = (getValue() / getMax()) * 100;
      fallbackBar.style.width = `${width}%`;
    }
  }

  function onResize() {
    updateProgressValue();
  }

  function addActiveStyle(styleClass) {
    if (!progressBar) return;
    progressBar.className = styleClass;

    document.querySelectorAll('a').forEach(a => a.classList.remove('active'));
    const trigger = document.getElementById(styleClass);
    if (trigger) {
      trigger.classList.add('active');
    }
  }

  // Tipuri de stiluri de progres
  ['flat', 'single', 'multiple', 'semantic'].forEach(id => {
    const btn = document.getElementById(id);
    if (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        addActiveStyle(id);

        if (id === 'semantic') {
          alert('hello');
        }
      });
    }
  });

  // Inițializare stiluri implicite
  addActiveStyle('flat');

  // Scroll și resize handlers
  window.addEventListener('scroll', updateProgressValue);
  window.addEventListener('resize', onResize);

  updateProgressValue();

  // Dinamic update semantic color (fără jQuery)
  document.addEventListener('scroll', function () {
    if (!progressBar || !progressBar.classList.contains('semantic')) return;

    const maxAttr = parseFloat(progressBar.getAttribute('max')) || 1;
    const valueAttr = parseFloat(progressBar.getAttribute('value')) || 0;
    const percentage = (valueAttr / maxAttr) * 100;

    const styleSheet = document.styleSheets[0];

    function setSemanticColor(color) {
      styleSheet.insertRule(`.semantic { color: ${color}; }`, styleSheet.cssRules.length);
      styleSheet.insertRule(`.semantic::-webkit-progress-value { background-color: ${color}; }`, styleSheet.cssRules.length);
      // styleSheet.insertRule(`.semantic::-moz-progress-bar { background-color: ${color}; }`, styleSheet.cssRules.length); // dezactivat
    }

    if (percentage < 49) {
      setSemanticColor('blue');
    } else if (percentage < 98) {
      setSemanticColor('orange');
    } else {
      setSemanticColor('green');
    }
  });
});
