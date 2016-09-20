/*
XML.ignoreWhitespace = false;
XML.prettyPrinting = false;
XML.ignoreComments = false;
XML.ignoreProcessingInstructions = true;
*/
package  {
	
	/**
	 * @author Fernando de França
	 */
	public class XMLUtils {
		
		/**
		 * Retorna lista com os nós que contiverem o atributo COM o valor especificado
		 * 
		 * ex.: Todos li com class=entry
		 * var lista2:XMLList = XMLUtils.getNodesByAttribute(xml..li, 'class', 'entry'); 
		 * 
		 * ex.: Qualquer elemento com class=entry
		 * var lista2:XMLList = XMLUtils.getNodesByAttribute(xml..*, 'class', 'entry'); 
		 * 
		 */
		public static function getNodesByAttribute($xmlList:XMLList, $attribName:String, $attribValue:String):XMLList {
			
			return $xmlList.(attribute($attribName) == $attribValue);
			
		}
		
		/**
		 * 
				var lst:XMLList = xml.div.(@id == "promo").img
					
					// todas img dentro da div com id promo
				
				xml.div.(@id == "promo").img.@src
					
					// todos src
				
				xml..div.(@id=='nav').a.@href
					
					// todos href dos <a> de alguma div com id='nav'
				
				xml..div.(@class NAO FUNCIONA por causa do class
				
				
				<item><blip:user> ESTA USANDO NAMESPACE
				item.*::user		 // usando a sintaxe *:: para nao precisar dos namespaces
				
		 */
		
	}
	
}