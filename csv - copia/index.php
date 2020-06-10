
<?php


if (isset($_POST["enviar"])) {//nos permite recepcionar una variable que si exista y que no sea null
	//include('Conexion.php');
	 //$con = New Conexion();
	//$conectar=$con->conectar();
	require_once("conexion.php");
	require_once("functions.php");

	$archivo = $_FILES["archivo"]["name"];
	$archivo_copiado= $_FILES["archivo"]["tmp_name"];
	$fecha=getdate();
	#$archivo_guardado= "copia_".$archivo;
	$archivo_guardado=$fecha["mday"]."-".$fecha["mon"]."-".$fecha["year"]."_".$fecha["hours"]."-".$fecha["minutes"]."-".$fecha["seconds"]."_".$archivo;

	$con = new Conexion();
	$conectar=$con->conectar();
	//cho $archivo."esta en la ruta temporal: " .$archivo_copiado;

	if (copy($archivo_copiado ,$archivo_guardado )) {
		echo "se copio correctamente el archivo temporal a nuestra carpeta de trabajo <br/>";
	}else{
		echo "hubo un error <br/>";
	}
    
    if (file_exists($archivo_guardado)) {
    	 
    	 $fp = fopen($archivo_guardado,"r");//abrir un archivo
    	 $data=array();
         $rows = 0;

         while ($datos = fgetcsv($fp , 1000 , ";")) {
         	    $rows ++;	
         	  #echo $datos[0];
         	    # echo $datos[0] ." ".$datos[1] ." ".$datos[2]." ".$datos[3] ." ".$datos[4] ." ".$datos[5] ." ".$datos[6] ." ".$datos[7] ."<br/>";
         	
         	if ($rows > 1) {

         		#$sql ="call sp_GuardarUsuario('$datos[0]','$datos[1]','$datos[2]','$datos[3]','$datos[4]','$datos[5]','$datos[6]','$datos[7]')";
         		
         		#$res = $conectar->query($sql);
         		# $row = $res->fetch_object();
         		#var_dump($res);
         		$resultado = insertar_datos($datos[0],$datos[1],$datos[2],$datos[3],$datos[4],$datos[5],$datos[6],$datos[7]);

				 #$data[]='('.$datos[0].',"'.$datos[1].'","'.$datos[2].'","'.$datos[3].'","'.$datos[4].'","'.$datos[5].'","'.$datos[6].'",'.$datos[7].')'; 
         	
				#print_r($res)
				if($resultado){
	         		echo "se inserto los datos correctamnete<br/>";
	         	}else{
	         		echo "no se inserto <br/>";
	         	}

			}

	 	}
	 

    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Dubir archivo a la BD mysql</title>
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	 
	 <div class="formulario">
	 	<form action="index.php" class="formulariocompleto" method="post" enctype="multipart/form-data">
	 		 <input type="file" name="archivo" class="form-control"/>

<select>jornada 
			<option value="1800">
				1800890
			</option>

			<option>
				31252
			</option>

	 		</select>

	 		<select>ficha 
			<option value="1800">
				1800890
			</option>

			<option>
				31252
			</option>

	 		</select>



	 		<input type="submit" value="SUBIR ARCHIVO" class="form-control" name="enviar">
	 		
	 	</form>
	 </div>
</body>
</html>
