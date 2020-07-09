-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-07-2020 a las 00:14:56
-- Versión del servidor: 10.4.8-MariaDB
-- Versión de PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `horario`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=CURRENT_USER PROCEDURE `aprendiz` (IN `v_nombre` VARCHAR(255), IN `v_dia` VARCHAR(255))  BEGIN
set @auxficha= (select f.numeroFicha 
							from ficha f 
							inner join detalleusu du on f.idFicha = du.idFicha
                            inner join usuario u on u.idUsuario = du.idUsuario
                            inner join detalleusuario dt on dt.idUsuario = u.idUsuario
                            where concat(dt.nombre,' ', dt.apellido) = v_nombre
                            );

select f.numeroFicha AS Ficha,a.nombre AS Ambiente,d.nombre AS Dia,ac.nombre AS nombre,CONCAT(de.nombre, ' ', de.apellido) AS Instructor,dt.TrimPeriodo AS Trimestre,dt.horaInicio AS horaInicio,dt.horaFin AS horaFin
from detalleasignacion  dt
        inner join ficha f on f.idFicha= dt.idFicha
        inner join  ambiente a on a.idAmbiente=dt.idAmbiente
        inner join dia d on d.idDia = dt.idDia
        inner join  actiproy ac on ac.idActiProy = dt.idActiProy
        inner join usuario u on u.idUsuario= dt.idUsuario
        inner join detalleusuario de on de.idUsuario = u.idUsuario
        where f.numeroFicha = @auxficha and d.nombre=v_dia;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `areaFormacion` (IN `nombreArea` VARCHAR(70))  BEGIN

Select td.TipoDocumento, dt.Documento, dt.nombre, dt.apellido, tu.tipoUsuario, f.numeroFicha, t.descripcion as Ficha, df.jornada, p.nombre
from detalleusuario dt 
inner join tipodoc td on td.idTipoDoc = dt.idTipodoc
inner join usuario u on u.idUsuario = dt.idUsuario
inner join roles r  on u.idUsuario = r.idUsuario
inner join tipousuario tu on r.idTipoUsuario = tu.idTipoUsuario 
inner join detalleasignacion da on u.idUsuario = da.idUsuario 
inner join detalleficha df on  u.idUsuario = df.idUsuario
inner join ficha f on df.idFicha = f.idFicha 
inner join resulta re on da.idResultA = re.idResultA 
inner join trimestre t on re.idTrimestre = t.idTrimestre
inner join programa p on t.idPrograma = p.idPrograma
where p.nombre  = nombreArea;

/*
select td.TipoDocumento, dt.Documento, dt.nombre, dt.apellido,u.correo,u.password, tu.tipoUsuario,r.estado
from detalleusuario dt 
inner join tipodoc td on td.idTipoDoc = dt.idTipodoc
inner join usuario u on u.idUsuario = dt.idUsuario
inner join roles r  on u.idUsuario = r.idUsuario
inner join tipousuario tu on r.idTipoUsuario = tu.idTipoUsuario 
#where dt.Documento  = v_documento;
*/
	
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `detalleUsu` ()  BEGIN
declare idaprendiz int;
DECLARE findelbucle INTEGER DEFAULT 0;

declare users cursor for 
	select distinct u.idUsuario from usuario u
	inner join roles r 
	on (u.idUsuario = r.idUsuario)
	inner join tipousuario t
	on (r.idTipoUsuario = t.idTipoUsuario)
	where t.idTipoUsuario = 3;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET findelbucle=1;

open users; 
bucle: loop
IF findelbucle = 1 THEN
	LEAVE bucle;
END IF;

fetch users into idaprendiz;

set @jornada = 'Mañana';
set @estado = 'Formación';

insert into detalleusu values (null,1,idaprendiz,@jornada,@estado);

end loop;
close users;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `guardarAsignacion` (IN `v_idDetalleA` INT, IN `v_idficha` INT, IN `v_idAmbiente` INT, IN `v_idDia` INT, IN `v_idUsuario` INT, IN `v_idActiProy` INT, IN `v_periodo` YEAR, IN `v_trimestre` INT, IN `v_horaIncio` TIME, IN `v_horaFin` TIME)  BEGIN
#crud de la tabla detalleasignacion, esta estroturado por clases 
declare msj varchar (255);
set @auxusu = (select count(idUsuario) from detalleasignacion where idUsuario = v_idUsuario and idAmbiente = v_idAmbiente and  horaInicio = v_horaIncio and idDia = v_idDia );
set @auxamb = (select count(idAmbiente) from detalleasignacion where idAmbiente = v_idAmbiente and idUsuario = v_idUsuario and horaInicio = v_horaIncio and  idDia = v_idDia );
set @auxhora = (select count(horaInicio) from detalleasignacion where horaInicio = v_horaIncio and idAmbiente = v_idAmbiente and idUsuario = v_idUsuario and  idDia = v_idDia );
set @auxdia = (select count(idDia) from detalleasignacion where idDia = v_idDia and horaInicio = v_horaIncio and idAmbiente = v_idAmbiente and idUsuario = v_idUsuario and idDia = v_idDia );
if @auxusu > 0 and @auxamb > 0 and @auxhora > 0 and @auxdia > 0 then
    set msj= "El instructor ya se le asigno ese horario";
SELECT msj;

#elseif @auxamb > 0  then
    #set msj= "El instructor ya se le asigno ese ambiente en ese horario";
    #select msj;
elseif @auxhora > 0 and  @auxusu > 0 and @auxamb = 0 and @auxdia > 0  then
    set msj= "Ya se asigno esa hora a un instructor";
SELECT msj;
elseif @auxusu = 0 and @auxamb = 0 and @auxhora = 0 and @auxdia = 0 then 
    insert into detalleasignacion values (null,v_idficha,v_idAmbiente,v_idDia,v_idUsuario,v_idActiProy,v_periodo,v_trimestre,v_horaIncio,v_horaFin);
    set msj = ("se han guardado los detalles de asignacion");
SELECT msj;
end if;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `listarAprenndiz` (IN `buscar` INT)  BEGIN


Select td.TipoDocumento, dt.Documento, dt.nombre, dt.apellido, tu.tipoUsuario, f.numeroFicha, t.descripcion as Ficha, df.jornada
from detalleusuario dt 
inner join tipodoc td on td.idTipoDoc = dt.idTipodoc
inner join usuario u on u.idUsuario = dt.idUsuario
inner join roles r  on u.idUsuario = r.idUsuario
inner join tipousuario tu on r.idTipoUsuario = tu.idTipoUsuario 
inner join detalleasignacion da on u.idUsuario = da.idUsuario 
inner join detalleficha df on  u.idUsuario = df.idUsuario
inner join ficha f on df.idFicha = f.idFicha 
inner join resulta re on da.idResultA = re.idResultA 
inner join trimestre t on re.idTrimestre = t.idTrimestre
where f.numeroFicha = buscar or  dt.documento = buscar;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `ps_RegistroAprendiz` (IN `v_idTipoDoc` INT, IN `v_documento` VARCHAR(255), IN `v_nombre` VARCHAR(255), IN `v_apellido` VARCHAR(255), IN `v_telefono` VARCHAR(255), IN `v_genero` VARCHAR(20), IN `v_correo` VARCHAR(255), IN `v_idFicha` INT, IN `v_jornada` VARCHAR(255))  BEGIN

declare mensaje varchar (255);
declare v_idTipoUsuario, v_estado int;


set v_idTipoUsuario=3; # declaro que el tipo de usuario que se balla a registar va ha ser un aprendiz
 set v_estado=1;

#la siguiente funcion compruba si el numero de documento existe 
 set @aux = (select idUsuario from detalleusuario where documento = v_documento);
 
 if  @aux > 0  then
  set mensaje= "-------------------Este usuario ya existe--------------------";
	select mensaje;
 else
	call sp_usuario(null, v_correo,v_documento,'guardar');
	set @idus = (select  max(idUsuario) from usuario); #almacenamos el ultimo  idUsuario que fue registrado
	call sp_detalleusuario(null, @idus,v_idTipoDoc,v_documento,v_nombre,v_apellido,v_telefono,v_genero, 'guardar');
	call sp_roles(null, v_idTipoUsuario,@idus,v_estado,'guardar');
    call sp_detalleusu(v_idFicha,@idus,v_jornada,v_estado, 'guardar');
 end if;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_actiproy` (IN `v_nombre` VARCHAR(255), IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla actipoy, esta estroturado por clases 
	declare msj varchar(255);
    
	case
		when opcion = 'guardar' then 
        set @aux=(select nombre from  actiproy  where nombre=v_nombre); #comprovamos que la materia no exista
		if	@aux <0 then #condicion que evalua que si se pueden ingresar mas datos
			insert into actiproy values (null,v_nombre);
					set msj = ("Se ha Guardado los datos");
					select msj;
        else
			set msj="Este elemento ya existe";
			select msj;
        end if;
	
        #_______________________________
    when opcion = 'actualizar' then
		update actiproy
		set v_nombre = v_nombre;
		set msj = ("Se han Actualizado los datos");
		select msj;
    
    when opcion = 'consultar' then
		select * from actiproy
		where idActiProy = v_idActiProy;
    
	end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_ActualizarUsuario` (IN `v_documento` INT, IN `v_idTipoDoc` INT, IN `v_nombre` VARCHAR(255), IN `v_apellido` VARCHAR(255), IN `v_telefono` VARCHAR(255), IN `v_correo` VARCHAR(255), IN `v_idTipoUsuario` INT, IN `v_estado` INT)  BEGIN
	#Declaramos las variales que vamos a utizar mas adelante en el codigo
    declare usuarioId int;
    declare mensaje varchar (255);
    
# funcion que almacena el id del usuario 
	set usuarioId = (SELECT idUsuario from detalleusuario WHERE  documento = v_documento);

#funcion de comprovacion de que el numero de documento exista 
    if usuarioId then
			#llamamos los procedimientos almacenados  de las tablas  usuario, detalleusuario, roles
			call sp_usuario(usuarioId, v_correo,v_documento,'actualizar');
			call sp_detalleusuario(0, usuarioId,v_idTipoDoc," ",v_nombre,v_apellido,  v_telefono, " ", 'actualizar');
			call sp_roles(0, v_idTipoUsuario, usuarioId, v_estado, 'actualizar');
			#mensaje que mostrara por pantalla en caso de que la accion se alla completado
			set mensaje="elemento Actualizado";
			select mensaje;
   else
			select "Este usuario no existe" as Mensaje;
	end if;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_ambiente` (IN `v_idTipoAmbiente` INT, IN `v_nombre` VARCHAR(40), IN `v_capacidad` INT, IN `opcion` VARCHAR(40))  BEGIN
#crud de la tabla ambiente, esta estroturado por clases 

declare msj varchar (255);

case
	when opcion = 'guardar' then
		insert into ambiente values(null,v_idTipoAmbiente,v_nombre,v_capacidad);
		set msj = ("se guardo el ambiente");
		select msj;

	when opcion = 'actualizar' then
		update ambiente set nombre = v-nombre,capacidad = v_capacidad where idAmbiente = v_idAmbiente;
		set msj = ("se actualizo el ambiente");  
		select msj;

	when opcion = 'consultar' then
		select * from ambiente where idAmbiente = v_idAmbiente;
		
	when opcion = 'listar' then
		select * from ambiente;

end case;
  
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_competencia` (IN `v_idPrograma` INT, IN `v_nombre` VARCHAR(255), IN `v_codigo` INT, IN `v_estado` INT, IN `opcion` VARCHAR(50))  BEGIN
#crud de la tabla competencia, esta estroturado por clases 
declare msj varchar(255);
case
	when opcion = 'guardar' then
		INSERT INTO competencia VALUES(null,v_idPrograma,v_nombre,v_codigo,v_estado);
		set msj = ("se ha guardado la competencia");
		select msj;

	when opcion = 'actualizar' then
		update competencia set nombre=v_nombre,codigo=v_codigo where idCompetencia=v_idCompetencia;
		set msj = ("se ha actualizado la competencia");
		select msj;

	when opcion = 'eliminar' then
		update competencia set estado=v_estado where idCompetencia=v_idCompetencia;
		set msj = ("se ha eliminado la competencia");
		select msj;

	when opcion = 'listar' then 
		select * from competencia;

	when opcion = 'consultar' then 
		select * from competencia where idCompetencia=v_idCompetencia;
        
end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_detalleasignacion` (IN `v_idficha` INT, IN `v_idAmbiente` INT, IN `v_idDia` INT, IN `v_idUsuario` INT, IN `v_idActiProy` INT, IN `v_periodo` YEAR, IN `v_trimestre` INT, IN `v_horaIncio` TIME, IN `v_horaFin` TIME, IN `opcion` VARCHAR(50))  BEGIN
#crud de la tabla detalleasignacion, esta estroturado por clases 
declare msj varchar (255);
set v_horaIncio = (SELECT DATE_FORMAT(concat('0000-00-00 ',v_horaIncio), "%H:%i"));
set v_horaFin = (SELECT DATE_FORMAT(concat('0000-00-00 ',v_horaFin), "%H:%i"));
case
	when opcion = 'guardar' then
		insert into detalleasignacion values (null,v_idficha,v_idAmbiente,v_idDia,v_idUsuario,v_idActiProy,v_periodo,v_trimestre,v_horaIncio,v_horaFin);
		set msj = ("se han guardado los detalles de asignacion");
		select msj;

	when opcion = 'actualizar' then
		update detalleasignacion set horaInicio = v_horaInicio,horaFin = v_horaFin where idDetalleA = v_idDetalleA;
		set msj = ("se han actualizado los detalles de asignacion");
		select msj;
    
	when opcion ='consultar' then 
		select * from detalleasignacion where idDetalleA = v_idDetalleA;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_detalleusu` (IN `v_idFicha` INT, IN `v_idUsuario` INT, IN `v_jornada` VARCHAR(30), IN `v_estado` INT, IN `opcion` VARCHAR(45))  BEGIN
#crud de la tabla detalleusu, esta estroturado por clases 
declare msj varchar (255);
case
	when opcion = 'guardar' then
		insert into detalleusu values(null,v_idFicha,v_idUsuario,v_jornada,v_estado);
        
	when opcion = 'actualizar' then
		update detalleusu set jornada=v_jornada where idDetalleF=v_idDetalleF;
   
	when opcion = 'eliminar' then
		update detalleusu set estado=v_estado where idDetalleF=v_idDetalleF;
     
	when opcion = 'listar' then
		select * from detalleusu;
        
   /*     select td.TipoDocumento, dt.Documento, concat(dt.nombre,' ', dt.apellido)as Nombres,u.correo,u.password,f.numeroFicha,de.jornada,tu.tipousuario
from detalleusuario dt 
inner join tipodoc td on td.idTipoDoc = dt.idTipodoc
inner join usuario u on u.idUsuario = dt.idUsuario
inner join roles r  on u.idUsuario = r.idUsuario
inner join tipousuario tu on r.idTipoUsuario = tu.idTipoUsuario 
inner join detalleusu de on de.idUsuario=u.idUsuario
inner join ficha f on f.idFicha=de.idFicha
where dt.Documento  = v_documento;*/

        
end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_detalleusuario` (IN `v_idDetalleUsu` INT, IN `v_idUsuario` INT, IN `v_idTipoDoc` INT, IN `v_documento` VARCHAR(255), IN `v_nombre` VARCHAR(255), IN `v_apellido` VARCHAR(255), IN `v_telefono` VARCHAR(255), IN `v_genero` VARCHAR(255), IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla detalleusuario, esta estroturado por clases 
case
	when opcion='guardar' then
		insert into detalleusuario values (v_idDetalleUsu,v_idUsuario,V_idTipoDoc,v_documento,v_nombre,v_apellido,v_telefono,v_genero);

	when opcion = 'consultar'
		then select * from detalleusuario where idUsuario=v_idUsuario;

	when opcion = 'actualizar' then 
		update detalleusuario set  idTipoDoc=v_idTipoDoc,nombre=v_nombre,apellido=v_apellido,telefono=v_telefono where idUsuario=v_idUsuario;

	when opcion='eliminar' then
		delete from detalleusuario where idDetalleUsu = v_idDetalleUsu;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_detaProject` (IN `v_idActiProy` INT, IN `v_idResultA` INT, IN `v_estado` INT, IN `opcion` VARCHAR(255))  BEGIN
	declare msj varchar(255);
	case
    when opcion = 'guardar' then 
		insert into detaProject values (null,v_idActiProy,v_idResultA,v_estado);
		set msj = ("Se ha Guardado los datos");
		select msj;
		
    when opcion = 'actualizar' then
		update detaProject
		set v_iddetaProject = v_iddetaProject;
		set msj = ("Se han Actualizado los datos");
		select msj;
    
    when opcion = 'consultar' then
		select * from detaProject
		where v_iddetaProject = v_iddetaProject;
    
    end case;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_dia` (IN `v_idDia` INT, IN `v_nombre` VARCHAR(30), IN `v_estado` INT, IN `opcion` VARCHAR(50))  BEGIN
#crud de la tabla dia, esta estroturado por clases 
declare msj varchar (255);
case
	when opcion ='guardar' then
		insert into dia values (null,v_nombre,v_estado);
		set msj = ("se ha guardado el dia");
		select msj;

	when opcion = 'actualizar' then
		update dia set nombre = v_nombre,estado = v_estado where idDia = v_idDia;
		set msj = ("se ha actualizado el dia");
		select msj;

	when opcion = 'listar' then 
		select * from dia where idDia = v_idDia;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_EliminarUsuario` (IN `v_documento` INT)  BEGIN
    #decalracion de la variable de mensajes 
    declare mensaje varchar (255);
    
	# Declaramos variables para almacenar los ids
    declare ax_usuario int;
    declare ax_idDetalleUsuario int;
    declare ax_idRoles int;
    
	#almacenamos el id de la tabla  DetalleUsuario
    set ax_idDetalleUsuario=(select idDetalleUsu from  detalleusuario where  documento = v_documento);
    #almacenamos el id de la tabla  usuario
	set ax_usuario= (SELECT idUsuario from detalleusuario WHERE  documento = v_documento);
    #almacenamos el id de la tabla  Roles
    set ax_idRoles=(select idRol from roles where ax_usuario=idUsuario);

	#compravacion del que el documeto no alla sido eliminado antes
	if ax_idDetalleUsuario then
			#llamos los procedimietos almacenados de las tablas detalleusuario,usuario y roles con la opcion eliminar
			call sp_detalleusuario(ax_idDetalleUsuario, 0,0, " ", " ", " ",  " ", " ", 'eliminar');
			call sp_usuario(ax_usuario, " "," ",'eliminar');
			call sp_roles(ax_idRoles,0, 0,0, 'eliminar');
            #el mesaje de que retorna si el elemento a sido eliminado
			select  concat ("Este elemento ", v_documento," fue eliminado" ) as Mensaje;
	   else
       #mesaje que retorna en caso de que este elemento ya alla sido eliminado o no exista
				select concat ("Este usuario  ",v_documento,"  ya fue eliminado") as Mensaje;
		end if; 
    
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_ficha` (IN `v_idPrograma` INT, IN `v_fechaInicio` DATE, IN `v_fechaFin` DATE, IN `v_cantidadAprendiz` INT, IN `v_numeroFicha` INT, IN `opcion` VARCHAR(45))  BEGIN
#crud de la tabla ficha, esta estroturado por clases 
declare msj varchar(255);

case
	when opcion = 'guardar' then
        #comoprovamos si el numero de ficha ya existe
        set @aux=(select numeroFicha from ficha where  numeroFicha=v_numeroFicha);
        
		if	@aux >0 then #condicion que evalua que si se pueden ingresar mas dato
					set msj="Este numero de ficha ya existe";
                    select msj;
        else
			insert into ficha values(null,v_idPrograma,v_fechaInicio,v_fechaFin,v_cantidadAprendiz,v_numeroFicha); 
			set msj = ("se ha guardado la ficha");
			select msj;
        end if;
        
	when opcion = 'actualizar' then 
		update ficha set fechaFin=v_fechaFin,cantidadAprendiz=v_cantidadAprendiz where idFicha=v_idFicha;
        set msj = ("se ha actualizado la ficha");
		select msj;
        
	when  opcion = 'eliminar' then
		update ficha set estado=v_estado where idFicha=v_idFicha;
        set msj = ("se ha eliminado la ficha");
		select msj;
        
	when opcion = 'listar' then
		select * from ficha;
        
	when opcion = 'consultar' then
		select * from ficha where idFicha=v_idFicha;
        
end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_GuardarDocente` (IN `v_idTipoDoc` INT, IN `v_documento` VARCHAR(255), IN `v_nombre` VARCHAR(255), IN `v_apellido` VARCHAR(255), IN `v_telefono` VARCHAR(255), IN `v_genero` VARCHAR(20), IN `v_correo` VARCHAR(255))  BEGIN
#Declaramos las variales que vamos a utizar mas adelante en el codigo
declare mensaje varchar (255);
declare v_estado,v_idTipoUsuario int;

set v_estado=1;
set v_idTipoUsuario=2;


#la siguiente funcion compruba si el numero de documento existe 
 set @aux = (select ifnull(idUsuario,0) from detalleusuario where documento = v_documento);
	
# Buscarmos el perfil= 
set @userexist = (select count(idTipoUsuario) from roles where idTipoUsuario = v_idTipoUsuario and idUsuario = @aux );

#comprovacion  de si el usuario ya existe 
if  @aux > 0 and @userexist = 1 then
    set mensaje= "-------------------Este instructor  ya existe--------------------";
	select mensaje;
elseif  @aux is null and @userexist = 0 then
	#llamamos los procedimientos almacenados  de las tablas  usuario, detalleusuario, roles
	call sp_usuario(null, v_correo,v_documento,'guardar');
	set @idus = (select  max(idUsuario) from usuario); #almacenamos el ultimo  idUsuario que fue registrado
	call sp_detalleusuario(null, @idus,v_idTipoDoc,v_documento,v_nombre,v_apellido,v_telefono,v_genero, 'guardar');
	call sp_roles(null, v_idTipoUsuario,@idus,  v_estado, 'guardar');
      set mensaje="Instructor registrado";
    select mensaje;
