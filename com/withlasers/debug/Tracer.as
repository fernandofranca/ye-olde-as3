package com.withlasers.debug {
	import org.flashdevelop.utils.FlashConnect
	import flash.external.ExternalInterface
	import flash.utils.describeType;
	import flash.display.*;
	import flash.text.TextField
	import flash.events.Event
	
	
	//import com.withlasers.patterns.Singleton
	
	/**
	 * Tracer
	 * @author Fernando de França
	 */
	public class Tracer  {
		private static var __instance:Tracer
		private static var __allowInstance:Boolean = false
		
		public var enableFlashConnect:Boolean = true
		public var enableFirebug:Boolean = true
		
		private var propsMovieClip:Array = ['name', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'currentFrame', 'currentLabel', 'totalFrames', 'mouseEnabled', 'hitArea', 'enabled', 'mouseChildren', 'tabEnabled', 'tabIndex', 'tabChildren', 'loaderInfo', 'numChildren', 'parent']
		private var propsSprite:Array = ['name', 'numChildren', 'CHILDREN', 'parent', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'mouseEnabled', 'hitArea', 'mouseChildren', 'tabEnabled', 'tabIndex', 'tabChildren', 'loaderInfo']
		private var propsTextField:Array = ['name', 'type', 'text', 'htmlText', 'textWidth', 'textHeight', 'length', 'numLines', 'maxChars', 'wordWrap', 'autoSize', 'multiline', 'styleSheet', 'defaultTextFormat', 'textColor', 'border', 'borderColor', 'background', 'backgroundColor', 'opaqueBackground', 'mouseWheelEnabled', 'restrict', 'displayAsPassword', 'embedFonts', 'antiAliasType', 'thickness', 'sharpness', 'selectable', 'selectedText', 'selectionBeginIndex', 'selectionEndIndex', 'caretIndex', 'parent', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY', 'rotation', 'visible', 'alpha', 'mask', 'scrollRect', 'cacheAsBitmap', 'blendMode', 'filters', 'mouseEnabled', 'tabEnabled', 'tabIndex', 'loaderInfo']
		
		private var TIPO_WARNING:String = 'warning';
		private var TIPO_ERROR:String = 'erro';
		
		private var sp:String = '\n____________________________________\n\n';
		
		public function Tracer():void  {
			if (__instance != null && __allowInstance != true) {
				
				// não permite instanciar diretamente ou mais de uma vez
				throw(new Error('Obtenha a referencia pela funcao getInstance()'))
				
			}
		}
		
		private function __msg($msg:String, $tipo:String = ''):void {
			var prefixo:String
			var firebugMethod:String
			
			switch ($tipo) {
				case TIPO_ERROR:
					prefixo = 'ERRO: '
					firebugMethod = 'console.error'
				break
				case TIPO_WARNING:
					prefixo = 'ATENÇÃO: '
					firebugMethod = 'console.warn'
				break
				case '':
					prefixo = 'INFO: '
					firebugMethod = 'console.log'
				break
			}
			
			
			if (enableFlashConnect) FlashConnect.trace(prefixo + $msg + sp);
			
			if (enableFirebug) {
				if (ExternalInterface.available) {
					ExternalInterface.call(firebugMethod, $msg);
				}
			}
		}
		
		/**
		 * Aceita argumentos multiplos
		 */
		public function trace(... args):void {
			
			var tipo:String
			var arg:*
			var linha:String
			var linhas:String
			
			
			for (var i:int = 0; i < args.length; i++) {
				
				arg = args[i];
				
				// determina tipo
				tipo = __typeToString(arg);
				
				if (tipo == 'Object') {
					__msg('[' +tipo + '] = ' + arg);
					traceProps(arg);
				} else if (tipo=='Array') {
					
					linhas = '[Array]\n';
					
					for (var j:int = 0; j < arg.length; j++) {
						//linhas += '\t[' +j +'] ' + '\n';
						//traceProps(arg[j]);
						// poderia detalhar os elementos do array... estudar possibilidade.
						
						linhas += '\t[' +j +'] '+  arg[j] + '\n';
					}
					__msg(linhas);
					
				} else if (arg is DisplayObjectContainer) {
					traceProps(arg, arg + ' (' + arg['name'] + ') properties');
				} else {
					__msg('[' +tipo + '] = ' + arg)
				}
			}
			
		}
		
		public function traceWarning($msg:String):void {
			__msg($msg, TIPO_WARNING)
		}
		
		public function traceError($msg:String):void {
			__msg($msg, TIPO_ERROR)
		}
		/**
		 * Lista as propriedades publicas de uma instancia, seus tipos e valores
		 * @param	$obj	Instancia
		 * @param	$descricao	Texto opcional
		 */
		public function traceProps($obj:*, $descricao:String=null):void {
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
				strDescricao += '*** ' + $descricao + ' ***\n';
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
					str += '\t ' + name + ':' + type + '\t = ' + value + '\n';
					
					strArr.push(str);
				}
				
			}
			
			
			// caso especial para objetos, que nunca sao detalhados pelo describeType
			
			if (name=='Object') {
				for (var prop:String in $obj) {
					name = prop
					value = $obj[name];
					type = typeof value;
					
					str += '\t ' + name + ':' + type + '\t = ' + value + '\n';
					strArr.push(str);
				}
			}
			
			
			strArr.sort(); // organiza alfabeticamente
			str = strArr.join(''); //transforma de volta
			str = strDescricao + str;
			
			__msg(str);
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
			if (arg is Event) tipo = 'Event'
			if (arg is DisplayObjectContainer) tipo = 'DisplayObjectContainer'
			if (arg is MovieClip) tipo = 'MovieClip'
			
			return tipo;
		}
		
		
		
		public static function getInstance():Tracer {
			
			if (__instance == null) {
				__allowInstance = true;
				__instance = new Tracer();
				__allowInstance = false;
			}
			
				
			return __instance;
		}
	}
	
}