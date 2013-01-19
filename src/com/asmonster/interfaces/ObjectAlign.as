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
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	
	import flash.utils.setInterval;
	
	import com.asmonster.utils.Debug;
	import com.asmonster.utils.Generic;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	/**
	 * Controla o tamanho e posicionamento de objetos.
	 */
	public class ObjectAlign 
	{
		
		/**
		 * Não há construtor.
		 */
		public function ObjectAlign():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"interfaces", c:"ObjectAlign", m:"ObjectAlign" } );
		}
		
		
		/**
		 * Alinha e redimensiona objetos de acordo com uma referência.
		 * 
		 * @param	algin_parameters		Objeto com os parâmetro do método In.
		 * 									<p> <code>.Reference	:Object/Stage</code>	— Objeto de referência para controlar o alinhamento.</p>
		 * 									<p> <code>.Target		:String/Object</code>	— Objeto a ser alinhado.</p>
		 * 									<p> <code>.Container	:Object/Stage</code>	— Local onde o objeto a ser alinhado será procurado.</p>
		 * 									<p> <code>.Pos			:String</code>			— Posição em que o objeto será alinhado ['C', 'T' ou 'B' + 'C', 'L' ou 'R'] (defaults 'CC').</p>
		 * 									<p> <code>.ObjWidth		:Number</code>			— Largura do item para calcular o alinhamento (defaults auto).</p>
		 * 									<p> <code>.ObjHeight	:Number</code>			— Altura do item para calcular o alinhamento (defaults auto).</p>
		 * 									<p> <code>.margin		:Number</code>			— Margem entre o objeto alinhado e a referência (defaults 0).</p>
		 * 									<p> <code>.marginTop	:Number</code>			— Margem superior entre o objeto alinhado e a referência (defaults 0).</p>
		 * 									<p> <code>.marginBottom	:Number</code>			— Margem inferior entre o objeto alinhado e a referência (defaults 0).</p>
		 * 									<p> <code>.marginLeft	:Number</code>			— Margem esquerda entre o objeto alinhado e a referência (defaults 0).</p>
		 * 									<p> <code>.marginRight	:Number</code>			— Margem direita entre o objeto alinhado e a referência (defaults 0).</p>
		 * 									<p> <code>.stretch		:Boolean</code>			— Esticar o objeto de acordo com a referência (defaults false).</p>
		 * 									<p> <code>.stretchV		:Boolean</code>			— Esticar o objeto verticalmente de acordo com a referência (defaults false).</p>
		 * 									<p> <code>.stretchH		:Boolean</code>			— Esticar o objeto horizontalmente de acordo com a referência (defaults false).</p>
		 * 									<p> <code>.stchEase		:Function</code>		— TweenMax Easing a ser usada na transição do tamanho do objeto (defaults Expo.easeOut).</p>
		 * 									<p> <code>.stchTime		:Number</code>			— Tempo da transição do tamanho do objeto (defaults 0).</p>
		 * 									<p> <code>.posEase		:Function</code>		— TweenMax Easing a ser usada na transição da posição do objeto (defaults Expo.easeOut).</p>
		 * 									<p> <code>.posTime		:Number</code>			— Tempo da transição da posição do objeto (defaults 0.8).</p>
		 * 
		 * @example
<listing version="3.0">

ObjectAlign.In( { Reference:stage, Target:meuMC, Pos:"CL" } );

ObjectAlign.In( { Reference:stage, Target:meuMC, Pos:"CC", marginTop:50 } );

ObjectAlign.In( { Reference:stage, Target:meuMC, Pos:"CC", stretchV:true } );

</listing>
		 * 
		 */
		public static function In(algin_parameters:Object = null):Boolean
		{
			
			var Reference:Object;
			var AlgObject:Object;
			var H:String = "C";
			var V:String = "C";
			var ObjWidth:Number = undefined;
			var ObjHeight:Number = undefined;
			
			var autoSizeW:Boolean = true;
			var autoSizeH:Boolean = true;
			
			var mL:Number = 0;
			var mR:Number = 0;
			var mT:Number = 0;
			var mB:Number = 0;
			
			var stretchV:Boolean = false;
			var stretchH:Boolean = false;			
			
			var stchEase:Function = Expo.easeOut;
			var stchTime:Number = 0;
			
			var posEase:Function = Expo.easeOut;
			var posTime:Number = 0.8;
			
			var RefW:Number;
			var RefH:Number;
			
			var lX:Number;
			var lY:Number;
			
			var npX:Number;
			var npY:Number;
			
			var lW:Number;
			var lH:Number;
			
			function check_algin_parameters():Boolean {
				if (!Boolean(algin_parameters)) {
					Debug.Send("Object with parameters are required for In", "Error", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					return false;	
				}
				if (Boolean(algin_parameters.Reference)) {
					Reference = algin_parameters.Reference;
				} else {
					Debug.Send("Reference is required for In", "Error", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					return false;
				}
				AlgObject = Generic.GetTarget(algin_parameters.Target, algin_parameters.Container);
				if (!Boolean(AlgObject)) {
					Debug.Send("Invalid Target object", "Error", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					return false;
				}
				if(Boolean(algin_parameters.Pos)) {
					if (String(algin_parameters.Pos).substr(1, 1) == "C" || String(algin_parameters.Pos).substr(1, 2) == "L" || String(algin_parameters.Pos).substr(1, 2) == "R") {
						H = String(algin_parameters.Pos).substr(1, 2);
					}
				}
				if(Boolean(algin_parameters.Pos)) {
					if (String(algin_parameters.Pos).substr(0, 1) == "C" || String(algin_parameters.Pos).substr(0, 1) == "T" || String(algin_parameters.Pos).substr(0, 1) == "B") {
						V = String(algin_parameters.Pos).substr(0, 1);
					}
				}
				if (Boolean(algin_parameters.ObjWidth)) {
					if (isNaN(algin_parameters.ObjWidth)) {
						Debug.Send("ObjWidth must be a numeric value, the default value (null) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						autoSizeW = false;
						ObjWidth = algin_parameters.ObjWidth;
					}
				}
				if (Boolean(algin_parameters.ObjHeight)) {
					if (isNaN(algin_parameters.ObjHeight)) {
						Debug.Send("ObjHeight must be a numeric value, the default value (null) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						autoSizeH = false;
						ObjHeight = algin_parameters.ObjHeight;
					}
				}
				if (Boolean(algin_parameters.margin)) {
					if (isNaN(algin_parameters.margin)) {
						Debug.Send("margin must be a numeric value, margin will be ignored", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						mL = algin_parameters.margin; mR = algin_parameters.margin;
						mT = algin_parameters.margin; mB = algin_parameters.margin;
					}
				}
				if (Boolean(algin_parameters.marginTop)) {
					if (isNaN(algin_parameters.marginTop)) {
						mT = 0;
						Debug.Send("marginTop must be a numeric value, the default value (0) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						mT = algin_parameters.marginTop;
					}
				}
				if (Boolean(algin_parameters.marginBottom)) {
					if (isNaN(algin_parameters.marginBottom)) {
						mB = 0;
						Debug.Send("marginBottom must be a numeric value, the default value (0) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						mB = algin_parameters.marginBottom;
					}
				}
				if (Boolean(algin_parameters.marginLeft)) {
					if (isNaN(algin_parameters.marginLeft)) {
						mL = 0;
						Debug.Send("marginLeft must be a numeric value, the default value (0) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						mL = algin_parameters.marginLeft;
					}
				}
				if (Boolean(algin_parameters.marginRight)) {
					if (isNaN(algin_parameters.marginRight)) {
						mR = 0;
						Debug.Send("marginRight must be a numeric value, the default value (0) has been defined", "Alert", { p:"interfaces", c:"ObjectAlign", m:"In" } );
					} else {
						mR = algin_parameters.marginRight;
					}
				}
				if (Boolean(algin_parameters.stretch)) {
					stretchV = algin_parameters.stretch;
					stretchH = algin_parameters.stretch;
				}
				if (Boolean(algin_parameters.stretchV)) {
					stretchV = algin_parameters.stretchV;
				}
				if (Boolean(algin_parameters.stretchH)) {
					stretchH = algin_parameters.stretchH;
				}
				if (Boolean(algin_parameters.posEase)) {
					posEase = algin_parameters.posEase;
				}
				if (Boolean(algin_parameters.stchEase)) {
					stchEase = algin_parameters.stchEase;
				}
				if (!isNaN(algin_parameters.posTime) || algin_parameters.posTime == 0) {
					posTime = algin_parameters.posTime;
				}
				if (!isNaN(algin_parameters.stchTime) || algin_parameters.stchTime == 0) {
					stchTime = algin_parameters.stchTime;
				}
				return true;
			} if (check_algin_parameters() == false) { return false; };
			function calcPos():void {
				if (Reference as Stage) {
					RefW = Reference.stageWidth; RefH = Reference.stageHeight;
				} else {
					RefW = Reference.width; RefH = Reference.height;
				}
				if (!Boolean(ObjWidth)) { ObjWidth = AlgObject.width; };
				if (!Boolean(ObjHeight)) { ObjHeight = AlgObject.height; };
				
				if (Boolean(autoSizeW)) { ObjWidth = AlgObject.width; };
				if (Boolean(autoSizeH)) { ObjHeight = AlgObject.height; };
				
				if (Boolean(stretchV)) { ObjHeight = RefH - (mT + mB); };
				if (Boolean(stretchH)) { ObjWidth = RefW - (mL + mR); };
				
				if (H == "C") {
					if(mL == mR) {
						npX = (RefW / 2) - (ObjWidth / 2);
					} else {
						if (mL > mR) {
							npX = ((RefW / 2) - (ObjWidth / 2)) + (mL - mR);
						} else {
							npX = ((RefW / 2) - (ObjWidth / 2)) - (mR - mL);
						}
					}
				} else if (H == "R") {
					npX = (RefW - ObjWidth) - mR;
				} else {
					npX = 0 +  mL;
				}
				if (V == "C") {
					if(mT == mB) {
						npY = (RefH / 2) - (ObjHeight / 2);
					} else {
						if (mT > mB) {
							npY = ((RefH / 2) - (ObjHeight / 2)) + (mT - mB);
						} else {
							npY = ((RefH / 2) - (ObjHeight / 2)) - (mB - mT);
						}
					}
				} else if (V == "T") {
					npY = 0 + mT;
				} else {
					npY = (RefH - ObjHeight) - mB;
				}
			}
			function AlignCnt():void {
				if (Boolean(AlgObject.width != 0 && AlgObject.height != 0)) {
					calcPos();	
					if (lX != npX || lY != npY || lW != ObjWidth || lH != ObjHeight) {
						lX = npX; lY = npY;
						lW = ObjWidth; lH = ObjHeight;
						
						TweenMax.to(AlgObject, posTime, { x:npX, y:npY, ease:posEase } );
						//if (!Boolean(autoSizeH) || Boolean(stretchV)) { ????
						if (Boolean(stretchV)) {
							TweenMax.to(AlgObject, stchTime, { height:ObjHeight, ease:stchEase } );
						}
						//if (!Boolean(autoSizeW) || Boolean(stretchH)) { ????
						if (Boolean(stretchH)) {
							TweenMax.to(AlgObject, stchTime, { width:ObjWidth, ease:stchEase } );
						}
						
					}
				}
			}
			if (Boolean(AlgObject.width != 0 && AlgObject.height != 0)) {
				calcPos();
				AlgObject.x = npX; AlgObject.y = npY;
				if (!Boolean(autoSizeW) || Boolean(stretchH)) {
					AlgObject.width = ObjWidth;
				}
				if (!Boolean(autoSizeH) || Boolean(stretchV)) {
					AlgObject.height = ObjHeight;
				}
			}
			setInterval(AlignCnt, 5);
			return true;
		}
	}
}