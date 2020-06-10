<?php
class Conexion {
	 public function conectar(){
        try {
            $con = new mysqli("localhost","root","","horario");
            $con->set_charset("utf8");
            return $con;
        } catch (Exception $exc) {
            echo $exc->getMessage();
        }
    }
}
?>