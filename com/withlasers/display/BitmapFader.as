package com.withlasers.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import gs.easing.Linear;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class BitmapFader extends Bitmap 
	{
		protected var _value:uint = 0;
		
		protected var arrBmpData:Array = [];
		
		protected var bmpTransicao:BitmapData; // bmp "novo"
		
		protected var point:Point = new Point(0, 0); 
		private var _disposed:Boolean;
		
		public function BitmapFader($smooth:Boolean=true, $destroyOnRemoved:Boolean=true) 
		{
			smoothing = $smooth;
			
			if ($destroyOnRemoved==true) addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
		}
		
		protected function __handleRemoved(e:Event):void 
		{
			destroy();
		}
		
		protected function _setSource(num:int, src:DisplayObject):void 
		{
			var bmpD:BitmapData
			bmpD = new BitmapData(src.width, src.height, true, 0x00ffffff);
			bmpD.draw(src);
			
			arrBmpData[num] = bmpD;
		}
		
		/**
		 * Determina as fontes dos bitmaps que serao gerados
		 * @param	arr	Array de DisplayObject
		 */
		public function setSources(arr:Array):void 
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				_setSource(i, arr[i]);
			}
			
			bitmapData = BitmapData(arrBmpData[0]).clone(); //determina o bmp base
		}
		
		/**
		 * Determina as fontes a partir de frames de um movieclip
		 * @param	mc				Fonte
		 * @param	arrFrames		Frames que serao lidos
		 * @param	swapInstances	Troca automaticamente a fonte por esta instancia
		 */
		public function setSourceFrames(mc:MovieClip, arrFrames:Array, swapInstances:Boolean=true):void 
		{
			var j:int = 0;
			
			for (var i:int = 0; i < arrFrames.length; i++) 
			{
				mc.gotoAndStop(arrFrames[i]);
				
				_setSource(j, mc);
				
				j++
			}
			
			bitmapData = BitmapData(arrBmpData[0]).clone(); //determina o bmp base
			
			if (swapInstances) McUtils.swap(mc, this);
		}
		
		/**
		 * Fade between bitmaps
		 * @param	fNum 	Base 0, as Array
		 * @param	$t		Transition Time
		 */
		public function fade(fNum:int, $t:Number=0.3):void 
		{
			if (_disposed) return // ja foi destruido ou removido do stage
			
			if (fNum + 1 > arrBmpData.length) 
			{
					throw(new Error(getQualifiedClassName(this) + " Frame "+fNum+" not buffered or undefined " + _disposed));
				return
			}
			
			if (arrBmpData.length == 0) return // ja foi destruido
			
			bmpTransicao = arrBmpData[fNum];
			value = 0;
			TweenMax.to(this, $t, { value:255, ease:Linear.easeNone } );
		}
		
		public function destroy():void 
		{
			//log( "BitmapFader destroy : " + this );
			
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			TweenMax.killTweensOf(this);
			
			arrBmpData.length = 0;
			//bmpTransicao.dispose();
			bmpTransicao = null;
			
			_disposed = true;
		}
		
		/**
		 * Esta propriedade é usada apenas pela classe, na transicao. Não acessar diretamente
		 */
		public function get value():uint { return _value; }
		public function set value($value:uint):void 
		{
			_value = $value;
			
			bitmapData.merge(bmpTransicao, bmpTransicao.rect, point, $value, $value, $value, $value);
		}
		
	}

}