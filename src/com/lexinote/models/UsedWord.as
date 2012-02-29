package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARAssociation;
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class UsedWord extends ARModel
	{
		public var word_id:Number;
		public var used_id:Number;
		public var usedspelling:String;

		public function UsedWord()
		{
			super();
			this.__table = "UsedWords";
		}
		
	}
}