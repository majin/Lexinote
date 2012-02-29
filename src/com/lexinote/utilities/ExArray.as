package com.lexinote.utilities
{
	public class ExArray
	{
		static public function shuffle(arr:Array):Array {
			var l:Number = arr.length;
			var newArr = arr;
			while(l){
				var m = Math.floor(Math.random()*l);
				var n = newArr[--l];
				newArr[l] = newArr[m];
				newArr[m] = n;
			}
			return newArr;
		}
	}
}