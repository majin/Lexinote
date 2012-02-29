package com.lexinote.utilities
{
	public class LemmaManager
	{
		import com.lexinote.models.Lemma;
		static public function getLemmas(txt:String):Array{
			var ret:Array = new Array();
			var _lemmaModel:Lemma = new Lemma();
			var lemmas:Array = _lemmaModel.find({spelling: txt});
			if(lemmas == null || lemmas.length == 0) {
				ret[0] = txt;
				return ret;
			}

			ret[0] = txt;
			for(var i:Number=0; i<lemmas.length; i++) {
				ret[ret.length] = lemmas[i].family;
			}
			
			//文字数の長いものから順番に並べる
			ret.sort(sortOnLength);
			
			return ret;
		}
		
		static public function getWord(txt:String):String {
			var _lemmaModel:Lemma = new Lemma();
			var lemmas:Array = _lemmaModel.find({family: txt});
			if(lemmas == null || lemmas.length == 0) {
				return null;
			}
			return lemmas[0].spelling;
		}
		
		static private function sortOnLength(a:String, b:String):Number {
		    var aLength:Number = a.length;
		    var bLength:Number = b.length;
		
		    if(a.length > b.length) {
		        return -1;
		    } else if(a.length < b.length) {
		        return 1;
		    } else  {
		        //a.length == b.length
		        return 0;
		    }
		}
		

		static public function checkLemma(spelling:String, target:String):Boolean {
			var ls:Array = LemmaManager.getLemmas(spelling); //レマ一覧データを取得する
			var targets:Array = target.replace(/\t|\.|,|　/g, " ").split(" ");
			for(var i:Number=0; i<ls.length; i++) {
				for(var j:Number=0; j<targets.length; j++) {
					if(ls[i].toLowerCase() == targets[j].toLowerCase()) {
						return true;
					}
				}
			}
			return false;
		}
	}
}