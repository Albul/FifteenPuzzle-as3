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
package game.view {

import flash.display.Sprite;

import game.model.Constants;
import game.model.Model;

import gui.Button;

public class View extends Sprite {

	protected const DURATION:Number = 0.3;

	protected var _boxes:Array;
	protected var _bExit:Button;

	public function View() {
	}

//-------------------------------------------------------------------------------------------------
//
//  Public methods
//
//-------------------------------------------------------------------------------------------------

	public static function createView(model:Model, container:Sprite, dimensional:Boolean):View {
		var view:View = (dimensional == Constants.d2)? new View2D(model, container) :
				new View3D(model, container);
		return view;
	}

	public function dispouse():void {
	}

	public function get boxes():Array {
		return _boxes;
	}

	public function getNumBox(box:*):int {
		return NaN;
	}

	public function get bExit():Button {
		return _bExit;
	}
}
}