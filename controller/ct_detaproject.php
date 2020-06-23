<?php 
include('Conexion.php');
$con = New Conexion();
$createcon=$con->conectar();

function guardarDetaProject(){
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
}

function actualizarDetaProject(){
	if (isset($_POST['actualizar'])) {
		# code...
		$iddetaProject = $_POST['iddetaProject'];
		$idActiProy = $_POST['idActiProy'];
		$idResultA = $_POST['idResultA'];
		$estado=1;

		$sql= "update detaproject set `idActiProy` = '$idActiProy', `idResultA` = '$idResultA' where `iddetaProject` = '$iddetaProject'";

		$exe = $createcon->query($sql);
	
		if ($exe) {
			echo "Se actualizo";
			
		}else{
			echo "No se puede actualizar el resultado de Competencia";
		}

	}
}

?>