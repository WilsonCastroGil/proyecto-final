<?php  

include('menu.inc');
include('../controller/Conexion.php');
$con = New Conexion();
$createcon=$con->conectar();
$createcon->set_charset("utf8");

if ($_SESSION["perfil"] != '1;0;0') {

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
    $('#tsemana.display').DataTable();
  } );

  function confirmDelete(id){
    var r=confirm("¿Estas seguro de eliminar este registro?");
    if (r==true){
      window.location.href = "asignar.php?eliminar&id="+id;
    }
  }
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
  <div class="row mt-3">

    
   <!-- <h3 class="text-center  col-md-12 mt-2 text-light  badge-pill badge-primary">Asignar Horarios:
    <svg class="bi bi-stopwatch" width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" d="M8 15A6 6 0 1 0 8 3a6 6 0 0 0 0 12zm0 1A7 7 0 1 0 8 2a7 7 0 0 0 0 14z"/>
      <path fill-rule="evenodd" d="M8 4.5a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-.5.5H4.5a.5.5 0 0 1 0-1h3V5a.5.5 0 0 1 .5-.5zM5.5.5A.5.5 0 0 1 6 0h4a.5.5 0 0 1 0 1H6a.5.5 0 0 1-.5-.5z"/>
      <path d="M7 1h2v2H7V1z"/>
    </svg>

  </h3> -->
  <div class="col">

    <h5 class="text-center text-primary">Lunes</h5>
    <button class="btn btn-success w-100 h-50 bordes2" data-toggle="modal" data-target="#exampleModal" data-whatever="1">
      <svg class="bi bi-person-plus-fill w-50 h-50"  viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>
      <br>
      Asignar Instructor 
      
    </button>

  </div>
  <div class="col">
    <h5 class="text-center text-primary">Martes</h5>
    <button class="btn btn-success bordes2 w-100 h-50" data-toggle="modal" data-target="#exampleModal" data-whatever="2">
      <svg class="bi bi-person-plus-fill w-50 h-50" width="3em" height="3em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>
      <br>

    Asignar Instructor</button>
  </div>
  <div class="col">
    <h4 class="text-center text-primary">Miércoles</h4>
    <button class="btn btn-success bordes2 w-100 h-50" data-toggle="modal" data-target="#exampleModal" data-whatever="3">

      <svg class="bi bi-person-plus-fill w-50 h-50" width="3em" height="3em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>
      <br>

    Asignar Instructor</button>
  </div>
  <div class="col">
    <h4 class="text-center text-primary">Jueves</h4>
    <button class="btn btn-success bordes2 w-100 h-50" data-toggle="modal" data-target="#exampleModal" data-whatever="4">
      <svg class="bi bi-person-plus-fill w-50 h-50" width="3em" height="3em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>
      <br>


    Asignar Instructor</button>
  </div>
  <div class="col">
    <h4 class="text-center text-primary">Viernes</h4>
    <button class="btn btn-success bordes2 w-100 h-50" data-toggle="modal" data-target="#exampleModal" data-whatever="5">

      <svg class="bi bi-person-plus-fill w-50 h-50" width="3em" height="3em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>
      <br>
    Asignar Instructor</button>
  </div>
  <div class="col">
    <h4 class="text-center text-primary">Sábado</h4>
    <button class="btn btn-success bordes2 w-100 h-50" data-toggle="modal" data-target="#exampleModal" data-whatever="6">
      <svg class="bi bi-person-plus-fill w-50 h-50" width="3em" height="3em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm7.5-3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
        <path fill-rule="evenodd" d="M13 7.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0v-2z"/>
      </svg>

      <br>

    Asignar Instructor</button>
  </div>



  <!-- Seccion de vista de horario -->

  <div class="col-md-12 mt-2  pb-3">
   <div class="table-responsive col-md-12 bordes config">


    <ul class="nav nav-tabs text-center" id="myTab" role="tablist">
      <li class="nav-item col-md-2">
        <a class="nav-link btn-verde bordes2 " id="home-tab" data-toggle="tab" href="#Lunes" role="tab" aria-controls="home" aria-selected="true">LUNES</a>
      </li>
      <li class="nav-item  col-md-2">
        <a class="nav-link btn-verde bordes2" id="profile-tab" data-toggle="tab" href="#Martes" role="tab" aria-controls="profile" aria-selected="false">MARTES</a>
      </li>
      <li class="nav-item col-md-2">
        <a class="nav-link btn-verde bordes2" id="contact-tab" data-toggle="tab" href="#Miercoles" role="tab" aria-controls="contact" aria-selected="false">MIERCOLES</a>
      </li>
      <li class="nav-item col-md-2">
        <a class="nav-link btn-verde bordes2" id="home-tab" data-toggle="tab" href="#Jueves" role="tab" aria-controls="home" aria-selected="true">JUEVES</a>
      </li> 
      <li class="nav-item col-md-2">
        <a class="nav-link btn-verde bordes2 " id="home-tab" data-toggle="tab" href="#Viernes" role="tab" aria-controls="home" aria-selected="true">VIERNES</a>
      </li>
      <li class="nav-item col-md-2">
        <a class="nav-link btn-verde bordes2 " id="home-tab" data-toggle="tab" href="#Sabado" role="tab" aria-controls="home" aria-selected="true">SABADO</a>
      </li>
    </ul>
    <div class="tab-content" id="myTabContent">
      <div class="tab-pane fade show active" id="Lunes" role="tabpanel" aria-labelledby="home-tab">

        <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='lunes'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>
      </div>
      <div class="tab-pane fade" id="Martes" role="tabpanel" aria-labelledby="contact-tab"> 
      <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='martes'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>

      </div>
      <div class="tab-pane fade" id="Miercoles" role="tabpanel" aria-labelledby="contact-tab">
      <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='miercoles'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>
      </div>
      <div class="tab-pane fade" id="Jueves" role="tabpanel" aria-labelledby="contact-tab">
      <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='jueves'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>
      </div>
      <div class="tab-pane fade" id="Viernes" role="tabpanel" aria-labelledby="contact-tab">
      <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='viernes'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>
      </div>
      <div class="tab-pane fade" id="Sabado" role="tabpanel" aria-labelledby="contact-tab">
      <table  id ="tsemana" class="  table-striped display " width="100%" height="100%">
         <thead class=" ">
          <tr class="text-light text-center bgverdea table">
            <th>Numero de ficha</th>
            <th>Ambiente</th>
            <th>Dia</th>
            <th>Nombre Comp</th>
            <th>Instructor</th>
            <th>Trimestre</th>
            <th>Hora inicio</th>
            <th>Hora fin</th>
            <th>Opcion</th>
          </tr>
        </thead>

          <?php 
          if (isset($_GET['eliminar'])) {

            $sqlDelete = "delete from detalleasignacion where idDetalleA='".$_GET['id']."'";
            $res = $createcon->query($sqlDelete);
          }


          $sql="select * from v_detalleasignacion where dia ='sabado'";

          $exe = $createcon->query($sql);

          if ($exe->num_rows > 0) {

            $cont=0;

            while ($res=$exe->fetch_row()) {
              echo '<tr class="text-center font-weight-bold">
                <td>'.$res[1].'</td>
                <td>'.$res[2].'</td>
                <td>'.$res[3].'</td>
                <td>'.$res[4].'</td>
                <td>'.$res[5].'</td>
                <td>'.$res[6].'</td>
                <td>'.$res[7].'</td>
                <td>'.$res[8].'</td>
                <td>';
              
              echo "<a href='#' class='btn btn-danger' onclick='confirmDelete($res[0]);'>Eliminar</button>
                </td>
              </tr>";
              $count=$cont+1;
            }
            
          }
          else{

            echo "no se encontraron datos";

          }


          ?>

        </table>
        </div>
      </div>




    </div>
  </div>
