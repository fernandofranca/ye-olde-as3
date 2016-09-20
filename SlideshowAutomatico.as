/*
	var arr = [];
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_calendar_sub.gif');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_carousel_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_achievements_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_competitive_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_replabels_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_leaderboard_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_namedlevels_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_numberedlevels_sub.jpg');
	arr.push('http://developer.yahoo.com/ypatterns/images/pattern_grid_sub.gif');

	var sld:SlideshowAutomatico = new SlideshowAutomatico(_root, arr, 1, 4);
	
	sld.onLoadProgress = function ():void {
		trace('...', sld.percentLoaded);
	}
	
	sld.onLoadComplete = function ():void {
		trace('complete ', sld.mcAtual);
	}
	
	sld.start();
	
	var sc:Shortcuts = new Shortcuts(_stage);
	sc.add('a', sld.anterior);
	sc.add('s', sld.proxima);
	
	sc.add('p', sld.pause);
	sc.add('l', sld.resume);
	sc.add('m', sld.remove);
	
*/

package {
	import flash.display.*
	import flash.events.*;
	import gs.TweenMax
	import flash.utils.*;
	
	
	public class SlideshowAutomatico {
		
		private var __arr:Array 
		private var __imgfader:ImgFader
		private var __delay1:Number
		private var __delay2:Number
		private var __t1:Timer //delay longo
		private var __t2:Timer //delay normal
		
		public var indexImg:Number; //numero da imagem atual
		public var isPaused:Boolean = false;
		public var isLoading:Boolean = false; //isLoading só é true quando o usuario interage
		
		public var onLoadStart:Function
		public var onLoadProgress:Function
		public var onLoadComplete:Function
		
		public var mc:MovieClip // movieclip onde o slideshow é carregado
		public var mcAtual:MovieClip // movieclip onde a ultima imagem foi carregada, no onLoadComplete
		public var percentLoaded:Number = 0;
		
		
		public function SlideshowAutomatico($mcAlvo:DisplayObjectContainer, $arrUrls:Array, $intervalo:Number = 3, $intervalo2:Number = 6):void {
			
			__arr = $arrUrls;
			__delay1 = $intervalo*1000;
			__delay2 = $intervalo2*1000;
			
			__imgfader = new ImgFader($mcAlvo);
			__imgfader.addEventListener(ImgFader.ON_LOAD_START, __onLoadStart)
			__imgfader.addEventListener(ImgFader.ON_LOAD_PROGRESS, __onLoadProgress)
			__imgfader.addEventListener(ImgFader.ON_LOAD_COMPLETE, __onLoadComplete)
			//__imgfader.onLoadStart = __onLoadStart;
			//__imgfader.onLoadProgress = __onLoadProgress;
			//__imgfader.onLoadComplete = __onLoadComplete;
			
			isPaused = false;
			mc = __imgfader.mc;
		}
		
		/*
		 * Começa (do inicio, primeira imagem)
		 * */
		public function start():void{
			indexImg = -1
			
			__t1 = new Timer(__delay2, 1);
			__t1.addEventListener(TimerEvent.TIMER, __carregaPrimeira);
			
			__t2 = new Timer(__delay1, 0);
			__t2.addEventListener(TimerEvent.TIMER, __timerProxima);
			__t2.start()
			__proxima();
		}
		
		/*
		 * Pausa avanço automatico
		 * */
		public function pause():void {
			Main.trace( "sld.pause : >" );
			
			isPaused = true;
			
			if (__t1) {
				__t1.stop();
				__t2.stop();
			}
			Main.trace( "sld.pause : <" );
		}
		
		/* Continua avanço automatico após pausa
		 * */
		public function resume ():void {
			__proxima();
			__t2.start();
		}
		
		/*
		 * Remove tudo
		 * */
		public function remove ():void {
			Main.trace( "sld.remove : >"  );
			
			try {
				pause();
			} catch (e:Error){}
			
			try {
				__t1.removeEventListener(TimerEvent.TIMER, __carregaPrimeira);
				__t2.removeEventListener(TimerEvent.TIMER, __timerProxima);
			} catch (e:Error){}
			
			try {
				__imgfader.remove();
			} catch (e:Error) { }
			
			Main.trace( "sld.remove : <"  );
		}
		
		public function proxima():void {
			isLoading = true;
			
			__t2.stop();
			
			__t1.stop();
			__t1.start(); //inicia delay longo
			
			__interrompeFades()
			
			__proxima();
		}
		
		public function anterior():void {
			isLoading = true;
			
			__t2.stop();
			
			__t1.stop();
			__t1.start(); //inicia delay longo
			
			__interrompeFades()
			
			__anterior();
		}
		
		/* interrompe os fades. é necessario quando o usuario troca as imagens rapidamente */
		private function __interrompeFades():void{
			TweenMax.killTweensOf(__imgfader.mcCarregado);
			TweenMax.killTweensOf(__imgfader.mcVelho);
		}
		
		private function __onLoadStart(e:*=null):void {
			
			percentLoaded = 0;
			
			try {
				onLoadStart();
			} catch (e:Error){
				
			}
		}
		
		private function __onLoadProgress(e:*=null):void {
			
			percentLoaded = __imgfader.loadedPercent;
			
			try {
				onLoadProgress()
			} catch (e:Error){
				
			}
		}
		
		private function __onLoadComplete(e:*=null):void {
			
			isLoading = false;
			
			percentLoaded = 100;
			
			/* fades */
			
			var mc:MovieClip = __imgfader.mcCarregado;
			mc.alpha = 0;
			TweenMax.to(mc, 0.5, { alpha:1, delay:0.5 } );
			
			mcAtual = mc;
			
			var mcVelho:MovieClip = __imgfader.mcVelho;
			TweenMax.to(mcVelho, 0.5, { alpha:0, delay:0, onComplete:__disparaOnComplete} );
			
			/*
			try {
				onLoadComplete()
			} catch (e:Error){
				
			}
			*/
		}
		
		private function __disparaOnComplete():void {
			try {
				onLoadComplete()
			} catch (e:Error){
				
			}
		}
		
		private function __timerProxima(e:TimerEvent):void {
			// nao pode carregar outra se nao terminou de carregar a anterior
			if (__imgfader.isLoading==false) {
				__proxima();
			} else {
				//trace('esperando');
			}
		}
		
		/* carrega a proxima imagem */
		private function __proxima(e:*=null):void {
			
			if(indexImg+1<__arr.length){
				indexImg++;
			} else{
				indexImg=0
			}
			
			__imgfader.load(__arr[indexImg]);
		}
		
		/* carrega a imagem anterior */
		private function __anterior():void {
			
			if(indexImg-1>-1){
				indexImg--;
			} else{
				indexImg=__arr.length-1
			}
			
			__imgfader.load(__arr[indexImg]);
		}
		
		/* carrega primeira imagem depois do delay inicial */
		private function __carregaPrimeira(e:*):void {
			__proxima();
			__t1.stop();
			__t2.start();
		}
	}
}