<?php
include('Conexion.php');
$con = new Conexion();
$createcon = $con->conectar();

if (isset($_POST['btnopcion'])) {

	if ($_POST['btnopcion'] == 'guardar') {
		# code...

			
		$opcion = 'guardar';

		$idPrograma = $_POST['idPrograma'];
		$fechaInicio = $_POST['fechaInicio'];
		$fechaFin = $_POST['fechaFin'];
		$cantidadAprendiz = $_POST['cantidadAprendiz'];
		$numeroFicha = $_POST['numeroFicha'];


		$sql = "call sp_ficha('$idPrograma','$fechaInicio', '$fechaFin','$cantidadAprendiz','$numeroFicha','$opcion')";

		$exe = $createcon->query($sql);

		

		if ($exe->num_rows > 0) {
			if ($res = $exe->fetch_row()) {
				echo $res[0];
				# code...
			} else {
				echo $con->error;
			}
			# code...
		} else {
			echo "No es posible guardar la ficha";
		}
	}
}
