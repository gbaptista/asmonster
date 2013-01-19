package com.asmonster._test 
{
	
	import flash.display.Stage;
	import flash.text.TextField;
	
	import com.asmonster.interfaces.LoaderBox;
	
	import com.asmonster.utils.Debug;
	
	public class Test_interfaces_LoaderBox 
	{
		
		public function Test_interfaces_LoaderBox(stage:Stage, type:String = undefined) 
		{
			var tS:String = "Test_interfaces_LoaderBox";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			var Cpb:TextField = new TextField(); Cpb.x = 10; Cpb.y = 220;
			Cpb.width = 600; stage.addChild(Cpb);
			
			if (Boolean(type) && type == "Load1") {
				var Tlb1:LoaderBox = new  LoaderBox( {
					Target:stage,
					Container:stage,
					ProgressText:Cpb,
					HideOld:"OnComplete",
					ShowNew:"OnComplete",
					alphaTo:0.8
				} );
				function onL():void { 
					Debug.Send("Function OnLoad!", "Info", { p:"test", c:"Test", m:tS } );
				}
				Tlb1.Load("com/asmonster/_test/images/b/3.jpg", onL);
			} else if (Boolean(type) && type == "Load2") {
				var Tlb2:LoaderBox = new  LoaderBox( {
					Target:stage,
					Container:stage,
					ProgressText:Cpb,
					HideOld:"OnComplete",
					ShowNew:"OnComplete",
					alphaTo:1,
					autoAlign:"CC",
					Animation: {
						Time:1.6,
						Transition:"linear",
						alpha:true,
						scaleX:true,
						scaleY:true,
						slideX:true,
						slideY:true,
						rotation:true
					}
				} );
				Tlb2.Load("com/asmonster/_test/images/b/7.jpg");
			} else if (Boolean(type) && type == "Load3") {
				var Tlb3:LoaderBox = new  LoaderBox( {
					Target:stage,
					Container:stage,
					ProgressText:Cpb,
					HideOld:"OnComplete",
					ShowNew:"OnComplete",
					alphaTo:0.8
				} );
				Tlb3.Load("com/asmonster/_test/images/b/5.jpg");
				Tlb3.Cancel();
			} else if (Boolean(type) && type == "Load4") {
				var Tlb4:LoaderBox = new  LoaderBox( {
					Target:stage,
					Container:stage,
					ProgressText:Cpb,
					ProgressObjs:[Cpb],
					ResizeToW:300,
					ResizeToH:200,
					autoAlign:"CC"
				} );
				Tlb4.Load("com/asmonster/_test/images/b/9.jpg");
			} else if (Boolean(type) && type == "Load5") {
				var Tlb5:LoaderBox = new  LoaderBox( {
					Target:stage,
					Container:stage,
					ProgressText:Cpb,
					alphaTo:0.8,
					FullIn:stage
				} );
				Tlb5.Load("com/asmonster/_test/images/b/9.jpg");
			} else if (Boolean(type) && type == "Load6") {
				var Tlb6:LoaderBox = new  LoaderBox( { Target:stage } );
				Tlb6.Load("com/asmonster/_test/images/b/9.jpg");
			}
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
		}
		
	}
	
}