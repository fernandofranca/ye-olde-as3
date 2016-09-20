package com.withlasers.ui 
{
	import com.withlasers.ui.IAutoCompleteContainer;
	import com.withlasers.ui.IAutoCompleteItem;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	[Event(name="ON_SHOW", type="com.withlasers.ui.AutoCompleteEvent")] 
	[Event(name="ON_HIDE", type="com.withlasers.ui.AutoCompleteEvent")] 
	[Event(name="ON_SELECT", type="com.withlasers.ui.AutoCompleteEvent")] 
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AutoCompleteContainer extends Sprite implements IAutoCompleteContainer
	{
		
		public function AutoCompleteContainer() 
		{
			visible = false;
			__addListeners();
		}
		
		protected function __addListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, __handleAdded)
			addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved)
		}
		
		protected function __removeListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, __handleStageClick);
		}
		
		protected function __handleAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, __handleAdded);
			stage.addEventListener(MouseEvent.MOUSE_UP, __handleStageClick);
		}
		
		protected function __handleRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved);
			destroy()
		}
		
		protected function __handleStageClick(e:MouseEvent):void 
		{
			if (visible == true) hide();
			
			if (e.target is IAutoCompleteItem) 
			{
				dispatchEvent(new AutoCompleteEvent(AutoCompleteEvent.ON_SELECT, e.target.label, e.target.id));
			}
		}
		
		/* INTERFACE com.withlasers.ui.IAutoCompleteContainer */
		
		public function show():void
		{
			visible = true;
			dispatchEvent(new AutoCompleteEvent(AutoCompleteEvent.ON_SHOW));
		}
		
		public function hide():void
		{
			visible = false;
			dispatchEvent(new AutoCompleteEvent(AutoCompleteEvent.ON_HIDE));
		}
		
		public function addItem(item:IAutoCompleteItem):void
		{
			
			//posiciona
			Sprite(item).y = numChildren*(Sprite(item).height+2);
			
			// adiciona
			addChild(Sprite(item));
		}
		
		public function clearItems():void
		{
			McUtils.removeChilds(this)
		}
		
		public function destroy():void
		{
			clearItems();
			__removeListeners()
		}
		
	}

}