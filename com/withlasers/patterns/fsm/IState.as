package com.withlasers.patterns.fsm
{
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IState 
	{
		function get entity():*
		function set entity(e:*):void
		
		function get stateMachine():IStateMachine
		function set stateMachine(e:IStateMachine):void
		
		function get onEntered():Signal
		function get onExited():Signal
		
		function enter():void
		function exec():void
		function exit():void
	}
	
}