package com.withlasers.ui{
	import flash.display.*
	import flash.events.*;
	import flash.text.*;
	import gs.TweenMax
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class FormCampoSimples implements IFormCampo {
		public static const COLOR_OUT:String = 'out'
		public static const COLOR_ACTIVE:String = 'active'
		public static const COLOR_ERROR:String = 'error'
		
		public var mc:Sprite
		
		private var __tfInput:TextField	
		private var __textoLabel:String;
		private var __text:String // texto apresentado
		private var __value:String // valor digitado
		private var __msgErro:String
		private var __lm:ListenersManager
		
		public var colors:Array = [0x000000, 0xcccccc, 0xffffff, 0x000000, 0xffffff, 0xaa0000 ]
		
		public function FormCampoSimples($mc:DisplayObjectContainer, $textoLabel:String) {
			
			mc = Sprite($mc);
			__textoLabel = $textoLabel;
			
			__tfInput = mc['mcFront'].tf;
			__tfInput.text = __textoLabel;
			
			value = '';
			__msgErro = '';
			
			/* atribui listeners */
			__lm = new ListenersManager();
			__lm.add(mc, Event.REMOVED_FROM_STAGE, __removeListeners); //remove os listeners quando sair do stage
			__lm.add(__tfInput, FocusEvent.FOCUS_IN, onFocusHandler);
			__lm.add(__tfInput, FocusEvent.FOCUS_OUT, onKillFocusHandler);
			__lm.add(__tfInput, Event.CHANGE, onChangedHandler);
			
			setColor(COLOR_OUT, 0);
		}
		
		private function onFocusHandler():void{
			
			setColor(COLOR_ACTIVE);
			
			if (text==__textoLabel || text==__msgErro) {
				text = value;
			}
		}
		
		private function onKillFocusHandler():void{
			
			setColor(COLOR_OUT);
			
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
		
		public function set value(t:String):void {
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
		public function showError(msg:String):void {
			//Selection.setFocus(null); // Isto não é necessário
			
			__msgErro = msg;
			text = __msgErro;
			
			setColor(COLOR_ERROR);
		}
		
		public function setColor($color:String, $tempo:Number = 0.3):void {
			var colorFront:Number
			var colorBack:Number
			
			switch ($color) {
				case COLOR_OUT:
					colorFront = colors[0]
					colorBack = colors[1]
				break
				case COLOR_ACTIVE:
					colorFront = colors[2]
					colorBack = colors[3]
				break
				case COLOR_ERROR:
					colorFront = colors[4]
					colorBack = colors[5]
				break
			}
			
			__setColorFront(colorFront, $tempo);
			__setColorBack(colorBack, $tempo);
		}
		
		public function __setColorFront($color:Number, $tempo:Number=0.3):void {
			//TweenMax.to(__tfInput, $tempo, {tint:$color});
			__tfInput.textColor = $color;
		}
		
		public function __setColorBack($color:Number, $tempo:Number=0.3):void {
			TweenMax.to(mc['mcBack'], $tempo, {tint:$color});
		}
		
	}
	
}