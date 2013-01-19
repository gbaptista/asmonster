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
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	
	import flash.events.KeyboardEvent;
	
	import flash.text.TextField;
	
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import com.greensock.TweenMax;
	
	/**
	 * Controla informações e mensagens durante o desenvolvimento da aplicação.
	 * <p>Com o Debug você pode enviar mensagens diversas, substituindo o trace do Flash.</p>
	 * <p>Você acompanha o número de FPS da aplicação e visualiza o tempo exato de cada ação através das mensagens.</p>
	 * <p>Roda direto no SWF, sem a necessidade do Flash ou algum outro aplicativo adicional para ver as informações no navegador como seria com o trace e a maioria das soluções.</p>
	 * <p>Cores personalizadas e informações sobre o pacote, classe e método de origem da mensagem.</p>
	 */
	public class Debug 
	{		
		private static var McBkg:MovieClip = null;
		private static var Txt:TextField = null;
		
		private static var timeTp:uint;		
		private static var rD:Number;
		private static var started:Boolean = false;
		
		private static var txtAllFPS:TextField;
		
		private static var lastFPS:Number = getTimer();
		private static var countFPS:Number = 0;
		private static var atualFPS:String = "000";
		private static var maxFPS:Number = 0;
		private static var minFPS:Number = 999999999999999999999999;
		private static var medFPS:Number = 0;
		
		/**
		 * Ativar o Debug (Ctrl + Shift + D).
		 */
		public static var active:Boolean = true;
		
		/**
		 * Stage para adicionar os elementos do Debug.
		 */
		public static var stage:Stage = undefined;
		
		/**
		 * Porcentagem do tamanho da área do Debug com relação ao Stage.
		 */
		public static var SizePct:Number = 15;
		
		/**
		 * Mostrar mensagens do tipo "Info".
		 */
		public static var Info:Boolean = true;
		
		/**
		 * Mostrar mensagens do tipo "Alert".
		 */
		public static var Alert:Boolean = true;
		
		/**
		 * Mostrar mensagens do tipo "Error".
		 */
		public static var sError:Boolean = true;
		
		/**
		 * Mostrar mensagens do tipo "Result".
		 */
		public static var Result:Boolean = true;
		
		/**
		 * Mostrar mensagens do tipo "NewInstance".
		 */
		public static var NewInstance:Boolean = true;
		
		/**
		 * Não há construtor.
		 */
		public function Debug():void
		{
			Send("A static class should not be instantiated", "Error", { p:"utils", c:"Debug", m:"Debug" } );
		}
		
		private static var timeOutVs:uint;
		
		/**
		 * Abrir o Debug
		 */
		private static function show():void {
			
			clearTimeout(timeOutVs);
			
			McBkg.visible		= true;
			Txt.visible			= true;
			txtAllFPS.visible	= true;
			
			TweenMax.to(txtAllFPS,	0.3, { alpha:1.0, scaleY:1 } );
			TweenMax.to(Txt, 		0.3, { alpha:1.0, scaleY:1 } );
			TweenMax.to(McBkg,		0.3, { alpha:0.8, scaleY:1 } );
		}
		
		/**
		 * Fechar o Debug
		 */
		private static function hide():void {
			
			TweenMax.to(txtAllFPS,	0.3, { alpha:0.0, scaleY:0 } );
			TweenMax.to(Txt, 		0.3	, { alpha:0.0, scaleY:0 } );
			TweenMax.to(McBkg,		0.3, { alpha:0.0, scaleY:0 } );
			
			function hideVisb():void {
				McBkg.visible		= false;
				Txt.visible			= false;
				txtAllFPS.visible	= false;
			}
			clearTimeout(timeOutVs);
			timeOutVs = setTimeout(hideVisb, 0.5 * 1000);
			
		}
		
		/**
		 * Inicia o Debug.
		 * 
		 * @param	nstage	Stage para adicionar os elementos do Debug.
		 * 
		 * @example
<listing version="3.0">
Debug.stage = stage;

Debug.Start();
</listing>
		 *
		 * @example
<listing version="3.0">
Debug.Start(stage);
</listing>
		 * 
		 */
		public static function Start(nstage:Stage = null):void {
			
			if (Boolean(nstage && nstage as Stage)) { stage = nstage; };
			
			if (!Boolean(started)) {
				
				started = true;
				
				if (Boolean(stage)) {
					
					if (stage.frameRate > 99) {
						atualFPS = String(stage.frameRate);
					} else if (stage.frameRate > 9) {
						atualFPS = "0" + stage.frameRate;
					} else {
						atualFPS = "00" + stage.frameRate;
					}
					countFPS = stage.frameRate;
					
					// S FPS
					txtAllFPS = new TextField();
					txtAllFPS.selectable = false;
					txtAllFPS.autoSize = "right"; txtAllFPS.multiline = true;
					txtAllFPS.alpha = 0; txtAllFPS.scaleY = 0; txtAllFPS.visible = false;
					stage.addChild(txtAllFPS);
					
					function updateFPStext():void {
						if (countFPS > 99) {
								atualFPS = String(countFPS);
							} else if (countFPS > 9) {
								atualFPS = "0" + countFPS;
							} else {
								atualFPS = "00" + countFPS;
							}
							
							if (countFPS <= minFPS) { minFPS = countFPS; };
							if (countFPS >= maxFPS) { maxFPS = countFPS; };
							
							medFPS = (minFPS + maxFPS) / 2;
							
							txtAllFPS.htmlText = "<font color='#FFFFFF' face='tahoma' size='14'>" + countFPS + "</font> <font color='#FFFFFF' face='tahoma' size='11'>fps</font><br><font color='#5be03d' face='tahoma' size='10'>" + maxFPS + "</font> <font color='#ffcc00' face='tahoma' size='10'>" + medFPS + "</font> <font color='#ff3030' face='tahoma' size='10'>" + minFPS + "</font>";
							
							countFPS = 0;
					}
					updateFPStext();
					
					function updateFPS(event:Event):void {
						var currentTime:Number = getTimer();
						
						countFPS++;
						
						if (currentTime >= lastFPS + 500)
						{	
							countFPS = countFPS * 2;
							
							updateFPStext();
							
							lastFPS = currentTime;
						}
					}
					stage.addEventListener (Event.ENTER_FRAME, updateFPS);
					// E FPS
					
					var bkg:Shape = new Shape();
					
					bkg.graphics.beginFill(0x000000); bkg.graphics.moveTo(0, 0);
					bkg.graphics.lineTo(1, 0); bkg.graphics.lineTo(1, 1);
					bkg.graphics.lineTo(0, 1); bkg.graphics.lineTo(0, 0);
					
					McBkg = new MovieClip(); Txt = new TextField();
					
					McBkg.alpha = 0; McBkg.scaleY = 0; McBkg.visible = false;
					Txt.alpha = 0; Txt.scaleY = 0; Txt.visible = false;
					
					Txt.selectable = true; Txt.multiline = true; Txt.htmlText = "";
					
					McBkg.addChild(bkg); stage.addChild(McBkg); stage.addChild(Txt);
					
					function setDbg():void {
						rD = (stage.stageHeight / 10) * (SizePct/10);
						
						if (rD < 43) { rD = 43; }
						
						Txt.height = rD - 4; Txt.width = stage.stageWidth-10;
						Txt.x = 2; Txt.y = (stage.stageHeight - Txt.height) + 2;
						
						McBkg.width = stage.stageWidth; McBkg.height = rD;
						McBkg.x = 0; McBkg.y = stage.stageHeight - McBkg.height;
						
						txtAllFPS.x = stage.stageWidth - txtAllFPS.width - 2;
						txtAllFPS.y = stage.stageHeight - txtAllFPS.height - 2;
						
						stage.removeChild(McBkg); stage.addChild(McBkg);
						stage.removeChild(Txt); stage.addChild(Txt);
						stage.removeChild(txtAllFPS); stage.addChild(txtAllFPS);
						
					}
					setDbg(); setInterval(setDbg, 1);
					
					function CkKb(e:KeyboardEvent):void {
						if (e.keyCode == 68 && Boolean(e.ctrlKey && e.shiftKey)) {
							if (Boolean(active)) {
								active = false;
								hide();
							} else {
								active = true;
								show();
							}
						} else if (e.keyCode == 67 && Boolean(e.ctrlKey && e.shiftKey)) {
							ClearDebug();
						}
					}
					stage.addEventListener(KeyboardEvent.KEY_DOWN, CkKb);
					if(Boolean(active)) {
						show();
					}
				}
			}
			
			Send("Debug started...", "Result", { p:"utils", c:"Debug", m:"Start" } );
		}
		
		/**
		 * Limpa o Debug (Ctrl + Shift + C).
		 */
		public static function ClearDebug():void
		{
			Txt.htmlText = "";
			Send("Debug cleaned...", "Result", { p:"utils", c:"Debug", m:"ClearDebug" } );
		}
		
		/**
		 * Envia mensagens ao Debug.
		 * 
		 * @param	msg		Mensagem a ser enviada ao Debug.
		 * 					<p>Textos, números ou quaisquer outros objetos.</p>
		 * 
		 * @param	tp		Cor (uint) da mensagem ou o tipo de mensagem a ser enviada (String) ('Result', 'Error', 'Alert', 'Info' ou 'NewInstance').
		 * 					<p>'NewInstance' envia uma mensagem informando que uma nova classe foi instanciada, as demais opções, na prática, apenas alteram as cores e categorizam as mensagens.</p>
		 * 
		 * @param	path	Objeto com a origem da mensagem.
		 * 					<p> <code>.p:String</code>	— Pacote da classe de origem.</p>
		 * 					<p> <code>.c:String</code>	— Classe de origem.</p>
		 * 					<p> <code>.m:String</code>	— Método da classe de origem.</p>
		 *
		 * @example
<listing version="3.0">
Debug.Send(
	"Parâmetros são necessário para realizar uma consulta",
	"Error",
	{ p:"database", c:"Connect", m:"NewSqlSelect" }
);

Debug.Send(
	"Limite precisa ser um valor numérico, o valor de Limite foi ignorado",
	"Alert",
	{ p:"database", c:"Connect", m:"NewSqlSelect" }
);

Debug.Send("Mensagem de teste");

Debug.Send(2 + 2);

Debug.Send("Mensagem de teste", "Alert");

Debug.Send("Mensagem de teste", 0x00CBFF);
</listing>
		 * 
		 */
		public static function Send(msg:Object, tp:Object = "Info", path:Object = null):void
		{
			if (!Boolean(McBkg) && Boolean(stage)) { Start(); };
			
			var t:Date = new Date(); var setTxt:String = "";
			
			var hn:String; if (t.getHours() < 10) { hn = "0" + t.getHours(); } else { hn = "" + t.getHours(); };
			var mn:String; if (t.getMinutes() < 10) { mn = "0" + t.getMinutes(); } else { mn = "" + t.getMinutes(); };
			var sn:String; if (t.getSeconds() < 10) { sn = "0" + t.getSeconds(); } else { sn = "" + t.getSeconds(); };
			var ms:String; if (t.getMilliseconds() < 10) { ms = "00" + t.getMilliseconds(); } else if (t.getMilliseconds() < 100) { ms = "0" + t.getMilliseconds(); } else { ms = "" + t.getMilliseconds(); };
			
			var Smsg:String = '' + msg;
			
			var location:String = "";
			
			if(Boolean(path)) {
				if (Boolean(path.p) || Boolean(path.c) || Boolean(path.m)) {
					
					if (Boolean(path.p)) { location = location + path.p; };
					if (Boolean(path.c)) {
						if (location.length > 0) {
							location = location + "." + path.c;
						} else {
							location = location + " " + path.c;
						}
					};
					if (Boolean(path.m)) {
						if (location.length > 0) {
							location = location + "." + path.m;
						} else {
							location = location + " " + path.m;
						}
					};
				}
			}
			if (location.length > 0) {
				location = location + " ";
			}
			
			if (Boolean(Txt && McBkg && stage)) {
				if (tp as uint) {
					setTxt = "<font color='#" + tp.toString(16) + "' face='tahoma' size='12'>";
				} else {
					if (String(tp) == "Result") {
						setTxt = "<font color='#5be03d' face='tahoma' size='12'>";
					} else if (String(tp) == "Error") {
						setTxt = "<font color='#ff3030' face='tahoma' size='12'>";
					} else if (String(tp) == "Alert") {
						setTxt = "<font color='#ffcc00' face='tahoma' size='12'>";
					} else {
						setTxt = "<font color='#FFFFFF' face='tahoma' size='12'>";
					}
				}
					
				var startText:String = "";
					
				// FPS
				startText = startText + "<font size='10'>[ " + atualFPS + " fps ] </font>";
					
				// Time
				startText = startText + hn + ":" + mn + ":" + sn + ".<font size='10'>" + ms + "</font> ";
				
				if (String(msg) == "NewInstance") {
					setTxt = setTxt + startText + location + "> New " + path.m + " instantiated";
				} else {
					setTxt = setTxt + startText + location + "> " + Smsg;
				}
					
				Txt.htmlText = setTxt + "</font><br>" + Txt.htmlText;
			}
		}	
	}
}