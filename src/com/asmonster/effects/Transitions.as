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
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import com.asmonster.utils.Debug;
	import com.asmonster.utils.Generic;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Expo;
	
	/**
	 * Create transitions effects
	 */
	public class Transitions 
	{
		
		private static var Objs:Array = new Array();
		private static var ObjsDelay:Array = new Array();
		
		/**
		 * Não há construtor.
		 */
		public function Transitions():void
		{
			
		}
		
		/**
		 * Pega o Index da transition do target...
		 * 
		 * @param	Target				Target para verificar...
		 * 
		 */
		private static function getTransitionTimerIndex(Target:Object):Number {
			for (var i:int = 0; i < ObjsDelay.length; i++) 
			{
				if (ObjsDelay[i].Target == Target) {
					return i;
				}
			}
			return undefined;
		}
		
		/**
		 * Pega o Index da transition do target...
		 * 
		 * @param	Target				Target para verificar...
		 * 
		 */
		public static function getTransitionIndex(Target:Object):Number {
			for (var i:int = 0; i < Objs.length; i++) 
			{
				if (Objs[i].Target == Target) {
					return i;
				}
			}
			return undefined;
		}
		
		/**
		 * Verifica se está animando...
		 * 
		 * @param	Target				Target para verificar...
		 * 
		 */
		public static function isInTransition(Target:Object):Boolean {
			for (var i:int = 0; i < Objs.length; i++) 
			{
				if (Objs[i].Target == Target) {
					return true;
				}
			}
			for (var a:int = 0; a < ObjsDelay.length; a++) 
			{
				if (ObjsDelay[a].Target == Target) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Kill transition of a target
		 * 
		 * @param	Target				Target Object to kill transition
		 * 
		 */
		public static function killTransition(Target:Object, sendMessage:Boolean = false):Boolean {
			
			for (var a:int = 0; a < ObjsDelay.length; a++) {
				if (ObjsDelay[a].Target == Target) {
					clearTimeout(ObjsDelay[a].delay);
					clearInterval(ObjsDelay[a].ckDmT);
					ObjsDelay.splice(a, 1);
				}
			}
			
			for (var i:int = 0; i < Objs.length; i++) {
				if (Objs[i].Target == Target) {
					clearTimeout(Objs[i].onEnd);
					TweenMax.killTweensOf(Objs[i].Target);
					Target.x = Objs[i].x;
					Target.y = Objs[i].y;
					Target.scaleY = Objs[i].scaleY;
					Target.scaleX = Objs[i].scaleX;
					Target.alpha = Objs[i].alpha;
					Target.rotation = Objs[i].rotation;
					
					TweenMax.to(Target, 0, { blurFilter: { blurX:0, blurY:0, quality:3 }, overwrite:0 } );
					TweenMax.to(Target, 0, { removeTint:true, overwrite:0 } );
					
					if (Boolean(Objs[i].maskTarget)) {
						if (Boolean(Objs[i].maskTarget.getChildByName("maskMc215641684"))) {
							var mcMask:MovieClip = Objs[i].maskTarget.getChildByName("maskMc215641684");
							for (var j:uint = 0; j < mcMask.numChildren; j++) {
								TweenMax.killTweensOf(mcMask.getChildAt(j));
							};
							Target.mask = null;
							Objs[i].maskTarget.removeChild(mcMask);
						};
					};
					Objs.splice(i, 1);
					if(Boolean(sendMessage)) { Debug.Send("Animation canceled", "Error"); }
					return true;
				}
			}
			
			return true;
			
		}
		
		/**
		 * Add a new transition in a target object
		 * 
		 * @param	Target				Target Object
		 * @param	Action				Action ['show' or 'hide'] (defaults 'show')
		 * @param	Params				Object with the New options
		 * 
		 * 								<p> <code>.onStart		:Function</code>	— Function to be called on start the transition</p>
		 * 								<p> <code>.onComplete	:Function</code>	— Function to be called on complete the transition</p>
		 * 
		 * 								<p> <code>.Type		:String</code>		— Type of graphic ['Stripe', 'Rect', 'Square', 'Circle' or 'Ellipse'] (defaults 'Stripe')</p>
		 * 								<p> <code>.Disposal	:String</code>		— Disposal of animation ['H' or 'V'] (defaults 'H')</p>
		 * 
		 * 								<p> <code>.Length		:Number</code>		— Length of graphics (defaults 1)</p>
		 * 								<p> <code>.Time		:Number</code>		— Time duration of transition (defaults 1)</p>
		 * 								<p> <code>.Gain		:Number</code>		— Gain between animations of the graphics [0 to 1] (defaults 0.2)</p>
		 * 
		 * 								<p> <code>.Ease		:Function</code>	— TweenMax Easing (defaults Expo.easeOut)</p>
		 * 
		 * 								<p> <code>.Slide		:String</code>		— Slide animation ['C', 'T' or 'B' + 'C', 'L' or 'R'] (defaults 'CC')</p>
 		 * 								<p> <code>.alpha		:Bollean</code>		— alpha animation (defaults false)</p>
 		 * 								<p> <code>.scaleX		:Bollean</code>		— scaleX animation (defaults false)</p>
 		 * 								<p> <code>.scaleY		:Bollean</code>		— scaleY animation (defaults false)</p>
 		 * 								<p> <code>.rotation	:Bollean</code>		— rotation animation (defaults false)</p>
		 * 
		 * 								<p> <code>.grScaleX	:Bollean</code>		— scaleX in graphic animation (defaults true)</p>
		 * 								<p> <code>.grScaleY	:Bollean</code>		— scaleY in graphic animation (defaults true)</p>
		 * 								<p> <code>.grRotation	:Bollean</code>		— rotation in graphic animation (defaults false)</p>
		 * 
		 * 								<p> <code>.BlurX		:Bollean</code>		— BlurX filter (defaults false)</p>
		 * 								<p> <code>.BlurY		:Bollean</code>		— BlurY filter (defaults false)</p>
		 * 
		 * 								<p> <code>.tint		:uint</code>		— Color tint (defaults null)</p>
		 * 
		 * 								<p> <code>.Direction	:String</code>		— Animation direction ['center', 'TL' or 'BR'] (defaults 'center')</p>
		 * 								<p> <code>.Shuffle		:Bollean</code>		— Shuffles the order of animations (replaces .Disposal) (defaults false)</p>
		 * 								<p> <code>.Reverse		:Bollean</code>		— Reverse the order of animations (defaults false)</p>
		 * 
		 * 								<p> <code>.Trash		:Boolean</code>		— Show the masks just to observe (defaults false)</p>
		 * 
		 */
		public static function New(Target:Object = null, Action:String = "show", Params:Object = null):Boolean {
			
			//função chamada assim que o objeto a ser animado é validado
			function startMt():void {
				
				//remove todas as transições anteriores
				killTransition(Target, true);
				
				var obj:Object = new Object();
				
				obj.Target = Target;
				if(Target as Stage) {
					obj.maskTarget = Target;
				} else {
					obj.maskTarget = Target.parent;
				}
				
				// ######### S Verifica as options ==============
				
					//Define variáveis padrões
					var Length:Number = 0;
					var Type:String = "Stripe";
					var Disposal:String = "H";
					
					var Direction:String = "center";
					var Shuffle:Boolean = false;
					var Reverse:Boolean = false;
					
					var grScaleX:Boolean = true;
					var grScaleY:Boolean = true;
					var grRotation:Boolean = false;
					var grSlide:String = "CC";
					
					var Time:Number = 0.6;
					var Gain:Number = 0.3;
					
					var Ease:Function 	= Expo.easeOut;
					var grEase:Function = Expo.easeOut;
					var spEase:Function = Linear.easeNone;
					
					var Slide:String = "CC";
					var alpha:Boolean = true;
					var scaleX:Boolean = false;
					var scaleY:Boolean = false;
					var rotation:Boolean = false;
					
					var BlurX:Boolean = false;
					var BlurY:Boolean = false;
					
					var tint:Number = -1;
					
					var Trash:Boolean = false;
					
					var onStart:Function = undefined;
					var onComplete:Function = undefined;
					
					var TargetWidth:Number;
					var TargetHeight:Number;
					
					var useMask:Boolean = true;
					var startMask:Object;
					var espCirc:Number = 2;
					
					//verifica alterações nas variáveis padrões
					if (Boolean(Params && Params as Object)) {
						
						if (Boolean(Params.Type as String) && Boolean(Params.Type == "Rect" || Params.Type == "Square" || Params.Type == "Circle" || Params.Type == "Ellipse")) {
							Type = Params.Type;
						}
						
						if (Params.Disposal as String && Params.Disposal == "V") {
							Disposal = Params.Disposal;
						}
						
						if (Number(Params.Length) > 0) {
							Length = int(Params.Length);
						}
						
						if (Params.Time > 0) {
							Time = Params.Time;
						}
						
						if (Params.Gain > -1) {
							Gain = Params.Gain;
						}
						
						if (Params.Ease as Function) {
							Ease = Params.Ease;
						}
						
						if (Params.grEase as Function) {
							grEase = Params.grEase;
						}
						
						if (Params.spEase as Function) {
							spEase = Params.spEase;
						}
						
						if (Params.AllEase as Function) {
							Ease = Params.AllEase; grEase = Params.AllEase; spEase = Params.AllEase;
						}
						
						if (Params.grScaleX == false) {
							grScaleX = false;
						}
						
						if (Params.grScaleY == false) {
							grScaleY = false;
						}
						
						if (Params.grRotation == true) {
							grRotation = true;
						}
						
						if (Params.alpha == false) {
							alpha = false;
						}
						
						if (Params.scaleX == true) {
							scaleX = true;
						}
						
						if (Params.scaleY == true) {
							scaleY = true;
						}
						
						if (Params.rotation == true) {
							rotation = true;
						}
						
						if (Params.BlurX == true) {
							BlurX = true;
						}
						
						if (Params.BlurY == true) {
							BlurY = true;
						}
						
						if (Params.tint > -1) {
							tint = uint(Params.tint);
						}
						
						if (Params.Direction as String && Boolean(Params.Direction == "TL" || Params.Direction == "BR")) {
							Direction = Params.Direction;
						}
						
						if (Params.Shuffle == true) {
							Shuffle = true;
						}
						
						if (Params.Reverse == true) {
							Reverse = true;
						}
						
						if (Params.Trash == true) {
							Trash = true;
						}
						
						if (Params.onStart as Function) {
							onStart = Params.onStart;
						}
						
						if (Params.onComplete as Function) {
							onComplete = Params.onComplete;
						}
						
						if (Params.Slide as String && Boolean(Params.Slide.substr(0, 1) == "T" || Params.Slide.substr(0, 1) == "B" || Params.Slide.substr(0, 1) == "C") && Boolean(Params.Slide.substr(1, 2) == "L" || Params.Slide.substr(1, 2) == "R" || Params.Slide.substr(1, 2) == "C")) {
							Slide = Params.Slide;
						}
						
						if (Params.grSlide as String) { Params.grSlide = String(Params.grSlide).replace(new RegExp('Rand', 'g'), 'J'); }
						if (Params.grSlide as String && Boolean(Params.grSlide.substr(0, 1) == "T" || Params.grSlide.substr(0, 1) == "B" || Params.grSlide.substr(0, 1) == "C" || Params.grSlide.substr(0, 1) == "J") && Boolean(Params.grSlide.substr(1, 2) == "L" || Params.grSlide.substr(1, 2) == "R" || Params.grSlide.substr(1, 2) == "C" || Params.grSlide.substr(1, 2) == "J")) {
							grSlide = Params.grSlide;
						}
						
						var tempRotation:Number = Target.rotation;
						var tempscaleX:Number = Target.scaleX;
						var tempscaleY:Number = Target.scaleY;
						
						Target.rotation = 0;
						Target.scaleX 	= 1;
						Target.scaleY 	= 1;
						
						TargetWidth = Target.width; TargetHeight = Target.height;
						
						Target.rotation = tempRotation;
						Target.scaleX 	= tempscaleX;
						Target.scaleY 	= tempscaleY;
						
					}
					
					if (Length < 1 || (!Boolean(grRotation) && !Boolean(grScaleX) && !Boolean(grScaleY) && grSlide == "CC")) {
						useMask = false;
					}
				
				// ######### E Verifica as options ==============
				
				// # S Create Mask
				if(Boolean(useMask)) {
					
					//cria as variáveis padrões das máscaras
					var items:Array = new Array();
					var maskMc:MovieClip = new MovieClip();
					
					// #####
					var wdt:Number;
					var hgt:Number;
					
					var wdtOrig:Number = TargetWidth;
					var hgtOrig:Number = TargetHeight;
					
					var itemsByLn:Number;
					var itemsByCl:Number;
					
					if (Type == "Rect" || Type == "Ellipse") {
						
						wdt = TargetWidth / Length;
						hgt = TargetHeight / Length;
						itemsByLn = Length;
						itemsByCl = Length;
						
						Start();
						
					} else if (Type == "Square" || Type == "Circle") {
						
						wdt = TargetWidth / Length;
						hgt = TargetHeight / Length;
						
						if (wdt < hgt) {
							hgt = wdt;
						} else {
							wdt = hgt;
						}
						
						if(Disposal == "H") {
							itemsByLn = TargetWidth / wdt;
							itemsByCl = TargetHeight / wdt;
						} else {
							itemsByLn = TargetHeight / wdt;
							itemsByCl = TargetWidth / wdt;
						}
						
						Start();
						
					} else if (Type == "Stripe" && Disposal == "H") {
						wdt = TargetWidth;
						hgt = TargetHeight / Length;
						
						itemsByLn = Length;
						itemsByCl = 1;
						
						Start();
						
					} else if (Type == "Stripe" && Disposal == "V") {
						wdt = TargetWidth / Length;
						hgt = TargetHeight;
						
						itemsByLn = 1;
						itemsByCl = Length;
						
						Start();
						
					}
					
					// ###########################################################
					
					function Start():void {
						
						var rects:Array = new Array();
						
						var ct:Number = 0;
						
						startMask = Generic.getRegistrationPoint(Target);
						
						for (var c:int = 0; c < itemsByCl; c++)
						{
							for (var l:int = 0; l < itemsByLn; l++) 
							{
								
								items[ct] = new MovieClip();
								
								rects[ct] = new Shape();
								rects[ct].graphics.beginFill(0x00FF00);
								
								if (Direction == "center") {
									
									if(Type == "Ellipse" || Type == "Circle") {
										rects[ct].graphics.drawEllipse( -((wdt * espCirc) / 2), -((hgt * espCirc) / 2), wdt * espCirc, hgt * espCirc);
									} else {
										rects[ct].graphics.drawRect( -(wdt / 2), -(hgt / 2), wdt, hgt);
									}
									
								} else if (Direction == "TL") {
									
									if(Type == "Ellipse" || Type == "Circle") {
										rects[ct].graphics.drawEllipse( -(wdt/2),  -(hgt/2), wdt * espCirc, hgt * espCirc);
									} else {
										rects[ct].graphics.drawRect( 0, 0, wdt, hgt);
									}
									
								} else {
									if(Type == "Ellipse" || Type == "Circle") {
										rects[ct].graphics.drawEllipse( -(wdt * espCirc) + (wdt / 2), -(hgt * espCirc) + (hgt / 2), wdt * espCirc, hgt * espCirc);
									} else {
										rects[ct].graphics.drawRect( -wdt, -hgt, wdt, hgt);
									}
								}
								rects[ct].graphics.endFill();
								
								items[ct].addChild(rects[ct]);
								
								if (Disposal == "V" || Type == "Stripe") {
									if(Direction == "center") {
										items[ct].x = startMask.x + (c * wdt) + (wdt / 2);
										items[ct].y = startMask.y + (l * hgt) + (hgt / 2);
									} else if(Direction == "TL") {
										items[ct].x = startMask.x +(c * wdt);
										items[ct].y = startMask.y + (l * hgt);
									} else {
										items[ct].x = startMask.x + (c * wdt) + wdt;
										items[ct].y = startMask.y + (l * hgt) + hgt;
									}
								} else {
									if(Direction == "center") {
										items[ct].x = startMask.x + (l * wdt) + (wdt / 2);
										items[ct].y = startMask.y + (c * hgt) + (hgt / 2);
									} else if(Direction == "TL") {
										items[ct].x = startMask.x + (l * wdt);
										items[ct].y = startMask.y + (c * hgt);
									} else {
										items[ct].x = startMask.x + (l * wdt) + wdt;
										items[ct].y = startMask.y + (c * hgt) + hgt;
									}
								}
								
								if (Action == "show") {
									if(Boolean(grScaleX)) {
										items[ct].scaleX = 0;
									} else {
										items[ct].scaleX = 1.05;
									}
									if(Boolean(grScaleY)) {
										items[ct].scaleY = 0;
									} else {
										items[ct].scaleY = 1.05;
									}
									if (Boolean(grRotation)) {
										items[ct].rotation = 180;
									}
								}
								
								maskMc.name = "maskMc215641684";
								maskMc.addChild(items[ct]);
								ct++;
							}
						}
						
					}
					
					// ##### E Rect
					
					var gainAn:Number = Gain;
					var timeAn:Number;
					
					gainAn = ( (Time / (items.length)) * gainAn);
					
					timeAn = Time - (gainAn * (items.length - 1));
					
					var all:Number = (gainAn * (items.length - 1)) + timeAn;
					
					if(Boolean(Shuffle)) {
						items = Generic.ShuffleArray(items);
					} else {
						if (Action == "hide") {
							items.reverse();
						}
					}
					
					if (Boolean(Reverse)) {
						items.reverse();
					}
					
				}
				// # E Create Mask
				
				//adiciona à lista de elementos com transitions
				obj.onEnd = onEnd;
				obj.x = Target.x; obj.y = Target.y;
				obj.scaleX = Target.scaleX; obj.scaleY = Target.scaleY;
				obj.rotation = Target.rotation;
				if(Target.alpha > 0) {
					obj.alpha = Target.alpha;
				} else {
					obj.alpha = 1;
				}
				Objs.push(obj);
				
				if(Boolean(useMask)) {
					if (Boolean(Objs[getTransitionIndex(Target)].maskTarget)) {
						
						maskMc.scaleX = Target.scaleX;
						maskMc.scaleY = Target.scaleY;
						
						maskMc.x = Target.x;
						maskMc.y = Target.y;
						
						if(Objs[getTransitionIndex(Target)].rotation != 0) {
							maskMc.rotation = Objs[getTransitionIndex(Target)].rotation;
						}
						
						Objs[getTransitionIndex(Target)].maskTarget.addChild(maskMc);
					}
					
					if (Boolean(Trash)) {
						Target.mask = null;
						maskMc.alpha = 0.5;
					} else {
						maskMc.alpha = 0;
						Target.mask = maskMc;
					}
					
					var maskTarget:DisplayObject = maskMc;
					
				}
				
				// =======================================================
				
				Target.visible = true;
				if (Boolean(onStart)) { onStart(); }
				
				function endAn():void {
					if(Boolean(onComplete)) { onComplete(); }
					
					//remove todas as transições e referências ao completar
					if (Boolean(killTransition(Target))) {
						if (Action == "hide") {
							Target.visible = false;
						}
					}
				}
				var onEnd:uint = setTimeout(endAn, Time * 1000);
				
				// =======================================================
				
				// S Animações Target
				if (Action == "show") {
					if (Slide.substr(0, 1) != "C") {
						
						var orY:Number = Target.y;
						if (Slide.substr(0, 1) == "T") {
							
							Target.y = Target.y - TargetHeight;
							TweenMax.to(Target, Time, { y:orY, ease:Ease, overwrite:0 } );
							
							if (Boolean(useMask)) {
								maskTarget.y = maskTarget.y - TargetHeight;
								TweenMax.to(maskTarget, Time, { y:orY, ease:Ease, overwrite:0 } );
							}
							
						} else {
							
							Target.y = Target.y + TargetHeight;
							TweenMax.to(Target, Time, { y:orY, ease:Ease, overwrite:0 } );
							
							if (Boolean(useMask)) {
								maskTarget.y = maskTarget.y + TargetHeight;
								TweenMax.to(maskTarget, Time, { y:orY, ease:Ease, overwrite:0 } );
							}
							
						}
					}
					
					if (Slide.substr(1, 2) != "C") {
						var orX:Number = Target.x;
						if (Slide.substr(1, 2) == "L") {
							
							Target.x = Target.x - TargetWidth;
							TweenMax.to(Target, Time, { x:orX, ease:Ease, overwrite:0 } );
							
							if (Boolean(useMask)) {
								maskTarget.x = maskTarget.x - TargetWidth;
								TweenMax.to(maskTarget, Time, { x:orX, ease:Ease, overwrite:0 } );
							}
							
						} else {
							
							Target.x = Target.x + TargetWidth;
							TweenMax.to(Target, Time, { x:orX, ease:Ease, overwrite:0 } );
							
							if (Boolean(useMask)) {
								maskTarget.x = maskTarget.x + TargetWidth;
								TweenMax.to(maskTarget, Time, { x:orX, ease:Ease, overwrite:0 } );
							}
							
						}
					}
					
					if (scaleX) {
						
						Target.scaleX = 0;
						TweenMax.to(Target, Time, { scaleX:Objs[getTransitionIndex(Target)].scaleX, ease:Ease, overwrite:0 } );
						
						
						if (Boolean(useMask)) {
							maskTarget.scaleX = 0;
							TweenMax.to(maskTarget, Time, { scaleX:Objs[getTransitionIndex(Target)].scaleX, ease:Ease, overwrite:0 } );
						}
						
					}
					
					if (scaleY) {
						
						Target.scaleY = 0;
						TweenMax.to(Target, Time, { scaleY:Objs[getTransitionIndex(Target)].scaleY, ease:Ease, overwrite:0 } );
						
						if (Boolean(useMask)) {
							maskTarget.scaleY = 0;
							TweenMax.to(maskTarget, Time, { scaleY:Objs[getTransitionIndex(Target)].scaleY, ease:Ease, overwrite:0 } );
						}
						
					}
					
					if (rotation) {
						
						Target.rotation = Target.rotation - 180;
						TweenMax.to(Target, Time, { rotation:Objs[getTransitionIndex(Target)].rotation, ease:Ease, overwrite:0 } );
						
						if (Boolean(useMask)) {
							maskTarget.rotation = maskTarget.rotation - 180;
							TweenMax.to(maskTarget, Time, { rotation:Objs[getTransitionIndex(Target)].rotation, ease:Ease, overwrite:0 } );
						}
						
					}
					
				} else {
					if (Slide.substr(0, 1) != "C") {
						if (Slide.substr(0, 1) == "T") {
							TweenMax.to(Target, Time, { y:Target.y - TargetHeight, ease:Ease, overwrite:0 } );
							if (Boolean(useMask)) {
								TweenMax.to(maskTarget, Time, { y:Target.y - TargetHeight, ease:Ease, overwrite:0 } );
							}
						} else {
							TweenMax.to(Target, Time, { y:Target.y + TargetHeight, ease:Ease, overwrite:0 } );
							if (Boolean(useMask)) {
								TweenMax.to(maskTarget, Time, { y:Target.y + TargetHeight, ease:Ease, overwrite:0 } );
							}
						}
					}
					
					if (Slide.substr(1, 2) != "C") {
						if (Slide.substr(1, 2) == "L") {
							TweenMax.to(Target, Time, { x:Target.x - TargetWidth, ease:Ease, overwrite:0 } );
							if (Boolean(useMask)) {
								TweenMax.to(maskTarget, Time, { x:Target.x - TargetWidth, ease:Ease, overwrite:0 } );
							}
						} else {
							TweenMax.to(Target, Time, { x:Target.x + TargetWidth, ease:Ease, overwrite:0 } );
							if (Boolean(useMask)) {
								TweenMax.to(maskTarget, Time, { x:Target.x + TargetWidth, ease:Ease, overwrite:0 } );
							}
						}
					}
					
					if (scaleX) {
						
						TweenMax.to(Target, Time, { scaleX:0, ease:Ease, overwrite:0 } );
						
						if (Boolean(useMask)) {
							TweenMax.to(maskTarget, Time, { scaleX:0, ease:Ease, overwrite:0 } );
						}
						
					}
					
					if (scaleY) {
						
						TweenMax.to(Target, Time, { scaleY:0, ease:Ease, overwrite:0 } );
						
						if (Boolean(useMask)) {
							TweenMax.to(maskTarget, Time, { scaleY:0, ease:Ease, overwrite:0 } );
						}
						
					}
					
					if (rotation) {
						
						Target.rotation = Objs[getTransitionIndex(Target)].rotation;
						TweenMax.to(Target, Time, { rotation:Target.rotation + 180, ease:Ease, overwrite:0 } );
						
						if (Boolean(useMask)) {
							maskTarget.rotation = Objs[getTransitionIndex(Target)].rotation;
							TweenMax.to(maskTarget, Time, { rotation:maskTarget.rotation + 180, ease:Ease, overwrite:0 } );
						}
						
					}
					
				}
				// E Animações Target
				
				// =======================================================
				
				// S Animações Filtros
				
				// Blur
				var blurValue:Number = 40;
				TweenMax.to(Target, 0, { blurFilter: { blurX:0, blurY:0, quality:3 }, overwrite:0 } );
				
				// tint
				TweenMax.to(Target, 0, { removeTint:true, overwrite:0 } );
				
				if (Action == "show") {
					// ## alpha
					if (Boolean(alpha)) {
						Target.alpha = 0;
						TweenMax.to(Target, Time, { alpha:Objs[getTransitionIndex(Target)].alpha, ease:spEase, overwrite:0 } );
					}
					
					// ## tint
					if (tint > -1) {
						TweenMax.to(Target, 0, { tint:tint, overwrite:0 } );
						TweenMax.to(Target, Time, { removeTint:true, ease:spEase, overwrite:0 } );
					}
					
					// ## Blur
					if(Boolean(BlurX && BlurY)) {
						TweenMax.to(Target, 0, { blurFilter: { blurX:blurValue, blurY:blurValue, quality:3 }, overwrite:0 } );
					} else if (Boolean(BlurX)) {
						TweenMax.to(Target, 0, { blurFilter: { blurX:blurValue, blurY:0, quality:3 }, overwrite:0 } );
					} else if (Boolean(BlurY)) {
						TweenMax.to(Target, 0, { blurFilter: { blurX:0, blurY:blurValue, quality:3 }, overwrite:0 } );
					}
					if (Boolean(BlurX || BlurY)) {
						TweenMax.to(Target, Time, { blurFilter: { blurX:0, blurY:0, quality:3 }, ease:spEase, overwrite:0 } );
					}
				} else {
					// ## alpha
					if (Boolean(alpha)) {
						Target.alpha = Objs[getTransitionIndex(Target)].alpha;
						TweenMax.to(Target, Time, { alpha:0, ease:spEase, overwrite:0 } );
					}
					
					// ## tint
					if (tint > -1) {
						TweenMax.to(Target, 0, { removeTint:true, overwrite:0 } );
						TweenMax.to(Target, Time, { tint:tint, ease:spEase, overwrite:0 } );
					}
					
					// ## Blur
					if(Boolean(BlurX && BlurY)) {
						TweenMax.to(Target, Time, { blurFilter: { blurX:blurValue, blurY:blurValue, quality:3 }, ease:spEase, overwrite:0 } );
					} else if (Boolean(BlurX)) {
						TweenMax.to(Target, Time, { blurFilter: { blurX:blurValue , blurY:0, quality:3 }, ease:spEase, overwrite:0 } );
					} else if (Boolean(BlurY)) {
						TweenMax.to(Target, Time, { blurFilter: { blurX:0, blurY:blurValue, quality:3 }, ease:spEase, overwrite:0 } );
					}
					
				}
				
				// E Animações Filtros
				
				// =======================================================
				
				// S Animações Máscaras
				if (Boolean(useMask)) {
					
					//var grVrX:Number = int(TargetWidth + (TargetWidth / 10));
					//var grVrY:Number = int(TargetHeight + (TargetHeight / 10));
					
					var grVrX:Number = wdtOrig;
					var grVrY:Number = hgtOrig;
					
					var grSlideX:String = "C";
					var grSlideY:String = "C";
				
					
					var grVrItemX:Number = 0;
					var grVrItemY:Number = 0;
					
					for (var x:int = 0; x < items.length; x++)
					{
						
						if (grSlide.substr(1, 2) != "C") {
							if (grSlide.substr(1, 2) == "L") {
								grSlideX = "L";
							} else if (grSlide.substr(1, 2) == "R") {
								grSlideX = "R";
							} else {
								if ( (Math.round(Math.random() * (1 - 0)) + 0) == 0 ) {
									grSlideX = "L";
								} else {
									grSlideX = "R";
								}
							}
						}
						
						if (grSlide.substr(0, 1) != "C") {
							if (grSlide.substr(0, 1) == "T") {
								grSlideY = "T";
							} else if (grSlide.substr(0, 1) == "B") {
								grSlideY = "B";
							} else {
								if ( (Math.round(Math.random() * (1 - 0)) + 0) == 0 ) {
									grSlideY = "T";
								} else {
									grSlideY = "B";
								}
							}
						}
						
						if (Direction == "center") {
							
							if (grSlideX == "L") { grVrItemX = -(wdt / 2); }
							else if (grSlideX == "R") { grVrItemX = -(wdt / 2); }
							
							if (grSlideY == "T") { grVrItemY = -(hgt / 2); }
							else if (grSlideY == "B") { grVrItemY = -(hgt / 2); }
							
						} else if (Direction == "TL") {
							
							if (grSlideX == "L") { grVrItemX = 0; }
							else if (grSlideX == "R") { grVrItemX = -wdt; }
							
							if (grSlideY == "T") { grVrItemY = 0; }
							else if (grSlideY == "B") { grVrItemY = -hgt; }
							
						} else if (Direction == "BR") {
							
							if (grSlideX == "L") { grVrItemX = -wdt; }
							else if (grSlideX == "R") { grVrItemX = 0; }
							
							if (grSlideY == "T") { grVrItemY = -hgt; }
							else if (grSlideY == "B") { grVrItemY = 0; }
							
						}
						
						if (grSlideX == "L") {
							grVrItemX = grVrItemX - startMask.x;
						} else {
							grVrItemX = startMask.x + grVrItemX;
						}
						
						if (grSlideY == "T") {
							grVrItemY = grVrItemY - startMask.y;
						} else {
							grVrItemY = startMask.y + grVrItemY;
						}
						
						if (Direction == "TL" && Boolean(grRotation)) {
							if (grSlideY == "T") {
								grVrItemY = grVrItemY - hgt;
							} else {
								grVrItemY = grVrItemY + hgt;
							}
							if (grSlideX == "L") {
								grVrItemX = grVrItemX - wdt;
							} else {
								grVrItemX = grVrItemX + wdt;
							}
						} else if (Direction == "BR" && Boolean(grRotation)) {
							if (grSlideX == "L") {
								grVrItemX = grVrItemX + wdt;
							} else {
								grVrItemX = grVrItemX - wdt;
							}
							if (grSlideY == "T") {
								grVrItemY = grVrItemY + hgt;
							} else {
								grVrItemY = grVrItemY - hgt;
							}
						}
						
						var dmMultip:Number = 1;
						
						if (Type == "Circle" || Type == "Ellipse") { dmMultip = espCirc - (espCirc / 10); }
						
						if (Action == "show") {
							
							if (Boolean(grScaleX)) {
								TweenMax.to(items[x], timeAn, { scaleX:1.05, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							if (Boolean(grScaleY)) {
								TweenMax.to(items[x], timeAn, { scaleY:1.05, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							if (Boolean(grRotation)) {
								TweenMax.to(items[x], timeAn, { rotation:0, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							
							//grSlide
							if (grSlideY != "C") {
								var grOrY:Number = items[x].y;
								if (grSlideY == "T") {
									items[x].y = -((hgt * dmMultip) + grVrItemY);
								} else if (grSlideY == "B") {
									items[x].y = grVrY + ((hgt * dmMultip) + grVrItemY);
								}
								TweenMax.to(items[x], timeAn, { y:grOrY, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							
							if (grSlideX != "C") {
								var grOrX:Number = items[x].x;
								if (grSlideX == "L") {
									items[x].x = -((wdt * dmMultip) + grVrItemX);
								} else if (grSlideX == "R") {
									items[x].x = grVrX + ((wdt * dmMultip) + grVrItemX);
								}
								TweenMax.to(items[x], timeAn, { x:grOrX, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							
						} else {
							if (Boolean(grScaleX)) {
								TweenMax.to(items[x], timeAn, { scaleX:0, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							if (Boolean(grScaleY)) {
								TweenMax.to(items[x], timeAn, { scaleY:0, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							if (Boolean(grRotation)) {
								TweenMax.to(items[x], timeAn, { rotation:180, delay:x * gainAn, ease:grEase, overwrite:0 } );
							}
							
							//grSlide
							if (grSlideY != "C") {
								if (grSlideY == "T") {
									TweenMax.to(items[x], timeAn, { y: -((hgt * dmMultip) + grVrItemY), delay:x * gainAn, ease:grEase, overwrite:0 } );
								} else if (grSlideY == "B") {
									TweenMax.to(items[x], timeAn, { y:grVrY + ((hgt * dmMultip) + grVrItemY), delay:x * gainAn, ease:grEase, overwrite:0 } );
								}
							}
							
							if (grSlideX != "C") {
								if (grSlideX == "L") {
									TweenMax.to(items[x], timeAn, { x: -(((wdt * dmMultip) + grVrItemX)), delay:x * gainAn, ease:grEase, overwrite:0 } );
								} else if (grSlideX == "R") {
									TweenMax.to(items[x], timeAn, { x:grVrX + ((wdt * dmMultip) + grVrItemX), delay:x * gainAn, ease:grEase, overwrite:0 } );
								}
							}
							
						}
					}
				}
				// E Animações Máscaras
				
				// =======================================================
				
				// ###########################################################
			}
			
			//validações
			if (!Boolean(Target as DisplayObject)) {
				Debug.Send("Invalid Target", "Error", { p:"effects", c:"Transitions", m:"New" } );
				return false;
			}
			
			if (!Boolean(Action == "show" || Action == "hide")) {
				Debug.Send("Action must be 'show' or 'hide'", "Error", { p:"effects", c:"Transitions", m:"New" } );
				return false;
			}
			
			var nObjDl:Object = new Object();
			
			//função que verifica até que o objeto a ser animado tenha dimensões válidas
			function ckDm():void {
				if (Boolean(Target.width + Target.height)) {
					if(Params.delay > 0) {
						ObjsDelay[getTransitionTimerIndex(Target)].delay = setTimeout(startMt, Params.delay * 1000);
					} else {
						ObjsDelay[getTransitionTimerIndex(Target)].delay = setTimeout(startMt, 0);
					}
					clearInterval(ObjsDelay[getTransitionTimerIndex(Target)].ckDmT);
				}
			}
			
			nObjDl.Target = Target;
			nObjDl.ckDmT = setInterval(ckDm, 75);
			
			ObjsDelay.push(nObjDl);
			
			return true;
			
		}
		
	}
}