</div>
</section>






<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content ">
      <div class="modal-header config">
        <h5 class="modal-title text-center" id="modal-titulo"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">

        <form class="row" id="asignarHorario" method="POST">
          <div class="form-group col-sm-12">
            <input type="hidden" class="form-control dia" name="idDia" id="recipient-name">
          </div>
          <div class="form-group col-sm-3">
            <label for="message-text" class="col-form-label">Periodo:</label>
            <?php echo'<input type="text" name="periodo" class="form-control" readonly value="'.date("Y").'">' ?>
          </div>
          <div class="form-group col-sm-3">
            <label for="message-text" class="col-form-label">Trimestre:</label>
            <select name="trimperiodo" class="form-control">
              <option value="" disabled="">Seleccione un Trimestre:</option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
            </select>
          </div>
          <div class="form-group col-md-6">
            <label for="message-text" class="col-form-label">Instructor:</label>
            <select name="idUsuario" class="form-control">
              <option value="">Seleccione un Instructor:</option>
              <?php  
              
              $sql = "SELECT * from instructores";
              $exe = $createcon->query($sql);
              if ($exe->num_rows>0) {
               while($res = $exe->fetch_row()){
                 echo '<option value="'.$res[0].'">'.$res[1].'</option>';
               }

             }else{
               echo "error en la conexion";
             }


                // $con->error;

             ?>
           </select>
         </div>
         <div class="form-group col-sm-6">
           <label for="ambiente" class="col-form-label">Ambiente de Aprendizaje:</label>
           <select name="idAmbiente" class="form-control">
             <option value="">Seleccione un ambiente</option>
             <?php  

             $sql = "SELECT * from ambiente";
             $exe = $createcon->query($sql);

             while($res = $exe->fetch_row()){
               echo '<option value="'.$res[0].'">'.$res[2].'</option>';
             }
             ?>
           </select>
         </div>

         <div class="form-group col-sm-6">
           <label for="ambiente" class="col-form-label">Ficha:</label>
           <select name="idFicha" class="form-control">
             <option value="">Seleccione una Ficha</option>
             <?php  

             $sql = "SELECT * from ficha;";
             $exe = $createcon->query($sql);
             $con->error;
             while($res = $exe->fetch_row()){
               echo '<option value="'.$res[0].'">'.$res[5].'</option>';
             }
             ?>
           </select>
         </div>

         <div class="form-group col-sm-4">
           <label for="ambiente" class="col-form-label">AP:</label>
           <select name="idActiProy" class="form-control">
             <option value="">Seleccione una Actividad de Aprendizaje</option>
             <?php  

             $sql = "SELECT * from actiproy";
             $exe = $createcon->query($sql);
             $con->error;
             while($res = $exe->fetch_row()){
               echo '<option value="'.$res[0].'">'.$res[1].'</option>';
             }
             ?>
           </select>
         </div>
         <div class="form-group col-sm-4">
           <label for="ambiente" class="col-form-label">Incio:</label>
           <input type="time" name="horaInicio" class="form-control">
         </div>
         <div class="form-group col-sm-4">
           <label for="ambiente" class="col-form-label">Fin:</label>
           <input type="time" name="horaFin" class="form-control">
         </div>
       </form>
       <section class="text-capitalize col-md-12" id="ejecucion">
         <!-- Resultados de la operación -->
       </section>
     </div>
     <div class="modal-footer config">
      <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
      <button type="button" onclick="asignarHorario()" class="btn btn-success text-white">Asignar Horario</button>
    </div>
  </div>
</div>
</div>

<script>
  $('#exampleModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var recipient = button.data('whatever') // Extract info from data-* attributes

    recipiente = parseInt(recipient);
    console.log(recipiente);
    switch (recipiente) {
     case 1:
     var titulo = "Lunes";
     break;
     case 2:
     var titulo = "Martes";
     break;
     case 3:
     var titulo = "Miércoles";
     break;
     case 4:
     var titulo = "Jueves";
     break;
     case 5:
     var titulo = "Viernes";
     break;
     case 6:
     var titulo = "Sábado";
     break;
     default:
     var titulo = "Domingo";
     break;
   }

   var modal = $(this)
   modal.find('.modal-title').text('Asignar Horario a Instructor el Día ' + titulo)
   modal.find('.dia').val(recipient)
 })
</script>

