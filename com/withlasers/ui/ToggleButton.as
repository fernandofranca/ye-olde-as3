package com.withlasers.ui {
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * Botao Liga/Desliga
	 * @param	$arrFrames
							0	frame Unselected
							1	frame UnselectedOver
							2	frame Selected
							3	frame SelectedOver
							4	frame Disabled
	 */
	public class ToggleButton extends MovieClip {
		
		/*
			frameUnselected
			frameUnselectedOver
			frameSelected
			frameSelectedOver
			frameDisabled
		*/
		
		private var __arrFrames:Array
		
		private var _enabled:Boolean = true;
		private var _selected:Boolean = false;
		
		private static const STATE_SELECTED:String = 'selected';
		private static const STATE_SELECTED_OVER:String = 'selected over';
		private static const STATE_UNSELECTED:String = 'unselected';
		private static const STATE_UNSELECTED_OVER:String = 'unselected over';
		private static const STATE_ENABLED:String = 'enabled';
		private static const STATE_DISABLED:String = 'disabled';
		
		public static const EVENT_SELECT:String = 'select';
		public static const EVENT_UNSELECT:String = 'unselect';
		public static const EVENT_ENABLE:String = 'enable';
		public static const EVENT_DISABLE:String = 'disable';
		
		public function ToggleButton():void {
			
			__arrFrames = [1, 2, 3, 4, 5];
			
			enabled = true;
			selected = false;
			buttonMode = true;
			
			__observeEvents();
		}
		
		private function __observeEvents():void{
			addEventListener(MouseEvent.ROLL_OVER, __handleEvents);
			addEventListener(MouseEvent.ROLL_OUT, __handleEvents);
			addEventListener(MouseEvent.CLICK, __handleEvents);
			
			addEventListener(Event.REMOVED_FROM_STAGE, __handleRemoved)
		}
		
		private function __handleRemoved(e:Event):void {
			removeEventListener(MouseEvent.ROLL_OVER, __handleEvents);
			removeEventListener(MouseEvent.ROLL_OUT, __handleEvents);
			removeEventListener(MouseEvent.CLICK, __handleEvents);
		}
		
		private function __handleEvents($evt:MouseEvent):void {
			
			switch ($evt.type) {
				case MouseEvent.ROLL_OVER:
					if (selected==true) {
						__setVisual(STATE_SELECTED_OVER)
					} else {
						__setVisual(STATE_UNSELECTED_OVER)
					}
				break
				
				case MouseEvent.ROLL_OUT:
					if (selected==true) {
						__setVisual(STATE_SELECTED)
					} else {
						__setVisual(STATE_UNSELECTED)
					}
					
				break
				
				case MouseEvent.CLICK:
					selected = !selected;
					
					// so dispara o evento na interação do usuario
					switch (selected) {
						case true:
							__dispatchEvent(EVENT_SELECT);
						break
						
						case false:
							__dispatchEvent(EVENT_UNSELECT);
						break
					}
				break
			}
		}
		
		private function __dispatchEvent($event:String):void{
			dispatchEvent(new Event($event));
		}
		
		private function __setVisual($state:String):void{
			switch ($state) {
				case STATE_SELECTED:
					gotoAndStop(__arrFrames[2]);
				break
				
				case STATE_SELECTED_OVER:
					gotoAndStop(__arrFrames[3]);
				break
				
				case STATE_UNSELECTED:
					gotoAndStop(__arrFrames[0]);
				break
				
				case STATE_UNSELECTED_OVER:
					gotoAndStop(__arrFrames[1]);
				break
				
				case STATE_ENABLED:
					if (selected==true) {
						gotoAndStop(__arrFrames[2]);
					} else {
						gotoAndStop(__arrFrames[0]);
					}
				break
				
				case STATE_DISABLED:
					gotoAndStop(__arrFrames[4]);
				break
				
			}
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void {
			
			// so dispara o evento na interação do usuario
			
			if (value != _selected) {
				
				_selected = value;
				
				switch (value) {
					
					case true:
						__setVisual(STATE_SELECTED);
					break
					
					case false:
						__setVisual(STATE_UNSELECTED);
					break
				}
			}
		}
		
		override public function get enabled():Boolean { return _enabled; }
		
		override public function set enabled(value:Boolean):void {
			
			if (value != _enabled) {
				_enabled = value;
				mouseEnabled = value;
				
				switch (value) {
					
					case true:
						__setVisual(STATE_ENABLED);
						__dispatchEvent(EVENT_ENABLE);
					break
					
					case false:
						__setVisual(STATE_DISABLED);
						__dispatchEvent(EVENT_DISABLE);
					break
				}
				
			}
		}
	}
	
}