package {
	import flash.net.*;
	import flash.utils.getTimer;

	public class Utils {
		public static var lastTime:Number = 0;
		
		public static function gcHack():void {
			// unsupported technique that seems to force garbage collection
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e:Error) {}
		}
		
		/**
		 * 
		 * converte os valores da string do window.location.search em um objeto
		 * ex: 
		 *  no htm :
		 *  so.addVariable('queryString', escape(window.location.search.toString()));
		 *
		 *	no flash:
		 *	s = '?q=window+location&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a'
		 */
		public static function converteWindowLocationSearch($locationString:String):Object {
			var _objetoDestino:Object = {}
			var _pares:Array
			
			//EmbedPlayer.swf?name_id=sc2&op=y
			
			$locationString = $locationString.substr($locationString.indexOf('?')+1);
			$locationString = unescape($locationString); //trata porque ja deve checar escaped
			$locationString = $locationString.split('?').join(''); //remove o '?'
			_pares = $locationString.split( '&' ); //splita em pares
			
			var _par:*
			var _chave:*
			var _valor:*
			
			//atribui ao objeto destino
			for (var i:Number = 0; i < _pares.length; i++) {
				
				_par = _pares[i].split('=');
				
				_chave = _par[0]
				_valor = _par[1]
				
				_objetoDestino[_chave] = _valor;
			}
			return _objetoDestino;
		}
		
		public static function stopWatch():Number 
		{
			var ret:Number =  getTimer() - lastTime;
			
			lastTime = getTimer();
			
			return ret
		}
		
		public static function getCallStack():String 
		{
			var str:String = new Error().getStackTrace();
			var lines:Array = str.split("\n");
			var ret:String = "";
			
			lines.splice(1, 1); // remove o primeiro elemento, que é a chamada a esta funcao
			
			for each (var line:String in lines) 
			{
				line = line.replace("at ", "");
				line = line.replace("/", ".");
				var i0:int = line.indexOf("[");
				var i1:int = line.lastIndexOf(":")
				var i2:int = line.lastIndexOf("]");
				
				ret += line.substring(0, i0) + line.substring(i1, i2) + "\n";
			}
			
			str = line = "";
			lines.length = 0;
			
			return ret
		}
	}
}