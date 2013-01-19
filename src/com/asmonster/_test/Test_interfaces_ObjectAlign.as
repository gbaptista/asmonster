package com.asmonster._test 
{
	
	import flash.display.Stage;
	
	import com.asmonster.interfaces.ObjectAlign;
	
	import com.asmonster.utils.Debug;
	
	public class Test_interfaces_ObjectAlign 
	{
		
		public function Test_interfaces_ObjectAlign(stage:Stage, type:String = null) 
		{
			var tS:String = "Test_interfaces_LoaderBox";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			
			var Shp:NewShape3 = new NewShape3();
			stage.addChild(Shp);
			
			Shp.alpha = 0.5;
			
			if (Boolean(type) && type == "ObjAl1") {
				ObjectAlign.In( {
					Reference:stage,
					Target:Shp,
					Pos:"CC"
				} );
			} else if (Boolean(type) && type == "ObjAl2") {
				ObjectAlign.In( {
					Reference:stage,
					Target:Shp,
					stretchV:true
				} );
			}
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
	}
}