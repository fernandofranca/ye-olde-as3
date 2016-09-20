package com.withlasers.debug{
	import flash.display.*
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ConsoleInspector {
		private static var __isInited:Boolean;
		private static var __stageRef:Stage
		private static var __root:MovieClip
		private static var mcHighlight:MovieClip;
		
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
			__stopInspect();
			
			isInspecting = true;
			__stageRef.addEventListener(MouseEvent.MOUSE_UP, __handleClick);
			__stageRef.addEventListener(MouseEvent.MOUSE_MOVE, __handleMove);
		}
		
		private static function __stopInspect():void{
			
			__stageRef.removeEventListener(MouseEvent.MOUSE_UP, __handleClick);
			__stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, __handleMove);
			
			if (isInspecting==true) {
				// remove highlight
				mcHighlight.graphics.clear();
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
			
			// isto devia ficar no Console, mas eu teria que criar um evento...
			try {
				Console.instance.visible = true;
			} catch (e:Error){}
			
			
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
			
			
			Console.instance.msg(mc);
			
			// caminho do mc
			//trace(caminhoSimples.reverse().join('.'));
			var arrMsgs:Array = [];
			arrMsgs.push('  <b>' + caminhoSimples.reverse().join('.') + '</b>');
			
			// caminho com tipos
			//trace(caminhoTipo.split('object ').join(''));
			
			
			// lista os filhos do mc
				
				var arrFilhos:Array = McUtils.getChilds(mc)
				
				for (var j:int = 0; j < arrFilhos.length; j++) {
					arrMsgs.push('\t+   <b>' + arrFilhos[j].name+'</b> ' + arrFilhos[j]);
				}
				
			Console.instance.msgInfo(arrMsgs.join('\n'))
			
		}
		
		/**
		 * Desenha o hilight e Retorna o alvo do Click
		 * @return	Retorna o alvo do Click
		 */
		private static function __inspectPoint(evt:MouseEvent):DisplayObjectContainer{
			
			// TODO isto repete o codigo do __handleMove
			
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
		
	}
	
}