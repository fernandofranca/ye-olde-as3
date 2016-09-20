/**
	var anim:TextAnimator = new TextAnimator(tf);
	var txt:String = 'Todas as chamadas subseqüentes a métodos ou propriedades dessa ocorrência de BitmapData';
	anim.start(txt, 0.5, 0.5);
 */
package com.withlasers.display
{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.utils.Timer;
	import gs.easing.Expo;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class TextAnimator
	{
		private var tf:TextField;
		private var texto:String
		
		public var pos:int = 0
		public var onComplete:Function
		public var customAnimator:Function
		
		public function TextAnimator($tf:TextField) 
		{
			tf = $tf;
		}
		
		public function start($texto:String, $duration:Number=1, $delay:Number=0, $ease:Function=null):void 
		{
			stop();
			
			texto = $texto;
			
			pos = 1;
			
			if($ease==null) $ease = Expo.easeInOut
			
			TweenMax.to(this, $duration, { pos:$texto.length, delay:$delay, onUpdate:__handleUpdate, onComplete:__handleComplete, ease:$ease } );
		}
		
		public function stop():void 
		{
			TweenMax.killTweensOf(this);
		}
		
		/**
		 * Para tudo e remove referencias
		 */
		public function remove():void 
		{
			stop();
			tf = null;
			onComplete = null
			customAnimator = null
		}
		
		private function __handleUpdate():void
		{
			__animate(tf, texto, pos);
		}
		
		private function __handleComplete():void
		{
			tf.text = texto;
			
			if (onComplete!=null) 
			{
				try {
					onComplete()
				} catch (e:Error){ }
			}
		}
		
		
		/**
		 * Funcao que faz a animacao. Pode ser sobrescrita
		 */
		protected function __animate($tf:TextField, $texto:String, $count:int):void
		{
			if (customAnimator==null) 
			{
				$tf.text = $texto.substr(0, $count - 1);
				var l:String = String.fromCharCode(Math.round(Math.random()*27)+65)
				$tf.appendText(' ['+l+']');
				$tf.appendText($texto.substr($count - 1, $count));
			} else 
			{
				customAnimator($tf, $texto, $count);
			}
		}
		
	}

}