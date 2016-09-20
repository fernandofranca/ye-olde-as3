package gfx {
	import flash.display.*
	import flash.events.*;
	import flash.text.*;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class FormCampoSelectItem extends FormCampoSelectItemDesign implements IFormCampoSelectItem {
		
		public static const COLOR_OUT:String = 'out'
		public static const COLOR_OVER:String = 'over'
		
		private var __rollover:Number = 0;
		private var __value:String
		private var __id:String
		
		private var __mc:Sprite
		
		public function FormCampoSelectItem() {
			mc = this;
			mouseChildren = false
			
			addEventListener(MouseEvent.ROLL_OVER, __handleMouseEvent)
			addEventListener(MouseEvent.ROLL_OUT, __handleMouseEvent)
			addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved)
			
			rollover = 0;
		}
		
		private function __handleMouseEvent($evt:MouseEvent):void {
			switch ($evt.type) {
				case MouseEvent.ROLL_OVER:
					rollover = 1;
				break
				case MouseEvent.ROLL_OUT:
					rollover = 0;
				break
			}
		}
		
		public function get rollover():Number { return __rollover; }
		public function set rollover(value:Number):void {
			__rollover = value;
			
			var corBack:Number
			var corFront:Number
			
			if (value==1) {
				setColor(COLOR_OVER);
			} else {
				setColor(COLOR_OUT);
			}
		}
		
		private function __handleRemoved(e:Event):void {
			removeEventListener(MouseEvent.ROLL_OVER, __handleMouseEvent)
			removeEventListener(MouseEvent.ROLL_OUT, __handleMouseEvent)
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
		}
		
		// implementacao da interface -->
		public function get text():String {
			return tf.text;
		}
		public function set text(value:String):void {
			tf.text = value
		}
		
		public function get value():String { 
			return __value
		}
		public function set value(t:String):void {
			__value = t;
		}
		
		public function get id():String { 
			return __id
		}
		public function set id(value:String):void { 
			__id = value
		}
		
		public function get mc():Sprite { return __mc; }
		public function set mc(value:Sprite):void {
			__mc = value;
		}
		
		// <-- implementacao da interface
		
		public function setColor($color:String, $tempo:Number = 0.3):void {
			var colorFront:Number
			var colorBack:Number
			
			switch ($color) {
				case COLOR_OUT:
					colorFront = 0xffffff// Main.app.themeManager.getProp('FormCampoSelectItem', 'colorFrontOut'); 
					colorBack = 0x333333//Main.app.themeManager.getProp('FormCampoSelectItem', 'colorBackOut'); 
				break
				case COLOR_OVER:
					colorFront = 0x333333//Main.app.themeManager.getProp('FormCampoSelectItem', 'colorFrontOver'); 
					colorBack = 0xffffff//Main.app.themeManager.getProp('FormCampoSelectItem', 'colorBackOver'); 
				break
			}
			
			__setColorFront(colorFront, $tempo);
			__setColorBack(colorBack, $tempo);
		}
		
		public function __setColorFront($color:Number, $tempo:Number = 0.3):void {
			TweenMax.to(tf, $tempo, {tint:$color});
		}
		
		public function __setColorBack($color:Number, $tempo:Number = 0.3):void {
			TweenMax.to(mcBack, $tempo, {tint:$color});
		}
	}
	
}