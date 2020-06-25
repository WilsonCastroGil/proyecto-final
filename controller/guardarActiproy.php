<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

 	if (isset($_POST['asignar'])) {

 		$opcion = 'guardar';

 		$nombre = $_POST['nombremat'];

 		$sql = "CALL sp_actiproy('$nombre','$opcion')";

 		$exe = $createcon->query($sql);
	
		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {
				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}else{
			echo "No es posible guardar la materia (actividad de proyecto)";
		}
	}

?>