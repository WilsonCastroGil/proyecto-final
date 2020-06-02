<?php 
require_once('../controller/Conexion.php');
include('menu.inc');

?>

<div class="container">

	<div class=col-sm-2> </div>
	<div class="col">

		<div class="row mt-5">
			
			<div class="col-sm-6">

				<div class="card  border-success mb-3 ">
					<div class="form-container config">	
						
						<div class="card-body text-success">


							<h5 class="card-title">Ficha</h5>

							<div class="form-group row">

							<select class="form-control" name="rol" id="role">
						<option selected disabled>Seleccione una Opción</option>
						<?php
							$con = New Conexion();
							$createcon = $con->conectar(); 
							$sql = "SELECT * FROM dia";
							$exe = $createcon->query($sql);
							 $createcon->set_charset("utf8");
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
							

							<div class="card text-right">
								<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde ">Registrar ficha</button>

							</div>


							<div class="card text-right">
								<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde ">Eliminar ficha</button>

							</div>
								</div>

						</div>
					</div>
				</div>

				<div class="card  border-success mb-3">
					<div class="form-container config">	
						
						<div class="card-body text-success">


							<h5 class="card-title">Tipo de ambiente</h5>

							<div class="form-group row">

								<input type="text" class="form-control border-success" name="iduser">
					

							<div class="card text-right">
								<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar tipo de ambiente</button>

							</div>

										</div>
						</div>
					</div>
				</div>

				<div class="card  border-success mb-3">
					<div class="form-container config">	
						
						<div class="card-body text-success">


							<h5 class="card-title">Ficha</h5>

							<div class="form-group row">

								<input type="text" class="form-control border-success" name="iduser">
							

							<div class="card text-right">
								<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar ficha</button>

							</div>

							</div>
						</div>
					</div>
				</div>
			</div>
			

			<div class="col-sm-6">
				<div class="card  border-success mb-3">
					<div class="form-container config">	
						
						<div class="card-body text-success">


							<h5 class="card-title">Registrar sede</h5>

							<div class="form-group row">

								<label for="inputEmail4">Nombres</label>
								<input type="text" class="form-control border-success" name="nombre">

								<label for="inputEmail4">Direccion</label>
								<input type="text" class="form-control border-success" name="nombre">

								<label for="inputEmail4">Telefono</label>
								<input type="text" class="form-control border-success" name="nombre">

								<label for="inputEmail4">Correo</label>
								<input type="text" class="form-control border-success" name="nombre">

								<label for="inputEmail4">Director</label>
								<input type="text" class="form-control border-success" name="nombre">

								<div class="card text-right">
									<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar sede</button>

								</div>


							</div>
						</div>
					</div>
				</div>
                 
					<div class="card  border-success mb-3">
						<div class="form-container config">	

							<div class="card-body text-success">


								<h5 class="card-title">Dia</h5>

								<div class="form-group row">

									<input type="text" class="form-control border-success" name="iduser">
							

								<div class="card text-right">
									<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar ficha</button>

								</div>

									</div>
							</div>
						</div>
					</div>

					<div class="card  border-success mb-3">
						<div class="form-container config">	
							
							<div class="card-body text-success">


								<h5 class="card-title">Ambiente</h5>

								<div class="form-group row">

									<input type="text" class="form-control border-success" name="iduser">
								

								<div class="card text-right">
									<button type="button" onclick="cruduser('guardar')" class="btn btn-primary verde">Registrar ficha</button>

								</div>

									</div>
							</div>
						</div>
					</div>






                 </div>
					
				</div>
		

	</div>
</div>


