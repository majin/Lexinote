package com.lexinote.utilities.photoviewer
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class FlickrPhotoFeeds {
		
		public static const FEEDS_URL:String = "http://api.flickr.com/services/feeds/photos_public.gne";
		
		private static var service:HTTPService;
		private static var parameters:Object;
		
		public static var searchText:String = "";
		
		[Bindable]
		public static var photoFeeds:ArrayCollection = new ArrayCollection();
		
		// 初期化
		private static const STATIC_BLOCK:Boolean = staticBlock();
		private static function staticBlock():Boolean {
			service = new HTTPService();
			service.url = FEEDS_URL;
			service.showBusyCursor = true;
			service.addEventListener(ResultEvent.RESULT, sendCompleteHandler, false, 0, true);
			service.addEventListener(FaultEvent.FAULT, sendFaultHandler, false, 0, true);
			
			parameters = new Object();
			parameters.format = "rss_200";
			parameters.lang = "en-us";
			parameters.tags = "";
			
			return true;
		}
		
		public function FlickrPhotoFeeds() {
		}
		
		public static function searchPhoto(searchText:String):void {
			searchText = searchText;
			parameters.tags = searchText;
			
			if (parameters.tags != "" && parameters.tags != null) {
				service.send(parameters);
			}
		}
		
		public static function sendCompleteHandler(event:ResultEvent):void {
			var items:ArrayCollection = event.result.rss.channel.item as ArrayCollection;
			var collection:ArrayCollection = new ArrayCollection();
			
			for (var key:String in items) {
				collection.addItem(new FlickrPhoto(items[key]));
			}
			
			photoFeeds = collection;
		}
		
		public static function sendFaultHandler(event:FaultEvent):void {
		}

	}
}