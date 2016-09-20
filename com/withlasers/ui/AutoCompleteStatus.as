package com.withlasers.ui 
{
	import com.withlasers.ui.IAutoCompleteStatus;
	import flash.text.TextField;
	import flash.display.Sprite
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AutoCompleteStatus extends Sprite implements IAutoCompleteStatus
	{
		
		protected var __tf:TextField
		
		public function AutoCompleteStatus($message:String) 
		{
			mouseEnabled = false;
			mouseChildren = false;
			buttonMode = false;
			
			__build()
			
			message = 'Sem resultados para: ' + $message;
		}
		
		protected function __build():void
		{
			__tf = new TextField();
			__tf.mouseEnabled = false;
			__tf.width = 200;
			__tf.height = 25;
			__tf.textColor = 0xffffff;
			__tf.background = true;
			__tf.backgroundColor = 0x000000;
			
			addChild(__tf);
		}
		
		/* INTERFACE com.withlasers.ui.IAutoCompleteStatus */
		
		public function get message():String
		{
			return __tf.text;
		}
		
		public function set message($str:String):void
		{
			__tf.text = $str;
		}
		
	}

}