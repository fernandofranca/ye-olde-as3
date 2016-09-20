package com.withlasers.services {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class RemotingEvent extends Event {
		public static const ON_SUCESS:String = 'ON_SUCESS'
		public static const ON_ERROR:String = 'ON_ERROR'
		
		public var value:*
		
		public function RemotingEvent($type:String, $value:*) { 
			value = $value;
			super($type, false, false);
		} 
		
		public override function clone():Event { 
			return new RemotingEvent(type, value);
		} 
		
		public override function toString():String { 
			return formatToString("RemotingEvent", "type", "value"); 
		}
		
	}
	
}