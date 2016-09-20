package com.withlasers.ui 
{
	import com.withlasers.ui.IAutoCompleteItem;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AutoCompleteItem extends Sprite implements IAutoCompleteItem
	{
		protected var __tf:TextField
		
		protected var __id:String
		
		public function AutoCompleteItem($label:String, $id:String) 
		{
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			
			__build()
			
			label = $label;
			id = $id;
		}
		
		protected function __build():void
		{
			
			__tf = new TextField();
			__tf.mouseEnabled = false;
			__tf.width = 200;
			__tf.height = 25;
			__tf.background = true;
			__tf.backgroundColor = 0xC0C0C0;
			
			addChild(__tf);
		}
		
		override public function toString():String 
		{
			return '[AutoCompleteItem] '+label + ' ' + id
		}
		
		/* INTERFACE com.withlasers.ui.IAutoCompleteItem */
		
		public function get label():String
		{
			return __tf.text
		}
		
		public function set label($str:String):void
		{
			__tf.text = $str;
		}
		
		public function get id():String
		{
			return __id
		}
		
		public function set id($str:String):void
		{
			__id = $str;
		}
		
	}

}