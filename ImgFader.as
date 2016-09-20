package {
	import flash.display.*
	import flash.events.*;
	
	
	public class ImgFader extends EventDispatcher {
		public var mc:MovieClip // principal / container
			public var mcNovo:MovieClip
			public var mcVelho:MovieClip
			public var mcCarregado:MovieClip
			
			private var __mcA:MovieClip
			private var __mcB:MovieClip
			
		public var isLoading:Boolean
		public var loadedPercent:Number
		
		private var __loader:ImgLoader
		
		
		/* eventos */
		//public var onLoadStart:Function 	// modelo antigo com callbacks
		//public var onLoadProgress:Function
		//public var onLoadComplete:Function
		
		public static const ON_LOAD_START:String = 'onLoadStart'
		public static const ON_LOAD_PROGRESS:String = 'onLoadProgress'
		public static const ON_LOAD_COMPLETE:String = 'onLoadComplete'
		
		
		
		public function ImgFader ($mcTarget:DisplayObjectContainer):void {
			
			mc = new MovieClip();
			__mcA = new MovieClip();
			__mcB = new MovieClip();
			
			//cria instancias mc, mcA, mcB
			$mcTarget.addChild(mc);
			mc.addChild(__mcB);
			mc.addChild(__mcA);
			
			
			__mcA.name = 'mcA';
			__mcB.name = 'mcB';
			
			
			mcNovo = __mcB
			mcVelho = __mcA
			
		}
		
		public function load($url:String):void {
			
			
			// REVER!
			// Se ainda estiver carregando deveria ser diferente
			if (isLoading!=true) {
				if (mcNovo==__mcA) {
					mcNovo = __mcB
					mcVelho = __mcA
				} else {
					mcNovo = __mcA
					mcVelho = __mcB
				}
			}
			
			
			//remove conteudo anterior, o que quer que seja
			while (mcNovo.numChildren>0) {
				mcNovo.removeChildAt(0);
			}
			
			
			
			isLoading = true;
			
			//anula o anterior caso exista
			if (__loader) {
				__loader.onComplete = null;
				__loader.cancel();
			}
			__loader = new ImgLoader(mcNovo, true);
			__loader.onProgress = __onLoadProgress;
			__loader.onComplete = __onLoadComplete
			__onLoadStart();
			__loader.load($url);
		}
		
		public function remove():void {
			isLoading = false;
			
			__loader.cancel();
			
			//onLoadComplete = null;
			//onLoadProgress = null;
			//onLoadStart = null;
			
			mc.parent.removeChild(mc);
		}
		
		private function __mandaParaCima():void{
			
			if (mc.getChildIndex(mcNovo) < mc.getChildIndex(mcVelho)) {
				mc.setChildIndex(mcNovo, mc.getChildIndex(mcVelho))
			}
		}
		
		private function __onLoadStart():void {
			
			dispatchEvent(new Event(ON_LOAD_START));
		}
		
		private function __onLoadProgress($loadedPercent:Number):void {
			loadedPercent = $loadedPercent;
			
			dispatchEvent(new Event(ON_LOAD_PROGRESS));
		}
		
		private function __onLoadComplete():void {
			isLoading = false;
			mcCarregado = mcNovo
			__mandaParaCima();
			
			dispatchEvent(new Event(ON_LOAD_COMPLETE));
		}
	}
}