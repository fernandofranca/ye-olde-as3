package com.withlasers.ui 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IRadioButton 
	{
		function get enabled():Boolean 
		function set enabled(value:Boolean):void
		
		function get id():String 
		function set id(value:String):void
		
		function get mc():Sprite 
		function set mc(value:Sprite):void
		
		function get text():String 
		function set text(value:String):void 
	}
	
}