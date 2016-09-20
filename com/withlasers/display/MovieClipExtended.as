package com.withlasers.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class MovieClipExtended extends MovieClip {
		/**
		 * Dispara na mudança de width ou height
		 */
		public static const EVENT_RESIZE:String = 'EVENT_RESIZE';
		
		
		
		public var rectMask:Rectangle = new Rectangle(0, 0, 50, 50);
		
		public function MovieClipExtended() {
			scrollRect = rectMask;
		}
		
		public function get backgroundColor():Number { return Number(opaqueBackground); }
		
		public function set backgroundColor(value:Number):void {
			opaqueBackground = value;
		}
		
		public function get widthReal():Number { return super.width; }
		
		public function set widthReal(value:Number):void {
			super.width = value;
		}
		
		public function get heightReal():Number { return super.height; }
		
		public function set heightReal(value:Number):void {
			super.height = value;
		}
		
		
		/**
		 * Medida baseada na mascara
		 * scaleX continua funcionando como antes
		 */
		override public function get width():Number { return rectMask.width; }
		override public function set width(value:Number):void {
			rectMask.width = value;
			scrollRect = rectMask;
			dispatchEvent(new Event(EVENT_RESIZE, true));
		}
		
		/**
		 * Medida baseada na mascara
		 * scaleY continua funcionando como antes
		 */
		override public function get height():Number { return rectMask.height; }
		override public function set height(value:Number):void {
			rectMask.height = value;
			scrollRect = rectMask;
			dispatchEvent(new Event(EVENT_RESIZE, true));
		}
		
		/**
		 * Valores positivos empurram para a direita
		 */
		public function get scrollX():Number { return rectMask.x; }
		public function set scrollX(value:Number):void {
			rectMask.x = value;
			scrollRect = rectMask;
		}
		
		/**
		 * Valores positivos empurram para baixo
		 */
		public function get scrollY():Number { return rectMask.y; }
		public function set scrollY(value:Number):void {
			rectMask.y = value;
			scrollRect = rectMask;
		}
		
		/**
		 * se alpha for 0 deixa oculto
		 */
		override public function get alpha():Number { return super.alpha; }
		override public function set alpha(value:Number):void {
			super.alpha = value;
			
			visible = !value == 0;
			
		}
		
		public function get right():Number{
			return x + width;
		}
		
		public function get bottom():Number{
			return y + height;
		}
	}
	
}