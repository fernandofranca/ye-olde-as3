package com.withlasers.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class UIListeners
	{
		public var target:DisplayObjectContainer
		public var rollout:Function
		public var rollover:Function
		public var click:Function
		public var removed:Function
		public var added:Function
		public var resize:Function
		public var destroyOnRemove:Boolean
		
		private var hasResize:Boolean; // possui um callback de resize registrado?
		
		public var enabled:Boolean = true; //pode ser usado para desabilitar os callbacks temporariamente
		public var lastEvent:Event // ultimo evento ocorrido. pode ser util quando for necessario obter o target do evento
		
		
		// estas propriedades sao usadas no rollover/rollout com delay
		public var delay:Number;
		protected var isOver:Boolean = false
		protected var intervalId:Number
		
		public function UIListeners($target:DisplayObjectContainer,
									$rollout:Function=null,
									$rollover:Function=null,
									$click:Function=null,
									$removed:Function=null,
									$added:Function=null,
									$resize:Function=null,
									$destroyOnRemove:Boolean=true) 
		{
			target = $target;
			rollout = $rollout;
			rollover = $rollover;
			click = $click;
			removed = $removed;
			added = $added;
			resize = $resize;
			destroyOnRemove = $destroyOnRemove;
			
			if (target is Sprite) Sprite(target).buttonMode = true; 
			
			if (rollout!=null) 		target.addEventListener(MouseEvent.ROLL_OUT, 	__handleMouseEvent);
			if (rollover!=null) 	target.addEventListener(MouseEvent.ROLL_OVER, 	__handleMouseEvent);
			if (click!=null) 		target.addEventListener(MouseEvent.CLICK, 		__handleMouseEvent);
			
			if (added!=null || resize!=null) 	target.addEventListener(Event.ADDED_TO_STAGE, 		__handleEvent);
			if (removed!=null) 					target.addEventListener(Event.REMOVED_FROM_STAGE, 	__handleEvent);
			
			if (resize!=null && target.stage!=null) target.stage.addEventListener(Event.RESIZE, __handleEvent);
		}
		
		public function destroy():void 
		{
			
			clearTimeout(intervalId);
			
			if (rollout!=null) 		target.removeEventListener(MouseEvent.ROLL_OUT, 	__handleMouseEvent);
			if (rollover!=null) 	target.removeEventListener(MouseEvent.ROLL_OVER, 	__handleMouseEvent);
			if (click!=null) 		target.removeEventListener(MouseEvent.CLICK, 		__handleMouseEvent);
			
			if (added!=null) 		target.removeEventListener(Event.ADDED_TO_STAGE, 		__handleEvent);
			if (removed!=null) 		target.removeEventListener(Event.REMOVED_FROM_STAGE, 	__handleEvent);
			
			if (resize != null && hasResize == true ) target.stage.removeEventListener(Event.RESIZE, __handleEvent);
			
			target	 	= null;
			rollout 	= null;
			rollover 	= null;
			click 		= null;
			added 		= null;
			removed 	= null;
			resize 		= null;
		}
		
		private function __handleEvent(e:Event):void 
		{
			if (enabled==false) return // esta desabilitado. nao faz nada.
			
			lastEvent = e;
			var fun:Function
			
			switch (e.type) 
			{
				case Event.ADDED_TO_STAGE:
					fun = added;
					
					if (resize != null && hasResize!=true )
					{
						target.stage.addEventListener(Event.RESIZE, __handleEvent);
						hasResize = true;
					}
					
				break
				case Event.REMOVED_FROM_STAGE:
					fun = removed
					
					if (resize != null && hasResize==true)
					{
						target.stage.removeEventListener(Event.RESIZE, __handleEvent);
						hasResize = false;
					}
					
					if (destroyOnRemove==true) destroy()
				break
				case Event.RESIZE:
					fun = resize
				break
			}
			
			
			if (fun != null) fun();
		}
		
		private function __handleMouseEvent(e:MouseEvent):void 
		{
			if (enabled == false) return // esta desabilitado. nao faz nada.
			
			lastEvent = e;
			
			switch (e.type) 
			{
				case MouseEvent.ROLL_OUT:
					
					if (delay)
					{
						isOver = false;
						
						clearTimeout(intervalId);
						intervalId = setTimeout(__checkOut, delay)
					} else 
					{
						rollout();
					}
				break
				case MouseEvent.ROLL_OVER:
					
					if (delay)
					{
						isOver = true;
						
						clearTimeout(intervalId);
						intervalId = setTimeout(__checkOver, delay)
					} else 
					{
						rollover();
					}
				break
				case MouseEvent.CLICK:
					click();
				break
			}
		}
		
		// estas funcoes sao usadas s[o no rollover/rollout com delay
		
		private function __checkOver():void
		{
			if (isOver == true) rollover();
		}
		
		private function __checkOut():void
		{
			if (isOver == false) rollout();
		}
		
	}

}