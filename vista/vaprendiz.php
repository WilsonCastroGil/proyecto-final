<?php

include('menu.inc');

include('../controller/Conexion.php');
$con = new Conexion();
$createcon = $con->conectar();
$createcon->set_charset("utf8");
print_r($_SESSION);
// error_reporting(0);

if ($_SESSION["perfil"] != '0;0;1') {
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

<!-- <script type="text/javascript">
  $(document).ready(function() {
    $('#tsemana.display').DataTable();
  });
</script> -->

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


<section class="container mt-2 p-5">


  <div class="row ">



  

     <h3 class=" text-center row-12 naranja mb-3"> Tu horario:<svg class="bi bi-stopwatch" width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" d="M8 15A6 6 0 1 0 8 3a6 6 0 0 0 0 12zm0 1A7 7 0 1 0 8 2a7 7 0 0 0 0 14z"/>
      <path fill-rule="evenodd" d="M8 4.5a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-.5.5H4.5a.5.5 0 0 1 0-1h3V5a.5.5 0 0 1 .5-.5zM5.5.5A.5.5 0 0 1 6 0h4a.5.5 0 0 1 0 1H6a.5.5 0 0 1-.5-.5z"/>
      <path d="M7 1h2v2H7V1z"/>
    </svg></h3>
    <div class="table-responsive row-md-12 bordes config p-2">


      <ul class="nav nav-tabs text-center md-5 mt-3  " id="myTab" role="tablist">
        <li class="nav-item col-md-2 ">
          <a class="nav-link btn-verde bordes2 " id="home-tab" data-toggle="tab" href="#lunes" role="tab" aria-controls="home" aria-selected="false">LUNES</a>
        </li>
        <li class="nav-item col-md-2">
          <a class="nav-link btn-verde bordes2" id="profile-tab" data-toggle="tab" href="#Martes" role="tab" aria-controls="profile" aria-selected="false">MARTES</a>
        </li>
        <li class="nav-ite col-md-2">
          <a class="nav-link btn-verde bordes2" id="contact-tab" data-toggle="tab" href="#Miercoles" role="tab" aria-controls="contact" aria-selected="false">MIERCOLES</a>
        </li>
        <li class="nav-item col-md-2">
          <a class="nav-link btn-verde  bordes2" id="home-tab" data-toggle="tab" href="#Jueves" role="tab" aria-controls="home" aria-selected="false">JUEVES</a>
        </li>
        <li class="nav-item col-md-2">
          <a class="nav-link btn-verde bordes2 " id="home-tab" data-toggle="tab" href="#Viernes" role="tab" aria-controls="home" aria-selected="false">VIERNES</a>
        </li>
        <li class="nav-item col-md-2">
          <a class="nav-link btn-verde  bordes2" id="home-tab" data-toggle="tab" href="#Sabado" role="tab" aria-controls="home" aria-selected="false">SABADO</a>
        </li>
      </ul>
      <div class="tab-content " id="myTabContent">
        <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
        </div>
        <div class="tab-pane fade" id="lunes" role="tabpanel" aria-labelledby="profile-tab">
          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('" . $_SESSION["user"] . "','lunes')";

            $exe = $createcon->query($sql);

            if ($exe->num_rows > 0) {

              $cont = 0;

              while ($res = $exe->fetch_array()) {
                echo '<tr class="text-center font-weight-bold">
                <td>' . $res[0] . '</td>
                <td>' . $res[3] . '</td>
                <td>' . $res[4] . '</td>
                <td>' . $res[2] . '</td>
                <td>' . $res[5] . '</td>
                <td>' . $res[6] . '</td>
                <td>' . $res[7] . '</td>
                </tr>';

                $count = $cont + 1;
              }
            } else {

              echo  '<div class=" spinner-grow text-danger" role="status">

              </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            }


            ?>

          </table>
        </div>
        <div class="tab-pane fade" id="Martes" role="tabpanel" aria-labelledby="contact-tab">
          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('" . $_SESSION["user"] . "','martes')";

            $exe = $createcon->query($sql);

            if ($exe->num_rows > 0) {

              $cont = 0;

              while ($res = $exe->fetch_row()) {
                echo '<tr class="text-center font-weight-bold">
                <td>' . $res[0] . '</td>
                <td>' . $res[3] . '</td>
                <td>' . $res[4] . '</td>
                <td>' . $res[2] . '</td>
                <td>' . $res[5] . '</td>
                <td>' . $res[6] . '</td>
                <td>' . $res[7] . '</td>
                </tr>';

                $count = $cont + 1;
              }
            } else {

              echo  '<div class=" spinner-grow text-danger" role="status">

              </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            }

            ?>

          </table>
        </div>
        <div class="tab-pane fade" id="Miercoles" role="tabpanel" aria-labelledby="contact-tab">
          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('" . $_SESSION["user"]. "','miercoles')";

            $exe = $createcon->query($sql);

            if ($exe->num_rows > 0) {

              $cont = 0;

              while ($res = $exe->fetch_row()) {
                echo '<tr class="text-center font-weight-bold">
                <td>' . $res[0] . '</td>
                <td>' . $res[3] . '</td>
                <td>' . $res[4] . '</td>
                <td>' . $res[2] . '</td>
                <td>' . $res[5] . '</td>
                <td>' . $res[6] . '</td>
                <td>' . $res[7] . '</td>
                </tr>';

                $count = $cont + 1;
              }
            } else {

              echo  '<div class=" spinner-grow text-danger" role="status">

              </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            }


            ?>

          </table>
        </div>
        <div class="tab-pane fade" id="Jueves" role="tabpanel" aria-labelledby="contact-tab">
          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('".$_SESSION["user"]."','jueves')";

     

            $exe = $createcon->query($sql);

            print_r($res = $exe->row[0]);

            // if ($exe->num_rows > 0) {

             

            //   $cont = 0;

            //   while ($res = $exe->fetch_row()) {
            //     echo '<tr class="text-center font-weight-bold">
            //     <td>' . $res[0] . '</td>
            //     <td>' . $res[3] . '</td>
            //     <td>' . $res[4] . '</td>
            //     <td>' . $res[2] . '</td>
            //     <td>' . $res[5] . '</td>
            //     <td>' . $res[6] . '</td>
            //     <td>' . $res[7] . '</td>
            //     </tr>';

            //     $count = $cont + 1;
            //   }
            // } else {

            //   echo  '<div class=" spinner-grow text-danger" role="status">

            //   </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            // }


            ?>

          </table>
        </div>
        <div class="tab-pane fade" id="Viernes" role="tabpanel" aria-labelledby="contact-tab">
          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('" . $_SESSION["user"] . "','viernes')";

            $exe = $createcon->query($sql);

            if ($exe->num_rows > 0) {

              $cont = 0;

              while ($res = $exe->fetch_row()) {
                echo '<tr class="text-center font-weight-bold">
                <td>' . $res[0] . '</td>
                <td>' . $res[3] . '</td>
                <td>' . $res[4] . '</td>
                <td>' . $res[2] . '</td>
                <td>' . $res[5] . '</td>
                <td>' . $res[6] . '</td>
                <td>' . $res[7] . '</td>
                </tr>';

                $count = $cont + 1;
              }
            } else {

              echo  '<div class=" spinner-grow text-danger" role="status">

              </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            }


            ?>

          </table>

        </div>
        <div class="tab-pane fade" id="Sabado" role="tabpanel" aria-labelledby="contact-tab">

          <table id="tsemana" class="table table-striped display " width="100%" height="100%">
            <thead class=" bgverdea">
              <tr class="text-light text-center bgverdea font-weight-bold">
                <th># de ficha</th>
                <th>Competencia</th>
                <th>Instructor</th>
                <th>Dia</th>
                <th>Trimestre</th>
                <th>H inicio</th>
                <th>H fin</th>
              </tr>
            </thead>

            <?php

            $sql = "call aprendiz ('" . $_SESSION["user"] . "','sabado')";

            $exe = $createcon->query($sql);

            if ($exe->num_rows > 0) {

              $cont = 0;

              while ($res = $exe->fetch_row()) {
                echo '<tr class="text-center font-weight-bold">
                <td>' . $res[0] . '</td>
                <td>' . $res[3] . '</td>
                <td>' . $res[4] . '</td>
                <td>' . $res[2] . '</td>
                <td>' . $res[5] . '</td>
                <td>' . $res[6] . '</td>
                <td>' . $res[7] . '</td>
                </tr>';

                $count = $cont + 1;
              }
            } else {

              echo  '<div class=" spinner-grow text-danger" role="status">

              </div>  <article class="text-dark font-weight-bold"> ¡ERROR! no se encontraron datos, puede deberse a que no tiene aun asignado un horario en este dia</article>';
            }


            ?>

          </table>

        </div>
      </div>


    </div>



    <div class="container mt-5 bordes config p-3">
      <h1 class=" verde">¡BIENVENID@! <?php echo $_SESSION["user"];  ?><svg xmlns="http://www.w3.org/2000/svg" width="100px" height="100px"  enable-background="new 0 0 106.998 237.183" viewBox="0 0 106.998 237.183"><path d="M26.456 142.781v-15.963V107.88 96.406c-5.472 1.318-9.662 1.922-13.292 1.957h-.014-.014c-1.933-.005-3.492-.176-5.051-.556-2.244-.553-4.114-1.481-5.729-2.832-.114-.096-.18-.231-.214-.391-1.158 3.932-1.659 8.349-1.163 13.315C2.093 119.056 12.883 137.986 26.456 142.781zM74.819 50.698H44.025c.067 1.424.143 3.65.143 6.425-.002 4.412-.191 10.205-.927 16.37-.088.735-.171 1.528-.254 2.343 1.278 1.161 2.267 2.658 2.817 4.398 1.444 4.57-.58 9.417-4.586 11.699-.868 5.5-2.098 10.804-4.777 15.03-1.686 2.71-4.469 5.096-7.984 5.769V224.82c0 6.83 5.537 12.363 12.363 12.363 6.828 0 12.365-5.533 12.365-12.363v-90.271h4.635v90.271c0 6.83 5.537 12.363 12.363 12.363 6.828 0 12.365-5.533 12.365-12.363V72.353c.65 1.04 1.324 2.299 2 3.808.425.948.85 1.985 1.271 3.147 2.818 7.814 5.189 20.63 5.179 40.638 0 5.514-.177 11.57-.565 18.225-.256 4.409 3.111 8.195 7.522 8.451.159.01.317.014.474.014 4.206.001 7.73-3.283 7.979-7.533.402-6.933.59-13.3.59-19.156-.04-30.183-4.861-46.886-11.434-56.931-3.284-4.985-7.127-8.183-10.678-9.956-1.015-.511-1.987-.895-2.91-1.196-2.192-.718-4.058-.922-5.326-.937C76.063 50.783 75.452 50.698 74.819 50.698zM29.724 102.618c1.113-1.69 2.115-4.511 2.838-7.824-1.445.411-2.808.78-4.106 1.114v8.214C28.847 103.781 29.251 103.302 29.724 102.618z"/><circle cx="55.502" cy="22.5" r="22.5"/><path d="M3.64,93.444v-0.002c1.644,1.375,3.366,2.039,4.917,2.423c1.566,0.379,3.048,0.493,4.587,0.498
        c6.04-0.06,13.653-1.777,25.536-5.487c4.213-1.332,6.549-5.825,5.218-10.039c-1.331-4.213-5.825-6.549-10.038-5.218
        c-11.086,3.547-18.135,4.803-20.716,4.743c-0.081,0-0.138-0.003-0.207-0.005c2.105-0.703,7.215-2.404,13.52-4.452v-0.261
        c0.665-0.574,1.333-1.139,2-1.697v1.31c1.55-0.501,3.154-1.018,4.793-1.542c0.646-0.205,1.303-0.336,1.965-0.407
        c0.028-0.251,0.054-0.519,0.083-0.764c0.685-5.742,0.87-11.245,0.87-15.422c0-2.323-0.056-4.237-0.111-5.559
        c-0.025-0.593-0.049-1.053-0.068-1.388c-1.718-0.066-3.469,0.412-4.973,1.493c-0.046,0.034-1.472,1.059-3.673,2.727
        c-2.74,2.077-6.684,5.153-10.693,8.576c-3.624,3.103-7.287,6.456-10.296,9.838c-1.509,1.703-2.866,3.402-4.017,5.309
        c-1.096,1.932-2.25,4.03-2.329,7.444c-0.104,2.179,0.916,5.054,2.689,6.991c0.007-0.013,0.014-0.026,0.021-0.04
        C2.997,92.842,3.299,93.157,3.64,93.444z"/></svg></h1>

        <p class="lead font-weight-bold">Aquí podrás navegar en tu horario designado haciendo click en el dia de la semana que quieras ver</p>

      </div>


    

  </div>



</section>


