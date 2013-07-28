package
{
	import org.flixel.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;

	public class MenuState extends FlxState
	{
		[Embed(source = "../assets/jingle.wav", mimeType = "application/octet-stream")] private const WavJingle:Class;
		public var sndJingle:WavSound;

		public function MenuState()
		{
		}

		override public function create():void
		{
			FlxG.mouse.show();
			FlxG.bgColor = 0xFF687800;
			
			var title:FlxText = new FlxText(0, 10, 400, "Super Happy Pet", true);
			title.setFormat(null, 100, 0xFF3C4500, "center");

			
			add(title);
			
			sndJingle = new WavSound(new WavJingle() as ByteArray);
			sndJingle.play();
			//startGame();
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("SPACE") || FlxG.mouse.justPressed()) {
				FlxG.fade(0xFF687800, 0.5, startGame);
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