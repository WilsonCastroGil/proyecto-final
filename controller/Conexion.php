<?php
Class Conexion {

    public function conectar() {
       return new mysqli("localhost", "root", "", "horario");
        
    }

}
