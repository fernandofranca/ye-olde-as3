package com.withlasers.layout
{
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Padding 
	{
		public var container:Container;
		
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _left:Number;
		
		public function Padding(container:Container, top:Number=0, right:Number=0, bottom:Number=0, left:Number=0) 
		{
			this.container = container;
			
			this.left = left;
			this.bottom = bottom;
			this.right = right;
			this.top = top;
		}
		
		public function get top():Number 
		{
			return _top;
		}
		
		public function set top(value:Number):void 
		{
			_top = value;
			container.layout();
		}
		
		public function get right():Number 
		{
			return _right;
		}
		
		public function set right(value:Number):void 
		{
			_right = value;
			container.layout();
		}
		
		public function get bottom():Number 
		{
			return _bottom;
		}
		
		public function set bottom(value:Number):void 
		{
			_bottom = value;
			container.layout();
		}
		
		public function get left():Number 
		{
			return _left;
		}
		
		public function set left(value:Number):void 
		{
			_left = value;
			container.layout();
		}
		
	}

}