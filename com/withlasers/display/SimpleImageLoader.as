package com.withlasers.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class SimpleImageLoader
	{
		public var loader:Loader
		
		public function SimpleImageLoader($url:String, $target:DisplayObjectContainer=null, $smooth:Boolean=true) 
		{
			loader = new Loader();
			loader.load(new URLRequest($url));
			$target.addChild(loader);
			
			if ($smooth == true) loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __handleComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
		}
		
		private function __handleComplete(e:Event):void 
		{
			if (loader.content is Bitmap) Bitmap(loader.content).smoothing = true;
		}
		
		private function __errorHandler(e:Event):void 
		{
		}
		
	}

}