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

package com.asmonster.database 
{
	
	import flash.display.Loader;
	import flash.display.Stage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import flash.net.URLRequest;
	
	import flash.text.TextField;
	
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	import com.adobe.crypto.SHA256;
	
	import com.asmonster.utils.Debug;
	
	import com.asmonster.utils.Generic;
	
	import com.greensock.TweenMax;
	
	/**
	 * Trabalha com os dados obtidos através da classe database.Connect.
	*/
	public class UseData
	{
		
		private var AddChildIn:Object;
		private var AtualPage:Number = 1;
		
		private var ItemsByRC:Number = 1;
		private var TotalPages:Number = 0;
		private var ObjModel:Object;
		private var NextBtObj:Object;
		private var PrevBtObj:Object;
		private var Disposal:String = "H";
		private var StartX:Number = 0;
		private var StartY:Number = 0;
		private var ObjWidth:Number = undefined;
		private var ObjHeight:Number = undefined;
		private var DistX:Number = 0;
		private var DistY:Number = 0;
		private var OnEndPage:String = "Continue";
		
		private var StatusText:Object;
		private var TotalItemsText:Object;
		private var TotalPagesText:Object;
		private var AtualPageText:Object;
		
		private var AutoAdjustIn:Object;
		private var AutoDist:Boolean = false;
		private var minDistX:Number = 0;
		private var minDistY:Number = 0;
		private var EqualDists:Boolean = false;
		
		private var TextOnComplete:String = "Complete!";
		private var TextOnLoading:String = "Loading...";
		
		private var ObjsData:Array;
		
		private var arrListenersBt:Array = new Array();;
		private var Animation:Object;
		
		
		private var ItemsByPageP:Number = 1;
		/**
		 * itens por página.
		 * @default 1
		*/
		public function get ItemsByPage():Number { return ItemsByPageP; };
		/**  * @private  */ 
		public function set ItemsByPage(nv:Number):void { ItemsByPageP = nv; };
		
		
		private var ItemsP:Array = new Array();
		/**
		 * Array com os objetos exibidos na página atual.
		*/
		public function get Items():Array { return ItemsP; };
		/**  * @private  */ 
		public function set Items(nv:Array):void { ItemsP = nv; };
		
		
		private var PositionsP:Array = new Array();
		/**
		 * Posição dos objetos exibidos na página atual.
		*/
		public function get Positions():Array { return PositionsP; };
		/**  * @private  */ 
		public function set Positions(nv:Array):void { PositionsP = nv; };
		
		private var ObjDataP:Object;
		/**
		 * Objeto com a instância da classe Connect.
		*/
		public function get ObjData():Object { return ObjDataP; }
		/**  * @private  */ 
		public function set ObjData(nv:Object):void { ObjDataP = nv; };
		
		
		/**
		 * Construtor
		 * 
		 * @param	Data	Objeto com uma instância da classe Connect.
		 * 
		 * @see Connect
		 * 
		 */
		public function UseData(Data:Connect = null):void {
			if (!Boolean(Data)) {
				Debug.Send("É necessário um Objeto com uma instância da classe Connect", "Error", { p:"database", c:"UseData", m:"UseData" } );
			} else {
				ObjData = Data;
				Debug.Send("NewInstance", "Info", { p:"database", c:"UseData", m:"UseData" } );
			}
		}
		
		/**
		 * Insere os dados obtidos pela classe Connect em um objeto ou cria eventos com os dados.
		 * 
		 * @param	gtdt_parameters		Object	  		Objeto com os parâmetros do método GetData
		 * 								<p> <code>.Type				:String</code>			— Tipo de objeto a ser trabalhado. ['Text', 'Load' or 'Button']</p>
		 * 								<p> <code>.Target			:Object</code>			— Objeto que receberá os dados ou eventos.</p>
		 * 								<p> <code>.ProgressText		:TextField</code>		— TextField para mostrar um carregando caso .Type for 'Load'.</p>
		 * 								<p> <code>.Data				:String</code>			— Dados manuais para inserir no objeto ou criar algum evento (substitui .GetField).</p>
		 * 								<p> <code>.Line				:Number</code>			— Número da linha de onde os dados serão obtidos.</p>
		 * 								<p> <code>.Over				:Function</code>		— Caso .Type for 'Button', função para o evento 'MouseEvent.MOUSE_OVER'.</p>
		 * 								<p> <code>.Out				:Function</code>		— Caso .Type for 'Button', função para o evento 'MouseEvent.MOUSE_OUT';</p>
		 * 								<p> <code>.Click			:Function</code>		— Caso .Type for 'Button', função para o evento 'MouseEvent.CLICK'.</p>
		 * 								<p> <code>.Function			:Function</code>		— Função a ser chamada quando os dados forem obtidos (substitui .Target e .Type).</p>
		 * 								<p> <code><b>.GetField		:</b>Object</code>		— Objeto com os parâmetros do método GetField (substitui .Data).</p>
		 * 								<p> <code>.GetField.Line	:Number</code>			— Number of row in the database to get data.</p>
		 * 								<p> <code>.GetField.Columns	:String/Array</code>	— Número da linha de onde os dados serão obtidos.</p>
		 * 								<p> <code>.GetField.OnEmpty	:String</code>			— Valor a ser utilizado para campos vazios.</p>
		 * 								<p> <code>.GetField.IsEmpty	:Array</code>			— Valores que serão considerados como vazio.</p>
		 * 								<p> <code>.GetField.Use		:String</code>			— Modelo de texto a ser retornado.</p>
		 * 
		 * @see Connect
		 * 
		 * @example
<listing version="3.0">
var Data:Connect = new Connect();

var List:UseData = new UseData(Data);

var MyTxtFld:TextField = new TextField();

List.GetData( {
	Target: MyTxtFld, Type: "Text", 
	GetField: {
		Line: 2,
		Columns: "age",
		IsEmpty: [20],
		OnEmpty: "ops..."
	}
} );

var Data:Connect = new Connect();

var List:UseData = new UseData(Data);

var MyTxtFld:TextField = new TextField();

List.GetData( {
	Target: MyTxtFld, Type: "Text", 
	GetField: {
		Line: 3,
		Columns: ["age","name"],
		Use:"Age: &lt;1&gt; - Name: &lt;2&gt;"
	}
} );
</listing>
		 * 
		 * 
		 */
		public function GetData(gtdt_parameters:Object = null):Boolean
		{
			function completeData():Boolean {
				if ( gtdt_parameters.Type == "Text" || gtdt_parameters.Type == "Load" || gtdt_parameters.Type == "Button" ) {
					if ( !Boolean(gtdt_parameters.Data) && gtdt_parameters.Type != "Button" || !Boolean(gtdt_parameters.Data) && gtdt_parameters.Type == "Button" && Boolean(gtdt_parameters.GetField) ) {
						gtdt_parameters.Data = GetField( gtdt_parameters.GetField );
					}
					if ( Boolean(gtdt_parameters.Target) ) {
						if (gtdt_parameters.Type == "Text") {
							gtdt_parameters.Target.text = "" + gtdt_parameters.Data;
							return true;
						} else if (gtdt_parameters.Type == "Load") {
							var ObjMc:Object = gtdt_parameters.Target;
							var obJmcl:Loader = new Loader();
							obJmcl.name = "TempLoaderObject";
							if ( Boolean(ObjMc.getChildByName("TempLoaderObject")) ) {
								ObjMc.removeChild(ObjMc.getChildByName("TempLoaderObject"));
							}
							loadProgFile(obJmcl, gtdt_parameters.ProgressText);
							obJmcl.load(new URLRequest(gtdt_parameters.Data));
							ObjMc.addChild(obJmcl);
							return true;
						} else if (gtdt_parameters.Type == "Button") {							
							if (Boolean(gtdt_parameters.Click) && Boolean(gtdt_parameters.Over) || Boolean(gtdt_parameters.Click) && Boolean(gtdt_parameters.Out) || Boolean(gtdt_parameters.Over) && Boolean(gtdt_parameters.Out)) {
								Debug.Send("O objeto precisa ter apenas 'Click', 'Over' ou 'Out', não é permitido mais de um evento por objeto, o objeto foi ignorado", "Error", { p:"database", c:"UseData", m:"GetData" } );
								return false;
							} else {
								if (Boolean(gtdt_parameters.Click as Function) || Boolean(gtdt_parameters.Over as Function) || Boolean(gtdt_parameters.Out as Function)) {
									var objRt:Object =  new Object();
									objRt.Data = gtdt_parameters.Data;
									if(Boolean(gtdt_parameters.GetField)) {
										objRt.Line = gtdt_parameters.GetField.Line;
									} else {
										objRt.Line = gtdt_parameters.Line;
									}
									function Over(event:MouseEvent):void {
										objRt.event = event;
										gtdt_parameters.Over(objRt);
									}
									function Out(event:MouseEvent):void {
										objRt.event = event;
										gtdt_parameters.Out(objRt);
									}
									function Click(event:MouseEvent):void {
										objRt.event = event;
										gtdt_parameters.Click(objRt);
									}
									if (gtdt_parameters.Over as Function) {
										gtdt_parameters.Target.addEventListener(MouseEvent.MOUSE_OVER, Over);
										if(!Boolean(gtdt_parameters.GetField) && Boolean(objRt.Line)) {
											arrListenersBt.push( { obj:gtdt_parameters.Target, type:MouseEvent.MOUSE_OVER, listener:Over } );
										}
									}
									if (gtdt_parameters.Out as Function) {
										gtdt_parameters.Target.addEventListener(MouseEvent.MOUSE_OUT, Out);
										if(!Boolean(gtdt_parameters.GetField) && Boolean(objRt.Line)) {
											arrListenersBt.push( { obj:gtdt_parameters.Target, type:MouseEvent.MOUSE_OUT, listener:Out } );
										}
									}
									if (gtdt_parameters.Click as Function) {
										gtdt_parameters.Target.addEventListener(MouseEvent.CLICK, Click);
										if(!Boolean(gtdt_parameters.GetField) && Boolean(objRt.Line)) {
											arrListenersBt.push( { obj:gtdt_parameters.Target, type:MouseEvent.CLICK, listener:Click } );
										}
									}
									return true;
								} else {
									Debug.Send("O objeto precisa ter uma função em 'Click', 'Over' ou 'Out' para criar um Button, o objeto foi ignorado", "Error", { p:"database", c:"UseData", m:"GetData" } );
								}
							}
						}
					} else {
						Debug.Send("Target é necessário.", "Error", { p:"database", c:"UseData", m:"GetData" } );
						return false;
					}
				} else {
					if (gtdt_parameters.Function as Function && Boolean(gtdt_parameters.Data || gtdt_parameters.GetField || gtdt_parameters.Line)) {
						var objRtF:Object =  new Object();
						if ( !Boolean(gtdt_parameters.Data) && Boolean(gtdt_parameters.GetField) ) {
							gtdt_parameters.Data = GetField( gtdt_parameters.GetField );
							if (Boolean(gtdt_parameters.GetField.Line)) { objRtF.Line = gtdt_parameters.GetField.Line; };
						}
						objRtF.Data = gtdt_parameters.Data;
						if (Boolean(gtdt_parameters.Line)) { objRtF.Line = gtdt_parameters.Line; };
						gtdt_parameters.Function(objRtF);
						return true;
					} else {
						if (gtdt_parameters.Function as Function) {
							Debug.Send("GetField ou Data é necessário", "Error", { p:"database", c:"UseData", m:"GetData" } );
						} else {
							Debug.Send("Type é necessário", "Error", { p:"database", c:"UseData", m:"GetData" } );
						}
						return false;
					}
				}
				return true;
			}
			function retornadata():void {
				if (Boolean(ObjData.CnStatus)) {
					completeData();
					clearInterval(geting);
				}
			}
			clearInterval(geting);
			var geting:uint = setInterval(retornadata, 75);
			return true;
		}
		
		/**
		 * Realiza a paginação dos dados obtidos pela classe Connect
		 * 
		 * @param	pgdt_parameters		Object	  					Objeto com os parâmetros do método PaginateData
		 * 								<p> <code>.AddChildIn		:Stage/Object</code>		— Stage ou algum objeto para adicionar os objetos gerados na paginação.</p>
		 * 								<p> <code>.Animation		:AnimateDataItems</code>	— Objeto com uma instância da classe AnimateDataItems.</p>
		 * 								<p> <code>.StartPage		:Number</code>				— Página inicial (defaults 1).</p>
		 * 								<p> <code>.ItemsByPage		:Number</code>				— Itens por página (defaults 1).</p>
		 * 								<p> <code>.ItemsByRC		:Number</code>				— Itens por linha/coluna (defaults 1).</p>
		 * 								<p> <code>.OnEndPage		:String</code>				— Ação a ser executada ao chegar na última página ['Continue' or 'Stop'] (defaults 'Continue')</p>
		 * 								<p> <code>.ObjModel			:Class</code>				— Classe que servirá de modelo para gerar os itens da paginação</p>
		 * 								<p> <code>.NextBtObj		:Object/String</code>		— Objeto que será o botão avançar</p>
		 * 								<p> <code>.PrevBtObj		:Object/String</code>		— Objeto que será o botão voltar</p>
		 * 								<p> <code>.Disposal			:String</code>				— Distribuição dos itens, vertical ou horizontal ['V' or 'H'] (defaults 'H')</p>
		 * 								<p> <code>.StartX			:Number</code>				— Posição X inicial dos itens (defaults 0)</p>
		 * 								<p> <code>.StartY			:Number</code>				— Posição Y inicial dos itens (defaults 0)</p>
		 * 								<p> <code>.ObjWidth			:Number</code>				— Largura dos itens para calcular a distância (defaults auto)</p>
		 * 								<p> <code>.ObjHeight		:Number</code>				— Altura dos itens para calcular a distância (defaults auto)</p>
		 * 								<p> <code>.Dist				:Number</code>				— Distância X e Y entre os itens (defaults 0)</p>
		 * 								<p> <code>.DistX			:Number</code>				— Distância X entre os itens (defaults 0)</p>
		 * 								<p> <code>.DistY			:Number</code>				— Distância Y entre os itens (defaults 0)</p>
		 * 								<p> <code>.StatusText		:TextField/String</code>	— TextField para mostrar o status da obtenção dos dados na classe Connect</p>
		 * 								<p> <code>.TextOnComplete	:String</code>				— Texto a ser exibido no texto de status ao completar (defaults 'Complete!')</p>
		 * 								<p> <code>.TextOnLoading	:String</code>				— Texto a ser exibido no texto de status enquanto estiver carregando (defaults 'Loading...')</p>
		 * 								<p> <code>.TotalItemsText	:TextField/String</code>	— TextField para mostrar o total de itens geradas</p>
		 * 								<p> <code>.TotalPagesText	:TextField/String</code>	— TextField para mostrar o total de páginas geradas</p>
		 * 								<p> <code>.AtualPageText	:TextField/String</code>	— TextField para mostrar a página atual</p>
		 * 								<p> <code>.AutoAdjustIn		:Object</code>				— Objeto de referência para o auto-ajuste da disposição dos itens (substitui .ItemsByPage e .ItemsByRC)</p>
		 * 								<p> <code>.AutoMargin		:Number</code>				— Margem entre o objeto de referência e os itens (se .AutoAdjustIn)</p>
		 * 								<p> <code>.AutoMarginH		:Number</code>				— Margem horizontal entre o objeto de referência e os itens (se .AutoAdjustIn)</p>
		 * 								<p> <code>.AutoMarginV		:Number</code>				— Margem vertical entre o objeto de referência e os itens (se .AutoAdjustIn)</p>
		 * 								<p> <code>.AutoDist			:Boolean</code>				— Distância automática entre os itens (se .AutoAdjustIn)</p>
		 * 								<p> <code>.minDist			:Number</code>				— Distância mínima (X e Y) entre os itens (se .AutoDist)</p>
		 * 								<p> <code>.minDistX			:Number</code>				— Distância mínima (X) entre os itens (se .AutoDist)</p>
		 * 								<p> <code>.minDistY			:Number</code>				— Distância mínima (Y) entre os itens (se .AutoDist)</p>
		 * 								<p> <code>.EqualDists		:Boolean</code>				— Igualar a distância entre os itens (se .AutoDist)</p>
		 * 
		 * 								<p></p>
		 * 
		 * @param	objs_data			Array com o objetos e ações para os dados serem inseridos e eventos serem criados
		 * 								<p> <code>.Type				:String</code>				— Tipo de objeto a ser trabalhado ['Text', 'Load' or 'Button']</p>
		 * 								<p> <code>.Target			:Object/String</code>		— Object target to insert data or event</p>
		 * 								<p> <code>.ProgressText		:TextField/String</code>	— TextField target to show progress text case .Type is 'Load'</p>
		 * 								<p> <code>.Data				:String</code>				— Data for insert in Object or create an event (replaces .Columns, .OnEmpty, .IsEmpty and .Use)</p>
		 * 								<p> <code>.Over				:Function</code>			— Case 'Button', Function for the event 'MouseEvent.MOUSE_OVER'</p>
		 * 								<p> <code>.Out				:Function</code>			— Case 'Button', Function for the event 'MouseEvent.MOUSE_OUT'</p>
		 * 								<p> <code>.Click			:Function</code>			— Case 'Button', Function for the event 'MouseEvent.CLICK'</p>
		 * 								<p> <code>.Function			:Function</code>			— Function to be called when data loaded (replaces .Target and .Type)</p>
		 * 								<p> <code>.Columns			:String/Array</code>		— Columns of the table to get data</p>
		 * 								<p> <code>.OnEmpty			:String</code>				— Value to empty fields</p>
		 * 								<p> <code>.IsEmpty			:Array</code>				— Values considered empty</p>
		 * 								<p> <code>.Use				:String</code>				— Model of text to be returned</p>
		 * 
		 * @see asmonster.effects.AnimateDataItems
		 * @see Connect
		 * 
		 * @example 
<listing version="3.0">
var Data:Connect = new Connect();

var List:UseData = new UseData(Data);

var FuncClick:Function = function(objRt):void {
	trace(objRt.Data);
}

List.PaginateData( {
	Animation:new AnimateDataItems(),
	AddChildIn: TestCnt,
	ObjModel: NewShape2,
	StartX:40,
	StartY:40,
	AutoMarginH:20,
	AutoMarginV:34,
	ItemsByPage:12,
	ItemsByRC:4,
	Dist:10,
	TextOnLoading:"Loading...",
	TextOnComplete:"ok!",
	StatusText:"StatusText2",
	TotalItemsText:"TotalItemsText2",
	TotalPagesText:"TotalPagesText2",
	AtualPageText:"AtualPageText2",
	NextBtObj:"BtGo2",
	PrevBtObj:"BtBk2"
}, [
						{ Target: "areaBt", Type: "Button", Click:FuncClick,
									Columns: "image", Use:"./sampleimages/b/&lt;data&gt;.jpg" },
					  
						{ Target: "LoaderMc.LoadCt", Type:"Load", Columns:"image",
									ProgressText:"pct", Use:"./sampleimages/s/&lt;data&gt;.jpg" }  
   ]
);
</listing>
		 * 
		 * 
		 */
		public function PaginateData(pgdt_parameters:Object = null, objs_data:Array = null):Boolean
		{
			ObjsData = objs_data;
			function check_pgdt_parameters():Boolean {
				if (!Boolean(pgdt_parameters)) {
					Debug.Send("Object with parameters are required for Paginate Data", "Error", { p:"database", c:"UseData", m:"PaginateData" } );
					return false;
				}
				if (!Boolean(pgdt_parameters.ObjModel)) {
					Debug.Send("ObjModel is required for Paginate Data", "Error", { p:"database", c:"UseData", m:"PaginateData" } );
					return false;
				} else {
					if (!Boolean(pgdt_parameters.ObjModel as Class)) {
						Debug.Send("ObjModel must be a Class", "Error", { p:"database", c:"UseData", m:"PaginateData" } );
						return false;
					} else {
						ObjModel = pgdt_parameters.ObjModel;
					}
				};
				if (Boolean(pgdt_parameters.NextBtObj)) { NextBtObj = pgdt_parameters.NextBtObj; };
				if (Boolean(pgdt_parameters.PrevBtObj)) { PrevBtObj = pgdt_parameters.PrevBtObj; };
				if (!Boolean(pgdt_parameters.AddChildIn)) {
					Debug.Send("AddChildIn is required for Paginate Data", "Error", { p:"database", c:"UseData", m:"PaginateData" } );
					return false;
				} else { AddChildIn = pgdt_parameters.AddChildIn; };
				if (Boolean(pgdt_parameters.StartPage)) {
					if (isNaN(pgdt_parameters.StartPage)) {
						Debug.Send("StartPage must be a numeric value, the default value (1) has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { AtualPage = pgdt_parameters.StartPage; };
				}
				if (Boolean(pgdt_parameters.ItemsByPage)) {
					if (isNaN(pgdt_parameters.ItemsByPage)) {
						Debug.Send("ItemsByPage must be a numeric value, the default value (1) has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { ItemsByPage = pgdt_parameters.ItemsByPage; };
				}
				if (Boolean(pgdt_parameters.Disposal)) {
					if (pgdt_parameters.Disposal != "H" && pgdt_parameters.Disposal != "V") {
						Debug.Send("Disposal must be 'H' or 'V', the default value ('H') has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { Disposal = pgdt_parameters.Disposal; };
				}
				if (Boolean(pgdt_parameters.OnEndPage)) {
					if (pgdt_parameters.OnEndPage != "Stop" && pgdt_parameters.OnEndPage != "Continue") {
						Debug.Send("OnEndPage must be 'Continue' or 'Stop', the default value ('Continue') has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { OnEndPage = pgdt_parameters.OnEndPage; };
				}
				if (Boolean(pgdt_parameters.ItemsByRC)) {
					if (isNaN(pgdt_parameters.ItemsByRC)) {
						Debug.Send("ItemsByRC must be a numeric value, the default value (1) has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { ItemsByRC = pgdt_parameters.ItemsByRC; };
				}
				if (Boolean(pgdt_parameters.AutoDist)) {
					AutoDist = pgdt_parameters.AutoDist;
				}
				if (Boolean(pgdt_parameters.EqualDists)) {
					EqualDists = pgdt_parameters.EqualDists;
				}
				if (!isNaN(pgdt_parameters.StartX)) {
					StartX = pgdt_parameters.StartX;
				}
				if (!isNaN(pgdt_parameters.StartY)) {
					StartY = pgdt_parameters.StartY;
				}
				if (Boolean(pgdt_parameters.AutoMarginH) && !isNaN(pgdt_parameters.AutoMarginH)) {
					StartX = StartX + pgdt_parameters.AutoMarginH;
				}
				if (Boolean(pgdt_parameters.AutoMarginV) && !isNaN(pgdt_parameters.AutoMarginV)) {
					StartY = StartY + pgdt_parameters.AutoMarginV;
				}
				if (Boolean(pgdt_parameters.AutoMargin) && !isNaN(pgdt_parameters.AutoMargin)) {
					if (Boolean(pgdt_parameters.AutoMarginH) && !isNaN(pgdt_parameters.AutoMarginH)) {
						StartX = StartX - pgdt_parameters.AutoMarginH;
					}
					StartX = StartX + pgdt_parameters.AutoMargin;
					if (Boolean(pgdt_parameters.AutoMarginV) && !isNaN(pgdt_parameters.AutoMarginV)) {
						StartY = StartY - pgdt_parameters.AutoMarginV;
					}
					StartY = StartY + pgdt_parameters.AutoMargin;
				}
				if (Boolean(pgdt_parameters.ObjWidth)) {
					if (isNaN(pgdt_parameters.ObjWidth)) {
						var ckW:Object = new ObjModel(); ObjWidth = ckW.width;
						Debug.Send("ObjWidth must be a numeric value, the default value (auto) has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { ObjWidth = pgdt_parameters.ObjWidth; };
				} else {
					var ckWb:Object = new ObjModel(); ObjWidth = ckWb.width;
				}
				if (Boolean(pgdt_parameters.ObjHeight)) {
					if (isNaN(pgdt_parameters.ObjHeight)) {
						var ckH:Object = new ObjModel(); ObjHeight = ckH.height;
						Debug.Send("ObjHeight must be a numeric value, the default value (auto) has been defined", "Alert", { p:"database", c:"UseData", m:"PaginateData" } );
					} else { ObjHeight = pgdt_parameters.ObjHeight; };
				} else {
					var ckHb:Object = new ObjModel(); ObjHeight = ckHb.height;
				}
				if (!isNaN(pgdt_parameters.Dist)) {
					DistX = pgdt_parameters.Dist;
					DistY = pgdt_parameters.Dist;
				}
				if (!isNaN(pgdt_parameters.DistX)) {
					DistX = pgdt_parameters.DistX;
				}
				if (!isNaN(pgdt_parameters.DistY)) {
					DistY = pgdt_parameters.DistY;
				}
				if (Boolean(pgdt_parameters.Animation)) {
					Animation = pgdt_parameters.Animation;
				}
				if (Boolean(pgdt_parameters.TextOnComplete) ) {
					TextOnComplete = pgdt_parameters.TextOnComplete;
				}
				if (Boolean(pgdt_parameters.TextOnLoading) ) {
					TextOnLoading = pgdt_parameters.TextOnLoading;
				}
				if (Boolean(pgdt_parameters.StatusText) && Boolean(Generic.GetTarget(pgdt_parameters.StatusText, pgdt_parameters.AddChildIn))) {
					StatusText = Generic.GetTarget(pgdt_parameters.StatusText, AddChildIn);
					StatusText.text = "" + TextOnLoading;
				}
				if (
					Boolean(pgdt_parameters.TotalItemsText) && Boolean(Generic.GetTarget(pgdt_parameters.TotalItemsText, pgdt_parameters.AddChildIn))
					||
					Boolean(pgdt_parameters.TotalItemsText) && Boolean(Generic.GetTarget(pgdt_parameters.TotalItemsText))					
				) {
					TotalItemsText = Generic.GetTarget(pgdt_parameters.TotalItemsText, AddChildIn);
					if (!Boolean(TotalItemsText)) {
						TotalItemsText = Generic.GetTarget(pgdt_parameters.TotalItemsText);
					}
				}
				if (
					Boolean(pgdt_parameters.TotalPagesText) && Boolean(Generic.GetTarget(pgdt_parameters.TotalPagesText, pgdt_parameters.AddChildIn))
					||
					Boolean(pgdt_parameters.TotalPagesText) && Boolean(Generic.GetTarget(pgdt_parameters.TotalPagesText))
					) {
					TotalPagesText = Generic.GetTarget(pgdt_parameters.TotalPagesText, AddChildIn);
					if (!Boolean(TotalPagesText)) {
						TotalPagesText = Generic.GetTarget(pgdt_parameters.TotalPagesText);
					}
				}
				if (
					Boolean(pgdt_parameters.AtualPageText) && Boolean(Generic.GetTarget(pgdt_parameters.AtualPageText, pgdt_parameters.AddChildIn))
					||
					Boolean(pgdt_parameters.AtualPageText) && Boolean(Generic.GetTarget(pgdt_parameters.AtualPageText))
					) {
					AtualPageText = Generic.GetTarget(pgdt_parameters.AtualPageText, AddChildIn);
					if (!Boolean(AtualPageText)) {
						AtualPageText = Generic.GetTarget(pgdt_parameters.AtualPageText);
					}
				}
				if (Boolean(pgdt_parameters.AutoAdjustIn)) {
					AutoAdjustIn = pgdt_parameters.AutoAdjustIn;
					var lWorkW:Number; var lWorkH:Number;
					var lItemsByPage:Number; var lItemsByRC:Number;
					var nItemsByPage:Number; var nItemsByRC:Number;
					function AutoAdjust():void {
						if (Boolean(ObjData.CnStatus)) {
							if (Boolean(pgdt_parameters.minDist && !isNaN(pgdt_parameters.minDist))) {
								minDistX = pgdt_parameters.minDist;
								minDistY = pgdt_parameters.minDist;
							}
							if (Boolean(pgdt_parameters.minDistX && !isNaN(pgdt_parameters.minDistX))) {
								minDistX = pgdt_parameters.minDistX;
							}
							if (Boolean(pgdt_parameters.minDistY && !isNaN(pgdt_parameters.minDistY))) {
								minDistY = pgdt_parameters.minDistY;
							}
							var wDistX:Number; var wDistY:Number;
							if (Boolean(AutoDist)) {
								wDistX = minDistX;
								wDistY = minDistY;
							} else {
								wDistX = DistX;
								wDistY = DistY;
							}
							var WorkW:Number; var WorkH:Number;
							var ItemW:Number = ObjWidth + wDistX;
							var ItemH:Number = ObjHeight + wDistY;
							if (AutoAdjustIn as Stage) {
								WorkW = AutoAdjustIn.stageWidth;
								WorkH = AutoAdjustIn.stageHeight;
							} else {
								WorkW = AutoAdjustIn.width;
								WorkH = AutoAdjustIn.height;
							}
							if(!Boolean(pgdt_parameters.AutoMargin)) {
								if (Boolean(pgdt_parameters.AutoMarginH) && !isNaN(pgdt_parameters.AutoMarginH)) {
									WorkW = WorkW - (pgdt_parameters.AutoMarginH * 2);
								}
								if (Boolean(pgdt_parameters.AutoMarginV) && !isNaN(pgdt_parameters.AutoMarginV)) {
									WorkH = WorkH - (pgdt_parameters.AutoMarginV * 2);
								}
							}
							if (Boolean(pgdt_parameters.AutoMargin) && !isNaN(pgdt_parameters.AutoMargin)) {
								WorkW = WorkW - (pgdt_parameters.AutoMargin * 2);
								WorkH = WorkH - (pgdt_parameters.AutoMargin * 2);
							}
							if (WorkW < ItemW) { WorkW = ItemW; };
							if (WorkH < ItemH) { WorkH = ItemH; };
							WorkW = WorkW + wDistX; WorkH = WorkH + wDistY;
							nItemsByPage = int(WorkW / ItemW) * int(WorkH / ItemH);
							if (Disposal == "H") {
								nItemsByRC = int(WorkW / ItemW);
							} else {
								nItemsByRC = int(WorkH / ItemH);
							}
							var nDistX:Number = DistX;
							var nDistY:Number = DistY;
							if (Boolean(AutoDist)) {
							var linItems:Number; var colItems:Number;
							if (Disposal == "H") {
									linItems = nItemsByRC;
									colItems = nItemsByPage / nItemsByRC;
								} else {
									linItems = nItemsByPage / nItemsByRC;
									colItems = nItemsByRC;
								}
								nDistX = ((WorkW - (ItemW * linItems)) / (linItems - 1)) + minDistX;
								nDistY = ((WorkH - (ItemH * colItems)) / (colItems - 1)) + minDistY;
								if (Boolean(EqualDists)) {
									if (nDistX > nDistY) {
										nDistX = nDistY;
									} else if (nDistY > nDistX) {
										nDistY = nDistX;
									}
								}
							}
							if (nItemsByPage != lItemsByPage || nItemsByRC != lItemsByRC || int(nDistX) != int(DistX) || int(nDistY) != int(DistY)) {
								DistX = nDistX; DistY = nDistY;
								var FrsI:Number = (((AtualPage * ItemsByPage) - ItemsByPage) + 1);
								ItemsByRC = nItemsByRC; lItemsByRC = nItemsByRC;
								ItemsByPage = nItemsByPage; lItemsByPage = nItemsByPage;
								if (ObjData.CnTotal % ItemsByPage == 0) {
									TotalPages = int(ObjData.CnTotal / ItemsByPage);
								} else {
									TotalPages = int(ObjData.CnTotal / ItemsByPage) + 1;
								}
								for (var i:int = 1; i <= TotalPages; i++) 
								{
									var mn:Number = (i * ItemsByPage) - ItemsByPage;
									var mx:Number = i * ItemsByPage;
									if (FrsI >= mn && FrsI <= mx) {
										AtualPage = i;
										GoToPage(AtualPage, true);
										break;
									}
								}
								if ( Boolean(AtualPageText) ) {
									AtualPageText.text = ""+AtualPage;
								}
								if ( Boolean(TotalPagesText) ) {
									TotalPagesText.text = TotalPages;
								}
							}
						}
					}
					AutoAdjust();
					setInterval(AutoAdjust, 75);
				}
				return true;
			} if (check_pgdt_parameters() == false) { return false; };
			function completeData():void {
				if (ObjData.CnTotal % ItemsByPage == 0) {
					TotalPages = int(ObjData.CnTotal / ItemsByPage);
				} else {
					TotalPages = int(ObjData.CnTotal / ItemsByPage) + 1;
				}
				InsertDataItems();
				function PaginateRoutines():void {
					if (Boolean(NextBtObj)) {
						function CLICKN(event:MouseEvent):void {
							if(AtualPage < TotalPages) {
								AtualPage = AtualPage + 1;
								GoToPage(AtualPage, true);
							} else {
								if (OnEndPage == "Continue") {
									AtualPage = 1;
									GoToPage(AtualPage, true);
								}
							}
						}
						if( Boolean(Generic.GetTarget(NextBtObj, AddChildIn)) ) {
							Generic.GetTarget(NextBtObj, AddChildIn).addEventListener(MouseEvent.CLICK, CLICKN);
						} else if( Boolean(Generic.GetTarget(NextBtObj)) ) {
							Generic.GetTarget(NextBtObj).addEventListener(MouseEvent.CLICK, CLICKN);
						}
					}
					if (Boolean(PrevBtObj)) {
						function CLICKP(event:MouseEvent):void {
							if(AtualPage > 1) {
								AtualPage = AtualPage - 1;
								GoToPage(AtualPage, true);
							} else {
								if (OnEndPage == "Continue") {
									AtualPage = TotalPages;
									GoToPage(AtualPage, true);
								}
							}
						}
						if( Boolean(Generic.GetTarget(PrevBtObj, AddChildIn)) ) {
							Generic.GetTarget(PrevBtObj, AddChildIn).addEventListener(MouseEvent.CLICK, CLICKP);
						} else if ( Boolean(Generic.GetTarget(PrevBtObj)) ) {
							Generic.GetTarget(PrevBtObj).addEventListener(MouseEvent.CLICK, CLICKP);
						}
					}
				} PaginateRoutines();
				
				if ( Boolean(StatusText) ) { StatusText.text = "" + TextOnComplete; };
				if ( Boolean(TotalItemsText) ) { TotalItemsText.text = "" + ObjData.CnTotal; };
				if ( Boolean(TotalPagesText) ) { TotalPagesText.text = "" + TotalPages; };
				if ( Boolean(AtualPageText) ) { AtualPageText.text = "" + AtualPage; };
				Debug.Send("Paginate Data was successfully completed", "Result", { p:"database", c:"UseData", m:"PaginateData" } );
			}
			//Check Data
			function retornadata():void {
				if (Boolean(ObjData.CnStatus)) {
					completeData();
					clearInterval(geting);
				}
			}
			clearInterval(geting);
			var geting:uint = setInterval(retornadata, 75);
			Debug.Send("Loading Data...", "Info", { p:"database", c:"UseData", m:"PaginateData" } );
			return true;
		}
		
		/**
		 * Change atual page
		 * 
		 * @param	page		Number of the new page
		 * @param	everChange	<b>Ever</b> go to page
		 *
		 */
		public function GoToPage(page:Number, everChange:Boolean = false):void
		{
			if(Boolean(page)) {
				if(Boolean(AtualPage == page && everChange) || Boolean(AtualPage != page)) {
					AtualPage = page;
					if (AtualPage > TotalPages) {
						AtualPage = TotalPages;
					}
					if (AtualPage < 1) {
						AtualPage = 1;
					}
					if (Boolean(AtualPageText)) {
						AtualPageText.text = ""+AtualPage;
					}
					if (Boolean(StatusText)) {
						if (Boolean(ObjData.CnStatus)) {
							StatusText.text = "" + TextOnComplete;
						} else {
							StatusText.text = "" + TextOnLoading;
						}
					}
					InsertDataItems();
				}
			}
		}
		
		/**
		 * UnLoad Pagination
		 * 
		 * @param	totalClear	Clear the texts in objects (StatusText, AtualPageText, TotalPagesText...)
		 * 
		 */
		public function PaginateUnLoad(totalClear:Boolean = true):void
		{
			function RemoveAll():void {
				if (Boolean(AddChildIn.getChildByName("ObjModelItem"))) {
					while(Boolean(AddChildIn.getChildByName("ObjModelItem"))) {
						AddChildIn.removeChild(AddChildIn.getChildByName("ObjModelItem"));
					}
				}
			}
			if (Boolean(Animation)) {
				Animation.AnimateHide(Items, Positions);
				clearTimeout(RemoveAllT);
				var RemoveAllT:uint = setTimeout(RemoveAll, (Animation.TimeForFill+0.1) * 1000);
			} else {
				RemoveAll();
			}
			if (Boolean(totalClear)) {
				if (Boolean(StatusText)) { StatusText.text = ""; };
				if (Boolean(TotalItemsText)) { TotalItemsText.text = ""; };
				if (Boolean(TotalPagesText)) { TotalPagesText.text = ""; };
				if (Boolean(AtualPageText)) { AtualPageText.text = ""; };
			}
		}
		
		/**
		 * Places the items generated by the paging
		 */
		private function PlaceItems():void {
			var NewX:Number = StartX; var NewY:Number = StartY;
			for (var y:int = 0; y < Items.length; y ++) {
				if (y > 0) {
					if(Disposal == "H") {
						if (y % ItemsByRC == 0) {
							NewX = StartX; NewY = NewY + ObjHeight + DistY;
						} else { NewX = NewX + ObjWidth + DistX; };
					} else {
						if (y % ItemsByRC == 0) {
							NewY = StartY; NewX = NewX + ObjWidth + DistX;
						} else { NewY = NewY + ObjHeight + DistY; };
					}
				}
				Items[y].x = NewX; Items[y].y = NewY;
				Positions[y] = { x: NewX, y: NewY, w:ObjWidth, h:ObjHeight };
				AddChildIn.addChild(Items[y]);
				Items[y].visible = false;
			}
		}
		
		/**
		 * Generates the items of the pagination
		 */
		private function GenerateItems():void {
			Items = new Array();
			for (var x:int = 0; x < ItemsByPage; x ++) {
				if (!(((AtualPage * ItemsByPage) - ItemsByPage) + (x + 1) > ObjData.CnTotal)) {
					Items[x] = new ObjModel();
					Items[x].name = "ObjModelItem";
				}
			}
			if (Boolean(Animation)) {
				Animation.ClearForAnimation(Items);
			}
		}
		
		/**
		 * Insert data items generated by the paging
		 */
		private function InsertDataItems():void {
			function Fill():void {
				for (var i:Number = 0; i < arrListenersBt.length; i++) {
					if(arrListenersBt[i].obj.hasEventListener(arrListenersBt[i].type)) {
						arrListenersBt[i].obj.removeEventListener(arrListenersBt[i].type, arrListenersBt[i].listener);
					}
				}
				arrListenersBt = new Array();
				var nData:Object;
				var iNc:Number = (AtualPage * ItemsByPage) - (ItemsByPage-1);
				for (var x:int = 0; x < ItemsByPage; x ++) {
					if (Boolean(Items[x])) {
						if (iNc <= ObjData.CnTotal) {
							Items[x].visible = true;
							if (Boolean(ObjsData)) {
								for (var y:int = 0; y < ObjsData.length; y ++) {
									if (!Boolean(ObjsData[y].Target) && !Boolean(ObjsData[y].Function as Function)) {
										Debug.Send("The Object must have a Target, the Object has been ignored", "Error", { p:"database", c:"UseData", m:"InsertDataItems" } );
									} else {
										if (!Boolean(ObjsData[y].Type == "Text" || ObjsData[y].Type == "Load" || ObjsData[y].Type == "Button" || ObjsData[y].Function as Function )) {
											Debug.Send("Type of Object must be 'Text', 'Load' or 'Button', the Object has been ignored", "Error", { p:"database", c:"UseData", m:"InsertDataItems" } );
										} else {
											if(!Boolean(ObjsData[y].Data)) {
												if (!Boolean(ObjsData[y].Columns) && Boolean(ObjsData[y].Type == "Text" || ObjsData[y].Type == "Load")) {
													Debug.Send("The Object must have a Columns to get data or a Data value, the Object has been ignored", "Error", { p:"database", c:"UseData", m:"InsertDataItems" } );
												} else if (!Boolean(ObjsData[y].Columns) && Boolean(ObjsData[y].Type == "Button" || ObjsData[y].Function as Function)) {
													nData = "";
												} else {
													nData = GetField( { Line:iNc, IsEmpty:ObjsData[y].IsEmpty, OnEmpty:ObjsData[y].OnEmpty, Columns:ObjsData[y].Columns, Use:ObjsData[y].Use, Treat:ObjsData[y].Treat } );
												}
											} else {
												nData = ObjsData[y].Data;
											}
											if (Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Click as Function) || Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Over as Function) || Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Out as Function) || Boolean(ObjsData[y].Type != "Button")) {
												if (Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Click) && Boolean(ObjsData[y].Over) || Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Click) && Boolean(ObjsData[y].Out) || Boolean(ObjsData[y].Type == "Button") && Boolean(ObjsData[y].Over) && Boolean(ObjsData[y].Out)) {
													Debug.Send("The Object must have only 'Click', 'Over' or 'Out', is not allowed more than one event per Object, the Object has been ignored", "Error", { p:"database", c:"UseData", m:"InsertDataItems" } );
												} else {
													GetData( {
														Target: Generic.GetTarget(ObjsData[y].Target, Items[x]),
														Data: nData,
														Type: ObjsData[y].Type,
														ProgressText: Generic.GetTarget(ObjsData[y].ProgressText, Items[x]),
														Over: ObjsData[y].Over,
														Out: ObjsData[y].Out,
														Click: ObjsData[y].Click,
														Line:iNc,
														Function:ObjsData[y].Function,
														Treat:ObjsData[y].Treat
													} );
												}
											} else {
												Debug.Send("The Object must have a Function in 'Click', 'Over' or 'Out' to create a Button, the Object has been ignored", "Error", { p:"database", c:"UseData", m:"InsertDataItems" } );
											}
										}
									}
								}
							}
						} else {
							Items[x].visible = false;
						}
					}
					iNc++;
				}
			}
			if (Boolean(Animation)) {
				PaginateUnLoad(false);
				function NewItem():void {
					GenerateItems();
					PlaceItems();
					Animation.AnimateShow(Items, Positions);
					Fill();
				}
				clearTimeout(StNewItem);
				var StNewItem:uint = setTimeout(NewItem, (Animation.TimeForFill+0.1) * 1000);
			} else {
				GenerateItems();
				PaginateUnLoad(false);
				PlaceItems();
				Fill();
			}
		}		
		
		/**
		 * Returns a specific field from the database
		 * 
		 * @param	gtfd_parameters		Object			Object with the GetField parameters
		 * @param	.Line				Number			Number of row in the database to get data
		 * @param	.Columns			String/Array	Columns of the table to get data
		 * @param	.OnEmpty			String			Value to empty fields
		 * @param	.IsEmpty			Array			Values considered empty
		 * @param	.Use				String			Model of text to be returned
		 * @param	.Treat				Function		Function to treat the database return
		 */
		private function GetField(gtfd_parameters:Object = null):String
		{
			//Check Parameters
			function check_gtfd_parameters():Boolean {
				if (!Boolean(gtfd_parameters)) {
					Debug.Send("Object with parameters are required to get data", "Error", { p:"database", c:"UseData", m:"GetField" } );
					return false;
				}
				if (!Boolean(gtfd_parameters.Line)) {
					Debug.Send("Line is required to get data", "Error", { p:"database", c:"UseData", m:"GetField" } );
					return false;
				}
				if (isNaN(gtfd_parameters.Line)) {
					Debug.Send("Line must be a numeric value", "Error", { p:"database", c:"UseData", m:"GetField" } );
					return false;
				}
				if (!Boolean(gtfd_parameters.Columns)) {
					Debug.Send("Columns are required to get data", "Error", { p:"database", c:"UseData", m:"GetField" } );
					return false;
				}
				return true;
			}
			if (check_gtfd_parameters() != false) {
				if (Boolean(ObjData.CnStatus)) {
					var dadosRt:String = ""; var txtRt:String = "";
					var EndValue:String; var tpValue:String; var expR:Object;
					function treatReturn(Str:String):String {
						if (Boolean(Str)) {
							Str = "" + Str;
						}
						if ( Boolean(gtfd_parameters.OnEmpty) ) {
							if( Boolean(Str) ) {
								if ( Boolean(gtfd_parameters.IsEmpty) ) {
									if(gtfd_parameters.IsEmpty as Array) {
										var g:Number = 0;
										for (var emp:int = 0; emp < gtfd_parameters.IsEmpty.length; emp ++) {
											if(Str == gtfd_parameters.IsEmpty[emp]) {
												g++;
											}
										}
										if (g > 0) {
											Str = gtfd_parameters.OnEmpty;
										}
									} else {
										Debug.Send("IsEmpty must be an Array, IsEmpty has been ignored", "Error", { p:"database", c:"UseData", m:"GetField" } );
									}
								}
							} else {
								Str = gtfd_parameters.OnEmpty;
							}
						}
						return "" + Str;
					}
					if (gtfd_parameters.Columns is Array && gtfd_parameters.Columns.length > 1) {
						if (!Boolean(gtfd_parameters.Use)) {
							for (var x:int = 0; x < gtfd_parameters.Columns.length; x ++) {
								EndValue = treatReturn(ObjData.CnData[ gtfd_parameters.Columns[x] + "[" + gtfd_parameters.Line + "]" ]);
								dadosRt = dadosRt + EndValue;
							}
						} else {
							txtRt = gtfd_parameters.Use;
							expR = "data";
							txtRt = txtRt.replace(new RegExp("<" + expR + ">", "g"), SHA256.hash("<" + expR + ">"));
							for (var a:int = 0; a < gtfd_parameters.Columns.length; a ++) {
								expR = a+1;
								txtRt = txtRt.replace(new RegExp("<" + expR + ">", "g"), SHA256.hash("<" + expR + ">"));
							}
							for (var b:int = 0; b < gtfd_parameters.Columns.length; b ++) {
								EndValue = treatReturn(ObjData.CnData[ gtfd_parameters.Columns[b] + "[" + gtfd_parameters.Line + "]" ]);
								dadosRt = dadosRt + EndValue;
							}
							expR = "data"; txtRt = txtRt.replace(new RegExp(SHA256.hash("<" + expR + ">"), "g"), dadosRt);
							for (var c:int = 0; c < gtfd_parameters.Columns.length; c ++) {
								EndValue = treatReturn(ObjData.CnData[ gtfd_parameters.Columns[c] + "[" + gtfd_parameters.Line + "]" ]);
								tpValue = EndValue;
								expR = c+1;
								txtRt = txtRt.replace(new RegExp(SHA256.hash("<" + expR + ">"), "g"), tpValue);
							}
							dadosRt = txtRt;
						}
						if (Boolean(gtfd_parameters.Treat as Function)) {
							return gtfd_parameters.Treat( Generic.TreatDataBaseReturn(dadosRt) );
						} else {
							return Generic.TreatDataBaseReturn(dadosRt);
						}						
					} else {
						EndValue = treatReturn(ObjData.CnData[ gtfd_parameters.Columns + "[" + gtfd_parameters.Line + "]" ]);
						dadosRt = EndValue;
						if (!Boolean(gtfd_parameters.Use)) {
							if (Boolean(gtfd_parameters.Treat as Function)) {
								return gtfd_parameters.Treat( Generic.TreatDataBaseReturn(dadosRt) );
							} else {
								return Generic.TreatDataBaseReturn(dadosRt);
							}
						} else {
							txtRt = gtfd_parameters.Use;
							expR = 1; txtRt = txtRt.replace(new RegExp("<" + expR + ">", "g"), SHA256.hash("<" + expR + ">"));
							expR = "data"; txtRt = txtRt.replace(new RegExp("<" + expR + ">", "g"), SHA256.hash("<" + expR + ">"));
							expR = 1; txtRt = txtRt.replace(new RegExp(SHA256.hash("<" + expR + ">"), "g"), dadosRt);
							expR = "data"; txtRt = txtRt.replace(new RegExp(SHA256.hash("<" + expR + ">"), "g"), dadosRt);
							if (Boolean(gtfd_parameters.Treat as Function)) {
								return gtfd_parameters.Treat( Generic.TreatDataBaseReturn(txtRt) );
							} else {
								return Generic.TreatDataBaseReturn(txtRt);
							}
						}
					}
				} else {
					Debug.Send("Data are not yet loaded", "Error", { p:"database", c:"UseData", m:"GetField" } );
					return "Error";;
				}
			} else {
				return "Error";
			}
		}
		
		/**
		 * Controls the Loader object and her events
		 * 
		 * @param	txtObj		TextField		Text Object to inform the percentage loaded
		 * @param	loaderObj	Loader			Loader Object to control events
		 */
		private function loadProgFile(loaderObj:Loader, txtObj:TextField = null):void {
			if(txtObj as TextField) {
				txtObj.text = "0%";
				txtObj.visible = true;
			}
			function PROGRESS(event:ProgressEvent):void {
				var pc:Number = Math.round((event.bytesLoaded / event.bytesTotal) * 100);
				if(txtObj as TextField) {
					txtObj.text = pc + "%";
				}
				loaderObj.alpha = 0;
			};
			loaderObj.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, PROGRESS);
			function COMPLETE(event:Event):void {
				if(txtObj as TextField) {
					txtObj.visible = false;
				}
				TweenMax.killTweensOf(loaderObj);
				TweenMax.to(loaderObj, 0.6, { alpha:1 } );
			}
			loaderObj.contentLoaderInfo.addEventListener(Event.COMPLETE, COMPLETE);
		}
		
	}
}