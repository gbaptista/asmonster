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

package com.asmonster.interfaces 
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	
	import com.asmonster.utils.Debug;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	/**
	 * Create a Box with several functionalities
	*/
	public class Box extends MovieClip
	{
		
		private var BoxShp:Shape = new Shape();
		private var Mask:Shape = new Shape();
		private var BoxBorderMc:MovieClip = new MovieClip();
		
		private var BorderT:Shape = new Shape();
		private var BorderB:Shape = new Shape();
		private var BorderL:Shape = new Shape();
		private var BorderR:Shape = new Shape();
		
		private var ContLoader:MovieClip = new MovieClip();
		
		private var color:uint = 0x333333;
		private var borderColor:uint = 0xFF0000;
		
		private var dmBoxW:Number = 20;
		private var dmBoxH:Number = 20;
		
		private var dmBorderT:Number = 3;
		private var dmBorderB:Number = 3;
		private var dmBorderL:Number = 3;
		private var dmBorderR:Number = 3;
		
		private var xp:Number = undefined;
		private var yp:Number = undefined;
		
		private var btMode:Boolean = false;
		
		private var hoverAlpha:Number = undefined;
		private var hoverScale:Number = undefined;
		
		private var hoverBright:Number = undefined;
		private var hoverColor:uint = undefined;
		private var hoverBorderColor:uint = undefined;
		
		private var BoxBorderCnt:MovieClip = new  MovieClip();
		
		private var autoAlign:Boolean = true;
		
		/**
		 * Get the Loader object of the box
		 */
		public function get Loader():MovieClip {
			return ContLoader;
		}
		
		/**
		 * Get the Button object of the box
		 */
		public function get Button():MovieClip {
			BoxBorderMc.buttonMode = true;
			return BoxBorderMc;
		}
		
		/**
		 * Send to debug the new instance created
		 * @default false
		 */
		public function set Send(nv:Boolean):void {
			Debug.Send("NewInstance", "Info", { p:"interfaces", c:"Box", m:"Box" } );
		}
		
		/**
		 * Create a new box instance
		 * 
		 * @param	bP			Object	  								Object with the Box parameters
		 *						<p> <code>.w					:Number</code>		— Width of the box (defaults 20)</p>
		 *						<p> <code>.h					:Number</code>		— Height of the box (defaults 20)</p>
		 *						<p> <code>.border				:Number</code>		— Size of the border (defaults 3)</p>
		 *						<p> <code>.bT					:Number</code>		— Size of the top border (defaults 3)</p>
		 *						<p> <code>.bB					:Number</code>		— Size of the bottom border (defaults 3)</p>
		 *						<p> <code>.bL					:Number</code>		— Size of the left border (defaults 3)</p>
		 *						<p> <code>.bR					:Number</code>		— Size of the right border (defaults 3)</p>
		 *						<p> <code>.x					:Number</code>		— X position of the box (defaults auto in center)</p>
		 *						<p> <code>.y					:Number</code>		— Y position of the box (defaults auto in center)</p>
		 *						<p> <code>.color				:uint</code>		— Color of the box (defaults 0x333333)</p>
		 *						<p> <code>.borderColor			:uint</code>		— Color of the border (defaults 0xFF0000)</p>
		 *						<p> <code>.colorAlpha			:Number</code>		— Alpha of the box (defaults 1)</p>
		 *						<p> <code>.borderAlpha			:Number</code>		— Alpha of the border (defaults 1)</p>
		 *						<p> <code>.loaderAlpha			:Number</code>		— Alpha of the Loader (defaults 1)</p>
		 * 
		 *						<p> <code>.btMode				:Boolean</code>		— Button mode (defaults false)</p>
		 * 
		 *						<p> <code>.hoverAlpha			:Number</code>		— Alpha in hover animation (defaults false)</p>
		 *						<p> <code>.hoverScale			:Number</code>		— Scale in hover animation (defaults false)</p>
		 *						<p> <code>.hoverBright			:uint</code>		— Bright in hover animation (defaults false)</p>
		 *						<p> <code>.hoverColor			:uint</code>		— Color in hover animation (defaults false)</p>
		 *						<p> <code>.hoverBorderColor	:Number</code>		— Border color in hover animation (defaults false)</p>
		 * 
		 *						<p> <code>.autoAlign			:Bollean</code>		— Auto align the image loaded in the center (defaults true)</p>
		 * 
		 * @example
<listing version="3.0">
var Box5:Box = new Box( {
	w:100,
	h:80,
	border:6,
	btMode:true,
	colorAlpha:0.5,
	borderAlpha:1
} );
</listing>
		 * 
		 * 
		 */
		public function Box( bP:Object = undefined ):void
		{
			
			BoxBorderCnt.name = "BoxBorderCnt";
			BoxBorderMc.name = "BoxBorderMc";
			ContLoader.name = "ContLoader";
			
			if (Boolean(bP && bP as Object)) {
				if (bP.autoAlign == false) {
					autoAlign = false;
				}
				
				if (Boolean(bP.hoverAlpha)) { hoverAlpha = bP.hoverAlpha; };
				if (Boolean(bP.hoverScale)) { hoverScale = bP.hoverScale; };
				
				if (Boolean(bP.hoverBright)) { hoverBright = bP.hoverBright; };
				if (Boolean(bP.hoverColor)) { hoverColor = bP.hoverColor; };
				if (Boolean(bP.hoverBorderColor)) { hoverBorderColor = bP.hoverBorderColor; };
				
				if (Boolean(bP.btMode)) { btMode = bP.btMode; };
				
				if (!Boolean(isNaN(bP.w))) { dmBoxW = bP.w; };
				if (!Boolean(isNaN(bP.h))) { dmBoxH = bP.h; };
				if (!Boolean(isNaN(bP.border))) {
					dmBorderT = bP.border; dmBorderB = bP.border;
					dmBorderL = bP.border; dmBorderR = bP.border;
				}
				if (!Boolean(isNaN(bP.bT))) { dmBorderT = bP.bT; };
				if (!Boolean(isNaN(bP.bB))) { dmBorderB = bP.bB; };
				if (!Boolean(isNaN(bP.bL))) { dmBorderL = bP.bL; };
				if (!Boolean(isNaN(bP.bR))) { dmBorderR = bP.bR; };
				if (!Boolean(isNaN(bP.x))) { xp = bP.x; };
				if (!Boolean(isNaN(bP.y))) { yp = bP.y; };
				if (Boolean(bP.color && bP.color as uint)) {
					color = bP.color;
				}
				if (Boolean(bP.borderColor && bP.borderColor as uint)) {
					borderColor = bP.borderColor;
				}
			}
			
			BoxShp.graphics.beginFill(color);
			BoxShp.graphics.moveTo(0, 0);
			BoxShp.graphics.lineTo(dmBoxW, 0);
			BoxShp.graphics.lineTo(dmBoxW, dmBoxH);
			BoxShp.graphics.lineTo(0, dmBoxH);
			BoxShp.graphics.lineTo(0, 0);
			BoxShp.x = dmBorderL; BoxShp.y = dmBorderT;
			if (Boolean(bP && bP as Object && bP.colorAlpha < 1.1)) {
				BoxShp.alpha = bP.colorAlpha;
			}
			
			Mask.graphics.beginFill(color, 0);
			Mask.graphics.moveTo(0, 0);
			Mask.graphics.lineTo(dmBoxW, 0);
			Mask.graphics.lineTo(dmBoxW, dmBoxH);
			Mask.graphics.lineTo(0, dmBoxH);
			Mask.graphics.lineTo(0, 0);
			Mask.x = dmBorderL; Mask.y = dmBorderT;
			
			ContLoader.mask = Mask;
			
			var alpTo:Number;
			
			if (Boolean(bP && bP as Object && bP.loaderAlpha < 1.1)) {
				ContLoader.alpha = bP.loaderAlpha;
				alpTo = bP.loaderAlpha;
			} else {
				alpTo = 1;
			}
			
			BorderL.graphics.beginFill(borderColor);
			BorderL.graphics.moveTo(0, 0);
			BorderL.graphics.lineTo(dmBorderL, 0);
			BorderL.graphics.lineTo(dmBorderL, dmBoxH + (dmBorderB + dmBorderT));
			BorderL.graphics.lineTo(0, dmBoxH + (dmBorderB + dmBorderT));
			BorderL.graphics.lineTo(0, 0);
			BorderL.x = 0; BorderL.y = 0;
			
			BorderR.graphics.beginFill(borderColor);
			BorderR.graphics.moveTo(0, 0);
			BorderR.graphics.lineTo(dmBorderR, 0);
			BorderR.graphics.lineTo(dmBorderR, dmBoxH + (dmBorderB + dmBorderT));
			BorderR.graphics.lineTo(0, dmBoxH + (dmBorderB + dmBorderT));
			BorderR.graphics.lineTo(0, 0);
			BorderR.x = dmBoxW + dmBorderL; BorderR.y = 0;
			
			BorderT.graphics.beginFill(borderColor);
			BorderT.graphics.moveTo(0, 0);
			if (dmBorderR > 0) {
				BorderT.graphics.lineTo(dmBoxW + 0.1, 0);
				BorderT.graphics.lineTo(dmBoxW + 0.1, dmBorderT);
			} else {
				BorderT.graphics.lineTo(dmBoxW, 0);
				BorderT.graphics.lineTo(dmBoxW, dmBorderT);
			}
			BorderT.graphics.lineTo(0, dmBorderT);
			BorderT.graphics.lineTo(0, 0);
			BorderT.x = dmBorderL; BorderT.y = 0;
			
			BorderB.graphics.beginFill(borderColor);
			BorderB.graphics.moveTo(0, 0);
			if (dmBorderR > 0) {
				BorderB.graphics.lineTo(dmBoxW + 0.1, 0);
				BorderB.graphics.lineTo(dmBoxW + 0.1, dmBorderB);
			} else {
				BorderB.graphics.lineTo(dmBoxW, 0);
				BorderB.graphics.lineTo(dmBoxW, dmBorderB);
			}
			BorderB.graphics.lineTo(0, dmBorderB);
			BorderB.graphics.lineTo(0, 0);
			BorderB.x = dmBorderL; BorderB.y = dmBoxH+dmBorderT;
			
			if (Boolean(bP && bP as Object && bP.borderAlpha < 1.1)) {
				BorderB.alpha = bP.borderAlpha;
				BorderT.alpha = bP.borderAlpha;
				BorderR.alpha = bP.borderAlpha;
				BorderL.alpha = bP.borderAlpha;
			}
			
			BoxBorderMc.addChild(BorderB);
			BoxBorderMc.addChild(BorderT);
			BoxBorderMc.addChild(BorderR);
			BoxBorderMc.addChild(BorderL);
			
			BoxBorderMc.addChild(BoxShp);
			BoxBorderMc.addChild(ContLoader);
			BoxBorderMc.addChild(Mask);
			
			BoxBorderCnt.addChild(BoxBorderMc);
			
			ContLoader.x = dmBorderL; ContLoader.y = dmBorderT;
			
			if(Boolean(autoAlign)) {
				function algLoad():void {
						ContLoader.x = dmBorderL + ((dmBoxW / 2) - (ContLoader.width / 2));
						ContLoader.y = dmBorderT + ((dmBoxH / 2) - (ContLoader.height / 2));
				}
				setInterval(algLoad, 75);
			}
			
			if (!Boolean(xp == 0 || xp > 0)) {
				BoxBorderMc.x = -(BoxBorderMc.width / 2);
			} else { BoxBorderMc.x = xp; };
			if (!Boolean(yp == 0 || yp > 0)) {
				BoxBorderMc.y = -(BoxBorderMc.height / 2);
			} else { BoxBorderMc.y = yp; };
			
			if (Boolean(btMode)) {
				BoxBorderMc.buttonMode = true;
			}
			
			if (Boolean(hoverAlpha)) {
				BoxBorderCnt.alpha = hoverAlpha;
			}
			
			function Over(event:MouseEvent):void {
				TweenMax.killTweensOf(ContLoader); TweenMax.killTweensOf(BoxBorderCnt);
				TweenMax.killTweensOf(BoxShp);
				if (Boolean(hoverColor)) {
					TweenMax.to(BoxShp, 0.3, { tint:hoverColor, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverBright)) {
					TweenMax.to(ContLoader, 0.5, { colorMatrixFilter: { brightness:hoverBright }, alpha:alpTo, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverAlpha)) {
					TweenMax.to(BoxBorderCnt, 0.5, { alpha:1, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverScale)) {
					TweenMax.to(BoxBorderCnt, 0.5, { scaleX:hoverScale, scaleY:hoverScale, overwrite:0, ease:Expo.easeOut } );
				}
				
				if (Boolean(hoverBorderColor)) {
					TweenMax.killTweensOf(BorderB); TweenMax.killTweensOf(BorderT);
					TweenMax.killTweensOf(BorderL); TweenMax.killTweensOf(BorderR);
					
					TweenMax.to(BorderB, 0.3, { tint:hoverBorderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderT, 0.3, { tint:hoverBorderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderL, 0.3, { tint:hoverBorderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderR, 0.3, { tint:hoverBorderColor, overwrite:0, ease:Expo.easeOut } );
				}
			}	
			function Out(event:MouseEvent):void {
				TweenMax.killTweensOf(ContLoader); TweenMax.killTweensOf(BoxBorderCnt);
				TweenMax.killTweensOf(BoxShp);
				if (Boolean(hoverColor)) {
					TweenMax.to(BoxShp, 0.4, { tint:color, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverBorderColor)) {
					TweenMax.killTweensOf(BorderB); TweenMax.killTweensOf(BorderT);
					TweenMax.killTweensOf(BorderL); TweenMax.killTweensOf(BorderR);
					TweenMax.to(BorderB, 0.4, { tint:borderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderT, 0.4, { tint:borderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderL, 0.4, { tint:borderColor, overwrite:0, ease:Expo.easeOut } );
					TweenMax.to(BorderR, 0.4, { tint:borderColor, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverBright)) {
					TweenMax.to(ContLoader, 0.5, { colorMatrixFilter: { brightness:1 }, alpha:alpTo, overwrite:0, ease:Expo.easeOut } );
				}
				if (Boolean(hoverAlpha)) {
					TweenMax.to(BoxBorderCnt, 0.5, { alpha:hoverAlpha, overwrite:0, ease:Expo.easeOut } );
				}
				if(Boolean(hoverScale)) {
					TweenMax.to(BoxBorderCnt, 0.5, { scaleX:1, scaleY:1, overwrite:0, ease:Expo.easeOut } );
				}
			}
			BoxBorderMc.addEventListener(MouseEvent.MOUSE_OUT, Out);
			BoxBorderMc.addEventListener(MouseEvent.MOUSE_OVER, Over);
			
			addChild(BoxBorderCnt);
			
		}
	}
}