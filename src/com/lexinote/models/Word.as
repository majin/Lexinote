package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARAssociation;
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class Word extends ARModel
	{
		public var id:Number;
		public var spelling:String;
		public var order_number:Number;
		public var standard_meaning:String;
		public var level:Number;
		public var familiarity:Number;
		public var istraining:Number;
		public var photo_uri:String;
		public var photo_comment:String;
		public var count:Number;
		public var created:Number;
		public var modified:Number;
		
		public var toeic_id:Number;

//		public var details:Array;
				
		public function Word()
		{
			super();
			this.__table = "Words";
            this.__recursive = 2;
            this.__hasMany = {
				"details": new ARAssociation("WordDetail", "word_id")
            };
		}
		
	}
}