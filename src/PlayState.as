package
{
	import org.flixel.*;
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
		
		private var pet:Pet;
		
		public var GUI:FlxGroup, buttons:FlxGroup, poops:FlxGroup;
		private var txtHunger:FlxText, txtHappiness:FlxText;
		private var btnMeal:FlxButton, btnTreat:FlxButton, btnToilet:FlxButton, btnMedicine:FlxButton;
		public var iconSickness:FlxSprite;
		public var messageBanner:MessageBanner;
		public var totalPoops:Number = 0;
		
		private var paused:Boolean = false;
		
		override public function create():void {
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 400, 400);
			FlxG.worldBounds = new FlxRect(0, 0, 400, 400);
			
			GUI = new FlxGroup();
			txtHunger = new FlxText(10, 10, 180, "Hunger: ");
			txtHunger.setFormat("", 16, 0xFF3C4500, "left");
			GUI.add(txtHunger);
			txtHappiness = new FlxText(210, 10, 180, "Happiness: ");
			txtHappiness.setFormat("", 16, 0xFF3C4500, "left");
			GUI.add(txtHappiness);
			messageBanner = new MessageBanner(0, 330, 400);
			GUI.add(messageBanner);
			iconSickness = new FlxSprite(320, 50, PngSickness);
			iconSickness.visible = false;
			GUI.add(iconSickness);
			
			buttons = new FlxGroup();
			btnMeal = new FlxButton(10, 370, "Meal", clickMeal);
			buttons.add(btnMeal);
			btnTreat = new FlxButton(110, 370, "Treat", clickTreat);
			buttons.add(btnTreat);
			btnToilet = new FlxButton(210, 370, "Toilet", clickToilet);
			buttons.add(btnToilet);
			btnMedicine = new FlxButton(310, 370, "Medicine", clickMedicine);
			buttons.add(btnMedicine);
			buttons.visible = false;
			GUI.add(buttons);
			
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
				
				super.update();
			} 			
		}
		
		private function checkControls():void {
			if (FlxG.keys.justReleased("ESCAPE")) {
				FlxG.switchState(new MenuState);
			}
		}
		
		private function checkPet():void {
			txtHunger.text = "Hunger: \n" + pet.hungerReport();
			txtHappiness.text = "Happiness: \n" + pet.happinessReport();
		}
		
		private function clickMeal():void {
			btnMeal.status = FlxButton.NORMAL;
			pet.doMeal();
			sndButtonSelect.play();
		}
		
		private function clickTreat():void {
			btnTreat.status = FlxButton.NORMAL;
			pet.doTreat();
			sndButtonSelect.play();
		}
		
		private function clickToilet():void {
			btnToilet.status = FlxButton.NORMAL;
			pet.doToilet();
			sndButtonSelect.play();
		}
		
		private function clickMedicine():void {
			btnMedicine.status = FlxButton.NORMAL;
			pet.doMedicine();
			sndButtonSelect.play();
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
		
	}
}