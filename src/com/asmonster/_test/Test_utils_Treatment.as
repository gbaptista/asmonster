package com.asmonster._test 
{
	
	import com.asmonster.utils.Treatment;
	
	import com.asmonster.utils.Debug;
	
	public class Test_utils_Treatment 
	{
		
		public function Test_utils_Treatment() 
		{
					
			var tS:String = "Test_utils_Treatment";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			
			Debug.Send(Generic.TreatDataBaseReturn("Test 951dcee3a7a4f3aac67ec76a2ce4469cc76df650f134bf2572bf60a65c982338 Test"), "Info", { p:"test", c:"Test", m:tS } );
			
			Debug.Send(Generic.GetConditions('descri = "teste" AND tit = "color" AND teste < 4 OR cdt > 6 AND id != 4'), "Info", { p:"test", c:"Test", m:tS } );
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
		
	}
	
}