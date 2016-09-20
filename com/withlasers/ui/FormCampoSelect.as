/**
 * Adicionei a possibilidade de especificar no construtor qual a classe dos subitens
 * Adicionei um textformat para o label
 * Adicionei disparo de evento ao selecionar
 * Desabilitei a tematização temporariamente (setColor)
 */
package com.withlasers.ui {
	import display.MovieClipExtended;
	import flash.display.*
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.*;
	import flash.utils.getTimer;
	import gs.easing.Expo;
	import gs.TweenMax;
	
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class FormCampoSelect extends EventDispatcher implements IFormCampo  {
		public static const ON_SELECT:String = 'event_on_select';
		
		public static const COLOR_OUT:String = 'out'
		public static const COLOR_ACTIVE:String = 'active'
		public static const COLOR_ERROR:String = 'error'
		
		public var mc:Sprite
		public var isOpened:Boolean;
		public var idItemSelected:int
		
		private var sprSubItens:MovieClipExtended
		
		private var __tfInput:TextField	
		private var __formatCondensado:TextFormat
		private var __mcBack:MovieClip
		private var __botao:MovieClip
		private var __textoLabel:String;
		private var __text:String // texto apresentado
		private var __value:String =''// valor digitado
		private var __msgErro:String
		private var __lm:ListenersManager
		
		private var __classeSubItem:Class //= FormCampoSelectItem
		
		/**
		 * 'Recurso' para evitar o bug do click/focus
		 */
		private var __lastFocus:Number
		
		/**
		 * Mouse Focus
		 */
		public var hasFocus:Boolean;
		
		/**
		 * Array dos objetos adicionados
		 */
		private var __arrValores:Array = []
		
		
		public function FormCampoSelect($mc:DisplayObjectContainer, $textoLabel:String, $classeSubItem:Class) {
			mc = Sprite($mc);
			__textoLabel = $textoLabel;
			__classeSubItem = $classeSubItem;
			
			__formatCondensado = new TextFormat();
			__formatCondensado.letterSpacing = -1.2;
			
			__tfInput = mc['tf'];
			__tfInput.defaultTextFormat = __formatCondensado;
			__tfInput.text = __textoLabel;
			__tfInput.mouseEnabled = false;
			
			__mcBack = mc['mcBack'];
			__mcBack.buttonMode = true;
			
			__botao = mc['botaoAbreFecha'];
			__botao.mouseChildren = false;
			__botao.mouseEnabled = false;
			__botao.buttonMode = true;
			
			sprSubItens = new MovieClipExtended();
			sprSubItens.width = mc.width
			sprSubItens.height = 0
			sprSubItens.y = mc.height
			mc.addChild(sprSubItens);
			
			__addListeners();
			
			setColor(COLOR_OUT, 0);
		}
		
		private function toggle():void {
			if (isOpened==true) {
				close()
			} else {
				open()
			}
		}
		
		private function close():void{
			if (isOpened == true) {
				
				// LATER !!! alterei para abrir para cima
				//TweenMax.to(sprSubItens, 0.3, { height:0, ease:Expo.easeInOut } );
				TweenMax.to(sprSubItens, 0.3, { alpha:0 } );
				//TweenMax.to(sprSubItens, 0.3, { scrollY:sprSubItens.height*-1, ease:Expo.easeOut } );
				
				isOpened = false;
				
				setColor(COLOR_OUT);
				
				__botao.scaleY = 1
			}
		}
		
		public function open():void {
			if (isOpened != true && sprSubItens.numChildren>0) {
				var nh:Number = sprSubItens.numChildren * (sprSubItens.getChildAt(0).height + 1) + 1
				// LATER !!! alterei para abrir para cima
				//TweenMax.to(sprSubItens, 0.3, { height:nh, ease:Expo.easeOut } );
				//TweenMax.to(sprSubItens, 0.3, { scrollY:0, ease:Expo.easeOut } );
				TweenMax.to(sprSubItens, 0.3, { alpha:1 } );
				sprSubItens.height = nh;
				
				
				//TweenMax.from(sprSubItens, 0.5, { alpha:0 } );
				isOpened = true;
				
				setColor(COLOR_ACTIVE);
				
				__botao.scaleY = -1
			}
			__sendToTop();
		}
		
		private function __sendToTop():void{
			var container:DisplayObjectContainer = DisplayObjectContainer(mc.parent);
			container.addChildAt(mc, container.numChildren);
		}
		
		public function addItem($label:String, $value:String, $id:String):void{
			var item:IFormCampoSelectItem = new __classeSubItem();
			item.text = $label;
			item.value = $value;
			item.id = $id;
			
			var spr:Sprite = item.mc
			spr.buttonMode = true;
			spr.y = sprSubItens.numChildren * (spr.height - 1) ;
			
			// LATER !!! alterei para abrir para cima
			//sprSubItens.y = Math.ceil((sprSubItens.numChildren * (spr.height - 1))/2) * -1 ;
			sprSubItens.y = (sprSubItens.numChildren * (spr.height - 1)) * -1 -20;
			
			sprSubItens.addChild(spr);
			
			var obj:Object = { }
			obj.label = $label;
			obj.value = $value;
			obj.id = $id;
			
			__arrValores.push(obj)
		}
		
		/**
		 * Muda o label e o value
		 */
		public function selectItem($value:String):void {
			for (var i:int = 0; i < __arrValores.length; i++) {
				if (__arrValores[i].id == $value) {
					__selectItem(__arrValores[i].label, __arrValores[i].value, __arrValores[i].id);
					break
				}
			}
		}
		
		private function __selectItem($text:String, $value:String, $id:int):void{
			text = $text;
			value = $value;
			idItemSelected = $id;
		}
		
		private function __addListeners():void{
			sprSubItens.addEventListener(MouseEvent.CLICK, __handleClickSub);
			__mcBack.addEventListener(FocusEvent.FOCUS_IN, __handleFocus);
			__mcBack.addEventListener(FocusEvent.FOCUS_OUT, __handleFocus);
			
			mc.addEventListener(Event.REMOVED_FROM_STAGE, __handleRemove);
		}
		
		private function __handleRemove(e:Event):void {
			sprSubItens.removeEventListener(MouseEvent.CLICK, __handleClickSub)
			__mcBack.removeEventListener(FocusEvent.FOCUS_IN, __handleFocus)
			__mcBack.removeEventListener(FocusEvent.FOCUS_OUT, __handleFocus)
			
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemove);
		}
		
		private function __handleFocus($evt:FocusEvent):void {
			
			switch ($evt.type) {
				case FocusEvent.FOCUS_IN:
					hasFocus = true
					open();
					__lastFocus = getTimer();
					__mcBack.addEventListener(MouseEvent.CLICK, __handleClickBotao)
				break
				case FocusEvent.FOCUS_OUT:
					hasFocus = false
					//__mcBack.removeEventListener(MouseEvent.CLICK, __handleClickBotao)
					close();
				break
			}
			
		}
		
		// clicks no stage
		private function __handleClickStage(e:MouseEvent):void {
			if (e.target!=__mcBack) {
				close()
			}
		}
		
		// clique no botao de abrir e fechar
		private function __handleClickBotao(e:MouseEvent):void {
			// 'recurso'
			if ((getTimer()-__lastFocus)>300) {
				toggle();
			}
			//
		}
		
		// clique nos subitens
		private function __handleClickSub($evt:MouseEvent):void {
			var item:* = $evt.target
			
			__selectItem(item.text, item.value, item.id);
			
			// faz o disparo do evento
			dispatchEvent(new Event(ON_SELECT, false, false));
			
			close();
		}
		
		public function get text():String {return __tfInput.text}
		public function set text(value:String):void {
			__tfInput.text = value
		}
		
		public function get value():String{return __value}
		public function set value(t:String):void{__value = t}
		
		public function get tabIndex():Number{return __mcBack.tabIndex}
		public function set tabIndex(value:Number):void{__mcBack.tabIndex = value}
		
		public function showError(msg:String):void {
			
			__msgErro = msg;
			text = __msgErro;
			
			setColor(COLOR_ERROR)
		}
		
		public function setColor($color:String, $tempo:Number = 0.3):void {
			var colorFront:Number
			var colorBack:Number
			
			switch ($color) {
				case COLOR_OUT:
					colorFront = 0x6b624a//Main.app.themeManager.getProp('FormCampo', 'colorFrontOut');
					colorBack = 0xecddb3//Main.app.themeManager.getProp('FormCampo', 'colorBackOut');
					mc.filters = [];
				break
				case COLOR_ACTIVE:
					colorFront = 0x342e1e//Main.app.themeManager.getProp('FormCampo', 'colorFrontActive');
					colorBack = 0xecddb3//Main.app.themeManager.getProp('FormCampo', 'colorBackActive');
					mc.filters = [new GlowFilter(0xffffff, 1, 29, 29, 0.4, 2)];
				break
				case COLOR_ERROR:
					colorFront = 0x000000//Main.app.themeManager.getProp('FormCampo', 'colorFrontError');
					colorBack = 0xff5400//Main.app.themeManager.getProp('FormCampo', 'colorBackError');
					mc.filters = [];
				break
			}
			
			__setColorFront(colorFront, $tempo);
			__setColorBack(colorBack, $tempo);
		}
		
		public function __setColorFront($color:Number, $tempo:Number = 0.3):void {
			TweenMax.to(__tfInput, $tempo, {tint:$color});
		}
		
		public function __setColorBack($color:Number, $tempo:Number = 0.3):void {
			TweenMax.to(__mcBack, $tempo, {tint:$color});
		}
	}
	
}