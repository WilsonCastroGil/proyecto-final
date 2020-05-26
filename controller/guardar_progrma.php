<<?php 
	include('Conexion.php');
	$con = New Conexion();
	$conectar=$con->conectar();



	if (isset($_POST['guardarProgrma'])) {
		# code...
	 	$idCentro =$_POST['idCentro'];
	  	$nombre =$_POST['nombre'];
	   	$tipoFormacion =$_POST['tipoFormacion'];
	    $estado=1;
	    $opcion='guardar';

	    #llamamos  un procedimiento almacena
	    #que va a guardar datos en la tabla
	    #programa

		$sql="call sp_programa(
			'$idCentro',
			'$nombre',
			'$tipoFormacion',
			'$estado',
			'$opcion')";

		#comprovamos que la bd si nos debuelva el mensaje
		$exe = $conectar->query($sql);

		if ($exe ->num_rows > 0) {
			if ($res = $exe->fetch_row()) {

				echo $res[0];
			}else{
				echo $con->error;
			}
		}else{

			echo "Error, 	No hay Conexion a la base de  datos";

		}
	
	}
 ?>