<?php 

include ('Conexion.php');

$con=new Conexion();

$createcon=$con->conectar();

$sql="select * from usuario";

	if (isset($_POST['dato'])) {


$sql="select * from usuario where correo like '%".$_POST['dato']."%'";

		$exe = $createcon->query($sql);

		if ($exe->num_rows > 0) {

			while ($res=$exe->fetch_row()) {
				echo '<tr><td>'.$res[0].'</td>
			        	<td>'.$res[1].'</td>
				  			<td>'.$res[2].'</td></tr>';
				
			}
		
		}
			else{

				echo "no se encontraron datos";

			}
	}


 ?>