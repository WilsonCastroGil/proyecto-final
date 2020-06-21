<?php
require 'Conexion.php';
$con = new Conexion();

$consulta = $con->conectar();
$consulta->set_charset("utf8");

$res = $consulta->query("SELECT * FROM `municipio` where `idRegional`={$_GET['idMunic']} order by nombre");
?>
<div class="form-group row">
    <div class="col-sm-12 mb-3 mb-sm-0">
        <select id="municipio" name="cmbmunicipio" class="form-control rounded-pill">
            <option value="0">Seleccione un municipio</option>
            <?php while ($campos = $res->fetch_object()) { ?>
                <option value="<?php echo $campos->idMunicipio; ?>"><?php echo $campos->nombre; ?></option>
                <?php
            }
            ?>
        </select>
    </div>
  
    
