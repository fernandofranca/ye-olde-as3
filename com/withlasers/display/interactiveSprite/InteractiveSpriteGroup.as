package  com.withlasers.display.interactiveSprite
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractiveSpriteGroup extends EventDispatcher
	{
		public var selectedItem:InteractiveSprite
		public var selectedItemNum:int
		
		public var arrItems:Array = []
		
		public function InteractiveSpriteGroup() 
		{
			
		}
		
		
		public function addItem($item:InteractiveSprite):void 
		{
			arrItems.push($item);
			
			$item.addEventListener(InteractiveSpriteEvent.ON_SELECT, __handleSelect)
		}
		
		
		private function __handleSelect(e:InteractiveSpriteEvent):void 
		{
			var newItem:InteractiveSprite = e.instance
			
			selectItem(newItem)
		}
		
		public function selectItemNum($n:int):void 
		{
			selectItem(arrItems[$n] as InteractiveSprite)
		}
		
		public function selectItem(newItem:InteractiveSprite):void
		{
			if (newItem==selectedItem) return
			
			if (selectedItem!=null) selectedItem.selected = false
			
			selectedItem = newItem;
			selectedItem.selected = true
			
			for (var i:int = 0; i < arrItems.length; i++) 
			{
				if (selectedItem==arrItems[i]) 
				{
					selectedItemNum = i;
					break
				}
			}
			
			trace(selectedItem, selectedItemNum)
		}
		
	}

}