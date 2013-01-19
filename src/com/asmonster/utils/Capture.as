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
	
	import com.asmonster.utils.Debug;
	
	/**
	 * Realiza a "captura" de objetos.
	 * <p>É meio difícil explicar a utilidade dela, mas em alguns códigos "dinâmicos" e meio complexos ela realmente salva a vida.</p>
	 * <p>Pegar objetos dentro de outro objeto que são passados para outros lugares a partir de referências fica simples.</p>
	 * <p><a href="http://assault.cubers.net/" target="_blank">Capture the flag?</a></p>
	 */	
	public class Capture 
	{

		/**
		 * Não há construtor.
		 */
		public function Capture():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"utils", c:"Capture", m:"Capture" } );
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
Capture.GetTarget("testeMcA.testeMcB.McTeste4.McTb.tcMc", stage);

//Se o "testeMcA" está dentro de testeMcCnt ao invés de stage:
Capture.GetTarget("testeMcA.testeMcB.McTeste4.McTb.tcMc", testeMcCnt);

//Ao invés de tentar algo assim:
stage.getChildByName("testeMcA").testeMcB.getChildByName("McTeste4").getChildByName("McTb").getChildByName("tcMc");

//Ou assim:
stage.getChildByName("testeMcA")."testeMcB".getChildByName("McTeste4").getChildByName("McTb").getChildByName("tcMc");

//Você simplifica e resolve fazendo assim:
Capture.GetTarget("testeMcA.$testeMcB.McTeste4.McTb.tcMc", stage);
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