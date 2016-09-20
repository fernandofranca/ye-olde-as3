package com.withlasers.display {
	import flash.display.*;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize
	
	
	/**
	 * ...
	 * @author fernando@fiberinteractive.com.br
	 */
	public class Marquee {
		private var _limiteW:Number;
		private var _limiteOffset:Number;
		private var _tf:TextField;
		private var _speed:Number;
		private var _incX:int;
		private var _sentido:Number;
		private var _intervalId:Number;
		private var _offset:Number;
		private var _pausaCount:Number;
		private var _pausaLimite:int;
		
		private var _texto:String
		private var _rect:Rectangle;
		
		/**
		 * @param	$largura		Largura visível em pixels
		 * @param	$textfield		Ref Instancia do textfield
		 * @param	$velocidade		Tempo entre cada atualização em milissegundos
		 * @param	$incremento		Incremento entre cada atualização em pixels
		 * @param	$loopsDePausa	Numero de vezes que o loop executará na pausa entre o movimento
		 */
		public function Marquee($largura:Number, $textfield:TextField, $velocidade:Number=200, $incremento:int=2, $loopsDePausa:int=10) {
			
			_limiteW = $largura;
			_limiteOffset = 0;//limite do deslocamento
			_tf = $textfield;
			_speed = $velocidade;
			_incX = $incremento;
			_sentido = -1;
			_intervalId = 0;// id do loop
			_offset = 0;// deslocamento atual
			_pausaCount = 0;
			_pausaLimite = $loopsDePausa;
			
		}
		
		private function  _atribuiTexto (texto:String):void {
			_mataLoop();
			
			_tf.text = texto;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			
			_offset = 0;
			_atualizaVisual();
			
			
			
			
			//var w = _tf.width; // fica inconsistente
			var w:Number = _tf.textWidth + 2; //adicionei uma folga para nao ficar colado
			
			if (w>_limiteW) {
				// precisa de scroll
				_sentido = -1;
				_offset = 0;
				_limiteOffset = (w-_limiteW)*-1;
				_iniciaLoop();
			} else {
				// nao tem scroll
			}
		}
		
		private function  _mataLoop ():void {
			clearInterval(_intervalId);
		}
		
		private function  _iniciaLoop ():void {
			_mataLoop();
			_pausaCount = 0;
			_intervalId = setInterval(_scrollLoop, _speed);
		}
		
		private function  _scrollLoop ():void {
			
			var novoOffset:Number = _offset+(_incX * _sentido);
			
			switch (_sentido) {
				case -1 :
					if (_pausaCount>_pausaLimite) {
						if (novoOffset >= _limiteOffset) {
							_offset = novoOffset;
						} else {
							_offset = _limiteOffset;
							_inverteSentido();
							_pausaCount = 0;
						}
					} else {
						_pausaCount++;
					}
				break;
				
				case 1:
					if (_pausaCount>_pausaLimite) {
						if (novoOffset < 0) {
							_offset = novoOffset;
						} else {
							_offset = 0;
							_inverteSentido();
							_pausaCount = 0;
						}
					} else {
						_pausaCount++;
					}
				break;
			}
			
			_atualizaVisual();
		}
		
		private function  _atualizaVisual ():void {
			
			var nx:Number = _offset*-1;
			_rect = new Rectangle(nx, 0, _limiteW, 30); //nx
			_tf.scrollRect = _rect;
			
		}
		
		private function  _inverteSentido ():void {
			_sentido = _sentido *-1;
		}
		
		// ISTO é NOVO
		
		public function remove():void {
			_mataLoop();
		}
		
		
		public function get texto():String {
			return _texto;
		}
		
		public function set texto(value:String):void {
			_texto = value;
			_atribuiTexto(value);
		}
		
	}
	
}