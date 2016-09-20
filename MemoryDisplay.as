package {
	import flash.display.*
	import flash.events.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	// registrar uma variavel com o valor mais alto e guardar
	// variaveis para cor, intervalo, largura, numero de registros
	//  // criar textfield com o valor atual
	// metodos hide / show
		// stop/start/remove
	
	public class MemoryDisplay extends Sprite {
		//public var __sp:Sprite
		
		public var w:Number
		public var h:Number
		public var maxItens:Number
		public var intervaloTempo:Number
		public var color:Number
		
		private var arrMem:Array
		private var highestValue:Number = 0
		private var timer:Timer
		
		private var grafico:Shape
		private var tfMem:TextField
		
		public function MemoryDisplay($width:Number = 200, $height:Number = 100, $intervalo:Number=1000, $color:Number=0xff9900){
			w = $width
			h = $height
			intervaloTempo = $intervalo;
			color = $color;
			
			maxItens = 20+1;
			
			arrMem = []
			
			
			grafico = new Shape();
			addChild(grafico);
			
			tfMem = new TextField();
			tfMem.width = 40;
			tfMem.height = 19;
			tfMem.y = h - tfMem.height;
			tfMem.textColor = 0x000000;
			tfMem.backgroundColor = 0xffffff;
			tfMem.background = true;
			tfMem.autoSize = TextFieldAutoSize.LEFT;
			
			addChild(tfMem);
			
			
			/* moldura */
			var moldura:Shape = new Shape();
			moldura.graphics.lineStyle(1, 0x000000, 1)
			moldura.graphics.moveTo(0, 0);
			moldura.graphics.lineTo(w, 0);
			moldura.graphics.lineTo(w, h);
			moldura.graphics.lineTo(0, h);
			moldura.graphics.lineTo(0, 0);
			moldura.graphics.endFill();
			addChild(moldura)
			
			
			//loop()
			timer = new Timer(intervaloTempo, 0);
			timer.addEventListener(TimerEvent.TIMER, __loop);
			timer.start()
		}
		
		private function __loop (e:*):void {
			var m:Number = System.totalMemory/1024/1024;
			
			tfMem.text = m.toFixed(2) + ' Mb'; //exibe texto
			
			if (m>highestValue) {
				highestValue = m; //determina ultimo valor mais alto
			}
			
			
			arrMem.push(m);
			
			if (arrMem.length>maxItens) {
				arrMem.shift();
			}
			
			var g:Graphics = grafico.graphics
			g.clear();
			g.beginFill(color, 1)
			g.moveTo(0, h);
			
			var v:Number
			var nh:Number // nova altura
			var uh:Number = w/(maxItens-1) // unidade horizontal
			
			for (var i:int = 0; i < arrMem.length; i++) {
				v = (arrMem[i] * h)/highestValue
				nh = h - v
				
				g.lineTo(i * uh, nh);
			}
			
			i--
			g.lineTo(i * uh, h)
			g.lineTo(0, h);
			g.lineTo(0, 0);
			g.endFill();
		}
	}
}