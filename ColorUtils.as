package 
{

        public class ColorUtils
        {
        static private const HEXADECIMAL:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]; 
                
                public function ColorUtils() {}
                
                static public function INTtoRGB(color:int):Array
                {
                        var rgb:Array = new Array(3);
                        
                        rgb[0] = color >> 16;
                        rgb[1] = (color - (rgb[0] << 16)) >> 8;
                        rgb[2] = color - ((rgb[0] << 16) + (rgb[1] << 8));
                        
                        return rgb;
                }
                
                static public function RGBtoINT(rgb:Array):int
                {
                        return (rgb[0] << 16) + (rgb[1] << 8) + rgb[2];
                }
                
                static public function STRtoRGB(hex:String):Array
                {
                        return INTtoRGB(int("0x" + hex));
                }
                
                static public function STRtoINT(hex:String):int
                {
                        return parseInt(hex.substr(2, hex.length - 2), 16);
                }
                
                static public function INTtoSTR(color:int):String
                {
                        return "0x" + color.toString(16);
                }
                
                static public function RGBtoSTR(rgb:Array):String
                {
            var hex:String = ""; 
                        
                        for (var i:int = 0 ; i < rgb.length; i ++) 
                        { 
                                hex += HEXADECIMAL[int(rgb[i] / 16)] + HEXADECIMAL[rgb[i] % 16]; 
                        } 
                        
                        return hex;
                }
                
                static public function HSVtoRGB(hsv:Array):Array
                {
                        var rgb:Array = new Array(3), result:Array = new Array(3), cases:Number;

                        hsv[0] /= 255;
                        hsv[1] /= 255;
                        hsv[2] /= 255;
                        
                        if ( hsv[1] == 0 ) { rgb[0] = rgb[1] = rgb[2] = hsv[2] * 255; }
                        else
                        {
                                cases = ((hsv[0] * 6) < 6) ? hsv[0] * 6 : 0;
                                
                                result[0] = hsv[2] * ( 1 - hsv[1] );
                                result[1] = hsv[2] * ( 1 - hsv[1] * ( cases - int(cases) ) );
                                result[2] = hsv[2] * ( 1 - hsv[1] * ( 1 - ( cases - int(cases) ) ) );

                                cases = int(cases);
                                
                                if      ( cases == 0 ) { rgb[0] = hsv[2]        ; rgb[1] = result[2] ; rgb[2] = result[0]; }
                                else if ( cases == 1 ) { rgb[0] = result[1] ; rgb[1] = hsv[2]    ; rgb[2] = result[0]; }
                                else if ( cases == 2 ) { rgb[0] = result[0] ; rgb[1] = hsv[2]    ; rgb[2] = result[2]; }
                                else if ( cases == 3 ) { rgb[0] = result[0] ; rgb[1] = result[1] ; rgb[2] = hsv[2];    }
                                else if ( cases == 4 ) { rgb[0] = result[2] ; rgb[1] = result[0] ; rgb[2] = hsv[2];    }
                                else                   { rgb[0] = hsv[2]        ; rgb[1] = result[0] ; rgb[2] = result[1]; }

                                rgb[0] = int(rgb[0] * 255);
                                rgb[1] = int(rgb[1] * 255);
                                rgb[2] = int(rgb[2] * 255);
                        }
                        
                        return rgb;
                }
                
                static public function RGBtoHSV(rgb:Array):Array
                {
                        var hsv:Array = new Array(3), max:Number, min:Number, delta:Number;
                        
                        if ((rgb[0] == rgb[1]) && (rgb[1] == rgb[2])) { max = min = rgb[0]; }
                        else
                        {
                                if (rgb[0] > rgb[1])
                                {
                                        if (rgb[0] > rgb[2]) { max = rgb[0]; }
                                        else { max = rgb[2]; }
                                }
                                else
                                {
                                        if (rgb[1] > rgb[2]) { max = rgb[1]; }
                                        else { max = rgb[2]; }
                                }
                                
                                if (rgb[0] < rgb[1])
                                {
                                        if (rgb[0] < rgb[2]) { min = rgb[0]; }
                                        else { min = rgb[2]; }
                                }
                                else
                                {
                                        if (rgb[1] < rgb[2]) { min = rgb[1]; }
                                        else { min = rgb[2]; }
                                }
                        }
                                
                        rgb[0] = Number(rgb[0] / 255);
                        rgb[1] = Number(rgb[1] / 255);
                        rgb[2] = Number(rgb[2] / 255);
                        
                        max = Number(max / 255);
                        min = Number(min / 255);
                        
                        hsv[2] = max;
                        delta = max - min;
                        
                        if ( delta == 0 ) { hsv[0] = hsv[1] = 0; }
                        else
                        {
                           hsv[1] = delta / max;

                                var deltaRGB:Array = new Array(3);
                                   deltaRGB[0] = ( ( ( max - rgb[0] ) / 6 ) + ( delta / 2 ) ) / delta;
                                   deltaRGB[1] = ( ( ( max - rgb[1] ) / 6 ) + ( delta / 2 ) ) / delta;
                                   deltaRGB[2] = ( ( ( max - rgb[2] ) / 6 ) + ( delta / 2 ) ) / delta;
                                
                                if (max == rgb[0])              { hsv[0] = deltaRGB[2] - deltaRGB[1]; }
                                else if (max == rgb[1]) { hsv[0] = (1 / 3) + deltaRGB[0] - deltaRGB[2]; }
                                else if (max == rgb[2]) { hsv[0] = (2 / 3) + deltaRGB[1] - deltaRGB[0]; }
                        }
                        
                        hsv[0] = int(hsv[0] * 255);
                        hsv[1] = int(hsv[1] * 255);
                        hsv[2] = int(hsv[2] * 255);
                        
                        return hsv;
                }
                
                static public function HSV(hsv:Array):Array
                {
                        hsv[0] = int(hsv[0] * 360 / 255);
                        hsv[1] = int(hsv[1] * 100 / 255);
                        hsv[2] = int(hsv[2] * 100 / 255);
                        
                        return hsv;
                }
                
                static public function CMYKtoRGB(cmyk:Array):Array
                {
                        var rgb:Array = new Array(3);
                        
                        cmyk[0] /= 255;
                        cmyk[1] /= 255;
                        cmyk[2] /= 255;
                        cmyk[3] /= 255;
                        
                        rgb[0] = int(( 1 - ( cmyk[0] * ( 1 - cmyk[3] ) + cmyk[3] ) ) * 255);
                        rgb[1] = int(( 1 - ( cmyk[1] * ( 1 - cmyk[3] ) + cmyk[3] ) ) * 255);
                        rgb[2] = int(( 1 - ( cmyk[2] * ( 1 - cmyk[3] ) + cmyk[3] ) ) * 255);
                        
                        return rgb;
                }
                
                static public function RGBtoCMYK(rgb:Array):Array
                {
                        var cmyk:Array = new Array(4);
                        
                        cmyk[0] = 1 - rgb[0] / 255;
                        cmyk[1] = 1 - rgb[1] / 255;
                        cmyk[2] = 1 - rgb[2] / 255;
                        cmyk[3] = Math.min(cmyk[0], cmyk[1], cmyk[2]);
                        
                        cmyk[0] = ( cmyk[0] - cmyk[3] ) / ( 1 - cmyk[3] );
                        cmyk[1] = ( cmyk[1] - cmyk[3] ) / ( 1 - cmyk[3] );
                        cmyk[2] = ( cmyk[2] - cmyk[3] ) / ( 1 - cmyk[3] );
                        
                        cmyk[0] *= 255;
                        cmyk[1] *= 255;
                        cmyk[2] *= 255;
                        cmyk[3] *= 255;
                        
                        return cmyk;
                }
                
                static public function CMYK(cmyk:Array):Array
                {
                        cmyk[0] = int(cmyk[0] * 100 / 255);
                        cmyk[1] = int(cmyk[1] * 100 / 255);
                        cmyk[2] = int(cmyk[2] * 100 / 255);
                        cmyk[3] = int(cmyk[3] * 100 / 255);
                        
                        return cmyk;
                }               
        }
}
