package  
{
	import org.flixel.*;
	
	public class MessageBanner extends FlxText
	{
		public static const SHOW_FOR:Number = 3;
		
		private var _showing_for:Number = 0;
		
		private var messages:Array = [];
		
		public function MessageBanner(X:Number = 0, Y:Number = 0, Width:Number = 0) {
			super(X, Y, Width, "");

			this.setFormat("", 24, 0xFF3C4500, "center");
		}
		
		
		override public function update():void {			
			checkTime();
			checkForMessages();
			
			super.update();
		}
		
		
		private function checkTime():void {
			
			if (_showing_for > 0) {
				_showing_for -= FlxG.elapsed;
				if (_showing_for <= 0) {
					this.text = "";
				}
			}

		}
		
		private function checkForMessages():void {
			if (_showing_for <= 0 && messages.length > 0) {
				var new_message:String = messages.shift();
				//trace("new message: " + new_message);
				_showing_for = SHOW_FOR;
				this.text = "";
				this.text = new_message;
			}

		}
		
		public function addMessage(message:String):void {
			//trace("adding message " + message);
			messages.push(message);
		}
		
	}

}