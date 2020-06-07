<?php  
	include('Conexion.php');

	if (isset($_POST['btnopcion'])) {
		if ($_POST['btnopcion'] == 'guardar') {
			
			# Si es guardar entonces llamamos el sp multi proposito

			
			$con = New Conexion();
			$createcon=$con->conectar();
			 $createcon->set_charset("utf8");

		$idTipoDoc =$_POST['idTipoDoc'];
		$documento  =$_POST['documento'];
		$nombre =$_POST['nombre'];
		$apellido  =$_POST['apellido'];
		$telefono  =$_POST['telefono'];
		$genero =$_POST['genero'];
		$correo =$_POST['correo']; 
		$idTipoUsuario =$_POST['idTipoUsuario']; 
		$estado =1;

 		$sql="call sp_GuardarUsuario(
	 		'$idTipoDoc',
	 		'$documento',
	 		'$nombre',
	 		'$apellido', 
	 		'$telefono', 
	 		'$genero',
	 		'$correo',
	 		'$idTipoUsuario',
	 		'$estado')";



	$exe = $createcon->query($sql);

	
		// $exe = $con->query($sql);

		// print_r($_POST);
		if ($exe->num_rows > 0) {
			if ($res = $exe->fetch_row()) {

				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}
		else{

			echo "error, no se ha registrado";

		}


			
		}else{
			#si no, llamamos el procedimiento de la tabla
			
		}
	}
	
?>