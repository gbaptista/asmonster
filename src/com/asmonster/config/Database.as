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

package com.asmonster.config 
{
	
	import com.asmonster.utils.Debug;
	
	/**
	 * Armazena informações necessárias para realizar a conexão com o banco de dados.
	 * 
	 * <p>Os dados das propriedades DbServer, DbName, DbUser e DbPassw devem ser gerados com o utilitário GeneretaData.swf localizado na pasta "_utils".</p>
	 * 
	 * <p>Além destes dados, é necessário preencher normalmente o arquivo Config.php localizado na pasta "dynamic".</p>
	 * 
	 * <p>A pasta "dynamic" deve estar em algum servidor (local ou on-line) para que possa acessar o banco de dados já que a conexão é feita com PHP.</p>
	*/
	public class Database 
	{
		
		/** Pasta "dynamic" (Link do servidor para a pasta "dynamic"). */
		public static const UrlDynPage:String = "";
		
		/** Servidor do banco de dados. */
		public static const DbServer:String = "";
		
		/** Nome do banco de dados. */
		public static const DbName:String = "";
		
		/** Usuário do banco de dados. */
		public static const DbUser:String = "";
		
		/** Senha do banco de dados. */
		public static const DbPassw:String = "";
		
		/**
		 * Não há construtor.
		 */
		public function Database():void
		{
			Debug.Send("A static class should not be instantiated", "Error", { p:"config", c:"Database", m:"Database" } );
		}
	}
}