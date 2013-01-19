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
	
    import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	
	import flash.events.Event;
	
	import com.adobe.crypto.SHA256;
	
	import com.asmonster.utils.Generic;
	
	import com.asmonster.config.Database;
	import com.asmonster.utils.Debug;
	
	/**
	 * Realiza requisições a banco de dados e arquivos XML.
	*/
	public class Connect
	{
		private static var ObjectVars:URLVariables = new URLVariables();
		private static var LoadFile:URLLoader = new URLLoader();
		private static var LoadDyFl:URLRequest;
		private var CnType:String = undefined;
		
		private var CnStatusP:Boolean = false;
		/**
		 * Status da requisição.
		 * @default false
		*/
		public function get CnStatus():Boolean { return CnStatusP; };
		/**  * @private  */ 
		public function set CnStatus(nv:Boolean):void { CnStatusP = nv; };
		
		private var CnTotalP:Number = 0;
		/**
		 * Total de itens (linhas) retornados.
		 * @default 0
		*/
		public function get CnTotal():Number { return CnTotalP; };
		/**  * @private  */ 
		public function set CnTotal(nv:Number):void { CnTotalP = nv; };
		
		private var CnDataP:Object = null;
		/**
		 * Objeto que armazena os dados retornados.
		 * @default null
		*/
		public function get CnData():Object { return CnDataP; };
		/**  * @private  */ 
		public function set CnData(nv:Object):void { CnDataP = nv; };
		
		/**
		 * Construtor
		 */
		public function Connect():void {
			Debug.Send("NewInstance", "Info", { p:"database", c:"Connect", m:"Connect" } );
		}
		
		/**
		 * "Fecha" uma conexão, na prática, descarrega os dados armazenados.
		 * 
		 * @param NoMsg		Envia uma mensagem ao Debug.
		 */
		public function UnLoad(NoMsg:Boolean = true):void
		{
			CnType = undefined; CnTotal = 0;
			CnData = null; CnStatus = false;
			if (Boolean(NoMsg)) {
				Debug.Send("Connection was successfully closed", "Info", { p:"database", c:"Connect", m:"UnLoad" } );
			}
		}
		
		/**
		 * Obtem informações sobre a conexão.
		 * 
		 * @param	Info	String	  	Informação a ser retornada. ['Status', 'Total' or 'Type']
		 */
		public function GetInfos(Info:String = null):String
		{
			if (Boolean(Info)) {
				if (Info == "Status") { return "" + CnStatus; };
				if (Info == "Total") { return "" + CnTotal; };
				if (Info == "Type") { return "" + CnType; };
				return undefined;
			} else {
				return undefined;
			}
		}
		
		/**
		 * Seleciona dados de um arquivo XML.
		 * 
		 * @param	xml_parameters		Objeto com os parâmetros do método NewXmlGet.
		 * 								<p> <code>.File			:String</code>		— Arquivo XML a ser carregado.</p>
		 * 								<p> <code>.Node			:String</code>		— Nó inicial de referência para obter os dados.</p>
		 * 								<p> <code>.SubNode		:String</code>		— Nó que contém os dados desejados.</p>
		 * 								<p> <code>.Conditions	:String</code>		— Condições para a seleção dos dados a serem retornados (equivalente ao WHERE de uma String SQL).</p>
		 * 								<p> <code>.Limit		:Number</code>		— Número máximo de itens (linhas) a serem retornados.</p>
		 * 
		 * @see UseData
		 * 
		 * @example
<listing version="3.0">
var Data:Connect = new Connect();
	
Data.NewXmlGet( {
	File:"asmonster/test/xml/Test1.xml",
	Node:"Table",
	SubNode:"Line",
	Conditions:"age > 25"
} );
</listing>
		 * 
		 */
		public function NewXmlGet(xml_parameters:Object = null):Boolean
		{
			if (!Boolean(xml_parameters.File)) {
				Debug.Send("File é necessário para carregar dados de um arquivo XML", "Error", { p:"database", c:"Connect", m:"NewXmlGet" } );
				return false;
			}
			if (!Boolean(xml_parameters.Node)) {
				Debug.Send("Node é necessário para carregar dados de um arquivo XML", "Error", { p:"database", c:"Connect", m:"NewXmlGet" } );
				return false;
			}
			if (!Boolean(xml_parameters.SubNode)) {
				Debug.Send("SubNode é necessário para carregar dados de um arquivo XML", "Error", { p:"database", c:"Connect", m:"NewXmlGet" } );
				return false;
			}
			UnLoad(false);
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest(xml_parameters.File));
			function LoadXML(e:Event):void {
				var xmlData:XML = new XML(e.target.data);
				var N:String = xml_parameters.Node;
				var Sn:String = xml_parameters.SubNode;
				var Count:XMLList = xmlData[N].children();
				var i:Number = 0;
				for each (var It:XML in Count) {
					i++;
				}
				var Columns:Array = new Array();
				CnTotal = i;
				CnData = new Array();
				
				function chkLine(Line:Number):Boolean {
					if (Boolean(xml_parameters.Conditions)) {
						var ListT:XMLList = xmlData[N][Sn][Line].children();
						
						var CkCnt:Number = 0;
						var CndAr:Array = Generic.GetConditions(xml_parameters.Conditions);
						var CondOpc:Array = new Array();
						
						for (var x:int = 0; x < CndAr.length; x ++) {
							var CntOpc:Number = 0;
							CondOpc[x] = false;
							for (var i:int = 0; i < CndAr[x].length; i ++) {
								for each (var ItemT:XML in ListT) {
									if (CndAr[x][i][0] == ItemT.name()) {
										if (CndAr[x][i][2] == "=") {
											if (CndAr[x][i][1] == ItemT) { CntOpc = CntOpc +1; };
										}
										if (CndAr[x][i][2] == "!=") {
											if (CndAr[x][i][1] != ItemT) { CntOpc = CntOpc +1; };
										}
										if (CndAr[x][i][2] == ">") {
											if (Number(ItemT) > Number(CndAr[x][i][1])) { CntOpc = CntOpc +1; };
										}
										if (CndAr[x][i][2] == "<") {
											if (Number(ItemT) < Number(CndAr[x][i][1])) { CntOpc = CntOpc +1; };
										}
									}
								}
							}
							if (CntOpc == CndAr[x].length) { CondOpc[x] = true; }
							else { CondOpc[x] = false; };
						}
						for (var j:int = 0; j < CondOpc.length; j ++) {
							if (Boolean(CondOpc[j])) {
								return true;
							}
						}
						return false;
					} else {
						return true;
					}
				}
				
				var lnCnt:Number = 0;
				for (var x:int = 0; x < i; x++) 
				{
					if (Boolean(chkLine(x))) {
						var cntn:Boolean = true;
						if (Boolean(xml_parameters.Limit as Number)) {
							if (lnCnt < xml_parameters.Limit) {
								cntn = true;
							} else {
								CnTotal = CnTotal - 1;
								cntn = false;
							}
						}
						if(Boolean(cntn)) {
							lnCnt = lnCnt + 1;
							var List:XMLList = xmlData[N][Sn][x].children();
							for each (var Item:XML in List) {
								var strAr:String = Item.name() + "[" + (lnCnt) + "]";
								CnData[strAr] = Item;
								var cn:Number = 0;
								for (var c:int = 0; c < Columns.length; c++) 
								{ if (Columns[c] == Item.name()) { cn++; }; };
								if (cn == 0) { Columns[Columns.length] = Item.name(); };
							}
						}
					} else {
						CnTotal = CnTotal - 1;
					}
				}

				var ClStr:String = "";
				for (var l:int = 0; l < Columns.length; l++) {
					ClStr = ClStr + Columns[l];
					if(l != (Columns.length-1)) {
						ClStr = ClStr + ",";
					}
				}
				CnData["columnsTable[1]"] = ClStr;
				CnStatus = true;
				Debug.Send("Dados carregados com sucesso., " + CnTotal + " linhas foram retornadas", "Result", { p:"database", c:"Connect", m:"NewXmlGet" } );
			}
			Debug.Send("NewInstance", "Info", { p:"database", c:"Connect", m:"NewXmlGet" } );
			Debug.Send("Carregando dados...", "Info", { p:"database", c:"Connect", m:"NewXmlGet" } );
			CnType = "XML";
			return true;
		}

		/**
		 * Seleciona dados de um banco de dados.
		 * 
		 * @param	sql_parameters		Objeto com os parâmetros do método NewSqlSelect.
		 * 								<p> <code>.Table		:String</code>		— Tabela a ser selecionada no banco de dados.</p>
		 * 								<p> <code>.Columns		:String</code>		— Colunas a serem selecionadas na tabela. (padrão '~~')</p>
		 * 								<p> <code>.Conditions	:String</code>		— Condições para a seleção dos dados a serem retornados (equivalente ao WHERE de uma String SQL).</p>
		 * 								<p> <code>.Order		:String</code>		— Ordem dos dados retornados.</p>
		 * 								<p> <code>.Limit		:Number</code>		— Número máximo de itens (linhas) a serem retornados.</p>
		 * 
		 * @see UseData
		 * 
		 * @example
<listing>
var Data:Connect = new Connect();
	
Data.NewSqlSelect( {
	Table: "pictures",
	Columns:"*",
	Conditions:"id > 1",
	Order:"id DESC",
	Limit:48
} );
</listing>
		 *
		 * 
		 */
		public function NewSqlSelect(sql_parameters:Object = null):Boolean
		{
			//Check Parameters
			if (!Boolean(sql_parameters)) {
				Debug.Send("Nenhum parâmetro recebido", "Error", { p:"database", c:"Connect", m:"NewSqlSelect" } );
				return false;
			}
			if (!Boolean(sql_parameters.Table)) {
				Debug.Send("Table é necessário para realizar uma consulta", "Error", { p:"database", c:"Connect", m:"NewSqlSelect" } );
				return false;
			}
			if (!Boolean(sql_parameters.Columns)) {
				sql_parameters.Columns = "*";
				Debug.Send("Columns é nulo, o valor padrão (*) foi definido", "Alert", { p:"database", c:"Connect", m:"NewSqlSelect" } );
			}
			if (Boolean(sql_parameters.Limit)) {
				if(isNaN(sql_parameters.Limit)) {
					sql_parameters.Limit = null;
					Debug.Send("Limit precisa ser um valor numérico, Limit foi ignorado", "Alert", { p:"database", c:"Connect", m:"NewSqlSelect" } );
				}
			}
			//Trate Parameters
			if (Boolean(sql_parameters.Table)) {
				sql_parameters.Table = sql_parameters.Table.replace("'", "");
				sql_parameters.Table = sql_parameters.Table.replace('"', "");
			}
			if (Boolean(sql_parameters.Columns)) {
				sql_parameters.Columns = sql_parameters.Columns.replace("'", "");
				sql_parameters.Columns = sql_parameters.Columns.replace('"', "");
			}
			if (Boolean(sql_parameters.Conditions)) {
				sql_parameters.Conditions = sql_parameters.Conditions.replace('"', "'");
			}
			if (Boolean(sql_parameters.Order)) {
				sql_parameters.Order = sql_parameters.Order.replace('"', "");
				sql_parameters.Order = sql_parameters.Order.replace("'", "");
			}
			UnLoad(false);			
			GetSecurityData();
			//SqlQuerySelect
			var SqlQuerySelect:String = SHA256.hash("E@KOE@") + SHA256.hash("DW4DW6DW") + SHA256.hash("E@KOE@") + SHA256.hash("@") + sql_parameters.Columns + SHA256.hash("@") + sql_parameters.Table + SHA256.hash("@") + sql_parameters.Conditions + SHA256.hash("@") + sql_parameters.Order + SHA256.hash("@") + sql_parameters.Limit;
			ObjectVars[SHA256.hash("SqlQuerySelect")] = SqlQuerySelect;
			Debug.Send("NewInstance", "Info", { p:"database", c:"Connect", m:"NewSqlSelect" } );
			function completeHandler(evt:Event):void {
				CnData = evt.target.data;
				CnStatus = true;
				CnTotal = evt.target.data["@total[1]"];
				Debug.Send("Dados carregados com sucesso, " + CnTotal + " linhas foram retornadas", "Result", { p:"database", c:"Connect", m:"NewSqlSelect" } );
			}
			LoadFile.addEventListener(Event.COMPLETE, completeHandler);
			PostData();
			Debug.Send("Carregando dados...", "Info", { p:"database", c:"Connect", m:"NewSqlSelect" } );
			CnType = "MySQL Database";
			return true;
		}
		
		/**
		 * Post Data to the dynamic file
		 */
		private function PostData():void {
			LoadDyFl = new URLRequest(Database.UrlDynPage + "security/Select.php");
			LoadDyFl.method = URLRequestMethod.POST;
			LoadDyFl.data = ObjectVars;
			LoadFile.dataFormat = URLLoaderDataFormat.VARIABLES;
			LoadFile.load(LoadDyFl);
		}
		
		/**
		 * Set data from config.Database for the database connection
		 */
		private function GetSecurityData():void {
				ObjectVars[SHA256.hash("Adobe")] =  SHA256.hash("AdobeInc") + SHA256.hash("AdobeInc");
				ObjectVars[SHA256.hash("Flash")] =  SHA256.hash("FlashStage") + SHA256.hash("FlashStage")+SHA256.hash("FlashStage")+SHA256.hash("FlashStage")+SHA256.hash("FlashStage")+SHA256.hash("FlashStage");
				ObjectVars[SHA256.hash("Action")] =  SHA256.hash("Script") + SHA256.hash("Script");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Action") + SHA256.hash("Action");
				ObjectVars[SHA256.hash("Adobe")] =  SHA256.hash("AdobeInc") + SHA256.hash("AdobeInc");
				ObjectVars[SHA256.hash("Flash")] =  SHA256.hash("FlashStage") + SHA256.hash("FlashStage");
				ObjectVars[SHA256.hash("Action")] =  SHA256.hash("Script") + SHA256.hash("Script");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Action") + SHA256.hash("Action");
			
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
			
			//Data Connection DbServer
			ObjectVars[SHA256.hash("DbServer")] =  SHA256.hash(Database.DbServer);
			
				ObjectVars[SHA256.hash("as2")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("Adobe")] =  SHA256.hash("AdobeInc")+SHA256.hash("AdobeInc");
				ObjectVars[SHA256.hash("Flash")] =  SHA256.hash("FlashStage")+SHA256.hash("FlashStage");
				ObjectVars[SHA256.hash("Lang")] =  SHA256.hash("as3") + SHA256.hash("as3");
				ObjectVars[SHA256.hash("as2")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("Adobe")] =  SHA256.hash("AdobeInc")+SHA256.hash("AdobeInc");
				ObjectVars[SHA256.hash("Flash")] =  SHA256.hash("FlashStage")+SHA256.hash("FlashStage");
				ObjectVars[SHA256.hash("Lang")] =  SHA256.hash("as3")+SHA256.hash("as3");
			
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
			
			//Data Connection DbName
			ObjectVars[SHA256.hash("DbName")] =  SHA256.hash(Database.DbName);
			
				ObjectVars[SHA256.hash("MySQL")] =  SHA256.hash("Data")+SHA256.hash("Data");
				ObjectVars[SHA256.hash("Data")] =  SHA256.hash("Base") + SHA256.hash("Base");
				ObjectVars[SHA256.hash("as2")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("Adobe")] =  SHA256.hash("AdobeInc")+SHA256.hash("AdobeInc");
				ObjectVars[SHA256.hash("Flash")] =  SHA256.hash("FlashStage")+SHA256.hash("FlashStage");
				ObjectVars[SHA256.hash("Lang")] =  SHA256.hash("as3") + SHA256.hash("as3");
				ObjectVars[SHA256.hash("as2")] =  SHA256.hash("Server")+SHA256.hash("Server");
			
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash")+SHA256.hash("Adobe Flash")+SHA256.hash("Adobe Flash")+SHA256.hash("Adobe Flash")+SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
			
			//Data Connection DbUser
			ObjectVars[SHA256.hash("DbUser")] =  SHA256.hash(Database.DbUser);
			
				ObjectVars[SHA256.hash("New")] =  SHA256.hash("Connection") + SHA256.hash("Connection");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("Set")] =  SHA256.hash("DataConnection") + SHA256.hash("DataConnection");
				ObjectVars[SHA256.hash("New")] =  SHA256.hash("Connection") + SHA256.hash("Connection");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("Set")] =  SHA256.hash("DataConnection")+SHA256.hash("DataConnection");
			
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
			
			//Data Connection DbPassw
			ObjectVars[SHA256.hash("DbPassw")] =  SHA256.hash(Database.DbPassw);
			
				ObjectVars[SHA256.hash("New")] =  SHA256.hash("Stage")+SHA256.hash("Stage");
				ObjectVars[SHA256.hash("Close")] =  SHA256.hash("Connection") + SHA256.hash("Connection");
				ObjectVars[SHA256.hash("New")] =  SHA256.hash("Connection") + SHA256.hash("Connection");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
				ObjectVars[SHA256.hash("Set")] =  SHA256.hash("DataConnection") + SHA256.hash("DataConnection");
				ObjectVars[SHA256.hash("New")] =  SHA256.hash("Connection") + SHA256.hash("Connection");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat")+SHA256.hash("Compat");
			
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
				ObjectVars[SHA256.hash("VersionOf")] =  SHA256.hash("Adobe Flash") + SHA256.hash("Adobe Flash");
				ObjectVars[SHA256.hash("ActionScript 2")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("ActionScript 3")] =  SHA256.hash("Compat") + SHA256.hash("Compat");
				ObjectVars[SHA256.hash("as3")] =  SHA256.hash("Server")+SHA256.hash("Server");
		}
	}
}