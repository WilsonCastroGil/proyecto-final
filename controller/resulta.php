<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

 	if (isset($_POST['resulta'])) {

 		$opcion = 'Guardar';

 		$idTrimestre = $_POST['idTrimestre'];
 		$idCompetencia = $_POST['idCompetencia'];
 		$nombre = $_POST['nombre'];
 		$codigocom = $_POST['codigocom'];
 		$estado = 1;

 		$sql = "CALL sp_resulta(null,'$idTrimestre','$idCompetencia','$nombre','$codigocom','$estado','$opcion')";

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