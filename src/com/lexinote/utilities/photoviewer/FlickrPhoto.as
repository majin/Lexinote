package com.lexinote.utilities.photoviewer
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class FlickrPhoto
	{
		// photo-id
		public var id:uint;
		// user-id
		public var user_id:String;
		// credit
		public var credit:String;
		// owner
		public var owner:String;
		
		public var secret:String;
		
		public var o_secret:String;
		
		public var server_id:uint;
		
		public var farm_id:uint;
		
		public var title:String;
		
		public var ispublic:Boolean;
		public var isfriends:Boolean;
		public var isfamily:Boolean;
		
		public var link:String;
		
		public var thumbnail:ImageData;
		public var content:ImageData;
		
		public var author:Array;
		
		public static const REGEXP_LINK_PATTERN:String = "http://www.flickr.com/photos/([^/]+?)/([^/]+)/";
		
		// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
		// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
		// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
		// 0: all  1: farm-id  2: server-id  3: id  4: secret  5: mstb  6: o-secret  7: jpg|gif|png
//		public static const REGEXP_PHOTOLINK_PATTERN:String = "http://farm(\\d+)\.static\.flickr\.com/([^/]+)/([^_]+)_(?:([^_]+)(?:_([mstb]))?\.jpg|([^_]+)_o\.(jpg|gif|png))";
		public static const REGEXP_PHOTOLINK_PATTERN:String = "http://farm(\\d+)\.staticflickr\.com/([^/]+)/([^_]+)_(?:([^_]+)(?:_([mstb]))?\.jpg|([^_]+)_o\.(jpg|gif|png))";
		
		public static const REGEXP_AUTHOR_PATTRERN:String = "([^\\s]+)\\s+\\(([^)]+)\\)";
		
		public static const IMAGESIZE_S:String = "s";
		public static const IMAGESIZE_T:String = "t";
		public static const IMAGESIZE_M:String = "m";
		public static const IMAGESIZE_B:String = "b";
		public static const IMAGESIZE_O:String = "o";
		
		public function FlickrPhoto(item:Object)
		{
			var matches:Array;
			
			this.title = item.title != null ? item.title[0] : "";
			this.link = item.link;
			
			matches = this.link.match(REGEXP_LINK_PATTERN);
			if (matches != null) {
				this.user_id = matches[1];
				this.id = uint(matches[2]);
			}
			this.credit = item.credit;
			
			matches = item.thumbnail.url.match(REGEXP_PHOTOLINK_PATTERN);
			this.farm_id = uint(matches[1]);
			this.server_id = uint(matches[2]);
			this.id = uint(matches[3]);
			this.secret = matches[4];
			
			// thumbnail
			this.thumbnail = new ImageData();
			this.thumbnail.url = item.thumbnail.url;
			this.thumbnail.width = uint(item.thumbnail.width);
			this.thumbnail.height = uint(item.thumbnail.height);
			
			matches = item.content.url.match(REGEXP_PHOTOLINK_PATTERN);
			if (matches)
			{
				this.o_secret = matches[6];
	
				// content
				this.content = new ImageData();
				this.content.url = item.content.url;
				this.content.width = uint(item.content.width);
				this.content.height = uint(item.content.height);
				this.content.suffix = matches[7];
			}
			
			// author
			matches = String(item.author).match(REGEXP_AUTHOR_PATTRERN);
			this.author = new Array();
			this.author.name = matches[2];
			this.author.email = matches[1];
			this.author.url = item.author["flickr:profile"];
			
			
			
			return;
//			for (var key:String in item) {
//				trace(key + " : " + item[key]);
//				for (var key2:String in item[key]) {
//					trace("\t" + key2 + " : " + item[key][key2]);
//				}
//			}
//			
			
			trace("=================================================");
			for (var key:String in this.author) {
				trace(key + " : " + this.author[key]);
			}
		}
		
//		public function getUrl(type:String):String {
//			var url:String = "http://farm" + this.farm_id + ".static.flickr.com/" + this.server_id + "/" + this.id + "_";
//			if (type == IMAGESIZE_S || type == IMAGESIZE_T || type == IMAGESIZE_M ||
//			    type == IMAGESIZE_B) {
//			    url += this.secret + "_" + type + ".jpg";
//			} else if (type == IMAGESIZE_O) {
//			    url += this.o_secret + "_o." + this.content.suffix;
//			} else {
//				url += this.secret + ".jpg";
//			}
//			
//			return url;
//		}
	}
}