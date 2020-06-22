<?php

function insertar_datos($v_idTipoDoc,$v_documento,$v_nombre,$v_apellido,$v_telefono,$v_genero,$v_correo,$v_idFicha,$v_jornada){


		if ($v_idTipoDoc=="CC") {
			# code...
			$v_idTipoDoc=1;
		}elseif ($v_idTipoDoc=="TI") {
			# code...
			$v_idTipoDoc=2;
		}	

	// print_r("<pre> ");
	// print_r($v_idTipoDoc);
	// print_r($v_documento);
	// print_r($v_nombre);
	// print_r($v_apellido);
	// print_r($v_telefono);
	// print_r($v_genero);
	// print_r($v_correo);
	// print_r($v_idFicha);
	// print_r($v_jornada);
	// print_r("</pre>");

	require_once("conexion.php");

$con = new Conexion();
	$conectar=$con->conectar();

 	$sql ="call ps_RegistroAprendiz('$v_idTipoDoc','$v_documento','$v_nombre','$v_apellido','$v_telefono','$v_genero','$v_correo','$v_idFicha','$v_jornada')";

#print_r($sql);
	try{
		$res = $conectar->query($sql);
 		return $res;
	}
	catch (Exception $e){
	  return False;
	}
  }	


  function insertarDocentes($v_idTipoDoc,$v_documento,$v_nombre,$v_apellido,$v_telefono,$v_genero,$v_correo){


		if ($v_idTipoDoc=="CC") {
			# code...
			$v_idTipoDoc=1;
		}elseif ($v_idTipoDoc=="TI") {
			# code...
			$v_idTipoDoc=2;
		}	

	// print_r("<pre> ");
	// print_r($v_idTipoDoc);
	// print_r($v_documento);
	// print_r($v_nombre);
	// print_r($v_apellido);
	// print_r($v_telefono);
	// print_r($v_genero);
	// print_r($v_correo);
	// print_r($v_idFicha);
	// print_r($v_jornada);
	// print_r("</pre>");

	require_once("conexion.php");

$con = new Conexion();
	$conectar=$con->conectar();

 	$sql ="call sp_GuardarDocente('$v_idTipoDoc','$v_documento','$v_nombre','$v_apellido','$v_telefono','$v_genero','$v_correo')";

#print_r($sql);
	try{
		$res = $conectar->query($sql);
 		return $res;
	}
	catch (Exception $e){
	  return False;
	}
  }	
?> 