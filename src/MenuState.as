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
			FlxG.mouse.hide();
			
			var title:FlxText = new FlxText(0, 30, 400, "Super Happy Pet", true);
			title.setFormat(null, 100, 0xFF3333CC, "center");

			
			add(title);
			
			
			//startGame();
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("SPACE")) {
				startGame();
			}
			
			super.update();
		}

		private function startGame():void
		{
			FlxG.mouse.hide();
			//FlxG.switchState(new PlayState);
		}
	}
}