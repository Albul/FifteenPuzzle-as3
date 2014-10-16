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
import alternativa.engine3d.controllers.SimpleObjectController;
import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Resource;
import alternativa.engine3d.core.View;
import alternativa.engine3d.lights.AmbientLight;
import alternativa.engine3d.lights.DirectionalLight;
import alternativa.engine3d.loaders.ParserA3D;
import alternativa.engine3d.materials.StandardMaterial;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.materials.VertexLightTextureMaterial;
import alternativa.engine3d.objects.Mesh;
import alternativa.engine3d.objects.SkyBox;
import alternativa.engine3d.resources.BitmapTextureResource;
import alternativa.engine3d.shadows.DirectionalLightShadow;

import com.greensock.TweenMax;

import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.display3D.Context3D;
import flash.display3D.Context3DClearMask;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;

import game.components.EventModel;
import game.model.Index;
import game.model.Model;

import gui.Button;
import gui.Message;
import gui.StyledText;
import gui.StyledTextField;
import gui.Styles;

public class View3D extends game.view.View {

	[Embed(source = "../../../asset/models15.A3D", mimeType = "application/octet-stream")]
	private static const Models15:Class;

	[Embed(source="../../../asset/images/15_diffuse.jpg")] private var FifteenDiffuse:Class;
	[Embed(source="../../../asset/images/15_normal.jpg")] private var FifteenNormal:Class;

	public static const GAP:uint = 3;

	[Embed(source = "../../../asset/noise.mp3")] private var SoundStep:Class;

	private var soundStep:Sound;

	public var controller:SimpleObjectController;
	private var _model:Model;

	private var panel:Sprite;
	private var container:Sprite;
	private var tfTime:StyledTextField;
	private var tfSteps:StyledTextField;

	private var camera:Camera3D;
	private var stage3D:Stage3D;
	private var context:Context3D;
	private var cameraContainer:Object3D;
	private var scene:Object3D;

	private var sunLight:DirectionalLight;
	private var shadow:DirectionalLightShadow;
	private var materialBoard:StandardMaterial;
	private var materialBox:VertexLightTextureMaterial;

	// SkyBox textures
	[Embed(source="../../../asset/skybox/left.jpg")] private var SkyLeft:Class;
	[Embed(source="../../../asset/skybox/right.jpg")] private var SkyRight:Class;
	[Embed(source="../../../asset/skybox/back.jpg")] private var SkyBack:Class;
	[Embed(source = "../../../asset/skybox/front.jpg")] private var SkyFront:Class;
	[Embed(source = "../../../asset/skybox/bottom.jpg")] private var SkyBottom:Class;
	[Embed(source = "../../../asset/skybox/top.jpg")] private var SkyTop:Class;
	private var skyBox:SkyBox;
	private var ambientLight:AmbientLight;

	public function View3D(model:Model, container:Sprite) {
		this._model = model;
		this.container = container;
		container.x = 0;
		container.y = 0;
		init();
	}

//-------------------------------------------------------------------------------------------------
//
//  Private methods
//
//-------------------------------------------------------------------------------------------------

	private function init():void {
		initEngine();
		initLights();
		initMaterials();
		initSky();
		initModels();
		arrangeBoxes();
		initGUI();
		initSound();
		initContext();
		initListeners();

		if (context != null) {
			onResize(null);
		}
	}

	private function initContext():void {
		stage3D = container.stage.stage3Ds[0];
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
		stage3D.requestContext3D();
	}

	private function onContextCreate(e:Event):void {
		context = stage3D.context3D;
		for each (var resource:Resource in scene.getResources(true)) {
			resource.upload(stage3D.context3D);
		}
		if (camera && controller) {
			onResize(null);
		}
	}

	private function initEngine():void {
		container.stage.scaleMode = StageScaleMode.NO_SCALE;
		container.stage.align = StageAlign.TOP_LEFT;
		container.stage.quality = StageQuality.HIGH;

		camera = new Camera3D(1, 1000);
		camera.view = new alternativa.engine3d.core.View(807, 700, false, 0x000000);
		camera.view.antiAlias = 8;
		camera.view.hideLogo();
		container.stage.addChild(camera.view);
		camera.z = -100;

		scene = new Object3D();
		cameraContainer = new Object3D();
		cameraContainer.addChild(camera);
		scene.addChild(cameraContainer);

		controller = new SimpleObjectController(camera.view, cameraContainer, 400);
		controller.lookAtXYZ(0, 0, 0);
		controller.unbindAll();
		cameraContainer.rotationX = -130 * Math.PI / 180;
		controller.updateObjectTransform();
	}

