package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		

		public function MenuState()
		{
		}

		override public function create():void
		{
			FlxG.mouse.show();
			FlxG.bgColor = 0x687800;
			
			var title:FlxText = new FlxText(0, 10, 400, "Super Happy Pet", true);
			title.setFormat(null, 100, 0x3C4500, "center");

			
			add(title);
			
			
			//startGame();
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("SPACE") || FlxG.mouse.justPressed()) {
				startGame();
			}
			
			super.update();
		}

		private function startGame():void
		{
			//FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}
	}
}