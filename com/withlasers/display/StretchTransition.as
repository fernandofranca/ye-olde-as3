package com.withlasers.display 
{
	import com.withlasers.display.BitmapUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class StretchTransition extends Sprite 
	{
		private var _srcBmpData:BitmapData;
		private var _src:DisplayObject;
		
		private var _bmpFinal:Bitmap
		private var _bmpTransicao:Bitmap
		
		private var _value:Number=0;
		private var m:Matrix = new Matrix();;
		private var regiao:Rectangle;
		
		public function StretchTransition(src:DisplayObject ) 
		{
			_src = src;
			_srcBmpData = new BitmapData(src.width, src.height, false, 0xffffffff)
			_srcBmpData.draw(src);
			
			_bmpFinal = new Bitmap(_srcBmpData, "auto", true);
			
			_bmpTransicao = new Bitmap(new BitmapData(src.width, 1, false, 0xffffffff));
			
			regiao = new Rectangle(0, 0, _src.width, 1);
			
			m = new Matrix();
			
			addChild(_bmpFinal);
			addChild(_bmpTransicao);
			scrollRect = new Rectangle(0, 0, _src.width, _src.height);
			
			value = 0;
		}
		
		public function get value():Number { return _value; }
		public function set value($value:Number):void 
		{
			// 0 topo
			// 1 fim
			
			if ($value == _value) return
			
			_value = $value;
			
			var yPos:int = _src.height * value;
			
			regiao.y = yPos;
			
			m.ty = -yPos;
			
			_bmpTransicao.bitmapData.draw(_src, m);
			_bmpTransicao.height = _src.height;
			_bmpTransicao.y = yPos;
			
		}
		
	}

}