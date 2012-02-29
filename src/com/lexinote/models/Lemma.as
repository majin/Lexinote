package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARAssociation;
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class Lemma extends ARModel
	{
		public var spelling:String;
		public var family:String;

		public function Lemma()
		{
			super();
			this.__table = "Lemmas";
		}
		
	}
}