

package {
	import flash.display.*
	import flash.events.*;
	import flash.text.TextField;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.*
	
	
	public class Tracebox {
		// number
		// string
		// display obj
		// array
		// obj
		
		public static function traceObj(obj:*, identificacao:String=''):void {
			identificacao = String(identificacao);
			var i:Number, obj2:*
			var falta:Number = Math.round((35 - identificacao.length) / 2) - 1;
			var asteriscos:String = '';
			while (asteriscos.length<falta) {
				asteriscos += '*';
			}
			var linhaInicial:String = asteriscos +' '+ identificacao + ' '+asteriscos;
			
			__trace(linhaInicial);
			
			
			if (obj is Number) { //Number
				
				__trace(identificacao + ':' + typeof obj + ' = ' + obj);
				
			} else if (obj is String) { //String
				
				__trace(identificacao + ':' + typeof obj + ' = ' + obj);
				
			} else if (obj is Array) { //Array
				
				__trace(identificacao + ':Array');
				
				for (var j:int = 0; j < obj.length; j++) {
					__traceProperty(j, obj)
					obj2 = obj[j];
					if (obj2 is Object) {
						for (var k:String in obj2) {
							__trace('\t     ' + k + ':'+obj2[k])
						}
					}
				}
				
			} else if (obj is DisplayObject) { //DisplayObject e demais
				
				__trace('\t '+ obj);
				
				__traceProperty('name', obj)
				__traceProperty('x', obj)
				__traceProperty('y', obj)
				__traceProperty('width', obj)
				__traceProperty('height', obj)
				__trace('');
				__traceProperty('visible', obj)
				__traceProperty('alpha', obj)
				__traceProperty('mouseEnabled', obj)
				__traceProperty('tabIndex', obj);
				__trace('');
				
			} else if (obj is Object) { //Object
				
				__trace(identificacao + ':Object');
				
				for (k in obj) {
					__traceProperty(k, obj)
				}
				
			} 
			
			if (obj is MovieClip) { //caso especial para movieclips
				__traceProperty('currentFrame', obj)
				__traceProperty('currentLabel', obj)
			}
			
			if (obj is MovieClip || obj is Sprite) {
				__trace('\t parent = ' + obj.parent);
				__trace('\t children = ' + McUtils.getChilds(obj));
				__trace('');
			}
			
			if (obj is TextField) { //caso especial para textfield
				__traceProperty('text', obj)
				__trace('');
			}
			
			
			__trace('***********************************');
			__trace('');
			__trace('');
		}
		
		public static function msg(texto:*):void {
			__trace(texto);
		}
		
		static private function __traceProperty(prop:*, obj:*):void{
			
			__trace('\t ' + prop + ' = ' + obj[prop]);
		}
		
		private static function __trace($str:String):void {
			trace($str);
			
			var connSender:LocalConnection
			connSender = new flash.net.LocalConnection();
			connSender.addEventListener(StatusEvent.STATUS, __onStatus);
			connSender.send('localhost:TraceBox', 'addText', $str);
		}

		private static function __onStatus(e:StatusEvent):void {
			//trace(e);
		}
	}
}