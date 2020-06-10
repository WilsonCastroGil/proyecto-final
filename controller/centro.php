<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

 	if (isset($_POST['centro'])) {

 		$idSede = $_POST['idSede'];
 		$nombre = $_POST['nombre'];
 		$direccion = $_POST['direccion'];
 		$telefono = $_POST['telefono'];
 		$correo = $_POST['correo'];
 		$director = $_POST['director'];
 		$estado = 1;


		$sql = "insert into centro values (null,'$idSede','$nombre','$direccion','$telefono','$correo','$director','$estado')";


		$exe = $createcon->query($sql);

		if ($exe) {
			echo "se guardo";
			# code...
		}else{
			echo "No es posible guardar el centro";
		}

	}

?>

