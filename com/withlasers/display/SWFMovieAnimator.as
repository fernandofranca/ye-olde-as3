package com.withlasers.display 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class SWFMovieAnimator extends Sprite 
	{
		private var _isLoading:Boolean = false;
		
		private var _value:Number = 0.0000001;
		
		private var _urlSrc:String
		
		private var _loader:Loader
		
		private var _bmpFade:Bitmap
		
		private var _req:URLRequest
		
		public var onLoadComplete:Signal = new Signal();
		
		public function SWFMovieAnimator() 
		{
			_loader = new Loader();
			addChild(_loader);
			
			_bmpFade = new Bitmap();
			addChild(_bmpFade);
			
			_bmpFade.alpha = 0; _bmpFade.visible = false;
		}
		
		public function loadSourceSwf(url:String):void 
		{
			if (url == "" || url == null || url == _urlSrc) return;
			
			// faz copia no bitmap
			if (_urlSrc != null)
			{
				_bmpFade.bitmapData = BitmapUtils.copiaRegiao(_loader, new Rectangle(0, 0, _loader.width, _loader.height), true).bitmapData;
				_bmpFade.alpha = 1; _bmpFade.visible = true;
			}
			
			
			_urlSrc = url;
			
			
			
			
			_isLoading = true;
			
			_req = new URLRequest(url);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _handleLoadComplete);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handleLoadComplete);
			_loader.load(_req);
			
		}
		
		private function _handleLoadComplete(e:Event):void 
		{
			
			TweenMax.killTweensOf(_bmpFade);
			TweenMax.to(_bmpFade, 0.3, { autoAlpha:0, ease:Linear.easeNone } );
			
			_isLoading = false;
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _handleLoadComplete);
			
			
			// forca exibir o mesmo frame do swf anterior, caso exista
			if (value == 0.0000001)
			{
			} else
			{
				value = _value;
			}
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		/**
		 * Valores entre 0 e 1
		 */
		public function set value(v:Number):void 
		{
			//if (value == v) return;
			
			if (v > 0)
			{
				_value = v % 1;
			}
			else 
			{
				_value = 1 + v % 1;
			}
			
			if (_isLoading == true) return
			
			var mc:MovieClip = MovieClip(_loader.content)
			
			var n:int = int((mc.totalFrames - 0) * value); // calcula indice da proxima imagem
			
			mc.gotoAndStop(n);
		}
		
		public function dispose():void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _handleLoadComplete);
			
			_loader = null;
			
			_req = null;
			
			_bmpFade = null;
		}
	}

}