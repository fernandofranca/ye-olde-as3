package com.withlasers.ui{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public interface IFormCampoSelectItem {
		
		function get text():String 
		function set text(value:String):void 
		
		function get value():String
		function set value(t:String):void
		
		function get id():String 
		function set id(value:String):void
		
		function get mc():Sprite 
		function set mc(value:Sprite):void
	}
	
}