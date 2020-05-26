<?php 
	
	include('Conexion.php');
	$con = New Conexion();
	$conectar=$con->conectar();

	if (isset($_POST['registrarCompetencia'])) {

	   $idPrograma =$_POST['idPrograma'];
	   $nombre =$_POST['nombre'];
	   $codigo =$_POST['codigo'];
	   $estado =1;
	   $opcion ='guardar';


	   $sql="call sp_competencia(
	   	'$idPrograma',
	   	'$nombre',
	   	'$codigo',
	   	'$estado', 
	   	'$opcion')";

		# code...

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