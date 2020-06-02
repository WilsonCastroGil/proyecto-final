<?php  
	include('Conexion.php');
	$con = New Conexion();
 	$createcon=$con->conectar();

	if (isset($_POST['asignar'])) {

		$opcion = 'guardar';
		# code...
		$idFicha = $_POST['idFicha'];
		$idAmbiente = $_POST['idAmbiente'];
		$idDia = $_POST['idDia'];
		$idUsuario = $_POST['idUsuario'];
		$idActiProy = $_POST['idActiProy'];
		$periodo = $_POST['periodo'];
		$trimPeriodo = $_POST['trimperiodo'];
		$horaInicio = $_POST['horaInicio'];
		$horaFin = $_POST['horaFin'];

		$sql = "CALL sp_detalleasignacion(null,'$idFicha','$idAmbiente','$idDia','$idUsuario','$idActiProy','$periodo','$trimPeriodo','$horaInicio','$horaFin','$opcion')";

		$exe = $createcon->query($sql);
	
		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {
				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}else{
			echo "No es posible asignar este horario";
		}
	}
?>
