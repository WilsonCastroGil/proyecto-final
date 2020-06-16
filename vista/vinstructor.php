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
    header('location:login.php');
    exit;
}
?>

<script type="text/javascript">
    $(document).ready(function() {
        $('#tinstructor').DataTable();
    });
</script>

<section class="container">

    <div class=" row ">

        <div class="col mt-5">
            <div class="jumbotron bordes mx-auto ">
                <h1 class="display-4 naranja">Bienvenido Instructor</h1>
                <p class="lead text-dark h6">Aquí podrás ver tu horario de instructor asignado.</p>

                <div class="container-responsive">

                <table id="tinstructor" class=" table table-responsive table-striped" >
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
                            echo '<tr class="text-center h6"><td>' . $res[0] . '</td><td>' . $res[1] . '</td><td>' . $res[2] . '</td><td>' . $res[3] . '</td><td>' . $res[4] . '</td><td>' . $res[5] . '</td><td>' . $res[6] . '</td><td>' . $res[7] . '</td></tr>';

                            $count = $cont + 1;
                        }
                    } else {

                        echo "no se encontraron datos";
                    }


                    ?>

                </table>


                </div>


            </div>

        </div>

    </div>



</section>
<div class="row-12 mb-0 ">

    <footer class="page-footer font-small teal pt-2 bgverdea h-25">

        <!-- Footer Text -->
        <div class="container-fluid text-center ">

            <!-- Grid row -->
            <div class="row">

                <!-- Grid column -->
                <div class="col-md-12 mt-md-4 mt-3">

                    <!-- Content -->
                    <h5 class="text-uppercase font-weight-bold "></h5>


                </div>
                <!-- Grid column -->



            </div>
            <!-- Grid row -->

        </div>
        <!-- Footer Text -->


    </footer>
    <!-- Footer -->


</div>