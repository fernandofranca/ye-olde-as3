/**
 * 18/8/2009 11:03 
 * Mudança nos addeventlistener. Simplemente nao funcionavam com useCapture.
 * Adicionei um handler para remover no evento removedFromStage
 * 
 * 26/11/2009 16:59
 * Mudança para aceitar o stage como ponto de entrada
 */
package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	import gs.TweenLite
	
	
	public class Modal {
		private var __root:DisplayObjectContainer
		private var __stage:Stage
		private var __mcModal:Sprite
			private var __mcConteudoContainer:Sprite
			private var __mcBg:Sprite
		private var __bgColor:Number
		private var __bgAlpha:Number
		
		public var centraliza:Boolean = true;
		public var serial:Number
		public var conteudo:DisplayObject //conteudo do modal
		public var offsetX:Number = 0
		public var offsetY:Number = 0
		
		/**
		 * Fecha ao detectar um clique no Bg
		 */
		public var closeOnBgClick:Boolean = true;
		
		
		public function Modal ($root:DisplayObjectContainer, $bgColor:Number=0x000000, $bgAlpha:Number=0.5) {
			
			serial = getTimer();
			
			//__root = Sprite($root);
			
			__root = $root;
			
			if ($root is Stage) 
			{
				__stage = $root as Stage;
			} else 
			{
				__stage = __root.stage;
			}
			
			__bgColor = $bgColor;
			__bgAlpha = $bgAlpha;
			
			
			__mcModal = new MovieClip(); //contem todos os outros mcs
			__mcModal.name = '__mcModal';
			__mcModal.blendMode = BlendMode.LAYER;
			__root.addChild(__mcModal); //adiciona ao root
			
				__mcBg = new Sprite(); //adiciona mc background
				__mcModal.addChild(__mcBg);
				__desenhaBg();
				
				__mcConteudoContainer = new Sprite();
				__mcModal.addChild(__mcConteudoContainer);
				
				
			__stage.addEventListener(Event.RESIZE, __onResize);
			__stage.addEventListener(Event.REMOVED_FROM_STAGE, __onRemoved);
			__mcBg.addEventListener(MouseEvent.CLICK, __onBgClick);
			
		}
		
		/* Remove TUDO */
		public function remove():void {  //REVER
			
			// remove os listeners
			__stage.removeEventListener(Event.RESIZE, __onResize);
			__stage.removeEventListener(Event.REMOVED_FROM_STAGE, __onRemoved);
			__mcBg.removeEventListener(MouseEvent.CLICK, __onBgClick);
			
			// remove todo conteudo
			removeChild();
			
			// remove do stage
			__root.removeChild(__mcModal);
		}
		
		/* Adiciona conteudo */
		public function addChild($mc:DisplayObject):DisplayObject {
			removeChild(); //remove anterior
			var dObj:DisplayObject = __mcConteudoContainer.addChildAt($mc, 0); //adiciona mc/sprite
			fit(); //centraliza tudo
			conteudo = dObj;
			return dObj;
		}
		
		/**
		 * Remove todo conteudo
		 */
		public function removeChild():void {
			try {
				__mcConteudoContainer.removeChildAt(0);
				conteudo = null;
			} catch (e:Error){ }
		}
		
		/* Alinha tudo */
		public function fit():void {
			
			__desenhaBg(); //redesenha bg
			
			// centraliza todos elementos;
			if (centraliza == true) {
				__centralizaConteudo(__mcConteudoContainer);
			}
		}
		
		public function fadeIn($tempo:Number = 0.5, $delay:Number = 0):void {
			__mcModal.alpha = 0;
			visible = true;
			TweenLite.to(__mcModal, $tempo, { delay:$delay, alpha:1 } );
		}
		
		public function fadeOut():void {
			TweenLite.to(__mcModal, 0.5, { alpha:0, onComplete:__fadeOutComplete } );
		}
		
		private function __fadeOutComplete():void{
			visible = false; //deixa invisivel 
		}
		
		private function __onResize (e:Event):void { //handler do resize do stage
			fit();
		}
		
		private function __onBgClick(e:MouseEvent):void { // handler clique no fundo, fecha tudo
			if (closeOnBgClick==true) {
				remove();
			}
		}
		
		private function __onRemoved(e:Event):void {
			remove();
		}
		
		private function __centralizaConteudo(mc:DisplayObjectContainer):void {
			mc = Sprite(mc);
			
			// compensa algum deslocamento fora do top/left - casos onde o centro do elemento alinha com 0,0
			var incX:Number = (mc.getBounds(__mcConteudoContainer).left) * -1; 
			var incY:Number = (mc.getBounds(__mcConteudoContainer).top) * -1;
			
			mc.x = int((centerX - mc.width/2)+offsetX + incX);
			mc.y = int((centerY - mc.height/2)+offsetY + incY);
		}
		
		private function __desenhaBg():void {
			var g:Graphics = __mcBg.graphics;
			g.clear();
			g.beginFill(__bgColor, __bgAlpha);
			g.moveTo(0, 0);
			g.lineTo(__stage.stageWidth, 0)
			g.lineTo(__stage.stageWidth, __stage.stageHeight)
			g.lineTo(0, __stage.stageHeight)
			g.lineTo(0, 0)
			g.endFill();
		}
		
		/* getters / setters */
		
		public function get centerX():Number { return __stage.stageWidth/2; }
		public function get centerY():Number { return __stage.stageHeight/2; }
		
		public function get visible():Boolean { 
			return __mcModal.visible;
		}
		
		public function set visible(value:Boolean):void {
			__mcModal.visible = value;
		}
	}
}