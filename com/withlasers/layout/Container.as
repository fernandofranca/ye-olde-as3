// OK - constantes de alinhamento
// OK - dimensao fixada
// OK - dimensao do parent ou percentual
// OK - dimensao do content
	// OK - widthUnity - px, parent, content
	// OK - heightUnity - px, parent, content
	// OK - getter measuredWidth
	// OK - getter measuredHeight
// OK - alinhamento X e Y (reposiciona a view)
// OK - flow
// 14/09/2011 15:06

// OK - line break do FLowBox
// 18/09/2011 9:07 PM

// possibilidade de redimensionar para o stage?
// implementar dispose
	// dispose on remove opcional?
// padding
	// left, top, right, bottom, all, short
// margin
// hide overflow

// checar o bug do flowbox quando rola um overflow de um elemento maior que a largura linha
// implementar um layout "grid", tipo tabela, com largura e altura fixa
	// uma alternativa poderia ser com w e h arbitrarios, com numero de colunas fixas

// debug mode
// possibilidade de scroll
// background com 9 scale patch

package com.withlasers.layout 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.bytearray.display.ScaleBitmapSprite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Container extends Sprite 
	{
		public static var count:int = 0;
		
		public var id:int
		public var layoutOrientation:String = "V"; // sentido de distribuicao
		
		public var gap:int;
		public var childrenHAlign:Number;
		public var childrenVAlign:Number;
		
		public var widthPolicy:String; // pode ser "parent" ou "content" ou arbitrario percentual do parent "25%"
		public var heightPolicy:String; // pode ser "parent" ou "content"
		private var _desiredWidth:String;
		private var _desiredHeight:String;
		
		public var view:Sprite;
		
		public var bgColor:Number
		public var bgAlpha:Number = 1
		
		public var debugMode:Boolean = false;
		
		private var scaleBitmapSprite:ScaleBitmapSprite
		
		public function Container(_parent:DisplayObjectContainer, desiredWidth:String, desiredHeight:String, gap:int=0, childrenHAlign:Number=0, childrenVAlign:Number=0 ) 
		{
			count++;
			id = count;
			
			_desiredWidth = desiredWidth.toLowerCase();
			_desiredHeight = desiredHeight.toLowerCase();
			this.gap = gap;
			this.childrenHAlign = childrenHAlign;
			this.childrenVAlign = childrenVAlign;
			
			view = new Sprite();
			super.addChild(view);
			
			_parent.addChild(this);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			var d:DisplayObject = view.addChild(child)
			
			layout();
			
			return d;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var d:DisplayObject = view.addChildAt(child, index);
			
			layout();
			
			return d;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			var d:DisplayObject = view.removeChild(child);
			
			layout();
			
			return d;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var d:DisplayObject = view.removeChildAt(index);
			
			layout();
			
			return d;
		}
		
		public function removeAll():void 
		{
			while (numChildren>0) 
			{
				removeChildAt(0);
			}
			
			layout();
		}
		
		/**
		 * Pode ser usado pelo DisplayObject de conteudo para notificar seu respectivo container da sua mudança de dimensao
		 * @param	contentChanged
		 */
		public static function notifySizeChange(contentChanged:DisplayObject):void 
		{
			if (contentChanged.parent == null) return;
			
			var sp:DisplayObjectContainer = contentChanged.parent.parent
			
			if (sp is Container) Container(sp).layout()
		}
		
		public function setBackgroundScaleBitmap(bmpData:BitmapData, rect:Rectangle):void 
		{
			if (scaleBitmapSprite != null) super.removeChild(scaleBitmapSprite);
			
			scaleBitmapSprite = new ScaleBitmapSprite(bmpData, rect);
			scaleBitmapSprite.width = measuredWidth;
			scaleBitmapSprite.height = measuredHeight;
			
			super.addChildAt(scaleBitmapSprite, 0);
			
			_drawBounds();
			
			//var scaleSpr:ScaleBitmapSprite = new ScaleBitmapSprite(bmp.bitmapData, new Rectangle(10, 10, 174-20, 82-20));
		}
		
		public function layout():void 
		{
			//if (parent == null) return; // remover
			
			_layoutParent()
		}
		
		protected function _layoutParent():void 
		{
			if (parent == null) return;
			
			if (parent.parent is Container) Container(parent.parent).layout()
		}
		
		protected function _verticalFlow():void 
		{
			// TOP - BOTTOM
			var t:int = view.numChildren;
			var i:int = 0;
			var prevPosition:Number = 0;
			var element:DisplayObject
			
			while (i<t) 
			{
				element = view.getChildAt(i);
				element.y = prevPosition;
				
				_horizontalAlign(element);
				
				prevPosition = element.y + element.height + gap;
				
				i++;
			}
			
			_verticalAlign(view)
			
			_drawBounds();
		}
		
		protected function _horizontalFlow():void 
		{
			// LEFT - RIGHT
			var t:int = view.numChildren;
			var i:int = 0;
			var prevPosition:Number = 0;
			var element:DisplayObject
			
			while (i<t) 
			{
				element = view.getChildAt(i);
				element.x = prevPosition;
				
				_verticalAlign(element);
				
				prevPosition = element.x + element.width + gap;
				
				i++;
			}
			
			_horizontalAlign(view)
			
			_drawBounds();
		}
		
		protected function _leftToRightLineFlow():void 
		{
			// percorre elementos
				// monta array de linhas
				
			// percorre array de linhas
				// faz layout
			
			
			var linha:FlowLine = new FlowLine(measuredWidth, gap)
			var arrLinhas:Array = [linha];
			
			var t:int = view.numChildren;
			var i:int;
			var element:DisplayObject
			
			// monta array de linhas
			i = 0;
			while (i<t) 
			{
				element = view.getChildAt(i);
				
				var b:Boolean = linha.add(element);
				
				if (b == false) // estourou a linha
				{
					linha = new FlowLine(measuredWidth, gap)
					linha.add(element);
					arrLinhas.push(linha);
				}
				
				i++;
			}
			
			
			// faz layout das linhas
			var prevLine:FlowLine;
			var ny:Number = 0
			
			for each(var line:FlowLine in arrLinhas)
			{
				if (prevLine == null) ny = 0;
				
				for each (var obj:DisplayObject in line.arrElementos) 
				{
					obj.y = ny;
				}
				
				line.flowHorizontal(childrenHAlign);
				
				ny += line.totalHeight+gap;
				
				prevLine = line;
			}
			
			_verticalAlign(view)
			
			_drawBounds();
			
		}
		
		protected function _horizontalAlign(element:DisplayObject):void 
		{
			element.x = (measuredWidth * childrenHAlign) - (element.width * childrenHAlign); 
		}
		
		protected function _verticalAlign(element:DisplayObject):void 
		{
			element.y = (measuredHeight * childrenVAlign) - (element.height * childrenVAlign); 
		}
		
		public function get measuredWidth():Number 
		{
			if (visible == false) return 0;
			
			if (widthPolicy == null) // parse desired value
			{
				if (desiredWidth.indexOf("%") > -1) 				widthPolicy = "parentPercent";
				if (desiredWidth.indexOf("parent") > -1) 		widthPolicy = "parent";
				if (desiredWidth.indexOf("content") > -1) 	widthPolicy = "content";
				if (Number(desiredWidth) >= 0 ) 						widthPolicy = "absolute";
			}
			
			var value:Number
			
			if (parent == null) return 1;
			
			switch (widthPolicy) 
			{
				case "parentPercent":
					var perc:Number = Number(desiredWidth.substr(0, desiredWidth.length - 1))/100;
					
					value = Container(parent.parent).measuredWidth*perc;
				break;
				
				case "parent":
					value = Container(parent.parent).measuredWidth;
				break;
				
				case "content":
					value = view.width;
				break;
				
				case "absolute":
					value = Number(desiredWidth);
				break;
			}
			
			return value;
		}
		
		public function get measuredHeight():Number 
		{
			if (visible == false) return 0;
			
			if (heightPolicy == null) // parse desired value
			{
				if (desiredHeight.indexOf("%") > -1) 				heightPolicy = "parentPercent";
				if (desiredHeight.indexOf("parent") > -1) 	heightPolicy = "parent";
				if (desiredHeight.indexOf("content") > -1) 	heightPolicy = "content";
				if (Number(desiredHeight) >= 0 ) 						heightPolicy = "absolute";
			}
			
			var value:Number
			
			if (parent == null) return 1;
			
			switch (heightPolicy) 
			{
				case "parentPercent":
					var perc:Number = Number(desiredHeight.substr(0, desiredHeight.length - 1))/100;
					
					value = Container(parent.parent).measuredHeight*perc;
				break;
				
				case "parent":
					value = Container(parent.parent).measuredHeight;
				break;
				
				case "content":
					value = view.height;
				break;
				
				case "absolute":
					value = Number(desiredHeight);
					
				break;
			}
			
			
			return value;
		}
		
		protected function _drawBounds():void 
		{
			var w:Number = measuredWidth; 
			var h:Number = measuredHeight; 
			
			// desenha scale bitmap se existir
			if (scaleBitmapSprite != null)
			{
				scaleBitmapSprite.width = w;
				scaleBitmapSprite.height = h;
				graphics.clear();
				return;
			}
			
			if (isNaN(bgColor)) return; // nao desenha se nao tiver cor de bg atribuida
			
			graphics.clear();
			graphics.beginFill(bgColor, bgAlpha);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
		override public function toString():String 
		{
			return super.toString() + " id " + id;
		}
		
		override public function get numChildren():int 
		{
			return view.numChildren;
		}
		
		override public function set width(value:Number):void {}
		override public function get width():Number 
		{
			return measuredWidth;
		}
		
		override public function set height(value:Number):void {}
		override public function get height():Number 
		{
			return measuredHeight;
		}
		
		override public function get visible():Boolean 
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void 
		{
			if (value == super.visible) return;
			
			super.visible = value;
			
			//se visible = false torna o measuredWidth e measuredHeight = 0
			
			_layoutParent();
		}
		
		public function get desiredHeight():String 
		{
			return _desiredHeight;
		}
		
		public function set desiredHeight(value:*):void 
		{
			value = String(value);
			_desiredHeight = value;
			layout();
		}
		
		public function get desiredWidth():String 
		{
			return _desiredWidth;
		}
		
		public function set desiredWidth(value:*):void 
		{
			value = String(value);
			_desiredWidth = value;
			layout();
		}
		
		
	}

}