
<?php
require '../controller/Conexion.php';
$con = new Conexion();

$consulta = $con->conectar();
$consulta->set_charset("utf8");

$res = $consulta->query("SELECT * FROM `regional` where id_pais={$_GET['idpais']} order by nombre");
?>
<div class="form-group row">
<div class="col-sm-12 mb-3 mb-sm-0">
    <select id="departamento" onchange="cargarMunic(this.value)" class="form-control rounded-pill" >
        <option value="0">Seleccione un departamento</option>
        <?php while ($campos = $res->fetch_object()) { ?>
            <option value="<?php echo $campos->idRegional; ?>"><?php echo $campos->nombre; ?></option>
            <?php
        }
        ?>
    </select>
</div>
    
    
    
