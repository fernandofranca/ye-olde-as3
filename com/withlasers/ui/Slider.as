/*
* Ex:

var mcs = {}
mcs.slider = mcSlider
mcs.botao = mcSlider.mcFrente
mcs.range = mcSlider.mcFundo

// o botao deve ter o mesmo tamanho do range

slider1 = new Slider(Slider.ORIENTACAO_HORIZONTAL, mcs, 10)

slider1.onChange = function  () {
	TF1.text = slider1.value
}

slider1.setTamanhoBotao(10) //opcional

slider.value = 0;

*/

package com.withlasers.ui {
	import flash.display.*
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.events.*;
	
	
	public class Slider extends EventDispatcher {
		private var multiplicador:Number
		private var mcs:Object
		private var orientacao:String
		
		public var incMouseWheel:Number
		
		private var mcSlider:Sprite
		private var mcBotao:Sprite
		private var mcRange:Sprite
		
		private var xMin:Number
		private var xMax:Number
		private var yMin:Number
		private var yMax:Number
		private var _value:Number
		
		public var onChange:Function;
		
		public static const ORIENTACAO_HORIZONTAL:String = 'H'
		public static const ORIENTACAO_VERTICAL:String = 'v'
		
		public static const ON_CHANGE:String = 'onChange';
		
		/**
		 *
		 * @param	$orientacao				ORIENTACAO_HORIZONTAL|ORIENTACAO_VERTICAL
		 * @param	$mcs					Movieclip contendo mcFrente e mcFundo
		 * @param	$incrementoMouseWheel	Incremento percentual usado para MouseWheel
		 */
		public function Slider ($orientacao:String, $mcs:Object, $incrementoMouseWheel:Number=1):void{
			
			orientacao = $orientacao;
			
			mcSlider = Sprite($mcs.slider)
			mcBotao = Sprite($mcs.botao)
			mcRange = Sprite($mcs.range)
			
			incMouseWheel = $incrementoMouseWheel
			
			init();
		}
		
		private function init():void {
			_value = 0;
			
			//mcBotao.height = 40; //????
			mcBotao.buttonMode = true;
			
			//arredonda posicao
			mcSlider.x = Math.floor(mcSlider.x)
			mcSlider.y = Math.floor(mcSlider.y)
			
			mcBotao.addEventListener(MouseEvent.MOUSE_DOWN, __onClickBotao, false, 0, true);
			
			mcBotao.addEventListener(MouseEvent.MOUSE_UP, __solta, false, 0, true);
			mcBotao.stage.addEventListener(MouseEvent.MOUSE_UP, __solta, false, 0, true);
			
			if (incMouseWheel > 0) {
				mcSlider.addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel, false, 0, true);
				mcSlider.addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel, false, 0, true);
			}
			
			mcRange.addEventListener(MouseEvent.CLICK, __onClickRange, false, 0, true);
		}
		
		private function __onClickBotao(e:MouseEvent):void {
			__getLimits ()
			__arrasta();
		}
		
		private function __onClickRange(e:MouseEvent):void { //quando o usuario clicar no range, desloca o slider até aquele ponto
			
			var posClick:Number = mcRange.mouseY;
			var h:Number = mcRange.height;
			var perc:Number = Math.round((posClick * 100) / h);
			
			// arrendonda para 100 ou 0
			if (perc >= 97) perc = 100;
			if (perc <= 3 ) perc = 0;
			
			__setPercSlide(perc);
		}
		
		private function __solta (e:MouseEvent):void { //"onRelease"
			mcBotao.stopDrag();
			
			mcBotao.removeEventListener(MouseEvent.MOUSE_MOVE, _onChange);
			
			mcBotao.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onChange);
		}
		
		private function __onMouseWheel(e:MouseEvent):void {
			if (e.delta>0) {
				value = value - incMouseWheel;
			} else {
				value = value + incMouseWheel;
			}
		}
		
		private function _onChange(e:*= null):void {
			try {
				dispatchEvent(new Event(ON_CHANGE));
				onChange();
			} catch (e:Error){
			}
		}
		
		private function __arrasta ():void {
			var rect:Rectangle = new Rectangle(xMin, yMin, xMax, yMax)
			
			mcBotao.startDrag(false, rect);
			
			mcBotao.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onChange, false, 0, true);
		}
		
		private function __getLimits ():void{
			
			if (orientacao==ORIENTACAO_VERTICAL) {//vertical
				xMin = xMax = mcBotao.x
				yMin = mcRange.y
				yMax = (mcRange.y + mcRange.height) - mcBotao.height; // rever: precisa arredondar o height???
			} else if (orientacao==ORIENTACAO_HORIZONTAL) {//horizontal
				yMin = yMax = mcRange.y
				xMin = mcRange.x
				xMax = (mcRange.x + mcRange.width) //- mcBotao.width; // rever: precisa arredondar o height???
			}
		}
		
		private function __getPercSlide ():Number{
			var perc:Number = 0
			var max:Number
			var atual:Number
			
			__getLimits();
			
			if (orientacao==ORIENTACAO_VERTICAL) {//vertical
				max = yMax;
				atual = mcBotao.y;
				
				perc = (atual * 100)/max
			} else if (orientacao==ORIENTACAO_HORIZONTAL) {
				max = xMax;
				atual = mcBotao.x;
				
				perc = (atual * 100)/max
			}
			
			_value = perc
			return(perc);
		}
		
		private function __setPercSlide (perc:Number):void{
			var max:Number
			var atual:Number
			var novo:Number
			
			__getLimits();
			
			if (orientacao==ORIENTACAO_VERTICAL) {//vertical
				max = yMax;
				novo = yMax*(perc/100);
				
				mcBotao.y = novo;
			} else if (orientacao==ORIENTACAO_HORIZONTAL) {
				max = xMax;
				novo = xMax*(perc/100);
				
				mcBotao.x = novo;
			}
			_value = perc
			_onChange();
		}
		
		/**
		 * Muda o tamanho do botao, em % relativo ao tamanho da track e ao sentido
		 * @param	perc	% relativo ao tamanho da track
		 */
		public function setTamanhoBotao(perc:Number):void {
			
			perc>100?perc=100:perc=perc
			perc<1?perc=1:perc=perc
			
			if (orientacao==ORIENTACAO_VERTICAL) {//vertical
				mcBotao.height = mcRange.height*(perc/100)
				
				//limita a no minimo 20px
				mcBotao.height<20?mcBotao.height=20:mcBotao.height=mcBotao.height
			} else if (orientacao==ORIENTACAO_HORIZONTAL) {
				mcBotao.width = mcRange.width*(perc/100)
				
				//limita a no minimo 20px
				mcBotao.width<20?mcBotao.width=20:mcBotao.width=mcBotao.width
				
			}
			
			value = _value; // evita que o botao seja posicionado de maneira errada apos ser redimensionado
		}
		
		/**
		 * Percentual atual do scroll
		 */
		public function get value():Number {
			return __getPercSlide();
		}
		public function set value(v:Number):void {
			
			v>100?v=100:v=v
			v<0?v=0:v=v
			
			__setPercSlide(v);
		}
		
		/**
		 * Reseta a posicao do slider para 0
		 */
		public function reset ():void {
			value = 0;
		}
		
		/**
		 * Remove todos os listeners
		 */
		public function remove():void {
			onChange = null;
			
			mcBotao.removeEventListener(MouseEvent.MOUSE_DOWN, __onClickBotao);
			mcBotao.removeEventListener(MouseEvent.MOUSE_UP, __solta);
			mcBotao.stage.removeEventListener(MouseEvent.MOUSE_UP, __solta);
			mcBotao.removeEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
			mcRange.removeEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
			mcRange.removeEventListener(MouseEvent.CLICK, __onClickRange);
			mcBotao.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onChange);
		}
		
		/*
		public function get height():Number { return mcBotao.height; }
		
		public function set height(value:Number):void {
			mcBotao.height = value;
		}
		*/
	}
}