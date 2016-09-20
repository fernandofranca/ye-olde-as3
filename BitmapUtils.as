package  
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
		
		public static function slice($src:DisplayObject, $hParts:int, $vParts:int):Sprite
		{
			var vParts:int = $vParts;
			var hParts:int = $hParts;
			var src:DisplayObject = $src;
			
			var partW:int = src.width / hParts;
			var partH:int = src.height / vParts;
			
			var rect:Rectangle = new Rectangle(0, 0, 0, 0);
			var sprContainer:Sprite = new Sprite();
			var bmpRet:Bitmap
			
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
					
					sprContainer.addChild(bmpRet);
				}
			}
			
			return sprContainer
		}
		
		public static function flipBitmapDataHorizontal(bmp:BitmapData):BitmapData
		{
			var origin:Bitmap = new Bitmap(bmp);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(-1,1);
			matrix.translate(origin.width, 0);
			
			var bitmapData:BitmapData = new BitmapData(origin.width, origin.height, true, 0x00000000);
			bitmapData.draw(origin, matrix);
			
			return bitmapData;
		}

		public static function makeThumbnail(_spr:DisplayObject, _width:int, _height:int):Bitmap
		{
			var _scaleMatrix:Number = 1;

			if(_spr.width > _spr.height)
			{
				// horizontal
				_scaleMatrix = _height / _spr.height; // 100 / 300 = .333
			}
			else if(_spr.height > _spr.width)
			{
				// vertical
				_scaleMatrix = _width / _spr.width;
			}
			else
			{
				_scaleMatrix = _height / _spr.height; // tanto faz
			}


			var dx:Number =  ((_spr.width*_scaleMatrix) / 2) - (_width /2);
			var dy:Number =  ((_spr.height*_scaleMatrix) / 2) - (_height /2);

			var m:Matrix = new Matrix();
			m.scale(_scaleMatrix, _scaleMatrix);
			m.translate( -dx, -dy);

			var bmpD:BitmapData = new BitmapData(_width, _height, false, 0xffffffff);
			bmpD.draw(_spr, m, null, null, null, true);

			var bmp:Bitmap = new Bitmap(bmpD, "auto", true);

			return bmp;
		}
		
	}

}