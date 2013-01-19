package com.asmonster._test 
{	
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import com.asmonster.utils.Generic;
	
	import com.asmonster.utils.Debug;
	
	public class Test_utils_Capture 
	{
		
		public function Test_utils_Capture(stage:Stage) 
		{
			var tS:String = "Test_utils_Capture";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			
			var TestMc:MovieClip = new MovieClip(); stage.addChild(TestMc); TestMc.name = "TestMc";
			
			var TestMcB:MovieClip = new MovieClip(); stage.addChild(TestMcB); TestMcB.name = "TestMcB";
			
			var cpTest:NewShape = new NewShape(); stage.addChild(cpTest); cpTest.name = "cpTest";
			
			cpTest.mask = new MovieClip();
			
			TestMc.addChild(cpTest);
			TestMcB.addChild(TestMc);
			
			stage.getChildByName("teste");
			
			Debug.Send(Generic.GetTarget(cpTest), "Info", { p:"test", c:"Test", m:tS } );
			Debug.Send(Generic.GetTarget(cpTest, stage), "Info", { p:"test", c:"Test", m:tS } );
			Debug.Send(Generic.GetTarget("cpTest", TestMc), "Info", { p:"test", c:"Test", m:tS } );
			Debug.Send(Generic.GetTarget("TestMc.cpTest", TestMcB), "Info", { p:"test", c:"Test", m:tS } );
			
			Debug.Send(Generic.GetTarget("cpTest.$mask", TestMc), "Info", { p:"test", c:"Test", m:tS } );
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
		}
	}
}