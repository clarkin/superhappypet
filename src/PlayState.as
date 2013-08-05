package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/sickness.png")] private var PngSickness:Class;
		
		[Embed(source = "../assets/button_select.wav", mimeType = "application/octet-stream")] private const WavButtonSelect:Class;
		[Embed(source = "../assets/level_up.wav", mimeType = "application/octet-stream")] private const WavLevelUp:Class;
		[Embed(source = "../assets/timer_ending.wav", mimeType = "application/octet-stream")] private const WavTimerEnding:Class;
		[Embed(source = "../assets/alert.wav", mimeType = "application/octet-stream")] private const WavAlert:Class;
		[Embed(source = "../assets/poop.wav", mimeType = "application/octet-stream")] private const WavPoop:Class;
		[Embed(source = "../assets/death.wav", mimeType = "application/octet-stream")] private const WavDeath:Class;
		public var sndButtonSelect:WavSound;
		public var sndLevelUp:WavSound;
		public var sndTimerEnding:WavSound;
		public var sndAlert:WavSound;
		public var sndPoop:WavSound;
		public var sndDeath:WavSound;
		
		public static const COLOR_BACKGROUND:uint = 0xFF687800;
		public static const COLOR_TEXT:uint = 0xFF3C4500;
		
		private var pet:Pet;
		
		public var GUI:FlxGroup, buttons:FlxGroup, poops:FlxGroup, nameChoiceGUI:FlxGroup;
		private var txtHunger:FlxText, txtHappiness:FlxText, txtName:FlxText;
		private var btnMeal:FlxButtonPlus, btnPlay:FlxButtonPlus, btnToilet:FlxButtonPlus, btnMedicine:FlxButtonPlus;
		public var nameLabel:FlxText, inputName:FlxInputText, btnChooseName:FlxButtonPlus;
		
		public var iconSickness:FlxSprite;
		public var messageBanner:MessageBanner;
		public var totalPoops:Number = 0;
		
		public var paused:Boolean = false;
		
		override public function create():void {
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 400, 400);
			FlxG.worldBounds = new FlxRect(0, 0, 400, 400);
			
			GUI = new FlxGroup();
			txtName = new FlxText(10, 10, 380, "");
			txtName.setFormat("", 16, 0xFF3C4500, "center");
			GUI.add(txtName);
			messageBanner = new MessageBanner(0, 310, 400);
			GUI.add(messageBanner);
			iconSickness = new FlxSprite(320, 50, PngSickness);
			iconSickness.visible = false;
			GUI.add(iconSickness);
			
			buttons = new FlxGroup();
			txtHunger = new FlxText(10, 50, 180, "Hunger: ");
			txtHunger.setFormat("", 16, 0xFF3C4500, "left");
			buttons.add(txtHunger);
			txtHappiness = new FlxText(210, 50, 180, "Happiness: ");
			txtHappiness.setFormat("", 16, 0xFF3C4500, "left");
			buttons.add(txtHappiness);
			btnMeal = new FlxButtonPlus(10, 360, clickMeal, null, "MEAL", 80, 30);
			btnMeal.textNormal.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnMeal.textHighlight.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnMeal.borderColor = COLOR_TEXT;
			btnMeal.updateInactiveButtonColors([COLOR_BACKGROUND, COLOR_BACKGROUND]);
			btnMeal.updateActiveButtonColors([0xFF4E5900, 0xFF4E5900]);
			buttons.add(btnMeal);
			btnPlay = new FlxButtonPlus(110, 360, clickPlay, null, "PLAY", 80, 30);
			btnPlay.textNormal.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnPlay.textHighlight.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnPlay.borderColor = COLOR_TEXT;
			btnPlay.updateInactiveButtonColors([COLOR_BACKGROUND, COLOR_BACKGROUND]);
			btnPlay.updateActiveButtonColors([0xFF4E5900, 0xFF4E5900]);
			buttons.add(btnPlay);
			btnToilet = new FlxButtonPlus(210, 360, clickToilet, null, "TOILET", 80, 30);
			btnToilet.textNormal.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnToilet.textHighlight.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnToilet.borderColor = COLOR_TEXT;
			btnToilet.updateInactiveButtonColors([COLOR_BACKGROUND, COLOR_BACKGROUND]);
			btnToilet.updateActiveButtonColors([0xFF4E5900, 0xFF4E5900]);
			buttons.add(btnToilet);
			btnMedicine = new FlxButtonPlus(310, 360, clickMedicine, null, "MEDS", 80, 30);
			btnMedicine.textNormal.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnMedicine.textHighlight.setFormat("", 16, 0xFF3C4500, "center", 0);
			btnMedicine.borderColor = COLOR_TEXT;
			btnMedicine.updateInactiveButtonColors([COLOR_BACKGROUND, COLOR_BACKGROUND]);
			btnMedicine.updateActiveButtonColors([0xFF4E5900, 0xFF4E5900]);
			buttons.add(btnMedicine);
			buttons.visible = false;
			GUI.add(buttons);
			
			nameChoiceGUI = new FlxGroup();
			nameLabel = new FlxText(10, 20, 400, "Name your SUPER HAPPY PET");
			nameLabel.setFormat("", 16, 0xFF3C4500, "center");
			nameChoiceGUI.add(nameLabel);
			inputName = new FlxInputText(110, 50, "PORKY", 120, 0xFF687800, 0xFF3C4500);
			inputName.forceCase = FlxInputText.UPPER_CASE;
			inputName.filterMode = FlxInputText.ONLY_ALPHANUMERIC;
			inputName.backgroundColor = 0xFF3C4500;
			inputName.caretColor = 0xFF687800;
			inputName.color = 0xFF687800;
			inputName.enterCallBack = choseName;
			inputName.maxLength = 7;
			inputName.size = 16;
			nameChoiceGUI.add(inputName);
			btnChooseName = new FlxButtonPlus(240, 50, choseName, null, "OK", 50, 25);
			btnChooseName.textNormal.setFormat("", 12, 0xFF3C4500, "center", 0);
			btnChooseName.textHighlight.setFormat("", 12, 0xFF3C4500, "center", 0);
			btnChooseName.borderColor = COLOR_TEXT;
			btnChooseName.updateInactiveButtonColors([COLOR_BACKGROUND, COLOR_BACKGROUND]);
			btnChooseName.updateActiveButtonColors([0xFF4E5900, 0xFF4E5900]);
			nameChoiceGUI.add(btnChooseName);
			nameChoiceGUI.visible = false;
			GUI.add(nameChoiceGUI);
			
			sndButtonSelect = new WavSound(new WavButtonSelect() as ByteArray);
			sndLevelUp = new WavSound(new WavLevelUp() as ByteArray);
			sndTimerEnding = new WavSound(new WavTimerEnding() as ByteArray);
			sndAlert = new WavSound(new WavAlert() as ByteArray);
			sndPoop = new WavSound(new WavPoop() as ByteArray);
			sndDeath = new WavSound(new WavDeath() as ByteArray);
			
			poops = new FlxGroup();
			
			pet = new Pet(this, 100, 100);

			add(GUI);
			add(poops);
			add(pet);
		}
		
		override public function update():void {
			if (!paused) {
				checkControls();
				checkPet();
			} 	
			super.update();
		}
		
		private function checkControls():void {
			//if (FlxG.keys.justReleased("ESCAPE")) {
			//	FlxG.switchState(new MenuState);
			//}
		}
		
		private function checkPet():void {
			txtHunger.text = "Hunger: \n" + pet.hungerReport();
			txtHappiness.text = "Happiness: \n" + pet.happinessReport();
		}
		
		private function clickMeal():void {
			if (!paused) {
				pet.doMeal();
				sndButtonSelect.play();
			}
		}
		
		private function clickPlay():void {
			if (!paused) {
				pet.doPlay();
				sndButtonSelect.play();
			}
		}
		
		private function clickToilet():void {
			if (!paused) {
				pet.doToilet();
				sndButtonSelect.play();
			}
		}
		
		private function clickMedicine():void {
			if (!paused) {
				pet.doMedicine();
				sndButtonSelect.play();
			}
		}
		
		public function addPoop(X:Number, Y:Number, Facing:uint):void {
			var poop:Poop = new Poop(X, Y, Facing);
			if (!poops.alive) {
				poops.revive();
			}
			poops.add(poop);
			totalPoops++;
			sndPoop.play();
		}
		
		private function choseName(name:String = ""):void {
			if (name == "") {
				name = inputName.text;
			}
			if (name != "") {
				pet.finishChoosingName(name);
				txtName.text = name;
				nameChoiceGUI.visible = false;
			}
		}
		
	}
}