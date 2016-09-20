// nova!

package {
	import flash.errors.IOError;
	import flash.net.*;
	import flash.events.*
	import XML
	import XMLList
	
	public class XMLLoader extends EventDispatcher {
		private var _urlRequest:URLRequest
		private var _urlLoader:URLLoader
		private var _url:String
		public var xmlData:XML
		public var xmlStr:String
		public var onLoad:Function
		public var onError:Function
		
		public function XMLLoader () {
			_urlLoader = new URLLoader();
			_urlRequest = new URLRequest();
		}
		
		public function load(url:String):void {
			_url = url;
			_urlRequest.url = url;
			
			// remove listeners antigos
			__removeListeners();
			
			// adiciona listeners
			_urlLoader.addEventListener(Event.COMPLETE, __onLoad);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, __onError);
			_urlLoader.load(_urlRequest);
		}
		
		private function __removeListeners():void {
			try {
				_urlLoader.removeEventListener(Event.COMPLETE, __onLoad);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, __onError);
			} catch (e:Error) { }
		}
		
		private function __onLoad(e:Event):void {
			xmlData = new XML(_urlLoader.data);
			xmlStr = new String(_urlLoader.data);
			
			// remove listeners antigos
			__removeListeners();
			try {
				onLoad();
			} catch (e:Error) { }
		}
		
		private function __onError(e:IOErrorEvent):void {
			// remove listeners antigos
			__removeListeners();
			
			try {
				onError(e);
			} catch (e:Error){ }
		}
	}
}