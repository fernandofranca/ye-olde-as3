package  
{
	import flash.display.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class DrawUtils
	{
		
		public static function drawArc(t:Sprite, sx:Number, sy:Number, radius:Number, arc:Number, startAngle:Number=0):void
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			// Move the pen
			t.graphics.moveTo(sx, sy);
			
			// No need to draw more than 360
			if (Math.abs(arc) > 360) 
			{
				arc = 360;
			}
			
			numOfSegs = Math.ceil(Math.abs(arc) / 45);
			segAngle = arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (startAngle / 180) * Math.PI;
			
			// Calculate the start point
			ax = sx - Math.cos(angle) * radius;
			ay = sy - Math.sin(angle) * radius;
			
			for(var i:int=0; i<numOfSegs; i++) 
			{
				// Increment the angle
				angle += segAngle;
				
				// The angle halfway between the last and the new
				angleMid = angle - (segAngle / 2);
				
				// Calculate the end point
				bx = ax + Math.cos(angle) * radius;
				by = ay + Math.sin(angle) * radius;
				
				// Calculate the control point
				cx = ax + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
				cy = ay + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
				
				// Draw out the segment
				t.graphics.curveTo(cx, cy, bx, by);
			}
		}
		
		public static function drawWedge(t:Sprite, sx:Number, sy:Number, radius:Number, arc:Number, startAngle:Number=0):void 
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			// Move the pen
			t.graphics.moveTo(sx, sy);
			
			// No need to draw more than 360
			if (Math.abs(arc) > 360) 
			{
					arc = 360;
			}
			
			numOfSegs = Math.ceil(Math.abs(arc) / 45);
			segAngle = arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (startAngle / 180) * Math.PI;
			
			// Calculate the start point
			ax = sx + Math.cos(angle) * radius;
			ay = sy + Math.sin(-angle) * radius;
			
			// Draw the first line
			t.graphics.lineTo(ax, ay);
			
			for (var i:int=0; i<numOfSegs; i++) 
			{
					angle += segAngle;
					angleMid = angle - (segAngle / 2);
					bx = sx + Math.cos(angle) * radius;
					by = sy + Math.sin(angle) * radius;
					cx = sx + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
					cy = sy + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
					t.graphics.curveTo(cx, cy, bx, by);
			}
			
			// Close the wedge
			t.graphics.lineTo(sx, sy);
		}
		
		
		
		/**
		 * Desenha um retangulo rotacionado, calculando a posicao de cada vertice
		 * @param	target
		 * @param	origin	Top left
		 * @param	width
		 * @param	height
		 * @param	rotation			
		 */
		public static function drawRectangleWithRotation(target:Sprite, origin:Point, width:Number, height:Number, rotation:Number):void 
		{
			var pTL:Point = origin
			var pTR:Point = MathUtils.getPointWithRotation(pTL, width, 90 + rotation);
			var pBR:Point = MathUtils.getPointWithRotation(pTR, height, 180 + rotation)
			var pBL:Point = MathUtils.getPointWithRotation(pBR, width, 270 + rotation);
			
			//target.graphics.lineStyle(1, 0xff0000, 1);
			target.graphics.moveTo(origin.x, origin.y);
			target.graphics.lineTo(pTR.x, pTR.y);
			target.graphics.lineTo(pBR.x, pBR.y);
			target.graphics.lineTo(pBL.x, pBL.y);
			target.graphics.lineTo(origin.x, origin.y);
		}
		
		/**
		 * Desenha um arco usando retangulos
		 * @param	target
		 * @param	origin			Top left
		 * @param	radius			Raio do arco
		 * @param	arc					Numero de graus a desenhar
		 * @param	startAngle	Angulo do inicio (0 - 12h, 90 - 3h)
		 * @param	steps				Numero de retangulos a usar
		 * @param	thickness		espessura de cada retangulo
		 */
		public static function drawArcWithRects(target:Sprite, origin:Point, radius:Number, arc:Number, startAngle:Number=0, steps:int = 5, thickness:Number=4):void
		{
			for (var i:int = 0; i < steps; i++) 
			{
				var ptOrigin:Point = MathUtils.getPointWithRotation(origin, radius, startAngle + (arc / steps * i) );
				var ptEnd:Point = MathUtils.getPointWithRotation(origin, radius, startAngle + (arc / steps * (i + 1)) );
				drawLine(target, ptOrigin, ptEnd, thickness);
			}
		}
		
		public static function drawLine(target:Sprite, origin:Point, end:Point, thickness:Number = 20):void 
		{
			if (origin.equals(end)) return;
			
			var graphics:Graphics = target.graphics;
			
			var fullVect:Point = end.subtract(origin);
			var halfWidth:Number = thickness / 2; 
			
			var originNormalized:Point = new Point(fullVect.y,-fullVect.x);
			originNormalized.normalize(thickness / 2);
			
			var start1:Point = origin.add(originNormalized);
			var start2:Point = origin.subtract(originNormalized);
			
			var end1:Point = end.add(originNormalized);
			var end2:Point = end.subtract(originNormalized);
			
			graphics.moveTo(start1.x, start1.y);
			
			graphics.lineTo(end1.x, end1.y);
			graphics.lineTo(end2.x, end2.y);
			graphics.lineTo(start2.x, start2.y);
			graphics.lineTo(start1.x, start1.y);
			
		}
	}
}