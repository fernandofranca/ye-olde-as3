/**
 * Video/M4audio player
 * 13/8/2009 13:56 Fiz uma mudança pequena no metodo play. ao inves de usar resume, usei __ns.play(__url)
 */
package {
	import flash.display.*
	import flash.errors.IOError;
	import flash.events.*;
	import flash.media.*
	import flash.net.*
	import flash.utils.getTimer
	import flash.utils.Timer;
	
	public class VideoPlayer extends EventDispatcher {
		
		public var mcContainer:DisplayObjectContainer
		
		protected var __url:String
		protected var __nc:NetConnection
		protected var __ns:NetStream
		protected var __audio:Sound;
		protected var __video:Video
		
		protected var __lastTimer:Number
		protected var __lastBytes:Number
		protected var __bufferDefault:Number = 6;
		protected var __volume:Number = 1;
		protected var __realVolume:Number;
		protected var __bufferComplete:Boolean = false; //buffer esta 100% ? percentLoaded==100
		protected var __timerCheckEnd:Timer = new Timer(100);
		
		public var metadata:Object;
		public var duration:Number = 0;
		public var isPaused:Boolean;
		public var isPlaying:Boolean;
		public var isStopped:Boolean;
		
		public var isFlushing:Boolean; //terminou de carregar e esta esvaziando o buffer
		public var isBuffering:Boolean;
		public var autoBuffer:Boolean;
		
		
		public var error:Object
		
		/**
		 * Dispara traces nos eventos para debugar
		 */
		public var verboseMode:Boolean = false;
		
		/**
		 * Recebeu metadados
		 */
		public static const ON_METADATA:String = 'onMetaData';
		
		public static const ON_CUEPOINT:String = 'onCuePoint';
		
		public static const ON_ERROR:String = 'onError';
		
		/**
		 * Inicio da reprodução
		 */
		public static const ON_PLAY_START:String = 'onPlayStart'
		
		/**
		 * fim da reprodução
		 */
		public static const ON_PLAY_COMPLETE:String = 'onPlayComplete'
		
		/**
		 * Buffer Vazio
		 */
		public static const ON_BUFFER_FULL:String = 'onBufferFull'
		
		/**
		 * Buffer Cheio
		 */
		public static const ON_BUFFER_EMPTY:String = 'onBufferEmpty'
		
		/**
		 * Buffer 100% carregado - percentloaded==100
		 */
		public static const ON_BUFFER_LOADED:String = 'onBufferLoaded'
		
		/**
		 * Dispara no play, stop, pause, unpause
		 */
		public static const ON_PLAY_STATE_CHANGE:String = 'onPlayStateChange'
		
		
		/**
		 * Carrega e toca streams de video
		 *
		 * @param	$mcContainer	Se precisa criar a instancia do objeto Video, informe o alvo, do contrario atribua um video posteriormente
		 * @param	$width
		 * @param	$height
		 */
		public function VideoPlayer ($mcContainer:DisplayObjectContainer=null, $width:Number=320, $height:Number=240) {
			
			
			// conexão
			__nc = new NetConnection();
			__nc.connect(null);
			
			__ns = new NetStream(__nc);
			__ns.client = this;
			//__ns.checkPolicyFile = true;
			
			
			// visual
			mcContainer = $mcContainer;
			__video = new Video($width, $height);
			__video.attachNetStream(__ns);
			
			if (mcContainer) {
				mcContainer.addChild(__video);
			}
			
		}
		
		/**
		 * Eventos em geral
		 */
		protected function __observeEvents():void {
			__ns.addEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
			__ns.addEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
			__timerCheckEnd.addEventListener(TimerEvent.TIMER, __handleTimer, false, 0, true);
		}
		
		/**
		 * Remove todos eventos
		 */
		protected function __removeEvents():void {
			__ns.removeEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
			__ns.removeEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
			__timerCheckEnd.removeEventListener(TimerEvent.TIMER, __handleTimer, false);
		}
		
		public function onMetaData(info:Object):void {
			
			metadata = info;
			duration = info.duration;
			
			__lastTimer = getTimer();
			__lastBytes = __ns.bytesLoaded;
			
			__disparaEvento(ON_METADATA);
			
			__trace('Metadata')
			for (var name:String in metadata) {
				__trace('\t', name, metadata[name])
			}
		}
		
		public function onCuePoint(info:Object):void {
			__disparaEvento(ON_CUEPOINT); //não é importante, mas deveria ser diferente
		}
		
		protected function __disparaOnBufferEmpty():void {
			if (isFlushing != true) {
				// ainda esta carregarregando
				
				isBuffering = true;
				
				// TODO : IMPLEMENTAR Autobuffer
				/*
				if (autoBuffer==true ) { // se o buffer for modo automatico, recalcula de acordo com a qualidade da conexao
					bufferTime = calculaBuffer();
				}
				*/
				
				__disparaEvento(ON_BUFFER_EMPTY);
				
			} else if (isFlushing == true && isBuffering == false) {
				// terminou de carregar
				
				__disparaOnComplete()
			}
			
			// porque isFlushing não dispara em todo video?
		}
		
		protected function __disparaOnComplete():void {
			//volta para o inicio e pausa (play retorna a reprodução a partir do inicio)
			//seek(0);
			stop();
			
			__disparaEvento(ON_PLAY_COMPLETE);
		}
		
		protected function __disparaBufferComplete():void
		{
			__disparaEvento(ON_BUFFER_LOADED);
		}
		
		protected function __netStatusHandler(e:NetStatusEvent):void {
				var obj:Object = e.info;
				
				for (var name:String in obj) {
					__trace('\t', name, ':',obj[name]);
				}
			
			//Trace.trace(e.info.code);
			
			
			switch (e.info.code) {
				case 'NetStream.Play.StreamNotFound':
					//The FLV passed to the play() method can't be found
					error = e.info
					__disparaEvento(ON_ERROR);
				break
				case 'NetStream.Play.Start':
					// Playback has started
					if (isBuffering==true) {
						__disparaOnBufferEmpty();
					}
					__disparaEvento(ON_PLAY_START);
				break
				case 'NetStream.Play.Stop':
					// final da reprodução
					__disparaOnComplete();
				break;
				case 'NetStream.Buffer.Full':
					// Carregou o suficiente no buffer para voltar a tocar
					isBuffering = false;
					__disparaEvento(ON_BUFFER_FULL);
				break
				case 'NetStream.Buffer.Flush':
					// terminou de carregar tudo, esta esvaziando o buffer
					if (percentLoaded>=100) {
						isFlushing = true;
						isBuffering = false;
					}
				break
				case 'NetStream.Buffer.Empty':
					__disparaOnBufferEmpty();
				break
				case 'NetStream.Seek.Notify':
					/*
					 * apos um seek, NetStream.Buffer.Empty NÃO DISPARA,
					 * apenas o NetStream.Buffer.Full dispara, se for o caso!
					 * tive que fazer a checagem na mao, comparando
					 * timeLoaded-time>bufferTime
					 *
					 * o timeLoaded pode não ser preciso pois é calculado pela proporção
					 */
					
					if (timeLoaded - time > bufferTime == false) {
						
						// só dispara se REALMENTE nao carregou o suficiente
						// checa de novo para nao disparar de graça no final
						if (duration-timeLoaded > bufferTime) {
							__disparaOnBufferEmpty();
						} else {
							__disparaEvento(ON_BUFFER_FULL);
						}
						
					}
				break
				
				//
			}
		}
		
		protected function __ioErrorHandler(e:IOErrorEvent):void {
			error = e
			__disparaEvento(ON_ERROR);
		}
		
		/**
		 * Começa a carregar e deixa pausado
		 */
		public function load($url:String, $bufferTime:Number = 5, $autoBuffer:Boolean = false):void {
			
			// estados
			isPlaying = false;
			isPaused = true;
			isStopped = false;
			
			isFlushing = false;
			isBuffering = true;
			
			autoBuffer = $autoBuffer;
			bufferTime = $bufferTime;
			
			__url = $url;
			
			__bufferComplete = false;
			
			// fecha e reseta o netstream para matar o problema do glicth
			__ns.close();
			__removeEvents();
			
			__ns = null;
			__ns = new NetStream(__nc);
			__ns.client = this;
			
			__observeEvents();
			
			// carrega e pausa
			__ns.play(__url);
			__ns.pause();
			
			volume = volume;
			
			__video.attachNetStream(__ns);
		}
	
		/*
		  the "NetStream.Play.Stop" doesn't trigger everytime...
		  from what i've noticed it's for different files differently...
		  meaning, for some specific files it does, for others it doesn't....
			my workaround to this was smth like - when i get the "...Buffer.Flush''
			i set a boolean (_flushed = true) and when the "...Buffer.Empty" -
			i do the same things as supposed to when receiving the "Play.Stop"...
			but still it's buggy stuff...
		*/

		public function stop():void {
			
			if (isPlaying == true || isPaused == true) {
				
				__timerCheckEnd.stop();
				
				//__ns.pause(); //pausa // isto parece gerar um glitch no audio quando dou play novamente
				__ns.close();
				
				//estados
				isPlaying = false;
				isPaused = false;
				isStopped = true;
				
				__disparaEvento(ON_PLAY_STATE_CHANGE);
			}
		}
		
		public function play():void {
			
			if (isPaused == true) {//esta pausado?
				
				__ns.resume(); //tira da pausa
				
				//estados
				isPlaying = true;
				isPaused = false;
				isStopped = false;
					
				__disparaEvento(ON_PLAY_STATE_CHANGE);
				
			} else if (isStopped == true) { //esta parado?
				
				seek(0); //volta para o inicio
				//__ns.resume(); //tira da pausa
				__ns.play(__url); // fiz esta mudança
				
				//estados
				isPlaying = true;
				isPaused = false;
				isStopped = false;
					
				__disparaEvento(ON_PLAY_STATE_CHANGE);
				
			}
			
			__timerCheckEnd.start();
		}
		
		/* Se já estiver pausado, use play() para prosseguir */
		public function pause():void {
			if (isPlaying == true && isPaused == false) {
				
				__ns.pause();
				
				//estados
				isPlaying = true;
				isPaused = true;
				isStopped = false;
					
				__disparaEvento(ON_PLAY_STATE_CHANGE);
			}
		}
		
		/**
		 * Quebra a conexao, para o download e remove os listeners
		 */
		public function remove():void {
			// remover timer
			__ns.close();
			__nc.close();
			__timerCheckEnd.stop();
			__removeEvents();
		}
		
		/**
		 * Pula para um determinado ponto do video
		 * @param	$segundos	Tempo em segundos
		 */
		public function seek ($segundos:Number):void {
			if ($segundos < duration) {
				
				// REVER
				//bufferTime = __bufferDefault; // reverte o buffer para o valor default e permite pular para qualquer ponto
				
				time = ($segundos); //faz o seek do netstream
			}
		}
		
		/**
		 * Pula para um determinado ponto do video. Valor em %
		 * @param	$perc	Percentual do ponto para onde quer pular
		 */
		public function seekPercent($perc:Number):void {
			$perc = Math.floor($perc);
			
			if ($perc >= 0 && $perc <= 100 && $perc < percentLoaded) {
				//calcula em segundos
				var s:* = ($perc * duration) / 100
				seek(s);
			}
		}
		
		public function calculaBuffer():void{
			// TODO IMPLEMENTAR Autobuffer
		}
		
		protected function __disparaEvento(tipo:String):void {
			dispatchEvent(new Event(tipo, false, false));
		}
		
		protected function __trace(...rest):void {
			if (verboseMode==true) {
				trace(rest.join('  '));
			}
		}
		
		protected function __handleTimer(e:TimerEvent):void {
			if (duration - time<0.1 && duration>1) 
			{
				__disparaOnComplete();
			}
			
			if (__bufferComplete == false && percentLoaded == 100) 
			{
				__bufferComplete = true;
				__disparaBufferComplete();
			}
		}
		
		
		
		
		
		/* getters / setters */
	
		public function get percentLoaded():Number {
			var p:Number = (__ns.bytesLoaded * 100) / __ns.bytesTotal;
			if (isNaN(p)) {
				p = 0;
			}
			return p;
		}
	
		public function get percentPlayed():Number {
			var p:Number = (time * 100) / duration;
			if (isNaN(p)) {
				p = 0;
			}
			return p;
		}
		
		/* dataRate em KBps */
		public function get videoDataRate():Number {
			var d:Number = (__ns.bytesTotal / duration) / 1024;
			if (isNaN(d)) {
				d = 0;
			}
			return d;
		}
	
		public function get connectionDataRate():Number { // em KBps
			
			if (percentLoaded >= 100) {
				return videoDataRate;
			} else {
				
				var t:Number = (getTimer() - __lastTimer) / 1000;
				
				var b:Number = __ns.bytesLoaded - __lastBytes
				
				var r:Number = (b / t) / 1024;
				
				return r;
			}
			
		}
		
		/**
		 * Percentual de qualidade da conexao do cliente. Varia entre 0 e 100
		 */
		public function get connectionQuality():Number {
			var r:Number = Math.round((connectionDataRate / videoDataRate) * 100);
			
			if (r<=100) {
				return r;
			} else if (isNaN(r)) {
				return 0;
			} else {
				return 100;
			}
		}
		
		/**
		 * Volume do som. Varia entre 0 e 1.
		 */
		public function get volume():Number {
			//var st:SoundTransform = __ns.soundTransform;
			//return st.volume;
			return __volume;
		}
		public function set volume(value:Number):void {
			
			var st:SoundTransform = new SoundTransform();
			
			if (value>=0) {
				st.volume = value;
				__volume = value;
			} else {
				st.volume = 0;
				__volume = 0;
			}
			
			__ns.soundTransform = st;
		}
		/**
		 * Deixa mudo ou nao
		 */
		public function get mute():Boolean {
			return this.volume==0;
		}
		public function set mute(value:Boolean):void {
			if (value==true && mute==false) {
				__realVolume = volume;
				volume = 0;
			} else {
				volume = __realVolume
			}
		}
		
		/**
		 * Tempo atual em segundos
		 */
		public function get time():Number {
			return __ns.time;
		}
		public function set time(value:Number):void {
			__ns.seek(value);
		}
		
		/**
		 * Tempo carregado até o momento. É calculado pela proporção.
		 * Pode não ser preciso pois é calculado pela proporção.
		 * 		Precisei criar isto para checar apos o Seek,
		 * 		pois não acontecia o disparo de bufferempty
		 * 		pelo evento netStatus
		 */
		public function get timeLoaded():Number {
			return Math.floor((percentLoaded * duration) / 100);
		}
		
		/**
		 * percentual carregado no buffer
		 */
		public function get bufferPercent():Number {
			var p:* = (bufferLoaded * 100) / bufferTime;
			
			if (p > 100) p = 100;
			
			return p;
		}
		
		/**
		 * determina o tempo do buffer de execução em segundos
		 */
		public function set bufferTime(value:Number):void {
			__ns.bufferTime = value;
		}
		public function get bufferTime():Number {
			return __ns.bufferTime;
		}
		
		/**
		 * tempo em segundos carregados atualmente no buffer
		 */
		public function get bufferLoaded():Number {
			return __ns.bufferLength;
		}
		
		public function get width():Number {
			return __video.width;
		}
		public function set width(value:Number):void {
			__video.width = value;
		}
		
		public function get height():Number {
			return __video.height;
		}
		public function set height(value:Number):void {
			__video.height = value;
		}
		
		public function get proporcaoOriginal():Number {
			if (metadata) {
				return metadata.width / metadata.height;
			} else {
				return 0;
			}
		}
		
		public function get smoothing():Boolean {
			return __video.smoothing;
		}
		public function set smoothing(value:Boolean):void {
			__video.smoothing = value;
		}
		
		/**
		 * 0—Lets the video compressor apply the deblocking filter as needed.
		 * 1—Does not use a deblocking filter.
		 * 2—Uses the Sorenson deblocking filter.
		 * 3—For On2 video only, uses the On2 deblocking filter but no deringing filter.
		 * 4—For On2 video only, uses the On2 deblocking and deringing filter.
		 * 5—For On2 video only, uses the On2 deblocking and a higher-performance On2 deringing
		 */
		public function get deblocking():int {
			return __video.deblocking;
		}
		public function set deblocking(value:int):void {
			__video.deblocking = value;
		}
		
		public function get video():Video { return __video; }
		
		public function set video(value:Video):void {
			__video = value;
			__video.attachNetStream(__ns);
		}
		
		override public function toString():String { //retorna string com informações sobre o carregamento, reprodução, etc...
			var d:String
			var newline:String = '\n';
			d = 'atual : '+time;
			d += newline +'total : '+duration;
			d += newline +'percentPlayed : '+percentPlayed;
			d += newline +'percentLoaded : '+percentLoaded;
			d += newline +'';
			d += newline +'videoDataRate : '+videoDataRate;
			d += newline +'connectionDataRate : '+connectionDataRate;
			d += newline +'connectionQuality : ' + connectionQuality + '%';
			d += newline +'';
			d += newline +'bufferLoaded : '+bufferLoaded;
			d += newline +'bufferTime : '+bufferTime;
			d += newline +'bufferPercent : '+bufferPercent+'%';
			d += newline +'';
			d += newline +'isPlaying : '+isPlaying;
			d += newline +'isPaused : '+isPaused;
			d += newline +'isStopped : '+isStopped;
			d += newline +'';
			d += newline +'isBuffering : '+isBuffering;
			d += newline +'isFlushing : ' + isFlushing;
			d += newline +'novoBuffer : ' + calculaBuffer();
			return d;
		}
		
		//public function get NS():NetStream {
			//return __ns;
		//}
		
	}
}