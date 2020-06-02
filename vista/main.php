<?php 
# Se va a ir modificando
include('menu.inc');

$user = $_SESSION['user'];
$logg = $_SESSION['perfil'];
if (isset($logg)) {
	echo '<h1 class="text-danger">Bienvenido Usuario</h1>';
}
?>

