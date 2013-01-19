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
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Shape;
	
	import flash.events.MouseEvent;
	
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import com.asmonster.utils.Debug;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	/**
	 * Create drag-and-drop routines
	 */
	public class DragAndDrop 
	{
		
		private var stage:Stage;
		
		private var areas:Array = new Array();
		private var items:Array = new Array();
		
		private var limitStage:Boolean = true;
		/**
		 * Limit drop items in the stage area
		 * @default true
		*/
		public function get LimitInStage():Boolean { return limitStage; };
		/**  * @private  */ 
		public function set LimitInStage(nv:Boolean):void  { limitStage = nv; };
		
		private var overlap:Boolean = true;
		/**
		 * Overlap of items out of area
		 * @default true
		*/
		public function get overlapItem():Boolean { return overlap; };
		/**  * @private  */ 
		public function set overlapItem(nv:Boolean):void  { overlap = nv; };
		
		private var sendInvalidPosition:Boolean = true;
		/**
		 * Send message to debug on item dropped in an invalid position
		 * @default true
		*/
		public function get sendInvalidPositionToDebug():Boolean { return sendInvalidPosition; };
		/**  * @private  */ 
		public function set sendInvalidPositionToDebug(nv:Boolean):void  { sendInvalidPosition = nv; };
		
		private var SendDroppedWithinAreas:Boolean = true;
		/**
		 * Send message to debug on item dropped within of areas
		 * @default true
		*/
		public function get SendDroppedWithinAreasToDebug():Boolean { return SendDroppedWithinAreas; };
		/**  * @private  */ 
		public function set SendDroppedWithinAreasToDebug(nv:Boolean):void  { SendDroppedWithinAreas = nv; };
		
		private var SendDroppedOutAreas:Boolean = true;
		/**
		 * Send message to debug on item dropped out of areas
		 * @default true
		*/
		public function get SendDroppedOutAreasToDebug():Boolean { return SendDroppedOutAreas; };
		/**  * @private  */ 
		public function set SendDroppedOutAreasToDebug(nv:Boolean):void  { SendDroppedOutAreas = nv; };
		
		private var SendNewAreas:Boolean = true;
		/**
		 * Send message to debug on new area created
		 * @default true
		*/
		public function get SendNewAreasToDebug():Boolean { return SendNewAreas; };
		/**  * @private  */ 
		public function set SendNewAreasToDebug(nv:Boolean):void  { SendNewAreas = nv; };
		
		private var SendNewItems:Boolean = true;
		/**
		 * Send message to debug on new item created
		 * @default true
		*/
		public function get SendNewItemsToDebug():Boolean { return SendNewItems; };
		/**  * @private  */ 
		public function set SendNewItemsToDebug(nv:Boolean):void  { SendNewItems = nv; };
		
		/**
		 * @param  eStage  stage to work...
		 */
		public function DragAndDrop(eStage:Stage):void
		{
			stage = eStage;
			Debug.Send("NewInstance", "Info", { p:"interfaces", c:"DragAndDrop", m:"DragAndDrop" } );
		}
		
		/**
		 * Create a new drop area
		 * 
		 * @param	area			Object with the area to create the new drop area
		 * @param	space			Space of the subareas
		 * @param	dist			Distance between the subareas
		 * @param	overlapItem		Overlap of items in area 
		 * @param	showPts			Show the points of subareas
		 * @param	showBox			Show the boxes of subareas
		 * 
		 */
		public function NewDropArea(area:Object, space:Number = 39, dist:Number = 10, overlapItem:Boolean = false, showPts:Boolean = false, showBox:Boolean = false):void
		{
			if(Boolean(SendNewAreas)) {
				Debug.Send("New drop area created in '" + area.name + "'", "Info", { p:"interfaces", c:"DragAndDrop", m:"NewDropArea" } );
			}
			
			var i:Number = areas.length;
			
			areas[i] = new Object();
			areas[i].object = area;
			areas[i].overlap = overlapItem;
			
			if (areas[i].object as Stage) {
				areas[i].width = areas[i].object.stageWidth;
				areas[i].height = areas[i].object.stageHeight;
			} else {
				areas[i].width = areas[i].object.width;
				areas[i].height = areas[i].object.height;
			}
			
			//esse "+ 0.1" não deveria existir, mas depois que mudei pra tweenmax...
			//deu essa diferença de 0.1 não sei pq... bem, assim funciona; =)
			areas[i].space = space + 0.1; areas[i].dist = dist;
			
			areas[i].x = areas[i].object.x;
			areas[i].y = areas[i].object.y;
			
			DrawGrid(areas[i], showPts, showBox);
			
		}
		
		/**
		 * Add item in the drop area
		 * 
		 * @param	item				New item object
		 * @param	areaDrag			Drop area of the new object
		 * @param	Conditions			Conditions of the drop ['Areas', 'OutAreas' or 'All']
		 * @param	colorDrag			Color of the drag shadow
		 * @param	alphaDrag			Alpha of the drag shadow
		 * @param	lineDrag			Color of the drag line
		 * @param	lineAlphaDrag		Alpha of the drag line
		 * @param	lineDragT			Size of the drag line
		 */
		public function AddItem(item:Object, areaDrag:Object, Conditions:Object = null, colorDrag:uint = 0x000000, alphaDrag:Number = 0.1, lineDrag:uint = 0xFF0000, lineAlphaDrag:Number = 0.2, lineDragT:Number = 2):void
		{
			if(Boolean(SendNewItems)) {
				Debug.Send("New item added: '" + item.name + "'", "Info", { p:"interfaces", c:"DragAndDrop", m:"AddItem" } );
			}
			
			var nl:Number = items.length;
			
			items[nl] = new Object();
			items[nl].object = item;
			items[nl].area = areaDrag;
			
			items[nl].container = undefined;
			
			items[nl].area.buttonMode = true;
			
			items[nl].DropLimits = "All";
			
			if (Boolean(Conditions)) {
				if (Boolean(Conditions.DropLimits == "Areas" || Conditions.DropLimits == "OutAreas") || Conditions.DropLimits == "All") {
					items[nl].DropLimits = Conditions.DropLimits;
				}
			}
			
			var shd:Sprite = new Sprite();
			shd.graphics.beginFill(colorDrag);
			shd.graphics.drawRect(0, 0, 1, 1);
			shd.width = item.width; shd.height = item.height;
			shd.alpha = 0; shd.visible = false;
			stage.addChild(shd);
			
			var lnp:Sprite = new Sprite();
			lnp.graphics.lineStyle(lineDragT, lineDrag, 1, true);
			lnp.graphics.drawRect(0, 0, item.width, item.height);
			lnp.alpha = 0; lnp.visible = false;
			stage.addChild(lnp);
			
			function onDrop():void {	
				var rtNpg:Object = NewPosition(nl, shd.x, shd.y, true);
				if (Boolean(rtNpg.move)) {
					lnp.x = rtNpg.x; lnp.y = rtNpg.y;
				} else {
					lnp.x = items[nl].object.x; lnp.y = items[nl].object.y;
				}
			}
			var onDropT:uint;
			function Drag(event:MouseEvent):void {
				stage.removeChild(lnp); stage.addChild(lnp);
				TweenMax.killTweensOf(lnp);
				lnp.visible = true; TweenMax.to(lnp, 0.5, { alpha:lineAlphaDrag, overwrite:0, ease:Linear.easeNone } );
				lnp.x = items[nl].object.x; lnp.y = items[nl].object.y;
				stage.removeChild(shd); stage.addChild(shd);
				TweenMax.killTweensOf(shd);
				shd.visible = true; TweenMax.to(shd, 0.5, { alpha:alphaDrag, overwrite:0, ease:Linear.easeNone } );
				shd.x = items[nl].object.x; shd.y = items[nl].object.y;
				shd.startDrag();
				onDropT = setInterval(onDrop, 5);
			}
			function Drop(event:MouseEvent):void {
				clearInterval(onDropT);
				shd.stopDrag();
				TweenMax.killTweensOf(lnp);
				var lnpVF:Function = function(obj:Object):void { obj.visible = false; }
				TweenMax.to(lnp, 0.6, { alpha:0, overwrite:0, ease:Linear.easeNone, onComplete:lnpVF, onCompleteParams:[lnp] } );
				TweenMax.killTweensOf(shd);
				var shdVF:Function = function(obj:Object):void { obj.visible = false; }
				TweenMax.to(shd, 0.4, { alpha:0, overwrite:0, ease:Linear.easeNone, onComplete:shdVF, onCompleteParams:[shd] } );
				var rtNp:Object = NewPosition(nl, shd.x, shd.y);
				if (Boolean(rtNp.move)) {
					TweenMax.killTweensOf(items[nl].object);
					TweenMax.to(items[nl].object, 0.5, { x:rtNp.x, y:rtNp.y, overwrite:0, ease:Expo.easeOut } );
				}
			}
			items[nl].area.addEventListener(MouseEvent.MOUSE_DOWN, Drag);
			shd.addEventListener(MouseEvent.MOUSE_UP, Drop);
			
		}
		
		/**
		 * Get area of some item
		 * 
		 * @param	Item		Item to get area
		 */
		public function GetAreaOfItem(Item:Object = null):Object {
			
			var Area:Object = null;
			
			var vl:Boolean = false;
			
			for (var i:int = 0; i < items.length; i++) {
				if(Item as String) {
					if (items[i].object.name == Item) {
						 vl = true;
						if (items[i].container > -1) { Area = areas[items[i].container].object; };
					}
				} else {
					if (items[i].object == Item) {
						vl = true;
						if (items[i].container > -1) { Area = areas[items[i].container].object; };
					}
				}
			}
			
			if (!Boolean(vl)) {
				Debug.Send("Invalid item: " + Item, "Error", { p:"interfaces", c:"DragAndDrop", m:"GetAreaOfItem" } );
			}
			
			return Area;
			
		}
		
		/**
		 * Get items within some area
		 * 
		 * @param	Area		Area to get items
		 */
		public function GetItemsOfDropArea(Area:Object = null):Array {
			
			var itemsOfArea:Array = new Array();
			var idArea:Number = undefined;
			
			for (var i:int = 0; i < areas.length; i++) {
				if(Area as String) {
					if (Boolean(Area == areas[i].object.name)) { idArea = i; };
				} else {
					if (Boolean(Area == areas[i].object)) { idArea = i; };
				}
			}
			
			if (idArea > -1) {
				var ct:Number = 0;
				for (var x:int = 0; x < items.length; x++) 
				{
					if (Boolean(items[x].container == idArea)) {
						itemsOfArea[ct] = items[x].object;
						ct = ct + 1;
					}
				}
				return itemsOfArea;
			} else {
				Debug.Send("Invalid drop area: " + Area, "Error", { p:"interfaces", c:"DragAndDrop", m:"GetItemsOfDropArea" } );
			
				return itemsOfArea;
			}
		}
		
		/**
		 * Create a new grid
		 */
		private function DrawGrid(area:Object, showPts:Boolean, showBox:Boolean):void
		{
			
			var pBl:Number = int((area.width) / (area.space + area.dist));
			var pBc:Number = int((area.height) / (area.space + area.dist));
			
			area.pts = new Array();
			
			var ctPos:Number = 0;
			
			for (var x:int = 1; x <= pBc; x++) {
				var ny:Number = ((area.y + area.dist) + (area.space + (area.dist)) * x) - (area.space + (area.dist));
				for (var i:int = 1; i <= pBl; i++) {
					var nx:Number = ((area.x + area.dist) + (area.space + (area.dist)) * i) - (area.space + (area.dist));
					
					var pt:Shape = new Shape();
					pt.graphics.beginFill(0xFF0000);
					pt.graphics.drawCircle(nx, ny, 2);
					if (!Boolean(showPts)) { pt.visible = false; };
					stage.addChild(pt);
					
					var shd:Sprite = new Sprite();
					shd.graphics.beginFill(0xFF0000);
					shd.graphics.drawRect(0, 0, area.space, area.space);	
					shd.x = nx; shd.y = ny; shd.alpha = 0.2;
					if (!Boolean(showBox)) { shd.visible = false; };
					stage.addChild(shd);
					
					area.pts[ctPos] = new Object();
					area.pts[ctPos].x = nx;
					area.pts[ctPos].y = ny;
					area.pts[ctPos].box = shd;
					area.pts[ctPos].pt = pt;
					
					ctPos = ctPos + 1;
				}
			}
			
		}
		
		/**
		 * Set status
		 */
		private function PtStatus():Array
		{
			
			for (var x:int = 0; x < areas.length; x++) {
				for (var p:int = 0; p < areas[x].pts.length; p++) {
					areas[x].pts[p].box.alpha = 0.2;
				}
			}
			for (var id:int = 0; id < items.length; id++) {
				if (Boolean( items[id].container > -1 )) {
					var idArea:Number = items[id].container;
					var idPos:Number = items[id].pos;
					var sLx:Number = areas[idArea].pts[idPos].box.x;
					var eLx:Number = areas[idArea].pts[idPos].box.x + items[id].object.width + areas[idArea].dist;
					var sLy:Number = areas[idArea].pts[idPos].box.y;
					var eLy:Number = areas[idArea].pts[idPos].box.y + items[id].object.height  + areas[idArea].dist;
					for (var c:int = 0; c < areas[idArea].pts.length; c++) {
						if (
						Boolean(areas[idArea].pts[c].box.x > (sLx - 1) && areas[idArea].pts[c].box.x < (eLx))
						&&
						Boolean(areas[idArea].pts[c].box.y > (sLy - 1) && areas[idArea].pts[c].box.y < (eLy))
						) {
							areas[idArea].pts[c].box.alpha = 0.5;
						}
					}
				}
			}
			var arRt:Array = new Array();
			var nR:Number = 0;
			for (var i:int = 0; i < areas.length; i++) {
				for (var j:int = 0; j < areas[i].pts.length; j++) {
					if (areas[i].pts[j].box.alpha > 0.2) {
						arRt[nR] = new Array(); arRt[nR][0] = i; arRt[nR][1] = j;
						nR = nR + 1;
					}
				}
			}
			return arRt;
		}
		
		/**
		 * Calcule pts
		 */
		private function GetPts(id:Object, idArea:Object, idPos:Number):Array {
			
			var sLx:Number = areas[idArea].pts[idPos].box.x;
			var eLx:Number = areas[idArea].pts[idPos].box.x + items[id].object.width + areas[idArea].dist;
			
			var sLy:Number = areas[idArea].pts[idPos].box.y;
			var eLy:Number = areas[idArea].pts[idPos].box.y + items[id].object.height + areas[idArea].dist;
			
			var pts:Array = new Array();
			var i:Number = 0;
			for (var c:int = 0; c < areas[idArea].pts.length; c++) {
				if (
				Boolean(areas[idArea].pts[c].box.x > (sLx - 1) && (areas[idArea].pts[c].box.x) < (eLx))
				&&
				Boolean(areas[idArea].pts[c].box.y > (sLy - 1) && (areas[idArea].pts[c].box.y) < (eLy))
				) {
					pts[i] = c; i = i + 1;
				}
			}
			return pts;
		}
		
		/**
		 * Move items to new position
		 */
		private function NewPosition(id:Object, nx:Number, ny:Number, temp:Boolean = false):Object
		{
			var Rt:Object = new Object();
			var Cnt:Number = undefined;
			
			//Verifica se a nova posição do objeto pertence a alguma área
			for (var i:int = 0; i < areas.length; i++) {
				if (
					Boolean( nx + items[id].object.width > (areas[i].x - 1) && nx < (areas[i].x + areas[i].width + 1) )
					&&
					Boolean( ny + items[id].object.height > (areas[i].y - 1) && ny < (areas[i].y + areas[i].height + 1) )
					) {
					Cnt = i;
				}
			}	
			//Se o objeto será solto dentro de uma nova área e o item puder ser solto dentro de áreas então...
			if ( Boolean(Cnt > -1) && Boolean(items[id].DropLimits == "All" || items[id].DropLimits == "Areas") ) {
				
				//pega todos os pontos ocupados atualmente naquela área
				var ckS:Array = PtStatus();
				
				var ptSel:Number = undefined;
				var btX:Number = 9999999999999999999999999999999999999999999999999;
				var btY:Number = 9999999999999999999999999999999999999999999999999;
				var tpNy:Number = ny; var tpNx:Number = nx;
				
				//Verifica qual o ponto mais próximo daquela área para o objeto ser solto
				for (var a:int = 0; a < areas[Cnt].pts.length; a++) {
					var px:Number = int(nx - areas[Cnt].pts[a].x);
					var py:Number = int(ny - areas[Cnt].pts[a].y);
					if ( px < 0 ) { px = px * -1; };
					if ( py < 0 ) { py = py * -1; };
					
					if (py < btY || px < btX) {
						btX = px; tpNx = areas[Cnt].pts[a].x;
						btY = py; tpNy = areas[Cnt].pts[a].y;
						ptSel = a;
					};
				}

				//variável que irá dizer se o objeto pode ser solto naquela área ou não
				var ckSp:Boolean = true;
				
				//pega os pontos a serem ocupados pelo item na área em que será solto
				var nslPts:Array = GetPts(id, Cnt, ptSel);
				
				//verifica quantos pontos o objeto ocupa por linha/coluna naquela área
				var ibL:Number = (items[id].object.width + areas[Cnt].dist) / ( areas[Cnt].space + areas[Cnt].dist );
				var ibC:Number = (items[id].object.height + areas[Cnt].dist) / ( areas[Cnt].space + areas[Cnt].dist );
				
				if (ibL > int(ibL)) { ibL = int(ibL) + 1; }; 
				if (ibC > int(ibC)) { ibC = int(ibC) + 1; };
				
				//se a área não aceitar sobreposição dos itens...
				if (!Boolean(areas[Cnt].overlap)) {
					//verifica se o objeto já está naquela e área e pega os pontos ocupados por ele
					if(items[id].pos > -1 && items[id].container == Cnt) {
						var lslPts:Array = GetPts(id, Cnt, items[id].pos);					
					}
					
					//for em todos os campos ocupados no momento
					for (var c:int = 0; c < ckS.length; c++) {
						//verifica se o ponto ocupado pertence à área a ser ocupada
						if (ckS[c][0] == Cnt) {
								//for nos campos a serem ocupados pelo item
								for (var x:int = 0; x < nslPts.length; x++) {
									//se o ponto a ser ocupado é igual a um ponto já ocupado...
									if (ckS[c][1] == nslPts[x]) {
										var ckLp:Boolean = false;
										//verifica se o ponto a ser ocupado não pertence ao item que vai ocupá-lo
										if(Boolean(lslPts)) {
											for (var j:int = 0; j < lslPts.length; j++) {
												//se pertencer, então o ponto pode ser ocupado, já que é dele msm
												if (lslPts[j] == nslPts[x]) { ckLp = true; };
											}
										}
										//se o ponto a ser ocupado não pertencer ao item que vai ocupá-lo, então não poderá ser movimentado ali....
										if (!Boolean(ckLp)) { ckSp = false; };
									}
								}
						}
					}
				}
				
				//se a quantidade de campos a serem ocupados for diferente da quantidade de campos necessária para o item, então não poderá ser movimenta ali...
				if (!Boolean(nslPts.length == int(ibL * ibC))) { ckSp = false; };
				
				//seta as novas posições que o objeto ocupará se for movimentado
				nx = tpNx; ny = tpNy;
				
				//se o objeto puder ser movido naquela área...
				if (Boolean(ckSp)) {
					if (!Boolean(temp)) {
						
						//seta a nova área a qual o item percente
						items[id].container = Cnt;
						
						//seta o novo ponto da área em que o objeto se encontra
						items[id].pos = ptSel;
						
						PtStatus();
						
						if(Boolean(SendDroppedWithinAreas)) {
							Debug.Send("Object '" + items[id].object.name + "' dropped within the area '" + areas[Cnt].object.name + "'", "Info", { p:"interfaces", c:"DragAndDrop", m:"NewPosition" } );
						}
					}
					Rt.move = true;
					Rt.x = nx; Rt.y = ny;
				} else {
					if (!Boolean(temp)) {
						if(Boolean(sendInvalidPosition)) {
							Debug.Send("Object '" + items[id].object.name + "' dropped in an invalid position", "Alert", { p:"interfaces", c:"DragAndDrop", m:"NewPosition" } );
						}
					}
					Rt.move = false;
				}
				return Rt;
			} else {
				if (items[id].DropLimits == "All" || items[id].DropLimits == "OutAreas" && !Boolean(Cnt > -1)) {
					
					var mTn:Boolean = true;
					
					//Se não aceitar sobreposição...
					if (!Boolean(overlap)) {
						//Precisa verificar se o item não está sobrepondo nada;
						for (var q:int = 0; q < items.length; q++) 
						{
							if (Boolean(items[q].container == undefined && id != q)) {
								var nSx:Number = items[q].object.x;
								var nEx:Number = items[q].object.x + items[q].object.width;
								var nSy:Number = items[q].object.y;
								var nEy:Number = items[q].object.y + items[q].object.height;
								
								var cSx:Number = nx;
								var cEx:Number = nx + items[id].object.width;
								var cSy:Number = ny;
								var cEy:Number = ny + items[id].object.height;					
								
								if ( Boolean( cEx - 1 >= nSx && cSx + 1 <= nEx ) && Boolean( cEy - 1 >= nSy && cSy + 1 <= nEy ) ) {
									mTn = false;
								};
							}
						}
					}					
					//Verifica se o item não ultrapassa os limites do stage
					if (Boolean(limitStage)) {
						if (!Boolean(nx > -1 && (nx + items[id].object.width) < (stage.stageWidth + 1) && ny > -1 && (ny + items[id].object.height) < (stage.stageHeight + 1))) {
							mTn = false;
						}
					}
					
					//Se puder mover o item...
					if(Boolean(mTn)) {
						if (!Boolean(temp)) {
							PtStatus();
							if (Boolean(SendDroppedOutAreas)) {
								Debug.Send("Object '" + items[id].object.name + "' dropped out of area", "Info", { p:"interfaces", c:"DragAndDrop", m:"NewPosition" } );
							}
						}
						items[id].container = undefined;
						Rt.move = true;
					} else {
						if (!Boolean(temp)) {
							if(Boolean(sendInvalidPosition)) {
								Debug.Send("Object '" + items[id].object.name + "' dropped in an invalid position", "Alert", { p:"interfaces", c:"DragAndDrop", m:"NewPosition" } );
							}
						}
					}
				} else {
					if (!Boolean(temp)) {
						if(Boolean(sendInvalidPosition)) {
							Debug.Send("Object '" + items[id].object.name + "' dropped in an invalid position", "Alert", { p:"interfaces", c:"DragAndDrop", m:"NewPosition" } );
						}
					}
				}
				Rt.x = nx; Rt.y = ny;
				return Rt;
			}
		}
		
	}
}