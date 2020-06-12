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

    <div class=" row mt-5">

        <div class="col mt-5">
            <div class="jumbotron bordes ">
                <h1 class="display-4 naranja">Bienvenido Instructor</h1>
                <p class="lead verde">Aquí podrás ver tu horario de instructor asignado.</p>
      
                

                <table  id="tinstructor" class=" table table-striped bordes w-auto h-auto">
                                    <thead class="bgverdea">
                                        <tr>
                                            <th class="text-light">Numero de ficha</th>
                                            <th class="text-light">Ambiente</th>
                                            <th class="text-light">Dia</th>
                                            <th class="text-light">Competencia</th>
                                            <th class="text-light">Instructor</th>
                                            <th class="text-light">Trimestre</th>
                                            <th class="text-light">Hora inicio</th>
                                            <th class="text-light">Hora fin</th>
                                        </tr>
                                    </thead>

                                    <?php

                                    $sql = "select * from v_detalleasignacion where Instructor ='".$_SESSION['user']."'";

                                    $exe = $createcon->query($sql);

                                    if ($exe->num_rows > 0) {

                                        $cont = 0;

                                        while ($res = $exe->fetch_row()) {
                                            echo '<tr><td>' . $res[0] . '</td><td>' . $res[1] . '</td><td>' . $res[2] . '</td><td>' . $res[3] . '</td><td>' . $res[4] . '</td><td>' . $res[5] . '</td><td>' . $res[6] . '</td><td>' . $res[7] . '</td></tr>';

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

</section>





