package {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
    import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	
	public class ImgLoader {
		
		private var loader:Loader
		private var mcTarget:DisplayObjectContainer
		private var smooth:Boolean;
		
		public var url:String
		public var loadedContent:*; // pode ser um bitmap ou DisplayObjectContainer para swfs
		
		//public var loaderInfo:LoaderInfo
		public var percentLoaded:Number
		public var errorType:String
		
		public var onProgress:Function
		public var onComplete:Function
		public var onError:Function
		
		/* O ImgLoader é acumulativo, ou seja, usa um addChild no target, ao contrario do loadMovie
		 * */
		public function ImgLoader ($target:DisplayObjectContainer, $smooth:Boolean=true) {
			
			mcTarget = $target;
			smooth = $smooth;
			percentLoaded = 0;
		}
		
		public function load(__url:String):void {
			var urlReq:URLRequest = new URLRequest(__url);
			var context:LoaderContext = new LoaderContext(false);
			context.checkPolicyFile = false;
			
			loader = new Loader();
			//loader.load(urlReq, context);
			loader.load(urlReq, context);
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
		}
		
		public function cancel ():void {
			try {
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.close();
				onProgress = null;
				onComplete = null;
				onError = null;
			} catch (e:Error){
			}
		}
		
		private function progressHandler(e:ProgressEvent):void {
			percentLoaded = (e.bytesLoaded * 100) / e.bytesTotal;
			
			try {
				onProgress(percentLoaded);
			} catch (e:Error){ }
		}
		
		private function completeHandler(evento:Event):void {
			/* modelo anterior
			 * 
			//mcTarget.addChild(loader);
			loadedContent = mcTarget.addChild(loader.content);
			try {
				//se for bitmap aplica smoothing
				// IMPORTANTE: isto só é possivel com imagens vindas do mesmo dominio
				if (loader.content is Bitmap) {
					Bitmap(loader.content).smoothing = smooth;
				}
			} catch (e:Error){ }
			*/
			
			
			// permite carregar imagens de outros dominios que nao tenham o crossdomain.xml
			// mas o smoothing se torna impossivel
			
			if (smooth==true) {
				
				loadedContent = mcTarget.addChild(loader.content);
				
				try {
					//se for bitmap aplica smoothing
					// IMPORTANTE: isto só é possivel com imagens vindas do mesmo dominio
					if (loader.content is Bitmap) {
						Bitmap(loader.content).smoothing = smooth;
					}
				} catch (e:Error) { }
				
			} else {
				
				loadedContent = mcTarget.addChild(loader.getChildAt(0));
			}
			
			try {
				onComplete()
			} catch (e:Error) { }
			
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			onComplete = null;
			onProgress = null;
			onError = null;
		}

		public function getClass(className:String):Class {
			try {
				return loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;
			} catch (e:Error) {
				throw new IllegalOperationError(className + ' definicao nao encontrada');
			}
			return null;
		}
		
		
		private function errorHandler(e:IOErrorEvent):void {
			errorType = e.text;
			
			try {
				onError(errorType);
			} catch (e:Error){ }
		}
	}
}
