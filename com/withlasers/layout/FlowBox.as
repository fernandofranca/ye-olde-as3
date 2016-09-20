package com.withlasers.layout 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class FlowBox extends Container 
	{
		
		public function FlowBox(_parent:DisplayObjectContainer, desiredWidth:String, desiredHeight:String, gap:int=0, childrenHAlign:Number=0, childrenVAlign:Number=0) 
		{
			layoutOrientation = "FLOW"
			super(_parent, desiredWidth, desiredHeight, gap, childrenHAlign, childrenVAlign);
		}
		
		override public function layout():void 
		{
			_leftToRightLineFlow();
			
			super.layout();
		}
		
		public function addBreak():void 
		{
			addChild(new FlowBreak());
		}
		
	}

}