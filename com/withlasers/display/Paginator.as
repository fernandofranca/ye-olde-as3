package com.withlasers.display 
{
	import flash.display.*;
	import gs.easing.Expo;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Paginator extends Sprite
	{
		public var content:Sprite = new Sprite()
		public var position:int = 0
		
		protected var mascara:Mascara
		protected var __horizontal:Boolean
		
		public function Paginator($width:int, $height:int, $horizontal:Boolean=true) 
		{
			mascara = new Mascara(this, $width, $height, 0, 0);
			
			__horizontal = $horizontal;
			
			super.addChild(content);
		}
		
		/**
		 * Vai para a pagina (base em 0)
		 * @param	$n
		 */
		public function goto($n:int):void 
		{
			
			position = $n;
			
			var nd:int
			
			if (__horizontal) 
			{
				// horizontal
				if (position + 1 == total) 
				{
					nd = (content.height - mascara.width) * -1; // ultimo, compensa para nao ter viuva
				} else 
				{
					nd = ($n * mascara.width) * -1;
				}
				
				TweenLite.to(mascara, 0.5, { dx:nd, ease:Expo.easeInOut } );
			} else 
			{
				// vertical
				if (position + 1 == total) 
				{
					nd = (content.height - mascara.height) * -1; // ultimo, compensa para nao ter viuva
				} else 
				{
					nd = ($n * mascara.height) * -1;
				}
				
				TweenLite.to(mascara, 0.5, { dy:nd, ease:Expo.easeInOut } );
			}
		}
		
		/**
		 * Pagina até um determinado item
		 * @param	$do
		 */
		public function goToItem($do:DisplayObject):void 
		{
			var p:int
			
			if (__horizontal) 
			{
				p = $do.x / width;
				
			} else 
			{
				p = $do.y / height;
			}
			
			if (total>1) goto(p);
			
		}
		
		public function next():void 
		{
			if (position + 1 >= total) return
			
			goto(position + 1);
		}
		
		public function previous():void 
		{
			if (position - 1 <= -1) return
			
			goto(position - 1);
		}
		
		public function first():void 
		{
			goto(0)
		}
		
		public function last():void 
		{
			goto(total - 1);
		}
		
		public function get total():int
		{
			if (__horizontal)
			{
				return Math.ceil(content.width / mascara.width) //-1;
			} else 
			{
				return Math.ceil(content.height / mascara.height) //-1;
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return content.addChild(child);
		}
		
		override public function get width():Number { return mascara.width; }
		override public function set width(value:Number):void 
		{
			mascara.width = value;
		}
		
		override public function get height():Number { return mascara.height; }
		override public function set height(value:Number):void 
		{
			mascara.height = value;
		}
	}

}