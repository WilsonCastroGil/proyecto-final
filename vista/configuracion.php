<?php

include('menu.inc');
include('../controller/Conexion.php');
$con = new Conexion();
$createcon = $con->conectar();
$createcon->set_charset("utf8");

// if ($_SESSION["user"]="null"){

// 	header('location:login.php');

// }

?>

<div class="container-fluid mt-4">

	<div class="container">

		<div class="row ">

			<div class="col text-center">
				<button type="button" class="btn btn-verde w-75 h-75 " data-toggle="modal" data-target="#modalficha">
					<svg class="bi bi-layout-text-sidebar w-75  h-75" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" d="M14 1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z" />
						<path fill-rule="evenodd" d="M11 15V1h1v14h-1zM3 3.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 3a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 3a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 3a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z" />
					</svg> <br> Administrar ficha
				</button>

				<!-- Modal -->
				<div class="modal fade" id="modalficha" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<form action="" id="formficha" method="POST">
								<div class="modal-header config">
									<h5 class="modal-title" id="exampleModalLabel">Administrar ficha</h5>
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<div class="container ">
										<div class="form-group row-8">

											<label for="inputState"><span class="naranja">programa</span></label>
											<select name="idPrograma" id="inputState" class="form-control">
												<option selected value="" disabled>Seleccione una opcion</option>
												<?php

												$sql = "SELECT * from programa";
												$exe = $createcon->query($sql);
												if ($exe->num_rows > 0) {
													while ($res = $exe->fetch_row()) {
														echo '<option value="' . $res[0] . '">' . $res[2] . '</option>';
													}
												} else {
													echo "error en la conexion";
												}


												// $con->error;

												?>
											</select>

										</div>

										<div class="form-group row">

											<div class="col">
												<label for="ambiente" class="col-form-label naranja">Fecha inicio:</label>
												<input type="date" name="fechaInicio" class="form-control">
											</div>
										

											<div class="col">
												<label for="ambiente" class="col-form-label naranja">Fecha fin:</label>
												<input type="date" name="fechaFin" class="form-control">
											</div>
										</div>

										<div class="form-group row">

												<div class="col">
												<label for="inputAddress"><span class="naranja">Cantidad de aprendices</span></label>
													<select class="form-control" name="cantidadAprendiz" id="">
														<option value="20">20</option>
														<option value="25">25</option>
														<option value="30">30</option>
														<option value="35">35</option>
														<option value="40">40</option>
														<option value="45">45</option>
														<option value="50">50</option>
														<option value="55">55</option>
														<option value="60">60</option>
													</select>
												</div>

												<div class="col">
												<label for="inputAddress"><span class="naranja"># FICHA</span></label>
                            <input type="text" class="form-control " id="inputAddress" name="numeroFicha" placeholder="#Ficha" minlength="6">
												</div>

										</div>
									
									
									</div>
								</div>
								<div class="modal-footer config">
									<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
									<button type="button" class="btn btn-verde" onclick="crudficha('guardar')">Registrar</button>
									<article id="alertaficha" class="alert-warning text-danger"></article>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>

			<div class="col text-center">

				<button type="button" class="btn btn-verde w-75 h-75" data-toggle="modal" data-target="#modalsede">
					<svg class="bi bi-building w-75 h-75" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" d="M15.285.089A.5.5 0 0 1 15.5.5v15a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5V14h-1v1.5a.5.5 0 0 1-.5.5H1a.5.5 0 0 1-.5-.5v-6a.5.5 0 0 1 .418-.493l5.582-.93V3.5a.5.5 0 0 1 .324-.468l8-3a.5.5 0 0 1 .46.057zM7.5 3.846V8.5a.5.5 0 0 1-.418.493l-5.582.93V15h8v-1.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5V15h2V1.222l-7 2.624z" />
						<path fill-rule="evenodd" d="M6.5 15.5v-7h1v7h-1z" />
						<path d="M2.5 11h1v1h-1v-1zm2 0h1v1h-1v-1zm-2 2h1v1h-1v-1zm2 0h1v1h-1v-1zm6-10h1v1h-1V3zm2 0h1v1h-1V3zm-4 2h1v1h-1V5zm2 0h1v1h-1V5zm2 0h1v1h-1V5zm-2 2h1v1h-1V7zm2 0h1v1h-1V7zm-4 0h1v1h-1V7zm0 2h1v1h-1V9zm2 0h1v1h-1V9zm2 0h1v1h-1V9zm-4 2h1v1h-1v-1zm2 0h1v1h-1v-1zm2 0h1v1h-1v-1z" />
					</svg>
					<br> ADMINISTRAR SEDE
				</button>
				

				<!-- Modal -->
				<div class="modal fade " id="modalsede" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								<form>
									<div class="form-row">


									</div>
								</form>
							</div>

							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save changes</button>
							</div>
						</div>
					</div>
				</div>

			</div>


		</div>

		<div class="row mt-5">

			<div class="col text-center">
				<button type="button" class="btn btn-verde w-75 h-75" data-toggle="modal" data-target="#modalcompetencia">
					<svg class="bi bi-layers-fill w-75 h-75" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" d="M7.765 1.559a.5.5 0 0 1 .47 0l7.5 4a.5.5 0 0 1 0 .882l-7.5 4a.5.5 0 0 1-.47 0l-7.5-4a.5.5 0 0 1 0-.882l7.5-4z" />
						<path fill-rule="evenodd" d="M2.125 8.567l-1.86.992a.5.5 0 0 0 0 .882l7.5 4a.5.5 0 0 0 .47 0l7.5-4a.5.5 0 0 0 0-.882l-1.86-.992-5.17 2.756a1.5 1.5 0 0 1-1.41 0l.418-.785-.419.785-5.169-2.756z" />
					</svg>
					<br>
					ADMINISTRAR COMPETENCIA
				</button>

				<!-- Modal -->
				<div class="modal fade" id="modalcompetencia" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">ADMINISTRAR COMPETENCIA</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								...
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save changes</button>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="col text-center">

				<button type="button" class="btn btn-verde w-75 h-75" data-toggle="modal" data-target="#modalcentro">
					<svg class="bi bi-house-door-fill w-75 h-75" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
						<path d="M6.5 10.995V14.5a.5.5 0 0 1-.5.5H2a.5.5 0 0 1-.5-.5v-7a.5.5 0 0 1 .146-.354l6-6a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 .146.354v7a.5.5 0 0 1-.5.5h-4a.5.5 0 0 1-.5-.5V11c0-.25-.25-.5-.5-.5H7c-.25 0-.5.25-.5.495z" />
						<path fill-rule="evenodd" d="M13 2.5V6l-2-2V2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5z" />
					</svg>
					<br>
					ADMINISTRAR CENTRO
				</button>

				<!-- Modal -->
				<div class="modal fade" id="modalcentro" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								...
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save changes</button>
							</div>
						</div>
					</div>
				</div>

			</div>


		</div>

	</div>

</div>