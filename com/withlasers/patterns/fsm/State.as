package com.withlasers.patterns.fsm 
{
	import com.withlasers.patterns.fsm.*;
	import org.osflash.signals.Signal;
	
	/**
	 * ATENCAO: ISTO É APENAS UM MODELO
	 * 
	 * Para tornar oS StateS flexiveIs para contextos diferentes 
	 * evite extender a classe, apenas implementando a interface 
	 * e usando esta classe como modelo 
	 * 
	 * Use parametros no construtor para contextualizar acoes
	 * 
	 * @author Fernando de França
	 */
	public class State implements IState
	{
		protected var __entity:*
		protected var __stateMachine:IStateMachine
		protected var __onEntered:Signal = new Signal()
		protected var __onExited:Signal = new Signal()
		
		
		public function State() 
		{
			
		}
		
		/* INTERFACE fsm.IState */
		
		public function enter():void
		{
			// IMPLEMENTAR
			onEntered.dispatch()
		}
		
		public function exec():void
		{
			// IMPLEMENTAR
		}
		
		public function exit():void
		{
			// IMPLEMENTAR
			onExited.dispatch()
		}
		
		public function get entity():*
		{
			return __entity
		}
		
		public function set entity(e:*):void
		{
			__entity = e
		}
		
		public function get stateMachine():IStateMachine
		{
			return __stateMachine
		}
		
		public function set stateMachine(e:IStateMachine):void
		{
			__stateMachine = e;
		}
		
		public function get onEntered():Signal
		{
			return __onEntered
		}
		
		public function get onExited():Signal
		{
			return __onExited
		}
		
	}

}