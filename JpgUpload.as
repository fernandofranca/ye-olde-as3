/*
<?
print_r ($_POST);
move_uploaded_file($_FILES['Filedata']['tmp_name'], "img/".$_FILES['Filedata']['name']); 
?>
*/

package {
	import flash.display.*
	import flash.events.*;
	import com.adobe.images.JPGEncoder;
	import flash.utils.ByteArray;
	import flash.net.*;
	
	public class JpgUpload {
		var jpgSource:BitmapData
		var jpgEncoder:JPGEncoder
		var jpgStream:ByteArray
		var request: URLRequest
		var loader:URLLoader
		
		var onComplete:*
		var onError:*
		
		public function JpgUpload ($mcOrigem:DisplayObject, $nomeDoArquivo:String, $urlDestino:String, $onComplete:*, $onError:*=null, $qualidade:Number=95):void {
			onComplete = $onComplete;
			onError = $onError;
			
			$nomeDoArquivo += '.jpg';
			
			jpgSource = new BitmapData ($mcOrigem.width, $mcOrigem.height);
			jpgSource.draw($mcOrigem);
			jpgEncoder = new JPGEncoder($qualidade);
			jpgStream = jpgEncoder.encode(jpgSource);
			
			jpgStream.position = 0;

			var boundary: String = '---------------------------7d76d1b56035e';
			var header1: String  = '--'+boundary + '\r\n'
									+'Content-Disposition: form-data; name="Filename"\r\n\r\n'
									+'picture.jpg\r\n'
									+'--'+boundary + '\r\n'
									+'Content-Disposition: form-data; name="Filedata"; filename="'+$nomeDoArquivo+'"\r\n'
									+'Content-Type: application/octet-stream\r\n\r\n'
			
			//In a normal POST header, you'd find the image data here
			var header2: String =	'--'+boundary + '\r\n'
									+'Content-Disposition: form-data; name="Upload"\r\n\r\n'
									+'Submit Query\r\n'
									+'--' + boundary + '--';
			
			//Encoding the two string parts of the header
			var headerBytes1: ByteArray = new ByteArray();
			headerBytes1.writeMultiByte(header1, "ascii");

			var headerBytes2: ByteArray = new ByteArray();
			headerBytes2.writeMultiByte(header2, "ascii");

			//Creating one final ByteArray
			var sendBytes: ByteArray = new ByteArray();
			sendBytes.writeBytes(headerBytes1, 0, headerBytes1.length);
			sendBytes.writeBytes(jpgStream, 0, jpgStream.length);
			sendBytes.writeBytes(headerBytes2, 0, headerBytes2.length);

			request = new URLRequest($urlDestino);
			request.data = sendBytes;
			request.method = URLRequestMethod.POST;
			request.contentType = "multipart/form-data; boundary=" + boundary;

			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, __uploadCompleted);
			loader.addEventListener(IOErrorEvent.IO_ERROR, __onError);

			try {
				loader.load(request);
			} catch (error: Error) {
				
				trace(error);
				
				if (onError) {
					onError();
				}
			}
		}
		
		private function __onError(e:IOErrorEvent):void {
			__removeListeners();
			
			trace(e.text);
			
			if (onError) {
				onError();
			}
		}
		
		private function __uploadCompleted(e:Event):void {
			__removeListeners();
			__removeDados();
			
			if (onComplete) {
				onComplete();
			}
		}
		
		private function __removeListeners():void {
			loader.removeEventListener(Event.COMPLETE, __uploadCompleted);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, __onError);
		}
		
		private function __removeDados():void{
			jpgSource.dispose();
			jpgEncoder = null;
			jpgStream = null;
			request = null;
			loader = null;
		}
	}
}