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

package com.asmonster 
{
	
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import com.asmonster.utils.Debug;
	
	/**
	 * Inicialização do código e informações básicas do asMonster.
	 */
	public class asMonster 
	{
		
		/**
		 * Versão do asMonster.
		 */
		public static var Version:String = "1.8.6 Beta";
		
		/**
		 * Não há construtor.
		 */
		public function asMonster():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"asmonster", c:"asMonster", m:"asMonster" } );
		}
	
		/**
		 * Adiciona os créditos do asMonster no meu direito (ContextMenu) do SWF.
		 * 
		 * @param	hide	Esconder menus padrões do flash ('Zoom In', 'Zoom Out', etc.).
		 */
		public static function AddCredits(hide:Boolean = true):ContextMenu
		{
			var asCred:ContextMenu = new ContextMenu();
			
			if (Boolean(hide)) { asCred.hideBuiltInItems(); }
			
			var line:ContextMenuItem = new ContextMenuItem(null, true, false);
			var linkText:ContextMenuItem = new ContextMenuItem("asMonster " + Version);
			asCred.customItems.push(linkText, line);
			function CLICK(ContextMenuEvent:Event):void { navigateToURL(new URLRequest("http://asmonster.gbaptista.com/"), "_blank"); };
			linkText.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, CLICK);
			return asCred;
		}
		
		/**
		 * Inicia o código do asMonster com as configurações básicas.
		 * <p>Para que o asMonster funcione, é indispensável chamar este método.</p>
		 * <p>Define o "stage.scaleMode" como "StageScaleMode.NO_SCALE" e o stage.align como "TL".</p>
		 * <p>Inicia o Debug de acordo com os parâmetros.</p>
		 * <p>Envia informações de ajuda e sobre a versão atual.</p>
		 * 
		 * @param	stage			Stage principal da aplicação para ser ajustado.
		 * @param	debug			Iniciar com o Debug aberto.
		 * @param	noCreateDebug	Não criar o Debug.
		 * 
		 * @see com.asmonster.utils.Debug
		 */
		public static function Init(stage:Stage, debug:Boolean = true, noCreateDebug:Boolean = false):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE; stage.align = "TL";
			
			if (!Boolean(noCreateDebug)) {
				if (!Boolean(debug)) { Debug.active = false; }
				Debug.stage = stage; Debug.Start();
			}
			
			asMonster.Help(); asMonster.GetVersion();
		}
		
		/**
		 * Envia a versão atual do asMonster ao Debug.
		 * 
		 * @see com.asmonster.utils.Debug
		 */
		public static function GetVersion():void
		{
			Debug.Send("asMonster Version " + Version + " - Welcome!", "Result", { p:"asmonster", c:"asMonster", m:"GetVersion" } );
		}
		
		/**
		 * Envia informações de ajuda ao Debug.
		 * 
		 * @see com.asmonster.utils.Debug
		 */
		public static function Help():void
		{
			Debug.Send("More information in: http://asmonster.gbaptista.com/", "Alert", { p:"asmonster", c:"asMonster", m:"Help" } );
			Debug.Send("Documentation in: http://asmonster.gbaptista.com/docs/" + Version + "/", "Alert", { p:"asmonster", c:"asMonster", m:"Help" } );
		}
	}
}