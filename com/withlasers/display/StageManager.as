package com.withlasers.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class StageManager 
	{
		public var target:DisplayObject
		public var destroyOnRemoved:Boolean
		public var addedHandler:Function
		public var resizedHandler:Function
		public var removedHandler:Function 
		
		public var stageRef:Stage
		
		public function StageManager($target:DisplayObject, 
										$destroyOnRemoved:Boolean=true,
										$addedHandler:Function = null,
										$resizedHandler:Function = null,
										$removedHandler:Function=null) 
		{
			target = $target;
			destroyOnRemoved = $destroyOnRemoved;
			addedHandler = $addedHandler;
			resizedHandler = $resizedHandler;
			removedHandler = $removedHandler;
			
			addListeners()
		}
		
		// adiciona listeners
		private function addListeners():void 
		{
			// tem stage?
			if (target.stage != null) 
			{
				stageRef = target.stage;
				stageRef.addEventListener(Event.RESIZE, __resized)
			}
			target.addEventListener(Event.ADDED_TO_STAGE, __added)
			target.addEventListener(Event.REMOVED_FROM_STAGE, __removed)
		}
		
		private function __added(e:Event):void 
		{
			
			if (stageRef == null)
			{
				stageRef = target.stage;
				stageRef.addEventListener(Event.RESIZE, __resized)
			}
			
			__exec(addedHandler);
		}
		
		private function __removed(e:Event):void 
		{
			__exec(removedHandler);
			
			if (destroyOnRemoved==true) destroy()
		}
		
		private function __resized(e:Event):void 
		{
			__exec(resizedHandler);
			
		}
		
		private function __exec($func:Function):void
		{
			if ($func == null) return
			
			try 
			{
				$func();
			} catch (e:Error)
			{
				trace(e);
			}
		}
		
		public function destroy():void 
		{
			// remove listeners
			if (stageRef != null) stageRef.removeEventListener(Event.RESIZE, __resized);
			target.removeEventListener(Event.ADDED_TO_STAGE, __added);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, __removed);
			
			//destroy referencias
			target = null;
			stageRef = null;
			addedHandler = resizedHandler = removedHandler = null;
		}
		
		public function get width():Number 
		{
			if (stageRef == null) return 0
			
			return stageRef.stageWidth
		}
		
		public function get height():Number 
		{
			if (stageRef == null) return 0
			
			return stageRef.stageHeight
		}
	}
	
}