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
package game.model {
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import game.components.EventModel;
import game.components.RandomArray;

public class Model extends EventDispatcher {

	public static const AMOUNT:int = 15;
	public static const ROWS:int = 4;
	public static const COLS:int = 4;

	private var _matrix:AMap;
	private var _time:int;
	private var _steps:int;

	private var timer:Timer;

	public function Model() {
		init();
	}

//-------------------------------------------------------------------------------------------------
//
//  Public methods
//
//-------------------------------------------------------------------------------------------------

	/**
	 * Try to move the box
	 * @param numBox
	 */
	public function tryChange(numBox:int):void {
		if (nearEmpty(numBox)) {
			_matrix.swap(0, numBox);
			_steps++;

			this.dispatchEvent(new EventModel(EventModel.MATRIX_CHANGE, numBox, _matrix.getIndex(numBox)));

			if (boxInPlace(numBox)) {
				this.dispatchEvent(new EventModel(EventModel.GAME_COMPLETE, NaN));
			}
		}
	}

//-------------------------------------------------------------------------------------------------
//
//  Private methods
//
//-------------------------------------------------------------------------------------------------

	private function init():void {
		_matrix = new AMap();
		// Create a random selection of the array of numbers
		var randArr:RandomArray = new RandomArray();
		randArr.createRandom(randArr.createArrayIndx(new Array(AMOUNT + 1)));

		// Create a matrix
		for (var i:int = 1; i <= ROWS; i++) {
			for (var j:int = 1; j <= COLS; j++) {
				this._matrix.put(i.toString() + "," + j.toString(), randArr.getRandomItem()) ;
			}
		}

		timer = new Timer(1000);
		timer.addEventListener(TimerEvent.TIMER, onTimer);
		timer.start();
	}

	/**
	 * @private
	 * Searching for an empty place near the box
	 */
	private function nearEmpty(numBox:int):Boolean
	{
		var indx:Index = this._matrix.getIndex(numBox);

		if ((this._matrix.getValue(indx.generateIndx(1, 0).index) == 0) // bottom
				|| (this._matrix.getValue(indx.generateIndx(-1, 0).index) == 0) // top
				|| (this._matrix.getValue(indx.generateIndx(0, 1).index) == 0) // right
				|| (this._matrix.getValue(indx.generateIndx(0, -1).index) == 0)) { // left
			return true;
		} else {
			return false;
		}
	}

	/**
	 * @private
	 * Checking the completion of the game
	 */
	private function boxInPlace(numBox:int):Boolean {
		var curI:int = _matrix.getIndex(numBox).i;
		var curJ:int = _matrix.getIndex(numBox).j;
		var origI:int = (numBox % 4 > 0? Math.floor(numBox / 4) + 1 : (numBox / 4) as int);
		var origJ:int = (numBox % 4 != 0)? (numBox % 4) : 4;
		if (curI == origI && curJ == origJ) { // If the current box is in place, then check all the boxes
			for (var i:int = 1; i <= Model.AMOUNT; i++) {
				curI = _matrix.getIndex(i).i;
				curJ = _matrix.getIndex(i).j;
				origI = (i % 4 > 0? Math.floor(i / 4) + 1 : (i / 4) as int);
				origJ = (i % 4 != 0)? (i % 4) : 4;
				if (curI != origI && curJ != origJ) { // If any out of place
					return false;
				}
			}
		}
		else {
			return false;
		}
		return true; // Returns true if everything in its place
	}

//-------------------------------------------------------------------------------------------------
//
//  Events handlers
//
//-------------------------------------------------------------------------------------------------

	private function onTimer(e:TimerEvent):void {
		this._time = timer.currentCount;
		this.dispatchEvent(new EventModel(EventModel.TIME_CHANGE, this._time));
	}

//-------------------------------------------------------------------------------------------------
//
//  Getters
//
//-------------------------------------------------------------------------------------------------

	public function get matrix():Object {
		return _matrix;
	}

	public function get steps():int {
		return _steps;
	}

	public function get results():Object {
		return {steps: _steps, time: _time};
	}
}
}