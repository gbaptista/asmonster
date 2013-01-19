package com.asmonster._test 
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class NewShape2 extends MovieClip
	{
		
		public function NewShape2( d:Number = 80 )
		{			
			var bkg:Shape = new Shape();
			bkg.graphics.beginFill(0xCCCCCC);
			bkg.graphics.moveTo(0, 0);
			bkg.graphics.lineTo(d, 0);
			bkg.graphics.lineTo(d, d);
			bkg.graphics.lineTo(0, d);
			bkg.graphics.lineTo(0, 0);
			
			bkg.x = -(d / 2);
			bkg.y = -(d / 2);
			
			addChild(bkg);
		}
		
	}
	
}