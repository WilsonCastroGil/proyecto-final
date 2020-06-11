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
            <div class="jumbotron mt-5 ">
                <h1 class="display-4 naranja">Bienvenido Instructor</h1>
                <p class="lead verde">Aquí podrás ver tu horario de instructor designado presionando el boton "ver mi horario semanal".</p>
                <hr class="my-4">
                <p class="verde">It uses utility classes for typography and spacing to space content out within the larger container.</p>

                <!-- Button trigger modal -->
                <button type="button" class="btn btn-verde w-25 h-25" data-toggle="modal" data-target="#modalinstructor">
                    <svg class="w-25 h-25" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 511.999 511.999" style="enable-background:new 0 0 511.999 511.999;" xml:space="preserve">
                        <g>
                            <g>
                                <path d="M302.195,11.833H13.049C5.842,11.833,0,17.675,0,24.882v214.289c0,7.207,5.842,13.049,13.049,13.049h283.839
			l-34.352-21.329c-2.247-1.396-4.282-3.002-6.109-4.768H26.097V37.93h263.049v126.703c4.01,0.847,7.943,2.39,11.625,4.677
			l14.473,8.986V24.882C315.244,17.675,309.402,11.833,302.195,11.833z" />
                            </g>
                        </g>
                        <g>
                            <g>
                                <path d="M216.857,134.337c-4.352-3.43-10.665-2.685-14.097,1.668c-3.432,4.353-2.686,10.665,1.668,14.097l44.279,34.914
			c0.63-1.371,1.34-2.719,2.156-4.034c2.883-4.643,6.649-8.401,10.94-11.206L216.857,134.337z" />
                            </g>
                        </g>
                        <g>
                            <g>
                                <circle cx="419.71" cy="81.405" r="37.557" />
                            </g>
                        </g>
                        <g>
                            <g>
                                <path d="M511.33,173.609c-0.118-23.528-19.355-42.67-42.884-42.67H450.26c-17.831,46.242-11.329,29.381-22.507,58.37l4.709-23.724
			c0.346-1.744,0.067-3.555-0.79-5.113l-7.381-13.424l6.551-11.914c0.454-0.826,0.438-1.829-0.041-2.64
			c-0.479-0.811-1.352-1.308-2.293-1.308h-17.96c-0.942,0-1.813,0.497-2.293,1.308s-0.495,1.815-0.041,2.64l6.537,11.889
			l-7.367,13.4c-0.873,1.589-1.147,3.438-0.77,5.211l5.438,23.675c-3.119-8.087-21.08-52.728-23.255-58.37h-17.83
			c-23.529,0-42.766,19.141-42.884,42.67c-0.098,19.565-0.016,3.179-0.17,33.884l-36.702-22.787
			c-8.501-5.28-19.674-2.667-24.953,5.836c-5.279,8.503-2.666,19.675,5.836,24.954l64.219,39.873
			c12.028,7.47,27.609-1.167,27.68-15.304c0.036-7.091,0.292-57.809,0.334-66.275c0.013-2.092,1.714-3.776,3.805-3.769
			c2.089,0.007,3.779,1.703,3.779,3.794c-0.018,87.323-0.394,111.735-0.394,304.606c0,12.01,9.736,21.746,21.746,21.746
			s21.746-9.736,21.746-21.746V304.604h9.388v173.817c0,12.01,9.736,21.746,21.746,21.746s21.746-9.736,21.746-21.746l0.008-304.612
			c0-1.981,1.604-3.589,3.586-3.595c1.981-0.006,3.595,1.594,3.605,3.577l0.669,133.132c0.05,9.977,8.154,18.03,18.119,18.03
			c0.031,0,0.062,0,0.094,0c10.007-0.05,18.081-8.205,18.03-18.212L511.33,173.609z" />
                            </g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                        <g>
                        </g>
                    </svg>
                    <br>
                    Ver mi horario semanal
                </button>

                <!-- Modal -->
                <div class="modal fade" id="modalinstructor" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalCenterTitle">
                                <?php    
                               echo $_SESSION["user"].'   este es tu horario';
                                ?>
                                </h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <table id="tinstructor" class="table-striped table-dark display " width="100%" height="200px">
                                    <thead class="bg-success verde">
                                        <tr>
                                            <th>Numero de ficha</th>
                                            <th>Ambiente</th>
                                            <th>Dia</th>
                                            <th>Nombre Comp</th>
                                            <th>Instructor</th>
                                            <th>Trimestre</th>
                                            <th>Hora inicio</th>
                                            <th>Hora fin</th>
                                        </tr>
                                    </thead>

                                    <?php

                                    $sql = "select * from v_detalleasignacion where dia ='martes'";

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
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary">Save changes</button>
                            </div>
                        </div>
                    </div>
                </div>



                </a>
            </div>

        </div>

    </div>

</section>