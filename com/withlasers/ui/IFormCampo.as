package com.withlasers.ui{
	
	/**
	 * Interface dos campos do form
	 * @author Fernando de França
	 */
	public interface IFormCampo {
		function get text():String 
		function set text(value:String):void 
		
		function get label():String
		
		function get value():String
		function set value(t:String):void
		
		function get tabIndex():int
		function set tabIndex(value:int):void
		
		function showError(msg:String):void 
	}
	
}