package com.lexinote.utilities
{
	import mx.controls.Button;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class EnterButton extends Button {
	    override protected function keyDownHandler(event:KeyboardEvent):void {
	        if (event.keyCode == Keyboard.ENTER) {
	            event.keyCode = Keyboard.SPACE;
	        }
	        super.keyDownHandler(event);
	    }
	    
	    override protected function keyUpHandler(event:KeyboardEvent):void {
	        if (event.keyCode == Keyboard.ENTER) {
	            event.keyCode = Keyboard.SPACE;
	        }
	        super.keyUpHandler(event);
	    }
	}
}

