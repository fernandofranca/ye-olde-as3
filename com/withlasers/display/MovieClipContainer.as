package com.withlasers.display {
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.*
	
	/**
	 * @author Fernando de França
	 */
	public class MovieClipContainer extends MovieClip {
		private var __width:Number = 100
		private var __height:Number = 100
		private var __shapeBg:Shape;
		private var __rect:Rectangle;
		
		public var backgroundColor:Number;
		public var backgroundAlpha:Number = 1;
		
		
		public function MovieClipContainer($width:Number, $height:Number, $bgColor:Number=0xff0000) {
			backgroundColor = $bgColor;
			
			__criaBg();
			__criaMascara();
			
			width = $width;
			height = $height;
			
		}
		
		public function redraw():void {
			__posicionaFilhos();
		}
		
		override public function addChild($child:DisplayObject):DisplayObject {
			var obj:DisplayObject = super.addChild($child);
			__posicionaFilhos();
			return obj;
		}
		
		private function __posicionaFilhos():void {
			//var arrChilds:Array = this.child
			
			var maxLine:Number = 0; //altura maxima da linha atual
			var lastX:Number = 0;
			var lastY:Number = 0;
			var lastDo:DisplayObject = null;
			var elemento:DisplayObject
			
			// começa do 1 porque o bg é 0
			
			for (var i:int = 1; i < numChildren; i++) {
				// faltam os paddings
				elemento = getChildAt(i);
				
				
				if (lastDo==null) { //primeiro da lista
					elemento.x = 0
					elemento.y = 0
					
					lastDo = elemento;
					lastX = lastDo.x + lastDo.width
					lastY = 0;
					maxLine = lastY + elemento.height;
				} else {
					if (lastX+elemento.width<this.width) { //aqui nao tem quebra
						elemento.x = lastX;
						elemento.y = lastY;
						
						lastDo = elemento;
						lastX = lastDo.x + lastDo.width;
						
						// checa e atribui maior altura
						if (maxLine < lastDo.y + lastDo.height) {
							maxLine = lastDo.y + lastDo.height
						}
					} else { // quebra
						elemento.x = 0;
						elemento.y = maxLine;
						
						lastDo = elemento;
						lastX = lastDo.x + lastDo.width;
						lastY = maxLine;
						maxLine = lastDo.y + lastDo.height;
					}
				}
			}
			
		}
		
		private function __criaBg():void{
			__shapeBg = new Shape();
			addChild(__shapeBg);
			
			var cg:Graphics = __shapeBg.graphics;
			
			cg.beginFill(backgroundColor, backgroundAlpha)
			cg.drawRect(0, 0, __width, __width);
			cg.endFill();
		}
		
		private function __atualizaBg():void {
			__shapeBg.width = __width
			__shapeBg.height = __height
		}
		
		private function __criaMascara():void{
			__rect = new Rectangle(0, 0, width, height);
			this.scrollRect = __rect;
		}
		
		private function __atualizaMascara():void{
			__rect.width = width
			__rect.height = height
			this.scrollRect = __rect;
		}
		
		override public function get width():Number { return __width; }
		override public function set width(value:Number):void {
			__width = value;
			
			__atualizaBg();
			__atualizaMascara();
			
			__posicionaFilhos();
			__redrawParentContainer();
		}
		
		override public function get height():Number { return __height; }
		override public function set height(value:Number):void {
			__height = value;
			
			__atualizaBg();
			__atualizaMascara();
			
			__posicionaFilhos();
			__redrawParentContainer();
		}
		
		
		private function __redrawParentContainer():void{
			if (isContainerChild) {
				MovieClipContainer(parent).redraw();
			}
		}
		
		/**
		 * Checa se esta dentro de um MovieClipContainer
		 */
		public function get isContainerChild():Boolean {
			return parent is MovieClipContainer;
		}
	}
	
}