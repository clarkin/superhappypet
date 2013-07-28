package  
{
	import org.flixel.*;
	
	public class Pet extends FlxSprite
	{
		[Embed(source = "../assets/pet.png")] private var PngPet:Class;
		
		public static const TIME_AS_EGG:Number = 5;
		public static const TIME_AS_HATCHING:Number = 3;
		public static const TIME_AS_BABY:Number = 60;
		public static const TIME_AS_TEEN:Number = 1000;
		
		private var _playstate:PlayState;
		
		public var hunger:Number = 0;
		public var happiness:Number = 0;
		public var time_to_evolve:Number = 0;
		public var evolution:String = "egg";
		private var start_x:Number = 0, start_y:Number = 0;
		
		public function Pet(playstate:PlayState, X:Number = 0, Y:Number = 0) {
			super(X, Y);
			_playstate = playstate;
			start_x = X;
			start_y = Y;
			
			loadGraphic(PngPet, true, true, 168, 168);
			addAnimation("egg", [0]);
			addAnimation("baby", [1]);
			addAnimation("teen", [2]);
			addAnimation("hatching", [3,4,5], 1);
			
			play("egg");
			_playstate.messageBanner.addMessage("Look, an egg");
			time_to_evolve = TIME_AS_EGG;
		}
		
		
		override public function update():void {
			checkEvolve();
			checkMovement();
			
			super.update();
		}
		
		public function checkEvolve():void {
			if (time_to_evolve > 0) {
				time_to_evolve -= FlxG.elapsed;
				if (time_to_evolve <= 0) {
					if (evolution == "egg") {
						startHatching();
					} else if (evolution == "hatching") {
						finishHatching();
					}
				}
			}
		}
		
		public function checkMovement():void {
			if (evolution == "hatching") {
				x = start_x + Math.round(Math.random() * 6) - 3
			}
		}
		
		public function startHatching():void {
			_playstate.messageBanner.addMessage("It's hatching!");
			evolution = "hatching";
			play(evolution);
			time_to_evolve = TIME_AS_HATCHING;
		}
		
		public function finishHatching():void {
			_playstate.messageBanner.addMessage("It's a boy!");
			evolution = "baby";
			play(evolution);
			time_to_evolve = TIME_AS_BABY;
			_playstate.buttons.visible = true;
		}
		
		public function feedMeal():void {
			trace("fed");
			
		}
		
	}

}