<?php 
	
	include('Conexion.php');
	$con = New Conexion();
	$conectar=$con->conectar();

function guardarCompetencia(){
	if (isset($_POST['btnopcion'])) { 

		if ($_POST['btnopcion'] == 'guardar'){

		

	   $idPrograma =$_POST['idPrograma'];
	   $nombre =$_POST['nombrecomp'];
	   $codigo =$_POST['codigocomp'];
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
	}
}

function actualizarCompetencia(){
	if (isset($_POST['btnopcion'])) { 

		if ($_POST['btnopcion'] == 'actualizarComp'){

		

	   $idCompetencia =$_POST['idCompetencia'];
	   $idPrograma = $_POST['idPrograma'];
	   $nombre =$_POST['nombrecomp'];
	   $codigo =$_POST['codigocomp'];
	   $estado = 1;
	   $opcion ='actualizar';



	   $sql="call sp_competencia(
		'$idCompetencia',
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
	
	}
}
	
?>	




