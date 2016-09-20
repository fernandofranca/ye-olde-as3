/*
	var imagensArr = [];
	imagensArr.push('2204245800_61ea67464d_m.jpg');
	imagensArr.push('2204244292_dbac03dcc7_m.jpg');
	imagensArr.push('2204242426_cf966d90dd_m.jpg');
	
	cache1 = new Cache(arr1);
	cache1.verbose = true;
	cache1.onProgress = __onProgress
	cache1.onComplete = __onLoadComplete
	cache1.onError = __onError
	cache1.load();
	
	//addChild(cache1.mcCache)
	
	//mc = addChild(cache1.getElementByNum(2)); //depois do onComplete
*/
	
// OBS.: no carregamento simultaneo o percentLoaded não é fiel

package {
	import flash.display.*
	import flash.events.*;
	
	
	public class Cache {
		private var __imgsArr:Array
		private var __imgsTotal:Number
		private var __imgsIndex:Number
		private var __imgsLoaded:Number
		private var __numDownloadsSimultaneos:Number
	
		public var mcCache:Sprite //mc onde tudo será carregado
		public var verbose:Boolean = false;
		private var __mcs:Array //array com todos movieclips
		private var __loader:ImgLoader;
		
		
		/* eventos*/
		public var onProgress:Function
		public var onComplete:Function
		public var onError:Function;
		
		
		public function Cache ($arrUrls:Array, $numDownloadsSimultaneos:Number=1):void {
			__imgsArr = $arrUrls;
			
			if ($numDownloadsSimultaneos>$arrUrls.length) {
				__numDownloadsSimultaneos = $arrUrls.length;
			} else {
				__numDownloadsSimultaneos = $numDownloadsSimultaneos;
			}
			
			mcCache = new MovieClip();
		}
		
		public function load():void {
			__mcs = [];
			__imgsTotal = __imgsArr.length;
			__imgsLoaded = 0;
			__imgsIndex = -1;
			
			if (__numDownloadsSimultaneos>1) { //loop para adicionar mais de um download simultaneamente
				var sim = __numDownloadsSimultaneos
				while (sim > 0) {
					sim--;
					__loadNext ();
				}
			} else { //carrega uma por vez
				__loadNext();
			}
		}
		
		private function __loadNext():void {
			
			
			__imgsIndex++;
			
			var urlImg:String = __imgsArr[__imgsIndex];
			
			
			var mcNovo:MovieClip = new MovieClip();
			mcCache.addChild(mcNovo);
			
			__loader = new ImgLoader(mcNovo);
			
			__loader.onComplete = __onLoadImage;
			__loader.onProgress = __onProgress;
			__loader.onError = __onError;
			
			__loader.load(urlImg);
			__mcs.push(mcNovo);
			
			__trace('\t carregando:'+ urlImg);
			

		}
		
		private function __onLoadImage () { //decide o que é feito apos o carregamento de cada img
			__imgsLoaded++
			
			
			if (__imgsLoaded<__imgsTotal) {
				__loadNext();
				onProgress(percentLoaded);
				__trace(percentLoaded+'%')
			} else {
				try {
					onProgress(100);
				} catch (e:Error){
				}
				
				try {
					onComplete();
				} catch (e:Error){
				}
				__trace('fim do carregamento')
			}
		}
		
		private function __onProgress(loadedPerc) { //dispara um metodo customizado
			try {
				onProgress(loadedPerc);
			} catch (e:Error){
			}
		}
		
		private function __onError(e):void{
			__trace(e); //mostra erro
			
			try {
				onError(e); // dispara o erro
			} catch (e:Error){
			}
			__onLoadImage(); //passa para a próxima imagem
		}
		
		private function __getProgressPerc():Number { //calcula o percentual geral carregado
			
			var parcial = __loader.percentLoaded/100; //parcial da imagem atual
			
			var perc = Math.floor(((__imgsLoaded+parcial)*100)/(__imgsTotal+1)); //percentual geral
			
			return(perc);
		}

		public function get percentLoaded():Number {
			return __getProgressPerc();
		}
		
		/* retorna movieclip */
		public function getElementByNum(n:Number):MovieClip {
			
			if (n<__imgsTotal) {
				var mc:MovieClip
				mc = MovieClip(__mcs[n]);
				
				return mc;
			} else {
				throw new Error("Elemento inexistente: "+n+' - total '+__imgsTotal);
			}
			
		}
		
		/* remove tudo e cancela o carregameto*/
		public function remove():void {
			__loader.cancel(); // para o loader
			
			onComplete = null; //remove os callbacks
			onProgress = null;
			onError = null;
			
			for (var i:int = 0; i < __mcs.length; i++) {
				__mcs[i] = null;
			}
			__mcs = null;
			
			try {
				mcCache.parent.removeChild(mcCache); //remove o mc principal
			} catch (e:Error){}
			
			mcCache = null;
		}
		
		private function __trace($texto):void{
			if (verbose==true) {
				Tracebox.msg('Cache:' + $texto);
				//Tracebox.msg(__imgsLoaded+'/'+__imgsTotal )
			}
		}

	}
}