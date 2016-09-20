package com.withlasers.services {
	import com.adobe.protocols.dict.events.ErrorEvent;
	import flash.errors.IllegalOperationError;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import vo.MusicaVO;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Remoting extends EventDispatcher {
		public var urlGateway:String;
		public var timeout:Number;
		
		private var __service:NetConnection
		
		public function Remoting($urlGateway:String, $timeout:Number=2000) {
			urlGateway = $urlGateway;
			timeout = $timeout;
			
			__service = new NetConnection();
			__service.connect(urlGateway);
			
			__service.addEventListener(AsyncErrorEvent.ASYNC_ERROR, __handleErrors)
			__service.addEventListener(IOErrorEvent.IO_ERROR, __handleErrors)
			__service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __handleErrors)
			
			__service.addEventListener(NetStatusEvent.NET_STATUS, __handleStatus)
		}
		
		private function __handleStatus(e:NetStatusEvent):void 
		{
			
			var msg:String = '...unhandled status...'
			
			//FlashConnect.trace( e.info );
			
			if (e.info.code) 
			{
				
				msg = "<br>\r\n";
				for ( var i:String in e.info ) {
					msg += i + " : " + e.info[ i ] + "<br>\r\n";
				}
				
				dispatchEvent(new RemotingEvent(RemotingEvent.ON_ERROR, msg));
			}
		}
		
		private function __handleErrors(e:ErrorEvent):void 
		{
			var msg:String = '...unhandled status...'
			
			msg = e.type + ' (' + e.code + ' ' + e.message + ')'
			dispatchEvent(new RemotingEvent(RemotingEvent.ON_ERROR, msg));
		}
		
		public function disconnect():void {
			__service.close();
		}
		
		/**
		 * Faz uma chamada a um serviço
		 * @param	$nomeMetodo
		 * @param	$parametros
		 * @param	$onSuccess	A função receberá um parametro
		 * @param	$onError	A função receberá um parametro
		 * @return
		 */
		public function call($nomeMetodo:String, $parametros:Array = null, $onSuccess:Function = null, $onError:Function = null):RemotingCall {
			return new RemotingCall(__service, $nomeMetodo, $parametros, $onSuccess, $onError, timeout);
		}
		
		
	}
	
}