	private function initLights():void {
		ambientLight = new AmbientLight(0x444444);
		ambientLight.intensity = 1;
		scene.addChild(ambientLight);

		sunLight = new DirectionalLight(0xf0a060);
		sunLight.x = -80;
		sunLight.y = 100;
		sunLight.z = 400;
		sunLight.intensity = 0.7;
		sunLight.lookAt(0, 0, 0);
		scene.addChild(sunLight);

		shadow = new DirectionalLightShadow(200, 220, -100, 100, 2048, 1);
		sunLight.shadow = shadow;
		shadow.centerX = 0;
		shadow.centerY = 0;
		/*shadow.debug = true;
		 shadow.biasMultiplier = 0.999;*/
	}

	private function initMaterials():void {
		var fifteenDiffuse:BitmapTextureResource = new BitmapTextureResource(new FifteenDiffuse().bitmapData);
		var fifteenNormal:BitmapTextureResource = new BitmapTextureResource(new FifteenNormal().bitmapData);
		materialBoard = new StandardMaterial(fifteenDiffuse, fifteenNormal);
		materialBoard.specularPower = 0.04;

		materialBox = new VertexLightTextureMaterial(fifteenDiffuse);
	}

	private function initSky():void {
		var skyLeft:BitmapTextureResource = new BitmapTextureResource(new SkyLeft().bitmapData);
		var skyRight:BitmapTextureResource = new BitmapTextureResource(new SkyRight().bitmapData);
		var skyBack:BitmapTextureResource = new BitmapTextureResource(new SkyBack().bitmapData);
		var skyFront:BitmapTextureResource = new BitmapTextureResource(new SkyFront().bitmapData);
		var skyBottom:BitmapTextureResource = new BitmapTextureResource(new SkyBottom().bitmapData);
		var skyTop:BitmapTextureResource = new BitmapTextureResource(new SkyTop().bitmapData);

		skyBox = new SkyBox(8000, new TextureMaterial(skyLeft), new TextureMaterial(skyRight),
				new TextureMaterial(skyBack), new TextureMaterial(skyFront),
				new TextureMaterial(skyBottom), new TextureMaterial(skyTop), 0.0005);

		scene.addChild(skyBox);
	}

	private function initModels():void {
		var parser:ParserA3D = new ParserA3D();
		parser.parse(new Models15());
		_boxes = new Array();

		var count:uint = parser.hierarchy.length;

		for (var i:uint = 0; i < count; i++) {
			var mesh:Mesh = parser.hierarchy[i] as Mesh;
			if (mesh == null) continue;
			if (mesh.name.substring(0, 3) == "Box") {
				_boxes[int(mesh.name.substring(3, 5))] = mesh;
				mesh.setMaterialToAllSurfaces(materialBox);
				mesh.useHandCursor = true;
			} else if (mesh.name.substring(0, 5) == "Board") {
				cameraContainer.x = mesh.x;
				cameraContainer.y = mesh.y;
				cameraContainer.z = mesh.z;
				controller.updateObjectTransform();
				mesh.setMaterialToAllSurfaces(materialBoard);
			}

			shadow.addCaster(mesh);
			scene.addChild(mesh);
		}
	}

	private function initGUI():void {
		panel = new Sprite();
		panel.graphics.beginFill(0xf6d76e, 0.8);
		panel.graphics.drawRoundRect(0, 0, 150, 220, 15, 15);
		panel.graphics.endFill();
		panel.x = 0;
		panel.y = 0;

		var labelSteps:StyledText = StyledText.Create("Ходов:", 18, Styles.ORANGE_TEXT);
		labelSteps.x = 20;
		labelSteps.y = 10;
		panel.addChild(labelSteps);

		tfSteps = StyledTextField.Create(0, 0, Styles.TEXT_FIELD_VIEW3D);
		tfSteps.x =  labelSteps.x;
		tfSteps.y = labelSteps.y + labelSteps.height + GAP;
		panel.addChild(tfSteps);

		var labelTime:StyledText = StyledText.Create("Времени:", 18, Styles.ORANGE_TEXT);
		labelTime.x = labelSteps.x;
		labelTime.y = tfSteps.y + tfSteps.height + 2 * GAP;
		panel.addChild(labelTime);

		tfTime = StyledTextField.Create(0, 0, Styles.TEXT_FIELD_VIEW3D);
		tfTime.x =  labelSteps.x;
		tfTime.y = labelTime.y + labelTime.height + GAP;
		tfTime.text = "00:00";
		panel.addChild(tfTime);

		_bExit = Button.Create("Выход", Styles.MENU_BUTTON, Styles.SMALL_ORANGE_TEXT);
		_bExit.x = (panel.width - _bExit.width) / 2;
		_bExit.y = tfTime.y + _bExit.height + 2 * GAP;
		panel.addChild(_bExit);

		container.stage.addChild(panel);
	}

