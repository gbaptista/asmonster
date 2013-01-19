package com.asmonster._test 
{
	
	import flash.display.Stage;
	
	import com.asmonster.utils.Debug;
	
	import com.asmonster._test.*;
	
	public class Test 
	{
		
		public function Test():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"test", c:"Test", m:"Test" } );
		}
		
		public static function StartTest(stage:Stage):void {
			
			//Debug.Alert = true; Debug.sError = true;
			//Debug.Info = false; Debug.NewInstance = false; Debug.Result = false;
			
			// # Start...	
			Debug.Send("Tests Started!", "Alert", { p:"test", c:"Test", m:"Test" } );
				
			// # database
				// Connect
				//new Test_database_Connect("xml");
				//new Test_database_Connect("database");
				
				// UseData
				//new Test_database_UseData(stage, "xml");
				//new Test_database_UseData(stage, "database");
				//new Test_database_UseData(stage, "xml", "GetData");
				//new Test_database_UseData(stage, "xml", "GetData2");
				//new Test_database_UseData(stage, "xml", "GetData3");
				//new Test_database_UseData(stage, "xml", "PaginateData");
				//new Test_database_UseData(stage, "xml", "PaginateData2"); //animate.AnimateDataItems
				//new Test_database_UseData(stage, "xml", "PaginateData3"); //animate.AnimateDataItems
				
			// # effects
				// Transitions
				//new Test_effects_Transitions(stage);
				
			// # interfaces
				// Box
				//new Test_interfaces_Box(stage);
				
				// DragAndDrop
				//new Test_interfaces_DragAndDrop(stage);
				
				// LoaderBox
				//new Test_interfaces_LoaderBox(stage, "Load1");
				//new Test_interfaces_LoaderBox(stage, "Load2");
				//new Test_interfaces_LoaderBox(stage, "Load3");
				//new Test_interfaces_LoaderBox(stage, "Load4");
				//new Test_interfaces_LoaderBox(stage, "Load5");
				//new Test_interfaces_LoaderBox(stage, "Load6");
				
				// ObjectAlign
				//new Test_interfaces_ObjectAlign(stage, "ObjAl1")
				//new Test_interfaces_ObjectAlign(stage, "ObjAl2")
				
			// # utils
				// Capture
				//new Test_utils_Capture(stage);
				//new Test_utils_Treatment();
				
				
			// # Finish...	
			Debug.Send("Tests Finished!", "Alert", { p:"test", c:"Test", m:"Test" } );
			
		}
		
	}
}