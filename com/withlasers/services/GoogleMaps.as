/*
	var mt:GoogleMaps = new GoogleMaps(653, 424, 'ABQIAAAAwGLWUdlPG5W2Kp1xPW34ixQosVkcbugzsmUymtCWWizKeUZnexRZryWziffcJORxLd3VPzdGw4H_7A')
	
	stage.addChild(mt)
	
	mt.addEventListener(GoogleMaps.ON_MAP_READY, function ():void 
	{
		mt.search('Rua Paranaguá, 754, São Paulo - SP')
	})
	
	mt.addEventListener(GoogleMaps.ON_SEARCH_RESULT, function ():void 
	{
		trace(mt.placeMarksResult);
		
		var pl:Placemark = mt.placeMarksResult[0] as Placemark //Resultados
		
		mt.setPosition(pl.point, 15)
		mt.addMarker(pl.point, pl.address, Seta) //Adicionara uma instancia de Seta no local
		//mt.addMarker(pl.point, pl.address )
	})
*/
	
package  com.withlasers.services
{
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.LatLng;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;
	import com.google.maps.services.Placemark;
	import com.google.maps.controls.ControlBase;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.PositionControlOptions;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.controls.ZoomControlOptions;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Fernando de França
	 */
	public class GoogleMaps extends Sprite
	{
		protected var map:Map;
		
		protected var __width:int = 100
		protected var __height:int = 100
		protected var __key:String
		protected var geoClient:ClientGeocoder;
		
		/**
		 * Resposta da busca, Array de PlaceMark
		 */
		public var placeMarksResult:Array
		
		public static const ON_MAP_READY:String = 'ON_MAP_READY'
		public static const ON_SEARCH_RESULT:String = 'ON_SEARCH_RESULT'
		public static const ON_SEARCH_ERROR:String = 'ON_SEARCH_ERROR'
		
		public function GoogleMaps($width:int, $height:int, $key:String) 
		{
			// setup
			__key = $key;
			__width = $width
			__height = $height
			
			map = new Map()
			map.key = __key
			addChild(map)
			width = __width;
			height = __height;
			
			
			// controles
			var ctrlPosition:PositionControl = new PositionControl(new PositionControlOptions( { position: new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 20) } ))
			var ctrlZoom:ZoomControl = new ZoomControl(new ZoomControlOptions( { position: new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 41, 90) } ));
			map.addControl(ctrlPosition);
			map.addControl(ctrlZoom);
			
			
			// aguarda disponibilizacao
			map.addEventListener(MapEvent.MAP_READY, __onMapReady)
			
		}
		
		protected function __onMapReady(e:MapEvent):void 
		{
			__setUpGeoCoder();
			
			dispatchEvent(new Event(ON_MAP_READY));
		}
		
		protected function __setUpGeoCoder():void
		{
			var myLatLngBounds:LatLngBounds = new LatLngBounds(new LatLng(11, 12), new LatLng(52, 68));
			geoClient = new ClientGeocoder("BR", myLatLngBounds);
			geoClient.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, __handleGeoCoding)
			geoClient.addEventListener(GeocodingEvent.GEOCODING_FAILURE, __handleGeoCoding)
		}
		
		protected function __handleGeoCoding($evt:GeocodingEvent):void 
		{
			placeMarksResult = null
			
			switch ($evt.type) 
			{
				case GeocodingEvent.GEOCODING_SUCCESS:
					placeMarksResult = $evt.response.placemarks;
					dispatchEvent(new Event(ON_SEARCH_RESULT));
				break
				
				case GeocodingEvent.GEOCODING_FAILURE:
					dispatchEvent(new Event(ON_SEARCH_ERROR));
				break
			}
		}
		
		public function search($endereco:String):void 
		{
			geoClient.geocode($endereco)
		}
		
		public function setPosition($latLng:LatLng, $zoom:Number):void 
		{
			map.setZoom($zoom, true)
			map.panTo($latLng);
		}
		
		public function addMarker($latLng:LatLng, $texto:String, $icone:Class=null ):void 
		{
			var marker:Marker 
			
			if ($icone!=null) 
			{
				marker = new Marker( $latLng,
					new MarkerOptions( { hasShadow:false, tooltip:$texto, icon:new $icone() } )
				);
			} else 
			{
				marker = new Marker( $latLng,
					new MarkerOptions( { hasShadow:false, tooltip:$texto } )
				);
			}
			
			map.addOverlay(marker);
		}
		
		
		
		override public function get width():Number { return __width; }
		override public function set width(value:Number):void 
		{
			__width = value;
			map.setSize(new Point(__width, __height));
		}
		
		
		override public function get height():Number { return __height; }
		override public function set height(value:Number):void 
		{
			__height = value;
			map.setSize(new Point(__width, __height));
		}
		
	}

}