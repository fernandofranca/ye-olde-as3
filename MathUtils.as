package  {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MathUtils {
		
		public static function angleToRadian($angle:Number):Number{
			return ($angle / 180) * Math.PI;
		}
		
		public static function radianToAngle( $rad:Number ):Number
		{
			return ( 180 / Math.PI ) * $rad;
		}
		
		public static function waveX($angle:Number, $radius:Number):Number{
			var rad:Number = angleToRadian($angle);
			
			return Math.cos(rad) * $radius;
		}
		
		public static function waveY($angle:Number, $radius:Number):Number{
			var rad:Number = angleToRadian($angle);
			
			return Math.sin(rad) * $radius;
		}
		
		
		// width = ( radius / elements ) * 6
		// radius = ( width / 6 ) * total
		//
		// 60 = (300/30) * 6
		
		/** Distribute the points clockwise around the circle. */
		public static const CLOCKWISE:String = "clockwise";
		/** Distribute the points counterclockwise around the circle. */
		public static const COUNTERCLOCKWISE:String = "counterclockwise";
		
		/**
		*	This method accepts arguments based on the size and position of your circle 
		*	along with the amount of points to distribute around the circle, 
		*	what angle to start the first point, which direction to plot the points, 
		*	how much of the circumference to use for the distribution, and which direction
		*	around the circle to plot the points. 
		*	
		*	@param centerX The center x position of the circle to place the points around.
		*	@param centerY The center y position of the circle to place the points around.
		*	@param radi The radius of the circle to distribute the points around.
		*	@param total The total amount of point to distribute around the circle.
		*	@param startAngle [Optional] The starting angle of the first point. This is based on the 0-360 range.
		*	@param arc [Optional] The length of distribution around the circle to evenly distribute the points. This is based on 0-360. 
		*	@param dir [Optional] This determines the direction that the points will distribute around the circle.
		*	@param evenDist [Optional] If set to true, AND if you're arc angle is less than 360, this will evently distribute the points around the circle.<br/>If set to true, the points are visually arranged in this manner POINT-SPACE-POINT-SPACE-POINT,<br/>if set to false, an extra space will be added after the last point: POINT-SPACE-POINT-SPACE-POINT-SPACE
		*	
		* */
		
		public static function makeCirclePoints(centerX:Number, centerY:Number, circleRadius:Number, totalPoints:int, startAngle:Number = 0, arc:int = 360, pointDirection:String = "clockwise", evendistribution:Boolean = true):Array 
		{
			
			var mpi:Number = Math.PI/180;
			var startRadians:Number = startAngle * mpi;
			
			var incrementAngle:Number = arc/totalPoints;
			var incrementRadians:Number = incrementAngle * mpi;
			
			if(arc<360) {
				// this spreads the points out evenly across the arc
				if(evendistribution) {
					incrementAngle = arc/(totalPoints-1);
					incrementRadians = incrementAngle * mpi;
				} else {
					incrementAngle = arc/totalPoints;
					incrementRadians = incrementAngle * mpi;
				}
			}
			
			var pts:Array = [];
			var diameter:Number = circleRadius*2;
			
			while(totalPoints--) {
				var xp:Number = centerX + Math.sin(startRadians) * circleRadius;
				var yp:Number = centerY + Math.cos(startRadians) * circleRadius;
				var pt:Point = new Point(xp, yp);
				pts.push(pt);
				
				if(pointDirection==COUNTERCLOCKWISE) {
					startRadians += incrementRadians;
				} else {
					startRadians -= incrementRadians;
				}
			}
			
			return pts;
		}
		
		public static function simpleEase(obj:*, prop:String, destino:Number, acceleracao:Number=0.1):void 
		{
			if (Number(obj[prop]) == destino) return;
			
			obj[prop] += acceleracao * (destino - Number(obj[prop])); 
		}
		
		static private var vx:Number = 0;
		public static function simpleElastic(obj:*, prop:String, destino:Number, spring:Number=0.1, friction:Number = 0.8):void 
		{
			if (Number(obj[prop]) == destino) return;
			
			var cx:Number = obj[prop];
			
			vx += (destino - cx) * spring; //spring: elastic coefficient
			
			obj[prop] += (vx *= friction); //friction: friction force
			
			//obj[prop] += acceleracao * (destino - Number(obj[prop])); 
		}
		
		/**
		 * Desloca um objeto em relacao a um ponto informado
		 * @param	obj				objeto a ser deslocado
		 * @param	relativePoint	pode ser a posicao do cursor
		 * @param	springLength	distancia a deslocar
		 */
		public static function partialShift(obj:*, relativePoint:Point, springLength:Number = 90):void 
		{	
			var dx:Number = obj.x - relativePoint.x;
			var dy:Number = obj.y - relativePoint.y;
			
			var angle:Number = Math.atan2(dy, dx);
			
			var targetX:Number = relativePoint.x + Math.cos(angle) * springLength;
			var targetY:Number = relativePoint.y + Math.sin(angle) * springLength;
			
			obj.x = targetX;
			obj.y = targetY;
		}
		
		public static function partialShiftAsPoint(objPoint:Point, relativePoint:Point, springLength:Number = 90):Point 
		{
			var dx:Number = objPoint.x - relativePoint.x;
			var dy:Number = objPoint.y - relativePoint.y;
			
			var angle:Number = Math.atan2(dy, dx);
			
			var targetX:Number = relativePoint.x + Math.cos(angle) * springLength;
			var targetY:Number = relativePoint.y + Math.sin(angle) * springLength;
			
			return new Point(targetX, targetY);
		}
		
		/**
		 * Calcula o deslocamento de um ponto em funcao da distacia e rotacao
		 * @param	origin
		 * @param	distance
		 * @param	rotation
		 */
		public static function getPointWithRotation(origin:Point, distance:Number, rotation:Number):Point 
		{
			var radius:Number = distance;
			var startAngle:Number = rotation + 90;
			
			var ang:Number = (startAngle / 180) * Math.PI;
			
			var ax:Number = origin.x - Math.cos(ang) * radius;
			var ay:Number = origin.y - Math.sin(ang) * radius;
			
			return new Point(ax, ay);
		}
		
		/**
		 * Retorna em graus o angulo entre dois pontos
		 * @param	point1
		 * @param	point2
		 * @return
		 */
		public static function angleBetweenPoints(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return radianToAngle(Math.atan2(dx,dy));
		}
		
		public static function getDistanceBetweenCoords(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public static function rotateRelativeToPoint(obj:*, mouseX:Number, mouseY:Number):void 
		{
			var dx:Number = mouseX - obj.x;
			var dy:Number = mouseY - obj.y;
			obj.rotation = Math.atan2(dy, dx) * 180 / Math.PI;
		}
	}
	
}