package com.lexinote.models
{
	import jp.cre8system.framework.airrecord.model.ARAssociation;
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class Param extends ARModel
	{
		public var key:String;
		public var value:String;
	
		public function Param()
		{
			super();
			this.__table = "Params";
 		}
		
	}
}