package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	
	public class Mascara {
		private var mc:DisplayObject
		private var rect:Rectangle
		
		public var originalWidth:Number
		public var originalHeight:Number
		

		public function Mascara($mc:DisplayObject, $w:Number, $h:Number, $dx:Number=0, $dy:Number=0){
			mc = $mc;
			originalWidth = $w;
			originalHeight = $h;
			rect = new Rectangle(0, 0, originalWidth, originalHeight);
			atualizaMascara();
			dx = $dx;
			dy = $dy;
		}
		
		private function atualizaMascara():void {
			mc.scrollRect = rect;
		}
		
		public function get dx():Number {
			return rect.x*-1;
		}
		
		public function set dx(value:Number):void {
			rect.x = value*-1;
			atualizaMascara();
		}
		
		public function get dy():Number {
			return rect.y*-1;
		}
		
		public function set dy(value:Number):void {
			rect.y = value*-1;
			atualizaMascara();
		}
		
		public function get width():Number {
			return rect.width;
		}
		
		public function set width(value:Number):void {
			rect.width = value;
			atualizaMascara();
		}
		
		public function get height():Number {
			return rect.height;
		}
		
		public function set height(value:Number):void {
			rect.height = value;
			atualizaMascara();
		}
	}
}