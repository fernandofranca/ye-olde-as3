
// (13/10/2010) movi esta classe da raiz para o package com.withlasers.ui
package com.withlasers.ui {
	import flash.display.*
	import flash.events.*;
	import flash.text.*;
	
	
	public class FormCampoTexto {
		
		public var mc:MovieClip
		public var frameOut:Number
		public var frameOver:Number
		public var frameError:Number
		
		private var __tfInput:TextField	
		private var __textoLabel:String;
		private var __text:String // texto apresentado
		private var __value:String // valor digitado
		private var __msgErro:String
		private var __lm:ListenersManager
		
		public function FormCampoTexto ($mc:DisplayObjectContainer, $textoLabel:String):void {
			
			mc = MovieClip($mc);
			__textoLabel = $textoLabel;
			
			__tfInput = mc.mcInput.textField_txt;
			__tfInput.text = __textoLabel;
			
			frameOut = 1;
			frameOver = 10;
			frameError = 15;
			
			value = '';
			__msgErro = '';
			
			/* atribui listeners */
			__lm = new ListenersManager();
			__lm.add(mc, Event.REMOVED_FROM_STAGE, __removeListeners); //remove os listeners quando sair do stage
			__lm.add(__tfInput, FocusEvent.FOCUS_IN, onFocusHandler);
			__lm.add(__tfInput, FocusEvent.FOCUS_OUT, onKillFocusHandler);
			__lm.add(__tfInput, Event.CHANGE, onChangedHandler);
			
		}
		
		private function onFocusHandler():void{
			McUtils.playTo(mc, frameOver);
			if (text==__textoLabel || text==__msgErro) {
				text = value;
			}
		}
		
		private function onKillFocusHandler():void{
			McUtils.playTo(mc, frameOut);
			if (value=='') {
				text = __textoLabel;
			}
		}
		
		private function onChangedHandler():void{
			value = __tfInput.text
		}
		
		private function __removeListeners():void {
			__lm.removeAll();
		}
		
	
		/* muda texto visivel ao usuario != value */
		public function get text():String {
			__text = __tfInput.text
			return __text;
		}
		
		public function set text(value:String):void {
			__tfInput.text = value;
			__text = value;
		}
		
		/* atribui valor a ser retornado pela classe */
		
		public function get value():String {
			return __value;
		}
		
		public function set value(t:String) {
			__value = t;
		}
		
		/* tabIndex */
		
		public function get tabIndex():Number { 
			return __tfInput.tabIndex;
		}
		
		public function set tabIndex(value:Number):void {
			__tfInput.tabIndex = value;
		}
		
		/* mostra mensagem de erro */
		public function showError(msg:String) {
			//Selection.setFocus(null); // Isto não é necessário
			
			__msgErro = msg;
			text = __msgErro;
			
			mc.gotoAndStop(frameOver);
			McUtils.playTo(mc, frameError);
		}
	}
}