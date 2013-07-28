package  
{
	import org.flixel.*;
	
	public class Pet extends FlxSprite
	{
		[Embed(source = "../assets/pet.png")] private var PngPet:Class;
		
		private var _playstate:PlayState;
		
		public function Pet(playstate:PlayState, X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			loadGraphic(PngPet, true, true, 50, 50);
			addAnimation("egg", [0]);
			addAnimation("baby", [1]);
			addAnimation("teen", [2]);
			addAnimation("adult", [3]);
			
			play("egg");
			
			_playstate = playstate;
		}
		
		
		override public function update():void
		{
			
			super.update();
		}
		
	}

}