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
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.setTimeout;
	import game.Controller;
	import game.components.EventModel;
    import game.model.Constants;

    import gui.Button;
    import gui.StyledText;
    import gui.Styles;

    public class GameState extends BaseState {

		private var controller:Controller;
        private var results:Object;

		private var container:Sprite;
        private var panel:Sprite;
        private var b2D:Button;
        private var b3D:Button;
        private var bBack:Button;

		public function GameState(container:Sprite) {
            this.container = container;

            panel = new Panel_design();

            var label:StyledText = StyledText.Create("Вариант игры:", 0, Styles.BIG_GREEN_TEXT);
            label.x = (panel.width - label.width) / 2;
            label.y = PADDING * 2;
            panel.addChild(label);

            b2D = Button.Create("Двухмерная 2D", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            b2D.x = (panel.width - b2D.width) / 2;
            b2D.y = label.y + label.height + PADDING * 3;
            panel.addChild(b2D);
            b2D.addEventListener(MouseEvent.CLICK, b2D_onMouseClick);

            b3D = Button.Create("Трехмерная 3D", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            b3D.x = (panel.width - b3D.width) / 2;
            b3D.y = b2D.y + b2D.height + PADDING;
            panel.addChild(b3D);
            b3D.addEventListener(MouseEvent.CLICK, b3D_onMouseClick);

            // Create button back to menu
            bBack = Button.Create("Назад", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bBack.x = (panel.width - bBack.width) / 2;
            bBack.y = b3D.y + b3D.height + PADDING;
            panel.addChild(bBack);
            bBack.addEventListener(MouseEvent.CLICK, bBack_onMouseClick);
		}

        private function createGame(dimensional:Boolean):void {
            results = new Object();
            controller = new Controller(container);
            controller.addEventListener(EventModel.GAME_COMPLETE, onGameComplete);
            controller.addEventListener(Controller.GAME_EXIT, onGameExit);
            controller.startGame(dimensional);
        }

        private function showResults():void {
            dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_RESULT, results));
        }

//-------------------------------------------------------------------------------------------------
//
//  Overrides methods
//
//-------------------------------------------------------------------------------------------------

		override public function enterState(params:Object = null):void {
            container.addChild(panel);
		}

		override public function leaveState():void {
            while (container.numChildren != 0) {
                container.removeChildAt(0);
            }
		}

//-------------------------------------------------------------------------------------------------
//
//  Events handlers
//
//-------------------------------------------------------------------------------------------------

		private function onGameComplete(e:EventModel):void {
			results = controller.results;
			setTimeout(showResults, 3000);
            controller.stopGame();
            controller = null;
		}

        private function onGameExit(e:Event):void {
            results = controller.results;
            showResults();
            controller.stopGame();
            controller = null;
        }

        private function b2D_onMouseClick(e:MouseEvent):void {
            container.removeChild(panel);
            createGame(Constants.d2);
        }

        private function b3D_onMouseClick(e:MouseEvent):void {
            container.removeChild(panel);
            createGame(Constants.d3);
        }

        private function bBack_onMouseClick(e:MouseEvent):void {
            dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_MENU));
        }

    }
}