package com.asmonster._test 
{
	
	import flash.display.Stage;
	
	import flash.events.MouseEvent;
	
	import com.asmonster.interfaces.Box;
	import com.asmonster.interfaces.DragAndDrop;
	import com.asmonster.interfaces.LoaderBox;
	
	import com.asmonster.utils.Debug;
	
	public class Test_interfaces_DragAndDrop 
	{
		
		public function Test_interfaces_DragAndDrop(stage:Stage) 
		{
			
			var tS:String = "Test_interfaces_DragAndDrop";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			var Site:DragAndDrop = new DragAndDrop(stage);
			
			Site.overlapItem = false;
			Site.LimitInStage = true;
			
			/*
			Site.SendDroppedOutAreasToDebug = false;
			Site.SendDroppedWithinAreasToDebug = false;
			Site.sendInvalidPositionToDebug = false;
			Site.SendNewAreasToDebug = false;
			Site.SendNewItemsToDebug = false;
			*/
			
			// =======
			
			var area:Box = new Box( { border:0, w:615, h:300, x:0, y:0 } );
			area.alpha = 0.1; area.x = 170; area.y = 170; stage.addChild(area);
			
			var areaB:Box = new Box( { border:0, w:615, h:120, x:0, y:0 } );
			areaB.alpha = 0.1; areaB.x = 170; areaB.y = 480; stage.addChild(areaB);
			
			area.name = "AreaA";
			areaB.name = "AreaB";
			
			Site.NewDropArea(area, 45, 10, false, false, true);
			Site.NewDropArea(areaB, 45, 10, false, true, true);
			
			// =======
			
			var ItemA:Box = new Box( { border:0, w:155, h:100, x:0, y:0, color:0xFF0000 } );
			ItemA.alpha = 0.4; ItemA.x = 5;
			stage.addChild(ItemA);
			
			var ItemB:Box = new Box( { border:0, w:100, h:45, x:0, y:0, color:0x0000FF } );
			ItemB.alpha = 0.4; ItemB.y = 110; ItemB.x = 5;
			stage.addChild(ItemB);
			
			var ItemC:Box = new Box( { border:0, w:100, h:100, x:0, y:0, color:0xFFFF00 } );
			ItemC.alpha = 0.6; ItemC.y = 165; ItemC.x = 5;
			stage.addChild(ItemC);
			
			var ItemD:Box = new Box( { border:0, w:100, h:155, x:0, y:0, color:0x00FF00 } );
			ItemD.alpha = 0.6; ItemD.y = 275; ItemD.x = 5;
			stage.addChild(ItemD);
			
			var ItemE:Box = new Box( { border:0, w:45, h:100, x:0, y:0, color:0x00FFFF } );
			ItemE.alpha = 0.4; ItemE.y = 440; ItemE.x = 5;
			stage.addChild(ItemE);
			
			ItemA.name = "ItemA";
			ItemB.name = "ItemB";
			ItemC.name = "ItemC";
			ItemD.name = "ItemD";
			ItemE.name = "ItemE";
			
			Site.AddItem(ItemA, ItemA, {
				DropLimits:"All"
			} );
			Site.AddItem(ItemB, ItemB, {
				DropLimits:"All"
			} );
			Site.AddItem(ItemC, ItemC, {
				DropLimits:"All"
			} );
			Site.AddItem(ItemD, ItemD, {
				DropLimits:"All"
			} );
			Site.AddItem(ItemE, ItemE, {
				DropLimits:"All"
			} );
			
			var Bt:Box = new Box( { border:0, w:30, h:30, x:0, y:0, color:0x00FFFF } );
			Bt.alpha = 1; Bt.y = 10; Bt.x = 400; stage.addChild(Bt);
			
			function ClickF():void {
				
				var testea:Array = Site.GetItemsOfDropArea(area);
				Debug.Send("GetItemsOfDropArea: " + testea, "Info", { p:"test", c:"Test", m:tS } );
				
				var teste:Object = Site.GetAreaOfItem("ItemA");
				if(Boolean(teste)) {
					Debug.Send("GetAreaOfItem: " + teste.name, "Info", { p:"test", c:"Test", m:tS } );
				} else {
					Debug.Send("GetAreaOfItem: " + teste, "Info", { p:"test", c:"Test", m:tS } );
				}
				
			}
			Bt.addEventListener(MouseEvent.CLICK, ClickF);
			
			// =======
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
		
	}
	
}