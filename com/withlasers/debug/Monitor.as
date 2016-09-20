/**


	var f:Function = function ():String {
		var arr:Array = [':', getTimer(), this['currentFrame']]
		return arr.join('  ');
	}
	
	var m:Monitor = new Monitor(stage, f, 100);


*/

package com.withlasers.debug {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 */
	public class Monitor extends MovieClip  {
		
		private var __tf:TextField = new TextField();
		private var __timerTf:Timer
		private var __updateFunction:Function
		
		
		public function Monitor($stageRef:Stage, $updateFunction:Function, $intervalo:int = 100):void {
			
			__updateFunction = $updateFunction;
			
			__tf.textColor = 0x666666;
			__tf.autoSize = TextFieldAutoSize.LEFT;
			__tf.selectable = false;
			__tf.mouseEnabled = false;
			
			addChild(__tf);
			
			$stageRef.addChild(this);
			
			__timerTf = new Timer($intervalo);
			__timerTf.addEventListener(TimerEvent.TIMER, __update);
			__timerTf.start();
		}
		
		private function __update(e:TimerEvent):void {
			__tf.text = __updateFunction();
		}
		
		
		
		
		
		override public function stop():void {
			__timerTf.stop();
		}
		
		public function start():void {
			__timerTf.start();
		}
		
		public function remove():void {
			stop();
			
			stage.removeChild(this);
		}
		
		
		
		public function get textColor():Number { return __tf.textColor; }
		public function set textColor(value:Number):void {
			__tf.textColor = value;
		}
	}
	
}