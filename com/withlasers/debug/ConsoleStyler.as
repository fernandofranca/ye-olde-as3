package com.withlasers.debug{
	import flash.system.*;
	import flash.text.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ConsoleStyler {
		
		public static const STYLE_DEFAULT:String = '1';
		public static const STYLE_INFO:String = '2';
		public static const STYLE_ERROR:String = '3';
		public static const STYLE_WARNING:String = '4';
		public static const STYLE_OBJ:String = '5';
		
		public static function setBasicStyle(tf:ConsoleTextField):void {
			
			
			with (tf) {
				/* basico */
				
				background = true;
				backgroundColor = 0xffffff;
				textColor = 0x000000;
				autoSize = TextFieldAutoSize.LEFT;
				multiline = true;
				selectable = false;
				
				format = new TextFormat();
				format.font = "Arial";
				format.size = 11;
				format.leading = 1;
				format.leftMargin = 2;
				format.rightMargin = 2;
				format.tabStops = [15, 200];
				
				defaultTextFormat = format;
			}
			
			__setStyleSheet(tf);
		}
		
		public static function setStyle(tf:ConsoleTextField, estilo:String):void {
			
			switch (estilo) {
				case STYLE_DEFAULT:
					tf.backgroundColor = 0xffffff;
					tf.textColor = 0xcccccc;
				break
				case STYLE_INFO:
					tf.backgroundColor = 0xffffff;
					tf.textColor = 0x666666
				break
				case STYLE_ERROR:
					tf.backgroundColor = 0xFE0146;
					tf.textColor = 0xffffff
				break
				case STYLE_WARNING:
					tf.backgroundColor = 0xFF9D3C;
					tf.textColor = 0x530B00;
				break
				case STYLE_OBJ:
					tf.backgroundColor = 0xD9F7FF;
					tf.textColor = 0x333333;
				break
			}
			
			__setStyleSheet(tf);
		}
		
		static private function __setStyleSheet(tf:ConsoleTextField):void {
			
			with (tf) {
				
				var h1:Object = new Object();
				h1.fontSize  = "16";
				
				var hover:Object = new Object();
				hover.fontWeight = "bold";
				hover.color = "#333399";
				
				var link:Object = new Object();
				link.fontWeight = "bold";
				link.color = "#3366cc";
				
				style = new StyleSheet();
				style.setStyle("a:link", link);
				style.setStyle("a:hover", hover);
				style.setStyle("h1", h1);
				
				styleSheet = style;
				
			}
			
		}
		
	}
	
}