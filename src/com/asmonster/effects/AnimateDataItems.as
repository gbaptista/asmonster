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
	
	import com.asmonster.utils.Debug;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	/**
	 * Generates a set of animations for data items
	*/
	public class AnimateDataItems 
	{
		
		private var CtrlTime:Number;
		private var Time:Number = 0.6;
		private var EaseIn:Function = Expo.easeOut;
		private var EaseOut:Function = Expo.easeIn;
		private var TypeS:String = "ItemByItem";
		private var TypeH:String = "All";
		private var alpha:Boolean = true;
		private var scaleX:Boolean = false;
		private var scaleY:Boolean = false;
		private var slideX:Boolean = false;
		private var slideY:Boolean = false;
		private var rotation:Boolean = false;
		private var DelayIn:Number = 4;
		private var DelayOut:Number = 4;
		
		/**
		 * Time to begin the fill of the data
		 * @default Time - (Time / 10)
		*/
		public var TimeForFill:Number = Time - (Time / 10);
		
		/**
		 * Create a new set of animations for items
		 * 
		 * @param	and_parameters		Object with the animation parameters
		 *								<p> <code>.Time			:Number</code>		— Time in seconds for animation of each item (defaults 1)</p>
		 *								<p> <code>.Delay			:Number</code>		— Interval between show and hide animation of items [Time divided per Delay] (defaults 4)</p>
		 *								<p> <code>.DelayIn			:Number</code>		— Interval between show animation of items [Time divided per DelayIn] (defaults 4)</p>
		 *								<p> <code>.DelayOut		:Number</code>		— Interval between hide animation of items [Time divided per DelayOut] (defaults 4)</p>
		 *								<p> <code>.Type			:String</code>		— Type of show and hide animation ['ItemByItem' or 'All']</p>
		 *								<p> <code>.TypeS			:String</code>		— Type of show animation ['ItemByItem' or 'All'] (defaults 'ItemByItem')</p>
		 *								<p> <code>.TypeH			:String</code>		— Type of hide animation ['ItemByItem' or 'All'] (defaults 'All')</p>
		 *								<p> <code>.Ease			:Function</code>	— Tweenmax ease to be used in show and hide animation</p>
		 *								<p> <code>.EaseIn			:Function</code>	— Tweenmax ease to be used in show animation (defaults 'Expo.easeOut')</p>
		 *								<p> <code>.EaseOut			:Function</code>	— Tweenmax ease to be used in hide animation (defaults 'Expo.easeIn')</p>
		 *								<p> <code>.alpha			:Boolean</code>		— Enable or disable animation in alpha property (defaults true)</p>
		 *								<p> <code>.scaleX			:Boolean</code>		— Enable or disable animation in scaleX property (defaults false)</p>
		 *								<p> <code>.scaleY			:Boolean</code>		— Enable or disable animation in scaleY property (defaults false)</p>
		 *								<p> <code>.slideX			:Boolean</code>		— Enable or disable animation in x property (defaults false)</p>
		 *								<p> <code>.slideY			:Boolean</code>		— Enable or disable animation in y property (defaults false)</p>
		 *								<p> <code>.rotation		:Boolean</code>		— Enable or disable animation in rotation property (defaults false)</p>
		 * 
		 * @see asmonster.database.UseData
		 * 
		 */
		public function AnimateDataItems(and_parameters:Object = null):void
		{
			if (Boolean(and_parameters)) {
				if (and_parameters.Time != null && and_parameters.Time != undefined) {
					if(isNaN(and_parameters.Time)) {
						Debug.Send("Time must be a numeric value, the default value (1) has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					} else {
						Time = and_parameters.Time;
						TimeForFill = Time - (Time / 10);
					}
				};
				if (and_parameters.Delay != null && and_parameters.Delay != undefined) {
					if(isNaN(and_parameters.Delay)) {
						Debug.Send("Delay must be a numeric value, the default value (4) has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					} else {
						DelayIn = and_parameters.Delay;
						DelayOut = and_parameters.Delay;
					}
				};
				if (and_parameters.DelayIn != null && and_parameters.DelayIn != undefined) {
					if(isNaN(and_parameters.DelayIn)) {
						Debug.Send("DelayIn must be a numeric value, the default value (4) has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					} else {
						DelayIn = and_parameters.DelayIn;
					}
				};
				if (and_parameters.DelayOut != null && and_parameters.DelayOut != undefined) {
					if(isNaN(and_parameters.DelayOut)) {
						Debug.Send("DelayOut must be a numeric value, the default value (4) has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					} else {
						DelayOut = and_parameters.DelayOut;
					}
				};
				if (and_parameters.Type != null && and_parameters.Type != undefined) {
					if(and_parameters.Type == "All" || and_parameters.Type == "ItemByItem") {
						TypeS = and_parameters.Type;
						TypeH = and_parameters.Type;
					} else {
						Debug.Send("Type must be 'ItemByItem' or 'All', the defaults value ('ItemByItem') for show and ('All') for hide has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					}
				}
				if (and_parameters.TypeS != null && and_parameters.TypeS != undefined) {
					if(and_parameters.TypeS == "All" || and_parameters.TypeS == "ItemByItem") {
						TypeS = and_parameters.TypeS;
					} else {
						Debug.Send("TypeS must be 'ItemByItem' or 'All', the defaults value ('ItemByItem') has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					}
				}
				if (and_parameters.TypeH != null && and_parameters.TypeH != undefined) {
					if(and_parameters.TypeH == "All" || and_parameters.TypeH == "ItemByItem") {
						TypeH = and_parameters.TypeH;
					} else {
						Debug.Send("TypeH must be 'ItemByItem' or 'All', the defaults value ('All') has been defined", "Alert", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
					}
				}
				if (and_parameters.Transition as Function) {
					EaseIn = and_parameters.Transition;
					EaseOut = and_parameters.Transition;
				};
				if (and_parameters.EaseIn as Function) {
					EaseIn = and_parameters.EaseIn;
				}
				if (and_parameters.EaseOut as Function) {
					EaseOut = and_parameters.EaseOut;
				}
				if (and_parameters.alpha == false) { alpha = false; };
				if (and_parameters.scaleX == true) { scaleX = true; };
				if (and_parameters.scaleY == true) { scaleY = true; };
				if (and_parameters.slideX == true) { slideX = true; };
				if (and_parameters.slideY == true) { slideY = true; };
				if (and_parameters.rotation == true) { rotation = true; };
			}
			Debug.Send("NewInstance", "Info", { p:"animate", c:"AnimateDataItems", m:"AnimateDataItems" } );
		}
		
		/**
		 * Change the alpha property of all items to 0
		 * 
		 * @param	ObjItems	Array with items
		 */
		public function ClearForAnimation(ObjItems:Array):void {
			for (var x:int = 0; x < ObjItems.length; x ++) {
				ObjItems[x].alpha = 0;
				ObjItems[x].visible = false;
			}
		}
		
		/**
		 * Hide the items
		 * 
		 * @param	ObjItems	Array with items
		 * @param	Positions	Array with positions of the items
		 */
		public function AnimateHide(ObjItems:Array, Positions:Array):void {
			for (var x:int = 0; x < ObjItems.length; x ++) {
				if (Boolean(ObjItems[x])) {
					TweenMax.killTweensOf(ObjItems[x]);
					var hDelay:Number;
					if (TypeS == "All" && TypeH == "All") {
						hDelay = 0;
						TimeForFill = Time;
					} else {
						if (TypeS == "ItemByItem" && TypeH == "All") {
							hDelay = 0;
							TimeForFill = Time;
						} else if (TypeS == "All" && TypeH == "ItemByItem") {
							hDelay = (Time / DelayOut) * (x);
							TimeForFill = ((Time / DelayOut) * (ObjItems.length)) + Time;
						} else {
							hDelay = (Time / DelayOut) * (x);
							TimeForFill = ((Time / DelayOut) * (ObjItems.length)) + Time;
						}
					}
					
					var setVF:Function = function(obj:Object):void { obj.visible = false; };
					
					if (Boolean(alpha)) {
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, alpha:0, overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					} else {
						ObjItems[x].alpha = 1;
					}
					if (Boolean(scaleX)) {
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, scaleX:0, overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					}
					if (Boolean(scaleY)) {
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, scaleY:0, overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					}
					if (Boolean(slideX)) {
						var Nw:Number = Positions[x].w;
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, x:Positions[x].x + (Nw * 2), overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					}
					if (Boolean(slideY)) {
						var Ny:Number = Positions[x].h;
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, y:Positions[x].y + (Ny * 2), overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					}
					if(Boolean(rotation)){
						TweenMax.to(ObjItems[x], Time, { delay:hDelay, rotation:270, overwrite:0, ease:EaseOut, onComplete:setVF, onCompleteParams:[ObjItems[x]] } );
					}
				}
			}
		}
		
		/**
		 * Show the items
		 * 
		 * @param	ObjItems	Array with items
		 * @param	Positions	Array with positions of the items
		 */
		public function AnimateShow(ObjItems:Array, Positions:Array):void {
			for (var x:int = 0; x < ObjItems.length; x ++) {
				if (Boolean(ObjItems[x])) {
					TweenMax.killTweensOf(ObjItems[x]);
					var sDelay:Number;
					if (TypeS == "All" && TypeH == "All") {
						sDelay = 0;
					} else {
						if (TypeS == "All" && TypeH == "ItemByItem") {
							sDelay = (Time / DelayOut) * (x);
						} else {
							sDelay = (Time / DelayOut) * (x);
						}
					}
					if (Boolean(alpha)) {
						var alpST:Function = function(obj:Object):void { obj.alpha = 0; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, alpha:1, overwrite:0, ease:EaseIn, onInit:alpST, onInitParams:[ObjItems[x]] } );
					} else {
						ObjItems[x].alpha = 1;
					}
					if (Boolean(scaleX)) {
						var sclxST:Function = function(obj:Object):void { obj.scaleX = 0; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, scaleX:1, overwrite:0, ease:EaseIn, onInit:sclxST, onInitParams:[ObjItems[x]] } );
					}
					if (Boolean(scaleY)) {
						var sclyST:Function = function(obj:Object):void { obj.scaleY = 0; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, scaleY:1, overwrite:0, ease:EaseIn, onInit:sclyST, onInitParams:[ObjItems[x]] } );
					}
					if (Boolean(slideX)) {
						var Nw:Number = Positions[x].w;
						var slxST:Function = function(obj:Object, nx:Number):void { obj.x = nx; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, x:Positions[x].x, overwrite:0, ease:EaseIn, onInit:slxST, onInitParams:[ObjItems[x], ObjItems[x].x - (Nw * 4)] } );
					}
					if (Boolean(slideY)) {
						var Ny:Number = Positions[x].h;
						var slyST:Function = function(obj:Object, nx:Number):void { obj.y = nx; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, y:Positions[x].y, overwrite:0, ease:EaseIn, onInit:slyST, onInitParams:[ObjItems[x], ObjItems[x].y - (Ny * 4)] } );
					}
					if (Boolean(rotation)) {
						var rtST:Function = function(obj:Object):void { obj.rotation = 270; obj.visible = true; };
						TweenMax.to(ObjItems[x], Time, { delay:sDelay, rotation:0, overwrite:0, ease:EaseIn, onInit:rtST, onInitParams:[ObjItems[x]] } );
					}
				}
			}
		}
	}
}