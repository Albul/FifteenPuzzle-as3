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

	public class BestsState extends BaseState {

        private var container:Sprite;

		private var panel:Sprite; // Skin panel
		private var bBackMenu:Button;
		private var tfTime:StyledTextField; // Displays the time
		private var tfSteps:StyledTextField; // Displays the amount of steps

		public function BestsState(container:Sprite) {
            this.container = container;

			panel = new Panel_design();

            var label:StyledText = StyledText.Create("Рекорды", 0, Styles.BIG_GREEN_TEXT);
            label.x = (panel.width - label.width) / 2;
            label.y = PADDING * 2;
            panel.addChild(label);

            var labelName:StyledText = StyledText.Create("Имя:", 20, Styles.ORANGE_TEXT);
            labelName.x = 40;
            labelName.y = label.y + label.height + PADDING;
            panel.addChild(labelName);

            var labelSteps:StyledText = StyledText.Create("Ходов:", 20, Styles.ORANGE_TEXT);
            labelSteps.x = 250;
            labelSteps.y = labelName.y;
            panel.addChild(labelSteps);

            var labelTime:StyledText = StyledText.Create("Время:", 20, Styles.ORANGE_TEXT);
            labelTime.x = 340;
            labelTime.y = labelName.y;
            panel.addChild(labelTime);

            tfTime = StyledTextField.Create(0, 0, Styles.BESTS_AREA);
            tfTime.x =  40;
            tfTime.y = labelSteps.y + labelSteps.height + PADDING;
            panel.addChild(tfTime);
            /*tfTime.textField.addEventListener(TextEvent.LINK, linkEvent);*/

            // Create button back to menu
			bBackMenu = Button.Create("Назад", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
			bBackMenu.x = (panel.width - bBackMenu.width) / 2;
			bBackMenu.y = tfTime.y + tfTime.height + PADDING;
            panel.addChild(bBackMenu);
            bBackMenu.addEventListener(MouseEvent.CLICK, bBackMenu_onMouseClick);
		}

        /*function linkEvent(event:TextEvent):void {
            trace(event.text);
            var link:URLRequest = new URLRequest(event.text);
            navigateToURL(link, "_blank");
        }*/
		
		private function bBackMenu_onMouseClick(e:MouseEvent):void {
			dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_MENU));
		}

//-------------------------------------------------------------------------------------------------
//
//  Overrides methods
//
//-------------------------------------------------------------------------------------------------

		/**
		 * When entering to the state shows the results
		 * @param params
		 */
		override public function enterState(params:Object = null):void {
            if (params != null) {
                if (params.hasOwnProperty("steps")) {
                    tfSteps.text = params.steps;
                }
                if (params.hasOwnProperty("time")) {
                    tfTime.text = params.time;
                }
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