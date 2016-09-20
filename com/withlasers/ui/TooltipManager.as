/*
	import com.withlasers.ui.*;
	
	TooltipManager.init(MyToolTip, this.stage)
	TooltipManager.add(mc0, 'texto 1')
	TooltipManager.add(mc1, 'texto 2')
	
	// nota:
	// o tooltip é removido automaticamente quando o alvo é removido
*/

package com.withlasers.ui{
	import flash.display.*
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	
	public class TooltipManager {
		private static var __isInited:Boolean
		private static var mcTooltip:ITooltipMc
		private static var __stageRef:Stage
		
		private static var __targetArray:Array
		private static var __dicTargets:Dictionary // referencias dos textos a partir dos mcs
		
		private static var __delayTimeout:Number
		
		public static var delay:Number = 400
		public static var followMouse:Boolean = true
		
		/**
		 * Inicializadora da classe estática
		 * @param	$classTooltip	Deve implementar a interface ITooltipMc
		 * @param	$stageRef		Referencia do Stafe
		 */
		public static function init($classTooltip:Class, $stageRef:Stage):void {
			
			// só pode inicializar uma vez
			if (__isInited != true) {
				
				__isInited = true;
				__stageRef = $stageRef;
				__targetArray = []
				__dicTargets = new Dictionary(true);
				
				mcTooltip = new $classTooltip();
				mcTooltip.hide();
				mcTooltip.text = 'hello'
				__stageRef.addChild(mcTooltip as DisplayObjectContainer);
			}
		}
		
		/**
		 * Adiciona um Tooltip para um elemento e determina o texto
		 * @param	$target	Elemento que dispara o Tooltip
		 * @param	$texto	Texto do Tooltip
		 */
		public static function add($target:DisplayObject, $texto:String):void {
			
			if (__isInited == true) {
				__dicTargets[$target] = $texto
				__addListeners($target);
			} else {
				throw(new Error('Antes de adicionar elementos, inicialize a classe com TooltipManager.init', 666));
			}
		}
		
		/**
		 * Remove o Tooltip do elemento
		 * @param	$target	Elemento que perderá o Tooltip
		 */
		public static function remove($target:DisplayObject):void {
			__removeListeners($target);
			delete __dicTargets[$target]; // remove referencia do dictionary
		}
		
		static private function __addListeners($target:DisplayObject):void{
			$target.addEventListener(MouseEvent.ROLL_OVER, __onRollOver)
			$target.addEventListener(MouseEvent.ROLL_OUT, __onRollOut)
			$target.addEventListener(MouseEvent.CLICK, __onRollOut)
			$target.addEventListener(Event.REMOVED_FROM_STAGE, __onRemove)
			
			if (followMouse==true) {
				$target.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove)
			}
			
		}
		
		static private function __removeListeners($target:DisplayObject):void{
			$target.removeEventListener(MouseEvent.ROLL_OVER, __onRollOver)
			$target.removeEventListener(MouseEvent.ROLL_OUT, __onRollOut)
			$target.removeEventListener(MouseEvent.CLICK, __onRollOut)
			$target.removeEventListener(Event.REMOVED_FROM_STAGE, __onRemove)
			$target.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove)
		}
		
		static private function __onRollOver(e:MouseEvent):void {
			
			var mc:DisplayObjectContainer = DisplayObjectContainer(e.target);
			
			var text:String = __dicTargets[mc]
			
			mcTooltip.text = text;
			
			if (__delayTimeout) {
				clearTimeout(__delayTimeout);
			}
			
			__delayTimeout = setTimeout(__checaOverDelay, delay)
		}
		
		static private function __checaOverDelay():void{
			mcTooltip.show();
		}
		
		static private function __onMouseMove(e:MouseEvent):void {
			mcTooltip.posiciona();
		}
		
		static private function __onRollOut(e:MouseEvent):void {
			mcTooltip.hide();
			
			// remove intervalo
			clearTimeout(__delayTimeout);
		}
		
		static private function __onRemove(e:Event):void {
			var mc:DisplayObjectContainer = DisplayObjectContainer(e.target)
			
			delete __dicTargets[mc]; // remove referencia do dictionary
			
			__removeListeners(mc); //remove todos listeners
			
			mcTooltip.hide();
		}
		
		/*
		static public function conta():void{
			var c=0
			for (var name:String in __dicTargets) {
				c++
			}
			trace(c);
		}
		*/
		
	}
}