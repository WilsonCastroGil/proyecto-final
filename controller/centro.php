<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

function guardarCentro(){
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
}

function actualizarCentro(){
	if (isset($_POST['actualizar'])) {

		$idCentro = $_POST['idCentro'];
		$idSede = $_POST['idSede'];
		$nombre = $_POST['nombre'];
		$direccion = $_POST['direccion'];
		$telefono = $_POST['telefono'];
		$correo = $_POST['correo'];
		$director = $_POST['director'];
		$estado = 1;


	   $sql = "update centro set `idSede` = '$idSede',`nombre` = '$nombre',`direccion` = '$direccion',
	   										`telefono` = '$telefono',`correo` = '$correo',`director` = '$director' where `idCentro` = '$idCentro'";


	   $exe = $createcon->query($sql);

	   if ($exe) {
		   echo "se actualizo";
		   # code...
	   }else{
		   echo "No es posible actualizar el centro";
	   }

   }

}

?>

