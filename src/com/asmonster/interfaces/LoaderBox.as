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
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import flash.display.Loader;
	
	import flash.net.URLRequest;
	
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.asmonster.utils.Debug;
	import com.asmonster.utils.Generic;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import com.asmonster.effects.Transitions;
	
	import com.greensock.easing.Bounce;
	
	/**
	 * Cria rotinas de carregamento e transição de arquivos SWF ou imagens externas.
	*/
	public class LoaderBox 
	{
	
		private var LdObject:Object;
		private var LdObjectCancel:Object = new Object();
		
		private var OrigTarget:Object;
		private var OrigTargetW:Number;
		private var OrigTargetH:Number;
		
		private var FullInW:Object;
		private var FullInH:Object;
		
		private var ProgressText:Object = new TextField();
		private var ProgressObjs:Array = new Array();
		private var LoaderA:Loader = new Loader();
		private var LoaderB:Loader = new Loader();
		private var LastLoaded:Loader = new Loader();
		private var HideOld:String = "OnComplete";
		private var ShowNew:String = "OnComplete";
		
		private var TransitionsShowParams:Object = new Object();
		private var TransitionsHideParams:Object = new Object();
		
		private var alphaTo:Number = 1;
		
		private var Time:Number = 0.6;
		
		private var FullInFake:Boolean = true;
		
		private var ObjWidth:Number = 0;
		private var ObjHeight:Number = 0;
		
		private var H:String = undefined;
		private var V:String = undefined;
		
		private var arrListeners:Array = new Array();
		
		/**
		 * Cria uma nova instância da LoaderBox.
		 * 
		 * @param	ldbx_parameters				Objeto com os parâmetros do construtor da LoaderBox.
		 * 										<p> <code>.Target				:String/Object</code>	— Objeto aonde será adicionado a LoaderBox.</p>
		 * 										<p> <code>.Container			:Object/Stag</code>		— Local em que o objeto aonde será adicionado a LoaderBox será procurado.</p>
		 * 										<p> <code>.ProgressText			:TextField</code>		— TextField para exibir a procentagem de progresso do carregamento.</p>
		 * 										<p> <code>.ProgressObjs			:Object/Array</code>	— Objeto ou Array com múltiplos objetos a serem exibidos/ocultados durante o progresso do carregamento.</p>
		 * 										<p> <code>.autoAlign			:String</code>			— Alinhamento automático do item carregado ['C', 'T' ou 'B' + 'C', 'L' ou 'R'] (defaults false).</p>
		 * 										<p> <code>.HideOld				:String</code>			— Momento para ocultar o item carregado anteriormente (defaults 'OnComplete') ['OnComplete' ou 'OnStart'].</p>
		 * 										<p> <code>.ShowNew				:String</code>			— Momento para exibir o novo item carregado (defaults 'OnComplete') ['OnComplete' ou 'AfterHideOld'].</p>
		 * 										<p> <code>.alphaTo				:Number</code>			— Alpha do item carregado (defaults 1).</p>
		 * 										<p> <code>.FullIn				:Object</code>			— Objeto de referência para redimensionar o item carregado.</p>
		 * 										<p> <code>.FullInW				:Object</code>			— Objeto de referência para redimensionar a largura o item carregado.</p>
		 * 										<p> <code>.FullInH				:Object</code>			— Objeto de referência para redimensionar a altura o item carregado.)</p>
		 * 										<p> <code>.ResizeToW			:Number</code>			— Largura para redimensionar o item carregado. (substitui .FullInW)</p>
		 * 										<p> <code>.ResizeToH			:Number</code>			— Altura para redimensionar o item carregado. (substitui .FullInH)</p>
		 * 
		 * 										<p> <code><b>.Transition			:</b>Object</code>		— Objeto com os parâmetros da animação.</p>
		 * 
		 * @example
<listing version="3.0">

var MyLoader:LoaderBox = new  LoaderBox( { Target:stage } );

function Cplt():void {
	Debug.Send("lol");
}

MyLoader.Load("image9.jpg", Cplt);


var MyLoaderB:LoaderBox = new  LoaderBox( {
	Target:stage,
	Container:stage,
	ProgressText:Cpb,
	ProgressObjs:[Cpb],
	HideOld:"OnComplete",
	ShowNew:"OnComplete",
	autoAlign:"CC",
	alphaTo:1,
	Animation: {
				Time:1.6,
				Ease:Bounce.easeOut,
				alpha:true,
				scaleX:true,
				scaleY:true,
				slideX:true,
				slideY:true,
				rotation:true
	}
} );

MyLoaderB.Load("image7.jpg");
</listing>
		 * 
		 * 
		 */
		public function LoaderBox(ldbx_parameters:Object = null):void
		{
			function check_ldbx_parameters():Boolean {
				if(Boolean(ldbx_parameters.autoAlign)) {
					if (String(ldbx_parameters.autoAlign).substr(1, 1) == "C" || String(ldbx_parameters.autoAlign).substr(1, 2) == "L" || String(ldbx_parameters.autoAlign).substr(1, 2) == "R") {
						H = String(ldbx_parameters.autoAlign).substr(1, 2);
					}
				}
				if(Boolean(ldbx_parameters.autoAlign)) {
					if (String(ldbx_parameters.autoAlign).substr(0, 1) == "C" || String(ldbx_parameters.autoAlign).substr(0, 1) == "T" || String(ldbx_parameters.autoAlign).substr(0, 1) == "B") {
						V = String(ldbx_parameters.autoAlign).substr(0, 1);
					}
				}
				if (!Boolean(ldbx_parameters)) {
					Debug.Send("Object with parameters are required for LoaderBox", "Error", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					return false;
				}
				if (!Boolean(ldbx_parameters.Target)) {
					Debug.Send("Target is required for LoaderBox", "Error", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					return false;
				}
				if (Boolean(ldbx_parameters.HideOld)) {
					if (ldbx_parameters.HideOld == "OnComplete" || ldbx_parameters.HideOld == "OnStart") {
						HideOld = ldbx_parameters.HideOld;
					} else {
						Debug.Send("HideOld must be 'OnComplete' or 'OnStart', the defaults value ('OnComplete') has been defined", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					}
				}
				if (Boolean(ldbx_parameters.ShowNew)) {
					if (ldbx_parameters.ShowNew == "OnComplete" || ldbx_parameters.ShowNew == "AfterHideOld") {
						ShowNew = ldbx_parameters.ShowNew;
					} else {
						Debug.Send("ShowNew must be 'OnComplete' or 'AfterHideOld', the defaults value ('OnComplete') has been defined", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					}
				}
				if (Boolean(ldbx_parameters.alphaTo)) {
					if(isNaN(ldbx_parameters.alphaTo)) {
						Debug.Send("alphaTo must be a numeric value, the default value (1) has been defined", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					} else {
						alphaTo = ldbx_parameters.alphaTo;
					}
				}
				if (Boolean(ldbx_parameters.FullIn)) {
					if(ldbx_parameters.FullIn as Stage) {
						FullInW = ldbx_parameters.FullIn;
						FullInH = ldbx_parameters.FullIn;
					} else {
						FullInW = new Object(); FullInW.width = ldbx_parameters.FullIn.width;
						FullInH = new Object(); FullInH.height = ldbx_parameters.FullIn.height;
					}
					FullInFake = false;
				}
				if (Boolean(ldbx_parameters.FullInW)) {
					if(ldbx_parameters.FullInW as Stage) {
						FullInW = ldbx_parameters.FullInW;
					} else {
						FullInW = new Object(); FullInW.width = ldbx_parameters.FullInW.width;
					}
					FullInFake = false;
				}
				if (Boolean(ldbx_parameters.FullInH)) {
					if(ldbx_parameters.FullInH as Stage) {
						FullInH = ldbx_parameters.FullInH;
					} else {
						FullInH = new Object(); FullInH.height = ldbx_parameters.FullInH.height;
					}
					FullInFake = false;
				}
				if (Boolean(ldbx_parameters.ResizeToW || ldbx_parameters.ResizeToH)) {
					var objSize:Object = new Object();
				}
				if (Boolean(ldbx_parameters.ResizeToW)) {
					if(isNaN(ldbx_parameters.ResizeToW)) {
						Debug.Send("ResizeToW must be a numeric value, ResizeToW will be ignored", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					} else {
						ObjWidth = ldbx_parameters.ResizeToW;
						objSize.width = ldbx_parameters.ResizeToW;
						FullInW = objSize;
					}
				}
				if (Boolean(ldbx_parameters.ResizeToH)) {
					if(isNaN(ldbx_parameters.ResizeToH)) {
						Debug.Send("ResizeToH must be a numeric value, ResizeToH will be ignored", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					} else {
						ObjHeight = ldbx_parameters.ResizeToH;
						objSize.height = ldbx_parameters.ResizeToH;
						FullInH = objSize;
					}
				}
				if(ldbx_parameters.Transition as Object) {
					TransitionsShowParams = ldbx_parameters.Transition;
					TransitionsHideParams = ldbx_parameters.Transition;
				}
				if(ldbx_parameters.TransitionShow as Object) {
					TransitionsShowParams = ldbx_parameters.TransitionShow;
				}
				if(ldbx_parameters.TransitionHide as Object) {
					TransitionsHideParams = ldbx_parameters.TransitionHide;
				}
				LdObject = Generic.GetTarget(ldbx_parameters.Target, ldbx_parameters.Container);
				OrigTarget = Generic.GetTarget(ldbx_parameters.Target, ldbx_parameters.Container);
				
				if (OrigTarget as Stage) {
					OrigTargetW = OrigTarget.stageWidth;
					OrigTargetH = OrigTarget.stageHeight;
				} else {
					OrigTargetW = OrigTarget.width;
					OrigTargetH = OrigTarget.height;
				}
				
				if (Boolean(LdObject)) {
					var LoaderMC:MovieClip = new MovieClip();
					LdObject.addChild(LoaderMC);
					LdObject = LoaderMC;
					LastLoaded = new Loader();
					LastLoaded.name = "LoaderB";
					if (Boolean(FullInW || FullInH)) {
						function ResizeCnt():void {
							FullInN();
						}
						ResizeCnt();
						setInterval(ResizeCnt, 5);
					}
					return true;
				} else {
					Debug.Send("Invalid Target object", "Error", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
					return false;
				}
			} if (check_ldbx_parameters() == true) {
				if (Boolean(ldbx_parameters.ProgressText)) {
					ProgressText = Generic.GetTarget(ldbx_parameters.ProgressText, ldbx_parameters.Container);
					if (!Boolean(ProgressText)) {
						ProgressText = Generic.GetTarget(ldbx_parameters.ProgressText);
						if (!Boolean(ProgressText)) {
							Debug.Send("The ProgressText object is invalid, the Object has been ignored", "Alert", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
						}
					}
				}
				if (Boolean(ldbx_parameters.ProgressObjs as Array)) {
					ProgressObjs = ldbx_parameters.ProgressObjs;
					for (var i:int = 0; i < ProgressObjs.length; i++) 
					{
						ProgressObjs[i] = Generic.GetTarget(ProgressObjs[i], ldbx_parameters.Container);
					}
				} else if (Boolean(ldbx_parameters.ProgressObjs)) {
					if(Boolean(Generic.GetTarget(ldbx_parameters.ProgressObjs, ldbx_parameters.Container))) {
						ProgressObjs[0] = Generic.GetTarget(ldbx_parameters.ProgressObjs, ldbx_parameters.Container);
					}
				}
				Debug.Send("NewInstance", "Info", { p:"interfaces", c:"LoaderBox", m:"LoaderBox" } );
			};
		}
		
		private var behaviorStatus:Boolean = false;
		private var behaviorInterval:uint;
		private var behaviorAtualFile:Number;
		
		private var behaviorTime:Number = 2;
		
		private var behaviorDefaultPath:String = "";
		
		private var behaviorFilesOr:Array;
		private var behaviorFilesList:Array;
		
		private var behaviorShuffle:Boolean = true;
		private var behaviorFixedFirst:Boolean = false;
		private var behaviorFixedLast:Boolean = false;
		
		private var behaviorReplay:Boolean = true;
		
		/**
		 * Define rotinas da LoaderBox.
		 * 
		 * @param	behaviorParams		Objeto com os parâmetros do método setBehavior.
		 * 								<p> <code>.intervalTime		:Number</code>		— Intervalo em segundos para um novo carregamento (defaults 2).</p>
		 * 								<p> <code>.defaultPath		:String</code>		— Loca padrão dos arquivos a serem carregados.</p>
		 * 								<p> <code>.Files			:Array</code>		— Arquivos a serem carregados.</p>
		 * 								<p> <code>.Shuffle			:Bollean</code>		— Ordem aleatória dos itens (defaults true).</p>
		 * 								<p> <code>.fixedFirst		:Bollean</code>		— Primeiro item fixo (defaults false).</p>
		 * 								<p> <code>.fixedLast		:Bollean</code>		— Último item fixo (defaults false).</p>
		 * 								<p> <code>.Replay			:Bollean</code>		— Reiniciar sequência de arquivos (defaults true).</p>
		 * 
		 */
		public function setBehavior(behaviorParams:Object = null):void {
			
			function validParams():Boolean {
				if (!isNaN(behaviorParams.intervalTime)) {
					behaviorTime = behaviorParams.intervalTime;
				}
				if (behaviorParams.defaultPath as String && Boolean(behaviorParams.defaultPath)) {
					behaviorDefaultPath = behaviorParams.defaultPath;
				}
				if (behaviorParams.Files as Array && behaviorParams.Files.length > 1) {
					behaviorFilesOr = behaviorParams.Files;
				} else {
					Debug.Send("The setBehavior method is for 2 or mor files", "Error", { p:"interfaces", c:"LoaderBox", m:"setBehavior" } );
					return false;
				}
				if (behaviorParams.Shuffle == false) {
					behaviorShuffle = false;
				}
				if (behaviorParams.fixedFirst == true) {
					behaviorFixedFirst = true;
				}
				if (behaviorParams.fixedLast == true) {
					behaviorFixedLast = true;
				}
				if (behaviorParams.Replay == false) {
					behaviorReplay = false;
				}
				return true;
			}
			
			if (Boolean(validParams())) {
				
				behaviorStatus = true;
				
				getFilesList();
				
				behaviorAtualFile = -1;
				
				Next();
				
				//behaviorStatus - behaviorInterval - behaviorAtualFile - behaviorTime - behaviorReplay
				
				//if (Boolean(behaviorShuffle)) { getFilesList(); }
				
			}
			
		}
		
		private function getFilesList():void {
			if (Boolean(behaviorShuffle)) {
				behaviorFilesList = behaviorFilesOr;
				var behaviorFilesFirst:String = ""; var behaviorFilesLast:String = "";
				if (Boolean(behaviorFixedFirst)) { behaviorFilesFirst = behaviorFilesList.shift(); }
				if (Boolean(behaviorFixedLast)) { behaviorFilesLast = behaviorFilesList.pop(); }
				if (Boolean(behaviorShuffle)) { behaviorFilesList = Generic.ShuffleArray(behaviorFilesList); }
				if (Boolean(behaviorFilesFirst)) { behaviorFilesList.unshift(behaviorFilesFirst); }
				if (Boolean(behaviorFixedLast)) { behaviorFilesList.push(behaviorFilesLast); }
			} else {
				behaviorFilesList = behaviorFilesOr;
			}
		}
		
		private function NextTimer():void {
			if (Boolean(behaviorStatus)) {
				clearTimeout(behaviorInterval);
				behaviorInterval = setTimeout(Next, behaviorTime * 1000);
			}
		}
		
		private function Next():void {
			
			//behaviorStatus - behaviorInterval - behaviorAtualFile - behaviorTime - behaviorReplay
			
			behaviorAtualFile = behaviorAtualFile + 1;
			
			if (behaviorAtualFile == behaviorFilesList.length) {
				if (Boolean(behaviorReplay)) {
					if (Boolean(behaviorShuffle)) { getFilesList(); }
					behaviorAtualFile = 0;
					internalLoad(behaviorDefaultPath + behaviorFilesList[behaviorAtualFile], NextTimer);
				}
			} else {
				internalLoad(behaviorDefaultPath + behaviorFilesList[behaviorAtualFile], NextTimer);
			}
			
		}
		
		private function Prev():void {
			
			behaviorAtualFile = behaviorAtualFile - 1;
			
			if (behaviorAtualFile < 0) {
				if (Boolean(behaviorReplay)) {
					if (Boolean(behaviorShuffle)) { getFilesList(); }
					behaviorAtualFile = behaviorFilesList.length - 1;
					internalLoad(behaviorDefaultPath + behaviorFilesList[behaviorAtualFile], NextTimer);
				}
			} else {
				internalLoad(behaviorDefaultPath + behaviorFilesList[behaviorAtualFile], NextTimer);
			}
			
		}
		
		public function Load(File:String, OnLoad:Function = null):void {
			if (Boolean(behaviorStatus)) {
				Debug.Send("Load indisponível depois do setBehavior", "Info", { p:"interfaces", c:"LoaderBox", m:"Load" } );
			} else {
				internalLoad(File, OnLoad);
			}
		}
		
		/**
		 * Carrega um novo arquivo na LoaderBox.
		 * 
		 * @param	File		Arquivo a ser carregado.
		 * @param	OnLoad		Função a ser chamada ao completar o carregamento.
		 */
		private function internalLoad(File:String, OnLoad:Function = null):void {
			if (!Boolean( Transitions.isInTransition(LoaderA) || Transitions.isInTransition(LoaderB) )) {
				for (var i:Number = 0; i < arrListeners.length; i++) {
					if(arrListeners[i].obj.hasEventListener(arrListeners[i].type)) {
						arrListeners[i].obj.removeEventListener(arrListeners[i].type, arrListeners[i].listener);
					}
				}			
				arrListeners = new Array();
				if (LastLoaded.name == "LoaderB") {
					try { LoaderA.close(); LoaderA.unload(); } catch (e:Error) { };
					LoaderA = new Loader();
					LoaderA .x = 0; LoaderA.y = 0;
					LoaderA.name = "LoaderA";
					if ( Boolean(LdObject.getChildByName("LoaderA")) ) {
						LdObject.removeChild(LdObject.getChildByName("LoaderA"));
						LdObject.addChild(LoaderA);
					} else { LdObject.addChild(LoaderA); };
					loadProgFile(LoaderA, ProgressText, ProgressObjs, OnLoad);
					LoaderA.load(new URLRequest(File));
					if (HideOld == "OnStart") {
						AnimateObject(LoaderB, "Hide", Time, 0);
					}
				} else {
					try { LoaderB.close(); LoaderB.unload(); } catch (e:Error) { };
					LoaderB = new Loader();
					LoaderB.name = "LoaderB";
					LoaderB.x = 0; LoaderB.y = 0;
					if ( Boolean(LdObject.getChildByName("LoaderB")) ) {
						LdObject.removeChild(LdObject.getChildByName("LoaderB"));
						LdObject.addChild(LoaderB);
					} else { LdObject.addChild(LoaderB); };
					loadProgFile(LoaderB, ProgressText, ProgressObjs, OnLoad);
					LoaderB.load(new URLRequest(File));
					if (HideOld == "OnStart") {
						AnimateObject(LoaderA, "Hide", Time, 0);
					}
				}
			}
		}
		
		public function Cancel():void {
			if (Boolean(behaviorStatus)) {
				Debug.Send("Cancel indisponível depois do setBehavior", "Info", { p:"interfaces", c:"LoaderBox", m:"Load" } );
			} else {
				internalCancel();
			}
		}
		
		/**
		 * Cancela qualquer carregamento ainda não completo.
		 */
		private function internalCancel():void {
			if (!Boolean( Transitions.isInTransition(LoaderA) || Transitions.isInTransition(LoaderB) )) {			
				AnimateObject(ProgressObjs, "Hide", (Time/3)*2, 0);
				for (var i:Number = 0; i < arrListeners.length; i++) {
					if(arrListeners[i].obj.hasEventListener(arrListeners[i].type)) {
						arrListeners[i].obj.removeEventListener(arrListeners[i].type, arrListeners[i].listener)
					}
				}
				arrListeners = new Array();
				if (LdObjectCancel.name == "LoaderB") {
					try { LoaderA.close(); LoaderA.unload(); } catch (e:Error) { };
					LoaderA = new Loader();
					LoaderA.name = "LoaderA";
					if (Boolean(FullInW)) {
						LoaderA.width = ObjWidth;
					}
					if (Boolean(FullInH)) {
						LoaderA.height = ObjHeight;
					}
					if ( Boolean(LdObject.getChildByName("LoaderA")) ) {
						LdObject.removeChild(LdObject.getChildByName("LoaderA"));
						LdObject.addChild(LoaderA);
					} else { LdObject.addChild(LoaderA); };
				} else {
					try { LoaderB.close(); LoaderB.unload(); } catch (e:Error) { };
					LoaderB = new Loader();
					LoaderB.name = "LoaderB";
					LoaderB.width = ObjWidth;
					LoaderB.height = ObjHeight;
					if ( Boolean(LdObject.getChildByName("LoaderB")) ) {
						LdObject.removeChild(LdObject.getChildByName("LoaderB"));
						LdObject.addChild(LoaderB);
					} else { LdObject.addChild(LoaderB); };
				}
				Debug.Send("Load Canceled", "Info", { p:"interfaces", c:"LoaderBox", m:"Cancel" } );
			}
		}
		
		/**
		 * Controla a animação dos itens.
		 * 
		 * @param	Obj			Objeto Loader a ser animado.
		 * @param	Type		Tipo de animação ['Show' ou 'Hide'].
		 * @param	Time		Tempo em segundos para a animação.
		 * @param	Delay		Delay em segundos para a animação.
		 */
		private function AnimateObject(Obj:Object, Type:String, Time:Number = undefined, Delay:Number = undefined):void {
			if (Obj as Array) {
				for (var i:int = 0; i < Obj.length; i++) {
					TweenMax.killTweensOf(Obj[i]);
					Obj[i].visible = true;
					if (Type == "Show") {
						Obj[i].alpha = 0; Obj[i].visible = true;
						TweenMax.to(Obj[i], Time, { delay:Delay, alpha:1, overwrite:0, ease:Expo.easeOut } );
					} else {
						TweenMax.to(Obj[i], Time, { delay:Delay, alpha:0, overwrite:0, ease:Expo.easeOut } );
					}
				}
				if (Type != "Show") {
					var OnComVisFt:Function = function():void {
						for (var a:int = 0; a < Obj.length; a++) { Obj[a].visible = false; }
					}
					clearTimeout(OnComVist); var OnComVist:uint = setTimeout(OnComVisFt, (Time + Delay + 0.1) * 1000);
				}
			} else {
				Transitions.killTransition(Obj);
				
				var ObjWrn:Number; var ObjHrn:Number;
				
				if (Boolean(FullInW)) { ObjWrn = ObjWidth; } else { ObjWrn = Obj.width; }
				if (Boolean(FullInH)) { ObjHrn = ObjHeight; } else { ObjHrn = Obj.height; }
				
				if (Type == "Show") {
					if (OrigTarget as Stage) { OrigTargetW = OrigTarget.stageWidth; OrigTargetH = OrigTarget.stageHeight; }
					if (Boolean(H)) {
						if(FullInFake && H == "C") {
							Obj.x = (OrigTargetW / 2) - (ObjWrn / 2);
						} else if (H == "R") {
							Obj.x = OrigTargetW - ObjWrn;
						} else {
							Obj.x = 0
						}
					}
					if (FullInFake && Boolean(V)) {
						if(V == "C") {
							Obj.y = (OrigTargetH / 2) - (ObjHrn / 2);
						} else if (V == "B") {
							Obj.y = OrigTargetH - ObjHrn;
						} else {
							Obj.y = 0;
						}
					}
				}
				
				//Obj.visible = true;
				
				if (Type != "Show") {
					var OnComVisF:Function = function():void {
						if(Obj) {
							Obj.visible = false; Obj.width = 1; Obj.height = 1;
						}
					}
					clearTimeout(OnComVis);
					var OnComVis:uint = setTimeout(OnComVisF, (Time + Delay + 0.1) * 1000);
				}
				
				if (Type == "Show") {
					TransitionsShowParams.Time = Time;
					TransitionsShowParams.delay = Delay;
					Transitions.New(Obj, 'show', TransitionsShowParams);
				} else {
					TransitionsHideParams.Time = Time;
					TransitionsHideParams.delay = Delay;
					Transitions.New(Obj, 'hide', TransitionsHideParams);
				}
				
			}
		}
		
		/**
		 * Redimensiona Loaders de acordo com alguma referência.
		 */
		private function FullInN():void {
			var objToResA:Object = LdObject.getChildByName("LoaderA");
			var objToResB:Object = LdObject.getChildByName("LoaderB");
			if (Boolean(FullInW)) {
				if (FullInW as Stage) {
					ObjWidth = FullInW.stageWidth;
				} else {
					ObjWidth = FullInW.width;
				}
				if (Boolean(objToResA)) {
					if(Boolean(objToResA.width != 0 && objToResA.height != 0)) {
						if (objToResA.width != ObjWidth) {
							objToResA.width = ObjWidth;
						}
					}
				}
				if (Boolean(objToResB)) {
					if(Boolean(objToResB.width != 0 && objToResB.height != 0)) {
						if (objToResB.width != ObjWidth) {
							objToResB.width = ObjWidth;
						}
					}
				}				
			}
			if (Boolean(FullInH)) {
				if (FullInH as Stage) {
					ObjHeight = FullInH.stageHeight;
				} else {
					ObjHeight = FullInH.height;
				}
				if (Boolean(objToResA)) {
					if(Boolean(objToResA.width != 0 && objToResA.height != 0)) {
						if (objToResA.height != ObjHeight) {
							objToResA.height = ObjHeight;
						}
					}
				}
				if (Boolean(objToResB)) {
					if(Boolean(objToResB.width != 0 && objToResB.height != 0)) {
						if (objToResB.height != ObjHeight) {
							objToResB.height = ObjHeight;
						}
					}
				}
			}
		}
		
		/**
		 * Controla o objeto Loader e seus eventos.
		 * 
		 * @param	loaderObj			Objeto Loader para controlar os eventos.
		 * @param	txtObj				Objeto de texto para informar a porcentagem carregada.
		 * @param	Onload				Função a ser chamada ao completar o carregamento.
		 */
		private function loadProgFile(loaderObj:Loader, txtObj:Object = null, ArrProgrObjs:Array = null, Onload:Function = null):void {
			var pc:Number;
			if(txtObj as TextField) {
				txtObj.text = "0%";
			}
			if (ArrProgrObjs.length > 0) {
				AnimateObject(ArrProgrObjs, "Show", (Time / 3) * 2, 0);
			}
			function PROGRESS(event:ProgressEvent):void {
				pc = Math.round((event.bytesLoaded / event.bytesTotal) * 100);
				if(txtObj as TextField) {
					txtObj.text = pc + "%";
				}
				loaderObj.alpha = 0;
			};
			loaderObj.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, PROGRESS);
			arrListeners.push( { obj:loaderObj.contentLoaderInfo, type:ProgressEvent.PROGRESS, listener:PROGRESS } );
			function COMPLETE(event:Event):void {
				function GoComplete():void {
					if (HideOld == "OnComplete") {
						AnimateObject(LastLoaded, "Hide", Time, 0);
					}
					if (ArrProgrObjs.length > 0) {
						AnimateObject(ArrProgrObjs, "Hide", (Time / 3) * 2, 0);
					}
					if (ShowNew == "OnComplete") {
						AnimateObject(loaderObj, "Show", Time, 0);
						if (Boolean(Onload)) { Onload(); };
					} else {
						if(Transitions.isInTransition(LastLoaded)) {
							AnimateObject(loaderObj, "Show", Time, Time + 0.1);
							if (Boolean(Onload)) {
								clearTimeout(OnCompleteS);
								var OnCompleteS:uint = setTimeout(Onload, (Time + 0.1) * 1000);
							};
						} else {
							AnimateObject(loaderObj, "Show", Time, 0);
							if (Boolean(Onload)) { Onload(); };
						};
					}
					LastLoaded = loaderObj;
				}
				if ( int(txtObj.text.replace("%", "")) == 100) {
					LdObjectCancel.name = loaderObj.name;
					GoComplete();
				}
			}
			loaderObj.contentLoaderInfo.addEventListener(Event.COMPLETE, COMPLETE);			
			arrListeners.push( { obj:loaderObj.contentLoaderInfo, type:Event.COMPLETE, listener:COMPLETE } );
		}
	}
}