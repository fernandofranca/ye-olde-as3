package  
{
	import flash.text.*;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class TextFieldUtils
	{
		
		public static function elastic($tf:TextField, $wordWrap:Boolean=true):void 
		{
			$tf.wordWrap = $wordWrap;
			$tf.autoSize = 'left';
		}
		
		public static function setLetterSpacing($tf:TextField, $value:Number):void 
		{
			var fmt:TextFormat = $tf.defaultTextFormat
			
			fmt.letterSpacing = $value;
			$tf.defaultTextFormat = fmt;
		}
		
		public static function limit(tf:TextField, $textoNovo:String, $strFinal:String='...'):String
		{
			var oldText:String = tf.text;
			
			tf.text = $textoNovo;
			
			var cond:Boolean = tf.textWidth > tf.width; // estourou?
			
			var arrWords:Array = $textoNovo.split(' ');
			
			// não precisa limitar
			if (cond==false || arrWords.length < 2) 
			{
				tf.text = oldText
				return $textoNovo
			} 
			
			// limita
			tf.text = '';
			
			var i:int = 1;
			var txtTest:String 
			
			while (tf.textWidth < tf.width) 
			{
				txtTest = arrWords.slice(0, i).join(' ') + $strFinal;
				tf.text = txtTest;
				i++;
			}
			
			txtTest = arrWords.slice(0, i-2).join(' ') + $strFinal;
			tf.text = oldText;
			
			return txtTest
		}
		
		public static function focus(tf:TextField):void 
		{
			if (tf.stage) tf.stage.focus = tf;
		}
		
		public static function blur(tf:TextField):void 
		{
			if (tf.stage) tf.stage.focus = null;
		}
		
	}

}