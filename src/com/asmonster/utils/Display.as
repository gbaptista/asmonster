/**
 * 
 * asMonster
 *
 * @author		Guilherme Baptista
 * @version		1.8.6 Beta
 * 
 * #updated		2010-07-26
 * 
 * asMonster Site:		http://asmonster.gbaptista.com/
 * Google Code Page:	http://code.google.com/p/asmonster/
 * Documentation:		http://asmonster.gbaptista.com/docs/
 * 
 * Licensed under the GNU Lesser General Public License: http://www.gnu.org/licenses/lgpl.html
 * 
 * Copyright (c) 2010 Guilherme Baptista
 * 
 * 
 * Using TweenMax Version: 11.37, Updated 2010-05-14
 * More about the TweenMax: http://www.greensock.com/tweenmax/
 * 
 */

package com.asmonster.utils 
{
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.asmonster.utils.Debug;

	public class Display
	{
		
		public function Display():void
		{
			
		}
		
		public static function getRegistrationPoint(Obj:Object, ptObj:Object = undefined):Object {
			
			var RegX:Number = Obj.getBounds(Obj).x;
			var RegY:Number = Obj.getBounds(Obj).y;
			
			if (Boolean(ptObj)) {
				ptObj.x = Obj.x + RegX;
				ptObj.y = Obj.y + RegY;
			}
			
			var rtObj:Object = new Object();
			
			rtObj.x = RegX;
			rtObj.y = RegY;
			
			return rtObj;
			
		}
		
	}

}