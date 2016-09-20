package  com.withlasers.display {
	import flash.display.MovieClip;
	
	/**
	 * Esta classe dispara automaticamente o redraw do Container
	 * @author Fernando de França
	 */
	public class MovieClipContainerChild extends MovieClip {
		
		public function MovieClipContainerChild() {
			
		}
		
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void {
			super.width = value;
			__redrawParentContainer();
		}
		
		override public function get height():Number { return super.height; }
		
		override public function set height(value:Number):void {
			super.height = value;
			__redrawParentContainer();
		}
		
		private function __redrawParentContainer():void{
			if (isContainerChild) {
				MovieClipContainer(parent).redraw();
			}
		}
		
		/**
		 * Checa se esta dentro de um MovieClipContainer
		 */
		public function get isContainerChild():Boolean {
			return parent is MovieClipContainer;
		}
		
	}
	
}