package com.withlasers.net 
{
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class BitlyShortener
	{
		public var onResult:Function
		public var onError:Function
		
		protected var sl:SendAndLoad;
		
		public function BitlyShortener($url:String, $user:String, $key:String, $onResult:Function, $onError:Function) 
		{
			onResult = $onResult;
			onError = $onError;
			
			var urlBitly:String = "http://api.bit.ly/v3/shorten?login=@LOGIN@&apiKey=@KEY@&longUrl=@URL@&format=txt";
			
			urlBitly = urlBitly.replace("@LOGIN@", $user);
			urlBitly = urlBitly.replace("@KEY@", $key);
			urlBitly = urlBitly.replace("@URL@", encodeURIComponent($url));
			
			sl = new SendAndLoad(urlBitly, { }, false, 5000, false);
			
			sl.onSuccess = function ():void 
			{
				// remove uma quebra de linha extra que retorna intermitentemente
				var res:String = String(sl.resposta)
				res = res.replace("\n", "");
				res = res.replace("\r", "");
				
				log("ok " + res);
				try 
				{
					onResult(res);
				} catch (err:Error)
				{
					trace("BitlyShortener: onResult" + err);
				}
			}
			
			sl.onError = function ():void 
			{
				log("erro " + sl.erro);
				try 
				{
					onError(sl.erro);
				} catch (err:Error)
				{
					trace("BitlyShortener: onError" + err);
				}
			}
			
			sl.send()
		}
		
		public function cancel():void 
		{
			sl.cancel();
		}
		
	}

}