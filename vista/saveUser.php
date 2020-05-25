<title>Registro de Usuarios</title>
<?php  
include_once('menu.inc');
require_once('../controller/Conexion.php');
?>

<section class="container">
	<div class="row">
		
		<div class="col-sm-2"></div>

		<form id="formRegistro" class="col mt-5" >
			

			
			<div class="form-row form-container">
              <div class="=form-row col-sm-12"><h4 class="naranja strong">Registro Usuario</h4></div>

				<div class="form-group col-md-4">
					<div class="form-row">
				
			</div>
					
					<label for="inputState"><span >Tipo documento</span></label>
					<select name="tipodocu" class="form-control">
						<option selected>seleccione una opcion---></option>
						<?php
							$con = New Conexion();
							$createcon = $con->conectar(); 
							$sql = "SELECT * FROM TipoDoc";
							$exe = $createcon->query($sql);
							if ($exe->num_rows > 0) {
								# Traemos todo:
								while($res = $exe->fetch_row()){
									echo '<option value="'.$res[0].'">'.$res[1].'</option>';
								}
							}else{
								echo "No hay registros para tomar";
							}
						?>
					</select>
				</div>
				<div class="form-group col-md-4">
					<label for="inputEmail4">Número de Identificación</label>
					<input type="text" class="form-control" name="iduser">
				</div>
				<div class="form-group col-md-4">
					<label for="inputEmail4">Tipo de Usuario</label>
					<select class="form-control" name="rol" id="role">
						<option selected disabled>Seleccione una Opción</option>
						<?php
							$con = New Conexion();
							$createcon = $con->conectar(); 
							$sql = "SELECT * FROM tipousuario where idtipousuario !=1";
							$exe = $createcon->query($sql);
							if ($exe->num_rows > 0) {
								# Traemos todo:
								while($res = $exe->fetch_row()){
									echo '<option value="'.$res[0].'">'.$res[1].'</option>';
								}
							}else{
								echo "No hay registros para tomar";
							}
						?>
					</select>
				</div>
				<div class="form-group col-md-6">
					<label for="inputEmail4">Nombres</label>
					<input type="text" class="form-control" name="nombre">
				</div>
				<div class="form-group col-md-6">
					<label for="inputEmail4">Apellidos</label>
					<input type="text" class="form-control" name="apellido">
				</div>
				<div class="form-group col-md-4">
					<label for="inputEmail4">Telefono</label>
					<input type="text" class="form-control" name="tel">
				</div>
				<div class="form-group col-md-4">
					<label for="inputEmail4">Correo</label>
					<input type="email" class="form-control" name="correo">
				</div>
				<div class="form-group col-md-4">
					<label for="inputEmail4">Genero</label>
					<select class="form-control" name="Genero" id="gen">
						<option selected disabled>Seleccione una Opción</option>
						<option value="M">Masculino</option>
						<option value="F">Femenino</option>
					</select>
				</div>
				<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar usuario</button>
			</div>
			
		</form>

		<div class="col-sm-2"></div>

	</div>
</section>