package com.withlasers.patterns
{
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IIterator 
	{
		
		function get elements():Array
		
		function get length():int
		
		function get pointer():int
		function set pointer($p:int):void
		
		function hasNext():Boolean
		function hasPrevious():Boolean
		
		function next():*
		function previous():*
		
		function get currentElement():*
	}
	
	
}