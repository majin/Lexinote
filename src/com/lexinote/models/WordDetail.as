package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	import jp.cre8system.framework.airrecord.model.ARAssociation;

	public class WordDetail extends ARModel
	{
		public var word_id:Number;
		public var order_number:Number;
		public var wordclass:String;
		public var meaning:String;
		public var example:String;
		public var definition:String;
		public var relatedword:String;
		public var yourproduction:String;
		public var created:Number;
		public var modified:Number;

		public function WordDetail()
		{
			//TODO: implement function
			super();
			this.__table = "WordDetails";
			this.__belongsTo = {
				"Words": new ARAssociation("Word", "id")
			};

		}
		
	}
}