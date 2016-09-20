package com.withlasers.ui 
{
	import flash.display.*;
	import flash.filters.BlurFilter;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class PreloadIcon extends Sprite
	{
		private var __percent:Number = 0;
		private var __sprFront:Sprite = new Sprite();
		private var __sprMask:Sprite = new Sprite();
		
		public var colorFront:Number
		public var colorBack:Number
		public var blur:int
		public var isVisible:Boolean = true;
		public var autoHide:Boolean = true;
		
		public function PreloadIcon($colorFront:Number=0xffffff, $colorBack:Number=0x000000, $blur:int=0) 
		{
			colorFront = $colorFront;
			colorBack = $colorBack;
			blur = $blur;
			blendMode = BlendMode.LAYER;
			mouseEnabled = false;
			
			if (blur > 0) filters = [new BlurFilter(blur, blur, 3)];
			
			__drawBase();
			__redraw();
		}
		
		public function show(t:Number=1):void 
		{
			isVisible = true;
			TweenLite.to(this, t, { autoAlpha:1 } );
		}
		
		public function hide(t:Number=1):void 
		{
			isVisible = false;
			TweenLite.to(this, t, { autoAlpha:0 } );
		}
		
		protected function __drawBase():void
		{
			var sprBase:Sprite = new Sprite();
			addChild(sprBase);
			sprBase.graphics.lineStyle(10, colorBack, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
			DrawUtils.drawArc(sprBase, 0, 0, 20, 360, 0);
			
			__sprFront = new Sprite();
			addChild(__sprFront);
			__sprFront.graphics.lineStyle(10, colorFront, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
			DrawUtils.drawArc(__sprFront, 0, 0, 20, 360, 0);
			
			__sprMask = new Sprite();
			addChild(__sprMask);
		}
		
		protected function __redraw():void
		{
			__sprMask.graphics.clear();
			__sprMask.graphics.beginFill(colorFront, 1);
			DrawUtils.drawWedge(__sprMask, -20, 0, 30, __percent * 3.6, 0);
			__sprFront.mask = __sprMask
		}
		
		public function get percent():Number { return __percent; }
		public function set percent(value:Number):void 
		{
			__percent = value;
			__redraw();
			
			if (autoHide == true && percent >= 100) hide();
		}
		
	}

}