package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARAssociation;
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class Log extends ARModel
	{
		public var id:Number;
		public var word_id:Number;
		public var spelling:String;
		public var category:String;
		public var module:String;
		public var action:String;
		public var data:String;
		public var ip:String;
		public var insertdate:String;
			
		public function Log()
		{
			super();
			this.__table = "Logs";
		}
		
	}
}