package  
{
	import org.flixel.*;
	
	public class Pet extends FlxSprite
	{
		[Embed(source = "../assets/pet.png")] private var PngPet:Class;
		
		public static const TIME_AS_EGG:Number = 3;
		public static const TIME_AS_HATCHING:Number = 3;
		public static const TIME_AS_BABY:Number = 60;
		public static const TIME_AS_TEEN:Number = 1000;
		
		public static const SPEED_AS_BABY:Number = 10;
		public static const MOVEMENT_CHANGE_BABY:Number = 0.3;
		public static const POOP_TIME_BABY:Number = 15;
		
		public static const HUNGER_DEATH_TIME:Number = 10;
		public static const HAPPINESS_DEATH_TIME:Number = 10;
		public static const SICKNESS_DEATH_TIME:Number = 20;
		
		private var _playstate:PlayState;
		
		public var hunger:Number = 0;
		public var happiness:Number = 0;
		public var time_to_evolve:Number = 0;
		public var evolution:String = "egg";
		private var start_x:Number = 0, start_y:Number = 0;
		private var movement_change:Number = 0;
		private var time_to_alert:Number = 0;
		private var time_to_poop:Number = 20;
		private var time_to_death_hunger:Number = -1;
		private var time_to_death_happiness:Number = -1;
		private var time_to_death_sickness:Number = -1;
		private var hunger_message_sent:Boolean = false;
		private var happiness_message_sent:Boolean = false;
		private var poop_message_sent:Boolean = false;
		private var sickness_message_sent:Boolean = false;
		
		public function Pet(playstate:PlayState, X:Number = 0, Y:Number = 0) {
			super(X, Y);
			_playstate = playstate;
			start_x = X;
			start_y = Y;
			alpha = 0.95;
			
			loadGraphic(PngPet, true, true, 168, 168);
			addAnimation("egg", [0]);
			addAnimation("baby", [1]);
			addAnimation("teen", [2]);
			addAnimation("gravestone", [3]);
			addAnimation("hatching", [4,5,6], 1);
			
			play("egg");
			facing = RIGHT;
			_playstate.messageBanner.addMessage("Look, an egg");
			_playstate.sndTimerEnding.play();
			time_to_evolve = TIME_AS_EGG;
		}
		
		
		override public function update():void {
			if (alive) {
				checkEvolve();
				checkMovement();
				checkStats();
			}
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
				x = start_x + Math.round(Math.random() * 6) - 3;
			} else if (evolution == "baby" && !_playstate.paused) {
				movement_change -= FlxG.elapsed;
				if (movement_change <= 0) {
					movement_change = MOVEMENT_CHANGE_BABY;
					var chance:Number = Math.round(Math.random() * 100);
					if (chance < 1) {
						velocity.x = 0;
					} else if (chance < 40) {
						velocity.x = SPEED_AS_BABY;
						if (facing == LEFT) {
							velocity.x = -SPEED_AS_BABY;
						}
					} else if (chance < 50) {
						if (facing == LEFT) {
							facing = RIGHT;
							velocity.x = 0;
						} else {
							facing = LEFT;
							velocity.x = 0;
						}
					}
					
					if (start_x - x > 100) {
						facing = RIGHT;
						velocity.x = SPEED_AS_BABY;
					} else if (start_x - x < -100) {
						facing = LEFT;
						velocity.x = -SPEED_AS_BABY;
					}
				}
			}
		}
		
		public function checkStats():void {
			if (_playstate.paused) {
				return;
			}
			
			if (evolution == "baby") {
				hunger -= FlxG.elapsed * 2;
				happiness -= FlxG.elapsed;		
				if (_playstate.totalPoops > 1) {
					happiness -= FlxG.elapsed * _playstate.totalPoops;
				}
				if (time_to_death_sickness != -1) {
					happiness -= FlxG.elapsed * 4;
				}
				time_to_poop -= FlxG.elapsed;		
				
				if (hunger < 15) {
					sendAlert(hunger);
					if (hunger <= 0) {
						if (time_to_death_hunger == -1) {
							time_to_death_hunger = 0;
							_playstate.messageBanner.addMessage("! ! ! Starving ! ! !");
						} else {
							time_to_death_hunger += FlxG.elapsed;
							if (time_to_death_hunger >= HUNGER_DEATH_TIME) {
								petDeath();
							}
						}
					} else {
						if (!hunger_message_sent) {
							hunger_message_sent	= true;
							_playstate.messageBanner.addMessage("! Hungry !");
						}		
					}
				} else if (happiness < 15) {
					sendAlert(happiness);
					if (happiness <= 0) {
						if (time_to_death_happiness == -1) {
							time_to_death_happiness = 0;
							_playstate.messageBanner.addMessage("! ! ! Suicidal ! ! !");
						} else {
							time_to_death_happiness += FlxG.elapsed;
							if (time_to_death_happiness >= HAPPINESS_DEATH_TIME) {
								petDeath();
							}
						}
					} else {
						if (!happiness_message_sent) {
							happiness_message_sent = true;
							_playstate.messageBanner.addMessage("! Unhappy !");
						}
					}
				} else if (time_to_death_sickness != -1) {
					time_to_death_sickness += FlxG.elapsed;
					if (time_to_death_sickness >= SICKNESS_DEATH_TIME) {
						petDeath();
					} else if (time_to_death_sickness >= SICKNESS_DEATH_TIME / 2) {
						if (!sickness_message_sent) {
							sickness_message_sent = true;
							_playstate.messageBanner.addMessage("! ! ! Dying of Sickness ! ! !");
						}
					}
				} else if (_playstate.totalPoops > 1) {
					sendAlert(12 - _playstate.totalPoops * 2);
					if (!poop_message_sent) {
						poop_message_sent = true;
						_playstate.messageBanner.addMessage("! Poops !");
						petSick();
					}
				}
				
				if (hunger >= 15) {
					hunger_message_sent = false;
				}
				if (happiness >= 15) {
					happiness_message_sent = false;
				}
				
				if (hunger > 0) {
					time_to_death_hunger = -1;
				}
				if (happiness > 0) {
					time_to_death_happiness = -1;
				}
				
				if (time_to_poop <= 0) {
					time_to_poop = POOP_TIME_BABY + Math.round(Math.random() * 6) - 3;
					var poop_direction:uint = LEFT;
					var poop_x:Number = x;
					if (facing == LEFT) {
						poop_direction = RIGHT;
						poop_x = x + width - 40;
					}
					_playstate.addPoop(poop_x, y + 30, poop_direction);
				}
			}

			statLimits();
		}
		
		private function sendAlert(noMoreAlertsFor:Number):void {
			if (time_to_alert > 0) {
				time_to_alert -= FlxG.elapsed;
			} else {
				_playstate.sndAlert.play();
				time_to_alert = noMoreAlertsFor / 5;
				if (time_to_alert <= 0.5) {
					time_to_alert = 0.5;
				}
			}
		}
		
		public function startHatching():void {
			_playstate.messageBanner.addMessage("It's hatching!");
			_playstate.paused = true;
			evolution = "hatching";
			play(evolution);
			time_to_evolve = TIME_AS_HATCHING;
		}
		
		public function finishHatching():void {
			_playstate.messageBanner.addMessage("It's a boy!");
			_playstate.sndLevelUp.play();
			evolution = "baby";
			play(evolution);
			startChoosingName();
		}
		
		public function startChoosingName():void {
			_playstate.nameChoiceGUI.visible = true;
			_playstate.inputName.hasFocus = true;
		}
		
		public function finishChoosingName(name:String):void {
			_playstate.nameChoiceGUI.visible = false;
			_playstate.messageBanner.addMessage("Please look after " + name);
			time_to_evolve = TIME_AS_BABY;
			hunger = 30;
			happiness = 30;
			_playstate.buttons.visible = true;
			_playstate.paused = false;
		}
		
		public function doMeal():void {
			hunger += 50;
			happiness += 10;
			if (time_to_poop > 12) {
				time_to_poop -= 10;
			}
			
			if (hunger >= 145) {
				petSick();
				_playstate.messageBanner.addMessage("He has eaten too much!");
			}
			
			statLimits();
		}
		
		public function doTreat():void {
			hunger += 10;
			happiness += 40;
			if (time_to_poop > 4) {
				time_to_poop -= 2;
			}
			
			statLimits();
		}
		
		public function doToilet():void {
			//trace("total poops: " + _playstate.totalPoops);
			if (_playstate.totalPoops > 0) {
				happiness += 10 * _playstate.totalPoops;
				_playstate.poops.kill();
				_playstate.totalPoops = 0;
				poop_message_sent = false;
			} else {
				happiness -= 10;
			}
			
			statLimits();
		}
		
		public function doMedicine():void {
			if (time_to_death_sickness != -1) {
				time_to_death_sickness = -1;
				_playstate.iconSickness.visible = false;
				sickness_message_sent = false;
				happiness += 30;
			} else {
				petSick();
				_playstate.messageBanner.addMessage("He feels sick");
			}
			statLimits();
		}
		
		public function petSick():void {
			time_to_death_sickness = 0;
			_playstate.iconSickness.visible = true;
		}
		
		public function petDeath():void {
			_playstate.sndDeath.play();
			evolution = "gravestone";
			play(evolution);
			_playstate.messageBanner.addMessage("You let him DIE");
			velocity.x = 0;
			alive = false;
			_playstate.paused = true;
		}
		
		private function statLimits():void {
			if (hunger < 0) {
				hunger = 0;
			}
			if (hunger > 100) {
				hunger = 100;
			}
			if (happiness < 0) {
				happiness = 0;
			}
			if (happiness > 100) {
				happiness = 100;
			}
		}
		
		public function hungerReport():String {
			var hungerVisual:String = "";
			var times:Number = Math.round(hunger / 10);
			for ( ; times > 0; times--) {
				hungerVisual += "*";
			}
			return hungerVisual;
		}
		
		public function happinessReport():String {
			var happinessVisual:String = "";
			var times:Number = Math.round(happiness / 10);
			for ( ; times > 0; times--) {
				happinessVisual += "*";
			}
			return happinessVisual;
		}
		
	}

}