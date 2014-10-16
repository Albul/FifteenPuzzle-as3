/*
 * Copyright 2012 Alexandr Albul
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package game.components {

/**
 * A class for creating a random permutation of the array and its output
 */
public class RandomArray extends Object {

	public var isPrinted:Boolean;

	private var arrayIndx:Array;
	private var arrayData:Array;
	private var i:int;

	public function RandomArray() {
	}

//-------------------------------------------------------------------------------------------------
//
//  Public methods
//
//-------------------------------------------------------------------------------------------------

	/**
	 * Creating a random permutation
	 * @param array
	 */
	public function createRandom(array:Array):void {
		this.arrayData = array;
		this.arrayIndx = createArrayIndx(array);
		this.i = 0;
		this.isPrinted = false;

		var k:int = 0;
		while (k <= array.length * 2) {
			var r1:int = Math.random() * array.length;
			var r2:int = Math.random() * array.length;
			this.arrayIndx = swap(r1, r2, this.arrayIndx);
			k++;
		}
	}

	public function getRandomItem():* {
		var item:* = this.arrayData[this.arrayIndx[i]];
		if (i == arrayIndx.length - 1)
			isPrinted = true;
		i++;
		return item;
	}

	/**
	 * Create an array filled with the incoming array indexes
	 * @param array
	 * @return Array of indexes
	 */
	public function createArrayIndx(array:Array):Array {
		var arrResult:Array = new Array();
		for (var i:int = 0; i < array.length; i++) {
			arrResult.push(i);
		}
		return arrResult;
	}

	public function swap(indxItem1:int, indxItem2:int, array:Array):Array {
		var tmpItem:* = array[indxItem1];
		array[indxItem1] = array[indxItem2];
		array[indxItem2] = tmpItem;
		return array;
	}
}
}