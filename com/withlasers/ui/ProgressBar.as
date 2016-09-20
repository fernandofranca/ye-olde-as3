package com.withlasers.ui 
{
	import flash.display.Sprite;
	import flash.display.*
	import flash.events.*;
	import flash.geom.Rectangle;
	import gs.easing.Expo;
	import gs.TweenLite
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ProgressBar extends Sprite  {
		public static const CHANGE:String = 'ProgressBar_change' //evento disparado durante uma interação do usuario
		
		private var __mc:Sprite
		private var __mcFrente:Sprite // parte que move/escala conforme o progresso
		private var __mcBarra:Sprite // parte que move/escala conforme o limite
		private var __mcBg:Sprite // parte que não move (sensor)
		
		private var __lm:ListenersManager
		
		private var __percent:Number = 0
		
		public var isEnabled:Boolean = true
		
		private var __isDragging:Boolean = false;
		
		
		public function ProgressBar ($classeMc:Class, $valorInicial:Number = 0):void {
			__lm = new ListenersManager();
			
			__mc = Sprite(new $classeMc());
			addChild(__mc)
			
			__mcFrente = Sprite(__mc['mcFrente']);
			__mcBarra = Sprite(__mc['mcBarra']);
			__mcBg = Sprite(__mc['mcBg']);
			
			__mcFrente.mouseEnabled = false
			__mcBarra.mouseEnabled = false
			__mcBarra.buttonMode = true;
			
			percent = $valorInicial;
			
			__lm.add(this, Event.ADDED_TO_STAGE, __init);
		}
		
		private function __init():void{
			__lm.add(this, Event.REMOVED_FROM_STAGE, __onRemove); //remove todos listeners
			__lm.add(__mcBg, MouseEvent.MOUSE_DOWN, __arrasta); //muda percentual
			__lm.add(stage, MouseEvent.MOUSE_UP, __solta); //solta
			
			
		}
		
		private function __arrasta():void {
			__isDragging = true;
			__onClick();
			__lm.add(stage, MouseEvent.MOUSE_MOVE, __onMouseMoveThumb);
		}
		
		private function __onMouseMoveThumb():void{
			__onClick();
		}
		
		private function __solta():void {
			if (__isDragging) {
				__lm.remove(stage, MouseEvent.MOUSE_MOVE);
				
				__isDragging = false;
				
				__onClick();
			}
		}
		
		private function __onClick():void {
			var percClick:Number = (__mcBg.mouseX * 100) / __mcBg.width;
			
			if (isEnabled==true) {
				__setPercent(percClick);
				dispatchEvent(new Event(CHANGE)) ;// dispara evento
			}
		}
		
		private function __onRemove():void{
			__lm.removeAll();
		}
		
		/**
		 * muda internamente
		 */
		private function __setPercent(value:Number):void {
			
			if (value>100 || value>limite) return
			
			if (value>0) {
				if (value <= limite) {
					__percent = value;
				} else {
					
					__percent = limite;
				}
			} else {
				value = 0;
				__percent = value;
			}
			
			__mcFrente.scaleX = value / 100;
		}
		
		/**
		 * Percentual
		 * Não muda caso esteja arrastando manualmente
		 */
		public function get percent():Number {
			return __percent;
		}
		public function set percent(value:Number):void {
			
			if (__isDragging==false) {
				__setPercent(value);
			}
		}
		
		/**
		 * limita ate quanto o percent pode ser setado
		 * limita quanto o thumb pode ser arrastado
		 */
		public function get limite():Number { return __mcBarra.scaleX*100; }
		public function set limite(value:Number):void {
			__mcBarra.scaleX = value / 100;
		}
	}
}