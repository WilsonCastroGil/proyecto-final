<?php
if (isset($_POST["Enviar"])) {
    $mail = @$_POST['txtcorreo'];
    $clave = @$_POST['txtcontrasena'];



    require '../controller/Conexion.php';

    $con = new Conexion(); //conecta a la base de datos

    $consultar = $con->conectar();  //ejecuta la funcion

    $resultado = $consultar->query("call sp_login('$mail','$clave')");
    if ($datos = $resultado->fetch_row()) {
//        session_start()
        print_r($datos[0]);
//        $_SESSION["logueado"] = true;
//        $_SESSION["usuario"] = $datos->correo;
//        $_SESSION["correo"] = $datos->password;
//        header("location:index.php");
    } else {
        $mensaje = "<span style='color:red'>Error los datos no son correctos<span>";
    }
} else {
    $mensaje = "<span style='color:#fc7323'>INICIAR SESION<span>";
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0,
              minimum-scale=1.0">

        <title>Inicia Sesión | Checknassist</title>
        <link rel="stylesheet" href="css/bootstrap.min.css"/>
        <link rel="stylesheet" href="css/login.css"/>
    </head>
    <body class="bg">


        <section class="row ">
            <section class="col-sm-1 col-md-10">

                <div class="container  ">
                   
                        <!-- Card -->
                        <div class=" col-md-4 ">
                            <!-- Default form login -->
                            <form class="text-center p-5 form-container" action="#">

                                <p class="h4 mb-4 naranja"><strong>Iniciar Sesión</strong></p>

                                <!-- Email -->
                                <input type="email" id="correo" class="form-control mb-4" placeholder="Correo">

                                <!-- Password -->
                                <input type="password" id="clave" class="form-control mb-4" placeholder="Contraseña">

                                <div class="d-flex justify-content-around">
                                    <div>
                                        <!-- Recuperar clave -->
                                        <a href="" class="red-text">¿Has olvidado la contraseña?</a>
                                    </div>

                                    <div id="response"></div>
                                </div>

                                <!-- Sign in button -->
<!--                                <a href="javascript:;" class="btn btn-block my-4 btn-verde" onclick="console.log(document.getElementById('correo').value + document.getElementById('clave').value);">Enviar</a>-->
<input type="Submit" name="Enviar" >
    
                                <!-- Register -->
                               
                            </form>
                            <!-- Default form login -->
                        </div>
                        <!-- Card -->
                    
                </div>
            </section>
        </section>

<!--        <section class="container-fluid bg">
            <span style="color: #000"> <?php
        print_r(@$_SESSION["usuario"]);
        ?></span>

            <section class="row justify-content-center">

                <section class="col-12 col-sm-4 col-md-2">

                    <form class="form-container" action="login.php." method="POST" >
                        <div class="form-group">
                            <label for="exampleInputEmail1">CORREO</label>
                            <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="txtcorreo">
                            <small id="emailHelp" class="form-text">El personal sena nunca te pedirá tu contraseña</small>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputPassword1">CONTRASEÑA</label>
                            <input type="password" class="form-control" id="exampleInputPassword1" name="txtcontrasena">
                        </div>
                        <div class="form-group form-check">


                        </div>
                        <button type="submit" class="btn btn-primary btn-block"type="submit" value="Iniciar" >Iniciar sesion</button>

        <?php echo "<br>" . @$mensaje; ?>
                    </form>

                </section>

            </section>

        </section>-->


        <script>src = "js/jquery-3.5.0.min.js"</script>
        <script>src = "js/bootstrap.min.js"</script>
        <script>src = "js/popper.min.js"</script>
    </body>
</html>
