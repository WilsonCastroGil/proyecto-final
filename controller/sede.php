<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

function guardarSede(){
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

}

function ActualizarSede(){
	if (isset($_POST['ActualizarSede'])) {

		$idSede =$_POST['idSede'];
		$idMunicipio = $_POST['idMunicipio'];
 		$nombre = $_POST['nombre'];
 		$direccion = $_POST['direccion'];
 		$telefono = $_POST['telefono'];	
 		$correo = $_POST['correo'];
 		$director = $_POST['director'];
 		$estado = 1;

 		$sql="UPDATE `sede` SET 
		`idMunicipio`='$idMunicipio',
		`nombre`='$nombre',
		`direccion`='$direccion',
		`telefono`='$telefono',
		`correo`='$correo',
		`director`='$director',
		`estado`='$estado'
		WHERE `idSede`='$idSede'";

 	    $exe = $createcon->query($sql);

		if ($exe) {
			echo "se guardo";
			# code...
		}else{
			echo "No es posible guardar la sede";
		}
	}
}
?>



