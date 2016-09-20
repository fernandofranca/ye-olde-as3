/*
	var urlPost = 'http://fiberinteractive.com.br/teste-post.php'
	var dados = {}
	dados.Email = 'test....';
	dados.Nome = 'XYZ';


	var p:SendAndLoad = new SendAndLoad(urlPost, dados)
	p.onSuccess = carregado
	p.onError = erro
	p.send();

	function carregado () {
		trace('!!!');
		obj = p.resposta;
		for (var i in obj) {
			trace(i, obj[i])
		}
	}

	function erro () {
		trace('Nao rolou. ' + p.erro)
	}
*/
	
// NOVO remove listeners nos erros ou sucesso
// NOVO implementação timeout

package {
	import flash.events.*;
	import flash.net.*
	//import com.withlasers.debug.Tracer
	import flash.utils.Timer
	
	public class SendAndLoad {
		public static var TIMEOUT_ERROR:String = 'SENDANDLOAD_TIMEOUT_ERROR';
		
		public var onSuccess:Function
		public var onError:Function
		public var url:String
		public var resposta:*; //resposta do POST (se retornar como variables é um objeto, senao String)
		public var erro:String; //erro ocorrido no envio
		public var dadosRespostaServer:* // recurso para expor o que o server retornou
		public var debugMode:Boolean = false;
		
		private var request:URLRequest
		private var loader:URLLoader
		private var timeout:Timer
		
		
		public function SendAndLoad ($url:String, $dados:Object, $variablesMode:Boolean=true, $tempoTimeout:Number=10, $debug:Boolean = false) {
			url = $url;
			debugMode = $debug;
			
			//converter o objeto para _vars
			
			request = new URLRequest($url);  
			loader = new URLLoader();
			request.method = URLRequestMethod.POST;
			
			if ($variablesMode==true) {
				request.data = __converteObjeto($dados);  //dados a serem enviados
				loader.dataFormat = URLLoaderDataFormat.VARIABLES;  
			} else {
				request.data = __converteString($dados);  //dados a serem enviados
				loader.dataFormat = URLLoaderDataFormat.TEXT;  
			}
			
			timeout = new Timer($tempoTimeout * 1000, 0);
			timeout.addEventListener(TimerEvent.TIMER, __onTimeout)
			
			loader.addEventListener(Event.COMPLETE, __onSuccess);  
			loader.addEventListener(IOErrorEvent.IO_ERROR, __onIOError);
			
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, __onStuff);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __onSecurityError);
		}
		
		private function __onStuff(e:*):void {
			trace('... '+e);
		}
		
		private function __converteString($objeto:*):String {
			var str:String = '';
			
			for (var i:String in $objeto) {
				str+=i+'='+$objeto[i]+'&'
			}
			
			trace(str);
			
			return str;
		}
		
		private function __converteObjeto($objeto:*):URLVariables { // converte objeto para UrlVariables
			
			var uv:URLVariables = new URLVariables();
			
			for (var i:String in $objeto) {
				uv[i] = $objeto[i];
			}
			
			return uv;
		}
		
		private function __onIOError(e:IOErrorEvent):void {
			trace('__onIOError');
			
			try {
				erro = e.text;
				onError();
			} catch (e:Error){ }
			
			__removeEventListeners();
		}
		
		private function __onSecurityError(e:SecurityErrorEvent):void {
			trace('__onSecurityError');
			
			try {
				erro = e.text;
				onError();
			} catch (e:Error){ }
			
			__removeEventListeners();
		}
		
		private function __onTimeout(e:TimerEvent):void {
			trace('__onTimeout');
			
			try {
				erro = TIMEOUT_ERROR;
				onError();
			} catch (e:Error){ }
			
			__removeEventListeners();
		}
		
		private function __onSuccess(event:Event):void {
			trace('__onSuccess');
			
			var ldr:URLLoader = URLLoader(event.target);  
			dadosRespostaServer = ldr.data;
			var objResposta:Object = { };
			
			trace('DataFormat: ' + ldr.dataFormat);
			trace(ldr.data);
			
			if (ldr.dataFormat == URLLoaderDataFormat.VARIABLES) {
				
				// constroi um objeto para resposta
				try {
					for (var i:String in dadosRespostaServer) {
						objResposta[i] = dadosRespostaServer[i];
					}
					
					resposta = objResposta
					onSuccess();
				} catch (e:Error){ }
				
			} else {
				
				// trata como URLLoaderDataFormat.TEXT
				try {
					resposta = dadosRespostaServer;
					onSuccess();
				} catch (e:Error){ }
			}
			
			__removeEventListeners();
		}
		
		/**
		 * Remove todos event listeners
		 */
		private function __removeEventListeners():void {
			trace('__removeEventListeners()');
			
			timeout.stop();
			timeout.removeEventListener(TimerEvent.TIMER, __onTimeout)
			
			loader.removeEventListener(Event.COMPLETE, __onSuccess);  
			loader.removeEventListener(IOErrorEvent.IO_ERROR, __onIOError);
			
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, __onStuff);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __onStuff);
		}
		
		public function send($post:Boolean = true):void {
			
			if ($post==true) {
				request.method = URLRequestMethod.POST;
			} else {
				request.method = URLRequestMethod.GET; 
			}
			
			loader.load(request);
			timeout.start();
		}
		
		/**
		 * Termina a operação e remove os listeners
		 */
		public function cancel():void {
			trace('__cancel()');
			__removeEventListeners();
			
			loader.close();
			timeout.stop();
		}
		
		private function trace($t:*):void {
			try {
				//if (debugMode == true) Tracer.getInstance().trace('SendAndLoad: ' + $t);
			} catch (e:Error){ }
		}
	}
}