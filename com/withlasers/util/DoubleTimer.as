
package com.withlasers.util 
{
	import flash.utils.getTimer;
	import flash.utils.Timer
	import flash.events.TimerEvent
	import org.osflash.signals.Signal
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class DoubleTimer
	{
		private var __delay1:Number
		private var __delay2:Number
		private var __t1:Timer //delay longo
		private var __t2:Timer //delay normal
		
		private var __lastCycleTime:Number = 0
		
		public var isPaused:Boolean = false;
		
		/**
		 * é disparado na chamada do metodo start
		 */
		public var signalStart:Signal = new Signal();
		
		/**
		 * sinaliza o inicio dos ciclos apos o intervalo inicial
		 */
		public var signalTimerStart:Signal = new Signal();
		
		/**
		 * Sinaliza cada ciclo de repetição
		 */
		public var signalTimerCycle:Signal = new Signal();
		
		
		public function DoubleTimer($delayInicial:Number = 6, $intervalo:Number = 3) 
		{
			__delay1 = $delayInicial * 1000;
			__delay2 = $intervalo * 1000;
			
			__t1 = new Timer(__delay1, 1);
			__t2 = new Timer(__delay2, 0);
			
			__t1.addEventListener(TimerEvent.TIMER, __timerDelayInicial);
			__t2.addEventListener(TimerEvent.TIMER, __timerCycle);
		}
		
		/*
		 * Começa (do inicio, primeira imagem)
		 * */
		public function start():void
		{
			__t1.stop();
			__t2.stop();
			
			__t1.start();
			
			__lastCycleTime = getTimer();
			
			signalStart.dispatch();
		}
		
		/*
		 * Pausa avanço automatico
		 * */
		public function pause():void 
		{
			isPaused = true;
			
			if (__t1) {
				__t1.stop();
				__t2.stop();
			}
		}
		
		/* Continua avanço automatico após pausa
		 * */
		public function resume ():void 
		{
			__t2.start();
		}
		
		/*
		 * Remove tudo
		 * */
		public function destroy ():void 
		{
			try {
				pause();
			} catch (e:Error){}
			
			try {
				__t1.removeEventListener(TimerEvent.TIMER, __timerDelayInicial);
				__t2.removeEventListener(TimerEvent.TIMER, __timerCycle);
			} catch (e:Error){}
			
			signalStart.removeAll();
			signalTimerCycle.removeAll();
			signalTimerCycle.removeAll();
		}
		
		private function __timerCycle(e:TimerEvent):void 
		{
			signalTimerCycle.dispatch();
			
			__lastCycleTime = getTimer();
		}
		
		/**
		 * Timer do delay inicial
		 * @param	e
		 */
		private function __timerDelayInicial(e:*):void 
		{
			signalTimerStart.dispatch();
			
			__t1.stop();
			__t2.start();
			
			__lastCycleTime = getTimer();
		}
		
		public function get timerPercent():Number
		{
			return ((getTimer() - __lastCycleTime) / __delay2) * 100;
		}
		
	}

}