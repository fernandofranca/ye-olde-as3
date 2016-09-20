package com.withlasers.util 
{
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface ISuggestionEngine
	{
		function get model():Array
		function set model($modelArr:Array):void
		
		function getSuggestion($strInput:String):Array
	}
	
}