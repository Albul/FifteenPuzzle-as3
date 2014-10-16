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
import flash.events.MouseEvent;

import gui.Button;
import gui.StyledText;
import gui.StyledTextField;
import gui.Styles;

public class ResultState extends BaseState {

	private var container:Sprite;

	private var panel:Sprite;
	private var bBackMenu:Button;
	private var tfTime:StyledTextField;
	private var tfSteps:StyledTextField;

	public function ResultState(container:Sprite) {
		this.container = container;
		panel = new Panel_design();

		var label:StyledText = StyledText.Create("Результаты", 0, Styles.BIG_GREEN_TEXT);
		label.x = (panel.width - label.width) / 2;
		label.y = PADDING * 2;
		panel.addChild(label);

		var labelSteps:StyledText = StyledText.Create("Хода:", 42, Styles.ORANGE_TEXT);
		labelSteps.y = label.y + label.height + PADDING;
		panel.addChild(labelSteps);

		tfSteps = StyledTextField.Create(0, 0, Styles.TEXT_FIELD);
		tfSteps.x =  (panel.width - tfSteps.width) / 2;
		tfSteps.y = labelSteps.y + labelSteps.height + PADDING / 3;
		tfSteps.text = "100";
		panel.addChild(tfSteps);

		labelSteps.x = tfSteps.x;

		var labelTime:StyledText = StyledText.Create("Время:", 42, Styles.ORANGE_TEXT);
		labelTime.x = tfSteps.x;
		labelTime.y = tfSteps.y + tfSteps.height + PADDING * 2;
		panel.addChild(labelTime);

		tfTime = StyledTextField.Create(0, 0, Styles.TEXT_FIELD);
		tfTime.x =  (panel.width - tfSteps.width) / 2;
		tfTime.y = labelTime.y + labelTime.height + PADDING / 3;
		tfTime.text = "100";
		panel.addChild(tfTime);

		bBackMenu = Button.Create("Назад", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
		bBackMenu.x = (panel.width - bBackMenu.width) / 2;
		bBackMenu.y = tfTime.y + tfTime.height + PADDING * 3;
		panel.addChild(bBackMenu);
		bBackMenu.addEventListener(MouseEvent.CLICK, bBackMenu_onMouseClick);
	}

	private function bBackMenu_onMouseClick(e:MouseEvent):void {
		dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_MENU));
	}

//-------------------------------------------------------------------------------------------------
//
//  Overrides methods
//
//-------------------------------------------------------------------------------------------------

	override public function enterState(params:Object = null):void {
		if (params.hasOwnProperty("steps")) {
			tfSteps.text = params.steps;
		}
		if (params.hasOwnProperty("time")) {
			tfTime.text = params.time;
		}
		container.addChild(panel);
	}

	override public function leaveState():void {
		while (container.numChildren != 0) {
			container.removeChildAt(0);
		}
	}
}
}