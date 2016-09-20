/*
	var t:Transition = new Transition();
	t.setOut(rect, {alpha:0, x:0, ease:Bounce.easeOut}, function():void { log('out ok') } );
	t.setIn(rect2, { alpha:0, x:0, ease:Expo.easeInOut }, function():void { log('in ok') } );
	t.start(1, 1);
*/
package com.withlasers.transitions
{
	import gs.easing.Linear;
	import gs.TweenMax;
	
	/**
	 * Faz as transições de dois elementos e suporta o callback para ambas transicoes
	 * @author Fernando de França
	 */
	public class Transition
	{
		protected var outTarget:*
		protected var outProps:*
		protected var outCallback:Function
		protected var outTween:TweenMax
		
		protected var inTarget:*
		protected var inProps:*
		protected var inCallback:Function
		protected var inTween:TweenMax
		
		public function Transition() 
		{
		}
		
		/**
		 * Transição com valores de destino (TO)
		 * @param	$target
		 * @param	$toProps	{ alpha:0, x:0, ease:Expo.easeInOut }
		 * @param	$callback
		 */
		public function setOut($target:*, $toProps:*, $callback:Function=null):void 
		{
			outTarget = $target;
			outProps = $toProps;
			outCallback = $callback;
		}
		
		/**
		 * Transição com valores de origem (FROM)
		 * @param	$target
		 * @param	$fromProps	{ alpha:0, x:0, ease:Expo.easeInOut }
		 * @param	$callback
		 */
		public function setIn($target:*, $fromProps:*, $callback:Function=null):void 
		{
			inTarget = $target;
			inProps = $fromProps;
			inCallback = $callback;
		}
		
		public function start($time:Number = 1, $delay:Number = 0):void 
		{
			var t1:* = { }
			t1.onComplete = outCallback;
			t1.delay = $delay;
			t1.ease = Linear.easeNone;
			for (var propName:String in outProps) {
				t1[propName] = outProps[propName]
			}
			
			outTween = TweenMax.to(outTarget, $time, t1 );
			
			
			var t2:* = { }
			t2.onComplete = inCallback;
			t2.delay = $delay+$time;
			t2.ease = Linear.easeNone;
			for (propName in inProps) {
				t2[propName] = inProps[propName]
			}
			
			inTween = TweenMax.from(inTarget, $time, t2 );
		}
		
		public function stop():void 
		{
			TweenMax.killTweensOf(outTarget);
			TweenMax.killTweensOf(inTarget);
		}
		
		public function pause():void 
		{
			outTween.pause();
			inTween.pause();
		}
		
		public function resume():void 
		{
			outTween.resume();
			inTween.resume();
		}
		
		public function destroy():void 
		{
			stop();
			
			outTarget = null;
			outProps = null;
			outCallback = null;
			outTween = null;
			
			inTarget = null;
			inProps = null;
			inCallback = null;
			inTween = null;
		}
	}

}