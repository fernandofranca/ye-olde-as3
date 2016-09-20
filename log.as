package  
{
	import com.withlasers.debug.Tracer;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public function log(...args):void 
	{
		FlashConnect.trace.apply(null, args); 
		//trace.apply(null, args);
	}

}