<?php 
include('Conexion.php');
$con = New Conexion();
$createcon=$con->conectar();


	if (isset($_POST['ct_detaproject'])) {
		# code...
		$idActiProy = $_POST['idActiProy'];
		$idResultA = $_POST['idResultA'];
		$estado=1;

		$sql= "insert into detaproject values(null,'$idActiProy','$idResultA','$estado')";

		$exe = $createcon->query($sql);
	
		if ($exe) {
			echo "Se guardo";
			
		}else{
			echo "No se puede guardar el resultado de Competencia";
		}

	}


?>