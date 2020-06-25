'use strict';
function loginUser(){
	// Traemos en una lista los valores del formulario:
	var dataForm = $('#formLogin').serialize();
	// adicionamos el boton concatenando el resultado de serialize con el botón, "&btnlogin=true"
	var datalogin = dataForm+'&btnlogin=true';
	 // Comprobar: 	
	//  alert (datalogin);
	//Con ajax controlamos el paso de datos al servicio desde el controlador:
	$.ajax({
		type: "POST",
		url: "controller/login.php",
		data: datalogin,
	}).done(function(res){
		// Parseo el resultado para volverlo entero:
		this.res = parseInt(res);

		console.log(res);
		if (this.res === 1 ) {
			
			// Si al volver entero el resultado es 1, entonces se va a mi página de main:
			// alert("hasta aca vamos ok");
			// console.log();
			// Método para cambiar de vista en la url:
			window.location = "vista/configuracion.php";
		}else {

			if (this.res === 2) {
				
				window.location = "vista/vinstructor.php";
			} else {

				if (this.res === 3) {
					window.location = "vista/vaprendiz.php";
				} else {
					
					$("#resultado").html(res);
				}
				
			}
			// Si no es posible convertirlo en numero, entonces me muestra lo que trae res (respuesta):
			
		}	
	});
}

function confirmDelete(id){
    var r=confirm("¿Estas seguro de eliminar este registro?");
    if (r==true){
      window.location.href = "asignar.php?eliminar&id="+id;
    }
  }

// funcion de buscar y mostrar tabla


$(listaruser());


function listaruser(req){

	$.ajax({

		url:"../controller/listar.php",
		type:"POST",
		data:{dato:req},

	}).done(function(tabla){


		$('#resultados').html(tabla);
		

		console.log(tabla);
	})

}


$(document).on('keyup','#buscador',function(){
	var valorbuscar=$(this).val();

	if (valorbuscar!=null) {
		listaruser(valorbuscar);
	}else{
		listaruser()
	}

})


// funcion para asignar

function asignarHorario(){
	var datos = $('#asignarHorario').serialize();
	var dato = datos+'&asignar=true';
	// console.log(data);
	$.ajax({
		url: '../controller/asignar.php',
		type: 'post',
		data : dato
	})
	.done(function(resultado){
		$('#ejecucion').html(resultado);
		setTimeout(regarcar,3000);
	})
}






// Función de guardar:

function cruduser(btnSaveUser){
	var datoForm = $("#formRegistroUser").serialize();
	var datoReg = datoForm+'&btnopcion='+btnSaveUser;
	// alert (datoReg);
	console.log();
	// Control asicronico:
	$.ajax({
		type: "POST",
		url: "../controller/cruduser.php",
		data: datoReg
	})
	.done(function(res){
		console.log(res);
		
		$("#alerta").html(res);
		setTimeout(regarcar,3000);
	})
}

function crudficha(btn){
	var datoForm = $("#formficha").serialize();
	var datoReg = datoForm+'&btnopcion='+btn;
	// alert (datoReg);
	console.log();
	// Control asicronico:
	$.ajax({
		type: "POST",
		url: "../controller/guardarFicha.php",
		data: datoReg
	})
	.done(function(res){
		console.log(res);
		$("#alertaficha").html(res);
		setTimeout(regarcar,3000);
	})
}

function crudcompetencia(btn){
	var datoForm = $("#formcompetencia").serialize();
	var datoReg = datoForm+'&btnopcion='+btn;
	// alert (datoReg);
	console.log();
	// Control asicronico:
	$.ajax({
		type: "POST",
		url: "../controller/competencia.php",
		data: datoReg
	})
	.done(function(res){
		console.log(res);
		$("#alertacomp").html(res);
		setTimeout(regarcar,3000);
	})
}


function savemateria(){
	var datos = $('#guardarmateria').serialize();
	var dato = datos+'&asignar=true';
	// console.log(data);
	// alert(dato);
	$.ajax({
		url: '../controller/guardarActiproy.php',
		type: 'post',
		data : dato
	})
	.done(function(resultado){
		$('#alertamat').html(resultado);
		setTimeout(regarcar,3000);
		


	})
}


function regarcar(){

	location.reload();


}