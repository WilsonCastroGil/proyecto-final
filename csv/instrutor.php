<?php
if (isset($_POST["guardar"])) {//nos permite recepcionar una variable que si exista y que no sea null
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
         #$data=array();
         $rows = 0;

        while ($datos = fgetcsv($fp , 1000 , ";")) {
            $rows ++;   
              #echo $datos[0];
                # echo $datos[0] ." ".$datos[1] ." ".$datos[2]." ".$datos[3] ." ".$datos[4] ." ".$datos[5] ." ".$datos[6] ." ".$datos[7] ."<br/>";

            if ($rows > 1) {
                $resultado = insertarDocentes(
                    $datos[0],
                    $datos[1],
                    utf8_decode($datos[2]),
                    utf8_decode($datos[3]),
                    utf8_decode($datos[4]),
                    utf8_decode($datos[5]),
                    utf8_decode($datos[6]));

                #print_r($_POST);
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
    <body>
        <div class="formulario">
            <form action="instructor.php" class="formulariocompleto" method="post" enctype="multipart/form-data">
                <input type="file" name="archivo" class="form-control"/>
                <input type="submit" value="SUBIR ARCHIVO" class="form-control" name="guardar">
            </form>
            <div>
            <form action="index.php">
                <button>
                  Registrar Aprendiz
                </button>
              </form>

            </div>
        </div>
    </body>
    </html>