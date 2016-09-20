package  com.withlasers.display.interactiveSprite
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractiveSpriteEvent extends Event 
	{
		public static const ON_SELECT:String = 'ON_SELECT';
		
		
		public var instance:InteractiveSprite
		
		public function InteractiveSpriteEvent(type:String, instance:InteractiveSprite) 
		{ 
			this.instance = instance;
			super(type, false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new InteractiveSpriteEvent(type, instance);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("InteractiveSpriteEvent", "type", "instance"); 
		}
		
	}
	
}