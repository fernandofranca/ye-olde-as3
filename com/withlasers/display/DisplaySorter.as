package  com.withlasers.display
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class DisplaySorter
	{
		protected static var ox:Number
		protected static var oy:Number
		protected static var referenceDo:DisplayObject
		/**
		 * Ordena um array de DisplayObjects e retorna o resultado
		 * @param	$arraySprites	Array de sprites
		 * @param	$ox				1 = direita,  -1 = esquerda, 0.5 = centro
		 * @param	$oy				1 = topo, -1 = base, 0.5 = centro
		 * @param	$invertido		inverte os resultados
		 * @return
		 */
		public static function sort($arraySprites:Array, $reference:DisplayObject, $ox:Number, $oy:Number, $invertido:Boolean=false):Array
		{
			ox = $ox;
			oy = $oy;
			referenceDo = $reference;
			
			$arraySprites.sort(__sortXY);
			if ($invertido == true) $arraySprites.reverse();
			
			return $arraySprites;
		}
		
		protected static function __sortXY(a:DisplayObject, b:DisplayObject):Number
		{
			var xa:Number = Math.abs(a.x - referenceDo.width * ox) - Math.abs(a.y - referenceDo.height * oy );
			var xb:Number = Math.abs(b.x - referenceDo.width * ox) - Math.abs(b.y - referenceDo.height * oy );
			
			if (xa > xb) 
			{
				return 1
			} else if (xa < xb) 
			{
				return -1
			} else 
			{
				return 0
			}
		}
		
	}

}