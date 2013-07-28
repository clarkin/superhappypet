package  
{
	import org.flixel.*;
	
	public class Pet extends FlxSprite
	{
		[Embed(source = "../assets/pet.png")] private var PngPet:Class;
		
		private var _playstate:PlayState;
		
		public function Pet(playstate:PlayState, X:Number = 0, Y:Number = 0) {
			super(X, Y);
			
			loadGraphic(PngPet, true, true, 168, 168);
			addAnimation("egg", [0]);
			addAnimation("baby", [0]);
			addAnimation("teen", [0]);
			addAnimation("adult", [0]);
			
			play("egg");
			
			_playstate = playstate;
		}
		
		
		override public function update():void {
			super.update();
		}
		
		public function feedMeal():void {
			trace("fed");
			
		}
		
	}

}