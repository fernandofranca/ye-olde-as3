package  com.withlasers.display.interactiveSprite
{
	import com.withlasers.display.interactiveSprite.InteractiveSprite
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractiveSpriteDecorator implements IInteractiveSpriteDecorator
	{
		
		public function InteractiveSpriteDecorator() 
		{
			
		}
		
		/* INTERFACE IInteractiveSpriteDecorator */
		
		public function decorate(sprDesign:*, spr:InteractiveSprite):void
		{
			//if (sprDesign is BotaoSelecionavel) 	new BotaoSelecionavelDecorator(sprDesign, spr);
			//if (sprDesign is CampoTexto) 			new CampoTextoDecorator(sprDesign, spr);
		}
		
	}

}