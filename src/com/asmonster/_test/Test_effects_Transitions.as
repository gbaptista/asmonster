package com.asmonster._test 
{
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import com.asmonster.effects.Transitions;
	
	import com.asmonster.interfaces.LoaderBox;
	
	import flash.utils.setTimeout;
	
	import com.asmonster.utils.Debug;
	
	public class Test_effects_Transitions 
	{
		
		public function Test_effects_Transitions(stage:Stage):void
		{
			
			var tS:String = "Test_effects_Transitions";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			
			var imageA:MovieClip = new MovieClip();
			imageA.x = 20; imageA.y = 100; imageA.alpha = 0;
			stage.addChild(imageA);
			
			function teste():void {
				Debug.Send("oncomplete test", "Alert");
			}
			
			function ok():void {
				
				function start():void {
					Debug.Send("transição iniciada!", "Result");
				}
				
				function end():void {
					Debug.Send("transição finalizada!", "Error");
				}
				
				import com.greensock.easing.Bounce;
				
				Transitions.newTransition(imageA, 'show', {
					Length:20, Gain:0.3, BlurY:true, tint:0xff3300, Ease:Bounce.easeOut, onStart:start, onComplete:end
				} );
				
				Debug.Send("agora!", "Alert");
			}
			
			function anima():void {
				setTimeout(ok, 0.5 * 1000);
				Debug.Send("em 0.5s...");
			}
			
			var loadA:LoaderBox = new LoaderBox( { Target:imageA } );
			loadA.Load("com/asmonster/_test/images/b/3.jpg", anima);
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
	}
}