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
    import com.greensock.TweenMax;

    import flash.display.Sprite;
    import flash.media.Sound;

    import game.components.EventModel;
    import game.model.Index;
    import game.model.Model;

    import gui.Button;
    import gui.Message;
    import gui.StyledText;
    import gui.StyledTextField;
    import gui.Styles;

    public class View2D extends View {

        public static const GAP:uint = 5;
        public static const MARGIN_LEFT:uint = 38;
        public static const MARGIN_TOP:uint = 44;

        [Embed(source = "../../../asset/noise.mp3")] private var SoundStep:Class;

        private var soundStep:Sound; // Sound for the step

        private var _model:Model;

        private var board:Board_design;
        private var tfTime:StyledTextField; // Displays the time
        private var tfSteps:StyledTextField; // Displays the amount of steps
        private var container:Sprite;

        public function View2D(model:Model, container:Sprite) {
            super();
            _model = model;
            this.container = container;
            init();
        }


//-------------------------------------------------------------------------------------------------
//
//  Private methods
//
//-------------------------------------------------------------------------------------------------

        private function init():void {
            initSound();
            createBoard();
            createBoxes();
            arrangeBoxes();
            initListeners();
        }

        private function initSound():void {
            soundStep = (new SoundStep()) as Sound;
        }

        private function createBoard():void {
            board = new Board_design();
            container.addChildAt(board, 0);
            container.x = (container.stage.stageWidth - container.width) / 2;
            container.y = (container.stage.stageHeight - container.height) / 2;

            var labelSteps:StyledText = StyledText.Create("Ходов:", 22, Styles.ORANGE_TEXT);
            labelSteps.x = 530;
            labelSteps.y = 210;
            board.addChild(labelSteps);

            tfSteps = StyledTextField.Create(0, 0, Styles.TEXT_FIELD_VIEW2D);
            tfSteps.x =  labelSteps.x;
            tfSteps.y = labelSteps.y + labelSteps.height + GAP;
            board.addChild(tfSteps);

            var labelTime:StyledText = StyledText.Create("Времени:", 22, Styles.ORANGE_TEXT);
            labelTime.x = labelSteps.x;
            labelTime.y = tfSteps.y + tfSteps.height + 2 * GAP;
            board.addChild(labelTime);

            tfTime = StyledTextField.Create(0, 0, Styles.TEXT_FIELD_VIEW2D);
            tfTime.x =  labelSteps.x;
            tfTime.y = labelTime.y + labelTime.height + GAP;
            tfTime.text = "00:00";
            board.addChild(tfTime);

            _bExit = Button.Create("Выход", Styles.MENU_BUTTON, Styles.SMALL_ORANGE_TEXT);
            _bExit.x = labelSteps.x + 60;
            _bExit.y = tfTime.y + tfTime.height + 5 * GAP;
            board.addChild(_bExit);
        }

        private function createBoxes():void {
            _boxes = new Array();

            _boxes.push(0);
            _boxes.push(new Box01_design());
            _boxes.push(new Box02_design());
            _boxes.push(new Box03_design());
            _boxes.push(new Box04_design());
            _boxes.push(new Box05_design());
            _boxes.push(new Box06_design());
            _boxes.push(new Box07_design());
            _boxes.push(new Box08_design());
            _boxes.push(new Box09_design());
            _boxes.push(new Box10_design());
            _boxes.push(new Box11_design());
            _boxes.push(new Box12_design());
            _boxes.push(new Box13_design());
            _boxes.push(new Box14_design());
            _boxes.push(new Box15_design());
        }

        /**
         * @private
         * Arrange all the boxes according to the data model
         */
        private function arrangeBoxes():void {
            var
                    box:Sprite,
                    indx:Index;

            for (var i:int = 1; i <= Model.AMOUNT; i++) {
                indx = _model.matrix.getIndex(i);
                box = _boxes[i];
                box.buttonMode = true;
                box.x = MARGIN_LEFT + (indx.j - 1) * (box.width + GAP);
                box.y = MARGIN_TOP + (indx.i - 1) * (box.height + GAP);
                board.addChild(box);
            }
        }

        private function initListeners():void {
            _model.addEventListener(EventModel.MATRIX_CHANGE, onModelChange);
            _model.addEventListener(EventModel.GAME_COMPLETE, onGameComplete);
            _model.addEventListener(EventModel.TIME_CHANGE, onTimeChange);
        }

        /**
         * @private
         * Move the box according to its index
         */
        private function moveBox(box:Sprite, indx:Index, animate:Boolean = false):void {
            var
                    toX:int = MARGIN_LEFT + (indx.j - 1) * (box.width + GAP),
                    toY:int = MARGIN_TOP + (indx.i - 1) * (box.height + GAP);
            board.addChild(box);

            if (animate) {
                TweenMax.to(box, DURATION, { x:toX, y: toY } );
                soundStep.play();
            } else {
                box.x = toX;
                box.y = toY;
            }
        }

        override public function getNumBox(box:*):int {
            for (var i:int = 0; i < _boxes.length; i++) {
                if (_boxes[i] == box) {
                    return i;
                }
            }
            return NaN;
        }


//-------------------------------------------------------------------------------------------------
//
//  Event handlers
//
//-------------------------------------------------------------------------------------------------

        /**
         * @private
         * Handling model changes
         */
        private function onModelChange(e:EventModel):void {
            var box:Sprite = this._boxes[e.numBox];

            moveBox(box, e.indx, true);
            this.tfSteps.text = String(this._model.steps);
        }

        private function onTimeChange(e:EventModel):void {
            var min:int = e.numBox / 60;
            var sec:int = e.numBox % 60;
            this.tfTime.text = (min >= 10? min.toString(): "0" + min.toString()) + ":" +
                    (sec >= 10? sec.toString(): "0" + sec.toString());
        }

        private function onGameComplete(e:EventModel):void {
            var msg:Message = new Message("Вы победили!!!", 0x00ff00, 1, 3, 48, false, "Arial");
            msg.x = stage.stageWidth / 2;
            msg.y = stage.stageHeight / 2;
            stage.addChild(msg);
        }

        override public function dispouse():void {
            if (container.contains(board)) {
                container.removeChild(board);
            }
            board = null;
            _model.removeEventListener(EventModel.MATRIX_CHANGE, onModelChange);
            _model.removeEventListener(EventModel.GAME_COMPLETE, onGameComplete);
            _model.removeEventListener(EventModel.TIME_CHANGE, onTimeChange);
        }


//-------------------------------------------------------------------------------------------------
//
//  Getters
//
//-------------------------------------------------------------------------------------------------

        public function get model():Model {
            return this._model;
        }

        public function set model(value:Model):void {
            this._model = value;
        }

    }
}