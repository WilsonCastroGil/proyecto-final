<?php  
  session_start();
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

	# Ejecutamos la consulta:
	$res=$exe->fetch_row();

	
      if($exe->num_rows>0 and $res[0]!='error'){
	
			# Si el resultado me trae mas de una fila y no me devuelve el mesaje 'error' entonces:


	
			#ponemos explode para separar los elementos traidos en el array por el simbolo ';'
	
	$resultado=explode(';',$res[0]);
	$_SESSION["user"]=$resultado[0];

	#el item del array en posicion 0 es el usuario

	$admin=$resultado[1];
	$instructor=$resultado[2];
	$aprendiz=$resultado[3];


	if($admin || $instructor || $aprendiz){

		if($admin == 1 ){
			$perfil="Admin";
			$_SESSION["perfil"] = $admin.';'.$instructor.';'.$aprendiz;

		}

		if($instructor == 1){
			$perfil= "Instructor";
			$_SESSION["perfil"] = $admin.';'.$instructor.';'.$aprendiz;
		}

		if($aprendiz == 1) {
			$perfil= "Aprendiz";
			$_SESSION["perfil"] = $admin.';'.$instructor.';'.$aprendiz;
		}
	}


	

	

// 	print_r($_POST);
// print_r($_SESSION);

echo "1";
// // echo $_SESSION["user"]." ".$_SESSION["perfil"]." ha iniciado sesion";



	}
	else{
		echo "Error, el usuario no se encuentra";
		}
	}


?>