package {
	import flash.display.*
	import flash.events.*;
	import flash.ui.Keyboard;
	
	
	
	public class Shortcuts {
		private var arrKeys:Array
		private var arrKeyCode:Array;
		
		private var __stage:Stage;
		public var enabled:Boolean = true;
		
		
		public function Shortcuts ($stage:Stage):void {
			arrKeys = []
			arrKeyCode = []
			__stage = $stage
			__stage.addEventListener(KeyboardEvent.KEY_DOWN, __keyListener);
		}
		
		public function add(tecla:String, funcao:Function):void {
			arrKeys.push( {tecla:tecla, funcao:funcao } );
		}
		
		public function addKey($keyCode:int, funcao:Function):void 
		{
			arrKeyCode.push( {keyCode:$keyCode, funcao:funcao } );
		}
		
		public function remove(tecla:String):void {
			var code:Number = tecla.charCodeAt(0);
			var c:Number
			
			
			for (var i:int = 0; i < arrKeys.length; i++) {
				c = String(arrKeys[i].tecla).charCodeAt(0);
				if (c == code) {
					arrKeys.splice(i, 1);
				}
				
			}
		}
		
		public function removeAll():void {
			arrKeys = [];
			arrKeyCode = [];
			__stage.removeEventListener(KeyboardEvent.KEY_DOWN, __keyListener);
			__stage = null;
		}
		
		private function __keyListener(e:KeyboardEvent):void {
			var code:Number = e.charCode;
			var keyCode:int = e.keyCode;
			
			var c:Number, fun:Function
			var i:int
			
			//se estiver habilitado continua
			if (enabled == true) 
			{ 
				// strings
				for (i=0; i < arrKeys.length; i++) {
					c = String(arrKeys[i].tecla).charCodeAt(0);
					fun = arrKeys[i].funcao;
					
					if (c == code) {
						try {
							fun();
						} catch (e:Error){
						}
					}
					
				}
				
				// keycodes
				for (i = 0; i < arrKeyCode.length; i++) {
					c = arrKeyCode[i].keyCode
					fun = arrKeyCode[i].funcao;
					
					if (c == keyCode) {
						try {
							fun();
						} catch (e:Error){
						}
					}
					
				}
			}
		}
		
		
	}
}