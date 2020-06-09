<<?php 
include('Conexion.php');
$con = New Conexion();
$createcon=$con->conectar();


	if (isset($_POST['ct_detaproject'])) {
		# code...
		$idActiProy = $_POST['idActiProy'];
		$idResultA = $_POST['idResultA'];
		$estado=1;

		$sql= "INSERT INTO detaproject values(null,'$idActiProy','$idResultA','$estado')";

		$exe = $createcon->query($sql);
	
		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {
				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}else{
			echo "No se puede guardar el resultado de Competencia";
		}

	}


 ?>