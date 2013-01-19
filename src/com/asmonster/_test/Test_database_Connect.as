package com.asmonster._test 
{
	
	import com.asmonster.database.Connect;
	
	import com.asmonster.utils.Debug;
	
	public class Test_database_Connect 
	{
		
		public function Test_database_Connect(type:String) 
		{
			
			var tS:String = "Test_database_Connect";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			var Data:Connect = new Connect();
			
			Data.UnLoad(false);
			if(type == "xml") {
				Data.NewXmlGet( {
					File:"com/asmonster/_test/xml/Test1.xml",
					Node:"Table",
					SubNode:"Line"
				} );
				Data.NewXmlGet( {
					File:"com/asmonster/_test/xml/Test1.xml",
					Node:"Table",
					SubNode:"Line",
					Conditions:"age > 25"
				} );
				Data.NewXmlGet( {
					File:"com/asmonster/_test/xml/Test1.xml",
					Node:"Table",
					SubNode:"Line",
					Conditions:"age > 25",
					Limit:7
				} );
			} else if(type == "database") {
				Data.NewSqlSelect( {
					Table: "eventos",
					Columns:"*",
					Conditions:"id > 1",
					Order:"id DESC",
					Limit:48
				} );
			}
			Data.GetInfos();
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
	}
}