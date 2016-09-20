/*

import com.withlasers.debug.Modify

Modify.init(stage);

stage.addEventListener(KeyboardEvent.KEY_UP, __handleKeyboard)

function __handleKeyboard (evt:KeyboardEvent) {
	if (evt.keyCode==81) { // tecla q
		if (Modify.isInspecting==false) {
			Modify.inspect();
		} else {
			Modify.stopInspect();
		} 
	}
}

*/

package com.withlasers.debug {
	import flash.display.*
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Modify {
		private static var __isInited:Boolean;
		private static var __stageRef:Stage
		private static var __root:MovieClip
		private static var mcHighlight:MovieClip;
		private static var tfDetalhes:TextField
		private static var __objInspected:DisplayObjectContainer = null
		
		
		public static var isInspecting:Boolean
		
		public static function init($stageRef:Stage):void {
			
			// só pode inicializar uma vez
			if (__isInited != true) {
				
				__isInited = true;
				__stageRef = $stageRef;
				__root = MovieClip(DisplayObjectContainer(__stageRef.root).getChildAt(0));
				
				isInspecting = false;
				
				
				mcHighlight = __root.getChildByName('mcHighlight') as MovieClip
				
				if (mcHighlight==null) {
					mcHighlight = new MovieClip();
					__root.addChild(mcHighlight);
					mcHighlight.name = 'mcHighlight';
					mcHighlight.mouseEnabled = false
				}
				
				tfDetalhes = __root.getChildByName('tfDetalhes') as TextField
				
				if (tfDetalhes==null) {
					tfDetalhes = new TextField();
					tfDetalhes.name = 'tfDetalhes';
					__root.addChild(tfDetalhes);
				}
				
				tfDetalhes.defaultTextFormat = new TextFormat('Arial', 11, 0x000000);
				tfDetalhes.backgroundColor = 0xEFDBAB;
				tfDetalhes.background = true;
				tfDetalhes.autoSize = TextFieldAutoSize.LEFT;
				tfDetalhes.wordWrap = false;
				tfDetalhes.multiline = false;
				tfDetalhes.mouseEnabled = false;
				tfDetalhes.visible = false;
				
			}
		}
		
		public static function inspect():void {
			if (__isInited!=true) {
				throw(new Error('Inicialize esta classe antes de usar este método!'))
			}
			__startInspect();
		}
		
		public static function stopInspect():void {
			if (__isInited == true) {
				isInspecting = false;
				__stopInspect();
			}
		}
		
		/**
		 * Destaca um MovieClip
		 */
		public static function hilight(mc:DisplayObject):void {
			var rect:Rectangle = mc.getBounds(__root); //limites do retangulo
			var gfx:Graphics = mcHighlight.graphics;
			
			gfx.clear();
			gfx.lineStyle(1, 0xff0000, 1, true);
			gfx.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			if (mc==__root) gfx.clear()
			if (mc==mcHighlight) gfx.clear()
		}
		
		private static function __startInspect():void{
			if (isInspecting) __stopInspect();
			
			isInspecting = true;
			tfDetalhes.visible = true;
			mcHighlight.visible = true;
			
			__stageRef.addEventListener(MouseEvent.MOUSE_UP, __handleClick);
			__stageRef.addEventListener(MouseEvent.MOUSE_MOVE, __handleMove);
		}
		
		private static function __stopInspect():void{
			
			__stageRef.removeEventListener(MouseEvent.MOUSE_UP, __handleClick);
			__stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, __handleMove);
			
			
			if (isInspecting==false) {
				mcHighlight.visible = false;
				tfDetalhes.visible = false;
				tfDetalhes.text = '';
				
				__stageRef.removeEventListener(KeyboardEvent.KEY_UP, __handleKeyboard);
			}
			
			isInspecting = false;
		}
		
		private static function __handleMove(evt:MouseEvent):* {
			__inspectPoint(evt);
		}
		
		
		private static function __handleClick(e:MouseEvent):* {
			var mc:DisplayObjectContainer
			var _parent:*
			var caminhoSimples:Array = []
			var caminhoTipo:String = ''
			
			
			__stopInspect();
			
			
			mc = __inspectPoint(e);
			
			// volta para o root se for nulo, acontece apontando pro stage
			if (mc == null) mc = __root
			
			_parent = mc;
			
			
			
			// determina o caminho
			while (_parent!=__stageRef) {
				caminhoTipo = _parent.name  + _parent + caminhoTipo;
				caminhoSimples.push(_parent.name);
				_parent = _parent.parent
			}
			
			__objInspected = mc;
			__updateInfo(mc);
			__observeKeyboard(e.currentTarget as DisplayObject);
		}
		
		/**
		 * Desenha o hilight e Retorna o alvo do Click
		 * @return	Retorna o alvo do Click
		 */
		private static function __inspectPoint(evt:MouseEvent):DisplayObjectContainer{
			
			var pt:Point = new Point(evt.stageX, evt.stageY);
			var a:Array = __root.getObjectsUnderPoint(pt)
			var mc:DisplayObjectContainer; // alvo do click
			
			
			if (evt.target is Stage) return undefined
			
			mc = a[a.length - 1].parent;
			
			// desenha o destaque para o mc clicado
			hilight(mc);
			
			
			// retorna
			return mc;
		}
		
		private static function __updateInfo(mc:DisplayObjectContainer):void {
			tfDetalhes.text = mc.name + '\nx : ' + mc.x + ',  y : ' + mc.y + ',  width : ' + mc.width + ',  height : ' + mc.height;
			
			tfDetalhes.x = McUtils.getGlobalX(mc)
			tfDetalhes.y = McUtils.getGlobalY(mc) - tfDetalhes.height - 5;
		}
		
		private static function __observeKeyboard($tgt:DisplayObject):void{
			$tgt.addEventListener(KeyboardEvent.KEY_UP, __handleKeyboard);
		}
		
		private static function __handleKeyboard(evt:KeyboardEvent):void {
			
			var kcode:int = evt.keyCode;
			var shift:Boolean = evt.shiftKey;
			var control:Boolean = evt.ctrlKey;
			
			var inc:int = shift == false?1:10;
			
			if (control) {
				switch (kcode) {
					case 38:
						setProp('height', inc * -1);
					break
					
					case 40:
						setProp('height', inc);
					break
					
					case 37:
						setProp('width', inc * -1);
					break
					
					case 39:
						setProp('width', inc);
					break
				}
				
			} else {
				switch (kcode) {
					case 38:
						setProp('y', inc * -1);
					break
					
					case 40:
						setProp('y', inc);
					break
					
					case 37:
						setProp('x', inc * -1);
					break
					
					case 39:
						setProp('x', inc);
					break
				}
			}
		}
		
		private static function setProp(prop:String, inc:int):void {
			__objInspected[prop] += inc;
			
			hilight(__objInspected);
			__updateInfo(__objInspected);
		}
		
	}
	
}