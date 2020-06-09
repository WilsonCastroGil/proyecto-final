<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

 	if (isset($_POST['sede'])) {

 		$idMunicipio = $_POST['idMunicipio'];
 		$nombre = $_POST['nombre'];
 		$direccion = $_POST['direccion'];
 		$telefono = $_POST['telefono'];	
 		$correo = $_POST['correo'];
 		$director = $_POST['director'];
 		$estado = 1;

 		$sql = "insert into sede values(null,'$idMunicipio','$nombre','$direccion','$telefono','$correo','$director','$estado')";



 		$exe = $createcon->query($sql);

		if ($exe) {
			echo "se guardo";


			
			# code...
		}else{
			echo "No es posible guardar la sede";
		}

	}

?>




