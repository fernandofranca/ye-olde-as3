package  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedSuperclassName;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ListChilds extends Sprite
	{
		public var str:String = "";
		public var arrItens:Array = []
		
		private var tf:TextField;
		private var shape:Shape = new Shape();
		private var textColor:Number;
		
		
		public function ListChilds($do:DisplayObjectContainer, $level:Number=0, $textColor:Number=0x000000) 
		{
			__makeList($do, $level);
			
			textColor = $textColor;
			__makeTf()
			__draw();
		}
		
		private function __makeTf():void 
		{
			tf = new TextField();
			tf.autoSize = "left";
			tf.wordWrap = false;
			tf.multiline = true;
			
			addChild(tf);
			
			var format:TextFormat = new TextFormat("Courier", 10, textColor);
			format.leading = 5;
			tf.defaultTextFormat = format;
			
			tf.addEventListener(MouseEvent.CLICK, __handleClick);
		}
		
		private function __handleClick(e:MouseEvent):void 
		{
			
			var n:int = tf.getLineIndexAtPoint(e.localX, e.localY);
			
			var _dObj:DisplayObject = DisplayObject(arrItens[n]);
			
			var _parent:DisplayObjectContainer = _dObj.parent;
			
			shape.graphics.clear()
			
			if (_parent == null) return
			
			_parent.addChild(shape);
			shape.graphics.lineStyle(1, 0xff0000, 1, true, LineScaleMode.NONE);
			
			var bounds:Rectangle = _dObj.getBounds(_parent);
			
			shape.graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
			
			trace(arrItens[n], _dObj.x, _dObj.y, _dObj.width, _dObj.height)
		}
		
		private function __draw():void 
		{
			tf.text = str;
		}
		
		private function __makeList($do:DisplayObjectContainer, $level:Number):void 
		{
			var level:Number = $level;
			
			__makeItem($do, level);
			
			var arrChildren:Array = McUtils.getChilds($do);
			
			for each (var item:DisplayObject in arrChildren) 
			{
				if (item is DisplayObjectContainer)
				{
					if (DisplayObjectContainer(item).numChildren>0)
					{
						var l:ListChilds = new ListChilds(DisplayObjectContainer(item), level + 1);
						str += l.str;
						
						arrItens = arrItens.concat(l.arrItens);
					} else 
					{
						__makeItem(item, level+1);
					}
				} else 
				{
					__makeItem(item, level+1);
				}
			}
		}
		
		private function __makeItem($do:DisplayObject, $level:Number):void 
		{
			var parent:DisplayObjectContainer = $do.parent;
			var i:int = parent.getChildIndex($do);
			
			var indent:String = ""
			for (var j:int = 0; j < $level; j++) 
			{
				indent += "    ";
			}
			
			arrItens.push($do);
			
			var name:String = $do.name
			
			
			
			__out(indent + "(" + i + ") " + $do + ' "' + name + '"' + " > " + getQualifiedSuperclassName($do));
		}
		
		private function __out($text:String):void 
		{
			$text = $text.replace("[object ", "[");
			$text = $text.replace("flash.display::", "");
			
			str += $text + "\n";
		}
		
		
		
	}
}