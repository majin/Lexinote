package net.threeonec.imagecache
{
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import mx.controls.Alert;
	
	dynamic public class ImageRepository
	{
		private static var _instance:ImageRepository;
		private static var _allowInstantiation:Boolean;
		
		
		
		public function ImageRepository():void{
			if(!_allowInstantiation){
				throw new Error("Cannot directory instantiate use getInstance method.");
			}
		}
		

		//Retrieves the singleton instance of ImageRepository.
		public static function getInstance():ImageRepository{
			if(_instance == null){
				_allowInstantiation = true;
				_instance = new ImageRepository();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		//this caches the iamge
		public function cacheImage(uid:String, data:BitmapData):void{
			this[uid] = data
		}
		
		//lookup
		public function lookup(uid:String):*{
			if(this[uid] == null){
				return null;
			}
			else{
				return this[uid];
			}
			return null;
		} 
	}
}