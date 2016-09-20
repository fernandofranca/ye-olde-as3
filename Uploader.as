package  { 
	import flash.net.*;
	import flash.events.*
	
	public class Uploader {
		private var __types:FileFilter
		private var __allTypes:Array
		private var __fileRefLista:FileReferenceList;
		private var __fileRefItem:FileReference;
		private var __uploadURL:URLRequest;
		private var __lista:Array; // lista dos arquivos
		private var __listaIndice:Number;//Numero do arquivo atual
		
		public var totalBytes:Number;
		public var uploadedBytes:Number
		public var percentUploaded:Number
		public var verbose:Boolean = false;
		
		/* eventos */
		public var onSelect:Function
		public var onProgress:Function
		public var onComplete:Function
		public var onError:Function
		
		
		
		public function Uploader($descricao:String, $tipos:Array, $urlDestino:String) {
			
			__types = new FileFilter($descricao, $tipos.join('; '))
			
			__allTypes = []
			__allTypes.push(__types);
			
			__uploadURL = new URLRequest();
			__uploadURL.url = $urlDestino;
			
			__fileRefLista = new FileReferenceList();
			__fileRefLista.addEventListener(Event.SELECT, __onSelect);
		}
		
		private function __onSelect(e:Event):void {
		    __lista = __fileRefLista.fileList; 
			
		    __startUpload();
		    
			try {
				onSelect(); //calback
			} catch (e:Error){
			}
		}
		
		private function __startUpload():void {
			__trace("iniciando upload");
			/* calcula total de bytes a serem enviados */
			totalBytes = 0;
			uploadedBytes = 0;
			percentUploaded = 0;
			
			var item:FileReference
			
			for (var i:String in __lista) {
				item = __lista[i]
				
				totalBytes += item.size;
			}
			item = null;
			
			__trace('bytes to upload = ' + totalBytes);
			
			__listaIndice = -1;
			__uploadNext()
		}
		
		
		
		private function __uploadNext() {
			
			
			if (__listaIndice + 1 < __lista.length) { //ainda há arquivos...
				__listaIndice++
				
				if (__fileRefItem) {
					// remove listeners anteriores
					__fileRefItem.removeEventListener(ProgressEvent.PROGRESS, __onProgress);
					__fileRefItem.removeEventListener(IOErrorEvent.IO_ERROR, __onError);
					__fileRefItem.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __onError);
					__fileRefItem.removeEventListener(HTTPStatusEvent.HTTP_STATUS, __onErrorHttp);
				} else {
					__fileRefItem = new FileReference();
				}
				
				__fileRefItem = FileReference(__lista[__listaIndice]); //pega a referencia do item
				
				//adiciona listeners
				__fileRefItem.addEventListener(ProgressEvent.PROGRESS, __onProgress);
				__fileRefItem.addEventListener(IOErrorEvent.IO_ERROR, __onError);
				__fileRefItem.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __onError);
				__fileRefItem.addEventListener(HTTPStatusEvent.HTTP_STATUS, __onErrorHttp);
				__fileRefItem.upload(__uploadURL);
				
				
				__trace('subindo... ' + __fileRefItem.name + '  /  ' + __fileRefItem.size);
				
			} else { //...terminou
				__trace('fim do upload');
				try {
					onComplete();
				} catch (e:Error){
				}
			}
		}
		
		private function __onError(e:*):void {
			__trace(e.text);
			try {
				onError(e.text)
			} catch (e:Error){
			}
		}
		
		private function __onErrorHttp(e:HTTPStatusEvent):void {
			__trace('Erro HTTP :' + e.status);
			try {
				onError(e.status)
			} catch (e:Error){
			}
		}
		
		
		
		private function __onProgress(event:ProgressEvent) {
			var file:FileReference = FileReference(event.target);
		
			
			var bytesLoaded:Number = event.bytesLoaded 
			var bytesTotal:Number = event.bytesTotal
			
			var b:Number
			
			if (bytesLoaded == bytesTotal) { 
				//completou o upload do arquivo
				uploadedBytes += bytesLoaded 
				b = uploadedBytes;
			} else { 
				//upload parcial do arquivo
				b = uploadedBytes + bytesLoaded;
			}
		
			percentUploaded = (b*100)/totalBytes
			
			try {
				onProgress(percentUploaded, file.name);
			} catch (e:Error){
			}
			
			if (bytesLoaded == bytesTotal) {
				//completou o upload do arquivo // dispara o onProgress antes de carregar o proximo
				__uploadNext();
			}
		}
		
		
		public function browse() {
			__fileRefLista.browse(__allTypes)
		}
		
		
		public function cancel() {
			__fileRefItem.cancel();
		}
		
		public function get files():Array { 
			var tmp = []
			for (var i:Number = 0; i < __lista.length; i++) {
				tmp.push(__lista[i].name)
			}
			return tmp;
		}
		
		private function __trace($texto):void{
			if (verbose==true) {
				Tracebox.msg('Uploader:' + $texto)
			}
		}
	}
}