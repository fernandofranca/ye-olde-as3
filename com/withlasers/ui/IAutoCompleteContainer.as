package com.withlasers.ui 
{
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IAutoCompleteContainer
	{
		function show ():void
		function hide ():void
		
		function addItem(item:IAutoCompleteItem):void;
		function clearItems():void
		function destroy():void
	}
	
}