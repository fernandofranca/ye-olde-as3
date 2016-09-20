package com.withlasers.ui{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	/**
	 * impleentação do movieclip que representará o Tooltip
	 * @author Fernando de França
	 */
	public class TooltipMc extends MovieClip implements ITooltipMc {
		/**
		 * Textfield obrigatorio
		 */
		protected var __tf:TextField
		
		/**
		 * Background do Textfield
		 */
		protected var __mcBg:MovieClip
		
		/**
		 * Largura maxima
		 */
		public var maxWidth:int = 100;
		
		public function TooltipMc ():void {
			__tf = this.tf;
			
			__setupDetalhes();
		}
		
		protected function __setupDetalhes():void{
			__tf.background = true;
			__tf.backgroundColor = 0xffcc00
			
			__tf.width = 150
			__tf.autoSize = TextFieldAutoSize.LEFT;
			__tf.multiline = true;
			__tf.wordWrap = true;
			
			mouseEnabled = false;
			mouseChildren = false;
			__tf.mouseEnabled = false;
		}
		
		public function hide():void{
			visible = false;
		}
		
		public function show():void{
			visible = true;
			
			bringToFront();
		}
		
		/**
		 * Texto do Tooltip
		 */
		public function get text():String { 
			return __tf.text;
		}
		
		public function set text(value:String):void {
			
			__tf.text = value;
			
			posiciona();
			
			bringToFront()
		}
		
		public function posiciona():void {
			if (stage) {
				x = stage.mouseX + 10
				y = stage.mouseY + 20
				
				// checa se nao caiu fora do stage
				
				if (y+height>stage.stageHeight) {
					y = stage.stageHeight - height;
				}
				
				if (x+width>stage.stageWidth) {
					x = stage.stageWidth - width;
				}
			}
		}
		
		public function bringToFront():void {
			if (stage) {
				stage.setChildIndex(this, stage.numChildren - 1)
			}
		}
	}
	
}