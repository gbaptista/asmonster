package com.asmonster._test 
{

	import com.asmonster.effects.AnimateDataItems;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextField;
	
	import com.asmonster.database.Connect;
	import com.asmonster.database.UseData;
	
	import com.asmonster.utils.Capture;
	
	import com.asmonster.utils.Debug;
	
	public class Test_database_UseData 
	{
		
		public function Test_database_UseData(stage:Stage, type:String, Mth:String = null) 
		{
			var tS:String = "Test_database_UseData";
			
			// #### Inform Test
			Debug.Send("Test Started", "Alert", { p:"test", c:"Test", m:tS } );
			
			// #### Start Test
			var Data:Connect = new Connect();
			if(type == "xml") {
				Data.NewXmlGet( { File:"com/asmonster/_test/xml/Test1.xml", Node:"Table", SubNode:"Line" } );
			} else if(type == "database") {
				Data.NewSqlSelect( { Table: "eventos", Columns:"*", Conditions:"id > 1", Order:"id DESC", Limit:48 } );
			}
			
			var List:UseData = new UseData(Data);
			
			if (Boolean(Mth) && type == "xml") {
				if (Mth == "GetData") {
					// ## GetData
					var Cp:TextField = new TextField(); Cp.x = 10; Cp.y = 10;
					stage.addChild(Cp);
					
					List.GetData( {
						Target: Cp, Type: "Text", Data: "Manual Data Test"
					} );
					
					var Ld:NewShape = new NewShape(); Ld.y = 15; Ld.x = 150;
					stage.addChild(Ld);
					var txtP:TextField = new TextField(); txtP.x = 150; txtP.y = 90;
					stage.addChild(txtP);
					
					List.GetData( {
						Target: Ld, Type: "Load",
						Data: "com/asmonster/_test/images/9.jpg", ProgressText:txtP
					} );
					
					var Bt:NewShape = new NewShape(); Bt.y = 15; Bt.x = 250;
					stage.addChild(Bt);
					
					var ckT:Function = function(ObjR:Object):void {
						Debug.Send("Click: " + ObjR + " - " + ObjR.Line + " - " + ObjR.Data, "Info", { p:"test", c:"Test", m:tS } );
					};
					var ouT:Function = function(ObjR:Object):void {
						Debug.Send("Out: " + ObjR + " - " + ObjR.Line + " - " + ObjR.Data, "Info", { p:"test", c:"Test", m:tS } );
					};
					var ovT:Function = function(ObjR:Object):void {
						Debug.Send("Over: " + ObjR + " - " + ObjR.Line + " - " + ObjR.Data, "Info", { p:"test", c:"Test", m:tS } );
					};
					List.GetData( {
						Target: Bt, Type: "Button", Data: "Data Button Test", Click: ckT
					} );
					List.GetData( {
						Target: Bt, Type: "Button", Data: "Data Button Test", Out: ouT
					} );
					List.GetData( {
						Target: Bt, Type: "Button", Data: "Data Button Test", Over: ovT
					} );
					
					var fcT:Function = function(ObjR:Object):void {
						Debug.Send("Function: " + ObjR + " - " + ObjR.Line + " - " + ObjR.Data, "Info", { p:"test", c:"Test", m:tS } );
					};
					List.GetData( {
						Function:fcT, Data: "Data Button Test"
					} );
				} else  if (Mth == "GetData2") {
					// ## GetData2
					var Cpb:TextField = new TextField(); Cpb.x = 10; Cpb.y = 10;
					Cpb.width = 600; stage.addChild(Cpb);
					List.GetData( {
						Target: Cpb, Type: "Text", 
						GetField: {
							Line: 2,
							Columns: "name"
						}
					} );
					
					var Cpc:TextField = new TextField(); Cpc.x = 10; Cpc.y = 30;
					Cpc.width = 600; stage.addChild(Cpc);
					List.GetData( {
						Target: Cpc, Type: "Text", 
						GetField: {
							Line: 2,
							Columns: "age",
							IsEmpty: [20],
							OnEmpty: "ops..."
						}
					} );
					
					var Cpd:TextField = new TextField(); Cpd.x = 10; Cpd.y = 50;
					Cpd.width = 600; stage.addChild(Cpd);
					List.GetData( {
						Target: Cpd, Type: "Text", 
						GetField: {
							Line: 2,
							Columns: ["name","age","infos"]
						}
					} );
					
					var Cpe:TextField = new TextField(); Cpe.x = 10; Cpe.y = 70;
					Cpe.width = 600; stage.addChild(Cpe);
					List.GetData( {
						Target: Cpe, Type: "Text", 
						GetField: {
							Line: 2,
							Columns: "age",
							Use:"Age: <data>"
						}
					} );
					
					var Cpf:TextField = new TextField(); Cpf.x = 10; Cpf.y = 90;
					Cpf.width = 600; stage.addChild(Cpf);
					List.GetData( {
						Target: Cpf, Type: "Text", 
						GetField: {
							Line: 3,
							Columns: ["age","name"],
							Use:"Age: <1> - Name: <2>"
						}
					} );
					
					function TreatF(txt:String):String {
						return "Treat_" + txt;
					}
					
					var Cpg:TextField = new TextField(); Cpg.x = 10; Cpg.y = 110;
					Cpg.width = 600; stage.addChild(Cpg);
					List.GetData( {
						Target: Cpg, Type: "Text", 
						GetField: {
							Line: 3,
							Columns: "age",
							Treat:TreatF
						}
					} );
				} else if (Mth == "GetData3") {
					
					//criamos a conexão
					var cnn:Connect = new Connect();
					
					//selecionamos os dados do arquivo XML
					cnn.NewXmlGet( {
						File:"com/asmonster/_test/xml/Data.xml",
						Node:"myList",
						SubNode:"item"
					} );
					
					
					//intanciamos a classe para trabalhar com os dados
					var items:UseData = new UseData(cnn);
					
					//criamos a paginação com as miniaturas
					items.PaginateData( {
						AddChildIn:stage,
						ObjModel:_BoxPic,
						ItemsByPage:10,
						ItemsByRC:2,
						Disposal:"H",
						DistX:10, DistY:10,
						StartX:80, StartY:60
					}, [
							{ Type:"Load", Target:"$Loader", Columns:"picture", Use:"com/asmonster/_test/images/s/<data>.jpg" },
							{ Type:"Load", Target:"$Loader", Columns:"picture", Use:"com/asmonster/_test/images/s/<data>.jpg" }
					   ]
					);
					
				} else if (Mth == "PaginateData") {
					// ## PaginateData
					List.PaginateData( {
						ObjModel: NewShape2,
						AddChildIn: stage
					} );
				} else if (Mth == "PaginateData2") {
					var txt2:TextField;
					
					var TestCnt:MovieClip = new MovieClip();
					stage.addChild(TestCnt);
					
					var StatusText2:TextField = new TextField();  txt2 = StatusText2;
					txt2.x = 10; txt2.y = 6; TestCnt.addChild(txt2);
					txt2.name = "StatusText2";
					
					var TotalItemsText2:TextField = new TextField();  txt2 = TotalItemsText2;
					txt2.x = 100; txt2.y = 6; TestCnt.addChild(txt2);
					txt2.name = "TotalItemsText2";
					
					var TotalPagesText2:TextField = new TextField();  txt2 = TotalPagesText2;
					txt2.x = 150; txt2.y = 6; TestCnt.addChild(txt2);
					txt2.name = "TotalPagesText2";
					
					var AtualPageText2:TextField = new TextField();  txt2 = AtualPageText2;
					txt2.x = 200; txt2.y = 6; TestCnt.addChild(txt2);
					txt2.name = "AtualPageText2";
					
					var BtGo2:NewShape = new NewShape();
					BtGo2.y = -55; BtGo2.x = 400;
					TestCnt.addChild(BtGo2);
					BtGo2.name = "BtGo2";
					
					var BtBk2:NewShape = new NewShape();
					BtBk2.y = -55; BtBk2.x = 300;
					TestCnt.addChild(BtBk2);
					BtBk2.name = "BtBk2";
					
					var testAn:AnimateDataItems = new AnimateDataItems( {
						scaleX:true
					} );
					
					List.PaginateData( {
						Animation:testAn,
						AddChildIn: TestCnt,
						ObjModel: NewShape2,
						StartX:40,
						StartY:40,
						AutoMarginH:20,
						AutoMarginV:34,
						ItemsByPage:12,
						ItemsByRC:4,
						Dist:10,
						TextOnLoading:"Cargando...",
						TextOnComplete:"ok!",
						StatusText:"StatusText2",
						TotalItemsText:"TotalItemsText2",
						TotalPagesText:"TotalPagesText2",
						AtualPageText:"AtualPageText2",
						NextBtObj:"BtGo2",
						PrevBtObj:"BtBk2"
					} );
				} else if (Mth == "PaginateData3") {
					var txt:TextField;
					
					var StatusText:TextField = new TextField();  txt = StatusText;
					txt.x = 10; txt.y = 6; stage.addChild(txt);
					
					var TotalItemsText:TextField = new TextField();  txt = TotalItemsText;
					txt.x = 100; txt.y = 6; stage.addChild(txt);
					
					var TotalPagesText:TextField = new TextField();  txt = TotalPagesText;
					txt.x = 150; txt.y = 6; stage.addChild(txt);
					
					var AtualPageText:TextField = new TextField();  txt = AtualPageText;
					txt.x = 200; txt.y = 6; stage.addChild(txt);
					
					var BtGo:NewShape = new NewShape();
					BtGo.y = -55; BtGo.x = 400;
					stage.addChild(BtGo);
					
					var BtBk:NewShape = new NewShape();
					BtBk.y = -55; BtBk.x = 300;
					stage.addChild(BtBk);
					
					List.PaginateData( {
						Animation:new AnimateDataItems(),
						AddChildIn: stage,
						ObjModel: NewShape2,
						StartX:40,
						StartY:40,
						AutoAdjustIn:stage,
						AutoMarginH:20,
						AutoMarginV:34,
						AutoDist:true,
						minDist:10,
						EqualDists:false,
						StatusText:StatusText,
						TotalItemsText:TotalItemsText,
						TotalPagesText:TotalPagesText,
						AtualPageText:AtualPageText,
						NextBtObj:BtGo,
						PrevBtObj:BtBk,
						OnEndPage:"Stop"
					} );
				}
			}
			
			// #### Test Complete
			Debug.Send("Test Complete", "Alert", { p:"test", c:"Test", m:tS } );
			
		}
	}
}