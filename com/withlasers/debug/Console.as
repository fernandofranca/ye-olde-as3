/*

	INSERT //oculta
	DELETE // remove o ultimo,
	DELETE + SHIFT remove todos

	HOME // move para o topo
	END // move para o fim
	PAGE UP // move para baixo
	PAGE DOWN // move para cima
	PAGE DOWN // move para cima
	PAGE DOWN // move para cima
	I ou i // Inspetor de MovieClips

	cons = new Console(stage, true);
	
	cons.addEventListener(Console.ON_ERROR, function ():void {
		trace('Erro. O mundo acabou!');
	})
	
	cons.addEventListener(Console.ON_WARNING, function ():void {
		trace('Warning! Naaaaao!');
	})
	
	cons.addEventListener(Console.ON_INFO, function ():void {
		trace('Xiii...');
	})
	
	cons.msg(_root)
	cons.msgInfo('Lorem ipsum \nSit dolor');
	cons.msgWarning('Lorem ipsum \nSit dolor');
	cons.msgError('Lorem ipsum \nSit dolor');
*/

package com.withlasers.debug{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.utils.describeType;
	import gs.TweenLite;
	
	/**
	 * @author Fernando de França
	 */
	public class Console {
		private static var __instance:Console
		
		private var __eventDispatcher:EventDispatcher;
		private var __isInited:Boolean
		private var __stageRef:Stage
		
		private var __bgColor:Number = 0x00000;
		private var __mascara:Mascara // mascara do conteudo
		private var __lastAddedMc:ConsoleTextField
		private var __height:Number = 100;
		private var __visible:Boolean = true;
		
		private var mc:MovieClip;
			private var mcContainer:MovieClip;
				private var mcConteudo:MovieClip;
			private var mcBg:MovieClip;
		
		private var linkFechar:String = '\n <a href="event:+++FECHAR+++">[ x ]</a>';
		
		public static const ON_ERROR:String = 'onError';
		public static const ON_INFO:String = 'onInfo';
		public static const ON_WARNING:String = 'onWarning';
		
		
		private var propsMovieClip:Array = ['name', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'currentFrame', 'currentLabel', 'totalFrames', 'mouseEnabled', 'hitArea', 'enabled', 'mouseChildren', 'tabEnabled', 'tabIndex', 'tabChildren', 'loaderInfo', 'numChildren', 'parent']
		private var propsSprite:Array = ['name', 'numChildren', 'CHILDREN', 'parent', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'mouseEnabled', 'hitArea', 'mouseChildren', 'tabEnabled', 'tabIndex', 'tabChildren', 'loaderInfo']
		private var propsTextField:Array = ['name', 'type', 'text', 'htmlText', 'textWidth', 'textHeight', 'length', 'numLines', 'maxChars', 'wordWrap', 'autoSize', 'multiline', 'styleSheet', 'defaultTextFormat', 'textColor', 'border', 'borderColor', 'background', 'backgroundColor', 'opaqueBackground', 'mouseWheelEnabled', 'restrict', 'displayAsPassword', 'embedFonts', 'antiAliasType', 'thickness', 'sharpness', 'selectable', 'selectedText', 'selectionBeginIndex', 'selectionEndIndex', 'caretIndex', 'parent', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'mouseEnabled', 'tabEnabled', 'tabIndex', 'loaderInfo']
		
		
		public function Console($stageRef:Stage, $visible:Boolean=false, $height:Number=200):void {
			if (Console.__instance!=null) {
				throw(new Error('O Console ja foi instanciado, use a propriedade "instance" para obter uma referência deste Singleton.'))
			} else {
				init($stageRef, $visible, $height);
				Console.__instance = this;
			}
		}
		
		public function init($stageRef:Stage, $visible:Boolean, $height:Number):void {
			
			// só pode inicializar uma vez
			if (__isInited != true) {
				
				__isInited = true;
				__stageRef = $stageRef;
				
				// inicializa o Inspector
				ConsoleInspector.init(__stageRef);
				
				// cria mcs
				mc = new MovieClip();
				mcBg = new MovieClip();
				mcContainer = new MovieClip();
				mcConteudo = new MovieClip();
				
				// adiciona ao stage
				$stageRef.addChild(mc)
					mc.addChild(mcBg)
					mc.addChild(mcContainer);
						mcContainer.addChild(mcConteudo);
				
				// visual
				__drawBg();
				__mascara = new Mascara(mcContainer, mcBg.width, height);
				
				alpha = 0.3;
				
				height = $height;
				
				visible = $visible;
				
				var sombra:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 2.5, 0, 15);
				mcBg.filters = [sombra];
				
				
				// eventos
				__stageRef.addEventListener(Event.RESIZE, __handleResize)
				
				mc.addEventListener(MouseEvent.MOUSE_WHEEL, __handleWheel);
				mc.addEventListener(MouseEvent.ROLL_OVER, __handleOver);
				mc.addEventListener(MouseEvent.ROLL_OUT, __handleOver);
				__stageRef.addEventListener(KeyboardEvent.KEY_UP, __handleKey)
				
				__eventDispatcher = new EventDispatcher();
				
			}
			
			__msg('Hello! <b>' + new Date().toTimeString()+'</b>');
		}
		
		private function __msg($str:String):void {
			
			
			var tf:ConsoleTextField
			tf = new ConsoleTextField();
			tf.htmlText = $str
			
			if (__lastAddedMc==null) {
				tf.y = 0
			}
			
			
			mcConteudo.addChild(tf);
			
			__positionElements();
			
			__lastAddedMc = tf; //atualiza referencia do ultimo elemento
			
			__scrollBottom();
		}
		
		/**
		 * Aceita argumentos multiplos
		 */
		public function msg(... args):void {
			
			var tipo:String
			var arg:*
			var linha:String
			var linhas:String
			
			if (__isInited!=true) {
				throw(new Error('Inicialize o Console antes de usar este método!'))
			}
			
			for (var i:int = 0; i < args.length; i++) {
				
				arg = args[i];
				
				// determina tipo
				tipo = __typeToString(arg);
				
				if (tipo == 'Object') {
					__msg('<b>[' +tipo + ']</b> = <a href="event:+++OBJETO+++">' + arg+'</a>')
					
					__lastAddedMc.ref = arg;
					__lastAddedMc.addEventListener(TextEvent.LINK, __handleLinkObj)
					
				}else if (tipo=='Array') {
					
					linhas = '<b>[Array]</b>\n';
					
					for (var j:int = 0; j < arg.length; j++) {
						linhas += '<a href="event:'+j+'"><b>[' + j + ']</b></a>  '
					}
					__msg(linhas);
					__lastAddedMc.ref = arg;
					__lastAddedMc.addEventListener(TextEvent.LINK, __handleLinkObj)
					
				} else {
					
					__msg('<b>[' +tipo + ']</b> = ' + arg)
				}
				
				
				// destaca o objeto
				if (arg is DisplayObject) ConsoleInspector.hilight(arg);
			}
			
		}
		
		
		public function msgInfo($texto:*):void {
			__msg($texto);
			ConsoleStyler.setStyle(__lastAddedMc, ConsoleStyler.STYLE_INFO);
			
			__disparaEvento(ON_INFO);
		}
		
		public function msgWarning($texto:*):void {
			__msg('<b>WARNING:</b> '+$texto);
			//__lastAddedMc.backgroundColor = ConsoleTextField.COLOR_WARNING;
			ConsoleStyler.setStyle(__lastAddedMc, ConsoleStyler.STYLE_WARNING);
			
			__disparaEvento(ON_WARNING);
		}
		
		public function msgError($texto:*):void {
			__msg('<b>ERROR:</b> '+$texto);
			ConsoleStyler.setStyle(__lastAddedMc, ConsoleStyler.STYLE_ERROR)
			
			__disparaEvento(ON_ERROR);
		}
		
		/**
		 * Lista as propriedades publicas de uma instancia, seus tipos e valores
		 * @param	$obj	Instancia
		 * @param	$descricao	Texto opcional
		 */
		public function msgProps($obj:*, $descricao:String=null):void {
			var i:int
			var xml:XML = describeType($obj);
			
			var acc:XMLList = xml.accessor;
			var vars:XMLList = xml.variable;
			var arr:XMLList
			var arrProps:Array
			
			var name:String
			var base:String
			var type:String
			var declaredBy:String
			var value:*
			
			var str:String = ''
			var strDescricao:String = ''
			var strArr:Array = [];
			var tipo:String = ''
			var filtraProp:Boolean = false; // decide se a propriedade nao sera exibida
			
			name = xml.attribute('name')
			base = xml.attribute('base')
			
			
			
			if ($descricao!=null) {
				strDescricao += '<h1>' + $descricao + '</h1>\n';
			}
			strDescricao += name + ' > ' + base + '\n';
			
			//loop de variaveis
			arr = XMLList(vars.toString() + acc.toString()); // concatena variaveis e accessors
			
			
			if ($obj is MovieClip) arrProps = propsMovieClip;
			if ($obj is Sprite) arrProps = propsSprite;
			if ($obj is TextField) arrProps = propsTextField;
			
			
			
			for (i = 0; i < arr.length(); i++) {
				str = ''
				
				name = arr[i].attribute('name');
				type = arr[i].attribute('type');
				
				value = '#undefined#';
				
				try {
					value = $obj[name]
				} catch (e:Error){ }
				
				
				
				
				if (arrProps) {
					// true nao exibe, pois nao esta no array
					filtraProp = arrProps.indexOf(name) < 0;
				}
				
				if (filtraProp == false) {
					
					// determina tipo
					tipo = __typeToString(value);
					
					if (tipo == 'Object') {
						str += '\t<b> '  + name + '</b>:' + type + '\t = ' +'<a href="event:' + name + '">' + value + '</a>\n';
					} else {
						str += '\t<b> ' + name + '</b>:' + type + '\t = ' + value + '\n';
					}
					
					strArr.push(str);
				}
				
			}
			
			
			// caso especial para objetos,
			// que nunca sao detalhados pelo describeType
			
			if (name=='Object') {
				for (var prop:String in $obj) {
					name = prop
					value = $obj[name];
					type = typeof value;
					
					str = '\t*<b> '  + name + '</b>:' + type + '\t = ' +'<a href="event:' + name + '">' + value + '</a>\n';
					strArr.push(str);
				}
			}
			
			
			strArr.sort(); // organiza alfabeticamente
			str = strArr.join(''); //transforma de volta
			str = strDescricao + str;
			
			msgInfo(str + linkFechar);
			
			__lastAddedMc.ref = $obj
			
			__lastAddedMc.addEventListener(TextEvent.LINK, __handleLinkObj);
			
			ConsoleStyler.setStyle(__lastAddedMc, ConsoleStyler.STYLE_OBJ);
			
			// destaca o objeto
			if ($obj is DisplayObject) ConsoleInspector.hilight($obj);
		}
		
		/**
		 * Remove as mensagens anteriores
		 */
		public function clear():void {
			
			var $mc:MovieClip = mcConteudo;
			
			while ($mc.numChildren>0) {
				$mc.removeChildAt(0)
			}
			
			__lastAddedMc = null;
			
			TweenLite.to(__mascara, 0.1, { dy:0 } );
		}
		
		/**
		 * Remove o ultimo mensagem exibida
		 */
		public function clearLast():void {
			var num:Number = mcConteudo.numChildren - 1
			
			if (num>0) {
				mcConteudo.removeChildAt(num);
				
				__lastAddedMc = mcConteudo.getChildAt(num-1) as ConsoleTextField;
				
				__scrollBottom();
			}
			
			__setFocus();
		}
		
		private function __disparaEvento(e:String):void {
			__eventDispatcher.dispatchEvent(new Event(e));
		}
		
		public function addEventListener(type:String, listener:Function):void {
			// ficou estranho mas funciona. investigar melhor depois
			
			__eventDispatcher.addEventListener(type, listener);
		}
		
		public function removeEventListener(type:String, listener:Function):void {
			
			__eventDispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * Determina o tipo e retorna String
		 */
		private function __typeToString(arg:*):String{
			// typeof nao é completamente confiavel.
			// ex: retorna object para array
			var tipo:String = ''
			
			
			if (arg is Object) tipo = 'Object'
			if (arg is Number) tipo = 'Number'
			if (arg is String) tipo = 'String'
			if (arg is Array) tipo = 'Array'
			if (arg is Boolean) tipo = 'Boolean'
			if (arg is Function) tipo = 'Function'
			
			return tipo;
		}
		
		/**
		 * Determina o objeto com foco.
		 * Apos remover alguns elementos o evento de teclado acaba não disparando
		 */
		private function __setFocus():void{
			mcContainer.stage.focus = mcContainer.stage;
		}
		
		/**
		 * Desenha o Background
		 */
		private function __drawBg():void {
			var gr:Graphics = mcBg.graphics
			gr.clear();
			gr.beginFill(__bgColor, 1);
			gr.drawRect(0, 0, __stageRef.stageWidth, height); //
			gr.endFill();
		}
		
		/**
		 * Posiciona os textfields em sequencia
		 */
		private function __positionElements():void{
			var atual:DisplayObject
			var anterior:DisplayObject
			
			var childsArr:Array = []
			for (var i:int = 1; i < mcConteudo.numChildren; i++) {
				//childsArr.push(mcConteudo.getChildAt(i));
				
				anterior = mcConteudo.getChildAt(i-1);
				atual = mcConteudo.getChildAt(i);
				
				atual.y = anterior.y + anterior.height + 4;
			}
		}
		
		/**
		 * Rola para o fim
		 */
		private function __scrollBottom($tempo:Number=0.5):void{
			
			var hReal:Number = mcConteudo.height;
			var hLimite:Number = __mascara.height;
			
			if (hReal > hLimite) {
				
				var deslocamento:Number
				deslocamento = (hReal - hLimite)*-1;
				
				TweenLite.to(__mascara, $tempo, { dy:deslocamento-10 } );
			} else {
				TweenLite.to(__mascara, $tempo, { dy:0} );
			}
			
		}
		
		/**
		 * Rola para o topo
		 */
		private function __scrollTop($tempo:Number=0.5):void{
			TweenLite.to(__mascara, $tempo, { dy:0} );
		}
		
		/**
		 * Rola para cima
		 */
		private function __scrollUp($tempo:Number = 0.5):void {
			var inc:Number = height;
			
			var dy:Number = __mascara.dy + inc
			
			if (dy<0) {
				TweenLite.to(__mascara, $tempo, { dy:dy} );
			}else {
				__scrollTop();
			}
		}
		
		/**
		 * Rola para baixo
		 */
		private function __scrollDown($tempo:Number = 0.5):void {
			var inc:Number = height;
			
			var dy:Number = __mascara.dy - inc
			
			var hReal:Number = mcConteudo.height * -1;
			
			if (dy>hReal) {
				TweenLite.to(__mascara, $tempo, { dy:dy} );
			}else {
				__scrollBottom();
			}
		}
		
		private function __removeElement($tf:*):void{
			mcConteudo.removeChild($tf);
			
			// atualiza o ultimo elemento da lista
			__lastAddedMc = mcConteudo.getChildAt(mcConteudo.numChildren - 1) as ConsoleTextField;
			
			// posiciona os elementos restantes
			__positionElements()
			
			// atualiza o scroll
			__scrollBottom();
			
			
		}
		
		
		
	// event handlers
		
		
		/**
		 * Detalha ao clicar em um link de um OBJETO
		 */
		private function __handleLinkObj(e:TextEvent):void {
			var ref:*
			var prop:String
			var nome:String
			
			switch (e.text) {
				
				case '+++OBJETO+++': // detalha o OBJETO
					ref = e.target.ref
					nome = e.target.text
					msgProps(ref, nome);
				break
				
				case '+++FECHAR+++': // remove o TextField
					__removeElement(e.target)
				break
				
				default : // detalha a propriedade
					ref = e.target.ref;
					prop = e.text;
					msgProps(ref[prop], prop);
				break
			}
			
			
		}
		
		/**
		 * Aumenta o tamanho do Console no mouse over
		 */
		private function __handleOver(e:MouseEvent):void {
			
			if (e.type==MouseEvent.ROLL_OVER) {
				TweenLite.to(mc, 0.2, { y:0 } );
			} else if (e.type == MouseEvent.ROLL_OUT) {
				if (visible==true) {
					TweenLite.to(mc, 0.2, { y:(height/1.5) * -1 } );
				}
				
			}
			
			__scrollBottom(0);
			
			ConsoleInspector.stopInspect();
		}
		
		/**
		 * Reajusta o Console no resize do Stage
		 */
		private function __handleResize(e:Event):void {
			__drawBg()
			__mascara.width = mcBg.width;
			__mascara.height = height;
		}
		
		/**
		 * Deslocamento pelo MouseWheel
		 */
		private function __handleWheel(e:MouseEvent):void {
			
			var deslocamento:Number
			var inc:Number = height/3
			
			var hReal:Number = mcConteudo.height;
			var hLimite:Number = __mascara.height;
			
			
			if (e.delta>0) {
				deslocamento = __mascara.dy + inc
			} else if(e.delta<0) {
				deslocamento = __mascara.dy - inc
			}
			
			
			if (deslocamento>0) {
				deslocamento = 0
			}
			
			
			if (deslocamento<(hReal - hLimite)*-1) {
				deslocamento = ((hReal - hLimite)*-1)-4
			}
			
			if (hReal>hLimite) {
				TweenLite.to(__mascara, 0.2, { dy:deslocamento } );
			}
			
			
		}
		
		/**
		 * Responde aos eventos de teclado
		 */
		private function __handleKey(e:KeyboardEvent):void {
			var kCode:Number = e.keyCode;
			
			
			if (visible==true) {
				switch (kCode) {
					case 45: // INSERT //oculta
						visible = false;
						break
					case 46: //DELETE // remove o ultimo, +shift remove todos
						e.shiftKey == true?clear():clearLast();
						break
					case 36: //HOME // move para o topo
						__scrollTop();
						break
					case 35: //END // move para o fim
						__scrollBottom();
						break
					case 33: //PAGE UP // move para baixo
						__scrollUp();
						break
					case 34: //PAGE DOWN // move para cima
						__scrollDown();
						break
					case 107: //PAGE DOWN // move para cima
						height += 50;
						break
					case 109: //PAGE DOWN // move para cima
						height -= 50;
						break
					case 73: // i ou I // inspect
						__toggleInspector()
						break
				}
			} else  if (visible==false) {
				switch (kCode) {
					case 45: // INSERT // exibe
						visible = true;
						break
					case 73: // i ou I // inspect
						ConsoleInspector.stopInspect();
						break
				}
			}
			
			//trace(kCode);
		}
		
		private function __toggleInspector():void{
			if (ConsoleInspector.isInspecting==true) {
				ConsoleInspector.stopInspect();
			} else {
				ConsoleInspector.inspect();
				visible = false
			}
		}
		
		
		
	// getters e setters
		
		
		public function get height():Number { return __height; }
		
		public function set height(value:Number):void {
			
			__height = value;
			__drawBg();
			__mascara.height = height;
			
			__scrollBottom(0.1);
		}
		
		public function get alpha():Number { return mcBg.alpha; }
		
		public function set alpha(value:Number):void {
			mcBg.alpha = value;
		}
		
		public function get visible():Boolean { return __visible; }
		
		public function set visible(value:Boolean):void {
			__visible = value;
			
			if (value==true) {
				TweenLite.to(mc, 0.2, { y:0 } );
			} else {
				//TweenLite.to(mc, 0, { y:height * -1 } );
				mc.y = height * -1;
			}
		}
		
		public static function get instance():Console {
			if (__instance == null) {
				throw(new Error('O Console ainda não foi instanciado.'))
			}
			return __instance
		}
	}
	
}