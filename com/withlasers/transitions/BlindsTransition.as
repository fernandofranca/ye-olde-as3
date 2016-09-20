/*

	var tr:BlindsTransition = new BlindsTransition(bmp2, 15, BlindsTransition.TIPO_SLASH_BACK )
	tr.transition(true, 1, 0, 0.01, BlindsTransition.ORDEM_DIR_ESQ, null);
	tr.onComplete = test1;
	tr.addEventListener(BlindsTransition.TRANSITION_COMPLETE_EVENT, function ():void 
	{
		Main.trace('fim');
	})
	
*/

package com.withlasers.transitions 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class BlindsTransition extends EventDispatcher
	{
		public static const TIPO_VERTICAL:String = 'TIPO_VERTICAL'
		public static const TIPO_FORWARD:String = 'TIPO_FORWARD'
		public static const TIPO_BACK:String = 'TIPO_BACK'
		
		public static const ORDEM_ESQ_DIR:String = 'ORDEM_ESQ_DIR'
		public static const ORDEM_DIR_ESQ:String = 'ORDEM_DIR_ESQ'
		
		public static const TRANSITION_COMPLETE_EVENT:String = 'TRANSITION_COMPLETE_EVENT'
		
		public var onComplete:Function
		public var onCompleteParams:Array
		
		protected var target:DisplayObject
		protected var pieceWidth:Number
		protected var tipo:String
		protected var width:Number
		protected var height:Number
		
		protected var arrPieces:Array
		protected var maskContainer:Sprite;
		protected var timer:Timer
		
		
		public function BlindsTransition($tgt:DisplayObject, $pieceWidth:Number=15, $tipo:String=null, $width:Number=0, $height:Number=0) 
		{
			target = $tgt;
			pieceWidth = $pieceWidth;
			tipo = $tipo;
			width = $width;
			height = $height;
			
			
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, __handleTimerComplete)
			
			__buildPieces()
		}
		
		protected function __buildPieces():void
		{
			
			var dw:Number = width==0?target.width:width
			var dh:Number = height==0?target.height:height
			var nw:Number = pieceWidth
			var steps:int = Math.ceil(dw / nw);
			
			arrPieces = []
			
			maskContainer = new Sprite();
			DisplayObjectContainer(target.parent).addChild(maskContainer);
			
			var shape:Shape
			var gr:Graphics
			for (var i:int = 0; i < steps; i++) 
			{
				shape = new Shape();
				gr = shape.graphics;
				gr.beginFill(0x000000, 1)
				gr.drawRect(0, 0, nw, dh);
				gr.endFill();
				
				shape.x = i * nw
				maskContainer.addChild(shape);
				arrPieces.push(shape)
			}
			
			switch (tipo) 
			{
				case BlindsTransition.TIPO_BACK:
					maskContainer.transform.matrix = new Matrix(1.5, 0, 1, 1, ((dw*0.5)*-1)+target.x, target.y); //normal
				break
				case BlindsTransition.TIPO_FORWARD:
					maskContainer.transform.matrix = new Matrix(1.5, 0, -1, 1, target.x, target.y); // invertido
				break
				
			}
			
			target.mask = maskContainer;
		}
		
		public function transition($transitionIn:Boolean, $time:Number, $delay:Number=0, $interval:Number=0.02, $ordem:String=null, $easing:Function=null):void 
		{
			if ($easing == null) $easing = Linear.easeNone
			if ($ordem == null) $ordem = ORDEM_ESQ_DIR
			
			var i:int
			var j:int
			var shape:Shape
			var totalDelay:Number
			
			
			var transitionFun:String = $transitionIn == true?'from':'to';
			
			if ($ordem==ORDEM_ESQ_DIR) 
			{
				for (i = 0; i < arrPieces.length; i++) 
				{
					shape = Shape(arrPieces[i]);
					TweenMax[transitionFun](shape, $time, { scaleX:0, delay:$delay + ($interval * i), ease:$easing } );
				}
				
				totalDelay = (($delay + ($interval * i)) + $time) * 1000;
				__startTimer(totalDelay);
				
			} else if ($ordem==ORDEM_DIR_ESQ) 
			{
				j = 0;
				for (i = arrPieces.length-1; i > -1; i--) 
				{
					shape = Shape(arrPieces[i]);
					TweenMax[transitionFun](shape, $time, { scaleX:0, delay:$delay + ($interval * j), ease:$easing } );
					j++
				}
				
				totalDelay = (($delay + ($interval * j)) + $time) * 1000;
				__startTimer(totalDelay);
			}
		}
		
		protected function __startTimer($delay:Number):void 
		{
			if (timer) timer.stop();
			timer.delay = $delay;
			timer.reset();
			timer.start();
		}
		
		protected function __handleTimerComplete(e:TimerEvent):void 
		{
			dispatchEvent(new Event(BlindsTransition.TRANSITION_COMPLETE_EVENT));
			
			if (onComplete!=null) 
			{
				try {
					onComplete.apply(null, onCompleteParams);
				} catch (e:Error){
					trace(e);
				}
			}
		}
		
		public function stopTransition():void 
		{
			for (var i:int = 0; i < arrPieces.length; i++) 
			{
				TweenMax.killTweensOf(arrPieces[i]);
			}
		}
		
		public function destroy():void 
		{
			stopTransition();
			
			timer.stop();
			timer.addEventListener(TimerEvent.TIMER, __handleTimerComplete);
			timer = null;
			
			onComplete = null;
			onCompleteParams = null;
			
			target.mask = null;
			DisplayObjectContainer(target.parent).removeChild(maskContainer);
		}
	}
}