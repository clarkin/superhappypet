package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Poop extends FlxSprite
	{
		[Embed(source = "../assets/poop.png")] private var PngPoop:Class;
		
		private var max_y:Number = 170;
				
		public function Poop(X:Number = 0, Y:Number = 0, Facing:uint = RIGHT)
		{
			super(X,Y);
			
			loadGraphic(PngPoop, true, true, 72, 91);
			addAnimation("poopin", [0, 1, 2], 0.5, false);
			play("poopin");
			
			elasticity = 0.8;
			maxVelocity.y = 400;
			acceleration.y = 100;
			alpha = 0.8;
			facing = Facing;
			var poop_power:Number = Math.round(Math.random() * 40) + 40;
			max_y = max_y + Math.round(Math.random() * 20) -10;
			velocity.x = poop_power;
			if (facing == LEFT) {
				velocity.x = -poop_power;
			}
		}
		
		
		override public function update():void
		{			
			checkBounds();
			
			super.update();
		}
		
		
		private function checkBounds():void {
			
			if (y > max_y) {
				y = max_y;
				acceleration.y = 0;
				velocity.y = 0;
				velocity.x = 0;
			}
		}
		
	}

}