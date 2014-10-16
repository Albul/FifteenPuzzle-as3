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
package {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import states.StateManager;

[SWF(width = "807", height = "730", frameRate="60", backgroundColor = "#F6F5E0")]
public class Main extends Sprite {

	private var stateMng:StateManager;

	public function Main():void {
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;

		stateMng = new StateManager(stage, this);
	}
}
}