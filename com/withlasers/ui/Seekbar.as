	// Esta é a versão nova da classe, que usa composição ao inves de herança para o movieclip
	
	/*
	 *

	var mcSeek:Seekbar = new Seekbar(0);
	addChild(mcSeek)

	mcSeek.x = 200
	mcSeek.y = 100

	mcSeek.addEventListener(Seekbar.CHANGE, onChange)

	function onChange (e) {
		trace(mcSeek.percent)
	}
	
	// removendo do stage, todos listeners sao removidos

	 * mcSeekbar
	 * 		mcThumb //parte que é arrastada
	 * 		mcBarra // parte que move/escala conforme o limite
	 * 		mcBg // parte que não move (sensor)
	 * */

package com.withlasers.ui{
	import flash.display.*
	import flash.events.*;
	import flash.geom.Rectangle;
	import gs.easing.Expo;
	import gs.TweenLite
	
	
	public class Seekbar extends MovieClip  {
		public static const CHANGE:String = 'Seekbar_change' //evento disparado durante uma interação do usuario
		
		private var __mc:Sprite
		private var __mcBarra:MovieClip // parte que move/escala conforme o limite
		private var __mcBg:MovieClip // parte que não move (sensor)
		private var __mcThumb:MovieClip //parte que é arrastada
		
		private var __lm:ListenersManager
		
		private var __percent:Number = 0
		
		public var isEnabled:Boolean = true
		
		private var __isDragging:Boolean = false;
		
		
		public function Seekbar ($classeMc:Class, $valorInicial:Number = 0):void {
			__lm = new ListenersManager();
			
			__mc = Sprite(new $classeMc());
			addChild(__mc)
			
			__mcBarra = MovieClip(__mc['mcBarra']);
			__mcBg = MovieClip(__mc['mcBg']);
			__mcThumb = MovieClip(__mc['mcThumb']);
			
			__mcBarra.mouseEnabled = false
			__mcBg.buttonMode = true;
			
			
			percent = $valorInicial;
			
			__lm.add(this, Event.ADDED_TO_STAGE, __init);
		}
		
		private function __init():void{
			__lm.add(this, Event.REMOVED_FROM_STAGE, __onRemove); //remove todos listeners
			__lm.add(__mcBg, MouseEvent.MOUSE_DOWN, __arrasta); //muda percentual
			__lm.add(stage, MouseEvent.MOUSE_UP, __solta); //solta
			
			if (__mcThumb) {
				__lm.add(__mcThumb, MouseEvent.MOUSE_DOWN, __arrasta); //arrasta
				__mcThumb.buttonMode = true;
			}
			
		}
		
		private function __arrasta():void {
			__isDragging = true;
			__mcThumb.startDrag(false, new Rectangle(0, 0, __mcBarra.width, 0));
			//__onClick(); // desliguei porque em um click simples disparava 2x, no click e no release
			__lm.add(stage, MouseEvent.MOUSE_MOVE, __onMouseMoveThumb);
		}
		
		private function __onMouseMoveThumb():void{
			__onClick();
		}
		
		private function __solta():void {
			if (__isDragging) {
				__mcThumb.stopDrag();
				
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
			
			if (__mcThumb) {
				var nx:Number = (__percent*__mcBg.width)/100
				nx = nx - __mcThumb.width / 2
				
				//limita
				nx = nx < 0?0:nx;
				if (nx+__mcThumb.width>__mcBg.width) {
					nx = __mcBg.width - __mcThumb.width
				}
				
				__mcThumb.x = nx
			}
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