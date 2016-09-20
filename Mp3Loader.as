// 5/10/2009 17:18 Inclusao de novos eventos
// 5/10/2009 17:18 Inclusao do timer de progresso

package {
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Mp3Loader extends EventDispatcher {
		private var _urlFile:String
		private var _sound:Sound
		private var _soundLoaderContext:SoundLoaderContext
		private var _soundChannel:SoundChannel
		private var _timeStart:Number
		private var _lastPosition:Number //usada no pause
		private var _volume:Number
		private var _oldIsBuffering:Boolean // estado anterior do isBuffering. é atualizado no LOAD_PROGRESS
		private var _timer:Timer
		private var _oldPosition:Number
		private var _playStarted:Boolean // usada para disparar o evento ON_PLAY_START
		
		public var bytesLoaded:Number
		public var bytesTotal:Number
		public var percentLoaded:Number
		public var id3:ID3Info
		public var isBuffering:Boolean
		public var isPaused:Boolean
		public var isPlaying:Boolean
		public var kbpsCurrent:Number
		public var kbpsRequired:Number
		public var percentUserSpeed:Number
		public var error:Object
		
		public static const LOAD_PROGRESS:String = 'onLoadProgress'; // progresso de carregamento
		public static const LOAD_COMPLETE:String = 'onLoadComplete'; // fim do carregamento
		public static const SOUND_COMPLETE:String = 'onSoundComplete'; // fim da reprodução do audio
		
		public static const ON_BUFFER_EMPTY:String = 'onBufferEmpty'; // o buffer esvaziou e parou de tocar
		public static const ON_BUFFER_FULL:String = 'onBufferFull'; // o buffer encheu e voltou a tocar
		
		public static const ID3:String = 'onID3'; // 'onMetaData'
		
		/**
		 * Dispara nos erros de arquivo nao encontrado
		 */
		public static const ON_ERROR:String = 'onError';
		
		/**
		 * Dispara no play, stop, pause, unpause
		 */
		public static const ON_PLAY_STATE_CHANGE:String = 'onPlayStateChange'
		
		/**
		 * Dispara a cada um segundo ao progresso da reprodução
		 */
		public static const ON_PLAY_PROGRESS:String = 'OnPlayProgress'
		
		/**
		 * Inicio da reprodução
		 */
		public static const ON_PLAY_START:String = 'onPlayStart'
		
		
		public function Mp3Loader() {
			_volume = 1;
			_sound = new Sound();
			_soundChannel = new SoundChannel();
			
			_timer = new Timer(1000);
			//_timer.addEventListener(TimerEvent.TIMER, __handleTimerProgress);
			_timer.addEventListener(TimerEvent.TIMER, __handleTimer)
			
			resetProps();
		}
		
		private function resetProps():void {
			bytesLoaded = 0;
			bytesTotal = 0;
			percentLoaded = 0;
			//position = 0;
			id3 = new ID3Info();
			isBuffering = false;
			_oldIsBuffering = false;
			isPaused = false;
			isPlaying = false;
			kbpsCurrent = 0;
			kbpsRequired = 0;
			percentUserSpeed = 0;
			_oldPosition = 0;
			_playStarted = false;
		}
		
		public function load($url:String):void {
			//if ($url==_urlFile) return
			
			
			stopAndCloseStream();
			
			_timeStart = getTimer();
			_urlFile = $url;
			resetProps();
			isBuffering = true;
			isPlaying = true;
			
			var urlReq:URLRequest = new URLRequest(_urlFile);
			
			_soundLoaderContext = new SoundLoaderContext(5000);
			
			_sound = new Sound();
			
			_soundChannel = new SoundChannel();
			
			__adicionaListeners();
			
			_sound.load(urlReq, _soundLoaderContext);
			_soundChannel = _sound.play(0);
			
			volume = _volume;
			
			dispatchEvent(new Event(ON_PLAY_STATE_CHANGE));
			
			//timer
			
		}
		
		private function __adicionaListeners():void {
			__removeListeners();
			
			_sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			_sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_sound.addEventListener(Event.ID3, id3Handler);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		private function __removeListeners():void {
			if (_sound) {
				try {
					_sound.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
					_sound.removeEventListener(Event.COMPLETE, loadCompleteHandler);
					_sound.removeEventListener(Event.ID3, id3Handler);
					_sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				} catch (e:Error){}
			}
			
			if (_soundChannel) {
				try {
					_soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				} catch (e:Error){}
			}
			if (_timer) {
				//_timer.removeEventListener(TimerEvent.TIMER, __handleTimerProgress);
			}
		}
		
		public function stop():void {
			
			
			try {
				position = 0;
			}
			catch (error:Error) {
			}
			
			isPaused = false;
			isPlaying = false;
			_soundChannel.stop();
			
			dispatchEvent(new Event(ON_PLAY_STATE_CHANGE));
			
			//timer
			__timerStop()
			
			_playStarted = false;
		}
		
		public function stopAndCloseStream():void 
		{
			
			try {
				_sound.close();
			}
			catch (error:Error) {
			}
			
			stop();
		}
		
		public function play():void {
			
			
			if (isPlaying==true) return
			
			isPaused = false;
			isPlaying = true;
			//position = 0;
			load(_urlFile);
			
			dispatchEvent(new Event(ON_PLAY_STATE_CHANGE));
			
			//timer
			__timerStart()
		}
		
		public function pause():void {
			
			isPaused = !isPaused;
			
			switch (isPaused) {
				case true:
					// vai pausar
					_lastPosition = position;
					_soundChannel.stop();
					dispatchEvent(new Event(ON_PLAY_STATE_CHANGE));
				break;
				case false:
					// vai tocar
					position = _lastPosition;
					dispatchEvent(new Event(ON_PLAY_STATE_CHANGE));
				break;
			}
		}
		
		/**
		 * Para e remove todos loops
		 */
		public function remove():void {
			__timerStop();
			__removeListeners();
			
			_sound.close();
			_sound = null;
			_soundChannel.stop();
		}
		
		private function loadProgressHandler(e:ProgressEvent):void {
			
			
			bytesLoaded = e.bytesLoaded;
			bytesTotal = e.bytesTotal;
			percentLoaded = (bytesLoaded * 100) / bytesTotal;
			
			isBuffering = _sound.isBuffering;
			
			
			// 'calculeiras'
			var _timeElapsed:Number = getTimer() - _timeStart;
			kbpsCurrent = Math.floor(bytesLoaded / _timeElapsed);
			kbpsRequired = Math.floor(bytesTotal / (duration * 1000));
			percentUserSpeed = (kbpsCurrent * 100) / kbpsRequired;
			
			dispatchEvent(new Event(LOAD_PROGRESS));
			
			// checa se vai disparar onBuffer...
			if (isBuffering!=_oldIsBuffering) {
				
				switch (isBuffering) {
					case true:
						dispatchEvent(new Event(ON_BUFFER_EMPTY));
						break
					case false:
						dispatchEvent(new Event(ON_BUFFER_FULL));
							
						if (_timer.running == false && duration > 1) {
							__timerStart();
						}
						break
				}
			}
			
			_oldIsBuffering = isBuffering;
			
		}
		
		private function id3Handler(e:Event):void {
			id3 = ID3Info(_sound.id3);
			dispatchEvent(new Event(ID3));
		}
		
		private function loadCompleteHandler(e:Event):void {
			isBuffering = false;
			percentLoaded = 100;
			percentUserSpeed = 100;
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		private function soundCompleteHandler(e:Event):void {
			dispatchEvent(new Event(SOUND_COMPLETE));
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			error = e.type + ' ' + e.text + ' @Mp3Loader URL:'+_urlFile;
			dispatchEvent(new Event(ON_ERROR));
			__timerStop();
		}
		
		/**
		 * Handler do timer que checa o progresso da reprodução
		 */
		private function __handleTimer(e:TimerEvent):void {
			//Main.trace( "__handleTimer : " + __handleTimer );
			
			var dif:Number = position - _oldPosition;
			
			//Main.trace( "dif : " + dif );
			
			if (_playStarted != true && _sound.isBuffering!=true) {
				dispatchEvent(new Event(ON_PLAY_START)); // inicio da reprodução
				_playStarted = true;
			}
			
			if (dif < 1 && isPaused == false && isPlaying == true && (duration - position) < 2) {
				/*
				Main.trace('***********************************');
				Main.trace( "position : " + position );
				Main.trace( "duration : " + duration );
				Main.trace( "isLoading : " + isLoading );
				Main.trace( "percentLoaded : " + percentLoaded );
				Main.trace('***********************************');
				*/
				
				// !!! alguns metodos do stop() provocavaem confilto
				// sound.close() por exemplo
				// parar os processos desta maneira e mais seguro
				
				__timerStop();
				
				isPaused = false;
				isPlaying = false;
				_playStarted = false;
				
				dispatchEvent(new Event(SOUND_COMPLETE));
			} else {
				if (position!=_oldPosition) {
					// esta tocando
					dispatchEvent(new Event(ON_PLAY_PROGRESS)); // progresso da reprodução
				}
			}
			
			
			_oldPosition = position;
			//Main.trace( "position : " + position );
			//Main.trace( "_oldPosition : " + _oldPosition );
		}
		
		private function __timerStart():void {
			_timer.start();
		}
		
		private function __timerStop():void {
			_timer.stop();
		}
		
		public function get isLoading():Boolean {
			return percentLoaded<100;
		}
		
		public function get percentPlayed():Number {
			var p:Number = ((position * 100) / duration); // IMPORTANTE troquei length por duration
			return Number(p);
		}
		
		public function get position():Number {
			return Math.floor(_soundChannel.position/1000);
		}
		
		public function set position(value:Number):void {
			value = Math.floor(value)* 1000;
			_soundChannel.stop();
			_soundChannel = _sound.play(value);
			isPaused = false;
			isPlaying = true;
			volume = _volume;
			
			dispatchEvent(new Event(ON_PLAY_PROGRESS));
		}
		
		public function get duration():Number {// a duração é estimada
			var _length:Number = Math.floor(((_sound.length * 100)/percentLoaded)/1000);
			return _length;
		}
		
		public function get bufferTime():Number {
			return _soundLoaderContext.bufferTime/1000;
		}
		
		public function set bufferTime(value:Number):void {
			_soundLoaderContext.bufferTime = value*1000;
		}
		
		public function get volume():Number {
			return _volume;
		}
		
		public function set volume(value:Number):void {
			var transform:SoundTransform = _soundChannel.soundTransform
			transform.volume = value;
			_soundChannel.soundTransform = transform;
			_volume = value;
		}
		
		public function get peak():Number {
			var p:Number = _soundChannel.leftPeak + _soundChannel.rightPeak
			p = p / 2;
			return p;
		}
		
	}
}