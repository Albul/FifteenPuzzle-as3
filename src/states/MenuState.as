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
    import gui.Styles;

    public class MenuState extends BaseState {
        private var container:Sprite;

        private var panel:Sprite;
        private var bNewGame:Button;
        private var bRecords:Button;
        private var bAbout:Button;
        private var bExit:Button;

        public function MenuState(container:Sprite) {
            this.container = container;

            panel = new Panel_design();

            var label:StyledText = StyledText.Create("Главное меню", 0, Styles.BIG_GREEN_TEXT);
            label.x = (panel.width - label.width) / 2;
            label.y = PADDING * 2;
            panel.addChild(label);

            bNewGame = Button.Create("Новая игра", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bNewGame.x = (panel.width - bNewGame.width) / 2;
            bNewGame.y = label.y + label.height + PADDING * 5;
            bNewGame.addEventListener(MouseEvent.CLICK, onMouseClick);
            panel.addChild(bNewGame);

            bRecords = Button.Create("Рекорды", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bRecords.x = (panel.width - bRecords.width) / 2;
            bRecords.y = bNewGame.y + bNewGame.height + PADDING;
            bRecords.addEventListener(MouseEvent.CLICK, onMouseClick);
            panel.addChild(bRecords);

            bAbout = Button.Create("Об игре", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bAbout.x = (panel.width - bAbout.width) / 2;
            bAbout.y = bRecords.y + bRecords.height + PADDING;
            bAbout.addEventListener(MouseEvent.CLICK, onMouseClick);
            panel.addChild(bAbout);

            bExit = Button.Create("Выход", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bExit.x = (panel.width - bExit.width) / 2;
            bExit.y = bAbout.y + bAbout.height + PADDING;
            bExit.addEventListener(MouseEvent.CLICK, onMouseClick);
            panel.addChild(bExit);
        }

//-------------------------------------------------------------------------------------------------
//
//  Event handlers
//
//-------------------------------------------------------------------------------------------------

        private function onMouseClick(e:MouseEvent):void {
            switch (Object(e.currentTarget).title) {
                case "Новая игра":
                    dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_NEW_GAME));
                    break;
                case "Рекорды":
                    dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_BESTS));
                    break;
                case "Об игре":
                    dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_ABOUT));
                    break;
                case "Выход":
                    dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_EXIT));;
                    break;
            }
        }

        override public function enterState(params:Object = null):void {
            container.addChild(panel);
        }

        override public function leaveState():void {
            while (container.numChildren != 0) {
                container.removeChildAt(0);
            }
        }

    }
}