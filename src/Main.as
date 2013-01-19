package
{
	
	import flash.display.Sprite;
	
	import flash.events.Event
	
	import com.asmonster.asMonster;
	import com.asmonster.utils.Debug;
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// =====================
			
			contextMenu = asMonster.AddCredits(); asMonster.Init(stage, true);
			
			// =====================
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
}