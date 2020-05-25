<?php 
# Se va a ir modificando
include('menu.inc');
session_start();
$user = $_SESSION['usuario'];
$logg = $_SESSION['logged'];
if (isset($logg)) {
	echo '<h1 class="text-danger">Bienvenido Usuario</h1>';
}
?>

