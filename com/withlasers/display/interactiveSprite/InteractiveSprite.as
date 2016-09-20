package  com.withlasers.display.interactiveSprite
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractiveSprite extends Sprite
	{
		
		protected var __onClick:Function
		protected var __selected:Boolean = false
		protected var __selectable:Boolean = false;
		protected var __hitSprite:Sprite;
		protected var __design:DisplayObject
		
		public var renderOver:Function = emptyFunction;
		public var renderOut:Function = emptyFunction;
		public var renderClick:Function = emptyFunction;
		public var renderSelected:Function = emptyFunction;
		public var renderUnselected:Function = emptyFunction;
		public var renderEnabled:Function = emptyFunction;
		public var renderDisabled:Function = emptyFunction;
		
		public function InteractiveSprite() 
		{
			__addListeners();
		}
		
		protected function __addListeners():void
		{
			addEventListener(MouseEvent.CLICK, __handleEvents)
			addEventListener(MouseEvent.ROLL_OVER, __handleEvents)
			addEventListener(MouseEvent.ROLL_OUT, __handleEvents)
			addEventListener(Event.REMOVED_FROM_STAGE, __removeListeners)
		}
		
		protected function __removeListeners(e:Event=null):void 
		{
			removeEventListener(MouseEvent.CLICK, __handleEvents)
			removeEventListener(MouseEvent.ROLL_OVER, __handleEvents)
			removeEventListener(MouseEvent.ROLL_OUT, __handleEvents)
			removeEventListener(Event.REMOVED_FROM_STAGE, __removeListeners);
		}
		
		protected function __handleEvents(e:MouseEvent):void 
		{
			if (selected == true) return
			
			switch (e.type) 
			{
				case MouseEvent.CLICK:
					if (selectable == true) 
					{
						selected = true;
						dispatchEvent(new InteractiveSpriteEvent(InteractiveSpriteEvent.ON_SELECT, this));
						renderSelected();
					} else 
					{
						renderClick()
					}
					
					__clickCallBack()
					
				break
				case MouseEvent.ROLL_OVER:
					renderOver();
				break
				case MouseEvent.ROLL_OUT:
					renderOut();
				break
			}
		}
		
		protected function __clickCallBack():void
		{
			if (onClick == null) return
			
			try {
				onClick()
			} catch (e:Error){
				trace(e);
			}
		}
		
		private function emptyFunction():void 
		{
			trace('emptyFunction');
		}
		
		
		public function setHitArea($x:Number, $y:Number, $w:Number, $h:Number):void 
		{
			if (__hitSprite == null) __hitSprite = new Sprite();
			
			__hitSprite.name = '__hitSprite';
			
			var gr:Graphics = __hitSprite.graphics
			
			gr.beginFill(0x000080, 1);
			gr.drawRect($x, $y, $w, $h);
			gr.endFill()
			
			addChildAt(__hitSprite, numChildren);
			
			hitArea = Sprite(__hitSprite);
			__hitSprite.visible = false
		}
		
		public function get design():DisplayObject { return __design; }
		public function set design(value:DisplayObject):void 
		{
			__design = value;
			addChildAt(value, 0)
		}
		
		public function get onClick():Function { return __onClick; }
		public function set onClick(value:Function):void 
		{
			__onClick = value;
			
			if (value == null) 
			{
				buttonMode = false;
			} else 
			{
				buttonMode = true;
			}
		}
		
		public function get selected():Boolean { return __selected; }
		public function set selected(value:Boolean):void 
		{
			__selected = value;
			
			if (value==true) 
			{
				buttonMode = false;
				renderSelected();
			} else 
			{
				buttonMode = true;
				renderUnselected();
			}
		}
		
		public function get selectable():Boolean { return __selectable; }
		public function set selectable(value:Boolean):void 
		{
			__selectable = value;
			
			if (value==true) buttonMode = true;
			
		}
		
		public function get bottom():Number
		{
			return y+height
		}
		
		public function get right():Number
		{
			return x+width
		}
		
	}

}