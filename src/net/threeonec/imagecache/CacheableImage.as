package net.threeonec.imagecache
{
	import mx.controls.Image;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import mx.core.UIComponent;
	import mx.controls.Alert;
	import mx.utils.UIDUtil;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	//import com.adobe.crypto.*;
	public class CacheableImage extends UIComponent
	{
		private var imageRepository:ImageRepository;
		private var url:String;
		private var bitmapData:BitmapData;
		private var loader:Loader;
		
		
		//class constructor
		public function CacheableImage(){
			//create new loader
			loader = new Loader();
			//get instance of the image repository
			imageRepository = ImageRepository.getInstance();	
		}
		
		public function load(toLoad:String):void{
			//store the url
			url = toLoad;
			//check if the image has already been loaded
			//if(imageRepository.lookup(MD5.hash(url)) != null){
			if(imageRepository.lookup(url) != null){
				//if it has fetch the bitmapData
				bitmapData = BitmapData(imageRepository.lookup(url));
				//then draw it to the screen
				drawImage();
				dispatchEvent(new Event(Event.COMPLETE));
			}else{
				//otherwise load it
				var request:URLRequest = new URLRequest(url);
				loader.load(request);
				//complete event
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
				//httpStatusEvent
				loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventCapture, false, 0, true);
				//ioErrorEvent
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventCapture, false, 0, true);
				//openEvent
				loader.contentLoaderInfo.addEventListener(Event.OPEN, eventCapture, false, 0, true);
				//progress
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventCapture, false, 0, true);
				//unload
				loader.contentLoaderInfo.addEventListener(Event.UNLOAD, eventCapture, false, 0, true);
			}
		}
		
		public function unload():void{
			loader.unload();
		}
		
		//image is loaded
		private function onLoadComplete(e:Event):void{
			//fetch the bitmap out of the loaded image
			bitmapData = Bitmap(loader.content).bitmapData;
			//store it to the image repository
			//imageRepository.cacheImage( MD5.hash(url), bitmapData);
			imageRepository.cacheImage( url, bitmapData);
			//draw the image
			drawImage();
		}
		
		private function eventCapture(e:Event):void{
			dispatchEvent(e);
		}
		
		//draws the image to the screen
		private function drawImage():void{
			width = bitmapData.width;
			height = bitmapData.height;
			graphics.clear();
			graphics.beginBitmapFill(bitmapData);
			graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
			graphics.endFill();
		}
		
		public function set source(uri:String):void{
			if(uri == null || uri == "") {
				return;
			}
			load(uri);
		}
		
	}
}

