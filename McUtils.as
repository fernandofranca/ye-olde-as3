package {
	import flash.display.*;
	import flash.events.*
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	public class McUtils  {
		
		public static function playTo(mc:MovieClip, frameDestino:Number):void {
			mc.removeEventListener(Event.ENTER_FRAME, __playToLoop, false);
			mc.__frameDestino = frameDestino;
			mc.addEventListener(Event.ENTER_FRAME, __playToLoop, false, 0, true);
		}
		
		private static function __playToLoop(e:Event):void {
			var mc:MovieClip = MovieClip(e.target);
			
			if (mc.currentFrame>mc.__frameDestino) {
					mc.prevFrame();
				} else if (mc.currentFrame<mc.__frameDestino) {
					mc.nextFrame();
				} else if (mc.currentFrame==mc.__frameDestino) {
					mc.__frameDestino=null;
					mc.removeEventListener(Event.ENTER_FRAME, __playToLoop, false);
			}
		}
		
		/* retorna array com elementos filhos*/
		public static function getChilds($mc:DisplayObjectContainer):Array {
			var mcsArr:Array = []
			for (var i:int = 0; i < $mc.numChildren; i++) {
				mcsArr.push($mc.getChildAt(i));
			}
			return mcsArr;
		}
		
		/**
		 * Remove todos elementos dentro deste container
		 * @param	$mc
		 */
		public static function removeChilds($mc:DisplayObjectContainer):void {
			while ($mc.numChildren>0) {
				$mc.removeChildAt(0)
			}
		}
		
		/**
		 * Remove este elemento do seu parent
		 * @param	$mc
		 */
		public static function removeChild($mc:*):DisplayObject {
			var tgt:DisplayObjectContainer = DisplayObjectContainer($mc);
			var parent:DisplayObjectContainer = DisplayObjectContainer(tgt.parent);
			return parent.removeChild(tgt);
		}
		
		public static function distribuiHorizontal($mcsArray:Array, inc:Number=0):void {
			var mcAnterior:DisplayObject
			
			for each(var mc:DisplayObject in $mcsArray) {
				
				if (mcAnterior) mc.x = mcAnterior.x + mcAnterior.width + inc;
				
				mcAnterior = mc;
			}
		}
		
		public static function distribuiVertical($mcsArray:Array, inc:Number=0):void {
			var mcAnterior:DisplayObject
			
			for each(var mc:DisplayObject in $mcsArray) {
				
				if (mcAnterior) mc.y = mcAnterior.y + mcAnterior.height + inc;
				
				mcAnterior = mc;
			}
		}
	
		public static function distribuiEmColunas (mc:DisplayObjectContainer, nSerie:Number, colunas:Number, intervaloW:Number, intervaloH:Number):void {
			//w = largura ou intervalo
			//h = altura ou intervalo
			//nSerie = numero de serie
				
			var linhaAtual:Number = Math.floor((nSerie/colunas))
			var __y:Number = linhaAtual * intervaloH;
			
			var colunaAtual:Number = nSerie-(linhaAtual * colunas);
			var __x:Number = colunaAtual  * intervaloW
			
			mc.x = __x;
			mc.y = __y;
		}
		
		/**
		 * Distribui em linhas de altura fixa
		 */
		public static function distribuiEmLinhas (mc:DisplayObjectContainer, nSerie:Number, linhas:Number, intervaloW:Number, intervaloH:Number):void {
			//w = largura ou intervalo
			//h = altura ou intervalo
			//nSerie = numero de serie
			
			var colunaAtual:Number = Math.floor((nSerie/linhas))
			var __x:Number = colunaAtual * intervaloW;
			
			var linhaAtual:Number = nSerie-(colunaAtual * linhas);
			var __y:Number = linhaAtual  * intervaloH;
			
			mc.x = __x;
			mc.y = __y;
		}
		
		/**
		 * Distribui em linhas de altura variavel
		 * @param	$arrMcs			Array com os itens as serem distribuidos
		 * @param	$intervalo		Intervalo vertical
		 * @param	$alturaLimite	valor onde começa a quebra de linhas
		 * @param	$larguraColuna	Largura fixa da coluna
		 */
		public static function distribuiFlowVertical($arrMcs:Array, $intervalo:Number, $alturaLimite:Number, $larguraColuna:Number):void 
		{
			var nx:Number = 0;
			var ny:Number = 0;
			
			var mcAtual:DisplayObjectContainer
			
			for (var i:int = 0; i < $arrMcs.length; i++) 
			{
				mcAtual = $arrMcs[i] as DisplayObjectContainer
				
				if (ny+$intervalo+mcAtual.height>$alturaLimite) 
				{
					ny = 0;
					nx = nx + $larguraColuna;
				} 
				
				mcAtual.y = ny;
				mcAtual.x = nx;
				
				ny = mcAtual.y + mcAtual.height + $intervalo
			}
		}
		
		public static function gotoAndStop( mc:MovieClip, frame:*, completeFunction:Function, params:Array = null ):void {
			mc.addEventListener( Event.RENDER, __frameComplete );
			mc.gotoAndStop( frame );
			mc.gotoParams = params;
			mc.gotoCallFunction = completeFunction;
			//forces the render function to fire
			mc.stage.invalidate();
		}
		
		private static function __frameComplete( e:Event ):void {
			e.target.removeEventListener( Event.RENDER, __frameComplete );
			if ( e.target.gotoParams ) {
				e.target.gotoCallFunction.apply( null, e.target.gotoParams );
				e.target.gotoParams = null;
			} else {
				e.target.gotoCallFunction.call();
			}
			e.target.gotoCallFunction = null;
		}
		
		public static function fitVertical(mc:DisplayObject, h:Number):void {
			mc.height = h;
			mc.scaleX = mc.scaleY;
			mc.width = Math.round(mc.width);
		}
		
		public static function fitHorizontal(mc:DisplayObject, w:Number):void {
			mc.width = w;
			mc.scaleY = mc.scaleX;
			mc.height = Math.round(mc.height);
		}
		
		/*
		 * Fit "sangrado"
		 * */
		public static function fit($mc:DisplayObject, w:Number, h:Number, $bleed:Boolean = true ):void 
		{
			if ($bleed == false)
			{
				__fitNoBleed($mc, w, h);
				return
			}
			var propDestino:Number = w / h;
			var propOrigem:Number = $mc.width / $mc.height;
			
			if (propDestino > 1) { //proporcao horizontal
				if (propDestino>propOrigem) {
					fitHorizontal($mc, w);
				} else {
					fitVertical($mc, h);
				}
			} else if (propDestino<1) { //proporcao vertical
				if (propDestino>propOrigem) {
					fitHorizontal($mc, w);
				} else {
					fitVertical($mc, h);
				}
			} else if (propDestino==1) {
				if (propOrigem>propDestino) {
					fitVertical($mc, h);
				} else {
					fitHorizontal($mc, w);
				}
			}
		}
		
		private static function __fitNoBleed($mc:DisplayObject, w:Number, h:Number):void 
		{
			var propDestino:Number = w / h;
			var propOrigem:Number = $mc.width / $mc.height;
			
			if (propDestino > 1) { //proporcao horizontal
				if (propDestino>propOrigem) {
					fitVertical($mc, h);
				} else {
					fitHorizontal($mc, w);
				}
			} else if (propDestino<1) { //proporcao vertical
				if (propDestino>propOrigem) {
					fitVertical($mc, h);
				} else {
					fitHorizontal($mc, w);
				}
			} else if (propDestino==1) {
				if (propOrigem>propDestino) {
					fitHorizontal($mc, w);
				} else {
					fitVertical($mc, h);
				}
			}
		}
		
		
		/* global para local */
		/* converte o xDestino(relativo ao Stage) para a coordenada local do mc */
		public static function setGlobalX (mc:DisplayObjectContainer, xDestino:Number):Number {
			var pontoDestino:Point = new Point(xDestino, 0);
			
			var pontoConvertido:Point = mc.parent.globalToLocal(pontoDestino);
			
			mc.x = pontoConvertido.x;
			
			return (pontoConvertido.x);
		}
		public static function setGlobalY (mc:DisplayObjectContainer, yDestino:Number):Number {
			var pontoDestino:Point = new Point(0,yDestino);
			
			var pontoConvertido:Point = mc.parent.globalToLocal(pontoDestino);
			
			mc.y = pontoConvertido.y;
			
			return (pontoConvertido.y);
		}
		
		/* retorna a coordenada global do mc */
		public static function getGlobalX(mc:DisplayObjectContainer):Number {
			var npt:Point = mc.parent.localToGlobal(new Point(mc.x, mc.y));
			return npt.x;
		}
		public static function getGlobalY(mc:DisplayObjectContainer):Number {
			var npt:Point = mc.parent.localToGlobal(new Point(mc.x, mc.y));
			return npt.y;
		}
		
		
		// FALTA CONVERTER PARA COOORDENADAS GLOBAIS
		public static function getRight($mc:DisplayObject):Number {
			if ($mc is Stage) {
				return Stage($mc).stageWidth;
			} else {
				return $mc.x + $mc.width;
			}
		}
		
		public static function getLeft($mc:DisplayObject):Number { return $mc.x; }
		
		public static function getTop($mc:DisplayObject):Number { return $mc.y; }
		
		public static function getBottom($mc:DisplayObject):Number {
			if ($mc is Stage) {
				return Stage($mc).stageHeight
			} else {
				return $mc.y + $mc.height;
			}
		}
		
		public static function setRight($mc:DisplayObject, value:Number):void {
			$mc.x = value - $mc.width;
		}
		
		public static function setBottom($mc:DisplayObject, value:Number):void {
			$mc.y = value - $mc.height;
		}
		
		/* alinha top left, sem escala, sem focusRect */
		public static function stageSetUp($stage:Stage):void {
			$stage.align = StageAlign.TOP_LEFT;
			$stage.scaleMode = StageScaleMode.NO_SCALE;
			$stage.stageFocusRect = false;
		}
		
		public static function newRectMc($w:Number=20, $h:Number=20):MovieClip{
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0x000000);
			shp.graphics.drawRect(0, 0, $w, $h)
			shp.graphics.endFill();
			
			var mcTmp:MovieClip = new MovieClip();
			mcTmp.addChild(shp);
			
			return mcTmp;
		}
		
		public static function drawRect($mc:Sprite, $w:Number=20, $h:Number=20, $color:Number=0xff0000):void {
			var gfx:Graphics = $mc.graphics;
			gfx.clear();
			gfx.beginFill($color, 1);
			gfx.drawRect(0, 0, $w, $h);
			gfx.endFill()
		}
		
		public static function drawRectShape($w:Number = 20, $h:Number = 20, $color:Number = 0xff0000):Shape {
			var shape:Shape = new Shape();
			var gfx:Graphics = shape.graphics;
			
			gfx.beginFill($color, 1);
			gfx.drawRect(0, 0, $w, $h);
			gfx.endFill();
			
			return shape;
		}
		
		public static function sendToTop($mc:DisplayObjectContainer):void{
			var container:DisplayObjectContainer = DisplayObjectContainer($mc.parent);
			container.addChildAt($mc, container.numChildren);
		}
		
		public static function scaleByCenter($do:DisplayObject, $scale:Number):void 
		{
			var cx:Number = $do.x + $do.width * 0.5;
			var cy:Number = $do.y + $do.height * 0.5;
			
			$do.scaleX = $do.scaleY = $scale;
			
			$do.x = cx - $do.width * 0.5;
			$do.y = cy - $do.height * 0.5;
		}
		
		/**
		 * Elimina o efeito borrado apos uma rotação 3d
		 */
		public static function remove3DBlur($do:DisplayObject):void 
		{
			$do.transform.matrix = new Matrix($do.scaleX, 0, 0, $do.scaleY, $do.x, $do.y);
		}
		
		/**
		 * Não elimina, mas melhora o blur de objetos que serão rotacionados em 3d
		 */
		public static function improveBlur3D($do:DisplayObject):void 
		{
			var xFactor:Number = $do.width / ($do.width + 1);
			var yFactor:Number = $do.height / ($do.height + 1);
			
			$do.scaleX = xFactor;
			$do.scaleY = yFactor;
			$do['z']=0; // alterei porque a ide do cs3 se estranha com a propriedade "z"
		}
		
		public static function setBlendModeLayer($do:DisplayObject):void 
		{
			$do.blendMode = BlendMode.LAYER;
		}
		
		
		/**
		 * Troca o z-index das instancias, copia x e y e remove o antigo
		 * @param	sprOld
		 * @param	sprNew
		 */
		public static function swap(sprOld:DisplayObject, sprNew:DisplayObject):void
		{
			var __parent:DisplayObjectContainer = sprOld.parent;
			
			if (__parent==null) return
			
			// adiciona ao mesmo parent se ainda não for
			if (sprNew.parent != __parent) __parent.addChild(sprNew);
			
			sprNew.x = sprOld.x;
			sprNew.y = sprOld.y;
			
			__parent.swapChildren(sprOld, sprNew);
			
			__parent.removeChild(sprOld); //TODO REVER porque nao esta jogando na mesma posicao XY
		}
	}
}