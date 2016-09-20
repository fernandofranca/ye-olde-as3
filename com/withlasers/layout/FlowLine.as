package com.withlasers.layout 
{
	import flash.display.DisplayObject;
	/**
	 * Abstracao de uma linha de um layout fluido
	 * @author Fernando de França
	 */
	internal class FlowLine 
	{
		private var horizontalGap:Number;
		public var maxWidth:Number;
		public var arrElementos:Array = [];
		
		public function FlowLine(maxWidth:Number, horizontalGap:Number=0) 
		{
			this.maxWidth = maxWidth;
			this.horizontalGap = horizontalGap;
			
			if (maxWidth < 1)
			{
				throw(new Error("FlowLine:Largura invalida"));
			}
		}
		
		public function add(obj:DisplayObject):Boolean 
		{
			arrElementos.push(obj)
			
			var value:Boolean = true
			
			if (totalWidth > maxWidth || obj is FlowBreak)
			{
				value = false;
				arrElementos.pop();
			}
			
			return value
		}
		
		public function flowHorizontal(childrenHAlign:Number=0):void 
		{
			var diffW:Number = (maxWidth - totalWidth) * childrenHAlign; // 0 esquerda, 0.5 centro, 1 direita
			
			var prevObj:DisplayObject
			
			for each (var obj:DisplayObject in arrElementos) 
			{
				if (prevObj) 
				{
					obj.x = prevObj.x + prevObj.width + horizontalGap; // layout da linha // ainda alinhado a direita
				} 
				else
				{
					obj.x = 0;
					obj.x += diffW;
				}
				
				
				prevObj = obj;
			}
			
		}
		
		public function get totalWidth():Number 
		{
			var value:Number = 0;
			var prevObj:DisplayObject
			
			for each (var obj:DisplayObject in arrElementos) 
			{
				value += obj.width + horizontalGap;
				
				prevObj = obj;
			}
			
			value -= horizontalGap;
			
			return value;
		}
		
		public function get totalHeight():Number 
		{
			var arrHeights:Array = [];
			
			for each (var obj:DisplayObject in arrElementos) 
			{
				arrHeights.push(obj.height)
			}
			
			return Math.max.apply(null, arrHeights);
		}
		
	}

}