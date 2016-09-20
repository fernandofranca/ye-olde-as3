/**
 * Meu id 37815998@N08
 * api key f499c20aec047ecaef010fc3d5bfb191
 */

package com.withlasers.services
{
	import com.adobe.crypto.MD5;
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.methodgroups.PhotoSets;
	import flash.events.EventDispatcher;
	import nl.demonsters.debugger.MonsterDebugger;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class Flickr extends EventDispatcher
	{
		private var svc:FlickrService;
		
		/**
		 * Array de Photos
		 */
		public var signalGetPhotos:Signal = new Signal(Array);
		
		/**
		 * Resposta do busca de user
		 */
		public var signalFindUser:Signal = new Signal(User);
		
		public function Flickr($api_key:String) 
		{
			svc = new FlickrService($api_key)
		}
		
		/**
		 * Lista as galerias do usuario / dispara um signal com array de Photosets
		 * @param	$user_id
		 * @return
		 */
		public function galleriesList($user_id:String):Signal 
		{
			new NativeSignal(svc, FlickrResultEvent.PHOTOSETS_GET_LIST).addOnce(__handleGalleriesList);
			svc.photosets.getList($user_id);
			
			return signalGetPhotos;
		}
			
			private function __handleGalleriesList(e:FlickrResultEvent):void
			{
				signalGetPhotos.dispatch(e.data.photoSets);
			}
		
		/**
		 * Lista as fotos de uma galeria / dispara um signal com array de Photos
		 * @param	$gallery_id
		 * @return
		 */
		public function galleryGetPhotos($gallery_id:String):Signal 
		{
			svc.photosets.getPhotos($gallery_id);
			
			new NativeSignal(svc, FlickrResultEvent.PHOTOSETS_GET_PHOTOS).addOnce(__handleGetPhotos);
			
			return signalGetPhotos;
		}
			
			private function __handleGetPhotos(e:FlickrResultEvent):void
			{
				signalGetPhotos.dispatch(e.data.photoSet.photos);
			}
		
		/**
		 * Busca fotos por usuario, texto, tags / dispara um signal com array de Photos
		 * @param	$user_id
		 * @param	$texto
		 * @param	$tags
		 * @param	$results
		 * @return
		 */
		public function search($user_id:String='', $texto:String='', $tags:String='', $results:Number=100):Signal
		{
			// id do usuario no flickr // http://flickrseek.com/?t=gid
			
			new NativeSignal(svc, FlickrResultEvent.PHOTOS_SEARCH).addOnce(__handleSearch);
			
			svc.photos.search($user_id, $tags, 'any', $texto, null, null, null, null, -1, 'o_dims,rotation,original_format,media,icon_server,views', $results); 
			
			return signalGetPhotos;
		}
			
			private function __handleSearch(e:FlickrResultEvent):void
			{
				signalGetPhotos.dispatch(e.data.photos.photos);
			}
		
		/**
		 * Retorna a url da foto
		 * @param	photo
		 * @param	size	0=thumb quadrada, 1=thumb proporcional, 2=pequena, 3=media, 4=grande, 5=original
		 * @return
		 */
		public function getPhotoUrl(photo:Photo, size:int=0):String
		{
			var baseURL:String = 'http://farm' + photo.farmId + '.static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret;
			
			var s:String = '';
			
			switch (size) 
			{
				case 0:
					s = '_s'; // thumb quadrada
				break
				
				case 1:
					s = '_t'; // thumb proporcional
				break
				
				case 2:
					s = '_m'; // pequena
				break
				
				case 3:
					s = ''; // media
				break
				
				case 4:
					s = '_b'; // grande
				break
				
				case 5:
					s = '_o'; // original
				break
			}
			
			var URL:String = baseURL + s+'.jpg';
			
			return URL
		}
		
		/**
		 * Busca um usuario pelo nome / dispara um signal com um objeto User
		 * @param	$username
		 */
		public function findByUsername($username:String):Signal 
		{
			new NativeSignal(svc, FlickrResultEvent.PEOPLE_FIND_BY_USERNAME).addOnce(__handleFindByUsername);
			svc.people.findByUsername($username);
			
			return signalFindUser
		}
			
			private function __handleFindByUsername(e:FlickrResultEvent):void
			{
				signalFindUser.dispatch(e.data.user);
			}
	}

}