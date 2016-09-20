package com.withlasers.display.interactiveSprite
{
	import com.withlasers.display.interactiveSprite.InteractiveSpriteCreator;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ExemploCreator extends InteractiveSpriteCreator
	{
		
		public static function criaBotaoX():InteractiveSprite
		{
			var spr:InteractiveSprite = InteractiveSpriteCreator.fromClass(BotaoSelecionavel);
			
			new ExemploDecorator(spr.getChildAt(0), spr);
			
			return spr
		}
		
	}

}