package com.withlasers.ui
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class MaskedInput
	{
		public var tf:TextField
		public var pattern:String
		
		public var previousValue:String
		
		public function MaskedInput($tf:TextField, $pattern:String='##/##/####', $restrict:String='0-9') 
		{
			tf = $tf;
			pattern = $pattern;
			previousValue = ''
			tf.type = TextFieldType.INPUT;
			
			__restringe($restrict)
			__addListeners()
		}
		
		private function __restringe($r:String):void
		{
			tf.restrict = $r;
		}
		
		private function __addListeners():void
		{
			tf.addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved)
			tf.addEventListener(Event.CHANGE, __handleChange)
		}
		
		private function __handleRemoved(e:Event):void 
		{
			__removeListeners()
		}
		
		private function __removeListeners():void
		{
			tf.removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			tf.removeEventListener(Event.CHANGE, __handleChange);
		}
		
		private function __handleChange(e:Event):void 
		{
			if (value.length > pattern.length)
			{
				value = previousValue
				return;
			}
			
			if (value.length < previousValue.length)
			{
				previousValue = value
				return;
			}
			
			__formata()
			
			previousValue = value;
		}
		
		private function __formata():void
		{
			var l:int = value.length;
			
			var saida:String = pattern.substring(0,1);
			var texto:String = pattern.substring(l);
			
			if (texto.substring(0,1) != saida) 
			{
				//caso normal
				value += texto.substring(0, 1);
			} 
				else 
			{
				// caso deletou um caractere da mascara e digitou outro
				var addedC:String = value.substr(l - 1, 1);
				var maskC:String = pattern.substr(l - 1, 1);
				
				if (maskC!='#') 
				{
					value = value.substring(0, l-1)+maskC+addedC
				}
			}
			
			// manda o cursor para o fim
			tf.setSelection(value.length, value.length)
		}
		
		public function set value($v:String):void 
		{
			tf.text = $v;
		}
		public function get value():String 
		{
			return tf.text
		}
		
		public function destroy():void 
		{
			__removeListeners();
		}
		
	}

}