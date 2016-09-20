package  
{
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class DateUtils
	{
		
		/**
		 * Formata a data como dd/mm/aaa
		 */
		public static function formataData($d:Date):String 
		{
			var s:String = '';
			s += formataNumeros($d.date, 2) + '/';
			s += formataNumeros($d.month + 1, 2) + '/';
			s += $d.fullYear
			
			return s
		}
		
		/**
		 * Formata hora como mm:mm
		 */
		public static function formataHora($d:Date):String 
		{
			var s:String = '';
			s += formataNumeros($d.hours, 2) + ':';
			s += formataNumeros($d.minutes, 2);
			
			return s
		}
		
		protected static function formataNumeros($n:Number, $casas:int=2):String 
		{
			var s:String
			
			s = String($n);
			
			while (s.length<$casas ) 
			{
				s = '0' + s;
			}
			
			return s
		}
		
		/**
		 * Converte para Unix TimeStamp
		 * @param	date
		 * @return
		 */
		public static function toUnixTimeStamp(date:Date):Number
		{
			var tzo:Number = date.getTimezoneOffset() * 60000;
			
			return Math.floor((date.getTime() - tzo) / 1000);
			
		}
		
	}

}