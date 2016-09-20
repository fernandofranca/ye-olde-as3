package com.withlasers.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.easing.Linear;
	import gs.TweenMax;
	
	/**
	 * 
	 */
	public class FrameFader extends Sprite
	{
		public var mc:MovieClip
		public var frameAtual:Number
		
		protected var __arrBmps:Array;
		protected var __smooth:Boolean = true;
		
		public function FrameFader($mc:MovieClip, $smooth:Boolean=true, $destroyOnRemove:Boolean = true) 
		{
			mc = $mc;
			mc.stop();
			__smooth = $smooth;
			
			generateBmps();
			
			if($destroyOnRemove==true) addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved, false, 0, true);
		}
		
		protected function generateBmps():void
		{
			__arrBmps = new Array();
			
			for (var i:int = 0; i < mc.totalFrames; i++) 
			{
				mc.gotoAndStop(i+1);
				
				var bmp:Bitmap = new Bitmap()
				bmp.bitmapData = new BitmapData(mc.width, mc.height, true, 0x000000);
				bmp.bitmapData.draw(mc);
				bmp.smoothing = __smooth;
				
				__arrBmps.push(bmp);
			}
		}
		
		public function showFrame($n:int, $t:Number=0.2):void 
		{
			if ($n <1) return
			if ($n == frameAtual) return
			if ($n > __arrBmps.length) return
			
			frameAtual = $n;
			
			var bmp:Bitmap = new Bitmap(Bitmap(__arrBmps[$n - 1]).bitmapData.clone());
			bmp.smoothing = true;
			addChildAt(bmp, numChildren);
			
			TweenMax.from(bmp, $t, { autoAlpha:0, ease:Linear.easeIn, onComplete:__removeChilds } );
		}
		
		protected function __removeChilds():void
		{
			while (numChildren>2) 
			{
				var c:DisplayObject = getChildAt(0);
				TweenMax.killTweensOf(c);
				Bitmap(c).bitmapData.dispose();
				removeChild(c);
			}
		}
		
		public function destroy():void 
		{
			
			while (numChildren>1) 
			{
				var c:DisplayObject = getChildAt(0);
				TweenMax.killTweensOf(c);
				Bitmap(c).bitmapData.dispose();
				removeChild(c);
			}
			
			for each (var bmp:Bitmap in __arrBmps) 
			{
				bmp.bitmapData.dispose();
			}
			
			__arrBmps.length = 0;
			
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			
		}
		
		protected function __handleRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			
			destroy();
		}
		
	}
	
}