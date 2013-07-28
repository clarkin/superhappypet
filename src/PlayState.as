package
{
	import org.flixel.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;
 
	public class PlayState extends FlxState
	{
		private var pet:Pet;
		
		public var GUI:FlxGroup, buttons:FlxGroup;
		private var txtHunger:FlxText, txtHappiness:FlxText;
		private var btnMeal:FlxButton, btnTreat:FlxButton, btnToilet:FlxButton, btnMedicine:FlxButton;
		public var messageBanner:MessageBanner;
		
		private var paused:Boolean = false;
		
		override public function create():void {
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 400, 400);
			FlxG.worldBounds = new FlxRect(0, 0, 400, 400);
			
			GUI = new FlxGroup();
			txtHunger = new FlxText(10, 10, 150, "Hunger: 0");
			txtHunger.setFormat("", 16, 0xFF3C4500, "left");
			GUI.add(txtHunger);
			txtHappiness = new FlxText(260, 10, 150, "Happiness: 0");
			txtHappiness.setFormat("", 16, 0xFF3C4500, "left");
			GUI.add(txtHappiness);
			messageBanner = new MessageBanner(0, 330, 400);
			GUI.add(messageBanner);
			
			buttons = new FlxGroup();
			btnMeal = new FlxButton(10, 370, "Meal", clickMeal);
			buttons.add(btnMeal);
			btnTreat = new FlxButton(110, 370, "Treat", clickMeal);
			buttons.add(btnTreat);
			btnToilet = new FlxButton(210, 370, "Toilet", clickMeal);
			buttons.add(btnToilet);
			btnMedicine = new FlxButton(310, 370, "Medicine", clickMeal);
			buttons.add(btnMedicine);
			buttons.visible = false;
			GUI.add(buttons);
			
			pet = new Pet(this, 100, 100);

			add(GUI);
			add(pet);
			
			
		}
		
		override public function update():void {
			if (!paused) {
				checkControls();
				
				super.update();
			} 			
		}
		
		private function checkControls():void {
			if (FlxG.keys.justReleased("ESCAPE")) {
				FlxG.switchState(new MenuState);
			}
		}
		
		private function clickMeal():void {
			btnMeal.status = FlxButton.NORMAL;
			pet.feedMeal();
		}
		
	}
}