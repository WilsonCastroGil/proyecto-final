<title>Ingreso</title>
<?php
session_start();
include('vista/cabezalogin.inc');
// print_r($_SESSION);

?>

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

<div class="row-12">
	<div class="pos-f-t">
		<div class="collapse" id="navbarToggleExternalContent">
			<div class="bg-dark p-4">
				<h4 class="naranja">Chekinassist</h4>
				<span class="text-light">Debes iniciar sesion para continuar,<br>
					en chekinassist puedes visualizar <br>
					tu horario en caso de ser un aprendiz o un instructor, <br>
					si tienes varios perfiles podras cambiarlos en la pestaña <br>
					configuracion</span>
			</div>
		</div>
		<nav class="navbar navbar-dark bg-light bordes3">
			<button class="navbar-toggler " type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
				<a title="Sena / Public domain"><img width="35" alt="Sena Colombia logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Sena_Colombia_logo.svg/64px-Sena_Colombia_logo.svg.png"></a>
			</button>

			<div class="text-center text-dark verde">

					<h5>Bienvenido al Sistema de Horarios Virtual del  Sena(SHVS) , debes iniciar sesion para continuar.</h5>
			</div>

		</nav>

	</div>

</div>

<section class="container-fluid">



	<div class="row-12">




		<div class="row">




			<div class="col-sm-4"></div>
			<div class="col mt-5">
				<form class="mt-5 form-container" method="POST" id="formLogin">
					<h3 class="naranja strong mb-4">Ingreso de usuario</h3>
					<div class="col">
						<article id="resultado" class="alert-warning text-danger"></article>
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Correo @misena</label>
						<input type="txt" class="form-control" name="usuario" aria-describedby="emailHelp">
						<small id="emailHelp" class="form-text text-muted">


						</small>
					</div>
					<div class="form-group">
						<label for="exampleInputPassword1">Contraseña</label>
						<input type="password" class="form-control" name="passuser">
					</div>

					<button type="button" onclick="loginUser()" id="" class="btn btn-verde verde "><svg class="bi bi-person-check-fill" width="2em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
							<path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm9.854-2.854a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 0 1 .708-.708L12.5 7.793l2.646-2.647a.5.5 0 0 1 .708 0z" />
						</svg> Ingresar</button>
				</form>
			</div>
			<div class="col-sm-4"></div>
		</div>
</section>






