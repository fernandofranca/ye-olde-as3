package com.withlasers.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class ButtonBehaviour 
	{
		protected var instance:DisplayObjectContainer
		protected var outFun:Function 
		protected var overFun:Function
		protected var selectedOutFun:Function
		protected var selectedOverFun:Function
		protected var disabledFun:Function
		
		protected var _enabled:Boolean = true
		protected var _selected:Boolean = false
		
		public var clickedSignal:Signal = new Signal();
		public var isMouseOver:Boolean = false;
		
		public function ButtonBehaviour(instance:DisplayObjectContainer, 
											outFun:Function, 
											overFun:Function,
											selectedOutFun:Function,
											selectedOverFun:Function,
											disabledFun:Function) 
		{
			this.instance = instance
			this.outFun = outFun
			this.overFun = overFun
			this.selectedOutFun = selectedOutFun
			this.selectedOverFun = selectedOverFun
			this.disabledFun = disabledFun
			
			instance.addEventListener(MouseEvent.ROLL_OVER, __handleMouseEvents);
			instance.addEventListener(MouseEvent.ROLL_OUT, __handleMouseEvents);
			instance.addEventListener(MouseEvent.CLICK, __handleMouseEvents);
			
			
			enabled = true;
		}
		
		private function __handleMouseEvents(e:MouseEvent):void 
		{
			if (enabled == false) return
			
			switch (e.type) 
			{
				case MouseEvent.ROLL_OUT:
					isMouseOver = false;
					if (selected==true) 
					{
						selectedOutFun()
					} else 
					{
						outFun();
					}
				break
				case MouseEvent.ROLL_OVER:
					isMouseOver = true;
					if (selected==true)
					{
						selectedOverFun()
					} else 
					{
						overFun();
					}
					
				break
				case MouseEvent.CLICK:
					isMouseOver = true;
					clickedSignal.dispatch();
				break
			}
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			if (value == _enabled) return
			
			_enabled = value;
			
			Sprite(instance).buttonMode = value;
			
			instance.mouseEnabled = value;
			
			if (disabledFun!=null) 
			{
				if (value == false)
				{
					disabledFun()
				} else 
				{
					outFun();
				}
			}
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			if (value == _selected) return
			
			_selected = value;
			
			if (value==true) 
			{
				isMouseOver == true?selectedOverFun():selectedOutFun();
			} else 
			{
				isMouseOver == true?overFun():outFun();
			}
		}
		
		public function destroy():void 
		{
			instance.removeEventListener(MouseEvent.ROLL_OVER, __handleMouseEvents);
			instance.removeEventListener(MouseEvent.ROLL_OUT, __handleMouseEvents);
			instance.removeEventListener(MouseEvent.CLICK, __handleMouseEvents);
			instance = null;
			
			outFun = overFun = selectedOutFun = selectedOverFun = disabledFun = null;
			
			clickedSignal.removeAll();
		}
		
	}
	
}