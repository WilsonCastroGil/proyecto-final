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


		if ($exe->num_rows > 0) {
			if ($res = $exe->fetch_row()) {

				echo $res[0];

			}else{
				echo $con->error;
			}
			
		}
		else{

			echo "error, no se ha registrado ni actualizado";

		}



	}
			if ($_POST['btnopcion'] == 'actualizar') {

				# Si es guardar entonces llamamos el sp multi proposito
	
				$con = New Conexion();
				$createcon=$con->conectar();
				 $createcon->set_charset("utf8");
	
			$v_idTipoDoc =$_POST['idTipoDoc'];
			$v_documento  =$_POST['documento'];
			$v_telefono  =$_POST['telefono'];
			$v_correo =$_POST['correo']; 
			$v_nombre =$_POST['nombre'];
			$v_apellido  =$_POST['apellido'];
			$v_idTipoUsuario =$_POST['idTipoUsuario']; 
			$v_estado =1;

			 $sql="call sp_ActualizarUsuario(
				'$v_documento',
 				'$v_idTipoDoc',  
				 '$v_nombre',
				 '$v_apellido',
				'$v_telefono', 
				'$v_correo',
				'$v_idTipoUsuario', 
 				'$v_estado' )";
	
	
	
		$exe = $createcon->query($sql);
	
	
			if ($exe->num_rows > 0) {
				if ($res = $exe->fetch_row()) {
	
					echo $res[0];
	
				}else{
					echo $con->error;
				}

			}
			else{
	
				echo "error, no se ha registrado ni actualizado";
	
			}

			}


}else{
	echo "error";
}
