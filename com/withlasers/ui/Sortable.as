/**
 * 
	for (var i:int = 0; i < 10; i++) 
	{
		spr = new SpriteSort(i);
		spr.y = i * 50;
		mcContainer.addChild(spr);
	}
	
	var srt:Sortable = new Sortable(mcContainer, 'y', 2);
	srt.signalChanged.add(onChange);
	
 */
package com.withlasers.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import gs.easing.Expo;
	import gs.TweenMax;
	import org.flashdevelop.utils.FlashConnect;
	import org.osflash.signals.Signal;
	
	/**
	 * Adiciona o comportamento de lista drag and drop a um container de elementos que devem implementar a interface ISortableSprite
	 * @author Fernando de França
	 */
	public class Sortable
	{
		public var signalChanged:Signal = new Signal(Array);
		public var container:DisplayObjectContainer
		public var stage:Stage
		public var orientation:String = 'y';
		public var margin:Number;
		public var tweenTime:Number = 0.2
		
		protected var tgtDrag:Sprite
		protected var _enabled:Boolean;
		
		protected var prevOrder:Array;
		protected var currOrder:Array;
		
		protected var beforeReleaseOrder:String
		protected var afterReleaseOrder:String
		
		public function Sortable($container:DisplayObjectContainer, $orientation:String, $margin:Number=0) 
		{
			orientation = $orientation;
			margin = $margin;
			
			container = $container;
			stage = container.stage;
			
			enabled = true;
			__arrange()
		}
		
		/**
		 * 
		 * @return Retorna um array de sprites
		 */
		private function __getCurrentOrderAsArray():Array
		{
			var arr:Array = McUtils.getChilds(container);
			arr.sortOn(orientation, Array.NUMERIC);
			
			return(arr)
		}
		
		/**
		 * 
		 * @return Retorna uma string para efeito de comparacao
		 */
		private function __getCurrentOrderAsString():String 
		{
			var str:String = ''
			var arr:Array = __getCurrentOrderAsArray();
			
			for each (var el:ISortableSprite in arr) 
			{
				str += ' ' + el.idNum;
			}
			
			return str
		}
		
		private function __startDrag():void
		{
			if (orientation=='x') 
			{
				tgtDrag.startDrag(false, new Rectangle( -tgtDrag.width-margin, 0, container.width + tgtDrag.width+(margin*2), 0));
			} 
				else 
			{
				tgtDrag.startDrag(false, new Rectangle( 0, -tgtDrag.height-margin, 0, container.height + tgtDrag.height+(margin*2)));
			}
			
		}
		
		private function __stopDrag():void
		{
			if (tgtDrag) tgtDrag.stopDrag()
		}
		
		private function __handleMouseDown(e:MouseEvent):void 
		{
			if (e.target.parent != container) return
			
			beforeReleaseOrder = __getCurrentOrderAsString();
			
			tgtDrag = Sprite(e.target);
			
			McUtils.sendToTop(tgtDrag)
			
			__startDrag();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, __handleMouseUp);
		}
		
		private function __handleMouseUp(e:MouseEvent):void 
		{
			afterReleaseOrder = __getCurrentOrderAsString();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, __handleMouseUp);
			
			__stopDrag();
			
			__arrange();
			
			__getCurrentOrderAsArray();
			
			__checkOrderChange();
		}
		
		private function __checkOrderChange():void
		{
			var cond:Boolean = afterReleaseOrder != beforeReleaseOrder;
			
			if (cond==true) 
			{
				var arrRes:Array = [];
				
				for each (var el:ISortableSprite in __getCurrentOrderAsArray()) 
				{
					arrRes.push(el.idNum);
				}
				
				signalChanged.dispatch(arrRes);
			}
		}
		
		private function __arrange():void 
		{
			if (orientation == 'x' ) 
			{
				arrangeHorizontal();
			} 
				else 
			{
				arrangeVertical();
			}
			
		}
		
		public function arrangeHorizontal():void
		{
			var arrChilds:Array = McUtils.getChilds(container);
			arrChilds.sortOn(orientation, Array.NUMERIC);
			
			var i:int = 0
			var arrPos:Array = []
			var posAnt:Number = 0;
			
			// determina as posicoes
			for each(var el:DisplayObjectContainer in arrChilds) {
				arrPos[i] = posAnt;
				posAnt = arrPos[i] + el.width + margin;
				i++;
			}
			
			// desloca para as respectivas posicoes
			i = 0;
			for each( el in arrChilds) {
				TweenMax.to(el, tweenTime, { x:arrPos[i], ease:Expo.easeInOut } );
				i++;
			}
		}
		
		public function arrangeVertical():void
		{
			var arrChilds:Array = McUtils.getChilds(container);
			arrChilds.sortOn(orientation, Array.NUMERIC);
			
			var i:int = 0
			var arrPos:Array = []
			var posAnt:Number = 0;
			
			// determina as posicoes
			for each(var el:DisplayObjectContainer in arrChilds) {
				arrPos[i] = posAnt;
				posAnt = arrPos[i] + el.height + margin;
				i++;
			}
			
			// desloca para as respectivas posicoes
			i = 0;
			for each( el in arrChilds) {
				TweenMax.to(el, tweenTime, { y:arrPos[i], ease:Expo.easeInOut } );
				i++;
			}
		}
		
		public function destroy():void 
		{
			__stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, __handleMouseUp);
			container.removeEventListener(MouseEvent.MOUSE_DOWN, __handleMouseDown);
			
			container = null;
			tgtDrag = null;
			stage = null;
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			if (_enabled != value) {
				if (value==true) 
				{
					container.addEventListener(MouseEvent.MOUSE_DOWN, __handleMouseDown);
				} else 
				{
					container.removeEventListener(MouseEvent.MOUSE_DOWN, __handleMouseDown);
				}
			}
		}
		
	}

}