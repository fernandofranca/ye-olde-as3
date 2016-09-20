/**
 * 
 * Ex.:
 * 
	lcn = new LocalConnector('myConn2');
	lcn.signalConnected.add(representaEstado); // restra uma funcao para quando o estado de conexao mudar
	lcn.registerMethod('sendMsg', __receive); // registra um metodo para ser chamado remotamente
	lcn.signalLog.add(tracer); // registra uma funcao para log
	
	// checa se a conexao esta disponivel
		lcn.checkRemoteConnection();
		lcn.signalCheckRemoteConnected.addOnce(tracer);
		
	// chama um metodo registrado em outra instancia
		lcn.callMethod('sendMsg', [getTimer()]);
		
	// conecta esta instancia, desconectando qualquer outra instancia, se houver
		lcn.connect(true);
 */

package com.withlasers.util {
	import flash.net.LocalConnection;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	
	/**
	 * Da suporte a comunicação entre instancias diferentes via um canal de LocalConnection
	 * @author Fernando de França
	 */
	public class LocalConnector {
		
		/**
		 * Nome da conexao em uso
		 */
		public var name:String
		
		/**
		 * Esta instancia esta conectada?
		 */
		public var isConnected:Boolean = false;
		
		/**
		 * Intervalo entre as tentativas de conexao
		 */
		public var retryDelay:Number
		
		/**
		 * Mensagens diversas de status
		 */
		public var signalLog:Signal = new Signal(String);
		
		/**
		 * Sinaliza quando a conexao local conecta ou desconecta
		 */
		public var signalConnected:Signal = new Signal(Boolean)
		
		/**
		 * Confirmação do metodo checkRemoteConnection()
		 */
		public var signalCheckRemoteConnected:Signal = new Signal(Boolean)
		
		/**
		 * Confirma ou não a execução de um send
		 */
		public var signalExec:Signal = new Signal(Boolean);
		
		protected var __methods:* = { };
		protected var conn:LocalConnection
		protected var retryAttempts:int = 0;
		
		public var id:String
		
		/**
		 * Instancia um conector
		 * @param	$name			Nome da conexao que sera compartilhada
		 * @param	$domain			Dominio
		 * @param	$retryDelay		Intervalo entre as tentativas de conexao
		 */
		public function LocalConnector($name:String, $domain:String = '*', $retryDelay:Number = 300) {
			name = $name;
			retryDelay = $retryDelay;
			id = $name + '_' + String(Math.random()).substr(2);
			
			__createConnection($domain);
		}
		
		protected function __createConnection($domain:String):void
		{
			conn = new LocalConnection();
			conn.allowDomain($domain);
			
			conn.addEventListener(StatusEvent.STATUS, __handleStatus, false, 0, true);
			
				//? necessario ?
				//conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, __handleLcAsync);
				//conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __handleLcSecError);
		}
		
		/**
		 * Remove conexao e todos listeners
		 */
		public function destroy():void 
		{
			disconnect();
			
			conn.removeEventListener(StatusEvent.STATUS, __handleStatus, false);
			
			signalCheckRemoteConnected.removeAll();
			signalConnected.removeAll();
			signalExec.removeAll();
			signalLog.removeAll();
			
			for (var name:String in __methods) 
			{
				__methods[name] = null;
			}
		}
		
		/**
		 * Checa se uma conexao remota com mesmo nome esta sendo usada
		 */
		public function checkRemoteConnection():void 
		{
			__log( "checkRemoteConnection : " );
			
			signalExec.addOnce(function($b:Boolean):void { signalCheckRemoteConnected.dispatch($b); } );
			conn.send(name, '__remoteCheck');
		}
		
		protected function __remoteCheck():void 
		{
		}
		
		/**
		 * Conecta esta instancia
		 * @param	$dropRemoteConnection	Derruba outra conexao, se necessário
		 */
		public function connect($dropRemoteConnection:Boolean=false):void 
		{
			__log( "connect () - retry attempts: " + retryAttempts + ')' );
			
			try {
				conn.client = this;
				conn.connect(name);
				
				isConnected = true;
				
			} catch (e:Error) {
				
				__log( "connect Error: " +e.name + ' ' + e.message);
				
				isConnected = false;
				
				if ($dropRemoteConnection==true) 
				{
					retryAttempts++;
					remoteDisconnect();
					setTimeout(connect, 300, true);
				}
			}
			
			signalConnected.dispatch(isConnected);
			
			__log('connected =' + isConnected);
		}
		
		/**
		 * Desconecta local
		 */
		public function disconnect():void 
		{
			isConnected = false;
			
			signalConnected.dispatch(isConnected);
			
			__log( "disconnect()" );
			
			conn.close();
		}
		
		/**
		 * Desconecta a conexão remota
		 */
		public function remoteDisconnect():void 
		{
			__log( "remoteDisconnect()" );
			
			conn.send(name, 'disconnect');
		}
		
		/**
		 * Registra um metodo (local) para ser chamado via callMethod
		 * @param	$methodName			Identificação do metodo
		 * @param	$methodReference	Referencia do metodo
		 */
		public function registerMethod($methodName:String, $methodReference:Function):void 
		{
			__methods[$methodName] = $methodReference;
		}
		
		/**
		 * Executa um metodo na conexao remoto
		 * @param	$nomeMetodo
		 * @param	$parametros
		 */
		public function callMethod($nomeMetodo:String, $parametros:Array = null):void {
			
			// checa se não esta chamando a si mesmo
			/*
			if (isConnected==true) 
			{
				__log('This instance is already connected! Call aborted.');
				return
			}
			*/
			
			
			if ($parametros == null) $parametros = [];
			
			$parametros.push(id);
			
			conn.send(name, '__execMethod', $nomeMetodo, $parametros);
		}
		
		public function __execMethod($methodName:String, $parametros:Array):void 
		{
			// checa se não esta chamando a si mesmo
			var caller:* = $parametros.pop();
			
			if (caller==id) 
			{
				__log('Ops, I´m calling myself! Call aborted.');
				return
			}
			
			__log('execMethod: ' + $methodName + '(' + $parametros.join(',')+')');
			
			try {
				__methods[$methodName].apply(null, $parametros);
			} catch (e:Error){
				__log('execMethod Error: ' + e.message);
			}
			
		}
		
		protected function __handleStatus(e:StatusEvent):void 
		{
			switch (e.level) {
                case "status":
                    __log("send() [succeeded]");
					
					signalExec.dispatch(true);
                break;
                case "error":
                    __log("send() [failed]");
					
					signalExec.dispatch(false);
                break;
            }
		}
		
		protected function __onAsyncErrorHandler($evt:AsyncErrorEvent):void {
			__log('AsyncError > ' +$evt);
		}
		
		protected function __log($str:String):void 
		{
			signalLog.dispatch($str);
		}
		
	}
	
}