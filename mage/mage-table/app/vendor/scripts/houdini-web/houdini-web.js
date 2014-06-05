(function(scope) {

  /* Models */
	
	function TUIOInput(attrs) {
    // overwrite in concrete subclass
	  this.pointerType = undefined;
	  
    this.update(attrs);
	}
	
	TUIOInput.prototype.update = function(attrs) {
	  for(var key in attrs) {
		  if (attrs.hasOwnProperty(key)) {
		    this[key] = attrs[key];
		  }
		}
	}
	
	TUIOInput.prototype.getPointerType = function() {
	  return this.pointerType;
	}
	
	function TUIOTouch(attrs) {
	  TUIOInput.call(this, attrs)
	  this.pointerType = "touch";
	}
	
	TUIOTouch.prototype = Object.create(TUIOInput.prototype);
	
	
	function TUIOObject(attrs) {
	  TUIOInput.call(this, attrs)
	  this.pointerType = "object";
	}

  TUIOObject.prototype = Object.create(TUIOInput.prototype);


	/* Profiles */
	
	function TUIOProfileProcessor(modelCtor) {
	  this.active = {};
	  this.ModelCtor = modelCtor;
	}
	
	TUIOProfileProcessor.prototype.getAttrsFromSetMessage = function(setMessage) {
	  // overwrite in concrete subclass
	}
	
	TUIOProfileProcessor.prototype.processMessage = function(message) {
    switch(message.messageType) {
			case "set":
				this.processSetMessage(message)
				break;
			case "alive":
				this.processAliveMessage(message)
				break;
		  case "fseq":
				this.processFSeqMessage(message)
				break;
		}
	}
	
	TUIOProfileProcessor.prototype.processSetMessage = function(setMessage) {
	  var sessionId = setMessage.sessionId,
		    attrs = this.getAttrsFromSetMessage(setMessage),
		    model, eventType;
		
    if(this.active[sessionId] === undefined) {
			// => create new touch point
			model = new this.ModelCtor(attrs);
			this.active[sessionId] = model;
			eventType = EventTypes.POINTER_DOWN;
		} else {
		  // => update existing touch point
			model = this.active[sessionId];
			model.update(attrs);
			eventType = EventTypes.POINTER_MOVE;
		}

		createAndDispatchPointerEvent(eventType, model);
	};
	
	TUIOProfileProcessor.prototype.processAliveMessage = function(aliveMessage) {
	  var aliveIds = aliveMessage.sessionIds,
	      sessionId, touch;
		
		for(var key in this.active) {
		  if (this.active.hasOwnProperty(key)) {
		    // key will be a string (WAT.JS :-)
		    sessionId = parseInt(key);
		    
		    if(aliveIds.indexOf(parseInt(sessionId)) < 0) {
  				// remove touch
  				model = this.active[sessionId];
  				createAndDispatchPointerEvent(EventTypes.POINTER_UP, model);
  				delete this.active[sessionId];
  			}
		  }
		}
	};
	
	TUIOProfileProcessor.prototype.processFSeqMessage = function(fseqMessage) {
	  // do nothing (for now?)
	};
	
	
	function Profile2DBlbProcessor() {
	  TUIOProfileProcessor.call(this, TUIOTouch);
	}
	
	Profile2DBlbProcessor.prototype = Object.create(TUIOProfileProcessor.prototype);
	
	Profile2DBlbProcessor.prototype.getAttrsFromSetMessage = function(setMessage) {
	  return {
      sessionId: setMessage.sessionId,
  	  x: setMessage.xPos,
  	  y: setMessage.yPos,
  	  xVelocity: setMessage.xVelocity,
  	  yVelocity: setMessage.yVelocity,
  	  motionAcceleration: setMessage.motionAcceleration,
  	  area: setMessage.area,
  	  width: setMessage.width,
  	  height: setMessage.height,
  	  angle: setMessage.angle,
  	  rotationVelocity: setMessage.rotationVelocity,
  	  rotationAcceleration: setMessage.rotationAcceleration
    };
	};
	
	function Profile2DObjProcessor() {
	  TUIOProfileProcessor.call(this, TUIOObject);
	};
	
	Profile2DObjProcessor.prototype = Object.create(TUIOProfileProcessor.prototype);
	
	Profile2DObjProcessor.prototype.getAttrsFromSetMessage = function(setMessage) {
	  return {
	    sessionId: setMessage.sessionId,
      markerId: setMessage.markerId,
  	  x: setMessage.xPos,
  	  y: setMessage.yPos,
  	  xVelocity: setMessage.xVelocity,
  	  yVelocity: setMessage.yVelocity,
  	  motionAcceleration: setMessage.motionAcceleration,
  	  angle: setMessage.angle,
  	  rotationVelocity: setMessage.rotationVelocity,
  	  rotationAcceleration: setMessage.rotationAcceleration
	  };
	};
	
	
	/* Events */
	
	var EventTypes = {
	  POINTER_DOWN: "pointerdown",
    POINTER_UP: "pointerup",
    POINTER_CANCEL: "pointercancel",
    POINTER_MOVE: "pointermove"
	};
	
	function createAndDispatchPointerEvent(type, tuioInput) {
    var coords = tuioToClientCoords(tuioInput.x, tuioInput.y),
    		target = getElementAt(coords.pageX, coords.pageY),
    		evt;

	  evt = new PointerEvent(type, {
	    pointerType: tuioInput.getPointerType(),
	    pointerId: tuioInput.sessionId,
	    screenX: coords.screenX,
	    screenY: coords.screenY,
	    clientX: coords.clientX,
	    clientY: coords.clientY,
	    target: target,
	    /**
       * For now, we only dispatch pointer[down|up|cancel|move] events,
       * which all bubble and are cancellable. If we want to dispatch other
       * events, we need to check if they also bubble and are cancellable:
       * http://www.w3.org/TR/pointerevents/#pointer-event-types
       */
  		bubbles: true,
  		cancelable: true
	  });
	  
	  evt.tuioSource = tuioInput;
	  
	  target.dispatchEvent(evt);
	}
	
	function tuioToClientCoords(x, y) {
	  return {
	    screenX: screen.width * x,
	    screenY: screen.height * y,
  		clientX: window.innerWidth * x,
  		clientY: window.innerHeight * y,
      pageX: document.documentElement.clientWidth * x,
      pageY: document.documentElement.clientHeight * y
	  };
	}
	
	function getElementAt(pageX, pageY) {
	  return document.elementFromPoint(pageX, pageY) || document;
	}


  var blobProcessor = new Profile2DBlbProcessor(),
      objectProcessor = new Profile2DObjProcessor();

  var _started = false;

  window.Houdini = {
    
    start: function(uri) {
      return new Promise(function(resolve, reject) {
        if(_started) return;

        _started = true;
    
        // -- Let the MAGIC happen :-) ----------------------

        var uri = uri || "http://localhost:8080/houdini",
            tuioSource = new EventSource(uri);

        tuioSource.onopen = function(evt) {
          resolve();
        };

        tuioSource.onerror = function(err) {
          reject();
        };

        tuioSource.addEventListener("tuio", function(tuioEvent) {
          processPacket(JSON.parse(tuioEvent.data));
        });
      });
    }

  };

 
  function processPacket(packet) {
    if(packet.packetType == "bundle") {
      processBundle(packet);
    } else {
      processMessage(packet);
    }
  }

  function processBundle(bundle) {
    bundle.packets.forEach(processMessage);
  }
    
  function processMessage(message) {
    switch(message.profile) {
      case "/tuio/2Dblb":
        blobProcessor.processMessage(message);
        break;
      case "/tuio/2Dobj":
        objectProcessor.processMessage(message);
        break;
    }
  }

})(window);
