package com.withlasers.net
{
	public class Social
	{
		public static const DELICIOUS:String = 'DELICIOUS'
		public static const DIGG:String = 'DIGG'
		public static const EMAIL:String = 'EMAIL'
		public static const FACEBOOK:String = 'FACEBOOK'
		public static const GOOGLE:String = 'GOOGLE'
		public static const LIVE:String = 'LIVE'
		public static const MYSPACE:String = 'MYSPACE'
		public static const ORKUT:String = 'ORKUT'
		public static const TWITTER:String = 'TWITTER'
		
		/**
		 * 
		 * @param	$rede
		 * @param	$url
		 * @param	$titulo
		 * @param	$options	"Special features" {orkutThumbUrl}
		 * @return
		 */
		public static function shareTo($rede:String, $url:String, $titulo:String, $options:*=null):String
		{
			var pageTitle:String = encodeURI($titulo);
			var pathAtual:String = encodeURIComponent($url);
			var url:String
			
			switch ($rede) {
				case DELICIOUS:
					url = 'http://del.icio.us/post?url=@URL@&title=@TITULO@'
				break
				case DIGG:
					url = 'http://digg.com/submit?phase=2&url=@URL@&title=@TITULO@'
				break
				case EMAIL:
					url = 'mailto:?subject=@TITULO@&body=@URL@'
				break
				case FACEBOOK:
					url = 'http://www.facebook.com/share.php?u=@URL@&t=@TITULO@'
				break
				case GOOGLE:
					url = 'http://www.google.com/bookmarks/mark?op=edit&bkmk=@URL@&title=@TITULO@'
				break
				case LIVE:
					url = 'https://favorites.live.com/quickadd.aspx?marklet=1&url=@URL@&title=@TITULO@'
				break
				case MYSPACE:
					url = 'http://www.myspace.com/Modules/PostTo/Pages/?u=@URL@&t=@TITULO@'
				break
				case ORKUT:
					url = 'http://promote.orkut.com/preview?nt=orkut.com&tt=@TITULO@&du=@URL@&cn=@TITULO@%20-%20@URL@&tn=@ORKUTTHUMBURL@'
				break
				case TWITTER:
					url = 'http://twitter.com/share?text=@TITULO@&url=@URL@'
				break
			}
			
			if (url) {
				url = StringUtils.replace(url, '@URL@', pathAtual);
				url = StringUtils.replace(url, '@TITULO@', pageTitle);
			}
			
			if ($options)
			{
				try {
					url = StringUtils.replace(url, '@ORKUTTHUMBURL@', encodeURIComponent($options.orkutThumbUrl));
				} catch (e:Error){}
			}
			
			return url
		}
		
		// a imagem provavelmente vira um objeto opcional (special features)
		/*
		 * http://promote.orkut.com/preview?nt=orkut.com&tt=Something%20Interesting&du=http://example.com&cn=An%20interesting%20page%20to%20visit
		 * 
			nt	Must be set to "orkut.com". 							Reserved for future use. Required
			du	URL of content being shared.							Required
			tt	Title of the shared item, should be plain text.			Required
			cn	Content to be shared.									Optional
			uc	User comment on shared item.							Optional
			tn	A thumbnail image to be included in the shared item.		Optional
			*/
	}
}