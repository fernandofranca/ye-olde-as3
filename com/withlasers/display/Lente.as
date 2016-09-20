package com.withlasers.display {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Efeito de Zoom
	 * Nota: a eliminacao dos bitmaps é feita automaticamente quando esta instancia é removida do stage
	 */
	public class Lente extends MovieClip {
		private var __mcOrigem:MovieClip;
		private var __width:int;
		private var __height:int;
		private var __ox:int = 0; // ponto de origem para copia do bitmap
		private var __oy:int = 0;
		
		private var __bmpFinal:BitmapData // crop
		private var __bmpDisplay:Bitmap // aquilo que é mostrado
		private var __zoom:Number = 1; // 1 = 100%, 2 = 200%
		private var __matrix:Matrix = new Matrix();
		
		/**
		 * Cria um mc com uma copia da imagem com o tamanho informado e zoom
		 * @param	$mcOrigem	Mc de origem a ser copiado
		 * @param	$width		Largura
		 * @param	$height		Altura
		 * @param	$zoom		1=100%, 2=200%...
		 */
		public function Lente($mcOrigem:MovieClip, $width:int=1, $height:int=1, $zoom:Number=1) {
			
			mouseEnabled = false;
			
			__mcOrigem = $mcOrigem;
			__width = $width;
			__height = $height;
			__zoom = $zoom;
			
			
			__bmpDisplay = new Bitmap(null, PixelSnapping.ALWAYS, true);
			addChild(__bmpDisplay);
			
			
			__atribuiBmps();
			
			__observeOnRemove();
		}
		
		/**
		 * Atualiza o visual com referencia no ponto determinado pelos parametros
		 * @param	$x
		 * @param	$y
		 */
		public function draw($x:int, $y:int):void {
			__ox = $x;
			__oy = $y;
			
			__update();
		}
		
		/**
		 * Apenas atualiza sem alterar o ponto de origem
		 */
		public function update():void {
			__update();
		}
		
		/**
		 * Para poder atualizar largura ou altura é preciso instanciar outro bitmapdata e atribuir ao bitmap
		 */
		private function __atribuiBmps():void{
			__bmpFinal = new BitmapData(__width, __height, false);
			__bmpDisplay.bitmapData = __bmpFinal;
		}
		
		/**
		 * Checa se esta instancia foi removida do stage para poder eliminar itens que devem ser coletados pelo GC
		 */
		private function __observeOnRemove():void{
			addEventListener(Event.REMOVED_FROM_STAGE, __handleOnRemove);
		}
		
		private function __handleOnRemove(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleOnRemove);
			__destroy();
		}
		
		/**
		 * Elimina os bitmaps e outros itens a serem coletados pelo GC
		 */
		private function __destroy():void {
			__bmpDisplay = null;
			__bmpFinal.dispose();
			
			__bmpDisplay = null;
			__bmpFinal = null;
			
			__mcOrigem = null;
			__matrix = null;
		}
		
		private function __update():void {
			var $x:int
			var $y:int
			
			
			// limita valores
			var widthReal:Number = __mcOrigem.width / __mcOrigem.scaleX
			var xMargem:Number = ((__width / 2) / zoom) + 1 //somei + 1 para nao ter borda e nao usar math.ceil
			var xMin:Number = xMargem
			var xMax:Number = widthReal  - xMargem;
			
			var heightReal:Number = __mcOrigem.height / __mcOrigem.scaleY
			var yMargem:Number = ((__height / 2) / zoom) + 1 //somei + 1 para nao ter borda e nao usar math.ceil
			var yMin:Number = yMargem
			var yMax:Number = heightReal  - yMargem;
			
			__ox = __ox > xMax?xMax:__ox
			__ox = __ox < xMin?xMin:__ox
			
			__oy = __oy > yMax?yMax:__oy
			__oy = __oy < yMin?yMin:__oy
			
			
			
			// transforma com matrix
			$x = (__ox * zoom - __width / 2) * -1; //subtrai a largura/2 para centralizar
			$y = (__oy * zoom - __height / 2) * -1;
			
			__matrix.a = zoom;
			__matrix.d = zoom;
			__matrix.tx = $x;
			__matrix.ty = $y;
			
			__bmpFinal.draw(__mcOrigem, __matrix, null, null, null, true);
		}
		
	// getters e setters
	
		/**
		 * 1 = 100%, 2 = 200%
		 */
		public function get zoom():Number { return __zoom; }
		public function set zoom(value:Number):void {
			__zoom = value > 0?value:0;
			
			__update();
		}
		
		
		override public function get width():Number { return __width; }
		override public function set width(value:Number):void {
			__width = value;
			__atribuiBmps();
			__update();
		}
		
		override public function get height():Number { return __height; }
		override public function set height(value:Number):void {
			__height = value;
			__atribuiBmps();
			__update();
		}
		
		/**
		 * MovieClip de referencia para cópia dos pixels
		 */
		public function get mcOrigem():MovieClip { return __mcOrigem; }
		public function set mcOrigem(value:MovieClip):void {
			__mcOrigem = value;
		}
	}
	
}