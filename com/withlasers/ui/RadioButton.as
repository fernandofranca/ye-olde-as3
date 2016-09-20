package com.withlasers.ui 
{
	import com.withlasers.ui.IRadioButton;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class RadioButton implements IRadioButton
	{
		protected var __enabled:Boolean = false
		protected var __mc:Sprite
		protected var __id:String
		protected var __text:String
		
		public var group:RadioButtonGroup
		
		public function RadioButton($mc:Sprite, $label:String, $enabled:Boolean = false) 
		{
			mc = $mc
			enabled = $enabled;
			text = $label;
			
			mc.mouseChildren = false
			mc.buttonMode = true;
			
			__setupEvents();
		}
		
		protected function __setupEvents():void
		{
			mc.addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			mc.addEventListener(MouseEvent.CLICK, __handleMouse)
			mc.addEventListener(MouseEvent.ROLL_OVER, __handleMouse)
			mc.addEventListener(MouseEvent.ROLL_OUT, __handleMouse)
			
			mc.addEventListener(FocusEvent.FOCUS_IN, __handleFocus)
			mc.addEventListener(FocusEvent.FOCUS_OUT, __handleFocus)
		}
		
		private function __handleFocus(evt:FocusEvent):void 
		{
			switch (evt.type) 
			{
				case FocusEvent.FOCUS_IN:
					__handleFocusIn()
				break
				case FocusEvent.FOCUS_OUT:
					__handleFocusOut()
				break
			}
		}
		
		protected function __removeEvents():void
		{
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			mc.removeEventListener(MouseEvent.CLICK, __handleMouse)
			mc.removeEventListener(MouseEvent.ROLL_OVER, __handleMouse)
			mc.removeEventListener(MouseEvent.ROLL_OUT, __handleMouse)
			
			mc.removeEventListener(FocusEvent.FOCUS_IN, __handleFocus)
			mc.removeEventListener(FocusEvent.FOCUS_OUT, __handleFocus)
			mc.removeEventListener(KeyboardEvent.KEY_UP, __handleKey)
		}
		
		protected function __handleRemoved(e:Event):void 
		{
			destroy();
		}
		
		protected function __handleMouse(evt:MouseEvent):void 
		{
			switch (evt.type) 
			{
				case MouseEvent.CLICK:
					group.enabledItem = this;
					__handleClick();
				break
				case MouseEvent.ROLL_OVER:
					__handleRollOver()
				break
				case MouseEvent.ROLL_OUT:
					__handleRollOut()
				break
			}
		}
		
		protected function __handleRollOut():void
		{
			mc.stage.focus = null
		}
		
		protected function __handleRollOver():void
		{
			focus()
		}
		
		protected function __handleClick():void
		{
			
		}
		
		private function __handleKey(evt:KeyboardEvent):void 
		{
			switch (evt.keyCode) 
			{
				case 39:
					group.selectNext()
				break
				
				case 37:
					group.selectPrevious()
				break
				
				case 40:
					group.selectNext()
				break
				
				case 38:
					group.selectPrevious()
				break
				
				case 32:
					group.enabledItem = this;
				break
			}
		}
		
		protected function __handleFocusIn():void
		{
			//var gr:Graphics = mc.graphics
			//gr.clear();
			//gr.beginFill(0xFFFF80, 0.5);
			//gr.drawRect(-2, -2, mc.width+4, mc.height+4);
			//gr.endFill()
			
			mc.addEventListener(KeyboardEvent.KEY_UP, __handleKey)
		}
		
		protected function __handleFocusOut():void
		{
			var gr:Graphics = mc.graphics
			gr.clear();
			
			mc.removeEventListener(KeyboardEvent.KEY_UP, __handleKey)
		}
		
		public function focus():void 
		{
			mc.stage.focus = mc;
		}
		
		public function destroy():void 
		{
			__removeEvents()
		}
		
		public function get tabIndex():Number
		{
			return mc.tabIndex
		}
		
		public function set tabIndex(value:Number):void
		{
			mc.tabIndex = value;
		}
		
		/* INTERFACE com.withlasers.ui.IRadioButton */
		
		public function get enabled():Boolean
		{
			return __enabled
		}
		
		public function set enabled(value:Boolean):void
		{
			__enabled = value;
			
			var f:int
			if (__enabled==true) 
			{
				f=2
			} else 
			{
				f=1
			}
			
			MovieClip(mc['mcIcone']).gotoAndStop(f);
		}
		
		public function get text():String
		{
			return __text
		}
		
		public function set text(value:String):void
		{
			__text = value;
			
			var tf:TextField = TextField(mc['tfLabel'])
			
			tf.text = value;
			tf.autoSize = TextFieldAutoSize.LEFT
		}
		
		public function get id():String
		{
			return __id
		}
		
		public function set id(value:String):void
		{
			__id = value;
		}
		
		public function get mc():Sprite
		{
			return __mc
		}
		
		public function set mc(value:Sprite):void
		{
			__mc = value
		}
	}

}