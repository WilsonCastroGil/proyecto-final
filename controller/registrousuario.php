<?php  
	include('Conexion.php');
	$con = New Conexion();
	$conectar=$con->conectar();

	// $sql = "SELECT * FROM usuario";
	// $exe = $conectar->query($sql);


function guardarUsuario(){
 		# code...
 		if (isset($_POST['resgistroUsuarios'])) {

		# code...
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
}	

function actualizarUsuario(){

	if (isset($_POST['actualizarUsuarios'])) {

        $documento  =$_POST['documento'];
		$idTipoDoc =$_POST['idTipoDoc'];
		$telefono  =$_POST['telefono'];
		$password = $_POST['contraseña'];
		$correo =$_POST['correo']; 
		$idTipoUsuario =$_POST['idTipoUsuario'];
		$estado =1;

		$sql = "call sp_ActualizarUsuario('$documento','$idTipoDoc','$telefono','$password','$correo','$idTipoUsuario','$estado')";

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

}


?>
