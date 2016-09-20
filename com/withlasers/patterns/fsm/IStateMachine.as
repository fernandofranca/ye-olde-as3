package com.withlasers.patterns.fsm
{
	import flash.events.Event;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IStateMachine 
	{
		function get entity():*
		function set entity(e:*):void
		
		function get onChanged():Signal
		
		function setState($newState:IState):void
		function onExitHandler():void
		
		function get currentState():IState
		
		function get nextState():IState
		function set nextState($state:IState):void
		
		function get previousState():IState
		function set previousState($state:IState):void
	}
	
}