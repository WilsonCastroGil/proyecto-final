<title>Horario Alumno</title>

<?php

include ('menu.inc');
  ?>





  <div class="container mt-5">
  	
<div class="row">

	<div class="col-sm-1"></div>

	<div class="col">



<ul class="nav nav-tabs" id="myTab" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#Kunes" role="tab" aria-controls="home" aria-selected="true">LUNES</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="profile-tab" data-toggle="tab" href="#Martes" role="tab" aria-controls="profile" aria-selected="false">MARTES</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="contact-tab" data-toggle="tab" href="#Miercoles" role="tab" aria-controls="contact" aria-selected="false">MIERCLES</a>
  </li>
   <li class="nav-item">
    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#Jueves" role="tab" aria-controls="home" aria-selected="true">JUEVES</a>
  </li> 
  <li class="nav-item">
    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#Viernes" role="tab" aria-controls="home" aria-selected="true">BIRNES</a>
  </li>
   <li class="nav-item">
    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#Sabado" role="tab" aria-controls="home" aria-selected="true">SABADO</a>
  </li>
</ul>
<div class="tab-content" id="myTabContent">
  <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">...</div>
  <div class="tab-pane fade" id="lunes" role="tabpanel" aria-labelledby="profile-tab">...</div>
  <div class="tab-pane fade" id="Martes" role="tabpanel" aria-labelledby="contact-tab">...</div>
   <div class="tab-pane fade" id="Miercoles" role="tabpanel" aria-labelledby="contact-tab">...</div>
    <div class="tab-pane fade" id="Jueves" role="tabpanel" aria-labelledby="contact-tab">...</div>
     <div class="tab-pane fade" id="Viernes" role="tabpanel" aria-labelledby="contact-tab">...</div>
      <div class="tab-pane fade" id="Sabado" role="tabpanel" aria-labelledby="contact-tab">...</div>
</div>









		
<table class="table  table-striped border-dark" id="data">
  <thead class="thead-dark">
    <tr>
      <th scope="col">id</th>
      <th scope="col">correo(usuario)</th>
      <th scope="col">contaseña</th>
   
    </tr>
  </thead>
  <tbody id="resultados">
  
  </tbody>
</table>



		</div>
	<div class="col-sm-1"></div>
</div>



  </div>