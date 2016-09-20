package {
	import flash.display.*
	import flash.events.*;
	
	
	public class ListenersManager  {
		private var arrListeners:Array = [];
		
		/*
		 * Registra listeners ao objeto
		 */
		public function add ($obj:*, $evento:*, $handler:Function, $handlerParams:Array = null, $incluiEvento:Boolean = false):void {
			
			if ($handlerParams == null) $handlerParams = [];
			
			if ($incluiEvento == true) $handlerParams.unshift('');
			
			var tmpFunc:Function = function (e:*):void {
				if ($incluiEvento == true) $handlerParams[0]=e;
				$handler.apply(null, $handlerParams);
			}
			
			arrListeners.push( { obj:$obj, evento:$evento, handler:tmpFunc } );
			
			$obj.addEventListener($evento, tmpFunc);
		}
		
		/* versao anterior
		public function add ($obj:*, $evento:*, $handler:Function):void {
			arrListeners.push( { obj:$obj, evento:$evento, handler:$handler } );
			
			$obj.addEventListener($evento, $handler);
		}
		*/
		
		/*
		 * Remove UM listener especifico do objeto
		 */
		public function remove($obj:Object, $evento:*):void {
			var el:*
			
			for (var i:int = arrListeners.length-1; i >=0 ; i--) {
				el = arrListeners[i]
				
				if (el.obj==$obj && el.evento==$evento) {// procura pelo objeto e evento
					el.obj.removeEventListener(el.evento, el.handler)
					arrListeners.splice(i, 1);
				}
			}
		}
		
		/*
		 * Remove TODOS listeners desta instancia da classe
		 */
		public function removeAll():void {
			var el:*
			
			for (var i:int = arrListeners.length - 1; i >= 0 ; i--) {
				el = arrListeners[i]
				arrListeners.splice(i, 1);
				el.obj.removeEventListener(el.evento, el.handler);
			}
		}
		
		/*
		 * Lista todos listeners registrados
		 */
		public function listaTodos():void {
			//FlashConnect.atrace(arrListeners, 'ListenersManager');
		}
		
		/*
		 * Lista os listeners de um objeto
		 */
		public function listaObj($obj:*):void {
			var el:*
			var t:Number = 0
			
			for (var i:int = arrListeners.length-1; i >=0 ; i--) {
				el = arrListeners[i]
				
				if (el.obj == $obj) {// procura pelo objeto
					t++
					//Tracebox.traceObj(el, 'listener #' + t);
					//FlashConnect.atrace(el, 'listener #' + t);
				}
			}
			
			//FlashConnect.atrace('Encontrou ' + t + ' listeners');
		}
	}
}