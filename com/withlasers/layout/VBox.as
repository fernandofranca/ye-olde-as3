package com.withlasers.layout 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class VBox extends Container 
	{
		
		public function VBox (_parent:DisplayObjectContainer, desiredWidth:String, desiredHeight:String, gap:int=0, childrenHAlign:Number=0, childrenVAlign:Number=0) 
		{
			layoutOrientation = "V"
			super(_parent, desiredWidth, desiredHeight, gap, childrenHAlign, childrenVAlign);
		}
		
		override public function layout():void 
		{
			_verticalFlow();
			
			super.layout();
		}
		
	}

}