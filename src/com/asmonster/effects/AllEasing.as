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

package com.asmonster.effects 
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	
	
	public class AllEasing 
	{
		
		public function AllEasing() 
		{
			
		}
		
		public static function get getEasings():Array {
			var easArr:Array = new Array();
			
			var i:Number = -1;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Back.easeIn"; easArr[i][1] = Back.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Back.easeInOut"; easArr[i][1] = Back.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Back.easeOut"; easArr[i][1] = Back.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Bounce.easeIn"; easArr[i][1] = Bounce.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Bounce.easeInOut"; easArr[i][1] = Bounce.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Bounce.easeOut"; easArr[i][1] = Bounce.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Circ.easeIn"; easArr[i][1] = Circ.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Circ.easeInOut"; easArr[i][1] = Circ.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Circ.easeOut"; easArr[i][1] = Circ.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Cubic.easeIn"; easArr[i][1] = Cubic.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Cubic.easeInOut"; easArr[i][1] = Cubic.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Cubic.easeOut"; easArr[i][1] = Cubic.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Elastic.easeIn"; easArr[i][1] = Elastic.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Elastic.easeInOut"; easArr[i][1] = Elastic.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Elastic.easeOut"; easArr[i][1] = Elastic.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Expo.easeIn"; easArr[i][1] = Expo.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Expo.easeInOut"; easArr[i][1] = Expo.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Expo.easeOut"; easArr[i][1] = Expo.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Linear.easeIn"; easArr[i][1] = Linear.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Linear.easeInOut"; easArr[i][1] = Linear.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Linear.easeNone"; easArr[i][1] = Linear.easeNone;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Linear.easeOut"; easArr[i][1] = Linear.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quad.easeIn"; easArr[i][1] = Quad.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quad.easeInOut"; easArr[i][1] = Quad.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quad.easeOut"; easArr[i][1] = Quad.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quart.easeIn"; easArr[i][1] = Quart.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quart.easeInOut"; easArr[i][1] = Quart.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quart.easeOut"; easArr[i][1] = Quart.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quint.easeIn"; easArr[i][1] = Quint.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quint.easeInOut"; easArr[i][1] = Quint.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Quint.easeOut"; easArr[i][1] = Quint.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Sine.easeIn"; easArr[i][1] = Sine.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Sine.easeInOut"; easArr[i][1] = Sine.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Sine.easeOut"; easArr[i][1] = Sine.easeOut;
			
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Strong.easeIn"; easArr[i][1] = Strong.easeIn;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Strong.easeInOut"; easArr[i][1] = Strong.easeInOut;
			i = i + 1; easArr[i] = new Array(); easArr[i][0] = "Strong.easeOut"; easArr[i][1] = Strong.easeOut;
			
			return easArr;
		}
		
	}
	
}