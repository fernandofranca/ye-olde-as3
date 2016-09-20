package com.withlasers.display 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class BitmapPattern extends Shape
	{
		private var __width:Number
		private var __height:Number
		private var bmpData:BitmapData
		private var tx:int = 0;
		private var ty:int = 0;
		private var ox:Number = 0;
		private var oy:Number = 0;
		private var matrix:Matrix = new Matrix(1, 0, 0, 1, tx, ty);
		
		public var destroyOnRemoved:Boolean
		
		public function BitmapPattern($bmpData:BitmapData, $width:Number, $height:Number, $destroyOnRemoved:Boolean=true) 
		{
			bmpData = $bmpData;
			
			destroyOnRemoved = $destroyOnRemoved;
			
			__width = $width;
			__height = $height;
			
			__redraw();
			
			addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved)
		}
		
		private function __handleRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			
			if (destroyOnRemoved) destroy()
		}
		
		private function __redraw():void
		{
			
			var w:Number = bmpData.width;
			var h:Number = bmpData.height;
			
			// checa se esta fazendo um loop, para evitar deslocamentos de valorers maiores do que o possivel
			// o operador modulo é usado para obter a diferenca e minimizar o deslocamento
			
			if (tx < -w) {
				matrix.tx = tx % -w;
			} 
				else if (tx > w) 
			{
				matrix.tx = tx % w;
			} 
				else 
			{
				matrix.tx = tx;
			}
			
			if (ty < -h) {
				matrix.ty = ty % -h;
			} 
				else if (ty > h) 
			{
				matrix.ty = ty % h;
			} 
				else 
			{
				matrix.ty = ty;
			}
			
			graphics.clear();
			graphics.beginBitmapFill(bmpData, matrix, true, true);
			graphics.drawRect(0, 0, __width, __height);
			graphics.endFill();
		}
		
		public function destroy():void
		{
			bmpData.dispose();
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
		}
		
		override public function get width():Number { return __width; }
		override public function set width(value:Number):void 
		{
			if (value==__width) return
			
			__width = value;
			
			__redraw()
		}
		
		override public function get height():Number { return __height; }
		
		override public function set height(value:Number):void 
		{
			if (value==__height) return
			
			__height = value;
			
			__redraw()
		}
		
		/**
		 * Deslocamento horizontal em pixels - scroll infinito
		 */
		public function get offSetX():Number {	return ox;	}
		public function set offSetX(value:Number):void 
		{
			tx = (ox + value)*0.5;
			ox = value;
			__redraw();
		}
		
		/**
		 * Deslocamento vertical em pixels - scroll infinito
		 */
		public function get offSetY():Number {	return ox;	}
		public function set offSetY(value:Number):void 
		{
			ty = (oy + value)*0.5;
			oy = value;
			__redraw();
		}
	}

}