elseif  @aux > 1 and @userexist = 0 then
	call sp_roles(null, v_idTipoUsuario,@aux,  v_estado, 'guardar');
 end if;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_GuardarUsuario` (IN `v_idTipoDoc` INT, IN `v_documento` VARCHAR(255), IN `v_nombre` VARCHAR(255), IN `v_apellido` VARCHAR(255), IN `v_telefono` VARCHAR(255), IN `v_genero` VARCHAR(20), IN `v_correo` VARCHAR(255), IN `v_idTipoUsuario` INT, IN `v_estado` TINYINT(1))  BEGIN
#Declaramos las variales que vamos a utizar mas adelante en el codigo
declare mensaje varchar (255);

#la siguiente funcion compruba si el numero de documento existe 
 set @aux = (select ifnull(idUsuario,0) from detalleusuario where documento = v_documento);
	
# Buscarmos el perfil= 
set @userexist = (select count(idTipoUsuario) from roles where idTipoUsuario = v_idTipoUsuario and idUsuario = @aux );

#comprovacion  de si el usuario ya existe 
if  @aux > 0 and @userexist = 1 then
    set mensaje= "-------------------Este usuario ya existe--------------------";
	select mensaje;
elseif  @aux is null and @userexist = 0 then
	#llamamos los procedimientos almacenados  de las tablas  usuario, detalleusuario, roles
	call sp_usuario(null, v_correo,v_documento,'guardar');
	set @idus = (select  max(idUsuario) from usuario); #almacenamos el ultimo  idUsuario que fue registrado
	call sp_detalleusuario(null, @idus,v_idTipoDoc,v_documento,v_nombre,v_apellido,v_telefono,v_genero, 'guardar');
	call sp_roles(null, v_idTipoUsuario,@idus,  v_estado, 'guardar');
      set mensaje="elemento guardado";
    select mensaje;
elseif  @aux > 1 and @userexist = 0 then
	call sp_roles(null, v_idTipoUsuario,@aux,  v_estado, 'guardar');
 end if;

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_login` (IN `user` VARCHAR(256), IN `pass` VARCHAR(256))  BEGIN
declare sesion,perfiles varchar(256);

set @user = (SELECT usuario FROM v_login WHERE correo = user and password =sha( pass) and estado = 1 limit 1);
set @aministrador=(SELECT count(tipoUsuario) FROM v_login WHERE correo = user and password = sha(pass) and estado = 1 and tipoUsuario='Admin' limit 1);
set @instructor =(SELECT count(tipoUsuario) FROM v_login WHERE correo = user and password = sha(pass) and estado = 1 and tipoUsuario='Instructor' limit 1);
set @Aprendiz =(SELECT count(tipoUsuario) FROM v_login WHERE correo = user and password = sha(pass) and estado = 1 and tipoUsuario='Aprendiz' limit 1);

set perfiles = (select concat(@user,';',@aministrador,';',@instructor,';',@Aprendiz));

#select @aministrador;
#select @instructor;
#select @Aprendiz;
#select @user;
#select perfiles;
if perfiles is null then
select 'error';
else 
select perfiles;
end if;

/*
if @aministrador ='Admin' then
	set sesion = 'Admin';	
elseif @Instructor='Instructor'  then
	set sesion = 'Instructor';
else
	set sesion = 'Aprendiz';	
end if;

set @resultado =(concat(@user,';',sesion));
select @resultado as resultado;*/

