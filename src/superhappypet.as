package
{
	import org.flixel.*; 
	[SWF(width = "400", height = "400", backgroundColor = "#000000")] 
	[Frame(factoryClass="Preloader")]
 
	public class superhappypet extends FlxGame
	{
		public function superhappypet()
		{
			trace("test");
			super(400, 400, MenuState, 1); 
		}
	}
}