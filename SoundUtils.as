package {
	import flash.utils.ByteArray;
	import flash.media.SoundMixer;
	
	public class SoundUtils {
		
		private static var maxPeak:Number = 0
		private static var peak:Number = 0
		private static var ba:ByteArray = new ByteArray();
		/**
		 * Retorna o pico do audio geral
		 */
		public static function getPeak():Number {
			
			if (SoundMixer.areSoundsInaccessible()) {
				return Math.random();
			}
			
			SoundMixer.computeSpectrum(ba, true, 0);
			
			peak = 0;
			ba.position = 0;
			
			while (ba.position<512) {
				peak += ba.readUnsignedByte()
				ba.position++
			}
			
			if (peak>maxPeak) maxPeak = peak
			
			peak = peak / maxPeak; //v = v / (512 * 64);
			
			if (isNaN(peak) ) peak = 0;
			
			return peak
		}
	}
	
}