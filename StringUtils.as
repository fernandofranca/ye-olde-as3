package  {
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class StringUtils {
		
		/**
		 * Faz a troca de TODAS ocorrencias de $old por $new
		 */
		public static function replace($str:String, $old:String, $new:String=''):String {
			return $str.split($old).join($new);
		}
		
		/**
		 * Retorna um array das urls das imagens
		 */
		public static function getImgsUrls($str:String):Array {
			var reImg:RegExp = /<img([^<>+]*)>/g; // todas imagens
			var reSrc:RegExp = /(?<=src=['|"])[^'|"]*?(?=['|"])/gi; // todos src
			
			var imgStr:String = $str.match(reImg).join(' ');
			
			return imgStr.match(reSrc);
		}
		
		/**
		 * Remove a Tag determinada
		 * @param	$str	Origem
		 * @param	$tag	nome da Tag a ser removida. Ex.: object, NÃO <object>
		 */
		public static function removeTag($str:String, $tag:String):String {
			var strLimpa:String
			
			var re:RegExp = new RegExp('<'+$tag+'[^><]*>|<.'+$tag+'[^><]*>','g')
			strLimpa = $str.replace(re,'');
			
			return strLimpa;
		}
		
		/**
		 * Remove Tags vazias do código
		 * @param	$str
		 * @return
		 */
		public static function removeEmptyTags($str:String):String {
			var re:RegExp = /<(?!input¦br¦img¦meta¦hr¦\/)[^>]*>\s*<\/[^>]*>/gi;
			
			return $str.replace(re, '');
		}
		
		/**
		 * Limpa: tags (img, object, param, embed, div), tags vazias, quebras duplas
		 * @param	$str
		 * @return
		 */
		public static function cleanHTML($str:String):String {
			var nStr:String = $str;
			
			// remove as tags invalidas
			nStr = StringUtils.removeTag(nStr, 'img');
			nStr = StringUtils.removeTag(nStr, 'object');
			nStr = StringUtils.removeTag(nStr, 'param');
			nStr = StringUtils.removeTag(nStr, 'embed');
			nStr = StringUtils.removeTag(nStr, 'div');
			nStr = nStr.split('strong').join('b'); // converte strong para b
			
			// remove as tags vazias
			nStr = StringUtils.removeEmptyTags(nStr); //2x, pois nao mata todas vazias na primeira
			nStr = StringUtils.removeEmptyTags(nStr);
			
			// remove quebras duplas
			nStr = nStr.split('\r\n\r\n').join('\r\n'); 
			nStr = nStr.split('\r\r').join('\r'); 
			nStr = nStr.split('\n\n').join('\n');
			
			return nStr
		}
		
		/**
		 * Retorna só o body, removendo o restante (header, etc...)
		 */
		public static function getBody($html:String):String {
			
			var i1:Number = $html.indexOf('<body');
			var i2:Number = $html.indexOf('</body>') + 7;
			
			return $html.substring(i1, i2);
		}
		
		/**
		 * Reduz o tamanho do texto para o numero de caracteres especificado
		 */
		public static function reduz($str:String, $maxChars:int):String {
			if ($str.length <= $maxChars) return $str
			
			$str = $str.substr(0, $maxChars);
			
			var fim:int = $str.lastIndexOf(' ');
			
			$str = $str.substr(0, fim);
			
			return $str
		}
		
		/**
		 * Retorna segundos convertidos para o formato hh:mm:ss
		 * @param	$segundos
		 */
		public static function segundosToString($segundos:Number, $cortaExcesso:Boolean=false):String{
			var d1:Date = new Date(0, 0, 0, 0 , 0 , $segundos);
			
			if ($cortaExcesso==false) {
				return d1.toTimeString().split(' ')[0];
			} else {
				var str:String = d1.toTimeString().split(' ')[0];
				
				if (str.indexOf("00:") == 0) str = str.substr(3);
				
				return str;
			}
			
		}
		
		/**
		  * This function will pad the left or right side of any variable passed in
		  * elem [AS object]
		  * finalLength: Number
		  * dir: String
		  *
		  * return String
		  */
		public static function padValue(elem:*, padChar:String, finalLength:Number, dir:String):String{
			
			//make sure the direction is in lowercase
			dir = dir.toLowerCase();
			
			//store the elem length
			var elemLen:int = elem.toString().length;
			
			//check the length for escape clause
			if(elemLen == finalLength)
			{
				return elem;
			}
			
			//pad the value
			switch(dir)
			{
				default:
				case 'l':
				return padValue(padChar + elem, padChar, finalLength, dir);
				break;
				case 'r':
				return padValue(elem + padChar, padChar, finalLength, dir);
				break;
			}
		}
		
		public static function htmlEncode(str:String):String {
			return XML( new XMLNode( XMLNodeType.TEXT_NODE, str ) ).toXMLString();
		}
		
		public static function htmlDecode(str:String):String {
			return new XMLDocument(str).firstChild.nodeValue;
		}
		
		
		private static var sdiakA:Array
		private static var bdiakA:Array
		private static function __initDecomposeUnicode():void
		{
			if (sdiakA != null) return // inicializa só uma vez
			
			sdiakA = [];
			bdiakA = [];
			
			//var sdiak:String = "áäčďéěíĺľňóôöŕšťúůüýřžÁÄČĎÉĚÍĹĽŇÓÔÖŔŠŤÚŮÜÝŘŽ";
			//var bdiak:String = "aacdeeillnooorstuuuyrzAACDEEILLNOOORSTUUUYRZ";
			
			var sdiak:String = "áàâãéêíñóôõúüçÁÄÂÀÃÉÊÉÍÑÓÕÔÚÜÇ";
			var bdiak:String = "aaaaeeinooouucAAAAAEEEINOOOUUC";
			
			
			for (var i:int=0;i<sdiak.length;i++) sdiakA.push(new RegExp(sdiak.charAt(i), "g"))
			for (i=0;i<sdiak.length;i++) bdiakA.push(bdiak.charAt(i))
		}
		
		public static function decomposeUnicode(string:String):String
		{
			__initDecomposeUnicode();
			
			for (var i:int = 0; i < sdiakA.length; i++)
			string = string.replace(sdiakA[i], bdiakA[i]);
			
			return (string)
		}
	}	
}