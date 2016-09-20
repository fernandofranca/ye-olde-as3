package com.withlasers.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AutoCompleteEvent extends Event 
	{
		public static const ON_SHOW:String = 'ON_SHOW'
		public static const ON_HIDE:String = 'ON_HIDE'
		public static const ON_SELECT:String = 'ON_SELECT'
		public static const ON_SUGGEST:String = 'ON_SUGGEST'
		
		public var label:String
		public var id:String
		
		public function AutoCompleteEvent(type:String, label:String=null, id:String=null) 
		{ 
			this.label = label;
			this.id = id;
			
			super(type, false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new AutoCompleteEvent(type, label, id);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AutoCompleteEvent", "type", "label", "id"); 
		}
		
	}
	
}