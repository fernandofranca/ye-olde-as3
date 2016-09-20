package com.withlasers.display 
{
	import flash.display.*;
	import flash.utils.ByteArray
	import flash.geom.Rectangle
	import flash.geom.Matrix
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class BitmapUtils
	{
		
		
		public static function copiaRegiao($src:IBitmapDrawable, $regiao:Rectangle, $smooth:Boolean=true):Bitmap
		{
			var m:Matrix = new Matrix();
			m.translate( -$regiao.x, -$regiao.y);
			
			var bmd:BitmapData = new BitmapData($regiao.width, $regiao.height, true, 0xffffff);
			bmd.draw($src, m);
			
			var bmp:Bitmap = new Bitmap(bmd);
			
			return bmp;
		}
		
		public static function slice($src:DisplayObject, $hParts:int, $vParts:int):Vector.<Bitmap>
		{
			var vParts:int = $vParts;
			var hParts:int = $hParts;
			var src:DisplayObject = $src;
			
			var partW:int = src.width / hParts;
			var partH:int = src.height / vParts;
			
			var rect:Rectangle = new Rectangle(0, 0, 0, 0);
			var bmpRet:Bitmap
			
			var arrRet:Vector.<Bitmap> = new Vector.<Bitmap>();
			
			// loop vertical
			for (var j:int = 0; j < vParts; j++) 
			{
				//loop horizontal
				for (var i:int = 0; i < hParts; i++) 
				{
					rect.x = i * partW;
					rect.y = j * partH;
					
					rect.width = partW;
					rect.height = partH;
					
					
					bmpRet = BitmapUtils.copiaRegiao(src, rect, true);
					
					
					bmpRet.x = rect.x;
					bmpRet.y = rect.y;
					
					arrRet.push(bmpRet);
				}
			}
			
			return arrRet
		}
		
	}

}