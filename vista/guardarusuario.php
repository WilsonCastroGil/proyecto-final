<?php

include ('menu.inc');
session_start();
if ($_SESSION["logueado"]==null) {
   
  header("location:login.php"); 
   
}else{
   $mensaje = "<span style='color:red'>Error los datos no son correctos<span>";
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0,
              minimum-scale=1.0">

        <title>Guardar Usuario | Checknassist</title>

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
        <link href="css/registro.css" rel="stylesheet" type="text/css"/>

    </head>

    <body>

        <div class="pos-f-t">
            <div class="collapse" id="navbarToggleExternalContent">
                <div class="bg-dark p-4">
                    <h5 class="text-white h4">Menu</h5>
                    <span class="text-muted">Toggleable via the navbar brand.</span>
                </div>
            </div>
            <nav class="navbar navbar-dark bg-dark">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <img src="/docs/4.4/assets/brand/bootstrap-solid.svg" width="30" height="30" alt="">

            </nav>
        </div>

        <section class="container-fluid bg">
<!--            <span style="color: #000"> 
                //<?php
//                if (@$_SESSION["usuario"] == null) {
//                    print_r("Ud no deberia ver este contenido, avisar al admin");
//                    header("location:login.php");
//                } else {
//                    print_r(@$_SESSION["usuario"]);
//                    
//                }
//                
            ?></span>-->



            <section class="row justify-content-center">


                <section class="col-sm-1 col-md-10">


                    <form class="form-container" action="login.php" method="POST">
                        <p class="h4 mb-4 naranja"><strong>Registro de usuario</strong></p>
                        <div class="form-row" >

                            <div class="form-group col-md-3">

                                <label for="inputEmail4"><span class="verde">Correo</span></label>
                                <input type="email" class="form-control" id="inputEmail4" placeholder="ejemplo@mail.com">
                            </div>
                            <div class="form-group col-md-3">
                                <label for="inputPassword4"><span class="verde">Contraseña</span></label>
                                <input type="password" class="form-control" id="inputPassword4" placeholder="Contraseña" minlength="8">
                            </div>


                            <div class="form-group col-md-3">
                                <label for="inputAddress"><span class="verde">Documento</span></label>
                                <input type="text" class="form-control " id="inputAddress" placeholder="1234567890" minlength="6">
                            </div>
                            <div class="form-group col-md-3 ">
                                <label for="inputState"><span class="verde">Tipo documento</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>Tarjeta de identidad</option>
                                    <option>Cedula de ciudadania</option>
                                    <option>Cedula de extranjeria</option>
                                </select>

                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-3">
                                <label for="inputAddress2"><span class="verde">Nombres</span></label>
                                <input type="text" class="form-control" id="inputAddress2" placeholder="Primer y/o segundo nombre">
                            </div>
                            <div class="form-group col-md-3">
                                <label for="inputAddress2"><span class="verde">Apellidos</span></label>
                                <input type="text" class="form-control" id="inputAddress2" placeholder="Primer y segundo apellido">
                            </div>


                            <div class="form-group col-md-3">
                                <label for="inputCity"><span class="verde">Tel</span></label>
                                <input type="text" class="form-control" id="inputCity" placeholder="#telefono">
                            </div>
                            <div class="form-group col-md-3">
                                <label for="inputState"><span class="verde">Genero</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>escoja</option>
                                    <option>Masculino</option>
                                    <option>Femenino</option>
                                    <option>Otro</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-sm-3">
                                <label for="inputState"><span class="verde">Ficha</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>1800890</option>
                                    <option>1424242</option>
                                    <option>2432432</option>
                                </select>
                            </div>

                            <div class="form-group col-sm-3">
                                <label for="inputState"><span class="verde">Rol</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>Admin</option>
                                    <option>Instructor</option>
                                    <option>Aprendiz</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-3">
                                <label for="inputState"><span class="verde">Ambiente</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>aula1</option>
                                    <option>aula2</option>
                                    <option>aula3</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-3">
                                <label for="inputState"><span class="verde">Trimestre</span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option>4</option>
                                    <option>5</option>
                                    <option>6</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-sm-3">
                                <label for="inputState"><span class="verde"><span class="verde">Programa</span></span></label>
                                <select id="inputState" class="form-control">
                                    <option selected>seleccione una opcion---></option>
                                    <option>ADSI</option>
                                    <option>MULTIMEDIA</option>
                                    <option>REDES</option>
                                </select>
                            </div>

                        </div>
                        <button type="submit" class="btn btn-primary btn-verde">REGISTRAR</button>
                    </form>

                </section>

            </section>

        </section>
        <div class="card-footer text-muted align-items-xl-end">
            COPYRIGHT SENA 2020.
        </div>


        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js" type="text/javascript"></script>
    </body>
</html>