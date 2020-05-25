<?php  
	# Si oprimimos el boton de loginuser, vamos a validar el ingreso:
if (isset($_POST['btnlogin'])){
		# Incluyo la conexion a la base de datos:
	     // print_r($_POST);
	require('Conexion.php');

	$con = New Conexion();
	$createcon=$con->conectar();

		# Capturo los datos del formulario:
	$user = $_POST['usuario'];
	$pass = $_POST['passuser'];

		# Estructuramos la consulta SQL:
	$sql = "SELECT * FROM login WHERE correo = '$user' and password = '$pass'";
	$exe = $createcon->query($sql);

		# Ejecutamos la consulta:
	if ($exe ->num_rows > 0) {
			# Si el resultado me trae mas de una fila entonces:
		session_start();
		while($res = $exe->fetch_row()){
			$perfil = $res[3];
			$estado = $res[4];
		}
			# Definimos variables de sesión para el control del formulario:
		$_SESSION['logged'] = 1;
		$_SESSION['usuario'] = $res[1];

		echo $_SESSION['logged'];

	}else{
		echo "Error, el usuario no se encuentra";
	}
}
else 
}

}

?>

