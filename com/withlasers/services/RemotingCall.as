package com.withlasers.services {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class RemotingCall extends EventDispatcher {
		private var __responder:Responder
		private var __service:NetConnection
		private var __timer:Timer
		
		private var __metodo:String
		private var __cbSucess:Function
		private var __cbError:Function
		
		public var isCanceled:Boolean = false;
		
		public function RemotingCall($service:NetConnection, $nomeMetodo:String, $parametros:Array = null, $onSuccess:Function = null, $onError:Function = null, $timeOut:Number=10000) {
			__service = $service;
			__responder = new Responder(__onSuccess, __onError);
			__metodo = $nomeMetodo;
			__cbSucess = $onSuccess;
			__cbError = $onError;
			
			__timer = new Timer($timeOut);
			__timer.addEventListener(TimerEvent.TIMER, __handleTimeout);
			__timer.start();
			
			
			if ($parametros==null) $parametros = [];
			$parametros.unshift(__responder);
			$parametros.unshift(__metodo);
			
			
			if ($parametros.length > 2) {
				__service.call.apply(null, $parametros);
			} else {
				__service.call(__metodo, __responder);
			}
		}
		
		private function __handleTimeout(e:TimerEvent):void {
			__stopTimer();
			
			__onError('TIMEOUT: '+__timer.delay);
		}
		
		private function __onSuccess($res:*):void {
			//Main.trace( "RemotingCall.__onSuccess : " + $res );
			
			if (isCanceled==true) return // para se estiver cancelado
			
			// timer
			__stopTimer();
			
			dispatchEvent(new RemotingEvent(RemotingEvent.ON_SUCESS, $res));
			
			if (__cbSucess!=null) {
				try {
					__cbSucess($res);
				} catch (e:Error) {
					throw(e);
				}
			}
			
			__responder = null;
			cancel();
		}
		
		private function __onError($res:*):void {
			//Main.trace( "RemotingCall Error : " + $res );
			
			if (isCanceled==true) return // para se estiver cancelado
			
			var str:String = 'RemotingCall Error! Method>' + __metodo + '\n';
			
			if ($res is String) {
				str = str+$res;
			} else {
				for ( var i:String in $res ) str += i + " = " + $res[ i ] + "\n";
			}
			
			__stopTimer();
			
			dispatchEvent(new RemotingEvent(RemotingEvent.ON_ERROR, str));
			
			if (__cbError!=null) {
				try {
					__cbError(str);
				} catch (e:Error) {
					throw(e);
				}
			}
			
			
			__responder = null;
			cancel();
		}
		
		private function __stopTimer():void {
			__timer.stop();
			__timer.removeEventListener(TimerEvent.TIMER, __handleTimeout);
		}
		
		public function cancel():void {
			isCanceled = true;
			__destroy();
		}
		
		private function __destroy():void {
			
			__stopTimer();
			
			__responder = null;
			__service = null;
			__timer = null;
			
			__metodo = null;
			__cbSucess = null;
			__cbError = null;
		}
		
	}
	
}