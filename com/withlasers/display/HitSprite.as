package com.withlasers.display 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class HitSprite extends Sprite
	{
		private var shape:Shape = new Shape()
		private var gr:Graphics = shape.graphics
		
		public function HitSprite($target:Sprite, $autoSize:Boolean = true, $w:Number=40, $h:Number=40) 
		{
			addChild(shape);
			$target.addChild(this);
			$target.hitArea = this;
			this.visible = false;
			
			
			if ($autoSize == true) 
			{
				var b:Rectangle = $target.getBounds($target);
				
				$w = b.width;
				$h = b.height;
				
				x = b.x;
				y = b.y;
			}
			
			__draw($w, $h)
		}
		
		private function __draw($w:Number, $h:Number):void
		{
			gr.clear();
			gr.beginFill(0x00FFFF, 1);
			gr.drawRect(0, 0, $w, $h);
			gr.endFill();
		}
		
	}

}