package com.withlasers.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class SlicedSlideShow extends Sprite 
	{
		private var _viewSource:DisplayObject;
		private var _width:int;
		private var _height:int;
		
		private var _arrBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		private var _bitmapFader:BitmapFader = new BitmapFader(true, true);
		
		private var numSlices:int;
		private var currentSlice:int;
		private var timer:Timer;
		
		public function SlicedSlideShow(viewSource:DisplayObject, width:int, height:int) 
		{
			_viewSource = viewSource;
			_width = width;
			_height = height;
			
			_setupSlices();
		}
		
		private function _setupSlices():void 
		{
			
			if (_viewSource.width > _width)
			{
				// horizontal
				numSlices = Math.round(_viewSource.width / _width);
				
				_arrBmps = BitmapUtils.slice(_viewSource, numSlices, 1);
			} else
			{
				//vertical
				numSlices = Math.round(_viewSource.height / _height);
				
				
				_arrBmps = BitmapUtils.slice(_viewSource, 1, numSlices);
			}
			
			addChild(_bitmapFader);
			_bitmapFader.setSources(_arrBmps );
			currentSlice = 0;
			
			_start()
		}
		
		private function _start():void 
		{
			timer = new Timer(4000);
			timer.addEventListener(TimerEvent.TIMER, __handleTimer);
			timer.start();
		}
		
		private function __handleTimer(e:TimerEvent):void 
		{
			if (currentSlice + 1 < numSlices)
			{
				currentSlice++;
			} else
			{
				currentSlice = 0;
			}
			
			_bitmapFader.fade(currentSlice, 1);
		}
		
		public function dispose():void 
		{
			trace( "SlicedSlideShow.dispose" );
			
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, __handleTimer);
			_bitmapFader.destroy();
		}
		
	}

}