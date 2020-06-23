<?php  
	include('Conexion.php');
	$con = New Conexion();
 $createcon=$con->conectar();

function guardarActiProy(){
 	if (isset($_POST['actiProy'])) {

 		$opcion = 'guardar';

 		$nombre = $_POST['nombre'];

 		$sql = "CALL sp_actiproy('$nombre','$opcion')";

 		$exe = $createcon->query($sql);
	
		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {
				echo $res[0];
			}else{
				echo $con->error;
			}
			
		}else{
			echo "No es posible guardar la actividad de proyecto";
		}
	}
}

function actualizarActiProy(){
	if (isset($_POST['actualizar'])) {

		$opcion = 'actualizar';
		$idActiProy = $_POST['idActiProy'];
		$nombre = $_POST['nombre'];
		

		$sql = "CALL sp_actiproy('$idActiProy','$nombre','$opcion')";

		$exe = $createcon->query($sql);
   
	   if ($exe ->num_rows > 0) {
		   if ($res = $exe->fetch_row()) {
			   echo $res[0];
		   }else{
			   echo $con->error;
		   }
		   
	   }else{
		   echo "No es posible actualizar la actividad de proyecto";
	   }
   }

}

?>