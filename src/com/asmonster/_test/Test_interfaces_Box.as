package com.asmonster._test 
{
	
	import flash.display.Stage;
	
	import flash.events.MouseEvent;
	
	import com.asmonster.interfaces.LoaderBox;
	import com.asmonster.interfaces.Box;
	
	import com.asmonster.utils.Debug;
	
	public class Test_interfaces_Box 
	{
		
		public function Test_interfaces_Box(stage:Stage) 
		{
			
			var tS:String = "Test_interfaces_Box";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			
			//BoxBorderCnt.BoxBorderMc
			//BoxBorderCnt.BoxBorderMc.ContLoader
			
			// # Box 1
			var Box1:Box = new Box();
			Box1.x = 60; Box1.y = 60;
			stage.addChild(Box1);
			
			// # Box 2
			var Box2:Box = new Box( {
				w:100,
				h:80,
				bT:8,
				bB:4,
				bL:4,
				bR:4,
				x:0,
				y:0,
				color:0x009900,
				borderColor:0x333333,
				hoverColor:0xFFFF00,
				hoverBorderColor:0xFF0000
			} );
			Box2.x = 50; Box2.y = 100;
			stage.addChild(Box2);
			
			// # Box 3
			var Box3:Box = new Box( {
				w:100,
				h:80,
				border:4,
				btMode:true,
				hoverAlpha:0.6,
				hoverScale:1.1
			} );
			Box3.x = 300; Box3.y = 60;
			stage.addChild(Box3);
			function ClickF():void {
				Debug.Send("Click", "Info", { p:"test", c:"Test", m:tS } );
			}
			Box3.Button.addEventListener(MouseEvent.CLICK, ClickF);
			var LdImage:LoaderBox = new LoaderBox( { Target:Box3.Loader } );
			LdImage.Load("com/asmonster/_test/images/s/9.jpg");
			
			// # Box 4
			var Box4:Box = new Box( {
				w:100,
				h:80,
				border:12,
				btMode:true,
				hoverScale:1.3,
				hoverBright:2,
				hoverBorderColor:0x333333,
				loaderAlpha:1
			} );
			Box4.x = 300; Box4.y = 200;
			stage.addChild(Box4);
			var LdImageB:LoaderBox = new LoaderBox( { Target:Box4.Loader } );
			LdImageB.Load("com/asmonster/_test/images/s/7.jpg");
			
			// # Box 4 B
			var Box4b:Box = new Box( {
				w:100,
				h:100,
				border:12,
				btMode:true,
				hoverScale:1.3,
				hoverBright:2,
				bR:1,
				hoverBorderColor:0x333333,
				loaderAlpha:1
			} );
			Box4b.x = 300; Box4b.y = 350;
			stage.addChild(Box4b);
			var LdImageBb:LoaderBox = new LoaderBox( { Target:Box4b.Loader } );
			LdImageBb.Load("com/asmonster/_test/images/s/3.jpg");
			
			// # Box 5
			var Box5:Box = new Box( {
				w:100,
				h:80,
				border:6,
				btMode:true,
				colorAlpha:0.5,
				borderAlpha:1
			} );
			Box5.x = 500;
			Box5.y = 200;
			stage.addChild(Box5);
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
		}
		
	}
}