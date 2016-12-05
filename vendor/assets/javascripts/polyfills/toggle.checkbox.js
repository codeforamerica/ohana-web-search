// Check if browser supports the :checked selector.
Modernizr.addTest('checkedselector', function() {
  return selectorSupported(':checked');
});

// If the :checked selector is not supported, the checkbox inputs
// will not be styled correctly, so show the default checkbox inputs
// and hide the stylized labels if the :checked selector is not supported.
window.onload = function() {
  if (!Modernizr.checkedselector) {
    var toggles = document.querySelectorAll('.toggle');
    var label, icon, input;
    for (var t = 0, len = toggles.length; t < len; t++) {
      input = toggles[t].querySelector('input[type=checkbox]');
      label = toggles[t].querySelector('label');
      icon = toggles[t].querySelector('.fa');
      input.style.visibility = 'inherit';
      label.style.display = 'none';
      icon.style.display = 'none';
    }

    // For inverted checkboxes append the label with 'Uncheck to ' because
    // we can't invert the appearance easily when the :checked selector
    // isn't supported.
    var inverted = document.querySelectorAll('.input-search-filter.inverted');
    var labels, text;
    for (var i = 0, len = inverted.length; i < len; i++) {
      labels = inverted[i].querySelectorAll('label');
      text = labels[labels.length-1];
      text.innerHTML = 'Uncheck to ' + text.innerHTML;
    }
  }
}