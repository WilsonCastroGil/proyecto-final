

<?php  
	include('menu.inc');
		include('../controller/Conexion.php');
            		$con = New Conexion();
	                $createcon=$con->conectar();
					$createcon->set_charset("utf8");
				
?>
<section class="container-fluid">
	<div class="row text-center mt-5 ">

<div class="col">
	<!-- Button trigger modal -->
<button type="button" class="btn btn-success verde" data-toggle="modal" data-target="#exampleModal">
  Administre una sede
</button>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header config">
        <h5 class="modal-title" id="exampleModalLabel">Registrar Sede</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">

<div class="form-group row">

<div class="container">


	<div class="row">

	<div class="col-sm-6">
								<label for="inputEmail4">Nombres</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>

<div class="col-sm-6">
								<label for="inputEmail4">Direccion</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>
</div>
<div class="row">

	<div class="col">
								<label for="inputEmail4">Telefono</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>
<div class="col">
								<label for="inputEmail4">Correo</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>
<div class="col">
								<label for="inputEmail4">Director</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>
								

							</div>
		</div>
				</div>

        
      </div>
      <div class="modal-footer config">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
        <button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar sede</button>
      </div>
    </div>
  </div>
</div>
</div>

<div class="col">
	<!-- Button trigger modal -->
<button type="button" class="btn btn-success verde" data-toggle="modal" data-target="#exampleModal2">
Administre usuario
</button>

<!-- Modal -->
<div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header config">
        <h5 class="modal-title" id="exampleModalLabel">Registrar usuario</h5>
		
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">

<div class="container">
<form id="formRegistroUser" method="POST">
    <div class="row">

		
	
 		<div class="form-group col-sm-6">
          	<label for="ambiente" class="col-form-label">Tipo de documento:</label>
            <select  class="form-control border-success" name="idTipoDoc">
            	<option value="" disabled="" >Seleccione un tipo de documento</option>
            	<?php  
            		
            		$sql = "SELECT * from tipodoc";
            		$exe = $createcon->query($sql);
            		$con->error;
            		while($res = $exe->fetch_row()){
            			echo '<option value="'.$res[0].'">'.$res[1].'</option>';
            		}
            	?>
            </select>
          </div>


          <div class="form-group col-sm-6">
          	<label for="inputEmail4">Documento</label>
								<input type="text" class="form-control border-success" name="documento">

          </div>


	</div>

<div class="row">
	
				<div class="form-group col-sm-6">
					 <label for="inputEmail4">Nombres</label>
								<input type="text" class="form-control border-success" name="nombre">

				</div>

				<div class="form-group col-sm-6">
					 <label for="inputEmail4">Apellidos</label>
								<input type="text" class="form-control border-success" name="apellido">

				</div>


</div>

<div class="row">
			<div class="form-group col-sm-6">
					 <label for="inputEmail4">Telefono</label>
								<input type="text" class="form-control border-success" name="telefono">

				</div>

				<div class="form-group col-sm-6">

					<label for="inputEmail4">Genero</label>
					<select  class="form-control border-success" name="genero" >
						
						<option disabled="">Seleccione genero</option>
					<option value="m">masculino</option>
					<option value="f">femenino</option>
					<option value="o">otros</option>

					</select>

				</div>


</div>


<div class="row">

		<div class="form-group col-sm-6">
					 <label for="inputEmail4">Correo</label>
								<input type="text" class="form-control border-success" name="correo">

				</div>



				<div class="form-group col-sm-6">
          	<label for="ambiente" class="col-form-label">Rol:</label>
            <select  class="form-control border-success" name="idTipoUsuario">
            	<option value="" disabled="">Seleccione un tipo de usuario</option>
            	<?php  
            		
            		$sql = "SELECT * from tipousuario;";
            		$exe = $createcon->query($sql);
            		$con->error;
            		while($res = $exe->fetch_row()){
            			echo '<option value="'.$res[0].'">'.$res[1].'</option>';
            		}
            	?>
            </select>
          </div>

</div>



<div class="row">
	
	

          <div class="form-group col-sm-6">

          		<label for="ambiente" class="col-form-label">Estado:</label>
					<select name="estadouser" class="form-control border-success" >
						
						<option disabled="">Seleccione un estado del usuario</option>
					<option value="1">habilitado</option>
					<option value="2">inhabilitado</option>


					</select>

				</div>



</div>


	</div>
  
  		 	 </div>
     				 <div class="modal-footer config">
       						 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
       						 <button  type="button"  onclick="cruduser('guardar')" class="btn btn-success verde">Registrar Usuario</button>
								
      				</div>
					  
					  </form>
   			 </div>
  </div>
</div>
</div>

<div class="col">
	
	<!-- Button trigger modal -->
<button type="button" class="btn btn-success verde" data-toggle="modal" data-target="#exampleModal3">
  Administre programa
</button>

<!-- Modal -->
<div class="modal fade" id="exampleModal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header config">
        <h5 class="modal-title" id="exampleModalLabel">Administre programa de formacion</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        
<div class="container">


	<div class="row">

	 <div class="form-group col-sm-6">
          	<label for="ambiente" >Centro:</label>
            <select name="idFicha" class="form-control border-success">
            	<option value="" disabled="">Seleccione un centro</option>
            	<?php  
            		
            		$sql = "SELECT * from centro;";
            		$exe = $createcon->query($sql);
            		$con->error;
            		while($res = $exe->fetch_row()){
            			echo '<option value="'.$res[0].'">'.$res[2].'</option>';
            		}
            	?>
            </select>
          </div>

<div class="col-sm-6">
								<label for="inputEmail4">Nombre programa</label>
								<input type="text" class="form-control border-success" name="nombre">
</div>
</div>
<div class="row">

	<div class="col">
		<label for="inputEmail4">Formacion</label>
								<select name="estadouser" class="form-control border-success" >
						
						<option disabled="">Seleccione tipo de formacion</option>
					<option value="presencial">presencial</option>
					<option value="virtual">virtual</option>
					

					</select>

</div>
<div class="col">
							

          		<label for="ambiente" >Estado:</label>
					<select name="estadouser" class="form-control border-success" >
						
						<option disabled="">Seleccione un estado del usuario</option>
					<option value="1">habilitado</option>
					<option value="2">inhabilitado</option>


					</select>

			

</div>
								

							</div>
		</div>

      </div>
      <div class="modal-footer config">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>

</div>
		
	</div>
</section>