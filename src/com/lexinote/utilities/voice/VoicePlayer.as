package com.lexinote.utilities.voice
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	import de.popforge.format.wav.WavFormat;
	
	import flash.utils.ByteArray;
	
	public class VoicePlayer
	{
		private var audioLoaded:Boolean = false;
		private var byteArray:ByteArray = new ByteArray();
		private var wave:WavFormat;
		private var phase: Number;
		private var endflag:Boolean = false;
	
		/**
		 * 
		 * 
		 */
		public function play(data:ByteArray):void {
	        wave = WavFormat.decode(data);
	        initAudioEngine();
		}
        
		private function initAudioEngine(): void {
			var buffer: AudioBuffer = new AudioBuffer(4, Audio.MONO, Audio.BIT16, Audio.RATE44100);
//			var buffer: AudioBuffer = new AudioBuffer(4, Audio.MONO, Audio.BIT16, Audio.RATE22050);
			buffer.onInit = onAudioBufferInit;
			buffer.onComplete = onAudioBufferComplete;
			phase = 0;
			endflag = false;
		}
		
		private function onAudioBufferInit( buffer: AudioBuffer ): void {
			buffer.start();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void {
			if(endflag) {
				buffer.stop();
			}
			//-- get array to store samples
			var samples: Array = buffer.getSamples();
			
			//-- some locals
			var output: Sample;
			var input: Sample;
			
			//-- compute speed
			var speed: Number = wave.rate / buffer.getRate();
			
			//-- CREATE ONE SECOND OF AUDIO (SINUS WAVE)
			for( var i: int = 0 ; i < samples.length ; i++ ) {
				//-- store local
				output = samples[i];
				input = wave.samples[ int( phase ) ];
	
				//-- write to sample
				output.left = input.left;
				output.right = input.right;
				
				//-- move pointer
				phase += speed;
				
				if( phase < 0 ) {
					phase += wave.samples.length;
				}
				else if( phase >= wave.samples.length ) {
					phase -= wave.samples.length;
					endflag = true;
				}
			}
			
//		filter.processAudio( samples );
	
			//-- update audio buffer
			buffer.update();
		}
	}
}