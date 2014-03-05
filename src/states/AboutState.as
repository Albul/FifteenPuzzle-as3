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
    import flash.events.TextEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import gui.Button;
    import gui.StyledText;
    import gui.StyledTextField;
    import gui.Styles;

    public class AboutState extends BaseState {

        private var container:Sprite;

        private var panel:Sprite;
        private var bBack:Button;

        public function AboutState(container:Sprite) {
            this.container = container;
            panel = new Panel_design();

            var lTitle:StyledText = StyledText.Create("Об игре", 0, Styles.BIG_GREEN_TEXT);
            lTitle.x = (panel.width - lTitle.width) / 2;
            lTitle.y = PADDING * 2;
            panel.addChild(lTitle);

            var lAbout:StyledTextField = StyledTextField.Create(0, 0, Styles.ABOUT_AREA);
            lAbout.text = "<br> Игра создана и выложена на Github для обучения <br>"
                    + " подрастающего поколения.<br>"
                    + " Специально для сайта <a href='event:http://as3.com.ua'><strong>as3.com.ua</strong></a>"
            lAbout.x = 40;
            lAbout.y = lTitle.y + lTitle.height + 2 * PADDING;
            lAbout.textField.addEventListener(TextEvent.LINK, linkEvent);
            panel.addChild(lAbout);

            var lAuthor:StyledText = StyledText.Create("Автор: Александр Албул", 0, Styles.ORANGE_TEXT_LINK);
            lAuthor.x = (panel.width - lAuthor.width) / 2;
            lAuthor.y = lAbout.y + lAbout.height + PADDING;
            panel.addChild(lAuthor);

            var lSite:StyledText = StyledText.Create("Сайт: http://as3.com.ua", 20, Styles.ORANGE_TEXT_LINK);
            lSite.x = (panel.width - lSite.width) / 2;
            lSite.y = lAuthor.y + lAuthor.height + PADDING;
            lSite.addEventListener(MouseEvent.CLICK, lSite_onMouseClick);
            panel.addChild(lSite);

            bBack = Button.Create("Назад", Styles.MENU_BUTTON, Styles.ORANGE_TEXT);
            bBack.x = (panel.width - bBack.width) / 2;
            bBack.y = lSite.y + lSite.height + 2 * PADDING;
            panel.addChild(bBack);
            bBack.addEventListener(MouseEvent.CLICK, bBack_onMouseClick);
        }


//-------------------------------------------------------------------------------------------------
//
//  Event handlers
//
//-------------------------------------------------------------------------------------------------

        private function linkEvent(event:TextEvent):void {
            trace(event.text);
            var link:URLRequest = new URLRequest(event.text);
            navigateToURL(link, "_blank");
        }

        private function bBack_onMouseClick(e:MouseEvent):void {
            dispatchEvent(new EventState(EventState.CHANGE_STATE, StateManager.STATE_MENU));
        }

        private function lSite_onMouseClick(e:MouseEvent):void {
            var link:URLRequest = new URLRequest("http://as3.com.ua");
            navigateToURL(link, "_blank");
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

    }
}