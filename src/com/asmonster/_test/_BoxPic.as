package com.asmonster._test
{
	
	import flash.display.MovieClip;
	import com.asmonster.interfaces.Box;
	
	public class _BoxPic extends MovieClip
	{
		
		public var Loader:Object;
		
		public function _BoxPic() 
		{
			
			var myBox:Box = new Box( {
				w:120,
				h:80,
				btMode:true,
				hoverScale:0.9,
				hoverBright:true
			} );
			addChild(myBox);
			Loader = myBox.Loader;
			
		}
	}
}