END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_programa` (IN `v_idCentro` INT, IN `v_nombre` VARCHAR(50), IN `v_tipoFormacion` VARCHAR(50), IN `v_estado` INT, IN `opcion` VARCHAR(50))  BEGIN
#crud de la tabla programa, esta estroturado por clases 
declare msj varchar (255);

case 
	when opcion = 'guardar' then
		insert into programa values(null,v_idCentro,v_nombre,v_tipoFormacion,v_estado);
		set msj = ("se ha guardado el programa");
		select msj;
        
	when opcion = 'actualizar' then
		update programa set nombre=v_nombre,tipoFormacion=v_tipoFormacion,horario=v_horario where idPrograma=v_idPrograma;
		set msj = ("se ha actualizado el programa");
		select msj;
        
	when opcion = 'eliminar' then
		update programa set estado=v_estado where idPrograma=v_idPrograma;
        set msj = ("se ha eliminado el programa");
		select msj;
        
	when opcion = 'listar' then
		select * from programa;
        
	when opcion = 'consultar' then
		select * from programa where idPrograma=v_idPrograma;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_resulta` (IN `v_idResultA` INT, IN `v_idTrimestre` INT, IN `v_idCompetencia` INT, IN `v_nombre` VARCHAR(255), IN `v_resultacom` INT, IN `v_estado` INT, IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla resulta, esta estroturado por clases 
declare msj varchar(255);
case
    when opcion = 'Guardar' then
		insert into resulta values (v_idResultA,v_idTrimestre,v_idCompetencia,v_nombre,v_resultacom,v_estado);
		set msj = ("Se han Guardado los datos");
		select msj;
		
    when opcion = 'Actualizar' then
		update resulta set idTrimestre = v_idTrimestre,idCompetencia=v_idCompetencia, nombre = v_nombre,codigocom=v_resultacom
		where idResultA = v_idResultA;
		set msj = ("Se han Actualizado los datos");
		select msj;
		
    when opcion = 'Consultar' then 
		select * from resulta where idResultA = v_idResultA;
    
end case;    
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_roles` (IN `v_idRol` INT, IN `v_idTipoUsuario` INT, IN `v_idUsuario` INT, IN `v_estado` INT, IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla resulta, esta estroturado por clases 
case 
	when opcion='guardar' then
		INSERT INTO roles VALUES (v_idRol,v_idTipoUsuario,v_idUsuario,v_estado);

	when opcion='actualizar' then
		update roles set idTipoUsuario=v_idTipoUsuario,estado=v_estado where idUsuario=v_idUsuario;

	when opcion='consultar' then 
		select * from roles where idRol=v_idRol;

	when opcion='eliminar' then 
		delete from roles where idRol=v_idRol;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_tipoambiente` (IN `v_idTipoAmbiente` INT, IN `v_nombre` VARCHAR(50), IN `v_estado` INT, IN `opcion` VARCHAR(40))  BEGIN
#crud de la tabla tipoambiente, esta estroturado por clases 
declare msj varchar(255);
case
	when opcion = 'Guardar' then
		insert into tipoambiente values (v_idTipoAmbiente,v_nombre,v_estado);
		set msj = ("se ha guardado el tipo de ambiente");
		SELECT msj;

	when opcion ='Actualizar' then
		update tipoambiente set nombre = v_nombre,estado = v_estado where idTipoAmbiente = v_idTipoAmbiente;
		set msj = ("se ha actualizado el tipo de ambiente");
		SELECT msj;

	when opcion = 'Listar' then
		select * from tipoambiente where idTipoAmbiente = v_idTipoAmbiente;

end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_trimestre` (IN `v_idTrimestre` INT, IN `v_idPrograma` INT, IN `v_descripcion` VARCHAR(255), IN `v_estado` VARCHAR(255), IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla trimestre, esta estroturado por clases 
declare msj varchar(255);
case
	when opcion = 'cuardar' then
		insert into trimestre values (v_idTrimestre,v_idPrograma,v_descripcion,v_estado);
		set msj=("Se han Guardado los datos");
		select msj;

	when opcion = 'actualizar' then 
		update trimestre set descripcion = v_descripcion, estado = v_estado where v_idTrimestre = v_idTrimestre;
		set msj =("Se ha Actualizado el trimestre");
		select msj;

	when opcion = 'consultar'then 
		select * from trimestre where idTrimestre = v_idTrimestre;
    
	end case;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `sp_usuario` (IN `v_idUsuario` INT, IN `v_correo` VARCHAR(255), IN `v_pass` VARCHAR(255), IN `opcion` VARCHAR(255))  BEGIN
#crud de la tabla usuario, esta estroturado por clases 
case
	when opcion='guardar' then
		insert into usuario values(v_idUsuario,v_correo,sha(v_pass));

	when opcion = 'actualizar' then
		update usuario set correo = v_correo,password=sha(v_pass) where idUsuario=V_idUsuario;

	when opcion ='consultar' then
		select * from usuario where idUsuario=v_idUsuario;

	when opcion='eliminar' then 
		delete from usuario where idUsuario=v_idUsuario;

end case;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actiproy`
--

CREATE TABLE `actiproy` (
  `idActiProy` int(11) NOT NULL COMMENT 'identificador de la tabla actiproy',
  `nombre` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'el nombre del actividad  y el proyecto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `actiproy`
--

INSERT INTO `actiproy` (`idActiProy`, `nombre`) VALUES
(1, 'java'),
(2, 'app android'),
(3, 'wed zase'),
(4, 'modelo relacional'),
(5, 'Python'),
(6, 'Emprendimiento'),
(7, 'Scrum'),
(8, 'HTML'),
(9, 'Java web'),
(10, 'Matematicas 1'),
(11, 'Matematicas 2'),
(12, 'Arquiterura de software');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ambiente`
--

CREATE TABLE `ambiente` (
  `idAmbiente` int(11) NOT NULL COMMENT 'identificador de la tabla ambiente',
  `idTipoAmbien` int(11) NOT NULL COMMENT 'id de la tabla tipo de  ambiente',
  `nombre` varchar(40) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del ambiente',
  `capacidad` int(11) NOT NULL COMMENT 'la capacidad de personas que pueden haber en el ambiente\\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ambiente`
--

INSERT INTO `ambiente` (`idAmbiente`, `idTipoAmbien`, `nombre`, `capacidad`) VALUES
(1, 1, 'Software 1', 40),
(2, 1, 'Software 2', 35),
(3, 1, 'Software 3', 30),
(4, 2, 'Multimedia 1', 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `centro`
--

CREATE TABLE `centro` (
  `idCentro` int(11) NOT NULL COMMENT 'identificador del centro ',
  `idSede` int(11) NOT NULL COMMENT 'id de la tabla sede',
  `nombre` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del centro',
  `direccion` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'donde esta ubicado el el centro',
  `telefono` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'telefono del centro al cual se pueda comunicar',
  `correo` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'correo  del centro al cual se pueda comunicar',
  `director` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del director del centro',
  `estado` int(11) NOT NULL COMMENT 'estado en que se  encuentra el centro'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `centro`
--

INSERT INTO `centro` (`idCentro`, `idSede`, `nombre`, `direccion`, `telefono`, `correo`, `director`, `estado`) VALUES
(1, 1, 'Centro de Tecnología de la Manufactura Avanzada', 'Carrera 68 #104, Complejo Norte,', '(4) 4442800', 'sena@misena.edu.co', 'sergio david sepulveda montoya', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `competencia`
--

CREATE TABLE `competencia` (
  `idCompetencia` int(11) NOT NULL,
  `idPrograma` int(11) NOT NULL,
  `nombre` varchar(255) CHARACTER SET latin1 NOT NULL,
  `codigo` varchar(25) CHARACTER SET latin1 NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `competencia`
--

INSERT INTO `competencia` (`idCompetencia`, `idPrograma`, `nombre`, `codigo`, `estado`) VALUES
(1, 1, 'PROMOVER LA INTERACCION IDONEA CONSIGO MISMO, CON LOS DEMAS Y CON LA NATURALEZA EN LOS CONTEXTOS LABORAL Y SOCIA', '1', 1),
(2, 1, 'RESULTADOS DE APRENDIZAJE ETAPA PRACTICA', '2', 1),
(3, 1, 'COMPRENDER TEXTOS EN INGLÉS EN FORMA ESCRITA Y AUDITIVA', '3226', 1),
(4, 1, 'PRODUCIR TEXTOS EN INGLÉS EN FORMA ESCRITA Y ORAL', '3227', 1),
(5, 1, 'CONSTRUIR EL SISTEMA QUE CUMPLA CON LOS REQUISITOS DE LA SOLUCIÓN INFORMÁTICA', '35320', 1),
(6, 1, 'ANALIZAR LOS REQUISITOS DEL CLIENTE PARA CONSTRUIR EL SISTEMA DE INFORMACION', '35322', 1),
(7, 1, 'IMPLANTAR LA SOLUCIÓN QUE CUMPLA CON LOS REQUISITOS PARA SU OPERACIÓN', '35325', 1),
(8, 1, 'PARTICIPAR EN EL PROCESO DE NEGOCIACIÓN DE TECNOLOGÍA INFORMÁTICA PARA PERMITIR LA IMPLEMENTACIÓN DEL SISTEMA DE INFORMACIÓN', '35327', 1),
(9, 1, 'APLICAR BUENAS PRÁCTICAS DE CALIDAD EN EL PROCESO DE DESARROLLO DE SOFTWARE, DE ACUERDO CON EL REFERENTE ADOPTADO EN LA EMPRESA', '35329', 1),
(10, 1, 'ESPECIFICAR LOS REQUISITOS NECESARIOS PARA DESARROLLAR EL SISTEMA DE INFORMACION DE ACUERDO CON LAS NECESIDADES DEL CLIENTE', '35332', 1),
(11, 1, 'DISEÑAR EL SISTEMA DE ACUERDO CON LOS REQUISITOS DEL CLIENTE', '35333', 1);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `detalleaprendiz`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `detalleaprendiz` (
`documento` int(11)
,`nombre` varchar(510)
,`numeroFicha` int(11)
,`Dia` varchar(30)
,`Ambiente` varchar(40)
,`Materia` varchar(45)
,`trimestre` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleasignacion`
--

CREATE TABLE `detalleasignacion` (
  `idDetalleA` int(11) NOT NULL COMMENT 'identicador de la tabla',
  `idFicha` int(11) NOT NULL COMMENT 'id de la tabla ficha',
  `idAmbiente` int(11) NOT NULL COMMENT 'id de latabla ambiente ',
  `idDia` int(11) NOT NULL COMMENT 'id de la tabla dia',
  `idUsuario` int(11) NOT NULL COMMENT 'id de la tabla usuario',
  `idActiProy` int(11) NOT NULL,
  `Periodo` year(4) NOT NULL COMMENT 'Año lectivo (2020)',
  `TrimPeriodo` int(11) NOT NULL COMMENT 'Trimestre del periodo.\nSolo son 4 porque el año tiene 4 trimestres',
  `horaInicio` time NOT NULL COMMENT 'es la hora de de inicio de cada clase',
  `horaFin` time NOT NULL COMMENT 'marca el fin  de las clases '
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleusu`
--

CREATE TABLE `detalleusu` (
  `idDetalleF` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `idFicha` int(11) NOT NULL COMMENT 'id de la tabla detalle de la ficha',
  `idUsuario` int(11) NOT NULL COMMENT 'id de la tabla usuario',
  `jornada` varchar(30) CHARACTER SET latin1 NOT NULL COMMENT 'las jornadas determinadas M.T.N',
  `estado` int(11) NOT NULL COMMENT 'El estado de la jornada activa o no activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='detalle de aprendiz';

--
-- Volcado de datos para la tabla `detalleusu`
--

INSERT INTO `detalleusu` (`idDetalleF`, `idFicha`, `idUsuario`, `jornada`, `estado`) VALUES
(1, 1, 15, 'mañana', 1),
(2, 1, 16, 'mañana', 1),
(3, 1, 17, 'mañana', 1),
(4, 1, 18, 'mañana', 1),
(5, 1, 19, 'mañana', 1),
(6, 1, 20, 'mañana', 1),
(7, 1, 21, 'mañana', 1),
(8, 1, 22, 'mañana', 1),
(9, 1, 23, 'mañana', 1),
(10, 1, 24, 'mañana', 1),
(11, 1, 25, 'mañana', 1),
(12, 1, 26, 'mañana', 1),
(13, 1, 27, 'mañana', 1),
(14, 1, 28, 'mañana', 1),
(15, 1, 29, 'mañana', 1),
(16, 1, 30, 'mañana', 1),
(17, 1, 31, 'mañana', 1),
(18, 1, 32, 'mañana', 1),
(19, 1, 33, 'mañana', 1),
(20, 1, 34, 'mañana', 1),
(21, 1, 35, 'mañana', 1),
(22, 1, 36, 'mañana', 1),
(23, 1, 37, 'mañana', 1),
(24, 1, 38, 'mañana', 1),
(25, 1, 39, 'mañana', 1),
(26, 1, 40, 'mañana', 1),
(27, 1, 41, 'mañana', 1),
(28, 1, 42, 'mañana', 1),
(29, 1, 43, 'mañana', 1),
(30, 1, 44, 'mañana', 1),
(31, 1, 45, 'mañana', 1),
(32, 1, 46, 'mañana', 1),
(33, 1, 47, 'mañana', 1),
(34, 2, 48, 'mañana', 1),
(35, 2, 49, 'mañana', 1),
(36, 2, 50, 'mañana', 1),
(37, 2, 51, 'mañana', 1),
(38, 2, 52, 'mañana', 1),
(39, 2, 53, 'mañana', 1),
(40, 2, 54, 'mañana', 1),
(41, 2, 55, 'mañana', 1),
(42, 2, 56, 'mañana', 1),
(43, 2, 57, 'mañana', 1),
(44, 2, 58, 'mañana', 1),
(45, 2, 59, 'mañana', 1),
(46, 2, 60, 'mañana', 1),
(47, 2, 61, 'mañana', 1),
(48, 2, 62, 'mañana', 1),
(49, 2, 63, 'mañana', 1),
(50, 2, 64, 'mañana', 1),
(51, 2, 65, 'mañana', 1),
(52, 2, 66, 'mañana', 1),
(53, 2, 67, 'mañana', 1),
(54, 2, 68, 'mañana', 1),
(55, 2, 69, 'mañana', 1),
(56, 2, 70, 'mañana', 1),
(57, 2, 71, 'mañana', 1),
(58, 2, 72, 'mañana', 1),
(59, 2, 73, 'mañana', 1),
(60, 3, 74, 'mañana', 1),
(61, 3, 75, 'mañana', 1),
(62, 3, 76, 'mañana', 1),
(63, 3, 77, 'mañana', 1),
(64, 3, 78, 'mañana', 1),
(65, 3, 79, 'mañana', 1),
(66, 3, 80, 'mañana', 1),
(67, 3, 81, 'mañana', 1),
(68, 3, 82, 'mañana', 1),
(69, 3, 83, 'mañana', 1),
(70, 3, 84, 'mañana', 1),
(71, 3, 85, 'mañana', 1),
(72, 3, 86, 'mañana', 1),
(73, 3, 87, 'mañana', 1),
(74, 3, 88, 'mañana', 1),
(75, 3, 89, 'mañana', 1),
(76, 3, 90, 'mañana', 1),
(77, 3, 91, 'mañana', 1),
(78, 3, 92, 'mañana', 1),
(79, 3, 93, 'mañana', 1),
(80, 3, 94, 'mañana', 1),
(81, 3, 95, 'mañana', 1),
(82, 3, 96, 'mañana', 1),
(83, 3, 97, 'mañana', 1),
(84, 3, 98, 'mañana', 1),
(85, 3, 99, 'mañana', 1),
(86, 3, 100, 'mañana', 1),
(87, 4, 101, 'mañana', 1),
(88, 4, 102, 'mañana', 1),
(89, 4, 103, 'mañana', 1),
(90, 4, 104, 'mañana', 1),
(91, 4, 105, 'mañana', 1),
(92, 4, 106, 'mañana', 1),
(93, 4, 107, 'mañana', 1),
(94, 4, 108, 'mañana', 1),
(95, 4, 109, 'mañana', 1),
(96, 4, 110, 'mañana', 1),
(97, 4, 111, 'mañana', 1),
(98, 4, 112, 'mañana', 1),
(99, 4, 113, 'mañana', 1),
(100, 4, 114, 'mañana', 1),
(101, 4, 115, 'mañana', 1),
(102, 4, 116, 'mañana', 1),
(103, 4, 117, 'mañana', 1),
(104, 4, 118, 'mañana', 1),
(105, 4, 119, 'mañana', 1),
(106, 4, 120, 'mañana', 1),
(107, 4, 121, 'mañana', 1),
(108, 4, 122, 'mañana', 1),
(109, 4, 123, 'mañana', 1),
(110, 4, 124, 'mañana', 1),
(111, 4, 125, 'mañana', 1),
(112, 4, 126, 'mañana', 1),
(113, 4, 127, 'mañana', 1),
(114, 4, 128, 'mañana', 1),
(115, 4, 129, 'mañana', 1),
(116, 4, 130, 'mañana', 1),
(117, 4, 131, 'mañana', 1),
(118, 4, 132, 'mañana', 1),
(119, 4, 133, 'mañana', 1),
(120, 4, 134, 'mañana', 1),
(121, 4, 135, 'mañana', 1),
(122, 4, 136, 'mañana', 1),
(123, 4, 137, 'mañana', 1),
(124, 4, 138, 'mañana', 1),
(125, 4, 139, 'mañana', 1),
(126, 4, 140, 'mañana', 1),
(127, 5, 141, 'noche', 1),
(128, 5, 142, 'noche', 1),
(129, 5, 143, 'noche', 1),
(130, 5, 144, 'noche', 1),
(131, 5, 145, 'noche', 1),
(132, 5, 146, 'noche', 1),
(133, 5, 147, 'noche', 1),
(134, 5, 148, 'noche', 1),
(135, 5, 149, 'noche', 1),
(136, 5, 150, 'noche', 1),
(137, 5, 151, 'noche', 1),
(138, 5, 152, 'noche', 1),
(139, 5, 153, 'noche', 1),
(140, 5, 154, 'noche', 1),
(141, 5, 155, 'noche', 1),
(142, 5, 156, 'noche', 1),
(143, 5, 157, 'noche', 1),
(144, 5, 158, 'noche', 1),
(145, 5, 159, 'noche', 1),
(146, 5, 160, 'noche', 1),
(147, 5, 161, 'noche', 1),
(148, 5, 162, 'noche', 1),
(149, 5, 163, 'noche', 1),
(150, 5, 164, 'noche', 1),
(151, 5, 165, 'noche', 1),
(152, 5, 166, 'noche', 1),
(153, 5, 167, 'noche', 1),
(154, 5, 168, 'noche', 1),
(155, 5, 169, 'noche', 1),
(156, 5, 170, 'noche', 1),
(157, 5, 171, 'noche', 1),
(158, 5, 172, 'noche', 1),
(159, 5, 173, 'noche', 1),
(160, 5, 174, 'noche', 1),
(161, 5, 175, 'noche', 1),
(162, 5, 176, 'noche', 1),
(163, 5, 177, 'noche', 1),
(164, 5, 178, 'noche', 1),
(165, 6, 179, 'noche', 1),
(166, 6, 180, 'noche', 1),
(167, 6, 181, 'noche', 1),
(168, 6, 182, 'noche', 1),
(169, 6, 183, 'noche', 1),
(170, 6, 184, 'noche', 1),
(171, 6, 185, 'noche', 1),
(172, 6, 186, 'noche', 1),
(173, 6, 187, 'noche', 1),
(174, 6, 188, 'noche', 1),
(175, 6, 189, 'noche', 1),
(176, 6, 190, 'noche', 1),
(177, 6, 191, 'noche', 1),
(178, 6, 192, 'noche', 1),
(179, 6, 193, 'noche', 1),
(180, 6, 194, 'noche', 1),
(181, 6, 195, 'noche', 1),
(182, 6, 196, 'noche', 1),
(183, 12, 197, 'tarde', 1),
(184, 12, 198, 'tarde', 1),
(185, 12, 199, 'tarde', 1),
(186, 12, 200, 'tarde', 1),
(187, 12, 201, 'tarde', 1),
(188, 12, 202, 'tarde', 1),
(189, 12, 203, 'tarde', 1),
(190, 12, 204, 'tarde', 1),
(191, 12, 205, 'tarde', 1),
(192, 12, 206, 'tarde', 1),
(193, 12, 207, 'tarde', 1),
(194, 12, 208, 'tarde', 1),
(195, 12, 209, 'tarde', 1),
(196, 12, 210, 'tarde', 1),
(197, 12, 211, 'tarde', 1),
(198, 12, 212, 'tarde', 1),
(199, 12, 213, 'tarde', 1),
(200, 12, 214, 'tarde', 1),
(201, 12, 215, 'tarde', 1),
(202, 12, 216, 'tarde', 1),
(203, 12, 217, 'tarde', 1),
(204, 12, 218, 'tarde', 1),
(205, 12, 219, 'tarde', 1),
(206, 12, 220, 'tarde', 1),
(207, 12, 221, 'tarde', 1),
(208, 12, 222, 'tarde', 1),
(209, 12, 223, 'tarde', 1),
(210, 12, 224, 'tarde', 1),
(211, 12, 225, 'tarde', 1),
(212, 12, 226, 'tarde', 1),
(213, 12, 227, 'tarde', 1),
(214, 12, 228, 'tarde', 1),
(215, 12, 229, 'tarde', 1),
(216, 12, 230, 'tarde', 1),
(217, 12, 231, 'tarde', 1),
(218, 12, 232, 'tarde', 1),
(219, 12, 233, 'tarde', 1),
(220, 12, 234, 'tarde', 1),
(221, 12, 235, 'tarde', 1),
(222, 11, 236, 'tarde', 1),
(223, 11, 237, 'tarde', 1),
(224, 11, 238, 'tarde', 1),
(225, 11, 239, 'tarde', 1),
(226, 11, 240, 'tarde', 1),
(227, 11, 241, 'tarde', 1),
(228, 11, 242, 'tarde', 1),
(229, 11, 243, 'tarde', 1),
(230, 11, 244, 'tarde', 1),
(231, 11, 245, 'tarde', 1),
(232, 11, 246, 'tarde', 1),
(233, 11, 247, 'tarde', 1),
(234, 11, 248, 'tarde', 1),
(235, 11, 249, 'tarde', 1),
(236, 11, 250, 'tarde', 1),
(237, 11, 251, 'tarde', 1),
(238, 11, 252, 'tarde', 1),
(239, 11, 253, 'tarde', 1),
(240, 11, 254, 'tarde', 1),
(241, 11, 255, 'tarde', 1),
(242, 11, 256, 'tarde', 1),
(243, 11, 257, 'tarde', 1),
(244, 11, 258, 'tarde', 1),
(245, 11, 259, 'tarde', 1),
(246, 11, 260, 'tarde', 1),
(247, 11, 261, 'tarde', 1),
(248, 11, 262, 'tarde', 1),
(249, 10, 265, 'tarde', 1),
(250, 10, 266, 'tarde', 1),
(251, 10, 267, 'tarde', 1),
(252, 10, 268, 'tarde', 1),
(253, 10, 269, 'tarde', 1),
(254, 10, 270, 'tarde', 1),
(255, 10, 271, 'tarde', 1),
(256, 10, 272, 'tarde', 1),
(257, 10, 273, 'tarde', 1),
(258, 10, 274, 'tarde', 1),
(259, 10, 275, 'tarde', 1),
(260, 10, 276, 'tarde', 1),
(261, 10, 277, 'tarde', 1),
(262, 10, 278, 'tarde', 1),
(263, 10, 279, 'tarde', 1),
(264, 10, 280, 'tarde', 1),
(265, 10, 281, 'tarde', 1),
(266, 10, 282, 'tarde', 1),
(267, 10, 283, 'tarde', 1),
(268, 10, 284, 'tarde', 1),
(269, 10, 285, 'tarde', 1),
(270, 10, 286, 'tarde', 1),
(271, 10, 287, 'tarde', 1),
(272, 10, 288, 'tarde', 1),
(273, 10, 289, 'tarde', 1),
(274, 10, 290, 'tarde', 1),
(275, 10, 291, 'tarde', 1),
(276, 10, 292, 'tarde', 1),
(277, 10, 293, 'tarde', 1),
(278, 10, 294, 'tarde', 1),
(279, 10, 295, 'tarde', 1),
(280, 9, 296, 'tarde', 1),
(281, 9, 297, 'tarde', 1),
(282, 9, 298, 'tarde', 1),
(283, 9, 299, 'tarde', 1),
(284, 9, 300, 'tarde', 1),
(285, 9, 301, 'tarde', 1),
(286, 9, 302, 'tarde', 1),
(287, 9, 303, 'tarde', 1),
(288, 9, 304, 'tarde', 1),
(289, 9, 305, 'tarde', 1),
(290, 9, 306, 'tarde', 1),
(291, 9, 307, 'tarde', 1),
(292, 9, 308, 'tarde', 1),
(293, 9, 309, 'tarde', 1),
(294, 9, 310, 'tarde', 1),
(295, 9, 311, 'tarde', 1),
(296, 9, 312, 'tarde', 1),
(297, 9, 313, 'tarde', 1),
(298, 9, 314, 'tarde', 1),
(299, 9, 315, 'tarde', 1),
(300, 9, 316, 'tarde', 1),
(301, 9, 317, 'tarde', 1),
(302, 9, 318, 'tarde', 1),
(303, 9, 319, 'tarde', 1),
(304, 9, 320, 'tarde', 1),
(305, 8, 321, 'tarde', 1),
(306, 8, 322, 'tarde', 1),
(307, 8, 323, 'tarde', 1),
(308, 8, 324, 'tarde', 1),
(309, 8, 325, 'tarde', 1),
(310, 8, 326, 'tarde', 1),
(311, 8, 327, 'tarde', 1),
(312, 8, 328, 'tarde', 1),
(313, 8, 329, 'tarde', 1),
(314, 8, 330, 'tarde', 1),
(315, 8, 331, 'tarde', 1),
(316, 8, 332, 'tarde', 1),
(317, 8, 333, 'tarde', 1),
(318, 8, 334, 'tarde', 1),
(319, 8, 335, 'tarde', 1),
(320, 8, 336, 'tarde', 1),
(321, 8, 337, 'tarde', 1),
(322, 8, 338, 'tarde', 1),
(323, 8, 339, 'tarde', 1),
(324, 8, 340, 'tarde', 1),
(325, 8, 341, 'tarde', 1),
(326, 8, 342, 'tarde', 1),
(327, 8, 343, 'tarde', 1),
(328, 8, 344, 'tarde', 1),
(329, 7, 345, 'tarde', 1),
(330, 7, 346, 'tarde', 1),
(331, 7, 347, 'tarde', 1),
(332, 7, 348, 'tarde', 1),
(333, 7, 349, 'tarde', 1),
(334, 7, 350, 'tarde', 1),
(335, 7, 351, 'tarde', 1),
(336, 7, 352, 'tarde', 1),
(337, 7, 353, 'tarde', 1),
(338, 7, 354, 'tarde', 1),
(339, 7, 355, 'tarde', 1),
(340, 7, 356, 'tarde', 1),
(341, 7, 357, 'tarde', 1),
(342, 7, 358, 'tarde', 1),
(343, 7, 359, 'tarde', 1),
(344, 7, 360, 'tarde', 1),
(345, 7, 361, 'tarde', 1),
(346, 7, 362, 'tarde', 1),
(347, 7, 363, 'tarde', 1),
(348, 7, 364, 'tarde', 1),
(349, 7, 365, 'tarde', 1),
(350, 7, 366, 'tarde', 1),
(351, 7, 367, 'tarde', 1),
(352, 7, 368, 'tarde', 1),
(353, 7, 369, 'tarde', 1),
(354, 7, 370, 'tarde', 1),
(355, 7, 371, 'tarde', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleusuario`
--

CREATE TABLE `detalleusuario` (
  `idDetalleUsu` int(11) NOT NULL COMMENT 'EL identificador de la tabla',
  `idUsuario` int(11) NOT NULL COMMENT 'El id de la tabla  usuario',
  `idTipoDoc` int(11) NOT NULL COMMENT 'el id de la tabla tipo  documento',
  `documento` int(11) NOT NULL COMMENT 'numero de identificacion del usuario',
  `nombre` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'Nombre propio del usuario',
  `apellido` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'apellido propio de un usuario',
  `telefono` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'numero a cual se le puede contatar',
  `genero` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'que al que pertece la pertenece la persona'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalleusuario`
--

INSERT INTO `detalleusuario` (`idDetalleUsu`, `idUsuario`, `idTipoDoc`, `documento`, `nombre`, `apellido`, `telefono`, `genero`) VALUES
(1, 1, 1, 2020, 'Administrador', 'del programa', '1234', 'M'),
(2, 2, 1, 71481380, ' ARMANDO EDILBERTO', 'MARIN GUZMAN', '5678', 'Masculino'),
(3, 3, 1, 98645726, ' WILSON', 'CASTRO GIL', '5678', 'Masculino'),
(4, 4, 1, 98565240, 'ADALBERTO', 'CARCAMO ALVARADO', '5678', 'Masculino'),
(5, 5, 1, 1040749467, 'ANDREA CAROLINA', 'BEDOYA GOMEZ', '5678', 'Femenina'),
(6, 6, 1, 1077451742, 'CHRISTIAN CAMILO', 'SERNA GAMEZ', '5678', 'Masculino'),
(7, 7, 1, 21954838, 'DORA MARIA ', ' ARCILA MOLINA', '5678', 'Masculino'),
(8, 8, 1, 14395983, 'EDER LARA', 'TRUJILLO ', '5678', 'Masculino'),
(9, 9, 1, 98582870, 'HAROL MAURICIO', 'GOMEZ ZAPATA', '5678', 'Masculino'),
(10, 10, 1, 71749015, 'INGO ANDRES', 'SCHUSSLER ROJO', '5678', 'Masculino'),
(11, 11, 1, 8355601, 'IVAN MAURICIO', 'CASTA?EDA GOMEZ', '5678', 'Masculino'),
(12, 12, 1, 1036609490, 'JUAN GUILLERMO', ' HERNANDEZ GIRALDO', '5678', 'Masculino'),
(13, 13, 1, 45486076, 'LUZ MERY', 'CARCAMO ALVARADO', '5678', 'Femenina'),
(14, 14, 1, 43182932, 'MARIA JULIETA ', ' RAMIREZ GAVIRIA', '5678', 'Femenina'),
(15, 15, 1, 1000084228, 'YENNIFER', 'GOMEZ GIL', '1234', 'Mosculinos'),
(16, 16, 1, 1000304810, 'KEVIN ANDRES', 'ORREGO GOMEZ', '1234', 'Mosculinos'),
(17, 17, 2, 1000565214, 'DAWINZON ARLEY', 'POLO CIRO', '1234', 'Mosculinos'),
(18, 18, 1, 1000748038, 'JUAN SEBASTIAN', 'VAHOS RODAS', '1234', 'Mosculinos'),
(19, 19, 1, 1000883553, 'DIEGO ALEJANDRO', 'ROMERO MOSQUERA', '1234', 'Mosculinos'),
(20, 20, 2, 1000922106, 'CAROLINA', 'CALLE VELEZ', '1234', 'Mosculinos'),
(21, 21, 2, 1000922445, 'MANUELA', 'REYES PE?ARANDA', '1234', 'Mosculinos'),
(22, 22, 2, 1001362780, 'JOSE DAVID', 'RAMIREZ GOMEZ', '1234', 'Mosculinos'),
(23, 23, 2, 1001463874, 'ANDRES MARIANO', 'BUSTAMANTE CASTRO', '1234', 'Mosculinos'),
(24, 24, 1, 1001637214, 'JHON HADER', 'ROJAS CABRERA', '1234', 'Mosculinos'),
(25, 25, 2, 1003290312, 'JOHN BAIRON', 'HOLGUIN MONTALVO', '1234', 'Mosculinos'),
(26, 26, 1, 1007240178, 'SANTIAGO', 'HERNANDEZ CHAVARRIAGA', '1234', 'Mosculinos'),
(27, 27, 2, 1007304708, 'FELIPE', 'RESTREPO CARDONA', '1234', 'Mosculinos'),
(28, 28, 1, 1007704966, 'SEBASTIAN', 'ORTIZ MU?OZ', '1234', 'Mosculinos'),
(29, 29, 1, 1007836261, 'JAIBER ALESSIS', 'RUA VILLA', '1234', 'Mosculinos'),
(30, 30, 1, 1017262417, 'ESTEFANIA', 'GONZALEZ LOAIZA', '1234', 'Mosculinos'),
(31, 31, 1, 1020453300, 'MARIA VIRGINIA', 'CADAVID ROJAS', '1234', 'Mosculinos'),
(32, 32, 1, 1020463781, 'LUIS FELIPE', 'LONDO?O GUTIERREZ', '1234', 'Mosculinos'),
(33, 33, 1, 1035875909, 'MANUEL ALEJANDRO', 'SILVA SALDARRIAGA', '1234', 'Mosculinos'),
(34, 34, 1, 1036631006, 'YENNYFER ALEXANDRA', 'GONZALEZ PULGARIN', '1234', 'Mosculinos'),
(35, 35, 1, 1036672733, 'KEVIN', 'ARDILA LOPERA', '1234', 'Mosculinos'),
(36, 36, 1, 1054993942, 'IRMA LORENA', 'VELEZ PEREZ', '1234', 'Mosculinos'),
(37, 37, 1, 1060596704, 'KELLY DANIELA', 'VELEZ ECHEVERRI', '1234', 'Mosculinos'),
(38, 38, 1, 1117553876, 'JUAN DAVID', 'VARGAS MAHECHA', '1234', 'Mosculinos'),
(39, 39, 1, 1128427257, 'JHOAN CAMILO', 'MURILLO CASTA?EDA', '1234', 'Mosculinos'),
(40, 40, 1, 1128459336, 'JHON EVER', 'VELASQUEZ ROLDAN', '1234', 'Mosculinos'),
(41, 41, 1, 1152460225, 'SARA LIZETH', 'URREA QUINTERO', '1234', 'Mosculinos'),
(42, 42, 1, 1152714062, 'MIGUEL ANGEL', 'RUIZ AVENDA?O', '1234', 'Mosculinos'),
(43, 43, 1, 1152714894, 'YESID DE JESUS', 'RODELO SAENZ', '1234', 'Mosculinos'),
(44, 44, 1, 1152715837, 'BRAINER ESTEBAN', 'BETANCUR GONZALEZ', '1234', 'Mosculinos'),
(45, 45, 1, 1192895823, 'JUAN JOSE', 'VILLA ALZATE', '1234', 'Mosculinos'),
(46, 46, 1, 1234990789, 'JHON DAVINSON', 'HIGUITA OSORIO', '1234', 'Mosculinos'),
(47, 47, 1, 98699456, 'JOSE ANDERSON', 'CARMONA RIVERA', '1234', 'Mosculinos'),
(48, 48, 1, 1000888498, 'ANNY CAROLINA', 'RENGIFO CARVAJAL', '1234', 'Mosculinos'),
(49, 49, 1, 1020487827, 'CAMILO', 'MORENO VALLEJO', '1234', 'Mosculinos'),
(50, 50, 1, 1002596062, 'CRISTIAN', 'RIVERA MU?OZ', '1234', 'Mosculinos'),
(51, 51, 1, 1020395328, 'DAVID SEBASTIAN', 'MORENO PEREZ', '1234', 'Mosculinos'),
(52, 52, 2, 1000100335, 'DIEGO ALEJANDRO', 'CARVAJAL MONSALVE', '1234', 'Mosculinos'),
(53, 53, 1, 1039652203, 'FABER ANTONIO', 'QUEJADA PESTA?A', '1234', 'Mosculinos'),
(54, 54, 2, 1003177832, 'FABIAN', 'RIVERA ESPITIA', '1234', 'Mosculinos'),
(55, 55, 1, 1035865102, 'FAY JORDANY', 'MURILLO JARAMILLO', '1234', 'Mosculinos'),
(56, 56, 1, 1007606012, 'IBIS LORENA', 'MURILLO ALTAMIRANO', '1234', 'Mosculinos'),
(57, 57, 2, 1193574555, 'JHON SEBASTIAN', 'RINCON PARDO', '1234', 'Mosculinos'),
(58, 58, 1, 1216726698, 'JHOVANI', 'PINEDA ALVAREZ', '1234', 'Mosculinos'),
(59, 59, 1, 1007704963, 'JOGAN SMITH', 'ORTIZ MU?OZ', '1234', 'Mosculinos'),
(60, 60, 1, 1035867338, 'JONNATHAN', 'PAREJA ALVAREZ', '1234', 'Mosculinos'),
(61, 61, 1, 1039625157, 'JUAN DAVID', 'GARCIA OCHOA', '1234', 'Mosculinos'),
(62, 62, 1, 1234989732, 'JUAN DIEGO', 'MEJIA ROBBY', '1234', 'Mosculinos'),
(63, 63, 1, 1216729638, 'JUAN FELIPE', 'OSPINA MEJIA', '1234', 'Mosculinos'),
(64, 64, 1, 1000887983, 'JUAN PABLO', 'ZEA SANMARTIN', '1234', 'Mosculinos'),
(65, 65, 1, 1000566325, 'MATEO ANDRES', 'RUEDA ARBOLEDA', '1234', 'Mosculinos'),
(66, 66, 1, 1007433601, 'NICOLAS', 'ACEVEDO IDARRAGA', '1234', 'Mosculinos'),
(67, 67, 1, 71212664, 'OSCAR ANDRES', 'LOPEZ VELASQUEZ', '1234', 'Mosculinos'),
(68, 68, 1, 1018346367, 'OSCAR DARIO', 'CORREA DAVID', '1234', 'Mosculinos'),
(69, 69, 1, 71702129, 'OSCAR MANUEL', 'GOMEZ MARTINEZ', '1234', 'Mosculinos'),
(70, 70, 1, 1037644284, 'ROBERT BRANDON', 'MU?OZ LARREA', '1234', 'Mosculinos'),
(71, 71, 2, 1123990247, 'SANTIAGO RAFAEL', 'GARCIA CARRETERO', '1234', 'Mosculinos'),
(72, 72, 1, 1035441676, 'SEBASTIAN', 'ESCUDERO PATI?O', '1234', 'Mosculinos'),
(73, 73, 1, 1001017291, 'SIMON', 'MONTOYA ZAPATA', '1234', 'Mosculinos'),
(74, 74, 1, 1000393648, 'BRAYAN ANDRES', 'CRUZ LOPEZ', '1234', 'Mosculinos'),
(75, 75, 1, 98704535, 'CARLOS MARIO', 'RAMIREZ TUBERQUIA', '1234', 'Mosculinos'),
(76, 76, 2, 1001539667, 'CESAR DAVID', 'AGUDELO IDARRAGA', '1234', 'Mosculinos'),
(77, 77, 1, 1035389134, 'CRISTIAN JULIAN', 'ZAPATA JARAMILLO', '1234', 'Mosculinos'),
(78, 78, 1, 1003086844, 'DAIRO CAMILO', 'PATI?O HERRERA', '1234', 'Mosculinos'),
(79, 79, 1, 1000394214, 'DANIEL FELIPE', 'CASTA?O CARDONA', '1234', 'Mosculinos'),
(80, 80, 1, 1007716231, 'ELKIN DARIO', 'LEZCANO CANO', '1234', 'Mosculinos'),
(81, 81, 1, 1007242934, 'ESTEBAN', 'FLOREZ ZULUAGA', '1234', 'Mosculinos'),
(82, 82, 1, 1152713036, 'FREDY ALEJANDRO', 'HERNANDEZ AMAYA', '1234', 'Mosculinos'),
(83, 83, 1, 1007623388, 'JAIRO LUIS', 'MIRANDA MRSIGLIA', '1234', 'Mosculinos'),
(84, 84, 1, 1001140227, 'JHON ALEXIS', 'HOLGUIN COGOLLO', '1234', 'Mosculinos'),
(85, 85, 1, 1128465037, 'JHON FREDY', 'MEDINA PULGARIN', '1234', 'Mosculinos'),
(86, 86, 1, 1063309609, 'JORGE ELIECER', 'ALMARALES HENAO', '1234', 'Mosculinos'),
(87, 87, 2, 1000411471, 'JOSE ALEJANDRO', 'RAMIREZ CARDONA', '1234', 'Mosculinos'),
(88, 88, 2, 1007622387, 'JUAN ANDRES', 'ESCOBAR ESCOBAR', '1234', 'Mosculinos'),
(89, 89, 1, 1020489401, 'JUAN ANDRES', 'AGUDELO QUICENO', '1234', 'Mosculinos'),
(90, 90, 1, 1001415941, 'JUAN DIEGO', 'CASTA?EDA CARDONA', '1234', 'Mosculinos'),
(91, 91, 1, 1037623517, 'JUAN FELIPE', 'SUAREZ CUARTAS', '1234', 'Mosculinos'),
(92, 92, 2, 1193307866, 'LUIS ANTONIO', 'ARIZA RADA', '1234', 'Mosculinos'),
(93, 93, 1, 1020452735, 'MARCO ANTONIO', 'CALLE GOMEZ', '1234', 'Mosculinos'),
(94, 94, 1, 1007471783, 'MARLENI DEL SOCORRO', 'AGUDELO AGUDELO', '1234', 'Mosculinos'),
(95, 95, 1, 1020466162, 'OSCAR ANDRES', 'OCHOA SUAREZ', '1234', 'Mosculinos'),
(96, 96, 2, 1005457823, 'ROBERTO CARLOS', 'DE LA OSSA MARTINEZ', '1234', 'Mosculinos'),
(97, 97, 2, 1001451822, 'SANDRA MALLERLY', 'GARCIA GUTIERREZ', '1234', 'Mosculinos'),
(98, 98, 1, 1001468733, 'SANTIAGO', 'HERRERA ZAPATA', '1234', 'Mosculinos'),
(99, 99, 1, 1032248694, 'VIVIANA', 'CASAS RAMOS', '1234', 'Mosculinos'),
(100, 100, 1, 1193117857, 'YARITZA SHIRLEY', 'RAMIREZ FANDI?O', '1234', 'Mosculinos'),
(101, 101, 2, 1000442227, 'ANA MARIA', 'HIGUITA BARRIENTOS', '1234', 'Mosculinos'),
(102, 102, 2, 1002148283, 'ANDREA VANESSA', 'ZAPATA TUBERQUIA', '1234', 'Mosculinos'),
(103, 103, 2, 1000403170, 'ANDRES FELIPE', 'QUICENO MARIN', '1234', 'Mosculinos'),
(104, 104, 2, 1000412754, 'ANDRES FELIPE', 'SOTO SOTO', '1234', 'Mosculinos'),
(105, 105, 2, 1000441577, 'ANDRES FELIPE', 'LONDO?O CASTRO', '1234', 'Mosculinos'),
(106, 106, 1, 1000887407, 'ANDRES FELIPE', 'MORALES PUERTA', '1234', 'Mosculinos'),
(107, 107, 2, 1000660018, 'ANDREY', 'TOBON MEDINA', '1234', 'Mosculinos'),
(108, 108, 2, 1000086201, 'CRISTIAN CAMILO', 'PEREZ MARTINEZ', '1234', 'Mosculinos'),
(109, 109, 2, 1000638180, 'DANIEL', 'VARGAS MARTINEZ', '1234', 'Mosculinos'),
(110, 110, 1, 1000538073, 'DAVID', 'USUGA PANESSO', '1234', 'Mosculinos'),
(111, 111, 1, 1001366286, 'DAVID', 'ROJAS JARAMILLO', '1234', 'Mosculinos'),
(112, 112, 2, 1000536237, 'EVELYN', 'MONTOYA MONTOYA', '1234', 'Mosculinos'),
(113, 113, 2, 1000898343, 'EVELYN ANDREA', 'OSSA VANEGAS', '1234', 'Mosculinos'),
(114, 114, 2, 1007415133, 'JHAN CARLOS', 'BETANCUR ACOSTA', '1234', 'Mosculinos'),
(115, 115, 2, 1006110691, 'JHOSELINE DAYANA', 'MOSQUERA VERGARA', '1234', 'Mosculinos'),
(116, 116, 1, 1000763348, 'JORGE ALEJANDRO', 'LOPEZ MURILLO', '1234', 'Mosculinos'),
(117, 117, 1, 1001670854, 'JUAN DIEGO', 'ALCALDE ALFONSO', '1234', 'Mosculinos'),
(118, 118, 2, 1000660335, 'JUAN JOSE', 'SANCHEZ BUENO', '1234', 'Mosculinos'),
(119, 119, 1, 1000532426, 'JUAN PABLO', 'BONNET QUINCHIA', '1234', 'Mosculinos'),
(120, 120, 2, 1001015663, 'JUAN PABLO', 'ARROYAVE OSORIO', '1234', 'Mosculinos'),
(121, 121, 1, 1238938130, 'JULIAN', 'FLOREZ FERNANDEZ', '1234', 'Mosculinos'),
(122, 122, 2, 1000534160, 'KAREN JOHANA', 'ORTIZ ARIAS', '1234', 'Mosculinos'),
(123, 123, 2, 1003239031, 'LIBARDO LUIS', 'LOPEZ BARRERA', '1234', 'Mosculinos'),
(124, 124, 2, 1001451794, 'LINA MARCELA', 'GONZALEZ GIL', '1234', 'Mosculinos'),
(125, 125, 2, 1000402801, 'LINAY YULIANI', 'MU?OZ PEREZ', '1234', 'Mosculinos'),
(126, 126, 2, 1000886343, 'LUCIANO', 'ALZATE RESTREPO', '1234', 'Mosculinos'),
(127, 127, 2, 1000899418, 'MARIA CAMILA', 'PATI?O LOPEZ', '1234', 'Mosculinos'),
(128, 128, 1, 1193071142, 'MAYERLIN FRANCENY', 'GAVIRIA VELEZ', '1234', 'Mosculinos'),
(129, 129, 1, 1193416161, 'MICHELL', 'GRISALES ECHAVARRIA', '1234', 'Mosculinos'),
(130, 130, 2, 1000898043, 'NATALIA', 'HERRERA CASTA?O', '1234', 'Mosculinos'),
(131, 131, 1, 1000089623, 'SANTIAGO', 'ALVAREZ QUIROZ', '1234', 'Mosculinos'),
(132, 132, 1, 1000645988, 'SANTIAGO', 'ANGEL HOYOS', '1234', 'Mosculinos'),
(133, 133, 2, 1000871030, 'SANTIAGO', 'GONZALEZ NORE?A', '1234', 'Mosculinos'),
(134, 134, 2, 1001132323, 'SANTIAGO', 'LOPEZ ZAPATA', '1235', 'Mosculinos'),
(135, 135, 2, 1001539643, 'SANTIAGO', 'LOPEZ VEGA', '1236', 'Mosculinos'),
(136, 136, 2, 1001686786, 'SANTIAGO', 'JARAMILLO VELASQUEZ', '1237', 'Mosculinos'),
(137, 137, 1, 1000396140, 'SEBASTIAN', 'ALVAREZ ATEHORTUA', '1238', 'Mosculinos'),
(138, 138, 2, 1007055030, 'SHAREN MELISA', 'RIOS LONDO?O', '1239', 'Mosculinos'),
(139, 139, 2, 1001709867, 'SIMON', 'RIVERA AGUDELO', '1240', 'Mosculinos'),
(140, 140, 2, 1001369454, 'VANESA', 'JIMENEZ TORO', '1241', 'Mosculinos'),
(141, 141, 1, 1039459054, 'ALEXANDER', 'SIERRA GALLEGO', '1234', 'Mosculinos'),
(142, 142, 1, 1017183719, 'ANDRES FELIPE', 'PAEZ MONTOYA', '1234', 'Mosculinos'),
(143, 143, 1, 1020467365, 'ANDRES FELIPE', 'HERRERA VANEGAS', '1234', 'Mosculinos'),
(144, 144, 1, 1036661658, 'CAMILO ALEJANDRO', 'ARANGO CEBALLOS', '1234', 'Mosculinos'),
(145, 145, 1, 1128465467, 'CESAR AUGUSTO', 'MU?OZ VALENCIA', '1234', 'Mosculinos'),
(146, 146, 1, 98702322, 'CESAR AUGUSTO', 'CASTRO RIOS', '1234', 'Mosculinos'),
(147, 147, 1, 1017202442, 'CRISTIAN CAMILO', 'RODRIGUEZ SANCHEZ', '1234', 'Mosculinos'),
(148, 148, 1, 1128434964, 'CRISTIAN ENRIQUE', 'PEREA MORENO', '1234', 'Mosculinos'),
(149, 149, 1, 1035876637, 'DANILO', 'CARMONA JIMENEZ', '1234', 'Mosculinos'),
(150, 150, 1, 1037661683, 'DAVID ALEJANDRO', 'SANCHEZ LONDO?O', '1234', 'Mosculinos'),
(151, 151, 1, 1037975962, 'DIANA MARCELA', 'MARTINEZ DUQUE', '1234', 'Mosculinos'),
(152, 152, 1, 1128392342, 'DIEGO ALEJANDRO', 'TORO ', '1234', 'Mosculinos'),
(153, 153, 1, 15518538, 'DIEGO FERNANDO', 'ECHEVERRI CADAVID', '1234', 'Mosculinos'),
(154, 154, 1, 1017152063, 'ELIANA MARCELA', 'OSSA MONTOYA', '1234', 'Mosculinos'),
(155, 155, 1, 1017205710, 'FRANCISCO JOSE', 'VALENCIA MONSALVE', '1234', 'Mosculinos'),
(156, 156, 1, 1017156987, 'FRANK FERNANDO', 'MU?OZ BEDOYA', '1234', 'Mosculinos'),
(157, 157, 1, 1038361053, 'GILMER ALFONSO', 'OSPINA PALACIO', '1234', 'Mosculinos'),
(158, 158, 1, 1000885064, 'IVAN SANTIAGO', 'HIGUITA RAMIREZ', '1234', 'Mosculinos'),
(159, 159, 1, 1001526457, 'JAVIER ANDRES', 'POSADA LOPEZ', '1234', 'Mosculinos'),
(160, 160, 1, 1035229561, 'JEFFERSON JAIR', 'MAYORGA QUINTERO', '1234', 'Mosculinos'),
(161, 161, 1, 1037593106, 'JONATHAN', 'HINESTROZA ', '1234', 'Mosculinos'),
(162, 162, 1, 1193567966, 'JONIER ALEXANDER', 'DAZA MORENO', '1234', 'Mosculinos'),
(163, 163, 1, 1128425471, 'JONNATHAN', 'DAVID GALLEGO', '1234', 'Mosculinos'),
(164, 164, 1, 98761093, 'JOSE ALEXANDER', 'GOMEZ LOPEZ', '1234', 'Mosculinos'),
(165, 165, 1, 1020424348, 'JUAN CAMILO', 'CATA?O PE?A', '1234', 'Mosculinos'),
(166, 166, 1, 1030611818, 'JUAN CAMILO', 'BENAVIDES ACOSTA', '1234', 'Mosculinos'),
(167, 167, 1, 1020405786, 'JUAN CARLOS', 'VIDAL PULGARIN', '1234', 'Mosculinos'),
(168, 168, 1, 1000088582, 'JUAN DIEGO', 'CANO VALENCIA', '1234', 'Mosculinos'),
(169, 169, 1, 1037618157, 'JUAN DIEGO', 'VILLA MONTOYA', '1234', 'Mosculinos'),
(170, 170, 1, 1152694111, 'JUAN FERNANDO', 'BUSTAMANTE LOPEZ', '1234', 'Mosculinos'),
(171, 171, 1, 1037669805, 'JUAN PABLO', 'LIENDO VELEZ', '1234', 'Mosculinos'),
(172, 172, 1, 1020425907, 'JUAN SEBASTIAN', 'VALENCIA MORALES', '1234', 'Mosculinos'),
(173, 173, 1, 1152437822, 'LISETH YULIANA', 'LEON VALENCIA', '1234', 'Mosculinos'),
(174, 174, 1, 1128424514, 'MOISES', 'CRESPO GALEANO', '1235', 'Mosculinos'),
(175, 175, 1, 1216720972, 'SANTIAGO', 'GONZALEZ VARGAS', '1236', 'Mosculinos'),
(176, 176, 1, 1152715235, 'SARA', 'HENAO SERNA', '1237', 'Mosculinos'),
(177, 177, 1, 11808273, 'WILFER AMADO', 'PEREA PARRA', '1238', 'Mosculinos'),
(178, 178, 1, 1042772460, 'YEISON DAVIER', 'SOSA PATI?O', '1239', 'Mosculinos'),
(179, 179, 1, 1013635839, 'DANIELA', 'CANO REYES', '1234', 'Mosculinos'),
(180, 180, 1, 1017184413, 'CARLOS ANDRES', 'QUEJADA MOSQUERA', '1234', 'Mosculinos'),
(181, 181, 1, 1017264677, 'ALEJANDRO', 'MARIN JIMENEZ', '1234', 'Mosculinos'),
(182, 182, 1, 1020415897, 'JHORMAN HUMBERTO', 'ZAPATA CIFUENTES', '1234', 'Mosculinos'),
(183, 183, 1, 1020452901, 'DIEGO ALEXANDER', 'MIRANDA GALLEGO', '1234', 'Mosculinos'),
(184, 184, 1, 1035232461, 'DIEGO ALEXANDER', 'HERRERA CAICEDO', '1234', 'Mosculinos'),
(185, 185, 1, 1036624899, 'YHOYMER HANS', 'MOSQUERA LOZANO', '1234', 'Mosculinos'),
(186, 186, 1, 1036648587, 'BRAHAMN ALEXANDER', 'DUQUE GUZMAN', '1234', 'Mosculinos'),
(187, 187, 1, 1037072299, 'SERGIO ANTONIO', 'MORALES CLAVIJO', '1234', 'Mosculinos'),
(188, 188, 1, 1037575343, 'KELLY JOHANA', 'ESCOBAR RIOS', '1234', 'Mosculinos'),
(189, 189, 1, 1037575589, 'ALEXANDER', 'GOMEZ SIERRA', '1234', 'Mosculinos'),
(190, 190, 1, 1116238166, 'ANDRES EDUARDO', 'DUQUE ARRUBLA', '1234', 'Mosculinos'),
(191, 191, 1, 1140866940, 'JUAN DAVID', 'HERNANDEZ PEDRAZA', '1234', 'Mosculinos'),
(192, 192, 1, 63546199, 'MAIRA LILIANA', 'ALZATE LOPEZ', '1234', 'Mosculinos'),
(193, 193, 1, 70753123, 'ELKIN DARIO', 'VANEGAS GRISALES', '1234', 'Mosculinos'),
(194, 194, 1, 71738718, 'LUIS ALBERTO', 'DUQUE MESA', '1234', 'Mosculinos'),
(195, 195, 1, 8063621, 'LUIS ENRIQUE', 'GOMEZ PALACIO', '1234', 'Mosculinos'),
(196, 196, 1, 8129031, 'CESAR AUGUSTO', 'GUZMAN GARCIA', '1234', 'Mosculinos'),
(197, 197, 1, 1000101368, 'CAMILO', 'GIRALDO GUZMAN', '1234', 'Mosculinos'),
(198, 198, 2, 1000191987, 'JANDI ANDRES', 'RODRIGUEZ GARCIA', '1234', 'Mosculinos'),
(199, 199, 1, 1000311821, 'SANTIAGO', 'ARIAS ACEVEDO', '1234', 'Mosculinos'),
(200, 200, 1, 1000407608, 'JUAN ESTEBAN', 'ORTIZ MARTINEZ', '1234', 'Mosculinos'),
(201, 201, 2, 1000413219, 'MANUELA', 'DUQUE PULGARIN', '1234', 'Mosculinos'),
(202, 202, 1, 1000438891, 'JOSE MIGUEL', 'VILLA CA?AS', '1234', 'Mosculinos'),
(203, 203, 2, 1000440870, 'DURLEY CAMILA', 'AVENDA?O GUTIERREZ', '1234', 'Mosculinos'),
(204, 204, 2, 1000442141, 'STEFANYA', 'AYALA GUZMAN', '1234', 'Mosculinos'),
(205, 205, 2, 1000443602, 'JOHAN ELOY', 'SANCHEZ HERNANDEZ', '1234', 'Mosculinos'),
(206, 206, 1, 1000444585, 'RICARDO', 'MONTOYA BETANCUR', '1234', 'Mosculinos'),
(207, 207, 2, 1000535247, 'LAURA VICTORIA', 'ACEVEDO PUERTA', '1234', 'Mosculinos'),
(208, 208, 1, 1000564779, 'MARIA ALEJANDRA', 'GOMEZ ALVAREZ', '1234', 'Mosculinos'),
(209, 209, 2, 1000567468, 'JACOBO ALEJANDRO', 'LAVERDE ZAPATA', '1234', 'Mosculinos'),
(210, 210, 2, 1000567937, 'GINA MELISSA', 'ESTRADA ALZATE', '1234', 'Mosculinos'),
(211, 211, 2, 1000568768, 'EDDY SANTIAGO', 'OSPINA ESTRADA', '1234', 'Mosculinos'),
(212, 212, 2, 1000569010, 'JULIAN STIVEN', 'QUIMBAYA JIMENEZ', '1234', 'Mosculinos'),
(213, 213, 2, 1000661771, 'JUAN ESTEBAN', 'CAMPERO MONTOYA', '1234', 'Mosculinos'),
(214, 214, 2, 1000661899, 'MIGUEL ANGEL', 'ARANGO AGUDELO', '1234', 'Mosculinos'),
(215, 215, 2, 1000755987, 'MATEO', 'DE LA ROSA ROJAS', '1234', 'Mosculinos'),
(216, 216, 1, 1000888789, 'EDWAR', 'LOPEZ HENAO', '1234', 'Mosculinos'),
(217, 217, 2, 1001021760, 'ANGELICA', 'ESPITIA GUERRERO', '1234', 'Mosculinos'),
(218, 218, 2, 1001250399, 'YEISON DANIEL', 'SALAZAR GIRALDO', '1234', 'Mosculinos'),
(219, 219, 2, 1001250642, 'SEBASTIAN', 'GUTIERREZ NARANJO', '1234', 'Mosculinos'),
(220, 220, 1, 1001359979, 'DONALD HAIVER', 'MOSQUERA MORENO', '1234', 'Mosculinos'),
(221, 221, 2, 1001360488, 'KAREN ESTEFANIA', 'ZAPATA GIL', '1234', 'Mosculinos'),
(222, 222, 1, 1001391317, 'MANUELA', 'RESTREPO MONROY', '1234', 'Mosculinos'),
(223, 223, 2, 1001620303, 'DAVID FELIPE', 'CORDOBA MANCO', '1234', 'Mosculinos'),
(224, 224, 1, 1001747000, 'RAFAEL SEGUNDO', 'HOYOS AVILES', '1234', 'Mosculinos'),
(225, 225, 2, 1004425126, 'JESUS STIVEN', 'BERRIO ARROYAVE', '1234', 'Mosculinos'),
(226, 226, 2, 1004446421, 'ALEXANDRA', 'MEDINA IBARRA', '1234', 'Mosculinos'),
(227, 227, 2, 1005107253, 'KEVIN DAVID', 'ARIZA VELEZ', '1234', 'Mosculinos'),
(228, 228, 1, 1006087981, 'YEIMI LORENA', 'OLAYA GAMBA', '1234', 'Mosculinos'),
(229, 229, 1, 1007304595, 'MARIA DANIELA', 'URIBE RODRIGUEZ', '1235', 'Mosculinos'),
(230, 230, 1, 1007898663, 'PAMELA ANDREA', 'AGUDELO GIRALDO', '1236', 'Mosculinos'),
(231, 231, 2, 1022142184, 'MIGUEL ANGEL', 'ZULETA PUERTA', '1237', 'Mosculinos'),
(232, 232, 1, 1035441678, 'JUAN PABLO', 'MU?OZ CHAVERRA', '1238', 'Mosculinos'),
(233, 233, 1, 1035442605, 'JUAN JOSE', 'HERNANDEZ VALDERRAMA', '1239', 'Mosculinos'),
(234, 234, 2, 1193527266, 'DAVID ESTEBAN', 'CASANOVA NOGALES', '1240', 'Mosculinos'),
(235, 235, 1, 1193534109, 'SANTIAGO', 'CARDONA OSORIO', '1241', 'Mosculinos'),
(236, 236, 2, 1000112152, 'NATALIA', 'HIGUITA HIGUITA', '1234', 'Mosculinos'),
(237, 237, 2, 1000292585, 'JUAN FELIPE', 'BARRERA AVENDA?O', '1234', 'Mosculinos'),
(238, 238, 2, 1000548745, 'DARLY YASIRA', 'HENAO LOPEZ', '1234', 'Mosculinos'),
(239, 239, 1, 1000566554, 'JOAN ANDRES', 'RESTREPO FIERRO', '1234', 'Mosculinos'),
(240, 240, 2, 1001016040, 'VALENTINA', 'OSORNO MONSALVE', '1234', 'Mosculinos'),
(241, 241, 2, 1001138242, 'JUAN ESTEBAN', 'ATEHORTUA CARDONA', '1234', 'Mosculinos'),
(242, 242, 2, 1001480319, 'JAIDER ANDRES', 'BERRIO MAZO', '1234', 'Mosculinos'),
(243, 243, 2, 1001587649, 'JUAN MANUEL', 'LOPEZ MORALES', '1234', 'Mosculinos'),
(244, 244, 2, 1003178072, 'ISMAEL SEGUNDO', 'CUELLO HERNANDEZ', '1234', 'Mosculinos'),
(245, 245, 2, 1007055667, 'JHON ALEXIS', 'PANIAGUA ACEVEDO', '1234', 'Mosculinos'),
(246, 246, 1, 1007223550, 'JOHAN', 'MU?OZ MOLINA', '1234', 'Mosculinos'),
(247, 247, 1, 1007865228, 'KERLY VALENTINA', 'TRIVI?O GONZALEZ', '1234', 'Mosculinos'),
(248, 248, 1, 1020452523, 'JOHAN ALEXIS', 'SANCHEZ ECHAVARRIA', '1234', 'Mosculinos'),
(249, 249, 1, 1020487144, 'DIEGO ALEJANDRO', 'MARTINEZ ARANGO', '1234', 'Mosculinos'),
(250, 250, 1, 1035236038, 'ANDRES', 'POSADA ECHAVARRIA', '1234', 'Mosculinos'),
(251, 251, 1, 1035304221, 'BRAYAN ANDRES', 'DURANGO POSADA', '1234', 'Mosculinos'),
(252, 252, 1, 1036963286, 'MARIA JOSE', 'BOTERO MARTINEZ', '1234', 'Mosculinos'),
(253, 253, 1, 1060270042, 'JUAN DIEGO', 'ALZATE VARGAS', '1234', 'Mosculinos'),
(254, 254, 1, 1060592768, 'YONATAN', 'ORTEGA TAPASCO', '1234', 'Mosculinos'),
(255, 255, 1, 1112766253, 'JUAN DAVID', 'BEDOYA TOBON', '1234', 'Mosculinos'),
(256, 256, 1, 1127614252, 'RICARDO ARTURO', 'VILLADA SILVESTRE', '1234', 'Mosculinos'),
(257, 257, 1, 1152219511, 'HADER ELDIR', 'MAYA MU?OZ', '1234', 'Mosculinos'),
(258, 258, 1, 1152716209, 'CRISTINA', 'MARTINEZ ROMA?A', '1234', 'Mosculinos'),
(259, 259, 1, 1152717613, 'MATEO', 'RODRIGUEZ TORO', '1234', 'Mosculinos'),
(260, 260, 1, 1216729296, 'LAURA CAMILA', 'LOPEZ CANO', '1234', 'Mosculinos'),
(261, 261, 1, 15373474, 'WILMAR ALEXANDER', 'SUAREZ SANCHEZ', '1234', 'Mosculinos'),
(262, 262, 1, 98707314, 'DANIEL FELIPE', 'GRANADOS GOMEZ', '1234', 'Mosculinos'),
(265, 265, 1, 1193523821, 'ALEJANDRO', 'MARTINEZ VALENCIA', '1234', 'Mosculinos'),
(266, 266, 1, 1017264496, 'ANDRES FELIPE', 'JIMENEZ ALZATE', '1234', 'Mosculinos'),
(267, 267, 2, 1007506019, 'ARLES OSWALDO', 'VASQUEZ PINEDA', '1234', 'Mosculinos'),
(268, 268, 1, 1020488407, 'CRISTIAN CAMILO', 'MARULANDA RIVERA', '1234', 'Mosculinos'),
(269, 269, 1, 1000088454, 'DANIEL', 'VILLA GALINDO', '1234', 'Mosculinos'),
(270, 270, 1, 1152712847, 'DANIEL', 'GIRALDO GIRALDO', '1234', 'Mosculinos'),
(271, 271, 1, 1017250539, 'DARWIN SMITH', 'ZAPATA CADENA', '1234', 'Mosculinos'),
(272, 272, 1, 1017228450, 'DAVID ALEJANDRO', 'AGUDELO HIGUITA', '1234', 'Mosculinos'),
(273, 273, 1, 1000565945, 'EDGAR DAVID', 'TOBON BUILES', '1234', 'Mosculinos'),
(274, 274, 1, 98765899, 'EDWARD ANDRES', 'RENTERIA BORJA', '1234', 'Mosculinos'),
(275, 275, 1, 43909500, 'ERIKA ANDREA', 'GIRALDO MARIN', '1234', 'Mosculinos'),
(276, 276, 1, 1000193776, 'FEDER RAMSEY', 'RAMIREZ MADRIGAL', '1234', 'Mosculinos'),
(277, 277, 1, 98772841, 'JAILER', 'MU?OZ CORREA', '1234', 'Mosculinos'),
(278, 278, 1, 1128439705, 'JEFERSON', 'VALETA SAENZ', '1234', 'Mosculinos'),
(279, 279, 2, 1000190087, 'JONATHAN ANDRES', 'SERNA VELASCO', '1234', 'Mosculinos'),
(280, 280, 1, 1001359301, 'JUAN CAMILO', 'PARRA ARANGO', '1234', 'Mosculinos'),
(281, 281, 1, 1020479314, 'JUAN PABLO', 'OCHOA ALZATE', '1234', 'Mosculinos'),
(282, 282, 1, 1146439662, 'JUAN SEBASTIAN', 'TIGREROS JARAMILLO', '1234', 'Mosculinos'),
(283, 283, 1, 1216729997, 'JULIAN ESTIVEN', 'ZAPATA GALEANO', '1234', 'Mosculinos'),
(284, 284, 1, 1001555296, 'KATERIN', 'MARTINEZ ESTRADA', '1234', 'Mosculinos'),
(285, 285, 1, 1152711792, 'KATHERIN', 'ALVAREZ ROJAS', '1234', 'Mosculinos'),
(286, 286, 1, 1152708331, 'LEIDER DUBAN', 'VELASCO DUQUE', '1234', 'Mosculinos'),
(287, 287, 1, 1000896722, 'LESLY PAULINA', 'UPEGUI ISAZA', '1234', 'Mosculinos'),
(288, 288, 1, 1214741708, 'LUIS FERNANDO', 'VELEZ RUA', '1234', 'Mosculinos'),
(289, 289, 1, 71227477, 'SAMUEL ANDRES', 'GIRALDO HERNANDEZ', '1234', 'Mosculinos'),
(290, 290, 1, 1007242664, 'SANTIAGO', 'MUNERA AGUDELO', '1234', 'Mosculinos'),
(291, 291, 1, 1017264755, 'SANTIAGO', 'VILLEGAS GIRALDO', '1234', 'Mosculinos'),
(292, 292, 1, 1035441837, 'SEBASTIAN', 'QUINTERO CAUCALI', '1234', 'Mosculinos'),
(293, 293, 1, 1000657310, 'YADIRA ANDREA', 'ORREGO ATEHORTUA', '1234', 'Mosculinos'),
(294, 294, 1, 1037659624, 'YEIFER ANDRES', 'CASTA?O SARIEGO', '1234', 'Mosculinos'),
(295, 295, 1, 1020477066, 'YULISA', 'OSORIO URREGO', '1235', 'Mosculinos'),
(296, 296, 1, 1000089581, 'MARIA ISABEL', 'LOPERA GOMEZ', '1234', 'Mosculinos'),
(297, 297, 2, 1000439498, 'ANA SOFIA', 'QUINTANA PINEDA', '1234', 'Mosculinos'),
(298, 298, 1, 1000565331, 'VALENTINA', 'ALZATE GONZALEZ', '1234', 'Mosculinos'),
(299, 299, 1, 1000634928, 'ALEXIS', 'MURILLO LOPEZ', '1234', 'Mosculinos'),
(300, 300, 1, 1001010449, 'SANTIAGO', 'VELEZ REINA', '1234', 'Mosculinos'),
(301, 301, 1, 1001501046, 'ELIANA ANDREA', 'ZAPATA ZAPATA', '1234', 'Mosculinos'),
(302, 302, 1, 1001620454, 'SANTIAGO', 'USUGA HERNANDEZ', '1234', 'Mosculinos'),
(303, 303, 2, 1006869135, 'STEVE SEBASTIAN', 'FOX LYNTON', '1234', 'Mosculinos'),
(304, 304, 1, 1007114039, 'JORGE ALEJANDRO', 'GONZALEZ VARGAS', '1234', 'Mosculinos'),
(305, 305, 1, 1007238905, 'JHOLMAN DANIEL', 'PUERTA MARIN', '1234', 'Mosculinos'),
(306, 306, 1, 1007239050, 'MARIANA', 'ACEVEDO CARTAGENA', '1234', 'Mosculinos'),
(307, 307, 1, 1007333351, 'MARLON DAVID', 'MEDINA PELAEZ', '1234', 'Mosculinos'),
(308, 308, 1, 1017201179, 'JEFFERSON', 'TORRES OSORIO', '1234', 'Mosculinos'),
(309, 309, 1, 1017252736, 'ANDRES FELIPE', 'CETRE PALACIOS', '1234', 'Mosculinos'),
(310, 310, 1, 1020442039, 'JHONATAN ANDRES', 'VELASQUEZ RIVERA', '1234', 'Mosculinos'),
(311, 311, 1, 1035917862, 'JUAN PABLO', 'DAVID OLEAS', '1234', 'Mosculinos'),
(312, 312, 1, 1036611092, 'DANIEL ARGIRO', 'ALVAREZ POSADA', '1234', 'Mosculinos'),
(313, 313, 1, 1039625764, 'XIMENA ANDREA', 'PULGARIN MONTOYA', '1234', 'Mosculinos'),
(314, 314, 1, 1152211552, 'LUIS FELIPE', 'SERNA MENDOZA', '1234', 'Mosculinos'),
(315, 315, 2, 1193149253, 'LAURA CAMILA', 'DEL VALLE MOLINA', '1234', 'Mosculinos'),
(316, 316, 1, 1214741684, 'JUAN CAMILO', 'GARCIA ARBELAEZ', '1234', 'Mosculinos'),
(317, 317, 1, 1214743650, 'JOSE LEONEL', 'JIMENEZ BAENA', '1234', 'Mosculinos'),
(318, 318, 1, 1214747365, 'BRANDON SMITH', 'RIOS ACEVEDO', '1234', 'Mosculinos'),
(319, 319, 1, 1216719836, 'SANTIAGO', 'DAVID GUZMAN', '1234', 'Mosculinos'),
(320, 320, 1, 30391423, 'FRANCIA YOLANDA', 'GOMEZ PINO', '1234', 'Mosculinos'),
(321, 321, 2, 1000190455, 'daniela', 'zapata gutierrez', '1234', 'Femenino'),
(322, 322, 2, 1000539147, 'dayhana', 'velez uribe', '1234', 'Femenino'),
(323, 323, 1, 1193114252, 'denisse alejandra', 'alzate meneses', '1234', 'Femenino'),
(324, 324, 2, 1000566165, 'jose manuel', 'perez quiceno', '1234', 'Masculino'),
(325, 325, 1, 1000204568, 'juan jose', 'laurens gomez', '1234', 'Masculino'),
(326, 326, 2, 1000660457, 'juan pablo', 'salas vasquez', '1234', 'Masculino'),
(327, 327, 1, 1000290790, 'julian andres', 'molina meneses', '1234', 'Masculino'),
(328, 328, 1, 1001229049, 'karen', 'vasquez hernandez', '1234', 'Femenino'),
(329, 329, 2, 1193538361, 'kevin alexander', 'suaza gomez', '1234', 'Masculino'),
(330, 330, 1, 1000565891, 'laura vanessa', 'agudelo arias', '1234', 'Femenino'),
(331, 331, 2, 1000884447, 'luis pablo', 'goez sepulveda', '1234', 'Masculino'),
(332, 332, 2, 1001250591, 'manuela', 'yusti zapata', '1234', 'Femenino'),
(333, 333, 2, 1000445851, 'maria camila', 'zuluaga londo?o', '1234', 'Femenino'),
(334, 334, 2, 1193054974, 'mariana', 'alvarez acevedo', '1234', 'Femenino'),
(335, 335, 2, 1000661880, 'natalia', 'garnica genes', '1234', 'Femenino'),
(336, 336, 2, 1002633746, 'natalia', 'pati?o perez', '1234', 'Femenino'),
(337, 337, 1, 1007222463, 'sebastian', 'alvarez perez', '1234', 'Masculino'),
(338, 338, 2, 1000901154, 'sebastian david', 'martinez godoy', '1234', 'Masculino'),
(339, 339, 1, 1000565339, 'sergio leon', 'saldarriaga davila', '1234', 'Masculino'),
(340, 340, 1, 1152718045, 'stefania', 'giraldo monsalve', '1234', 'Femenino'),
(341, 341, 2, 1001420064, 'susana', 'devia cardona', '1234', 'Femenino'),
(342, 342, 2, 1000871417, 'tomas', 'diaz vasquez', '1234', 'Masculino'),
(343, 343, 2, 1000757758, 'yenifer', 'restrepo sanchez', '1234', 'Femenino'),
(344, 344, 2, 1007243753, 'yulieth', 'londo?o barrientos', '1234', 'Femenino'),
(345, 345, 2, 1000205371, 'ESTEBAN', 'OCAMPO CARMONA', '1234', 'Masculino'),
(346, 346, 1, 1000748330, 'ISAIAS', 'ATEHORTUA MOSQUERA', '1234', 'Masculino'),
(347, 347, 2, 1000897934, 'JUAN SEBASTIAN', 'TORO MIRA', '1234', 'Masculino'),
(348, 348, 2, 1000903644, 'JOHAN SEBASTIAN', 'CARDONA FIGUEROA', '1234', 'Masculino'),
(349, 349, 2, 1001014771, 'SEBASTIAN', 'ALVAREZ SALDARRIAGA', '1234', 'Masculino'),
(350, 350, 1, 1001391145, 'CRISTIAN DAVID', 'GONZALEZ RUEDA', '1234', 'Masculino'),
(351, 351, 2, 1001437986, 'YERSON ARLEY', 'PIEDRAHITA OSPINA', '1234', 'Masculino'),
(352, 352, 1, 1001580044, 'JUAN DAVID', 'CEBALLOS MU?OZ', '1234', 'Masculino'),
(353, 353, 1, 1001580847, 'JAVIER ALONSO', 'OSORIO CARO', '1234', 'Masculino'),
(354, 354, 1, 1001619330, 'SERGIO DAVID', 'SEPULVEDA MONTOYA', '1234', 'Masculino'),
(355, 355, 1, 1003062330, 'MAYRA ROSA', 'BARBOSA HERNANDEZ', '1234', 'Femenino'),
(356, 356, 1, 1005932583, 'DANIEL FERNANDO', 'CARVAJAL CA?ON', '1234', 'Masculino'),
(357, 357, 1, 1007165941, 'JHON EINSTEING', 'CASTIBLANCO CIRO', '1234', 'Masculino'),
(358, 358, 1, 1007471918, 'ANGIE TRINIDAD', 'OSORIO CARDONA', '1234', 'Femenino'),
(359, 359, 1, 1007601270, 'LUIS MIGUEL', 'VIVAS PALACIOS', '1234', 'Masculino'),
(360, 360, 1, 1017163330, 'YENNIFER TATIANA', 'CLAVIJO LOPEZ', '1234', 'Femenino'),
(361, 361, 1, 1017184244, 'CRISTHIAN JULIAN', 'PORTILLA DELGADO', '1234', 'Masculino'),
(362, 362, 1, 1020416583, 'JONATHAN CAMILO', 'GALEANO MAZO', '1234', 'Masculino'),
(363, 363, 1, 1020483790, 'JOHAN CAMILO', 'GUZMAN AVENDA?O', '1234', 'Masculino'),
(364, 364, 1, 1033342873, 'BRAYAN', 'HOLGUIN BEDOYA', '1234', 'Masculino'),
(365, 365, 1, 1036682388, 'KEVIN ANDRES', 'GUTIERREZ VERGARA', '1234', 'Masculino'),
(366, 366, 1, 1037650364, 'ANDRES FELIPE', 'PINO PIEDRAHITA', '1234', 'Masculino'),
(367, 367, 1, 1042775277, 'CAROLINA', 'RODRIGUEZ CORREA', '1234', 'Femenino'),
(368, 368, 1, 1073327485, 'DIEGO FERNANDO', 'REAL MARTINEZ', '1234', 'Masculino'),
(369, 369, 1, 1128435635, 'YAJANY', 'BEJARANO MENA', '1234', 'Masculino'),
(370, 370, 1, 1128462720, 'JUAN DAVID', 'PIEDRAHITA ROJAS', '1234', 'Masculino'),
(371, 371, 1, 98623475, 'YOHAN MAURICIO', 'HENAO MARULANDA', '1234', 'Masculino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detaproject`
--

CREATE TABLE `detaproject` (
  `iddetaProject` int(11) NOT NULL,
  `idActiProy` int(11) NOT NULL,
  `idResultA` int(11) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dia`
--

CREATE TABLE `dia` (
  `idDia` int(11) NOT NULL COMMENT 'identificador de la tabla dia',
  `nombre` varchar(30) CHARACTER SET latin1 NOT NULL COMMENT 'se nombra el dia en que la clase sera presentada',
  `estado` int(11) NOT NULL COMMENT 'es el estado de la clase '
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `dia`
--

INSERT INTO `dia` (`idDia`, `nombre`, `estado`) VALUES
(1, 'Lunes', 1),
(2, 'Martes', 1),
(3, 'Miércoles', 1),
(4, 'Jueves', 1),
(5, 'Viernes', 1),
(6, 'Sábado', 1),
(7, 'Domingo', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ficha`
--

CREATE TABLE `ficha` (
  `idFicha` int(11) NOT NULL COMMENT 'identificador de la tabla ficha',
  `idPrograma` int(11) NOT NULL COMMENT 'indentificador de la tabla programa',
  `fechaInicio` date NOT NULL COMMENT 'es al fecha donde se empiza el cuso y trimestre',
  `fechaFin` date NOT NULL COMMENT 'marca el fin del trimestre y el cuso\n',
  `cantidadAprendiz` int(11) NOT NULL COMMENT 'muestra el numero total de todos los aprendices que hay ',
  `numeroFicha` int(11) NOT NULL COMMENT 'es el numero de tiene cada grupo para identificarlo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ficha`
--

INSERT INTO `ficha` (`idFicha`, `idPrograma`, `fechaInicio`, `fechaFin`, `cantidadAprendiz`, `numeroFicha`) VALUES
(1, 1, '2019-01-28', '2021-01-22', 35, 1800888),
(2, 1, '2019-01-28', '2021-01-22', 35, 2026981),
(3, 1, '2019-01-28', '2021-01-22', 35, 2026985),
(4, 1, '2019-01-28', '2021-01-22', 35, 2056778),
(5, 1, '2019-01-28', '2021-01-22', 35, 1906897),
(6, 1, '2019-01-28', '2021-01-22', 35, 2027092),
(7, 1, '2019-01-28', '2021-01-22', 35, 1800890),
(8, 1, '2019-01-28', '2021-01-22', 35, 1827231),
(9, 1, '2019-01-28', '2021-01-22', 35, 1906901),
(10, 1, '2019-01-28', '2021-01-22', 35, 1964321),
(11, 1, '2019-01-28', '2021-01-22', 35, 2026994),
(12, 1, '2019-01-28', '2021-01-22', 35, 2056779);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `instructores`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `instructores` (
`idUsuario` int(11)
,`nombre` varchar(511)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipio`
--

CREATE TABLE `municipio` (
  `idMunicipio` int(11) NOT NULL COMMENT 'identiifcador de la tabla ',
  `idRegional` int(11) NOT NULL COMMENT 'id de la tabla region ',
  `nombre` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del municipio',
  `estado` int(11) NOT NULL COMMENT 'estado del municipio'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `municipio`
--

INSERT INTO `municipio` (`idMunicipio`, `idRegional`, `nombre`, `estado`) VALUES
(1, 1, 'Medellin', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pais`
--

CREATE TABLE `pais` (
  `idPais` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `nombre` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del pais',
  `estado` int(11) NOT NULL COMMENT 'estado del pais'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `pais`
--

INSERT INTO `pais` (`idPais`, `nombre`, `estado`) VALUES
(1, 'Colombia', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programa`
--

CREATE TABLE `programa` (
  `idPrograma` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `idCentro` int(11) NOT NULL COMMENT 'id de la tabla centro',
  `nombre` varchar(100) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del sentro en cual esta funcionando  programa',
  `tipoFormacion` varchar(40) CHARACTER SET latin1 NOT NULL COMMENT 'el tipo de la formacion si es tics o otra caena de formacion',
  `estado` int(11) NOT NULL COMMENT 'el estado del grupo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `programa`
--

INSERT INTO `programa` (`idPrograma`, `idCentro`, `nombre`, `tipoFormacion`, `estado`) VALUES
(1, 1, 'Analisis y desarrollo de sistemas de informacion', 'precencial ', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regional`
--

CREATE TABLE `regional` (
  `idRegional` int(11) NOT NULL COMMENT 'identificador de la tabla ',
  `idPais` int(11) NOT NULL COMMENT 'id de tabla pais',
  `nombre` mediumtext CHARACTER SET latin1 NOT NULL COMMENT 'nombre de la region ',
  `estado` int(11) NOT NULL COMMENT 'estado de la region'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `regional`
--

INSERT INTO `regional` (`idRegional`, `idPais`, `nombre`, `estado`) VALUES
(1, 1, 'Antioquia', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resulta`
--

CREATE TABLE `resulta` (
  `idResultA` int(11) NOT NULL COMMENT 'identificador de la tabla de la tabla resultado',
  `idTrimestre` int(11) NOT NULL COMMENT 'id de la tabla tirmeestre',
  `idCompetencia` int(11) NOT NULL COMMENT 'id de la tabla competencia',
  `nombre` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'Nombre del resultado',
  `codigocom` int(11) NOT NULL COMMENT 'el resultado de la competencia',
  `estado` int(11) NOT NULL COMMENT 'estado del resultado actual'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idRol` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `idTipoUsuario` int(11) NOT NULL COMMENT 'id perteneciente a la tabla de tipo de usuario',
  `idUsuario` int(11) NOT NULL COMMENT 'id perteneciente a la tabla ususario',
  `estado` tinyint(1) NOT NULL COMMENT 'estado en el que se actualmente un usuario '
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idRol`, `idTipoUsuario`, `idUsuario`, `estado`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 1),
(3, 2, 3, 1),
(4, 2, 4, 1),
(5, 2, 5, 1),
(6, 2, 6, 1),
(7, 2, 7, 1),
(8, 2, 8, 1),
(9, 2, 9, 1),
(10, 2, 10, 1),
(11, 2, 11, 1),
(12, 2, 12, 1),
(13, 2, 13, 1),
(14, 2, 14, 1),
(15, 3, 15, 1),
(16, 3, 16, 1),
(17, 3, 17, 1),
(18, 3, 18, 1),
(19, 3, 19, 1),
(20, 3, 20, 1),
(21, 3, 21, 1),
(22, 3, 22, 1),
(23, 3, 23, 1),
(24, 3, 24, 1),
(25, 3, 25, 1),
(26, 3, 26, 1),
(27, 3, 27, 1),
(28, 3, 28, 1),
(29, 3, 29, 1),
(30, 3, 30, 1),
(31, 3, 31, 1),
(32, 3, 32, 1),
(33, 3, 33, 1),
(34, 3, 34, 1),
(35, 3, 35, 1),
(36, 3, 36, 1),
(37, 3, 37, 1),
(38, 3, 38, 1),
(39, 3, 39, 1),
(40, 3, 40, 1),
(41, 3, 41, 1),
(42, 3, 42, 1),
(43, 3, 43, 1),
(44, 3, 44, 1),
(45, 3, 45, 1),
(46, 3, 46, 1),
(47, 3, 47, 1),
(48, 3, 48, 1),
(49, 3, 49, 1),
(50, 3, 50, 1),
(51, 3, 51, 1),
(52, 3, 52, 1),
(53, 3, 53, 1),
(54, 3, 54, 1),
(55, 3, 55, 1),
(56, 3, 56, 1),
(57, 3, 57, 1),
(58, 3, 58, 1),
(59, 3, 59, 1),
(60, 3, 60, 1),
(61, 3, 61, 1),
(62, 3, 62, 1),
(63, 3, 63, 1),
(64, 3, 64, 1),
(65, 3, 65, 1),
(66, 3, 66, 1),
(67, 3, 67, 1),
(68, 3, 68, 1),
(69, 3, 69, 1),
(70, 3, 70, 1),
(71, 3, 71, 1),
(72, 3, 72, 1),
(73, 3, 73, 1),
(74, 3, 74, 1),
(75, 3, 75, 1),
(76, 3, 76, 1),
(77, 3, 77, 1),
(78, 3, 78, 1),
(79, 3, 79, 1),
(80, 3, 80, 1),
(81, 3, 81, 1),
(82, 3, 82, 1),
(83, 3, 83, 1),
(84, 3, 84, 1),
(85, 3, 85, 1),
(86, 3, 86, 1),
(87, 3, 87, 1),
(88, 3, 88, 1),
(89, 3, 89, 1),
(90, 3, 90, 1),
(91, 3, 91, 1),
(92, 3, 92, 1),
(93, 3, 93, 1),
(94, 3, 94, 1),
(95, 3, 95, 1),
(96, 3, 96, 1),
(97, 3, 97, 1),
(98, 3, 98, 1),
(99, 3, 99, 1),
(100, 3, 100, 1),
(101, 3, 101, 1),
(102, 3, 102, 1),
(103, 3, 103, 1),
(104, 3, 104, 1),
(105, 3, 105, 1),
(106, 3, 106, 1),
(107, 3, 107, 1),
(108, 3, 108, 1),
(109, 3, 109, 1),
(110, 3, 110, 1),
(111, 3, 111, 1),
(112, 3, 112, 1),
(113, 3, 113, 1),
(114, 3, 114, 1),
(115, 3, 115, 1),
(116, 3, 116, 1),
(117, 3, 117, 1),
(118, 3, 118, 1),
(119, 3, 119, 1),
(120, 3, 120, 1),
(121, 3, 121, 1),
(122, 3, 122, 1),
(123, 3, 123, 1),
(124, 3, 124, 1),
(125, 3, 125, 1),
(126, 3, 126, 1),
(127, 3, 127, 1),
(128, 3, 128, 1),
(129, 3, 129, 1),
(130, 3, 130, 1),
(131, 3, 131, 1),
(132, 3, 132, 1),
(133, 3, 133, 1),
(134, 3, 134, 1),
(135, 3, 135, 1),
(136, 3, 136, 1),
(137, 3, 137, 1),
(138, 3, 138, 1),
(139, 3, 139, 1),
(140, 3, 140, 1),
(141, 3, 141, 1),
(142, 3, 142, 1),
(143, 3, 143, 1),
(144, 3, 144, 1),
(145, 3, 145, 1),
(146, 3, 146, 1),
(147, 3, 147, 1),
(148, 3, 148, 1),
(149, 3, 149, 1),
(150, 3, 150, 1),
(151, 3, 151, 1),
(152, 3, 152, 1),
(153, 3, 153, 1),
(154, 3, 154, 1),
(155, 3, 155, 1),
(156, 3, 156, 1),
(157, 3, 157, 1),
(158, 3, 158, 1),
(159, 3, 159, 1),
(160, 3, 160, 1),
(161, 3, 161, 1),
(162, 3, 162, 1),
(163, 3, 163, 1),
(164, 3, 164, 1),
(165, 3, 165, 1),
(166, 3, 166, 1),
(167, 3, 167, 1),
(168, 3, 168, 1),
(169, 3, 169, 1),
(170, 3, 170, 1),
(171, 3, 171, 1),
(172, 3, 172, 1),
(173, 3, 173, 1),
(174, 3, 174, 1),
(175, 3, 175, 1),
(176, 3, 176, 1),
(177, 3, 177, 1),
(178, 3, 178, 1),
(179, 3, 179, 1),
(180, 3, 180, 1),
(181, 3, 181, 1),
(182, 3, 182, 1),
(183, 3, 183, 1),
(184, 3, 184, 1),
(185, 3, 185, 1),
(186, 3, 186, 1),
(187, 3, 187, 1),
(188, 3, 188, 1),
(189, 3, 189, 1),
(190, 3, 190, 1),
(191, 3, 191, 1),
(192, 3, 192, 1),
(193, 3, 193, 1),
(194, 3, 194, 1),
(195, 3, 195, 1),
(196, 3, 196, 1),
(197, 3, 197, 1),
(198, 3, 198, 1),
(199, 3, 199, 1),
(200, 3, 200, 1),
(201, 3, 201, 1),
(202, 3, 202, 1),
(203, 3, 203, 1),
(204, 3, 204, 1),
(205, 3, 205, 1),
(206, 3, 206, 1),
(207, 3, 207, 1),
(208, 3, 208, 1),
(209, 3, 209, 1),
(210, 3, 210, 1),
(211, 3, 211, 1),
(212, 3, 212, 1),
(213, 3, 213, 1),
(214, 3, 214, 1),
(215, 3, 215, 1),
(216, 3, 216, 1),
(217, 3, 217, 1),
(218, 3, 218, 1),
(219, 3, 219, 1),
(220, 3, 220, 1),
(221, 3, 221, 1),
(222, 3, 222, 1),
(223, 3, 223, 1),
(224, 3, 224, 1),
(225, 3, 225, 1),
(226, 3, 226, 1),
(227, 3, 227, 1),
(228, 3, 228, 1),
(229, 3, 229, 1),
(230, 3, 230, 1),
(231, 3, 231, 1),
(232, 3, 232, 1),
(233, 3, 233, 1),
(234, 3, 234, 1),
(235, 3, 235, 1),
(236, 3, 236, 1),
(237, 3, 237, 1),
(238, 3, 238, 1),
(239, 3, 239, 1),
(240, 3, 240, 1),
(241, 3, 241, 1),
(242, 3, 242, 1),
(243, 3, 243, 1),
(244, 3, 244, 1),
(245, 3, 245, 1),
(246, 3, 246, 1),
(247, 3, 247, 1),
(248, 3, 248, 1),
(249, 3, 249, 1),
(250, 3, 250, 1),
(251, 3, 251, 1),
(252, 3, 252, 1),
(253, 3, 253, 1),
(254, 3, 254, 1),
(255, 3, 255, 1),
(256, 3, 256, 1),
(257, 3, 257, 1),
(258, 3, 258, 1),
(259, 3, 259, 1),
(260, 3, 260, 1),
(261, 3, 261, 1),
(262, 3, 262, 1),
(263, 3, 265, 1),
(264, 3, 266, 1),
(265, 3, 267, 1),
(266, 3, 268, 1),
(267, 3, 269, 1),
(268, 3, 270, 1),
(269, 3, 271, 1),
(270, 3, 272, 1),
(271, 3, 273, 1),
(272, 3, 274, 1),
(273, 3, 275, 1),
(274, 3, 276, 1),
(275, 3, 277, 1),
(276, 3, 278, 1),
(277, 3, 279, 1),
(278, 3, 280, 1),
(279, 3, 281, 1),
(280, 3, 282, 1),
(281, 3, 283, 1),
(282, 3, 284, 1),
(283, 3, 285, 1),
(284, 3, 286, 1),
(285, 3, 287, 1),
(286, 3, 288, 1),
(287, 3, 289, 1),
(288, 3, 290, 1),
(289, 3, 291, 1),
(290, 3, 292, 1),
(291, 3, 293, 1),
(292, 3, 294, 1),
(293, 3, 295, 1),
(294, 3, 296, 1),
(295, 3, 297, 1),
(296, 3, 298, 1),
(297, 3, 299, 1),
(298, 3, 300, 1),
(299, 3, 301, 1),
(300, 3, 302, 1),
(301, 3, 303, 1),
(302, 3, 304, 1),
(303, 3, 305, 1),
(304, 3, 306, 1),
(305, 3, 307, 1),
(306, 3, 308, 1),
(307, 3, 309, 1),
(308, 3, 310, 1),
(309, 3, 311, 1),
(310, 3, 312, 1),
(311, 3, 313, 1),
(312, 3, 314, 1),
(313, 3, 315, 1),
(314, 3, 316, 1),
(315, 3, 317, 1),
(316, 3, 318, 1),
(317, 3, 319, 1),
(318, 3, 320, 1),
(319, 3, 321, 1),
(320, 3, 322, 1),
(321, 3, 323, 1),
(322, 3, 324, 1),
(323, 3, 325, 1),
(324, 3, 326, 1),
(325, 3, 327, 1),
(326, 3, 328, 1),
(327, 3, 329, 1),
(328, 3, 330, 1),
(329, 3, 331, 1),
(330, 3, 332, 1),
(331, 3, 333, 1),
(332, 3, 334, 1),
(333, 3, 335, 1),
(334, 3, 336, 1),
(335, 3, 337, 1),
(336, 3, 338, 1),
(337, 3, 339, 1),
(338, 3, 340, 1),
(339, 3, 341, 1),
(340, 3, 342, 1),
(341, 3, 343, 1),
(342, 3, 344, 1),
(343, 3, 345, 1),
(344, 3, 346, 1),
(345, 3, 347, 1),
(346, 3, 348, 1),
(347, 3, 349, 1),
(348, 3, 350, 1),
(349, 3, 351, 1),
(350, 3, 352, 1),
(351, 3, 353, 1),
(352, 3, 354, 1),
(353, 3, 355, 1),
(354, 3, 356, 1),
(355, 3, 357, 1),
(356, 3, 358, 1),
(357, 3, 359, 1),
(358, 3, 360, 1),
(359, 3, 361, 1),
(360, 3, 362, 1),
(361, 3, 363, 1),
(362, 3, 364, 1),
(363, 3, 365, 1),
(364, 3, 366, 1),
(365, 3, 367, 1),
(366, 3, 368, 1),
(367, 3, 369, 1),
(368, 3, 370, 1),
(369, 3, 371, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sede`
--

CREATE TABLE `sede` (
  `idSede` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `idMunicipio` int(11) NOT NULL COMMENT 'id de tabla municipio',
  `nombre` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'nombre de la sede',
  `direccion` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'en que parte de la region esta la seda',
  `telefono` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'telefono de la sede al cual comunicarse ',
  `correo` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'correo nombre de la sede',
  `director` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'nombre del director de esa sede',
  `estado` int(11) NOT NULL COMMENT 'estado de la sede'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `sede`
--

INSERT INTO `sede` (`idSede`, `idMunicipio`, `nombre`, `direccion`, `telefono`, `correo`, `director`, `estado`) VALUES
(1, 1, 'Centro De Comercio Sena', 'Cl. 51 ##57-70', '(4) 5760000', 'sena@misena.edu.co', 'sergio david sepulveda montoya', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoambiente`
--

CREATE TABLE `tipoambiente` (
  `idTipoAmbien` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `nombre` varchar(40) CHARACTER SET latin1 NOT NULL COMMENT 'Nombre del ambiente',
  `estado` int(11) NOT NULL COMMENT 'el estado del ambiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipoambiente`
--

INSERT INTO `tipoambiente` (`idTipoAmbien`, `nombre`, `estado`) VALUES
(1, 'Interno', 1),
(2, 'Externo', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodoc`
--

CREATE TABLE `tipodoc` (
  `idTipoDoc` int(11) NOT NULL COMMENT 'identificador de la tabla',
  `tipoDocumento` varchar(25) CHARACTER SET latin1 NOT NULL COMMENT 'el tipo de documento de un usuario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipodoc`
--

INSERT INTO `tipodoc` (`idTipoDoc`, `tipoDocumento`) VALUES
(1, 'Cedula de ciudadania'),
(2, 'Tarjeta de identidad'),
(3, 'Registro Civil'),
(4, 'Pasaporte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipousuario`
--

CREATE TABLE `tipousuario` (
  `idTipoUsuario` int(11) NOT NULL COMMENT 'identificador unico de la tabla',
  `tipoUsuario` varchar(25) CHARACTER SET latin1 NOT NULL COMMENT 'la definicion de de cada tipo de usuario\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipousuario`
--

INSERT INTO `tipousuario` (`idTipoUsuario`, `tipoUsuario`) VALUES
(1, 'Admin'),
(2, 'Instructor'),
(3, 'Aprendiz');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trimestre`
--

CREATE TABLE `trimestre` (
  `idTrimestre` int(11) NOT NULL COMMENT 'identificador  de la tabla ',
  `idPrograma` int(11) NOT NULL COMMENT 'id de la tabla programa',
  `descripcion` varchar(50) CHARACTER SET latin1 NOT NULL COMMENT 'descrebe las actividades que hay en el trimestre',
  `estado` int(11) NOT NULL COMMENT 'el estado de en que se encuantra el trimestre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `trimestre`
--

INSERT INTO `trimestre` (`idTrimestre`, `idPrograma`, `descripcion`, `estado`) VALUES
(1, 1, 'Primer trimestre', 1),
(2, 1, 'Segundo trimestre', 1),
(3, 1, 'Tercer trimestre', 1),
(4, 1, 'Cuarto trimestre', 1),
(5, 1, 'Quinto trimestr', 1),
(6, 1, 'Sexto trimestre', 1),
(7, 1, 'Septimo trimestre', 1),
(8, 1, 'Octavo trimestre', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL COMMENT 'Es el identificador de la tabla',
  `correo` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'Es el correo con que el usuario se resgistro',
  `password` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'Contraseña  que eligio el usuario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `correo`, `password`) VALUES
(1, 'admin@misena.edu.co', '85568b20c3315286c4dfebb330b25146f92bed66'),
(2, 'sena@misena.edu.com', '4c3a103f29134a40d548ff7cb8397106ce239a15'),
(3, 'sena@misena.edu.com', 'fe7e51ec62a49448e37f5c8fb052709eb68b6e10'),
(4, 'sena@misena.edu.com', '64beb8df7ffbb739e1651e386e5db9caccc923ed'),
(5, 'sena@misena.edu.com', '0b036c031d35287333baff190d275dbd7ea93fc5'),
(6, 'sena@misena.edu.com', 'c023db145698403be525e69ee608636916849215'),
(7, 'sena@misena.edu.com', 'f645db7ae5aa3e180e7b78e09048eed836212034'),
(8, 'sena@misena.edu.com', '5c0421121a2b32cdc8f93651502d6ed46dd557d6'),
(9, 'sena@misena.edu.com', '5763eda2901ecfaca28327e340d32abaa4fe766d'),
(10, 'sena@misena.edu.com', '15edc7ee2cc1e28128f9e6fcfd3568cec6ea6e78'),
(11, 'sena@misena.edu.com', 'a7b50bb31ad54b68569d8a9fb68145922405ba53'),
(12, 'sena@misena.edu.com', '49241d666fc4d91d3cddca446ca7fc8f24c7677d'),
(13, 'sena@misena.edu.com', '6daa745ac35bda0d8f2347efc957998607e62a2c'),
(14, 'sena@misena.edu.com', '364e5bf6be7de648459f482a1b970d3361ec138a'),
(15, 'sena@misena.edu.co', 'd14c798e19b53ed1a30fdfa095c9f123447c1542'),
(16, 'sena@misena.edu.co', '4b80f4e6a01af83e73f89a4dc9b1a3ce101f88e7'),
(17, 'sena@misena.edu.co', '3b37d430cb758b17a68d5e054057471133d946f5'),
(18, 'sena@misena.edu.co', '2eab579f2b10f2acbfa9114f26a7635dcb15fce9'),
(19, 'sena@misena.edu.co', 'bd8b4e948b7e4178faeaab37ff87fa1fdd7b8131'),
(20, 'sena@misena.edu.co', '928e35412459418905042df5d7f46c312f6ca333'),
(21, 'sena@misena.edu.co', 'b573932abd19ab6a4588021fd1fc0469df7673c6'),
(22, 'sena@misena.edu.co', 'e202def6eb1334936fb1773ae014b1c39eb761ae'),
(23, 'sena@misena.edu.co', '43fe46939dd3c11b16e1021db84298179dd476d7'),
(24, 'sena@misena.edu.co', '2bf0f93736f8f0a3e7b8497e4cc4de6328176d55'),
(25, 'sena@misena.edu.co', 'e029df1567ec26081aefd3a1cf1fd588e0b01eb4'),
(26, 'sena@misena.edu.co', 'd10df90aa2a5d96fba960f5266fca02b5cb91671'),
(27, 'sena@misena.edu.co', '2f94897310cc93d1857ab4211c41ca521a083d10'),
(28, 'sena@misena.edu.co', '015d9aa5915b566f08911cf6ce3c3d46ffe69e2f'),
(29, 'sena@misena.edu.co', '0ed50da9d176a7f22a2af75a2592bc49c0e9daeb'),
(30, 'sena@misena.edu.co', 'd65602b22d9b9deb679e2272a4743e53b33824c6'),
(31, 'sena@misena.edu.co', '70550bc4e2a51a46ed7c1d2d93258e5428e73341'),
(32, 'sena@misena.edu.co', '7a90db492aa0434fa03b9f9cb290b658acebc2b0'),
(33, 'sena@misena.edu.co', '537f7bb25bf8f8129a628df26ebcefa54e437b49'),
(34, 'sena@misena.edu.co', '7958cb9b8411b2b8d35a943afb0b483f9e883980'),
(35, 'sena@misena.edu.co', '9c13e1e466e372cf54c371ee110f103c9e6b6875'),
(36, 'sena@misena.edu.co', 'bb081952cc3bf3dfc1fa68f286b0e0c26d4dad47'),
(37, 'sena@misena.edu.co', 'ab02c3d7d2462887102eb3dae41d756493d75bd8'),
(38, 'sena@misena.edu.co', '25258723134f159889aa4d36022bf2f2597ab1fb'),
(39, 'sena@misena.edu.co', '8a7e7d364568f1dfb53ebf88f22e715af674c230'),
(40, 'sena@misena.edu.co', '2e734787d369fe7a641789792277c838629af54d'),
(41, 'sena@misena.edu.co', 'a57eac89a2875f72162240d37960222903e9372f'),
(42, 'sena@misena.edu.co', '187b62194c5920c316c026648bc72bb5b3c101b6'),
(43, 'sena@misena.edu.co', 'a4e9835041f1336814f5f92720ef16befb180fed'),
(44, 'sena@misena.edu.co', 'ac0703394b2b4891f7f7b6d2db8f10ce59b743f5'),
(45, 'sena@misena.edu.co', 'c7fb46b975a8777af26f90da94f757d1009c9bdc'),
(46, 'sena@misena.edu.co', '5e139e5d3fa550788438624d1f9da33c0f08afc2'),
(47, 'sena@misena.edu.co', '500ec30a5e348d91bfd71a633b870b21c190399d'),
(48, 'sena@misena.edu.co', 'acaeea6b999c9cff4263dcb89a109cc572cc877f'),
(49, 'sena@misena.edu.co', '8c713ccea4bcda0995a2e2f33a2d1e53f3c72d04'),
(50, 'sena@misena.edu.co', 'f429b9e1a2962e1cf1a9f70cab3ef17a07ce0692'),
(51, 'sena@misena.edu.co', '560346dd3063fd27d400ff5454c2c93cb47e211d'),
(52, 'sena@misena.edu.co', '976bcccc85f58bac1b814f416bb8ff9297e59b22'),
(53, 'sena@misena.edu.co', 'efe47ffb8e60e69c7d6f17856c925e4cdb45a700'),
(54, 'sena@misena.edu.co', 'f15ace689d9df921774a1f3029ef18b90a7c7127'),
(55, 'sena@misena.edu.co', 'b349a5c2b904327cf31e20075324b6676f007830'),
(56, 'sena@misena.edu.co', 'e7ea60fc283740a1ad2e90d92bd9380363fbbe65'),
(57, 'sena@misena.edu.co', 'cb85e66f3cee14d6486b289c756c04a43078d0d2'),
(58, 'sena@misena.edu.co', '897e8857f537e66be5d00665d11150deffeadbdb'),
(59, 'sena@misena.edu.co', 'c34a375d92085710c20b0949a879780bebf89e69'),
(60, 'sena@misena.edu.co', '9862d34de1d40f32ce88fe147a686126e72f551d'),
(61, 'sena@misena.edu.co', 'cd3dff0ddafa2466b139e5eae28372b76bf5fd52'),
(62, 'sena@misena.edu.co', '6cf49d9ae364b8a691044ae197ce8332a3cb02d5'),
(63, 'sena@misena.edu.co', 'f30313ed679f12f321498980aad43179d92f1734'),
(64, 'sena@misena.edu.co', '706284384b2762811791dd344fd4190240cb11b8'),
(65, 'sena@misena.edu.co', '0ce2506ade7e0e12715ba264f4f51bdb886f1d14'),
(66, 'sena@misena.edu.co', 'a251d29c7477ec7c530c0fc8abb866ab0505c80e'),
(67, 'sena@misena.edu.co', 'e7f6d1177e12cc22bf9df29364dfda1d6860561b'),
(68, 'sena@misena.edu.co', '23883ec3489a0cc13db199ca4bf991ac4d898b6a'),
(69, 'sena@misena.edu.co', '4d065e186229e5c94dd587a2c01444f9e02cfce5'),
(70, 'sena@misena.edu.co', '814eb902724c30932797af813034537ab9630d7e'),
(71, 'sena@misena.edu.co', '822c833ae5043d303044325328295a134b5b2e2e'),
(72, 'sena@misena.edu.co', 'b3404ef0db7cbd7eb25c8f095ce1735ecfe2759a'),
(73, 'sena@misena.edu.co', '37e66ec76d02115d953a785892c00758a709065d'),
(74, 'sena@misena.edu.co', '17abdd674f2345c31c88404d7809d0cdc63c3572'),
(75, 'sena@misena.edu.co', '51542a166d4b181f61fad46f597fc2dbb5f52f2f'),
(76, 'sena@misena.edu.co', '9a2d312928321f04689cbd01f5c6c7b22a114bd1'),
(77, 'sena@misena.edu.co', '952a42d44f4c316652b29f366d847332a400452b'),
(78, 'sena@misena.edu.co', '48211955ac8728046536ff5679813b8fb445dff0'),
(79, 'sena@misena.edu.co', 'eaa9cd93e993c69562a27a74a085aed3e6eafd89'),
(80, 'sena@misena.edu.co', '2f59e79493a21731842ef43149a5aeb77db5e505'),
(81, 'sena@misena.edu.co', 'cdd8b758aa83dd9e615b5b6be6ccc9ab256a19ad'),
(82, 'sena@misena.edu.co', '52eabc922e717683787551950c2ef64cfaa43914'),
(83, 'sena@misena.edu.co', '34177a49b789e41d6dbfbb6ed18ccb67c1d7addd'),
(84, 'sena@misena.edu.co', '2f64348ac56b545ead699f343756d9fc6a97d3dc'),
(85, 'sena@misena.edu.co', '186f31fcfc5a9df8b2631d94baf08995b2e23faf'),
(86, 'sena@misena.edu.co', 'baf28fc41757bb1b48aaa780e0a5ad9a83063f91'),
(87, 'sena@misena.edu.co', '1994a829f48f5844ea2b45475049781f21d45ae0'),
(88, 'sena@misena.edu.co', '8296372273d39e68166b8b5dea94f9900d215f99'),
(89, 'sena@misena.edu.co', '1d1e8b7ccbcbdef9c9bf74c0cf0b14655017d78b'),
(90, 'sena@misena.edu.co', 'f3381255df914ffc7bd23754101cceb69ef713eb'),
(91, 'sena@misena.edu.co', '0321a417820232ffe3616ee2f9eceede48302576'),
(92, 'sena@misena.edu.co', '5377d0fc77956b7c19116953ef28327d7fd967d2'),
(93, 'sena@misena.edu.co', 'c2ead131a8dbd6bb3b5b62097b7415e79e378523'),
(94, 'sena@misena.edu.co', 'ed78b16e02ac1922bb23a1f4778c3bd1e986751b'),
(95, 'sena@misena.edu.co', 'ecfd8bc2d9961972becceb6bf673d80f5c78a896'),
(96, 'sena@misena.edu.co', '0b71c0c531cffedac2a457507a7afaebe003dbbe'),
(97, 'sena@misena.edu.co', 'b32dfa2725d6f1b73e42c75e57d99d9e5683c040'),
(98, 'sena@misena.edu.co', '7cd58d2d9f8bd984f0cb3b7fd0ef931bd6416bff'),
(99, 'sena@misena.edu.co', '734c1af96e9106db55d47be00de6fee59c3ae2b9'),
(100, 'sena@misena.edu.co', '8d9de69ccb29a06951a95afc7f6c2613a6b90d83'),
(101, 'sena@misena.edu.co', '8a04c99ac8d0d6663cf253785033b7d8a05a0af7'),
(102, 'sena@misena.edu.co', 'c098811e34decb26300cc07c663af0e54fceae3a'),
(103, 'sena@misena.edu.co', 'dd05bc88d1b59f3936fefd2a10a626ad689df9a6'),
(104, 'sena@misena.edu.co', '9cdf287e6e94b60975a4648b9aeccc5bd0db02fd'),
(105, 'sena@misena.edu.co', 'ffe6553d2758c4299db6c256ed35d703d1e16e0d'),
(106, 'sena@misena.edu.co', 'c4dd49900052f749877db12163019a25bb556866'),
(107, 'sena@misena.edu.co', 'ab7e16bdf9bcbac53212ecaf3ede624072570423'),
(108, 'sena@misena.edu.co', '022ba2cd2f1e89b0ca0ce42157a9640621d046ae'),
(109, 'sena@misena.edu.co', 'b515bc480d42178ac97ce9fa4b80203e1f828499'),
(110, 'sena@misena.edu.co', '380b7216024e170ba28ed96e3601a0bbda4a52d7'),
(111, 'sena@misena.edu.co', 'eaed1e2d2233801afa9c1dcf6298cfc0b4c89161'),
(112, 'sena@misena.edu.co', '6333ee172d32f9054805cd39099a8ff5d2246aed'),
(113, 'sena@misena.edu.co', '2a9fbcf6bae5b3c9a068a940c1786266f07c1cc1'),
(114, 'sena@misena.edu.co', '3c76c112d60aa13071a0b314a129b18fffad1f5a'),
(115, 'sena@misena.edu.co', 'c75b3b5d9f8a91c4cad61119fbeeb08d044e94f3'),
(116, 'sena@misena.edu.co', 'c5a66e98876390908b93d54ddcb784592051af30'),
(117, 'sena@misena.edu.co', '3c319d52dd7f11eef3bfb0b25885aa24b1f52337'),
(118, 'sena@misena.edu.co', 'a76799cd3618efab1aa4cc0c953a4be7ff128ce4'),
(119, 'sena@misena.edu.co', 'c9b488bf7f4803e0f3ba1d58b05697b268e7ce3e'),
(120, 'sena@misena.edu.co', 'fb4169256b6bc0018b3fd680b8773dd7aafd5fe3'),
(121, 'sena@misena.edu.co', '0a574786bbde3c38e5262340be396450386ab2f6'),
(122, 'sena@misena.edu.co', '4ec1ec32d3e702635a5c5fc7575111bb8369223e'),
(123, 'sena@misena.edu.co', '1513e1ad390502fe129b1dad4585588c15deb18a'),
(124, 'sena@misena.edu.co', '07d1902862464d6c7abffb2f7352cddd6cf0ff59'),
(125, 'sena@misena.edu.co', 'cfc9ceb006bd705e893935abb11276a293fc4e9c'),
(126, 'sena@misena.edu.co', 'cfe35299471e908d9ff17b0fb49821c23ce2afd9'),
(127, 'sena@misena.edu.co', 'b8101e558b01540242527a72fb09836c1ba7294b'),
(128, 'sena@misena.edu.co', '54b6c40b73be8574f26967b2abc9bc91efa1cb18'),
(129, 'sena@misena.edu.co', '8dd04ab69eb4b968938c62adb1c745fb1ff7226b'),
(130, 'sena@misena.edu.co', '46ca56a5727667df9f666031614bb1f7461d110d'),
(131, 'sena@misena.edu.co', '728912e0541d9a44d9f344e4d18eeddc14972b5a'),
(132, 'sena@misena.edu.co', '0516e43cad0fd0cc0407b83e9b075d2f8f1ea1c2'),
(133, 'sena@misena.edu.co', '26ee11dbddab92d4b30af76f736f2db2d841c3ea'),
(134, 'sena@misena.edu.co', 'b0ecbc34d1554c8e72c579d57283e1c5150a7eae'),
(135, 'sena@misena.edu.co', '6720a00641471ea3278daf1ab66440b78f5686a1'),
(136, 'sena@misena.edu.co', 'c327eedc6487619f014110087055c5b1e72bf5ec'),
(137, 'sena@misena.edu.co', 'd88cd51adbd4dbc8d43e301117a9731e4f49b3d6'),
(138, 'sena@misena.edu.co', '155f28ccca5df96eeae5949493a4e7103e0239fb'),
(139, 'sena@misena.edu.co', 'cb97cc42eaffaff3a9c3dc936e9397b04664755a'),
(140, 'sena@misena.edu.co', 'd3c4fc66556bcb1a7bd9a13ab1edec4d637a264e'),
(141, 'sena@misena.edu.co', 'f103b78d1f22c97787746fd60ada40200296c1b2'),
(142, 'sena@misena.edu.co', '081dda27a781c38e432d42f182478a0a7595a6b3'),
(143, 'sena@misena.edu.co', 'b0f1fa54b4a3e4971414d9969330278256805e30'),
(144, 'sena@misena.edu.co', 'b4cacde0cc1c158fc811706d84bb6db7ad6a6d82'),
(145, 'sena@misena.edu.co', 'caaf0eeff6e5d840b88531a8d02ec1a7b7076908'),
(146, 'sena@misena.edu.co', 'f8cc62fdb87d7bb74570b519d1f9ec0ddba14bd3'),
(147, 'sena@misena.edu.co', '2401520d76e87f1756bd0fc466af98d405649782'),
(148, 'sena@misena.edu.co', '85568fcf8d454d0b028977483eea4ebadcd0a002'),
(149, 'sena@misena.edu.co', '312a71c5fbd269cc5424d785e50a9bdbaaa52781'),
(150, 'sena@misena.edu.co', '1672e572135738b8ba117da14ff18b078f6e53f4'),
(151, 'sena@misena.edu.co', 'b15d79e4246a44f081757adc3b81be47244020ab'),
(152, 'sena@misena.edu.co', 'dd2d25347cea0b0f258df91d713feda67d37843a'),
(153, 'sena@misena.edu.co', '0938ac9d7490c6596e87c321c9b37d90a0f0cb86'),
(154, 'sena@misena.edu.co', '4b51a86636b79398689917714c2c0f7dea424834'),
(155, 'sena@misena.edu.co', '62cb7197a339f08c0fb799a5fab4666ff35fc45d'),
(156, 'sena@misena.edu.co', 'a9fb359abcdea1ff3bf3f562afa1ae0ba20e007f'),
(157, 'sena@misena.edu.co', '971574a94531116b7aab831709034f1ce49b8aa5'),
(158, 'sena@misena.edu.co', 'c82eafd209f7f29d1a803767b114df08d178aa0a'),
(159, 'sena@misena.edu.co', 'e929ab980b1363a6a86efa194ecc97df7888161d'),
(160, 'sena@misena.edu.co', 'f25b354bf4da34cf94ad3f0b3d125022c5c9b99e'),
(161, 'sena@misena.edu.co', 'c229771cede8cfbf9a15deff3ef3292650a74b27'),
(162, 'sena@misena.edu.co', 'd817a8c0a96154dfbde572ac8e3fc73c24abdb95'),
(163, 'sena@misena.edu.co', '7fceaae963dba7a8c08acbbf99bc54bfb01a46d5'),
(164, 'sena@misena.edu.co', 'a7db0fdecb268240475d5a4433a0847a86be6c54'),
(165, 'sena@misena.edu.co', '058f5d6e4a60958e681d8ed421bb0962552b055f'),
(166, 'sena@misena.edu.co', '21066fc79cc2eb18309d14fe03b05fc530243ae0'),
(167, 'sena@misena.edu.co', 'f92adfcefeda632fcd108e8d60528efe742e98bc'),
(168, 'sena@misena.edu.co', 'dbc8937464ec7b955ca9a359c1f3cfd64ace8794'),
(169, 'sena@misena.edu.co', '25fb1c4d56a58bc6f31c05c390298839cad46417'),
(170, 'sena@misena.edu.co', '96f0c312b7391f3a9ad64fb9528d7f0da7bf1aa6'),
(171, 'sena@misena.edu.co', 'acf570d909301494c19275ff865252522d2a15fb'),
(172, 'sena@misena.edu.co', '29cea01c6856a20a7e33efb491a0b2174df82048'),
(173, 'sena@misena.edu.co', 'c096e14cd35394f1d3d87be73834f5af830d8422'),
(174, 'sena@misena.edu.co', '7dd65204b8bed8103794dc5c173b3d05a04999b5'),
(175, 'sena@misena.edu.co', 'b40613f778ca341c676370b8e197c910bdbd4f02'),
(176, 'sena@misena.edu.co', '44495af8cd6f39fead7e19137bce72e350e1aff9'),
(177, 'sena@misena.edu.co', 'cd0b591b6818926d61d3694b358bed49507463a4'),
(178, 'sena@misena.edu.co', '904ebf50a1d027483676cc6abda1ae11ad06c232'),
(179, 'sena@misena.edu.co', '9424fb58c79b11f083aed29f794c758851edddd5'),
(180, 'sena@misena.edu.co', '8d4df60cb08581d1f4fd66fa044051edae77ab4d'),
(181, 'sena@misena.edu.co', '71358d0223f3cb1a73b805731180a78e98bb0f75'),
(182, 'sena@misena.edu.co', 'b2a838fabd6e7fb5213b1dd5202e4850f06c2c92'),
(183, 'sena@misena.edu.co', '901e62f1ca7672291b73c165d963ba77288f679c'),
(184, 'sena@misena.edu.co', '26a2817710efb05c46d87cdd40240dfc804ba693'),
(185, 'sena@misena.edu.co', '639237fc16405011ad085af930ce94991252f1dd'),
(186, 'sena@misena.edu.co', '5bb165596e4e64d8c3e4f9e58a7e309b012d5733'),
(187, 'sena@misena.edu.co', '4c36fcf10738a5835fa2339bd739eeb1c94c7740'),
(188, 'sena@misena.edu.co', '66dbcf1d99dbf16fe453941bcbaec924350f16ce'),
(189, 'sena@misena.edu.co', '8af3dcfc994345be6d3a5e20b60c38a23f5f3f8c'),
(190, 'sena@misena.edu.co', '54e35e9d727bcdfc6260d5c3f6b9037d6180bb47'),
(191, 'sena@misena.edu.co', '1e68f76f5414c75d196700dfc724d2cfc71e2505'),
(192, 'sena@misena.edu.co', '638db8797af24207834ab3ba70c3c7189c55c922'),
(193, 'sena@misena.edu.co', '5118baa454693fbdadec4481529e4e9f9cf490d2'),
(194, 'sena@misena.edu.co', '8a2690f0d6d717df4acec7c2d41c4813d5e841df'),
(195, 'sena@misena.edu.co', 'f7d17dd0524e90bfa93e9d9e6b647d4b3530f935'),
(196, 'sena@misena.edu.co', '63ab208a8cb7a165d4bb24fd91daef744ce40eaf'),
(197, 'sena@misena.edu.co', '16208724f5eb0c9fb31fed440a2d50f19cfb348a'),
(198, 'sena@misena.edu.co', '941a0eb064cd766604df36b5fa726fc22489712f'),
(199, 'sena@misena.edu.co', '1a4e3d06d13816f255966c2d260c8c97ecfe08bf'),
(200, 'sena@misena.edu.co', '79d7253e0f7b38cb5adf859b8c1556a4d34f8a15'),
(201, 'sena@misena.edu.co', '21a7a43711a339552a46dbb633205d2cf6992a60'),
(202, 'sena@misena.edu.co', '09ba7232937de96a753592488b9fb17c30200021'),
(203, 'sena@misena.edu.co', '6dfc2f7db907e25649918f5fc7d070a29b7c3c77'),
(204, 'sena@misena.edu.co', '58546e20bc4d61d1392e45a03879cb625abcb015'),
(205, 'sena@misena.edu.co', '0b23bb445b0154ca061fe7c307828911516a7623'),
(206, 'sena@misena.edu.co', '3e2c347bb6ffa322d98b3d496ab708d5aeca8ea1'),
(207, 'sena@misena.edu.co', 'a8dda68454f0954809ea1e9699b396a1c4e3756c'),
(208, 'sena@misena.edu.co', 'fe9636977898cc66476027d47cf65006e89123f5'),
(209, 'sena@misena.edu.co', '8a3ca8b8f1e1656c3c926502b534160a63ec34f4'),
(210, 'sena@misena.edu.co', '5a3a43d4ae8273f73735261c99d8bfd64d45473e'),
(211, 'sena@misena.edu.co', '8f92bbc8e523c56f1f3b9083ba1c494933216512'),
(212, 'sena@misena.edu.co', '9b7e2cc0b7b73783945de39c01826757735c3bee'),
(213, 'sena@misena.edu.co', 'b9e82c24d84de8f80cbd20b7cf77eec095393ad1'),
(214, 'sena@misena.edu.co', '84dde3315c6159a06ce3f5476efea41dd02f36f7'),
(215, 'sena@misena.edu.co', 'ca1fa214b0eaa48530cb4d9c268d8ccfe6ebfda3'),
(216, 'sena@misena.edu.co', '8232e57607600f805301e8b176af8761957ca469'),
(217, 'sena@misena.edu.co', 'eeba98145972dd34f5aec8f4785dc72038e4b919'),
(218, 'sena@misena.edu.co', '577b44a4f74a7178600b978a2a375550d57fdf2f'),
(219, 'sena@misena.edu.co', 'd21d6b002454b3d07da0b86545019d14bebfc290'),
(220, 'sena@misena.edu.co', '7db379e0b7c5cbfb0e8762956bae7a3d2c59a1da'),
(221, 'sena@misena.edu.co', '8731b40d7f05240cc6db66e14fa817ea22b63cb0'),
(222, 'sena@misena.edu.co', 'd1e2fac5d79f19997429458f4421832429bbb9d9'),
(223, 'sena@misena.edu.co', '424fc7fdfbf4e88526c87fedd95e8d30575f71f5'),
(224, 'sena@misena.edu.co', 'd8c7add6b77edae5bf0ab9470a44aac0a652300c'),
(225, 'sena@misena.edu.co', 'faf86d2d54ab8dc3dbebd4237f676ffcb17ca915'),
(226, 'sena@misena.edu.co', 'a913987e7a4836152aec02044d6f9932c76ce0ed'),
(227, 'sena@misena.edu.co', '238b4d3513bdaa4121831dc006e992e1bd5c8eef'),
(228, 'sena@misena.edu.co', '91bde9a6bd0d0f2e6b8a448cfe6f512911a06a61'),
(229, 'sena@misena.edu.co', 'ca77905204c4e84953279a9877ecbcfadf1e07b9'),
(230, 'sena@misena.edu.co', 'd983b35de61dbe2a1ead7e7a0057b34dc4c69d10'),
(231, 'sena@misena.edu.co', 'b683a0aec6cdf91d0b5c84955e9b12e21775d7dd'),
(232, 'sena@misena.edu.co', 'da457e18ec8e64df084209ab63d7958abe467350'),
(233, 'sena@misena.edu.co', '8def6766e03ff094e4ae2b749fcc4efe9514b2f9'),
(234, 'sena@misena.edu.co', '7b0a99187e72d79301a8e24dbdb0177e28fbe832'),
(235, 'sena@misena.edu.co', '34568ee09a294ade7aa5d083643914df37e6b186'),
(236, 'sena@misena.edu.co', '46d5375ece645cbf88e519576e59be564b718bb0'),
(237, 'sena@misena.edu.co', 'bdcb744763d7d509a66a2a0e0b18665738d9a480'),
(238, 'sena@misena.edu.co', '72979584c1f61f2e7f533e0aa3fdcbead9807918'),
(239, 'sena@misena.edu.co', 'c62097fbf651f10499ec76462d9081822c321407'),
(240, 'sena@misena.edu.co', 'e2f864b4efb0fbe07e211d1c4998f653c1a28184'),
(241, 'sena@misena.edu.co', '45f38c93fe450a83166f6f36ad7b7002afef6fe5'),
(242, 'sena@misena.edu.co', '32c184480a468148664eb2919f71e9551d8c5479'),
(243, 'sena@misena.edu.co', '6d8cdea2b59467ab7895e70fbf77ccdf0c845cf9'),
(244, 'sena@misena.edu.co', 'c6c290fa9a36c237d23034f7e7f4e9853d426b4b'),
(245, 'sena@misena.edu.co', '2313cc40bf49686aab4f5339389c4adfb61b0286'),
(246, 'sena@misena.edu.co', '40b967179eb3dda4512fe0f03b5f54398ce87f24'),
(247, 'sena@misena.edu.co', 'dd506d26a6e3820700c0911d88e1c563b2fe2343'),
(248, 'sena@misena.edu.co', '13e1822c06fe461239845922a4edfe9d442fc232'),
(249, 'sena@misena.edu.co', 'cf89edbc47436dc60a389fa8cfb7448d1b1ed71a'),
(250, 'sena@misena.edu.co', '993d96403ddfa2ac656df023e8f1a107de38cbef'),
(251, 'sena@misena.edu.co', '342c9bba6684c451ad54ac0d9d5cf1d1c338687d'),
(252, 'sena@misena.edu.co', 'dd47718ac3dfed1173f6199eff11cf1f63c084d3'),
(253, 'sena@misena.edu.co', '102b5bcecba94287ebb515a1a8c0b0dc41000c83'),
(254, 'sena@misena.edu.co', 'de4d64adbbb3fac1f1311234ee377d543d14d497'),
(255, 'sena@misena.edu.co', 'eef66e1ab37cbf7148761151710fdd16b954ec0f'),
(256, 'sena@misena.edu.co', 'd9ffc64a25fb05331bd1b712ccd7241f84994397'),
(257, 'sena@misena.edu.co', '57c8dfacc2084c1c3a1b12851d3ee2845e68c4ae'),
(258, 'sena@misena.edu.co', '6f6dee8c3c38b3de5132f849ba3ccb02f2de6a1a'),
(259, 'sena@misena.edu.co', '1a16f47c998621cc7e3dc90955b64f28541b1dbe'),
(260, 'sena@misena.edu.co', 'b16e474f53210c02655fd6bbaee15f9d593f7f88'),
(261, 'sena@misena.edu.co', 'd765f5ce2a90965390aa0de8ef59698ae269e24a'),
(262, 'sena@misena.edu.co', '8a269629cc5e8d994bbb8962ac03ce2be312debd'),
(263, '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709'),
(264, '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709'),
(265, 'sena@misena.edu.co', 'e40a88d47e3291b9f5392d8bbfd38e5424f74c02'),
(266, 'sena@misena.edu.co', 'e5e4e4fc09f71b22ced694ce443de4ba42ea45c3'),
(267, 'sena@misena.edu.co', '0f8d4789ecc39fe2b94a632a707cc0a0c4cabe84'),
(268, 'sena@misena.edu.co', '9614ff0290e644abf749146629dc86b5759548e8'),
(269, 'sena@misena.edu.co', '426206e8f43ea0696322f69a735f3ef9649c3f28'),
(270, 'sena@misena.edu.co', '034af01d83ee7c954febeb820a5f788335adda35'),
(271, 'sena@misena.edu.co', 'cb6d521834e9b401c17d24bb8ead69e21d1ae45d'),
(272, 'sena@misena.edu.co', 'a89aebb6f6c6ca536aee84cdb270c0c8540eecc1'),
(273, 'sena@misena.edu.co', '8dccb4d2f553738f87def4647287ef6ffde79eea'),
(274, 'sena@misena.edu.co', 'b16a3a5964f11f79e0091a467e8453401102e6c4'),
(275, 'sena@misena.edu.co', '2ad8a61e78878140da7aa372083fbd7d42547b25'),
(276, 'sena@misena.edu.co', 'cda9b25a7bac5d6ce2e4e2c816d2826ffaf51dd0'),
(277, 'sena@misena.edu.co', '2d8aae58f08aa8c08e96b877d35ff24d28b84d46'),
(278, 'sena@misena.edu.co', 'adfdc1ea978a9b0d5d15ef0fed9230ee2e60372e'),
(279, 'sena@misena.edu.co', '8e0aaf8d3e6178d3e1feaaf6e2146d8569a9e8ac'),
(280, 'sena@misena.edu.co', '21608d915207d4089767ba2bfc37587ba3dfd763'),
(281, 'sena@misena.edu.co', '7e4140262fc7a18abefc83635baf3230434fd2c6'),
(282, 'sena@misena.edu.co', 'e44031dfa55c6ea2c34b3786b458586309a74b0a'),
(283, 'sena@misena.edu.co', '60d65d3b62fe3cc7a51c1746acc3baace94ff72e'),
(284, 'sena@misena.edu.co', '8249773edb593e4091f8365a374b77643c91502d'),
(285, 'sena@misena.edu.co', 'b9edaa3064648d2f6ab040dddb1f20057f63aa8c'),
(286, 'sena@misena.edu.co', '89dd89b4c9763b499bb53ca286ab9dab6477f4ec'),
(287, 'sena@misena.edu.co', 'd5b0f58cfa07b49ea3d629282b19814e74cea29c'),
(288, 'sena@misena.edu.co', '3aebd912e2018efbbd6dfca6944828fde64495fc'),
(289, 'sena@misena.edu.co', '667c5f3c886483a4af56535b1fafe15731fea494'),
(290, 'sena@misena.edu.co', 'be641eeaf895c0d7bef3373fe0185cbea2ae9b26'),
(291, 'sena@misena.edu.co', '5b3da9bb8dfd3cd1edf139e24ff568fc7f59e70e'),
(292, 'sena@misena.edu.co', '82e363b862b764b05b19718616528159aa358be2'),
(293, 'sena@misena.edu.co', 'c147d7a05dfe6b1b7995246b4d821f2ec4496037'),
(294, 'sena@misena.edu.co', 'cc2673476ce38c974c587d318d453976a5a95271'),
(295, 'sena@misena.edu.co', '1beb7527b66e07795d1c0faab9ce057494d81d59'),
(296, 'sena@misena.edu.co', '50023ede060034a3b797ea9829750bf683de0c29'),
(297, 'sena@misena.edu.co', '6cc2cc80a6cad3380472087d395807545eda8c65'),
(298, 'sena@misena.edu.co', 'c7c347ab59a2ed131e4bb3eced0e91d7131315ce'),
(299, 'sena@misena.edu.co', '58487baa9f6bfbac82e8bf2bb822f865660e3afa'),
(300, 'sena@misena.edu.co', 'f6088de59d06ab0cd1a249ff4f0ac84213226c85'),
(301, 'sena@misena.edu.co', '10446d104bae9340f5ba19cf72657f659f81228c'),
(302, 'sena@misena.edu.co', '93e52d433a6227265dbd0cc8aca1b13ebb838f05'),
(303, 'sena@misena.edu.co', '8003239845b7b9f2a3afb356a243483a6819febd'),
(304, 'sena@misena.edu.co', 'd75a51f696f74d1b26019abb14faa59e51e79356'),
(305, 'sena@misena.edu.co', 'd05fda78b0e6adb310c4b8aa88f547440e2dda83'),
(306, 'sena@misena.edu.co', '62cbdad80616c353f00e58136e8aaa1d648a164a'),
(307, 'sena@misena.edu.co', '7a0688c3b569fd85cc513fa3e0efd0f0dc3b6ac8'),
(308, 'sena@misena.edu.co', 'e39804e0c27363bba5b9861864de3f9436987cea'),
(309, 'sena@misena.edu.co', 'e4887874db0d35c333d5e4e9710ad86130e5b753'),
(310, 'sena@misena.edu.co', '8804d19f990e10385c866bfb1f6a464fc0edb43e'),
(311, 'sena@misena.edu.co', 'c0fba43fee2fda1b3262c5a9d53fc07f7f03289b'),
(312, 'sena@misena.edu.co', '7e06a5f9bc88c819628ada7df84126552adc7b7a'),
(313, 'sena@misena.edu.co', '8fc308dbc87fd1c865fb0f423f1cdfb6c2341aa8'),
(314, 'sena@misena.edu.co', 'da49e3703e1ed189c8ae192662a92709537da234'),
(315, 'sena@misena.edu.co', '8b669674cb163a3823c62f1aff085c882d59adff'),
(316, 'sena@misena.edu.co', '7468a32956a44cc9bb028e7f984a9e479378d589'),
(317, 'sena@misena.edu.co', 'f6e029d778e01e6ecf2cfe7824c6c89a19e9a5b2'),
(318, 'sena@misena.edu.co', 'edd41aeec0cfee89991f9f1aa43ad40d17eb8c58'),
(319, 'sena@misena.edu.co', '866c5ff359becdb34c6a048bc689605733b74060'),
(320, 'sena@misena.edu.co', '50b16087a31fed15d4099a3d6ee9af2be2898010'),
(321, 'sena@misena.edu.co', '51899ee66be5064d6e6e5868e59e36a11fd37614'),
(322, 'sena@misena.edu.co', '65ff08837c90a3f322c1acdcf3ca56e03c4ae6fc'),
(323, 'sena@misena.edu.co', 'd35f5fc75e6202bead1b13c4459f3bae8de28625'),
(324, 'sena@misena.edu.co', '4cf9850415a76250686b14d8120d8982dd6137e3'),
(325, 'sena@misena.edu.co', '643f8e5b16aa1123c8db23efe3411c2ac56d296b'),
(326, 'sena@misena.edu.co', 'b973f33e6628acba923f793eaca34479bdeb7505'),
(327, 'sena@misena.edu.co', '6329d520c3e94e5faf402b873381bb1c55c59bf2'),
(328, 'sena@misena.edu.co', '8c546b737813edcb16f461d57342e14036fbe2c4'),
(329, 'sena@misena.edu.co', '32c9057a2c745bfb011b503b4ced878e78e40a3b'),
(330, 'sena@misena.edu.co', '431c53db268756c66619b4b042bd4857d558c717'),
(331, 'sena@misena.edu.co', '5c23f34455c9c677cca44a136e84b3a4e6ac6415'),
(332, 'sena@misena.edu.co', '47da43a2692a55c7a2d4ce513ea4bd377def3892'),
(333, 'sena@misena.edu.co', 'fd46fa757d2933931a70bcdb3918e16092630461'),
(334, 'sena@misena.edu.co', '670e2d61dbeedc1bf8e3ccc862a52eaf45a136d8'),
(335, 'sena@misena.edu.co', 'd114d85bcfb049f75ce8b0feb91118dac5c1443c'),
(336, 'sena@misena.edu.co', 'e923dc232c55542e1e8b4cde5c6a896c9aa4f823'),
(337, 'sena@misena.edu.co', '422b1bfb11fc26e6c306112220bc595e33e7e33c'),
(338, 'sena@misena.edu.co', '61266a319ebeaf30fe222250ed65a069fa2e9389'),
(339, 'sena@misena.edu.co', 'c7f24359c1cd651e57d85e606a00cf62a2599e6d'),
(340, 'sena@misena.edu.co', 'bc4554654b77b14109afc557ecbd7ce0a9791857'),
(341, 'sena@misena.edu.co', 'e573ee530624f35da5ec60070c300f89868c39e3'),
(342, 'sena@misena.edu.co', '5bf52e6eced94a82d0644703799fce6e1411ffc3'),
(343, 'sena@misena.edu.co', 'eb7647ed2363b05525fca75f0fa99934902e1f71'),
(344, 'sena@misena.edu.co', '45a119767627c8b74c5a1a80156b6b62e3501174'),
(345, 'sena@misena.edu.co', '13e7df0184932adcf92c7e3a68c5dc514c89a198'),
(346, 'sena@misena.edu.co', 'f4ec21be622a8af3ef7372419caee06631732665'),
(347, 'sena@misena.edu.co', 'e4fbdc880b014100f6002ef7d11efb915d74584e'),
(348, 'sena@misena.edu.co', '06bbab5f9d64b5a4c043e4dd1f68ee1b5e0225a7'),
(349, 'sena@misena.edu.co', '9b2f756b98082470911253e9fdb2d4c653402d7e'),
(350, 'sena@misena.edu.co', 'b74eb400c7d18daddb14e01b95f16993b8dce165'),
(351, 'sena@misena.edu.co', '349c2d25d207e46f5f1754204aaf34c79d7ec324'),
(352, 'sena@misena.edu.co', '060424fccd08e17e242ced4657a0006d069cc98e'),
(353, 'sena@misena.edu.co', 'bf28e164052c932d072c9b19a1c360223eaa63e3'),
(354, 'sena@misena.edu.co', 'ee91388bb717f24f5c0852624ec5e1cc91344c66'),
(355, 'sena@misena.edu.co', '5c4c2c33ca8d74325067f494cb2290913b60eb42'),
(356, 'sena@misena.edu.co', '746fc0e1db44c3627c1f1a460217b8d596ea2df3'),
(357, 'sena@misena.edu.co', '70b2db88d17e843f0ec93ff00a227eb96c78a70a'),
(358, 'sena@misena.edu.co', '529e1408ad5d21c759d28e968ed05ed19d3cb66e'),
(359, 'sena@misena.edu.co', '68587ce8fb639f8bfce0804171414b4b42a90d4e'),
(360, 'sena@misena.edu.co', '901ade1e420da59851a6e82ec6246a305ea6bfaf'),
(361, 'sena@misena.edu.co', '65c0229ecf6903bab3497111b1a1a713664b687e'),
(362, 'sena@misena.edu.co', '823d96f1eee93f65dd265c875539f8bc76bd4f68'),
(363, 'sena@misena.edu.co', '51a3060f0e27768131b6d4c3d82f04a1383cf7a4'),
(364, 'sena@misena.edu.co', '8ae2c091f7bfd68c96efeb7427460cf1f86f21cf'),
(365, 'sena@misena.edu.co', '16e751ab2eddec57d2fa0a60831602642985050a'),
(366, 'sena@misena.edu.co', '580a6b1a694c4627db52506e3e2c871f3d64f3df'),
(367, 'sena@misena.edu.co', '95f35bc14488cd9e8d42b39901341b374da4cc1d'),
(368, 'sena@misena.edu.co', '2855e16f94683c6a38feb78cd0848441212fb0ed'),
(369, 'sena@misena.edu.co', '027294787a678356f00bff72fe90aea38ac03782'),
(370, 'sena@misena.edu.co', 'e2d425660cc59ed67a8a3ddb73899a3f91b3883a'),
(371, 'sena@misena.edu.co', 'e4638911cb618c5a5d1636f8e3926e4ee0fd5cc1');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_detalleasignacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_detalleasignacion` (
`id` int(11)
,`numeroFicha` int(11)
,`Ambiente` varchar(40)
,`Dia` varchar(30)
,`nombre` varchar(45)
,`Instructor` varchar(511)
,`Trimestre` int(11)
,`horaInicio` time
,`horaFin` time
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_listarusuarios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_listarusuarios` (
`TipoDocumento` varchar(25)
,`Documento` int(11)
,`nombre` varchar(255)
,`apellido` varchar(255)
,`telefono` varchar(255)
,`correo` varchar(255)
,`password` varchar(255)
,`tipoUsuario` varchar(25)
,`estado` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_login`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_login` (
`idUsuario` int(11)
,`usuario` varchar(511)
,`correo` varchar(255)
,`password` varchar(255)
,`tipousuario` varchar(25)
,`estado` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `detalleaprendiz`
--
DROP TABLE IF EXISTS `detalleaprendiz`;

CREATE  VIEW `detalleaprendiz`  AS  select `du`.`documento` AS `documento`,concat(`du`.`nombre`,`du`.`apellido`) AS `nombre`,`f`.`numeroFicha` AS `numeroFicha`,`d`.`nombre` AS `Dia`,`a`.`nombre` AS `Ambiente`,`ap`.`nombre` AS `Materia`,`t`.`descripcion` AS `trimestre` from ((((((((((`detalleusuario` `du` join `usuario` `u` on(`du`.`idUsuario` = `u`.`idUsuario`)) join `roles` `ro` on(`ro`.`idUsuario` = `u`.`idUsuario`)) join `tipousuario` `tu` on(`tu`.`idTipoUsuario` = `ro`.`idTipoUsuario`)) join `detalleasignacion` `da` on(`u`.`idUsuario` = `da`.`idUsuario`)) join `ficha` `f` on(`f`.`idFicha` = `da`.`idFicha`)) join `programa` `p` on(`p`.`idPrograma` = `f`.`idPrograma`)) join `trimestre` `t` on(`t`.`idPrograma` = `p`.`idPrograma`)) join `dia` `d` on(`d`.`idDia` = `da`.`idDia`)) join `ambiente` `a` on(`a`.`idAmbiente` = `da`.`idAmbiente`)) join `actiproy` `ap` on(`ap`.`idActiProy` = `da`.`idActiProy`)) where `tu`.`idTipoUsuario` = 3 order by `t`.`descripcion` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `instructores`
--
DROP TABLE IF EXISTS `instructores`;

CREATE  VIEW `instructores`  AS  select `u`.`idUsuario` AS `idUsuario`,concat(`dt`.`nombre`,' ',`dt`.`apellido`) AS `nombre` from (((`usuario` `u` join `detalleusuario` `dt` on(`dt`.`idUsuario` = `u`.`idUsuario`)) join `roles` `r` on(`u`.`idUsuario` = `r`.`idUsuario`)) join `tipousuario` `t` on(`r`.`idTipoUsuario` = `t`.`idTipoUsuario`)) where `t`.`idTipoUsuario` = 2 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_detalleasignacion`
--
DROP TABLE IF EXISTS `v_detalleasignacion`;

CREATE  VIEW `v_detalleasignacion`  AS  select `dt`.`idDetalleA` AS `id`,`f`.`numeroFicha` AS `numeroFicha`,`a`.`nombre` AS `Ambiente`,`d`.`nombre` AS `Dia`,`ac`.`nombre` AS `nombre`,concat(`de`.`nombre`,' ',`de`.`apellido`) AS `Instructor`,`dt`.`TrimPeriodo` AS `Trimestre`,`dt`.`horaInicio` AS `horaInicio`,`dt`.`horaFin` AS `horaFin` from ((((((`detalleasignacion` `dt` join `ficha` `f` on(`f`.`idFicha` = `dt`.`idFicha`)) join `ambiente` `a` on(`a`.`idAmbiente` = `dt`.`idAmbiente`)) join `dia` `d` on(`d`.`idDia` = `dt`.`idDia`)) join `usuario` `u` on(`u`.`idUsuario` = `dt`.`idUsuario`)) join `detalleusuario` `de` on(`de`.`idUsuario` = `u`.`idUsuario`)) join `actiproy` `ac` on(`ac`.`idActiProy` = `dt`.`idActiProy`)) order by `d`.`nombre` <> 0 and `dt`.`TrimPeriodo` <> 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_listarusuarios`
--
DROP TABLE IF EXISTS `v_listarusuarios`;

CREATE  VIEW `v_listarusuarios`  AS  select `td`.`tipoDocumento` AS `TipoDocumento`,`dt`.`documento` AS `Documento`,`dt`.`nombre` AS `nombre`,`dt`.`apellido` AS `apellido`,`dt`.`telefono` AS `telefono`,`u`.`correo` AS `correo`,`u`.`password` AS `password`,`tu`.`tipoUsuario` AS `tipoUsuario`,`r`.`estado` AS `estado` from ((((`detalleusuario` `dt` join `tipodoc` `td` on(`td`.`idTipoDoc` = `dt`.`idTipoDoc`)) join `usuario` `u` on(`u`.`idUsuario` = `dt`.`idUsuario`)) join `roles` `r` on(`u`.`idUsuario` = `r`.`idUsuario`)) join `tipousuario` `tu` on(`r`.`idTipoUsuario` = `tu`.`idTipoUsuario`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_login`
--
DROP TABLE IF EXISTS `v_login`;

CREATE  VIEW `v_login`  AS  select `u`.`idUsuario` AS `idUsuario`,concat(`du`.`nombre`,' ',`du`.`apellido`) AS `usuario`,`u`.`correo` AS `correo`,`u`.`password` AS `password`,`t`.`tipoUsuario` AS `tipousuario`,`r`.`estado` AS `estado` from (((`usuario` `u` join `roles` `r` on(`r`.`idUsuario` = `u`.`idUsuario`)) join `tipousuario` `t` on(`t`.`idTipoUsuario` = `r`.`idTipoUsuario`)) join `detalleusuario` `du` on(`du`.`idUsuario` = `u`.`idUsuario`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `actiproy`
--
ALTER TABLE `actiproy`
  ADD PRIMARY KEY (`idActiProy`);

--
-- Indices de la tabla `ambiente`
--
ALTER TABLE `ambiente`
  ADD PRIMARY KEY (`idAmbiente`),
  ADD KEY `idTipoAmbien` (`idTipoAmbien`);

--
-- Indices de la tabla `centro`
--
ALTER TABLE `centro`
  ADD PRIMARY KEY (`idCentro`),
  ADD KEY `idSede` (`idSede`);

--
-- Indices de la tabla `competencia`
--
ALTER TABLE `competencia`
  ADD PRIMARY KEY (`idCompetencia`),
  ADD KEY `idPrograma` (`idPrograma`);

--
-- Indices de la tabla `detalleasignacion`
--
ALTER TABLE `detalleasignacion`
  ADD PRIMARY KEY (`idDetalleA`),
  ADD KEY `idFicha` (`idFicha`),
  ADD KEY `idAmbiente` (`idAmbiente`),
  ADD KEY `idDia` (`idDia`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `fk_detalleasignacion_actiproy1_idx` (`idActiProy`);

--
-- Indices de la tabla `detalleusu`
--
ALTER TABLE `detalleusu`
  ADD PRIMARY KEY (`idDetalleF`),
  ADD KEY `idFicha` (`idFicha`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `detalleusuario`
--
ALTER TABLE `detalleusuario`
  ADD PRIMARY KEY (`idDetalleUsu`),
  ADD KEY `fk_detalleusuario_usuario1_idx` (`idUsuario`),
  ADD KEY `fk_detalleusuario_tipodoc1_idx` (`idTipoDoc`);

--
-- Indices de la tabla `detaproject`
--
ALTER TABLE `detaproject`
  ADD PRIMARY KEY (`iddetaProject`),
  ADD KEY `fk_detaProject_actiproy1_idx` (`idActiProy`),
  ADD KEY `fk_detaProject_resulta1_idx` (`idResultA`);

--
-- Indices de la tabla `dia`
--
ALTER TABLE `dia`
  ADD PRIMARY KEY (`idDia`);

--
-- Indices de la tabla `ficha`
--
ALTER TABLE `ficha`
  ADD PRIMARY KEY (`idFicha`),
  ADD KEY `idPrograma` (`idPrograma`);

--
-- Indices de la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD PRIMARY KEY (`idMunicipio`),
  ADD KEY `idRegional` (`idRegional`);

--
-- Indices de la tabla `pais`
--
ALTER TABLE `pais`
  ADD PRIMARY KEY (`idPais`);

--
-- Indices de la tabla `programa`
--
ALTER TABLE `programa`
  ADD PRIMARY KEY (`idPrograma`),
  ADD KEY `idCentro` (`idCentro`);

--
-- Indices de la tabla `regional`
--
ALTER TABLE `regional`
  ADD PRIMARY KEY (`idRegional`),
  ADD KEY `idPais` (`idPais`);

--
-- Indices de la tabla `resulta`
--
ALTER TABLE `resulta`
  ADD PRIMARY KEY (`idResultA`),
  ADD KEY `idTrimestre` (`idTrimestre`),
  ADD KEY `idCompetencia` (`idCompetencia`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRol`),
  ADD KEY `fk_Rol_usuario1_idx` (`idUsuario`),
  ADD KEY `fk_Rol_tipousuario1_idx` (`idTipoUsuario`);

--
-- Indices de la tabla `sede`
--
ALTER TABLE `sede`
  ADD PRIMARY KEY (`idSede`),
  ADD KEY `idMunicipio` (`idMunicipio`);

--
-- Indices de la tabla `tipoambiente`
--
ALTER TABLE `tipoambiente`
  ADD PRIMARY KEY (`idTipoAmbien`);

--
-- Indices de la tabla `tipodoc`
--
ALTER TABLE `tipodoc`
  ADD PRIMARY KEY (`idTipoDoc`);

--
-- Indices de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  ADD PRIMARY KEY (`idTipoUsuario`);

--
-- Indices de la tabla `trimestre`
--
ALTER TABLE `trimestre`
  ADD PRIMARY KEY (`idTrimestre`),
  ADD KEY `idPrograma` (`idPrograma`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `actiproy`
--
ALTER TABLE `actiproy`
  MODIFY `idActiProy` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla actiproy', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `ambiente`
--
ALTER TABLE `ambiente`
  MODIFY `idAmbiente` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla ambiente', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `centro`
--
ALTER TABLE `centro`
  MODIFY `idCentro` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador del centro ', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `competencia`
--
ALTER TABLE `competencia`
  MODIFY `idCompetencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `detalleasignacion`
--
ALTER TABLE `detalleasignacion`
  MODIFY `idDetalleA` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identicador de la tabla';

--
-- AUTO_INCREMENT de la tabla `detalleusu`
--
ALTER TABLE `detalleusu`
  MODIFY `idDetalleF` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=356;

--
-- AUTO_INCREMENT de la tabla `detalleusuario`
--
ALTER TABLE `detalleusuario`
  MODIFY `idDetalleUsu` int(11) NOT NULL AUTO_INCREMENT COMMENT 'EL identificador de la tabla', AUTO_INCREMENT=372;

--
-- AUTO_INCREMENT de la tabla `detaproject`
--
ALTER TABLE `detaproject`
  MODIFY `iddetaProject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dia`
--
ALTER TABLE `dia`
  MODIFY `idDia` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla dia', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `ficha`
--
ALTER TABLE `ficha`
  MODIFY `idFicha` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla ficha', AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `municipio`
--
ALTER TABLE `municipio`
  MODIFY `idMunicipio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identiifcador de la tabla ', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `pais`
--
ALTER TABLE `pais`
  MODIFY `idPais` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `programa`
--
ALTER TABLE `programa`
  MODIFY `idPrograma` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `regional`
--
ALTER TABLE `regional`
  MODIFY `idRegional` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla ', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `resulta`
--
ALTER TABLE `resulta`
  MODIFY `idResultA` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla de la tabla resultado';

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=370;

--
-- AUTO_INCREMENT de la tabla `sede`
--
ALTER TABLE `sede`
  MODIFY `idSede` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipoambiente`
--
ALTER TABLE `tipoambiente`
  MODIFY `idTipoAmbien` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipodoc`
--
ALTER TABLE `tipodoc`
  MODIFY `idTipoDoc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador de la tabla', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  MODIFY `idTipoUsuario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador unico de la tabla', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `trimestre`
--
ALTER TABLE `trimestre`
  MODIFY `idTrimestre` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identificador  de la tabla ', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Es el identificador de la tabla', AUTO_INCREMENT=372;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ambiente`
--
ALTER TABLE `ambiente`
  ADD CONSTRAINT `ambiente_ibfk_1` FOREIGN KEY (`idTipoAmbien`) REFERENCES `tipoambiente` (`idTipoAmbien`);

--
-- Filtros para la tabla `centro`
--
ALTER TABLE `centro`
  ADD CONSTRAINT `centro_ibfk_1` FOREIGN KEY (`idSede`) REFERENCES `sede` (`idSede`);

--
-- Filtros para la tabla `competencia`
--
ALTER TABLE `competencia`
  ADD CONSTRAINT `competencia_ibfk_1` FOREIGN KEY (`idPrograma`) REFERENCES `programa` (`idPrograma`);

--
-- Filtros para la tabla `detalleasignacion`
--
ALTER TABLE `detalleasignacion`
  ADD CONSTRAINT `detalleasignacion_ibfk_3` FOREIGN KEY (`idAmbiente`) REFERENCES `ambiente` (`idAmbiente`),
  ADD CONSTRAINT `detalleasignacion_ibfk_4` FOREIGN KEY (`idDia`) REFERENCES `dia` (`idDia`),
  ADD CONSTRAINT `detalleasignacion_ibfk_5` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `fk_detalleasignacion_actiproy1` FOREIGN KEY (`idActiProy`) REFERENCES `actiproy` (`idActiProy`),
  ADD CONSTRAINT `idFicha1` FOREIGN KEY (`idFicha`) REFERENCES `ficha` (`idFicha`);

--
-- Filtros para la tabla `detalleusu`
--
ALTER TABLE `detalleusu`
  ADD CONSTRAINT `detalleficha_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `idFicha` FOREIGN KEY (`idFicha`) REFERENCES `ficha` (`idFicha`);

--
-- Filtros para la tabla `detalleusuario`
--
ALTER TABLE `detalleusuario`
  ADD CONSTRAINT `fk_detalleusuario_tipodoc1` FOREIGN KEY (`idTipoDoc`) REFERENCES `tipodoc` (`idTipoDoc`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalleusuario_usuario1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `detaproject`
--
ALTER TABLE `detaproject`
  ADD CONSTRAINT `fidresulta` FOREIGN KEY (`idResultA`) REFERENCES `resulta` (`idResultA`),
  ADD CONSTRAINT `idAtivi` FOREIGN KEY (`idActiProy`) REFERENCES `actiproy` (`idActiProy`);

--
-- Filtros para la tabla `ficha`
--
ALTER TABLE `ficha`
  ADD CONSTRAINT `ficha_ibfk_1` FOREIGN KEY (`idPrograma`) REFERENCES `programa` (`idPrograma`);

--
-- Filtros para la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD CONSTRAINT `municipio_ibfk_1` FOREIGN KEY (`idRegional`) REFERENCES `regional` (`idRegional`);

--
-- Filtros para la tabla `programa`
--
ALTER TABLE `programa`
  ADD CONSTRAINT `Fkcentro` FOREIGN KEY (`idCentro`) REFERENCES `centro` (`idCentro`);

--
-- Filtros para la tabla `regional`
--
ALTER TABLE `regional`
  ADD CONSTRAINT `regional_ibfk_1` FOREIGN KEY (`idPais`) REFERENCES `pais` (`idPais`);

--
-- Filtros para la tabla `resulta`
--
ALTER TABLE `resulta`
  ADD CONSTRAINT `resulta_ibfk_1` FOREIGN KEY (`idTrimestre`) REFERENCES `trimestre` (`idTrimestre`),
  ADD CONSTRAINT `resulta_ibfk_2` FOREIGN KEY (`idCompetencia`) REFERENCES `competencia` (`idCompetencia`);

--
-- Filtros para la tabla `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `fk_Rol_tipousuario1` FOREIGN KEY (`idTipoUsuario`) REFERENCES `tipousuario` (`idTipoUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Rol_usuario1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `sede`
--
ALTER TABLE `sede`
  ADD CONSTRAINT `sede_ibfk_1` FOREIGN KEY (`idMunicipio`) REFERENCES `municipio` (`idMunicipio`);

--
-- Filtros para la tabla `trimestre`
--
ALTER TABLE `trimestre`
  ADD CONSTRAINT `trimestre_ibfk_1` FOREIGN KEY (`idPrograma`) REFERENCES `programa` (`idPrograma`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
