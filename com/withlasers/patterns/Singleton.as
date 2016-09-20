package com.withlasers.patterns {
	
	public class Singleton {
		private static var __instance:Singleton
		private static var __allowInstance:Boolean = false
		
		public function Singleton():void {
			
			if (__instance != null && __allowInstance != true) {
				
				// não permite instanciar diretamente ou mais de uma vez
				throw(new Error('Obtenha a referencia pela funcao getInstance()'))
				
			}
		}
		
		
		public static function getInstance():Singleton {
			
			if (__instance == null) {
				__allowInstance = true;
				__instance = new Singleton();
				__allowInstance = false;
			}
			
				
			return __instance;
		}
	}
	
}