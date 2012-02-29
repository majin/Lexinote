package com.lexinote.utilities
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;  

	public class TextInputEx extends TextInput
	{
		private var thisStyle:CSSStyleDeclaration
        = new CSSStyleDeclaration("SampleTextInputCSS");
 
		//ExampleText表示時のText Color
		private const EXAMPLE_TEXT_COLOR:int = 0x939393;
		//入力時のText Color
		private const NORMAL_TEXT_COLOR:int = 0x000000;
 
		//sampleText プロパティ
		[Inspectable(defaultValue="入力してください。")]
		private var __exampleText:String;
		public function get exampleText():String {
			return __exampleText;
		}
		public function set exampleText(str:String):void {
			this.__exampleText = str;
			onInit(null);
		}
 
		//data プロパティをオーバーライド
		public override function get data():Object {
			//sampleTextが表示されていたら空文字列を返す
			if (this.text == this.__exampleText ) {
				return "";
			}
			else {
				return this.text;
			}
		}
		//コンストラクタ
		public function TextInputEx()
		{
			super();
			this.addEventListener(FocusEvent.FOCUS_IN,onFocusIn, false, 0, true);
			this.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut, false, 0, true);
			this.addEventListener(FlexEvent.INITIALIZE,onInit, false, 0, true);
		}
 
		//初期化
		private function onInit(event:Event):void {
			//sampleTextを表示させて文字をグレー表示する
			this.text = this.__exampleText;
			thisStyle.setStyle("color", this.EXAMPLE_TEXT_COLOR);
			StyleManager.setStyleDeclaration(this.className,thisStyle,true);
		}
		//Focus In
		private function onFocusIn(event:Event):void {
 			//Textを空文字にして色を通常の色に設定する
			if (this.text == this.__exampleText) {
				this.text = "";
				thisStyle.setStyle("color",this.NORMAL_TEXT_COLOR);
				StyleManager.setStyleDeclaration(this.className,thisStyle,true);
			}
		}
		//Focus Out
		private function onFocusOut(event:Event):void {
			//Textが空文字だったらExampleTextを設定してグレー表示にする
			if (this.text == "") {
				thisStyle.setStyle("color",this.EXAMPLE_TEXT_COLOR);
				StyleManager.setStyleDeclaration(this.className,thisStyle,true);
				this.text = this.__exampleText;
			}
		}
	}
}