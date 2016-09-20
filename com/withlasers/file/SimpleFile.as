package com.withlasers.file
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * SimpleFile
	 * 
	 * usar sempre barras duplas no path
	 * C:\\Users\\log.txt
	 * 
	 * ou usar caminho relativo a app
	 * log.txt = C:\Users\Desktop\temp\FileReadWriteAppend\bin\log.txt
	 * 
	 * @author Fernando de França
	 */
	public class SimpleFile 
	{			
		// valida se é um path absoluto ou transforma em relativo caso nao tenha sido informado
		private static function _normalizePath(resourceUrl:String):String
		{
			var isPath:Boolean = resourceUrl.indexOf("\\") > -1;
			
			var ret:String
			
			if (!isPath)
			{
				ret = File.applicationDirectory.resolvePath(resourceUrl).nativePath;
			} else {
				ret = resourceUrl
			}
			
			return ret.split("\\").join("\\\\");
		}
		
		
		public static function fileExists(resourceUrl:String):Boolean
		{
			var file:File = new File(_normalizePath(resourceUrl));
			
			return file.exists;
		}
		
		public static function create(resourceUrl:String):void
		{
			if (!fileExists(resourceUrl)) overwrite(resourceUrl, "");
		}
		
		
		public static function overwrite(resourceUrl:String, content:String):void
        {
            var file:File = new File(_normalizePath(resourceUrl));
			
            var fs:FileStream = new FileStream();
            fs.open(file,FileMode.WRITE);
            fs.writeUTFBytes(content);
            fs.close();
        }
		
        public static function read(resourceUrl:String, startIndex:int = 0, endIndex:int = int.MAX_VALUE):String
        {
            var results:String;
            var file:File = new File(_normalizePath(resourceUrl));
			
            var fs:FileStream = new FileStream();
            fs.open(file,FileMode.READ);
            fs.position = startIndex;
			
            results = fs.readUTFBytes(Math.min(endIndex-startIndex, fs.bytesAvailable));
            fs.close();
			
            return results;
        }        
		
		public static function append(resourceUrl:String, content:String):void
        {
            var file:File = new File(_normalizePath(resourceUrl));
			
			
            var fs:FileStream = new FileStream();
            fs.open(file,FileMode.APPEND);
            fs.writeUTFBytes(content);
            fs.close();
        }
		
		public static function update(resourceUrl:String, content:String, startIndex:int = 0):void
        {
            var file:File = new File(_normalizePath(resourceUrl));
			
            var fs:FileStream = new FileStream();
            fs.open(file,FileMode.UPDATE);
            fs.position = startIndex;
            fs.writeUTFBytes(content);
            fs.close();
        }
		
		public static function get br():String 
		{
			return File.lineEnding;
		}
	}

}