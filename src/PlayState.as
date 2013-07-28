package
{
	import org.flixel.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;
 
	public class PlayState extends FlxState
	{
		private var pet:Pet;
		
		private var GUI:FlxGroup;
		private var txtHunger:FlxText;
		
		private var paused:Boolean = false;
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 400, 400);
			FlxG.worldBounds = new FlxRect(0, 0, 400, 400);
						
			pet = new Pet(this, 200, 200);
			
			GUI = new FlxGroup();
			txtHunger = new FlxText(10, 10, 100, "Hunger: 0");
			txtHunger.setFormat("", 16, 0x3C4500, "left");
			GUI.add(txtHunger);

			add(GUI);
			add(pet);
		}
		
		override public function update():void
		{
			if (!paused) {
				checkControls();
				
				super.update();
			} 			
		}
		
		private function checkControls():void {
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new MenuState);
			}
		}
		
	}
}