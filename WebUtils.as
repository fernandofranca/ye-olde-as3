package {
	import flash.external.ExternalInterface;
	import flash.net.*;
	//import org.osflash.signals.Signal;

	public class WebUtils {
		
		public static function noCache():String 
		{
			return Math.round(new Date().time / 1000) as String;
		}
		
		public static function getUrl($url:String, $window:String = '_blank'):void {
			var req:URLRequest = new URLRequest($url);
			
			try{
				navigateToURL(req, $window);
			} catch (e:Error) {
				trace("Navigate to URL failed", e.message);
			}
		}
		
		/**
		 * Retorna uma variavel do Javascript 
		 */
		public static function getJsVar($varNome:String):String {
			
			if (ExternalInterface.available != true) return null
			
			try {
				var s:String = ExternalInterface.call('eval', $varNome);
			} catch (e:Error) { }
			
			return s;
		}
		
		public static function jsPopUp($url:String, $windowName:String, $width:String, $height:String, $resizable:Boolean=false):void 
		{
			var jsStr:String = "window.open('"+$url+"','"+$windowName+"','width="+$width+",height="+$height+",resizable="+$resizable+"');";
			
			jsStr = 'function(){' + jsStr + '}';
			
			if (ExternalInterface.available == true) ExternalInterface.call(jsStr);
		}
		
		
		/**
		 * Retorna o codigo de embed de swf
		 * @param	$swfUrl
		 * @param	$id
		 * @param	$width
		 * @param	$height
		 * @param	$flashVarsStr	"a=1&b=2" Importante: os valores atribuidos devem ser encodados com "encodeURIComponent"
		 * @return
		 */
		public static function embed($swfUrl:String, $id:String, $width:String, $height:String, $flashVarsStr:String):String
		{
			var embedStr:String = '';
			embedStr += '<object id="@ID@" width="@WIDTH@" height="@HEIGHT@" data="@SWFURL@" type="application/x-shockwave-flash">';
			embedStr += '<param name="menu" value="false"/>';
			embedStr += '<param name="scale" value="noScale"/>';
			embedStr += '<param name="movie" value="@SWFURL@"/>';
			embedStr += '<param name="allowFullScreen" value="true"/>';
			embedStr += '<param name="allowscriptaccess" value="always"/>';
			embedStr += '<param name="flashvars" value="@FLASHVARS@"/>';
			embedStr += '<embed name="@ID@" src="@SWFURL@" flashvars="@FLASHVARS@" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="@WIDTH@" height="@HEIGHT@"></embed>';
			embedStr += '</object>';
			
			embedStr = StringUtils.replace(embedStr, '@ID@', $id);
			embedStr = StringUtils.replace(embedStr, '@WIDTH@', $width);
			embedStr = StringUtils.replace(embedStr, '@HEIGHT@', $height);
			embedStr = StringUtils.replace(embedStr, '@SWFURL@', $swfUrl);
			
			if ($flashVarsStr!=null) {
				// troca os caracteres que podem invalidar flashvars
				embedStr = StringUtils.replace(embedStr, '@FLASHVARS@', $flashVarsStr);
			} else {
				embedStr = StringUtils.replace(embedStr, '@FLASHVARS@', '');
			}
			
			return embedStr;
		}
		
		public static function shortenUrl($url:String, $onResult:Function, $onError:Function=null):void 
		{
			//$url = 'http://bit.ly/api?url=' + $url; // bit.ly passou a usar apikey e username
			$url = 'http://migre.me/api.txt?url=' + $url;
			
			var sl:SendAndLoad = new SendAndLoad($url, { }, false, 5000, false);
			sl.onSuccess = function ():void 
			{
				try 
				{
					$onResult(sl.resposta);
				} catch (err:Error)
				{
					trace(err);
				}
			}
			sl.onError = function ():void 
			{
				try 
				{
					$onError(sl.erro);
				} catch (err:Error)
				{
					trace(err);
				}
			}
			sl.send();
		}
		
		/*
		public static function embed($swfUrl:String, $width:String, $height:String, $flashVars:*=null):String {
			//  falta ID e NAME
			var embedStr:String = ''
			embedStr += '<object width="@WIDTH@" height="@HEIGHT@" data="@SWFURL@" type="application/x-shockwave-flash">'
			embedStr += '<param name="menu" value="false"/>'
			embedStr += '<param name="scale" value="noScale"/>'
			embedStr += '<param name="movie" value="@SWFURL@"/>'
			embedStr += '<param name="allowFullScreen" value="true"/>'
			embedStr += '<param name="allowscriptaccess" value="always"/>'
			embedStr += '<param name="flashvars" value="@FLASHVARS@"/>'
			embedStr += '<embed src="@SWFURL@" flashvars="@FLASHVARS@" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="@WIDTH@" height="@HEIGHT@"></embed>'
			embedStr += '</object>';
			
			
			embedStr = StringUtils.replace(embedStr, '@WIDTH@', $width);
			embedStr = StringUtils.replace(embedStr, '@HEIGHT@', $height);
			embedStr = StringUtils.replace(embedStr, '@SWFURL@', $swfUrl);
			
			if ($flashVars!=null) {
				var flashVarsStr:String = ''
				
				if ($flashVars is String) {
					flashVarsStr = $flashVars;
				} else {
					// é um objeto, percorre as propriedade para criar a string
					var fv:Array = []
					for (var name:String in $flashVars) {
						fv.push(name + '=' + $flashVars[name]);
					}
					flashVarsStr = fv.join('&');
				}
				
				// troca os caracteres que podem invalidar flashvars
				flashVarsStr = StringUtils.replace(flashVarsStr, ' ', '_');
				flashVarsStr = StringUtils.replace(flashVarsStr, '"', '_');
				flashVarsStr = StringUtils.replace(flashVarsStr, "'", '_');
				
				embedStr = StringUtils.replace(embedStr, '@FLASHVARS@', flashVarsStr);
			} else {
				embedStr = StringUtils.replace(embedStr, '@FLASHVARS@', '');
			}
			
			embedStr = StringUtils.htmlEncode(embedStr);
			
			return embedStr
		}
		*/
		/*
		public static function shortenUrl($url:String, $callback:Function):Signal 
		{
			$url = 'http://bit.ly/api?url=' + $url;
			
			var req:URLRequest = new URLRequest($url);
			var ldr:URLLoader = new URLLoader(req);
			var signal:Signal = new Signal(String);
			
			ldr.addEventListener(Event.COMPLETE, function (e:Event):void 
			{
				//$callback(ldr.data);
				signal.dispatch(ldr.data);
			});
			ldr.dataFormat = URLLoaderDataFormat.TEXT;
			ldr.load(req);
			
			return signal
		}
		*/
	}
}