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
	
	import flash.display.Stage;
	
	import flash.geom.Point;
	
	import com.adobe.crypto.SHA256;
	
	import com.asmonster.utils.Debug;
	
	/**
	 * Métodos genéricos utilizados no desenvolvimento.
	 */	
	public class Generic
	{
		
		/**
		 * Não há construtor.
		 */
		public function Generic():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"utils", c:"Generic", m:"Generic" } );
		}
		
		/**
		 * Retorna um objeto com as variações de  X e Y do objeto alvo de acordo com o seu registration point.
		 * 
		 * @param	Obj		Objeto alvo a ser analisado.
		 * @param	ptObj	Objeto a ser posicionado no registration point do objeto alvo.
		 */
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
		
		/**
		 * Retorna um texto com SHA256.hash("&amp;") convertido em "&amp;".
		 * 
		 * @param	Txt		Texto a ser tradado.
		 */
		public static function TreatDataBaseReturn(Txt:String):String {
			if ( Boolean(Txt) ) {
				return Txt.replace(new RegExp(SHA256.hash("&"), "g"), "&");
			} else {
				return Txt;
			}
		}
		
		/**
		 * Remove valores duplicados em uma array.
		 * 
		 * @param	arr		Array a ser trabalhada.
		 */
		public static function RemoveDuplicArray(arr:Array):Array {
			
			var is_unique:Function = function (item:*, index:int, array:Array):Boolean {
				return array.indexOf(item,index + 1) == -1;
			};
			
			return arr.filter(is_unique);
		}
		
		/**
		 * Coloca os valores de uma Array em ordem aleatória.
		 * 
		 * @param	arr		Array a ser ordenada.
		 */
		public static function ShuffleArray(arr:Array):Array {
			var len:int = arr.length;
			var temp:*;
			var i:int = len;
			while (i--) {
				var rand:int = Math.floor(Math.random() * len);
				temp = arr[i];
				arr[i] = arr[rand];
				arr[rand] = temp;
			}
			return arr;
		}
		
		/**
		 * Retorna uma Array com condições a partir de uma String de condições no modelo SQL.
		 * <p></p>
		 * 
		 * @param	Conditions	String no modelo SQL com as condições.
		 * 
		 * @example
<listing version="3.0">
var Cond:Array = Generic.GetConditions('descri = "teste" AND tit = "color" AND teste &lt; 4 OR cdt &gt; 6 AND id != 4');

//Retorna:

[0][0][0] = "descri";
[0][0][1] = "teste";
[0][0][2] = "=";

[0][1][0] = "tit";;
[0][1][1] = "color";
[0][1][2] = "=";

[0][2][0] = "teste";
[0][2][1] = 4;
[0][2][2] = "&lt;";

//or...

[1][0][0] = "cdt";
[1][0][1] = 6;
[1][0][2] = "&gt;";

[1][1][0] = "id";
[1][1][1] = 4;
[1][1][2] = "!=";

</listing>
		 * 
		 */
		public static function GetConditions(Conditions:String):Array {
			Conditions = Conditions.replace(new RegExp('"', 'g'), "'");
			
			Conditions = Conditions.replace(new RegExp(" Or ", "g"), " or ");
			Conditions = Conditions.replace(new RegExp(" oR ", "g"), " or ");
			Conditions = Conditions.replace(new RegExp(" OR ", "g"), " or ");
			Conditions = Conditions.replace(new RegExp(" AND ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" ANd ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" aNd ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" anD ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" aND ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" AnD ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" And ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" aNd ", "g"), " and ");
			Conditions = Conditions.replace(new RegExp(" ANd ", "g"), " and ");
			
			var CdtAr:Array = new Array(); var tpAt:Array;
			var tpArb:Array = new Array(); tpAt = Conditions.split(" or ");
			
			for (var x:int = 0; x < tpAt.length; x ++) {
				tpAt[x] = tpAt[x].split(" and ");
				for (var i:int = 0; i < tpAt[x].length; i ++) {
					if ( String(tpAt[x][i]).indexOf(" = ") > 1) {
						tpAt[x][i] = tpAt[x][i].split(" = ");
						tpAt[x][i][1] = tpAt[x][i][1].replace(new RegExp("'", "g"), "");
						tpAt[x][i][2] = "=";
					} else if ( String(tpAt[x][i]).indexOf(" > ") > 1) {
						tpAt[x][i] = tpAt[x][i].split(" > ");
						tpAt[x][i][1] = tpAt[x][i][1].replace(new RegExp("'", "g"), "");
						tpAt[x][i][2] = ">";
					} else if ( String(tpAt[x][i]).indexOf(" < ") > 1) {
						tpAt[x][i] = tpAt[x][i].split(" < ");
						tpAt[x][i][1] = tpAt[x][i][1].replace(new RegExp("'", "g"), "");
						tpAt[x][i][2] = "<";
					} else if ( String(tpAt[x][i]).indexOf(" != ") > 1) {
						tpAt[x][i] = tpAt[x][i].split(" != ");
						tpAt[x][i][1] = tpAt[x][i][1].replace(new RegExp("'", "g"), "");
						tpAt[x][i][2] = "!=";
					}
				}
			}
			
			CdtAr = tpAt;
			
			return CdtAr;
		}
		
		/**
		 * Retorna um objeto a partir de alguma referência.
		 * 
		 * @param	Target		O objeto ou uma String como referência para o objeto desejado.
		 * @param	Container	Local onde o objeto será procurado.
		 * 
		 * @example
<listing version="3.0">
//Ao invés de:
stage.getChildByName("testeMcA").getChildByName("testeMcB").getChildByName("McTeste4").getChildByName("McTb").getChildByName("tcMc");
	
//Você utiliza:
Generic.GetTarget("testeMcA.testeMcB.McTeste4.McTb.tcMc", stage);

//Se o "testeMcA" está dentro de testeMcCnt ao invés de stage:
Generic.GetTarget("testeMcA.testeMcB.McTeste4.McTb.tcMc", testeMcCnt);

//Ao invés de tentar algo assim:
stage.getChildByName("testeMcA").testeMcB.getChildByName("McTeste4").getChildByName("McTb").getChildByName("tcMc");

//Ou assim:
stage.getChildByName("testeMcA")."testeMcB".getChildByName("McTeste4").getChildByName("McTb").getChildByName("tcMc");

//Você simplifica e resolve fazendo assim:
Generic.GetTarget("testeMcA.$testeMcB.McTeste4.McTb.tcMc", stage);
</listing>
		 * 
		 */
		public static function GetTarget(Target:Object = null, Container:Object = null):Object {
			if ( Boolean(Container) ) {
				if (Container as Stage) {
					if (Target as String) {
						return null;
					} else {
						if( Boolean(Target) ) {
							return Target;
						} else {
							return null;
						}
					}
				} else {
					if (Target as String) {
						var nTarget:Array = Target.split(".");
						var nTargetF:Object = Container;
						for (var x:int = 0; x < nTarget.length; x ++) {
							if (nTarget[x].substr(0, 1) == "$") {								
								nTargetF = nTargetF[nTarget[x].substr(1, nTarget[x].length - 1)];
							} else {
								nTargetF = nTargetF.getChildByName(nTarget[x]);
							}
						}
						if( Boolean(nTargetF) ) {
							return nTargetF;
						} else {
							return null;
						}						
					} else {
						return null;
					}
				}
			} else {
				if (Target as String) {
					return null;
				} else {
					if( Boolean(Target) ) {
						return Target;
					} else {
						return null;
					}
				}
			}
		}
		
	}

}