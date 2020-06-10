<?php

function insertar_datos($v_idTipoDoc,$v_documento,$v_nombre,$v_apellido,$v_telefono,
 	$v_genero,$v_correo,$v_idTipoUsuario){

	require_once("conexion.php");

	$con = new Conexion();
	$conectar=$con->conectar();

 	$sql ="call sp_GuardarUsuario('$v_idTipoDoc','$v_documento','$v_nombre','$v_apellido','$v_telefono','$v_genero','$v_correo','$v_idTipoUsuario')";
	
	// print_r("<pre> ");
	// print_r($v_idTipoDoc);
	// print_r($v_documento);
	// print_r($v_nombre);
	// print_r($v_apellido);
	// print_r($v_telefono);
	// print_r($v_genero);
	// print_r($v_correo);
	// print_r($v_idTipoUsuario);
	// print_r("</pre>");
	try{
		$res = $conectar->query($sql);
 		return $res;
	}
	catch (Exception $e){
	  return False;
	}
 }
?>