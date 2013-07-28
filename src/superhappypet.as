package
{
	import org.flixel.*; 
	[SWF(width = "400", height = "400", backgroundColor = "#687800")] 
	[Frame(factoryClass="Preloader")]
 
	public class superhappypet extends FlxGame
	{
		public function superhappypet()
		{
			super(400, 400, MenuState, 1); 
		}
	}
}