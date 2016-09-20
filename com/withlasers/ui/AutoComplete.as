/*

	var mdl:Array = ['São Paulo', 'Santo André', 'Itu', 'São Carlos', 'Ribeirão Preto', 'São José do Rio Preto', 'Franca', 'Presidente Prudente', 'Marília', 'Catanduva', 'Bauru', 'Ourinhos','Guarujá','Aracaju','Manaus','Fortaleza','Recife','Natal','Belém','Dourados','Maringá','Londrina'];
	
	var tf:TextField = new TextField();
	tf.width = 300;
	tf.height = 20;
	tf.type = TextFieldType.INPUT;
	tf.border = true;
	stage.addChild(tf)
	
	var ac:AutoComplete = new AutoComplete(tf, mdl, AutoCompleteContainer, AutoCompleteItem, AutoCompleteStatus)
	
	ac.addEventListener(AutoCompleteEvent.ON_SELECT, function (e:AutoCompleteEvent):void 
	{
		Main.trace('!!!');
		Main.trace(ac.value)
	})
	
	ac.addEventListener(AutoCompleteEvent.ON_SUGGEST, function (e:AutoCompleteEvent):void 
	{
		Main.trace('...');
	})
*/

package com.withlasers.ui 
{
	import com.withlasers.util.SuggestionEngine;
	import com.withlasers.util.ISuggestionEngine;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	[Event(name="ON_SELECT", type="com.withlasers.ui.AutoCompleteEvent")] 
	[Event(name="ON_SUGGEST", type="com.withlasers.ui.AutoCompleteEvent")] 
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AutoComplete extends EventDispatcher
	{
		protected var __tf:TextField
		protected var __model:Array
		protected var __containerClass:Class
		protected var __itemClass:Class
		protected var __statusClass:Class
		protected var __container:IAutoCompleteContainer
		
		protected var __suggestionEngine:ISuggestionEngine
		protected var __timerDelay:Timer
		
		public var minLength:int = 3
		public var delay:int = 500
		public var suggestions:Array // array de strings
		public var value:String
		
		public function AutoComplete($tf:TextField, $model:Array, $containerClass:Class, $itemClass:Class, $statusClass:Class) 
		{
			__tf = $tf;
			__model = $model;
			__containerClass = $containerClass;
			__itemClass = $itemClass;
			__statusClass = $statusClass;
			__timerDelay = new Timer(delay, 1);
			
			// engine //
			__setupEngine();
			
			// container //
			__setupContainer();
			
			// listeners //
			__setupListeners();
		}
		
		public function destroy():void 
		{
			__timerDelay.stop();
			
			__removeListeners()
			__container.clearItems();
			__container.destroy();
			McUtils.removeChild(__container);
			
			__tf = null;
			__model = null;
			__containerClass = null;
			__container = null;
			__itemClass = null;
			__suggestionEngine = null;
			suggestions = null;
		}
		
		public function setStatus($msg:String):void 
		{
			__container.clearItems();
			Sprite(__container).addChild(new __statusClass($msg));
			__container.show();
			
		}
		
		protected function __setupEngine():void
		{
			__suggestionEngine = new SuggestionEngine()
			__suggestionEngine.model = __model;
		}
		
		protected function __setupContainer():void
		{
			__container = new __containerClass();
			__container['y'] = __tf.height + __tf.y+2;
			DisplayObjectContainer(__tf.parent).addChild(__container as DisplayObjectContainer)
		}
		
		protected function __setupListeners():void
		{
			__tf.addEventListener(Event.CHANGE, __handleInput)
			__timerDelay.addEventListener(TimerEvent.TIMER, __handleInputDelay);
			__container['addEventListener'](AutoCompleteEvent.ON_SELECT, __handleSelect)
		}
		
		protected function __removeListeners():void 
		{
			__tf.removeEventListener(Event.CHANGE, __handleInput)
			__timerDelay.removeEventListener(TimerEvent.TIMER, __handleInputDelay);
			__container['removeEventListener'](AutoCompleteEvent.ON_SELECT, __handleSelect)
		}
		
		protected function __chekInput():void 
		{
			if (input.length>=minLength)
			{
				__timerDelay.reset();
				__timerDelay.start();
			} else 
			{
				__container.hide();
			}
		}
		
		protected function __handleInput(e:Event):void 
		{
			__chekInput();
		}
		
		protected function __handleInputDelay(e:TimerEvent):void 
		{
			__container.clearItems();
			
			suggestions = __suggestionEngine.getSuggestion(input)
			
			var item:IAutoCompleteItem
			
			for each(var s:String in suggestions) 
			{
				item = new __itemClass(s, s);
				item.label = s;
				item.id = s;
				
				__container.addItem(item)
			}
			
			if (suggestions.length>0) 
			{
				__container.show();
				dispatchEvent(new AutoCompleteEvent(AutoCompleteEvent.ON_SUGGEST));
			} else 
			{
				setStatus(input)
			}
		}
		
		protected function __handleSelect(e:AutoCompleteEvent):void 
		{
			value = e.label;
			
			input = value;
			
			dispatchEvent(e);
		}
		
		public function get input():String { return __tf.text; }
		public function set input(value:String):void 
		{
			__tf.text = value;
		}
		
	}

}