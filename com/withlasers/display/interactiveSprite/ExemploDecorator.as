package  com.withlasers.display.interactiveSprite
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import gs.easing.Bounce;
	import gs.easing.Elastic;
	import gs.easing.Expo;
	import gs.TweenMax;
	import com.withlasers.display.interactiveSprite.InteractiveSprite
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ExemploDecorator
	{
		public var designSpr:BotaoSelecionavel
		public var intSpr:InteractiveSprite
		
		public function ExemploDecorator($designSpr:DisplayObject, $intSpr:InteractiveSprite) 
		{
			designSpr = $designSpr as BotaoSelecionavel; 
			intSpr = $intSpr;
			
			intSpr.selectable = true;
			intSpr.renderOver = renderOver;
			intSpr.renderOut = renderOut;
			intSpr.renderSelected = renderSelected;
			intSpr.renderUnselected = renderUnselected;
			
			
			intSpr.setHitArea(-10, 0, designSpr.width+20, designSpr.height)
			
			renderOut()
			
			
			designSpr.tf.mouseEnabled = false
		}
		
		private function renderOver():void
		{
			//TweenMax.to(designSpr, 0.3, { frame:50, ease:Bounce.easeOut} );
			//TweenMax.to(designSpr.tf, 0.3, {tint:0xFFFFFF});
		}
		
		private function renderOut():void
		{
			//TweenMax.to(designSpr, 0.2, { frame:1 } );
			//TweenMax.to(designSpr.tf, 0.2, {tint:0xFF0000});
		}
		
		private function renderSelected():void 
		{
			//renderOver()
			//TweenMax.to(designSpr, 0.3, { frame:75, ease:Expo.easeOut} );
			//TweenMax.to(designSpr.tf, 0.2, {x:27});
			//designSpr.filters = [new DropShadowFilter(0, 0, 0x000080, 1, 9, 9, 1, 3, true)];
		}
		
		private function renderUnselected():void 
		{
			//renderOut()
			//TweenMax.to(designSpr, 0.3, { frame:1, ease:Expo.easeOut} );
			//TweenMax.to(designSpr.tf, 0.2, {x:7});
			//designSpr.filters = []
		}
		
	}

}