(function(scope) {
	
	// inspired by https://github.com/Polymer/PointerEvents/blob/master/src/PointerEvent.js
	var PointerEvent = function(type, dict) {
			
		// assume the new DOM4 event ctors (http://www.w3.org/TR/dom/#event)
		var evt = new MouseEvent(type, dict);
		
		// ensure that the event passes instanceof checks
		evt.__proto__ = PointerEvent.prototype;
		
		// define the properties of the PointerEvent interface
    Object.defineProperties(evt, {
    	pointerId: { value: dict.pointerId || 0, enumerable: true },
      width: { value: dict.width || 0, enumerable: true },
      height: { value: dict.height || 0, enumerable: true },
      pressure: { value: dict.pressure || 0, enumerable: true },
      tiltX: { value: dict.tiltX || 0, enumerable: true },
      tiltY: { value: dict.tiltY || 0, enumerable: true },
      pointerType: { value: dict.pointerType || "", enumerable: true },
      isPrimary: { value: dict.isPrimary || false, enumerable: true }
    });
		
		return evt;
	};
	
	PointerEvent.prototype = Object.create(MouseEvent.prototype);
	
	// attach to window
	scope.PointerEvent = PointerEvent;
	
	// activate pointer events (as expected by hammer.js)
	scope.navigator.pointerEnabled = true
	
})(window);

/*
	
dictionary MouseEventInit : UIEventInit {
    long           screenX = 0;
    long           screenY = 0;
    long           clientX = 0;
    long           clientY = 0;
    boolean        ctrlKey = false;
    boolean        shiftKey = false;
    boolean        altKey = false;
    boolean        metaKey = false;
    unsigned short button = 0;
    unsigned short buttons = 0;
    EventTarget?   relatedTarget = null;
};

dictionary PointerEventInit : MouseEventInit {
    long      pointerId = 0;
    long      width = 0;
    long      height = 0;
    float     pressure = 0;
    long      tiltX = 0;
    long      tiltY = 0;
    DOMString pointerType = "";
    boolean   isPrimary = false;
};


*/
