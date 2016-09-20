/*
	var f1:FormCampoTexto = new FormCampoTexto(this.mc1, 'Nome');
	var f2:FormCampoTexto = new FormCampoTexto(this.mc2, 'Email');
	
	mcBt.addEventListener(MouseEvent.CLICK, msg)

	function msg (e) {
		
		var form:Form = new Form('http://fiberinteractive.com.br/xml/contato.php');
		form.addField(f1, 'Nome', Form.VALIDACAO_CARACTERES, 4);
		form.addField(f2, 'Email', Form.VALIDACAO_EMAIL);
		
		
		form.onError = function  () {
			trace('Não deu certo...');
			trace(form.resposta)
		}
		
		form.onSend = function  () {
			trace('Deu certo!');
			trace(form.resposta);
			
			for (var i in form.resposta) {
				trace(i, form.resposta[i])
			}
		}
		
		if (form.validate()==true) {
			trace('VALIDO')
			form.send();
		} else {
			trace('FORM INVALIDO')
		}
		
	}
*/

package {
	
	import flash.display.*
	import flash.events.*;
	import flash.system.System;
	import com.withlasers.ui.IFormCampo
	
	
	public class Form {
		private var fields:Array
		private var fieldsExtra:Array
		private var pl:SendAndLoad
		private var objDados:Object
		private var urlDestino:String
		
		private var __lastTabIndex:Number = -1
		
		public var onSend:Function
		public var onError:Function
		public var resposta:* = ''
		public static const VALIDACAO_CARACTERES:String = 'length'
		public static const VALIDACAO_EMAIL:String = 'e-mail'
		public static const SELECT:String = 'select'
		
		public function Form($urlDestino:String):void {
			fields = [];
			fieldsExtra = []; //variaveis extras, sem campo de texto, a serem enviadas
			urlDestino = $urlDestino;
		}
		
		/**
		 * Adiciona um campo para validacao e envio
		 * @param	field
		 * @param	nome			Nome da variavel no envio
		 * @param	tipoValidacao
		 * @param	param
		 */
		public function addField(field:IFormCampo, nome:String, tipoValidacao:String, param:*=null):void {
			fields.push( { field:field, nome:nome, tipo:tipoValidacao, param:param } );
			
			field.tabIndex = __lastTabIndex + 1;
			
			__lastTabIndex = field.tabIndex;
			
			// adicionei por causa do RadioButtonGroup, que tem diversos fields, assim nao é linear
		}
		
		/* variavel extra, sem ser um campo, a ser enviada*/
		public function addVariable(nome:String, valor:String):void {
			fieldsExtra.push( { nome:nome, value:valor } );
		}
		
		public function validate():Boolean {
			var i:Number
			var value:String
			var nome:String
			var tipo:*
			var param:*
			var field:IFormCampo
			var valido:Boolean = true;
			objDados = { }
			
			for (i = 0; i < fields.length; i++) {
				
				field = fields[i].field;
				
				tipo = fields[i].tipo;
				param = fields[i].param;
				value = field.value;
				nome = fields[i].nome;
				
				objDados[nome] = value; //atribui infos ao objeto que será usado no envio
				
				switch (tipo) {
					case 'length' : // valida por numero de caracteres
						if (value.length<param) {
							valido = false;
							field.showError('Digite no mínimo ' + param + ' caracteres');
						}
					break;
					case 'e-mail' : // valida se é um e-mail
						var isEmail:Boolean = value.indexOf('@') > -1 && value.indexOf('.') > -1 && value.length > 4;
						if (isEmail==false) {
							valido = false;
							field.showError('Informe um e-mail válido');
						}
					break;
					case SELECT:
						if (value==null || value=='') {
							valido = false;
							
							if (param==null) {
								field.showError('Selecione uma opção');
							} else {
								field.showError(String(param));
							}
						}
					break
				}
			}
			
			// loop adicional para as variaveis extras do addVariable (fieldsExtra)
			for (i = 0; i < fieldsExtra.length; i++) {
				value = fieldsExtra[i].value;
				nome = fieldsExtra[i].nome;
				objDados[nome] = value; //atribui infos ao objeto que será usado no envio
			}
			
			return valido
		}
		
		/**
		 * Envia os dados para o servidor
		 * @param	$useCodePage
		 * @param	$post		true envia por POST | false envia por GET
		 */
		public function send ($useCodePage:Boolean = true, $post:Boolean = true ):void {
			/*
			for (var i:String in objDados) {
				trace([i, objDados[i]]);
			}
			*/
			
			System.useCodePage = $useCodePage;
			
			pl = new SendAndLoad(urlDestino, objDados);
			pl.onSuccess = __onSuccess;
			pl.onError = __onError;
			pl.send($post);
		}
		
		public function resetFields():void 
		{
			for each (var obj:Object in fields) 
			{
				var field:IFormCampo = obj.field
				field.value = '';
				field.text = field.label;
			}
		}
		
		private function __onSuccess():void{
			try {
				resposta = pl.resposta;
				onSend()
			} catch (e:Error){}
		}
		
		private function __onError():void{
			try {
				resposta = pl.erro;
				onError();
			} catch (e:Error){}
		}
	}
}