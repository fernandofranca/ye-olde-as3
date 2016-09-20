/**
 * Classe derivada do Menufader
 * 
 * NOVO: disparo de evento implementado
 * NOVO: numero do item atual
 */

package com.withlasers.ui {
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class ButtonGroup extends EventDispatcher {
		private var __mcsArray:Array;
		private var __framesArray:Array;
		public var itemAtivo:MovieClip;
		public var numItemAtivo:int
		
		public static var EVENT_CHANGE:String = 'event change';
		
		
		public function ButtonGroup ($mcsArray:Array, $framesArray:Array) {
			itemAtivo = null;
			__mcsArray = $mcsArray;
			__framesArray = $framesArray;
			
			__atribuiAcoes();
		}
		
		private function __atribuiAcoes():void {
			for (var i:int = 0; i < __mcsArray.length; i++) {
				
				var mc:MovieClip = MovieClip(__mcsArray[i]);
				
				mc.buttonMode = true;
				mc.addEventListener(MouseEvent.ROLL_OVER, __mouseOver)
				mc.addEventListener(MouseEvent.ROLL_OUT, __mouseOut)
				mc.addEventListener(MouseEvent.CLICK, __click)
			}
		}
		
		public function remove ():void {
			for (var i:int = 0; i < __mcsArray.length; i++) {
				
				var mc:MovieClip = MovieClip(__mcsArray[i]);
				
				mc.removeEventListener(MouseEvent.ROLL_OVER, __mouseOver)
				mc.removeEventListener(MouseEvent.ROLL_OUT, __mouseOut)
				mc.removeEventListener(MouseEvent.CLICK, __click)
			}
		}
		
		private function __mouseOver(e:MouseEvent):void {
			var mc:MovieClip = MovieClip(e.currentTarget);
			if (mc!=itemAtivo) {
				mudaEstadoVisual(mc, 'over');
			}
		}
		
		private function __mouseOut(e:MouseEvent):void {
			var mc:MovieClip = MovieClip(e.currentTarget);
			if (mc!=itemAtivo) {
				mudaEstadoVisual(mc, 'out');
			}
		}
		
		private function __click(e:MouseEvent):void {
			var mc:MovieClip = MovieClip(e.currentTarget);
			var mcVelho:MovieClip = itemAtivo;
			
			if (mc!=mcVelho) {
				itemAtivo = mc;
				
				mudaEstadoVisual(mc, 'on');
				mudaEstadoVisual(mcVelho, 'out');
				
				numItemAtivo = __mcsArray.indexOf(mc);
				
				__disparaEvento();
				
			}
		}
		
		public function mudaEstadoVisual($mc:MovieClip, estado:String):void { // muda somente o visual do mc
			if ($mc==null) {
				return;
			}
			switch (estado) {	
				case 'out' :
					McUtils.playTo($mc, __framesArray[0]);
				break;
				case 'over' :
					McUtils.playTo($mc, __framesArray[1]);
				break;
				case 'on' :
					McUtils.playTo($mc, __framesArray[2]);
				break;
			}
		}
		
		private function __disparaEvento():void {
			dispatchEvent(new Event(EVENT_CHANGE));
		}
		
		public function ativaItem(n:int):void {//ativa visualmente o item determinado, sem disparar o onRelease
			
			mudaEstadoVisual(itemAtivo, 'out');
			mudaEstadoVisual(__mcsArray[n], 'on');
			itemAtivo = __mcsArray[n];
			numItemAtivo = n;
			
			__disparaEvento();
		}
	}
}