	private function initSound():void {
		soundStep = (new SoundStep()) as Sound;
	}

	private function initListeners():void {
		_model.addEventListener(EventModel.MATRIX_CHANGE, onModelChange);
		container.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		container.stage.addEventListener(Event.RESIZE, onResize);
		camera.view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		_model.addEventListener(EventModel.GAME_COMPLETE, onGameComplete);
		_model.addEventListener(EventModel.TIME_CHANGE, onTimeChange);
	}

	private function arrangeBoxes():void {
		var box:Mesh,
			indx:Index;

		for (var i:int = 1; i <= Model.AMOUNT; i++) {
			indx = this._model.matrix.getIndex(i);
			box = this._boxes[i];
			box.x = (indx.j - 1) * (19 + GAP);
			box.y = -(indx.i - 1) * (19 + GAP);
		}
	}

	/**
	 * @private
	 * Move the box according to its index
	 */
	private function moveBox(box:Mesh, indx:Index, animate:Boolean = false):void {
		var toX:int = (indx.j - 1) * (19 + GAP);
		var toY:int = -(indx.i - 1) * (19 + GAP);

		if (animate) {
			TweenMax.to(box, DURATION, { x:toX, y: toY } );
			soundStep.play();
		}
		else {
			box.x = toX;
			box.y = toY;
		}
	}

//-------------------------------------------------------------------------------------------------
//
//  Overrides
//
//-------------------------------------------------------------------------------------------------

	override public function dispouse():void {
		container.stage.removeChild(panel);
		container.stage.removeChild(camera.view);
		_model.removeEventListener(EventModel.MATRIX_CHANGE, onModelChange);
		container.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		container.stage.removeEventListener(Event.RESIZE, onResize);
		camera.view.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);

		_model.removeEventListener(EventModel.GAME_COMPLETE, onGameComplete);
		_model.removeEventListener(EventModel.TIME_CHANGE, onTimeChange);
		context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH); // wtf?
		camera.view = null;
		camera = null;
		cameraContainer = null;
		scene = null;
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

	private function onEnterFrame(e:Event):void {
		camera.render(stage3D);
		controller.update();
	}

	private function onResize(e:Event = null):void {
		camera.view.width = container.stage.stageWidth;
		camera.view.height = container.stage.stageHeight;
		onEnterFrame(null);
	}

	private function onMouseWheel(e:MouseEvent):void {
		if (e.delta > 0) {
			if (camera.z < -30) {
				camera.z += 10;
			}
		} else {
			if (camera.z > -200) {
				camera.z -= 10;
			}
		}
	}

	private function onModelChange(e:EventModel):void {
		var box:Mesh = this._boxes[e.numBox];

		moveBox(box, e.indx, true);
		this.tfSteps.text = String(this._model.steps);
	}

	private function onTimeChange(e:EventModel):void {
		var min:int = e.numBox / 60,
			sec:int = e.numBox % 60;
		this.tfTime.text = (min >= 10? min.toString(): "0" + min.toString()) + ":"
				+ (sec >= 10? sec.toString(): "0" + sec.toString());
	}

	private function onGameComplete(e:EventModel):void {
		var msg:Message = new Message("Вы победили!!!", 0x00ff00, 1, 3, 48, false, "Arial");
		msg.x = container.stage.stageWidth / 2;
		msg.y = container.stage.stageHeight / 2;
		container.stage.stage.addChild(msg);
	}

//-------------------------------------------------------------------------------------------------
//
//  Getters & setters
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