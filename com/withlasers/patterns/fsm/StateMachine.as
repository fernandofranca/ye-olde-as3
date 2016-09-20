package com.withlasers.patterns.fsm 
{
	import com.withlasers.patterns.fsm.*;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class StateMachine implements IStateMachine
	{
		protected var __onChanged:Signal = new Signal(String);
		
		protected var __entity:*
		protected var __currentState:IState
		protected var __nextState:IState
		protected var __previousState:IState
		
		public function StateMachine($entity:*) 
		{
			__entity = $entity;
		}
		
		/* INTERFACE fsm.IStateMachine */
		
		
		
		public function get onChanged():Signal
		{
			return __onChanged
		}
		
		public function setState($newState:IState):void
		{
			if (__currentState == null) 
			{
				__newInstance($newState);
			} else 
			{
				__nextState = $newState;
				__currentState.exit();
			}
		}
		
		protected function __newInstance($newState:IState):void
		{
			__currentState = $newState;
			__currentState.entity = entity;
			__currentState.stateMachine = this;
			__currentState.onEntered.add(__currentState.exec);
			__currentState.onExited.addOnce(onExitHandler);
			__currentState.enter();
			
			onChanged.dispatch('' + $newState);
		}
		
		public function onExitHandler():void
		{
			if (__nextState!=null) 
			{
				__newInstance(__nextState);
			}
		}
		
		public function get currentState():IState
		{
			return __currentState
		}
		
		public function get nextState():IState
		{
			return __nextState
		}
		
		public function set nextState($state:IState):void
		{
			__nextState = $state;
		}
		
		public function get previousState():IState
		{
			return __previousState
		}
		
		public function set previousState($state:IState):void
		{
			__previousState = $state;
		}
		public function get entity():*
		{
			return __entity
		}
		
		public function set entity(e:*):void
		{
			__entity = e
		}
		
	}

}