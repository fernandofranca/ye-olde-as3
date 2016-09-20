/*
	var ab:AudioButton = new AudioButton(mcBarras, ['mc0', 'mc1', 'mc2', 'mc3', 'mc4'], 30);
	addChild(ab);
	
	ab.x = 300;
	ab.y = 50;
	
	ab.addEventListener(MouseEvent.CLICK, function ():void {
		if (ab.isEnabled==true) {
			ab.stop();
		} else {
			ab.start();
		}
	})
*/

package {
	import flash.display.*
	import flash.events.*;
	import flash.media.*
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	
	public class AudioButton extends MovieClip  {
		private var __mcsContainer:MovieClip //container dos movieclips que serao controlados
		private var __mcsNomes:Array //movieclips que serao controlados
		private var __mcs:Array //movieclips que serao controlados
		private var __intervaloAtualizacao:int;
		private var __frameEnabled:int
		private var __frameDisabled:int
		
		private var __arrValores:Array
		private var __ba:ByteArray
		
		private var __timerAtualizacao:Timer
		
		public var isEnabled:Boolean = true;
		
		
		public function AudioButton ($classeDoSimbolo:Class, $nomesMcs:Array, $intervaloAtualizacao:int=60, $frameEnabled:int = 1, $frameDisabled:int = 2):void {
			
			__mcsContainer = MovieClip(addChild(new $classeDoSimbolo()));
			__mcsNomes = $nomesMcs;
			__intervaloAtualizacao = $intervaloAtualizacao;
			__frameEnabled = $frameEnabled;
			__frameDisabled = $frameDisabled;
			
			this.addEventListener(Event.ADDED_TO_STAGE, __init)
		}
		
		private function __init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, __init);
			
			buttonMode = true;
			mouseChildren = false;
			
			__defineMcs();
			
			__arrValores = []
			__arrValores.length = 256;
			__ba = new ByteArray();
			
			__timerAtualizacao = new Timer(__intervaloAtualizacao);
			__timerAtualizacao.addEventListener(TimerEvent.TIMER, __loop);
			start()
		}
		
		private function __defineMcs():void{ //define movieclips que vao oscilar
			__mcs = [];
			for (var i:int = 0; i < __mcsNomes.length; i++) {
				__mcs[i] = __mcsContainer[__mcsNomes[i]];
			}
		}
		
		public function start():void {
			isEnabled = true;
			__timerAtualizacao.start();
			__mcsContainer.gotoAndStop(__frameEnabled);
		}
		
		override public function stop():void {
			isEnabled = false;
			__timerAtualizacao.stop()
			__desenhaDesligado()
			__mcsContainer.gotoAndStop(__frameDisabled);
		}
		
		private function __loop(e:Event):void {
			
			SoundMixer.computeSpectrum(__ba, true, 15);
			
			var i:uint = 0;
			while (i < 256 ) {
				i++;
				__arrValores[i] = __ba.readFloat()
			}
			
			__desenha();
		}
		
		private function __desenha():void {
			
			var mult:Number = 2;
			var div:int = __mcs.length;
			var elementosPorDiv:int = Math.floor(256 / div);
			
			var e:int = 0;
			var total:Number
			var i:int
			
			var arrFinal:Array = [];
			var valorParcial:Number = 0
			
			for (i = 1; i < 256; i++) {
				if (e+1<elementosPorDiv) {
					e++
					valorParcial += __arrValores[i];
				} else {
					arrFinal.push(valorParcial / elementosPorDiv)
					e = 0
					valorParcial = 0;
				}
			}
			
			for (i = 0; i < __mcs.length; i++) {
				__mcs[i].scaleY = arrFinal[i] * mult; // muda a escala dos mcs <<< altere aqui
			}
		}
		
		private function __desenhaDesligado():void {
			var i:int
			
			for (i = 0; i < __mcs.length; i++) {
				__mcs[i].scaleY = 1; // muda a escala dos mcs <<< altere aqui
			}
		}
	}
}