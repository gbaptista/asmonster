package
{
	
	import flash.display.MovieClip;
	
	import com.asmonster.asMonster;
	import com.asmonster.utils.Debug;
	
	public class MainAT extends MovieClip
	{
		
		public function MainAT():void
		{
			
			// =====================
			
			contextMenu = asMonster.AddCredits(); asMonster.Init(stage, true);
			
			// =====================
			
		}
	}
}