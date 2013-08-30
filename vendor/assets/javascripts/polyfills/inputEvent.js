// from http://benalpert.com/2013/06/18/a-near-perfect-oninput-shim-for-ie-8-and-9.html
var activeElement = null;
var activeElementValue = null;

// On focus, start watching the element
document.addEventListener("focusin", function(e) {
    var target = e.srcElement;
    if (target.nodeName !== "INPUT") return;

    // Store a reference to the focused element and its current value
    activeElement = target;
    activeElementValue = target.value;

    // Listen to the propertychange event
    activeElement.attachEvent("onpropertychange", handlePropertyChange);

    // Override .value to track changes from JavaScript
    var valueProp = Object.getOwnPropertyDescriptor(
            HTMLInputElement.prototype, 'value');
    Object.defineProperty(activeElement, {
        get: function() { return valueProp.get.call(this); },
        set: function(val) {
            activeElementValue = val;
            valueProp.set.call(this, val);
        }
    });
});

// And on blur, stop watching
document.addEventListener("focusout", function(e) {
    if (!activeElement) return;

    // Stop listening to propertychange and restore the original .value prop
    activeElement.detachEvent("onpropertychange", handlePropertyChange);
    delete activeElement.value;

    activeElement = null;
    activeElementValue = null;
});

function handlePropertyChange(e) {
    if (e.propertyName === "value" &&
            activeElementValue !== activeElement.value) {
        activeElementValue = activeElement.value;
        // Fire textchange event on activeElement
    }
};