<?php
include('menu.inc');
include('../controller/Conexion.php');
$con = new Conexion();
$createcon = $con->conectar();
$createcon->set_charset("utf8");

if ($_SESSION["perfil"] != '0;1;0') {
    # Aseguramos desactivar todas las sesiones:
    session_unset();
    # Destruimos todos los archivos y variables de la sesion:
    session_destroy();
    # Destruimos los cookies del navegador para que al dar atrás no 
    $parametros_cookies = session_get_cookie_params();
    setcookie(session_name(), 0, 1, $parametros_cookies["path"]);
    # Actualizamos la pagina donde nos escontrabamos y redirigimos a la pagina princial
    echo "<meta http-equiv='refresh' content='0;'/>";
    header('location:cerrarsesion.php');
    exit;
}
?>

<script type="text/javascript">
    $(document).ready(function() {
        $('#tinstructor').DataTable();
    });
</script>


<script>
  window.onload=function(){
    var contenedor=document.getElementById('contenedor_carga');
    contenedor.style.visibility='hidden';
    contenedor.style.opacity='0';
  }

</script>

<div id="contenedor_carga">
<div id="carga">

</div>

</div>

<section class="container">

    <div class=" row ">

        <div class="col mt-5">
            <div class="jumbotron  bordes mx-auto config ">
                <h2 class="display-4 verde">Bienvenid@ Instructor <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto" width="100px" height="auto" enable-background="new 0 0 32 32" viewBox="0 0 32 32"><path d="M 9.5 0 A 3 3 0 0 0 6.5 3 A 3 3 0 0 0 9.5 6 A 3 3 0 0 0 12.5 3 A 3 3 0 0 0 9.5 0 z M 16 1 C 15.723633 1 15.5 1.2236328 15.5 1.5 L 15.5 6.2265625 C 14.490723 6.6549072 13.402771 7 12.5 7 L 6.5 7 L 6.421875 7 L 5 7 C 3.0703125 7 1.5 8.5859375 1.5 10.515625 L 1.5 17.5 C 1.5 18.328125 2.1713867 19 3 19 C 3.8286133 19 4.5 18.328125 4.5 17.5 L 4.5 10.515625 C 4.5 10.240234 4.7241211 10 5 10 L 5.5 10 L 5.5 20.5 L 5.5 21 L 5.5 30.5 C 5.5 31.328125 6.1713867 32 7 32 C 7.8286133 32 8.5 31.328125 8.5 30.5 L 8.5 23 L 10.5 23 L 10.5 30.5 C 10.5 31.328125 11.171387 32 12 32 C 12.828613 32 13.5 31.328125 13.5 30.5 L 13.5 21 L 13.5 20.5 L 13.5 9.921875 C 14.170593 9.829346 14.847534 9.6533203 15.5 9.4355469 L 15.5 13.5 C 15.5 13.776367 15.723633 14 16 14 L 30 14 C 30.276367 14 30.5 13.776367 30.5 13.5 L 30.5 1.5 C 30.5 1.2236328 30.276367 1 30 1 L 16 1 z M 16.5 2 L 29.5 2 L 29.5 13 L 16.5 13 L 16.5 9.0625 C 18.282593 8.3327026 19.705871 7.4154053 19.955078 7.25 C 20.645507 6.7910156 20.833496 5.8603516 20.375 5.1699219 C 19.91748 4.4804688 18.985352 4.2939453 18.294922 4.75 C 17.931275 4.9915771 17.277039 5.3814088 16.5 5.7695312 L 16.5 2 z M 22 3 C 21.723633 3 21.5 3.2236328 21.5 3.5 C 21.5 3.7763672 21.723633 4 22 4 L 28 4 C 28.276367 4 28.5 3.7763672 28.5 3.5 C 28.5 3.2236328 28.276367 3 28 3 L 22 3 z M 22 5 C 21.723633 5 21.5 5.2236328 21.5 5.5 C 21.5 5.7763672 21.723633 6 22 6 L 25 6 C 25.276367 6 25.5 5.7763672 25.5 5.5 C 25.5 5.2236328 25.276367 5 25 5 L 22 5 z "/></svg> <br> <?php echo "'".$_SESSION["user"]."'" ?> </h2>
                <p class="lead text-dark font-weight-bold h6">Aquí podrás ver tu horario asignado.</p>

                <div class="container-responsive">

                <table id="tinstructor" class=" table table-striped" >
                    <thead class="bgverdea">
                        <tr class="text-center">
                            <th class="text-light">#ficha</th>
                            <th class="text-light">Ambiente</th>
                            <th class="text-light">Dia</th>
                            <th class="text-light">Competencia</th>
                            <th class="text-light">Instructor</th>
                            <th class="text-light">Trimestre</th>
                            <th class="text-light">H.inicio</th>
                            <th class="text-light">H.fin</th>
                        </tr>
                    </thead>

                    <?php

                    $sql = "select * from v_detalleasignacion where Instructor ='" . $_SESSION['user'] . "'";

                    $exe = $createcon->query($sql);

                    if ($exe->num_rows > 0) {

                        $cont = 0;

                        while ($res = $exe->fetch_row()) {
                            echo '<tr class="text-center text-weight-bold h6"><td>' . $res[1] . '</td><td>' . $res[2] . '</td><td>' . $res[3] . '</td><td>' . $res[4] . '</td><td>' . $res[5] . '</td><td>' . $res[6] . '</td><td>' . $res[7] . '</td><td>' . $res[8] . '</td></tr>';

                            $count = $cont + 1;
                        }
                    } else {

                        echo  '<div class=" spinner-grow text-danger" role="status">
  
                </div>  <article class="text-danger"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario</article>';
                    }


                    ?>

                </table>


                </div>


            </div>

        </div>

    </div>



</section>
