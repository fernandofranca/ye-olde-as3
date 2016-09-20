package com.withlasers.deprecated { 
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author fernando@fiberinteractive.com.br
	 */
	public class BitmapPattern {
		private var shapeWidth:int
		private var shapeHeight:int
		private var patternWidth:int
		private var patternHeight:int
		
		private var shapeTmp:Shape
		private var shape:Shape
		private var bitmapPattern:Bitmap
		private var bitmapPatternData:BitmapData
		private var bitmapGrande:BitmapData
		
		private var _scrollX:int = 0
		
		public function BitmapPattern($shape:Shape, $bitmapPattern:Bitmap) {
			shape = $shape;
			bitmapPattern = $bitmapPattern;
			
			patternWidth = bitmapPattern.width;
			patternHeight = bitmapPattern.height;
			shapeWidth = shape.width;
			shapeHeight = shape.height;
			
			bitmapPatternData = new BitmapData(patternWidth, patternHeight, false);
			bitmapPatternData.draw(bitmapPattern);
			
			shapeTmp = new Shape();
			shapeTmp.graphics.beginBitmapFill(bitmapPatternData)
			shapeTmp.graphics.drawRect(0, 0, shapeWidth+patternWidth, shapeHeight+patternHeight)
			shapeTmp.graphics.endFill();
			
			bitmapGrande = new BitmapData(shapeWidth+patternWidth, shapeHeight+patternHeight, false);
			bitmapGrande.draw(shapeTmp);
			
			shape.graphics.clear()
			shape.graphics.beginBitmapFill(bitmapGrande);
			shape.graphics.drawRect(0, 0, shapeWidth, shapeHeight);
			shape.graphics.endFill();
			
			// remove o que for desnecessario
			bitmapPatternData.dispose();
			shapeTmp.graphics.clear();
		}
		
		public function get scrollX():int {
			return _scrollX;
		}
		
		public function set scrollX(value:int):void {
			var dif:int = _scrollX - value;
			
			_scrollX = value;
			
			if (_scrollX>patternWidth) {
				bitmapGrande.scroll(patternWidth, 0);
				_scrollX = 0;
			} else {
				bitmapGrande.scroll(dif, 0);
			}
			
		}
		
		
		
		
	}
	
}