/**
 * ex:
 * alinha centro do Elemento com o centro do stage
 * AlignUtil.setPosition(r2, 'c' , AlignUtil.getPosition(stage, 'c'), 0, 0);
 */
package  
{
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class AlignUtils
	{
		
		public static function getPosition($do:DisplayObject, $position:String='TL'):Point
		{
			var rect:Rectangle
			var point:Point
			
			if ($do is Stage) 
			{
				rect = new Rectangle(0, 0, Stage($do ).stageWidth, Stage($do ).stageHeight);
			} else 
			{
				rect = $do.getBounds($do.parent );
			}
			
			$position = $position.toUpperCase();
			switch ($position) 
			{
				case 'TL':
					point = new Point(rect.x, rect.y);
				break
				case 'TR':
					point = new Point(rect.x+rect.width, rect.y);
				break
				case 'TC':
					point = new Point(rect.x+rect.width/2, rect.y);
				break
				case 'T':
					point = new Point(rect.x+rect.width/2, rect.y);
				break
				case 'BL':
					point = new Point(rect.x, rect.y + rect.height);
				break
				case 'BR':
					point = new Point(rect.x+rect.width, rect.y + rect.height);
				break
				case 'BC':
					point = new Point(rect.x+rect.width/2, rect.y + rect.height);
				break
				case 'B':
					point = new Point(rect.x+rect.width/2, rect.y + rect.height);
				break
				case 'CL':
					point = new Point(rect.x, rect.y + rect.height/2);
				break
				case 'L':
					point = new Point(rect.x, rect.y + rect.height/2);
				break
				case 'CR':
					point = new Point(rect.x+rect.width, rect.y + rect.height/2);
				break
				case 'R':
					point = new Point(rect.x+rect.width, rect.y + rect.height/2);
				break
				case 'C':
					point = new Point(rect.x+rect.width/2, rect.y + rect.height/2);
				break
			}
			
			return point
		}
		
		public static function setPosition($do:DisplayObject, $position:String, $point:Point, $incX:Number = 0, $incY:Number = 0):void
		{
			var nx:Number, ny:Number
			
			$position = $position.toUpperCase();
			switch ($position) 
			{
				case 'TL':
					nx = $point.x;
					ny = $point.y;
				break
				case 'TR':
					nx = $point.x-$do.width;
					ny = $point.y;
				break
				case 'TC':
					nx = $point.x-$do.width/2;
					ny = $point.y;
				break
				case 'T':
					nx = $point.x-$do.width/2;
					ny = $point.y;
				break
				case 'BL':
					nx = $point.x;
					ny = $point.y-$do.height;
				break
				case 'BR':
					nx = $point.x-$do.width;
					ny = $point.y-$do.height;
				break
				case 'BC':
					nx = $point.x-$do.width/2;
					ny = $point.y-$do.height;
				break
				case 'B':
					nx = $point.x-$do.width/2;
					ny = $point.y-$do.height;
				break
				case 'CL':
					nx = $point.x;
					ny = $point.y-$do.height/2;
				break
				case 'L':
					nx = $point.x;
					ny = $point.y-$do.height/2;
				break
				case 'CR':
					nx = $point.x-$do.width;
					ny = $point.y-$do.height/2;
				break
				case 'R':
					nx = $point.x-$do.width;
					ny = $point.y-$do.height/2;
				break
				case 'C':
					nx = $point.x-$do.width/2;
					ny = $point.y-$do.height/2;
				break
			}
			
			nx += $incX;
			ny += $incY;
			
			$do.x = nx;
			$do.y = ny;
			
		}
		
		public static function alignCenter($target:DisplayObject, $reference:DisplayObject):void 
		{
			AlignUtils.setPosition($target, "C", AlignUtils.getPosition($reference, "C"));
		}
		
	}

}