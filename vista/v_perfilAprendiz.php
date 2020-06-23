<?php

include('menu.inc');

include('../controller/Conexion.php');
$con = new Conexion();
$createcon = $con->conectar();
$createcon->set_charset("utf8");

// if ($_SESSION["user"]==null) {

//   header("location:cerrarsesion.php"); 

// }else{
//    $mensaje = "<span style='color:red'>Error los datos no son correctos<span>";
// }


if (isset($_GET['id'])) {
    $con = new Conexion();
	$createcon = $con->conectar();
	$createcon->set_charset("utf8");

    $res = $consulta->query("select * from v_listarusuarios where Documento={$_GET['Documento']}");

    if ($campos = $res->fetch_object()) {
        $nombre = $campos->nombre;
        $apellido = $campos->apellido;
        $correo = $campos->correo;
        $id = $campos->id;
        $foto = $campos->foto;
    } else if (false) {
        
    }
}
?>


<section class="container-fluid bg mt-2">
	<section class="row justify-content-center">
		<section class="col-sm-1 col-md-10">
			<form class="form-container" action="" method="POST" id="formRegistroUser">
				<p class="h4 mb-4 naranja"><strong>Registro de usuario</strong></p>
				<div class="form-row">
					<div class="form-group col-md-3">
						<label for="inputAddress"><span class="naranja">Documento o contraseña</span></label>
						<input type="text" class="form-control " id="inputAddress" name="documento" placeholder="#documento" minlength="6">
					</div>
					<div class="form-group col-md-3 ">
						<label for="inputState"><span class="naranja">Tipo documento</span></label>
						<select name="idTipoDoc" id="inputState" class="form-control">
							<option value="" disabled>Seleccione una opcion</option>
							<?php

							$sql = "SELECT * from tipodoc";
							$exe = $createcon->query($sql);
							if ($exe->num_rows > 0) {
								while ($res = $exe->fetch_row()) {
									echo '<option value="' . $res[0] . '">' . $res[1] . '</option>';
								}
							} else {
								echo "error en la conexion";
							}
                                // $con->error;

							?>
						</select>

					</div>
					<div class="form-group col-md-3">
						<label for="inputAddress2"><span class="naranja">Nombres</span></label>
						<input name="nombre" type="text" class="form-control" id="inputAddress2" placeholder="Primer y/o segundo nombre">
					</div>

					<div class="form-group col-md-3">
						<label for="inputAddress2"><span class="naranja">Apellidos</span></label>
						<input name="apellido" type="text" class="form-control" id="inputAddress2" placeholder="Primer y segundo apellido">
					</div>

				</div>
				<div class="form-row">
					<div class="form-group col-md-3">
						<label for="inputCity"><span class="naranja">Tel</span></label>
						<input name="telefono" type="text" class="form-control" id="inputCity" placeholder="#telefono">
					</div>

					<div class="form-group col-md-3">
						<label for="inputState"><span class="naranja">Genero</span></label>
						<select name="genero" id="inputState" class="form-control">
							<option selected>escoja</option>
							<option value="m">Masculino</option>
							<option value="f">Femenino</option>
							<option value="o">Otro</option>
						</select>
					</div>

					<div class="form-group col-md-3">
						<label for="inputAddress2"><span class="naranja">Correo</span></label>
						<input name="correo" type="text" class="form-control" id="inputAddress2" placeholder="ejemplo@mail.com">
					</div>
					<div class="form-group col-md-3">
						<label for="inputAddress2"><span class="naranja">Cotraseña</span></label>
						<input name="correo" type="passwor" class="form-control" id="inputAddress2">
					</div>
				</select>
			</div>
		</div>
		<button type="button" onclick="cruduser('actualizar')" class="btn btn-primary btn-verde">ACTUALIZAR</button>
		<div class="text-right text-danger">¡para modificar un usuario debe poner el mismo # de documento !</div>
		<article id="alerta" class="alert-warning text-danger"></article>
	</form>
</section>
</section>
</section>


