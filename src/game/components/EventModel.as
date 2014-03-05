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
package game.components {
    import flash.events.Event;

    import game.model.Index;

    /**
     * Custom event for notification of changes in the model
     */
    public class EventModel extends Event {

        public static const MATRIX_CHANGE:String = "matrixChange";
        public static const TIME_CHANGE:String = "timeChange";
        public static const GAME_COMPLETE:String = "gameComplete";

        private var _numBox:int;
        private var _indx:Index;

        public function EventModel(type:String, numBox:int = 0, indx:Index = null, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);

            this._numBox = numBox;
            this._indx = indx;
        }

        public override function clone():Event {
            return new EventModel(type, _numBox, _indx, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("EventModel", "numBox", "indx", "bubbles", "cancelable", "eventPhase");
        }

        public function get numBox():int {
            return _numBox;
        }

        public function get indx():Index {
            return _indx;
        }
    }
}