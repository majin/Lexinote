package com.lexinote.utilities.voice
{
    import flash.errors.IOError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.media.Sound;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    
    import mx.controls.Alert;
    import mx.core.Application;
    
    import org.httpclient.*;
    import org.httpclient.events.*;
    import org.httpclient.http.*;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class VoiceAPILoader extends EventDispatcher
	{
		private var urlVariables:URLVariables = new URLVariables();
//		private var urlRequest:URLRequest = new URLRequest("http://192.20.225.55/tts/cgi-bin/nph-talk");
		private var urlRequest:URLRequest = new URLRequest("http://translate.google.com/translate_tts");
		private var urlLoader:URLLoader = new URLLoader();
		private var myText:String = "";
		public var data:ByteArray;  //e.target.data

		
		function VoiceAPILoader() {

			urlVariables.voice = "crystal";
			urlVariables.txt = "";
			urlVariables.speakButton = "SPEAK";
			
			urlRequest.method = URLRequestMethod.POST;

            var header:URLRequestHeader = new URLRequestHeader("Referer", "http://translate.google.com/");
//            var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");

			urlVariables.tl = "en";
			urlVariables.q = "";
			
			urlRequest.cacheResponse = false;
			urlRequest.useCache = false;
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.requestHeaders.push(header);

			urlRequest.data = urlVariables;
			
	        //URLLoaderでWAVファイルをByteArrayに読み込む
	        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	        
	        urlRequest.contentType = "application/octet-stream";
//			urlRequest.userAgent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MathPlayer 2.20; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.2)";
			urlRequest.userAgent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.125 Safari/533.4"
		}

		private var noOfMaxChars:int = 99;
		private var _sentences:Array = new Array();
		private var _idx:int = 0;
		private var _pidx:int = 0;
		
		private function divideText(str : String) : void
		{
			var substr : String;
			if (str.length >= noOfMaxChars)
			{
				substr = str.substring(0, noOfMaxChars + 1);
			}
			else
			{
				substr = str;
			}
		
			if (substr.charAt(substr.length - 1) != " " && str.length >= noOfMaxChars)
			{
				var index : int = substr.lastIndexOf(" ");
				substr = str.substring(0, index);
			}
		
			_sentences.push(substr);
		
			if (str.substring(substr.length + 1, str.length).length > 0)
			{
				divideText(str.substring(substr.length + 1, str.length));
			}
		}
		
		public function getVoiceData(txt:String):void {
			urlLoader.addEventListener(Event.COMPLETE, getVoiceDataCompleteHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);   
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ioErrorHandler, false, 0, true);

			txt = escapeWord(txt);
			myText = txt;
			divideText(txt);
			playStart(_sentences[_idx]);
		}
					
		private function playStart(txt:String):void {
			if(isCache(txt)) {
				if(_idx < _sentences.length-1) {
					_idx++;
					playStart(_sentences[_idx]);
				}else {
					play(_sentences[_pidx]);
				}
				return;
			}

//			urlVariables.txt = txt;
//			urlVariables.q = escapeMultiByte(txt.replace(/ /g, '+'));
			urlVariables.q = txt.replace(/ /g, '+');

			urlLoader.load(urlRequest);
		}

		private function escapeWord(txt:String):String {
			for(var i:Number=0; i<txt.length; i++) {
				if(txt.charCodeAt(i) > 255) {
					txt = txt.substr(0, i);
					break;
				}
			}
			txt = txt.replace( /\n/g, "" );
			txt = txt.replace( /\r/g, "" );
			txt = txt.replace( /\?/g, "." );

			return txt;
		}		
		private function getVoiceDataCompleteHandler(event:Event):void {
			writeCache(_sentences[_idx], event.target.data as ByteArray);
			
			if(_idx >= _sentences.length-1) {
				play(_sentences[_pidx]);
			}

			this.data = event.target.data as ByteArray;  //おそらく不要
			dispatchEvent(event);

			if(_idx < _sentences.length-1) {
				_idx++;
				playStart(_sentences[_idx]);
			}else {
				urlLoader.removeEventListener(Event.COMPLETE, getVoiceDataCompleteHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);   
 		        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ioErrorHandler);
			}

		}

		private function ioErrorHandler(event:Event):void {
			urlLoader.removeEventListener(Event.COMPLETE, getVoiceDataCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);   
            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ioErrorHandler);
			Alert.show("音声サービスにアクセスできませんでした。");
		}
		
		private function getVoicePath():File {
			var vrpath:File = File.userDirectory.resolvePath("VR");
			if(!vrpath.exists) {
				vrpath.createDirectory();
			}
			var voicepath:File = vrpath.resolvePath("voice");		
			if(!voicepath.exists) {
				voicepath.createDirectory();
			}
			return voicepath;
		}

		private function isCache(txt:String):Boolean {
			var voicepath:File = getVoicePath();
			var voicefile:File = voicepath.resolvePath(txt + ".mp3");
			if(!voicefile.exists) {
				return false;
			}
			return true;		
		}

		private function readCache(txt:String):ByteArray {
			var ret:ByteArray = new ByteArray();
			
			var voicepath:File = getVoicePath();
			var voicefile:File = voicepath.resolvePath(txt + ".mp3");
			if(!voicefile.exists) {
				return ret;
			}
			
			var stream:FileStream = new FileStream();
	        try {
				stream.open(voicefile, FileMode.READ);
				stream.readBytes(ret);
	        } catch (error:IOError) {
				trace(error.message);
	        } finally {
				stream.close();
	        }
	        
	        return ret;
		}

		private function writeCache(txt:String, data:ByteArray):Boolean {
			var voicepath:File = getVoicePath();
			var voicefile:File = voicepath.resolvePath(txt + ".mp3");
			if(voicefile.exists) {
				return false;
			}

			var stream:FileStream = new FileStream();
	        try {
				stream.open(voicefile, FileMode.WRITE);
				stream.writeBytes(data);
	        } catch (error:IOError) {
				trace(error.message);
				return false;
	        } finally {
				stream.close();
	        }
			
			return true;
		}
		import flash.media.SoundChannel;
	    private var channel:SoundChannel; 
		private function play(txt:String):Boolean {
			var voicepath:File = getVoicePath();
			var voicefile:File = voicepath.resolvePath(txt + ".mp3");
			if(!voicefile.exists) {
				return false;
			}
			
	        var request:URLRequest = new URLRequest("file://"+voicefile.nativePath);
	        var soundFactory:Sound = new Sound();

	        soundFactory.load(request);
			channel = soundFactory.play();
	        channel.addEventListener(Event.SOUND_COMPLETE, playEnd);
			return true;
		}
		
		private function playEnd(e:Event):void {
			if(_pidx < _sentences.length-1) {
				_pidx++;
				play(_sentences[_pidx]);
			}
		}
	}
}