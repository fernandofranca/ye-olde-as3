/**
 * Adicionei o label como getter/setter
 * 
 * Excluí a necessidade de parametros para instanciar e extendi da movieclip, 
 * 	possibilitando que movieclips extendam esta classe
 * 
 * A classe implementa IFormCampo que será a nova interface basica para todo Form
 */
package com.withlasers.ui {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	
	public class CampoTexto extends MovieClip implements IFormCampo {
		
		public static const ON_CHANGE:String = 'on_change';
		
		public var mc:MovieClip
		public var frameOut:Number
		public var frameOver:Number
		public var frameError:Number
		
		/**
		 * O campo esta sendo editado pelo usuario?
		 */
		public var isFocused:Boolean = false
		
		private var __tfInput:TextField	
		private var __textoLabel:String;
		private var __text:String // texto apresentado
		private var __value:String // valor digitado
		private var __msgErro:String
		private var __lm:ListenersManager
		private var __password:Boolean = false
		
		public function CampoTexto ():void { 
			mc = this;
			__textoLabel = '';
			
			__tfInput = mc.mcInput.textField_txt;
			__tfInput.text = __textoLabel;
			
			frameOut = 1;
			frameOver = 10;
			frameError = 15;
			
			gotoAndStop(frameOut);
			
			value = '';
			__msgErro = '';
			
			/* atribui listeners */
			__lm = new ListenersManager();
			__lm.add(mc, Event.REMOVED_FROM_STAGE, __removeListeners); //remove os listeners quando sair do stage
			__lm.add(__tfInput, FocusEvent.FOCUS_IN, onFocusHandler);
			__lm.add(__tfInput, FocusEvent.FOCUS_OUT, onKillFocusHandler);
			__lm.add(__tfInput, Event.CHANGE, onChangedHandler);
			
			
		}
		
		private function onFocusHandler():void {
			isFocused = true;
			McUtils.playTo(mc, frameOver);
			if (text==__textoLabel || text==__msgErro) {
				text = value;
				__tfInput.displayAsPassword = password;
			}
		}
		
		private function onKillFocusHandler():void {
			isFocused = false;
			McUtils.playTo(mc, frameOut);
			if (value=='') {
				text = __textoLabel;
				__tfInput.displayAsPassword = false;
			}
		}
		
		private function onChangedHandler():void{
			value = __tfInput.text
			dispatchEvent(new Event(ON_CHANGE));
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
		
		public function set value(v:String):void {
			__value = v;
			
			if (value=='' && isFocused==false) { // !NOVO - resolve o problema de deletar todos caracteres e aparecer o label enquanto digita
				text = __textoLabel;
				__tfInput.displayAsPassword = false;
			} else {
				__tfInput.text = v; // !NOVO!
				__tfInput.displayAsPassword = password;
			}
			
		}
		
		override public function get tabIndex():int { 
			return __tfInput.tabIndex;
		}
		
		override public function set tabIndex(value:int):void {
			__tfInput.tabIndex = value;
		}
		
		public function get label():String { 
			return __textoLabel;
		}
		
		public function set label(value:String):void {
			if (__tfInput.text == __textoLabel) __tfInput.text = value;
			__textoLabel = value;
		}
		
		public function get password():Boolean { return __password; }
		
		public function set password(value:Boolean):void {
			__password = value;
		}
		
		/* mostra mensagem de erro */
		public function showError(msg:String):void {
			//Selection.setFocus(null); // Isto não é necessário
			
			__msgErro = msg;
			text = __msgErro;
			__tfInput.displayAsPassword = false;
			
			mc.gotoAndStop(frameOver);
			McUtils.playTo(mc, frameError);
		}
	}
}