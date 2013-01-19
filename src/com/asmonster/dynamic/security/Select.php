<?php
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

require_once("sha256.inc.php");

//Verification of the Data Connection
function VrfConectDataBase() {
	include("../Config.php");
	$PostDbServer = addcslashes($_POST["ca0ca44928719c5e8b0f5e1bba6e5a1f203b4ed4876c67625268bff0fd4c7ca3"], "'");
	$PostDbName = addcslashes($_POST["c63e07d3281e04e3057482ed71e67a428c0591a66cd530f0f9d6108a2777e250"], "'");
	$PostDbUser = addcslashes($_POST["c768c8cf490d977a7a937a8ea8d06e68b657661beaf4d213bc98e6de8b40e607"], "'");
	$PostDbPassw = addcslashes($_POST["c1cc6a1552a7499ca6ab9b59cc7f0e8df48c885914caa91afd580803d0bde985"], "'");
	if ( sha256(sha256($DbServer)) != $PostDbServer || sha256(sha256($DbName)) != $PostDbName
		|| sha256(sha256($DbUser)) != $PostDbUser || sha256(sha256($DbPassw)) != $PostDbPassw )
	{ return false; } else { return true; };
}

if (VrfConectDataBase() != true) {
	echo "return=";
} else {
	echo "return=ok&";
}

//Status Messages
if (VrfConectDataBase() != true ) { echo "Data Connection: Error # "; };

//Start Data Connection
if (VrfConectDataBase() == true) {
	include("../Config.php");
// ## Start - Access Granted

	//S Connection
	$con = mysql_connect($DbServer, $DbUser, $DbPassw);
	mysql_select_db($DbName, $con);
	//E Connection
	
	// S SELECT
	$PostString = $_POST["f32fc4a1cea0154d740bf3ae54314eb9919eb5316c6e3fa0c9926aef2277ce26"];
	$SqlQuerySelect = "";	
	$ArPostString = explode(sha256("@"), $PostString);
	$i = 0; $v = 0;
	foreach($ArPostString as $PartStr) {
		$i++;
		if ($i == 2 && strlen($PartStr) > 0 && $PartStr != "undefined" && $PartStr != "null") {
			$SqlQuerySelect = $SqlQuerySelect."SELECT " . $PartStr . " FROM";
			$SelColuns = $PartStr;
			$v++;
		}
		if ($i == 3 && strlen($PartStr) > 0 && $PartStr != "undefined" && $PartStr != "null") {
			if($TablesAllowed == "*") {
				$SqlQuerySelect = $SqlQuerySelect." " . $PartStr;
				$SelTable = $PartStr;
				$v++;
			} else {
				$verf = explode(",", $TablesAllowed);
				$j = 0;
				foreach($verf as $VerfTbl) {
					if ( trim(strtoupper($VerfTbl)) == trim(strtoupper($PartStr)) ) {
						$j++;
					}
				}
				if ( $j > 0) {
					$SqlQuerySelect = $SqlQuerySelect." " . $PartStr;
					$SelTable = $PartStr;
					$v++;
				}
			}
			
		}
		if ($i == 4 && strlen($PartStr) > 0 && $PartStr != "undefined" && $PartStr != "null") {
			$SqlQuerySelect = $SqlQuerySelect." WHERE " . $PartStr;
		}
		if ($i == 5 && strlen($PartStr) > 0 && $PartStr != "undefined" && $PartStr != "null") {
			$SqlQuerySelect = $SqlQuerySelect." ORDER BY " . $PartStr;
		}
		if ($i == 6 && strlen($PartStr) > 0 && $PartStr > 0 && $PartStr != "undefined" && $PartStr != "null") {
			$SqlQuerySelect = $SqlQuerySelect." LIMIT " . $PartStr;
		}
	};
	if ($v > 1) {
		//S Data Select		
		$listV = mysql_query($SqlQuerySelect);
		$list = mysql_query($SqlQuerySelect);
		if (mysql_fetch_array($listV)) {
			$i = 0;
			while($ret = mysql_fetch_array($list)) {
				$i++;
				if ($SelColuns == "*") {
					$result = mysql_query("SHOW COLUMNS FROM ".$SelTable);
					while($columns = mysql_fetch_array($result)) {
						echo str_replace( "&", sha256("&"), ($columns[0] . "[" . $i . "]=" . $ret[ $columns[0] ]) ) . "&";
					}
				} else {
					$result = explode(",", $SelColuns);
					foreach($result as $columns) {
						echo str_replace( "&", sha256("&"), (trim($columns) . "[" . $i . "]=" . $ret[ trim($columns) ]) ) . "&";
					}
				}
			};
			echo "@total[1]=".$i;
		};
		if ($SelColuns == "*") {
			$resultF = mysql_query("SHOW COLUMNS FROM ".$SelTable);
			echo "&columnsTable[1]=";
			$clTb = "";
			while ($columns = mysql_fetch_array($resultF)) {
					$clTb = $clTb . $columns[0] . ",";
			}
			$clTb = substr( $clTb, 0, strlen($clTb)-1 );
			echo $clTb;
		} else {
			$clTb = "";
			$result = explode(",", $SelColuns);
			foreach($result as $columns) {
				$clTb = $clTb . trim($columns) . ",";
			}
			$clTb = substr( $clTb, 0, strlen($clTb)-1 );
			echo "&columnsTable[1]=" . $clTb;
		}
		//E Data Select
	} else {
		echo "Invalid SqlQuery";
	}
	// E SELECT
	
	mysql_close($con);
	
// ## End - Access Granted
};
?>