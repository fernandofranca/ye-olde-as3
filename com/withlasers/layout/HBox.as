package com.withlasers.layout 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class HBox extends Container 
	{
		
		public function HBox(_parent:DisplayObjectContainer, desiredWidth:String, desiredHeight:String, gap:int=0, childrenHAlign:Number=0, childrenVAlign:Number=0) 
		{
			layoutOrientation = "H"
			super(_parent, desiredWidth, desiredHeight, gap, childrenHAlign, childrenVAlign);
		}
		
		override public function layout():void 
		{
			_horizontalFlow();
			
			super.layout();
		}
		
	}

}