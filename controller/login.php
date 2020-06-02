<?php  

	# Si oprimimos el boton de loginuser, vamos a validar el ingreso:
if (isset($_POST['btnlogin'])){
		# Incluyo la conexion a la base de datos:
	     // print_r($_POST);
	require('Conexion.php');



	$con = New Conexion();
	$createcon=$con->conectar();
	 $createcon->set_charset("utf8");

		# Capturo los datos del formulario:
	$user = $_POST['usuario'];
	$pass = $_POST['passuser'];

		# Estructuramos la consulta SQL:
	$sql = "call sp_login('".$user."','".$pass."')";
	$exe = $createcon->query($sql);


	$res=$exe->fetch_row();
		# Ejecutamos la consulta:
	if ($res[0]!='null' ) {
			# Si el resultado me trae mas de una fila entonces:


	
	
	$resultado=explode(';',$res[0]);
	$_SESSION["user"]=$resultado[0];

	$perfil=$resultado[1];

	switch ($perfil) {
		case 'Admin':

		$_SESSION["perfil"]='Admin';
			# code...
			break;

		case 'Instructor':

		$_SESSION["perfil"]='Instructor';
			# code...
			break;
		
			case 'Aprendiz':

		$_SESSION["perfil"]='Aprendiz';
			# code...
			break;	

	}

	
// print_r($_SESSION);
echo  "1";
// echo $_SESSION["user"]." ".$_SESSION["perfil"]." ha iniciado sesion";



	}else{
		echo "Error, el usuario no se encuentra";
		}
	}




?>

