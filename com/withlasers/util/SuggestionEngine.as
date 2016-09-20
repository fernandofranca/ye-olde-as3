package com.withlasers.util 
{
	import com.withlasers.util.ISuggestionEngine;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class SuggestionEngine implements ISuggestionEngine
	{
		protected var __model:Array
		protected var __modelNormalizado:Array
		
		protected var strComAcentos:String = "ÁÀÃÂàáãâÈÉÊèéêÌÍÎìíîÒÓÕÔòóõôÙÚÛÜùúûüÇç";
		protected var strSemAcentos:String = "AAAAaaaaEEEeeeIIIiiiOOOOooooUUUUuuuuCc";
		
		public function SuggestionEngine() 
		{
			
		}
		
		/* INTERFACE com.withlasers.util.IAutoComplete */
		
		public function get model():Array
		{
			return __model
		}
		
		public function set model($modelArr:Array):void
		{
			__model = $modelArr;
			__modelNormalizado = __normalizaModel(__model);
		}
		
		public function getSuggestion($strInput:String):Array
		{
			$strInput = __normalizaEntrada($strInput);
			
			
			
			return __busca($strInput);
		}
		
		private function __busca($str:String):Array
		{
			var arrRes:Array = []
			
			var i:int = 0
			for each(var s:String in __modelNormalizado) {
				if (s.indexOf($str)>-1) 
				{
					arrRes.push(model[i]);
				}
				i++
			}
			
			return arrRes
		}
		
		private function __normalizaEntrada($str:String):String
		{
			$str = $str.toLowerCase();
			
			// acentos
			for (var i:int = 0; i < strComAcentos.length; i++) 
			{
				$str = StringUtils.replace($str, strComAcentos.substr(i, 1), strSemAcentos.substr(i, 1))
			}
			
			$str = StringUtils.replace($str, '  ', ' ');
			
			return $str;
		}
		
		private function __normalizaModel($arrModel:Array):Array
		{
			var arrNovo:Array = []
			
			var i:int = 0;
			for each(var s:String in $arrModel) {
				arrNovo[i] = __normalizaEntrada(s)
				i++;
			}
			
			return arrNovo
		}
		
	}

}