<?php  
	include('Conexion.php');
	$con = New Conexion();
	$conectar=$con->conectar();

if (isset($_POST['registroAprendiz'])) {

		
		$idTipoDoc =$_POST['idTipoDoc'];
		$documento  =$_POST['documento'];
		$nombre =$_POST['nombre'];
		$apellido  =$_POST['apellido'];
		$telefono  =$_POST['telefono'];
		$genero =$_POST['genero'];
		$correo =$_POST['correo']; 
		$idFicha =$_POST['idficha'];
		$jornada =$_POST['jornada'];
		

		$sql="call ps_RegistroAprendiz(
	 		'$idTipoDoc',
	 		'$documento',
	 		'$nombre',
	 		'$apellido', 
	 		'$telefono', 
	 		'$genero',
	 		'$correo',
			'$idFicha',
			'$jornada')";


		// $exe = $con->query($sql);
		$exe = $conectar->query($sql);

		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {

				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}else{

			echo "error, no hay datos";

		}
	
	}	



?>