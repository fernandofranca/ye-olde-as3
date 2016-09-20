package com.withlasers.display.interactiveSprite
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class InteractiveSpriteCreator
	{
		public static var decorator:IInteractiveSpriteDecorator = new InteractiveSpriteDecorator
		
		public static function fromClass($class:Class):InteractiveSprite
		{
			var sprDesign:DisplayObject = new $class();
			
			var spr:InteractiveSprite = new InteractiveSprite();
			
			spr.design = sprDesign;
			
			decorator.decorate(sprDesign, spr)
			
			return spr
		}
		
		public static function fromInstance($instance:DisplayObject):InteractiveSprite 
		{
			var nx:Number = $instance.x;
			var ny:Number = $instance.y;
			$instance.x = $instance.y = 0
			
			var parent:DisplayObjectContainer = $instance.parent as DisplayObjectContainer
			
			var spr:InteractiveSprite = new InteractiveSprite();
			spr.x = nx;
			spr.y = ny;
			parent.addChild(spr)
			
			spr.design = $instance;
			
			decorator.decorate($instance, spr)
			
			return spr
			
		}
		
		/*
		public static function botaoSelect($label:String):InteractiveSprite 
		{
			var spr:InteractiveSprite = fromClass(BotaoSelecionavel);
			
			BotaoSelecionavel(spr.design).tf.text = $label
			
			return spr
		}
		*/
		
	}

}