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
package game {
import alternativa.engine3d.core.events.MouseEvent3D;
import alternativa.engine3d.objects.Mesh;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

import game.components.EventModel;
import game.model.Constants;
import game.model.Model;
import game.view.View;
import game.view.View3D;

public class Controller extends EventDispatcher {

	public static var GAME_EXIT:String = "gameExit";

	private var _container:Sprite;

	private var _model:Model;
	private var _view:View;

	public function Controller(container:Sprite) {
		this._container = container;
	}

//-------------------------------------------------------------------------------------------------
//
//  Public methods
//
//-------------------------------------------------------------------------------------------------

	public function startGame(dimensional:Boolean = false):void {
		_model = new Model();
		_view = View.createView(_model, _container, dimensional);

		if (dimensional == Constants.d2) {
			for (var i:int = 1; i < _view.boxes.length; i++) {
				_view.boxes[i].addEventListener(MouseEvent.CLICK, onMouseClick)
			}
		} else {
			for (var i:int = 1; i < _view.boxes.length; i++) {
				_view.boxes[i].addEventListener(MouseEvent3D.CLICK, onMouseClick)
				_view.boxes[i].addEventListener(MouseEvent3D.MOUSE_DOWN, box3d_onMouseDown)
			}
		}
		_view.bExit.addEventListener(MouseEvent.CLICK, onExitGame);
		_model.addEventListener(EventModel.GAME_COMPLETE, onGameComplete);
	}

	public function stopGame():void {
		_view.dispouse();
		_model = null;
		_view = null;
	}

//-------------------------------------------------------------------------------------------------
//
//  Event handlers
//
//-------------------------------------------------------------------------------------------------

	private function box3d_onMouseDown(e:MouseEvent3D):void {
		(_view as View3D).controller.stopMouseLook();
	}

	private function onMouseClick(e:Event):void {
		var target:*;
		if (e is MouseEvent3D) {
			target = Mesh(e.target);
		} else {
			target = Sprite(e.target);
		}
		var numBox:int = _view.getNumBox(target);
		_model.tryChange(numBox);
	}

	private function onGameComplete(e:EventModel):void {
		_model.removeEventListener(EventModel.GAME_COMPLETE, onGameComplete);
		_view.bExit.removeEventListener(MouseEvent.CLICK, onExitGame);
		this.dispatchEvent(new EventModel(EventModel.GAME_COMPLETE, NaN));
	}

	private function onExitGame(e:MouseEvent):void {
		_model.removeEventListener(EventModel.GAME_COMPLETE, onGameComplete);
		_view.bExit.removeEventListener(MouseEvent.CLICK, onExitGame);
		this.dispatchEvent(new Event(GAME_EXIT));
	}

//-------------------------------------------------------------------------------------------------
//
//  Getters
//
//-------------------------------------------------------------------------------------------------

	public function get results():Object {
		return this._model.results;
	}
}
}