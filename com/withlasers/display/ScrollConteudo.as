
/*
scr1 = new ScrollConteudo(mc1, mc1.mcConteudo, 120, 120)
scr1.scrollYPerc = 50
scr1.scrollXPerc = 50
*/

/**
 * Adicionei o evento UPDATE
 * mudei o container e content de MovieClip para DisplayObjectContainer
 * fiz algumas mudancas radicais adicionais getters/setters para algumas propriedades mas deixei comentado
 */
package com.withlasers.display {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class ScrollConteudo extends EventDispatcher{
		public var mc:DisplayObjectContainer // o scrolRect é aplicado aqui
		public var mcContent:DisplayObjectContainer // o tamanho do conteudo é pego por aqui
		private var window:Rectangle
		
		private var _scrollXPerc:Number
		private var _scrollYPerc:Number
		
		private var _width:Number
		private var _height:Number
		private var _x:Number
		private var _y:Number
		
		//private var _xMax:Number
		//private var _yMax:Number
		
		//public var _conteudoWidth:Number
		//public var _conteudoHeight:Number
		
		public static const UPDATE:String = 'SCROLL_UPDATE';
		
		
		public function ScrollConteudo ($mcContainer:DisplayObjectContainer, $mcContent:DisplayObjectContainer, $width:Number, $height:Number) {
			
			
			mc = $mcContainer;
			mcContent = $mcContent;
			
			_width = $width
			_height = $height
			_x = 0
			_y = 0
			
			//_conteudoWidth = mcContent.width
			//_conteudoHeight = mcContent.height
			//
			//_xMax = _conteudoWidth - _width;
			//_yMax = _conteudoHeight - _height;
			
			window = new Rectangle(0, 0, 0, 0);
			
			updateScrollRect();
		}
		
		private function updateScrollRect():void{ //recalcula e redesenha
			
			//_conteudoWidth = mcContent.width
			//_conteudoHeight = mcContent.height
			
			//_xMax = _conteudoWidth - width;
			//_yMax = _conteudoHeight - height;
			
			
			
			window.x = _x
			window.y = _y
			window.height = _height
			window.width = _width
			
			mc.scrollRect = window
		}
		
		public function reset():void { //move para o topo e checa o tamanho
			updateScrollRect();
			scrollYPerc = 0;
			scrollXPerc = 0;
		}
		
		public function get scrollXPerc():Number {
			_scrollXPerc = (_x*100)/_xMax
			return _scrollXPerc;
		}
		
		public function set scrollXPerc( val:Number ):void {
			_scrollYPerc = val
			_x = (val*_xMax)/100
			updateScrollRect();
			
			__disparaEvento();
		}
		
		public function get scrollYPerc():Number {
			_scrollYPerc = (_y*100)/_yMax
			return _scrollYPerc;
		}
		
		public function set scrollYPerc( val:Number ):void {
			_scrollYPerc = val
			_y = (val*_yMax)/100
			updateScrollRect();
			
			__disparaEvento();
		}
		
		public function get width():Number {
			return _width;
		}
		
		public function set width( val:Number ):void {
			_width = val;
			//_xMax = _conteudoWidth - _width;
			updateScrollRect();
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height( val:Number ):void {
			_height = val;
			//_yMax = _conteudoHeight - _height;
			
			updateScrollRect();
		}
		
		public function get scrollYPx():Number {
			return _y;
		}
		
		public function set scrollYPx( val:Number ):void {
			//adicionei para possibilitar o page up/down sem estourar
			if (val>_yMax) {
				_y = _yMax
			} else if (val < 0) {
				_y = 0;
			} else {
				_y = val;
			}
			
			updateScrollRect();
			
			__disparaEvento();
		}
		
		public function get scrollXPx():Number {
			return _x;
		}
		
		public function set scrollXPx( val:Number ):void {
			_x = val;
			updateScrollRect();
			
			__disparaEvento();
		}
		
		public function get _conteudoWidth ():Number {
			return mcContent.width;
		}
		
		public function get _conteudoHeight ():Number {
			return mcContent.height;
		}
		
		private function get _xMax ():Number {
			return _conteudoWidth - width;
		}
		
		private function get _yMax ():Number {
			return _conteudoHeight - height;
		}
		
		private function __disparaEvento():void{
			dispatchEvent(new Event(UPDATE, false, false));
		}
	}
}