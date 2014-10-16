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
package states {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

public class StateManager extends Sprite {

	public static const STATE_MENU:String = "stateMenu";
	public static const STATE_NEW_GAME:String = "stateNewGame";
	public static const STATE_RESULT:String = "stateResult";
	public static const STATE_BESTS:String = "stateBests";
	public static const STATE_ABOUT:String = "stateAbout";
	public static const STATE_EXIT:String = "stateExit";

	private var states:Object;
	private var currentState:BaseState;
	private var _stage:Stage;
	private var _container:Sprite;

	public function StateManager(stage:Stage, container:Sprite) {
		_stage = stage;
		_container = container;

		this.states =  {
			"stateMenu": new MenuState(container),
			"stateNewGame": new GameState(container),
			"stateBests": new BestsState(container),
			"stateResult": new ResultState(container),
			"stateAbout": new AboutState(container),
			"stateExit": new ExitState()
		};

		this.currentState = new BaseState();
		switchTo(states[STATE_MENU]);
		for each (var state:Sprite in states) {
			state.addEventListener(EventState.CHANGE_STATE, onChangeState);
		}
		_stage.addEventListener(Event.RESIZE, onResize);
		onResize(null);
	}

//-------------------------------------------------------------------------------------------------
//
//  Methods
//
//-------------------------------------------------------------------------------------------------

	public function switchTo(newState:BaseState, params:Object = null):void {
		if (newState == null){
			throw new Error("State is not found");
		}
		this.currentState.leaveState();
		this.currentState = newState;
		this.currentState.enterState(params);
	}

//-------------------------------------------------------------------------------------------------
//
//  Events handlers
//
//-------------------------------------------------------------------------------------------------

	private function onAddedToStage(e:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

	}

	private function onResize(e:Event):void {
		_container.x = (_stage.stageWidth - _container.width) / 2;
		_container.y = (_stage.stageHeight - _container.height) / 2;
	}

	private function onChangeState(e:EventState):void {
		switchTo(states[e.toState], e.params);
		onResize(null);
	}

//-------------------------------------------------------------------------------------------------
//
//  Getters
//
//-------------------------------------------------------------------------------------------------

	public function get current():BaseState {
		return currentState;
	}
}
}