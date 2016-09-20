package {
	import flash.display.*
	import flash.events.*;
	import flash.net.SharedObject;
	
	
	public class LocalData {
		private var nome:String
		private var so:SharedObject
		
		public function LocalData($nomeInstancia:String):void {
			nome = $nomeInstancia;
			so = SharedObject.getLocal(nome);
		}
		
		/* salva informacoes */
		public function save():String{
			try {
				var res:String = so.flush();
			} catch (e:Error) {
				trace(e);
			}
			
			return res;
		}
		
		/* remove toda informacao do objeto */
		public function clear():void{
			so.clear();
			save();
		}
		
		public function list():void {
			/*
			*/
			var titulo:String = '*** ' + nome + '.data ***'
			var linhaFinal:String = '';
			while (linhaFinal.length<titulo.length) {
				linhaFinal += '*';
			}
			
			trace('');
			trace(titulo);
			
			try {
				for (var name:String in so.data) {
					trace(name, ':', so.data[name]);
				}
			} catch (e:Error){
				trace(e);
			}
			
			trace(linhaFinal);
			trace('');
			trace('');
		}
		
		public function setData(propriedade:String, valor:*):void {
			so.data[propriedade] = valor;
			save();
		}
		
		public function getData(propriedade:String):Object { 
			return so.data[propriedade];
		}
		
		
		
	}
}