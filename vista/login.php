<title>Ingreso</title>
<?php 
include('menulogin.inc');
?>

<section class="container">
	<div class="row">
		<div class="col-sm-4"></div>
		<div class="col">
			<form class="mt-5 form-container"  method="POST">
				<h3 class="naranja strong mb-4">Ingreso de usuario</h3>
				<div class="col">
					<article id="resultado" class="alert-warning text-danger"></article>
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Email address</label>
					<input type="txt" class="form-control" id="user" name="usuario" aria-describedby="emailHelp">
					<small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
				</div>
				<div class="form-group">
					<label for="exampleInputPassword1">Password</label>
					<input type="password" class="form-control" id="clave" name="passuser">
				</div>
				
				<button type="button" onclick="loginUser()"  id="formLogin"  class="btn btn-primary verde">Ingresar</button>
			</form>
		</div>
		<div class="col-sm-4"></div>
	</div>
</section>