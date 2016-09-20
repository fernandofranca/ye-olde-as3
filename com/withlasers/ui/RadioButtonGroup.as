/*
	var rgb:RadioButtonGroup = new RadioButtonGroup();
	rgb.addItem(formMc.radio1, 'Opcao 1', 'true')
	rgb.addItem(formMc.radio2, 'Opcao 2 com mais texto', 'false')
	rgb.addItem(formMc.radio3, 'Opcao 3 lorem ipsum dolor', 'false')
	rgb.distribuiItens(RadioButtonGroup.SENTIDO_HORIZONTAL, 3)
	
	trace(rgb.value)
*/

package com.withlasers.ui 
{
	import com.withlasers.ui.IFormCampo;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class RadioButtonGroup implements IFormCampo
	{
		
		
		/**
		 * Array dos objetos adicionados
		 */
		private var __arrValores:Array = []
		
		private var __tabIndex:Number
		
		public static const SENTIDO_HORIZONTAL:String = 'h'
		public static const SENTIDO_VERTICAL:String = 'v'
		
		public function RadioButtonGroup() 
		{
			
		}
		
		public function addItem($mc:Sprite, $label:String, $value:String='false'):void {
			
			
			var rb:RadioButton = new RadioButton($mc, $label, $value=='true')
			__arrValores.push(rb);
			rb.id = String(__arrValores.length - 1);
			rb.group = this;
		}
		
		public function selectNext():void 
		{
			var $rb:RadioButton
			
			for (var i:int = 0; i < __arrValores.length; i++) 
			{
				$rb = __arrValores[i] as RadioButton;
				
				if ($rb.enabled==true) break
			}
			
			if (i+1<__arrValores.length) 
			{
				$rb = __arrValores[i + 1] as RadioButton;
			}
			
			enabledItem = $rb
			$rb.focus();
		}
		
		public function selectPrevious():void 
		{
			var $rb:RadioButton
			
			for (var i:int = 0; i < __arrValores.length; i++) 
			{
				$rb = __arrValores[i] as RadioButton;
				
				if ($rb.enabled==true) break
			}
			
			if (i-1>-1) 
			{
				$rb = __arrValores[i - 1] as RadioButton;
			}
			
			enabledItem = $rb
			$rb.focus();
		}
		
		public function distribuiItens($sentido:String, $gap:int):void 
		{
			var mcAnt:Sprite
			var mc:Sprite
			
			for each(var i:RadioButton in __arrValores) 
			{
				mc = i.mc
				
				if (mcAnt) 
				{
					if ($sentido==SENTIDO_HORIZONTAL) 
					{
						mc.x = mcAnt.x + mcAnt.width + $gap;
						mc.y = mcAnt.y;
					} else 
					{
						mc.y = mcAnt.y + mcAnt.height + $gap;
						mc.x = mcAnt.x;
					}
				}
				
				mcAnt = mc;
			}
		}
		
		public function get enabledItem():RadioButton 
		{
			for each(var i:RadioButton in __arrValores) 
			{
				if (i.enabled == true)  break
			}
			
			return i
		}
		
		public function set enabledItem($item:RadioButton):void 
		{
			
			for each(var i:RadioButton in __arrValores) 
			{
				i.enabled = false;
			}
			
			$item.enabled = true;
		}
		
		/* INTERFACE com.withlasers.ui.IFormCampo */
		
		public function get text():String
		{
			return value
		}
		
		public function set text(value:String):void
		{
			
		}
		
		public function get value():String
		{
			return enabledItem.text
		}
		
		public function set value(t:String):void
		{
			
		}
		
		public function get tabIndex():Number
		{
			return __tabIndex;
		}
		
		public function set tabIndex(value:Number):void
		{
			
			enabledItem.tabIndex = value;
			var n:int = 0;
			
			for each(var i:RadioButton in __arrValores) 
			{
				i.tabIndex = value + n;
				n++;
			}
			
			__tabIndex = i.tabIndex
		}
		
		public function showError(msg:String):void
		{
			
		}
		
	}

}