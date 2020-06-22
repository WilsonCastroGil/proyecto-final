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
                <h1 class="display-4 naranja">Bienvenido Instructor <?php echo "'".$_SESSION["user"]."'" ?> </h1>
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
<footer class="page-footer font-small teal p-1 footer  ">

		<!-- Footer Text -->
		<div class="container-fluid text-center text-md-left">
		<div class="row-12 text-center ">

<h6>copyright sena 2020</h6>

</div>
			<!-- Grid row -->
			<div class="row config">

				<!-- Grid column -->
				<div class="col-md-6 mt-md-0 mt-3">

					<!-- Content -->
					<h6 class="text-uppercase font-weight-bold ">Aviso</h6>
					<p>
						recuerde que su usuario es el correo @misena y su contraseña es el documento con el cual está registrado en la institucion
					</p>

				</div>
				<!-- Grid column -->

				<hr class="clearfix w-100 d-md-none pb-3">

				<!-- Grid column -->
				<div class="col-md-6 mb-md-0 mb-3">

					<!-- Content -->
					<h6 class="text-uppercase font-weight-bold ">¡Recuerda!</h6>
					<p>Solo puedes tener un perfil activo en caso de tener mas de 1,
						si tienes problemas para visualiar tu horario debes filtrar los resultados ,
						así la visualizacion es mas fácil.</p>

				</div>
				<!-- Grid column -->

			</div>

			
			<!-- Grid row -->

		</div>
		<!-- Footer Text -->

		<!-- Copyright -->

		<!-- Copyright -->

	</footer>
