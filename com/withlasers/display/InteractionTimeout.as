package com.withlasers.display 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractionTimeout  
	{
		protected var timeoutTimer:Timer
		
		public var signalOnTimeout:Signal = new Signal();
		
		public function InteractionTimeout(target:DisplayObject, period:int=30000) 
		{
			target.addEventListener(MouseEvent.MOUSE_UP, __handleStageClick);
			
			timeoutTimer = new Timer(period);
			timeoutTimer.addEventListener(TimerEvent.TIMER, __handleTimer);
		}
		
		/**
		 * Zera o timer e inicia novamente
		 */
		public function reset():void 
		{
			timeoutTimer.stop();
			timeoutTimer.start();
		}
		
		private function __handleStageClick(e:MouseEvent):void 
		{
			reset();
		}
		
		private function __handleTimer(e:TimerEvent):void 
		{
			timeoutTimer.stop();
			
			signalOnTimeout.dispatch();
		}
		
	}

}