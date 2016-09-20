package com.withlasers.debug{
	import flash.system.*;
	import flash.text.*;
	import flash.events.*;
	
	/**
	 * @author Fernando de França
	 */
	public class ConsoleTextField extends TextField {
		
		public var ref:*
		
		private var format:TextFormat;
		private var style:StyleSheet;
		
		
		public function ConsoleTextField() {
			ConsoleStyler.setBasicStyle(this);
			addEventListener(MouseEvent.CLICK, __handleClick);
		}
		
		private function __handleClick(e:MouseEvent):void {
			System.setClipboard(text);
		}
		
	}
	
}