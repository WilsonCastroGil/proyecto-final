<?php  
	include('menu.inc');
?>
<section class="container">
	<div class="row">

		<div class="col-md-12 row">
			<h3 class="text-center col-md-12">Asignar Horarios:</h3>
			<div class="col">
				<h4 class="text-center text-left">Lunes</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="1">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Martes</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="2">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Miércoles</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="3">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Jueves</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="4">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Viernes</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="5">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Sábado</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="6">Asignar Instructor</button>
			</div>
			<div class="col">
				<h4 class="text-center text-left">Domingo</h4>
				<button class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="7">Asignar Instructor</button>
			</div>
		</div>

		<!-- Seccion de vista de horario -->

		<div class="col-md-12 row mt-3">
			<div class="table-responsive">
				<table class="table">
					<thead class="bg-dark text-light text-center">
						<tr>
							<th colspan="7">Horarios Asignados</th>
						</tr>
						<tr>
							<th>Lunes</th>
							<th>Martes</th>
							<th>Miércoles</th>
							<th>Jueves</th>
							<th>Viernes</th>
							<th>Sábado</th>
							<th>Domingo</th>
						</tr>
					</thead>
					<tbody id="tblhorarios">
						<!-- Mostrar resultados asignados -->
					</tbody>
				</table>
			</div>
		</div>
	</div>
</section>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
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
<div class="dropdown">
  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    Dropdown
  </button>
  <div class="dropdown-menu" aria-labelledby="dropdownMenu2">
    <button class="dropdown-item" type="button">Action</button>
    <button class="dropdown-item" type="button">Another action</button>
    <button class="dropdown-item" type="button">Something else here</button>
  </div>
</div>
 

          </div>
          <div class="form-group col-md-6">
            <label for="message-text" class="col-form-label">Instructor:</label>
            <select name="idUsuario" class="form-control">
            	<option value="">Seleccione un Instructor:</option>
            	<?php  
            		include('../control/conex.php');
            		$sql = "SELECT * from instructores";
            		$exe = $con->query($sql);
            		$con->error;
            		while($res = $exe->fetch_row()){
            			echo '<option value="'.$res[0].'">'.$res[1].'</option>';
            		}
            	?>
            </select>
          </div>
          <div class="form-group col-sm-6">
          	<label for="ambiente" class="col-form-label">Ambiente de Aprendizaje:</label>
            <select name="idAmbiente" class="form-control">
            	<option value="">Seleccione un ambiente</option>
            	<?php  
            		include('../control/conex.php');
            		$sql = "SELECT * from ambiente";
            		$exe = $con->query($sql);
            		$con->error;
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
            		include('../control/conex.php');
            		$sql = "SELECT * from ficha;";
            		$exe = $con->query($sql);
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
            		include('../control/conex.php');
            		$sql = "SELECT * from actiproy";
            		$exe = $con->query($sql);
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
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
        <button type="button" onclick="asignarHorario()" class="btn btn-primary">Asignar Horario</button>
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