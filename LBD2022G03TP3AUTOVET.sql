-- Año: 2022
-- Grupo Nro: 03
-- Integrantes: García Ángela Beatriz, Hernandez José Ignacio
-- Tema: Gestor de Turnos
-- Nombre del Esquema lbd2022g03tp1autovet
-- Plataforma (SO + Versión): Windows 10 
-- Motor y Versión: MySQL Server 8.0.28 (Community Server)
-- GitHub Repositorio: LBD2022G03
-- GitHub Usuario: beatrizang, hernandezjoseignacio

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LBD2022G03TP1AUTOVET
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LBD2022G03TP3AUTOVET` ;

-- -----------------------------------------------------
-- Schema LBD2022G03TP1AUTOVET
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LBD2022G03TP3AUTOVET` DEFAULT CHARACTER SET utf8 ;
USE `LBD2022G03TP3AUTOVET` ;

-- -----------------------------------------------------
-- Table `Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Personas` ;

CREATE TABLE IF NOT EXISTS `Personas` (
  `dni` INT NOT NULL CHECK (`dni` > 0),
  `apellido` VARCHAR(25) NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(15) NULL,
  `domicilio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dni`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `Personas` (`email` ASC);


-- -----------------------------------------------------
-- Table `Veterinarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Veterinarios` ;

CREATE TABLE IF NOT EXISTS `Veterinarios` (
  `dni` INT NOT NULL,
  `matriculaProfesional` INT NOT NULL CHECK (`matriculaProfesional` > 0),
  `Especialidad` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `fk_Veterinarios_Personas`
    FOREIGN KEY (`dni`)
    REFERENCES `Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `UX_matriculaProfesional` ON `Veterinarios` (`matriculaProfesional` ASC) ;

CREATE INDEX `IX_matriculaProfesional` ON `Veterinarios` (`matriculaProfesional` ASC) ;


-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Clientes` ;

CREATE TABLE IF NOT EXISTS `Clientes` (
  `dni` INT NOT NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `fk_Clientes_Personas1`
    FOREIGN KEY (`dni`)
    REFERENCES `Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mascotas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mascotas` ;

CREATE TABLE IF NOT EXISTS `Mascotas` (
  `idMascota` INT NOT NULL AUTO_INCREMENT,
  `dniCliente` INT NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  `especie` VARCHAR(20) NULL,
  `raza` VARCHAR(20) NULL,
  `sexo` TINYINT NOT NULL COMMENT '0 - macho\n1 - hembra',
  `castrado` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idMascota`, `dniCliente`),
  CONSTRAINT `fk_Mascotas_Clientes1`
    FOREIGN KEY (`dniCliente`)
    REFERENCES `Clientes` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Mascotas_Clientes1_idx` ON `Mascotas` (`dniCliente` ASC);


-- -----------------------------------------------------
-- Table `Servicios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Servicios` ;

CREATE TABLE IF NOT EXISTS `Servicios` (
  `nombreServicio` VARCHAR(25) NOT NULL,
  `precio` FLOAT NOT NULL,
  `estado` ENUM('activo', 'no disponible', 'baja') NOT NULL DEFAULT 'activo',
  PRIMARY KEY (`nombreServicio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Salas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Salas` ;

CREATE TABLE IF NOT EXISTS `Salas` (
  `nombreSala` VARCHAR(20) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  `tipo` ENUM('operaciones', 'cuidados y observaciones', 'consulta') NOT NULL,
  PRIMARY KEY (`nombreSala`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Turnos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Turnos` ;

CREATE TABLE IF NOT EXISTS `Turnos` (
  `idTurno` INT NOT NULL AUTO_INCREMENT,
  `dniCliente` INT NOT NULL,
  `idMascota` INT NOT NULL,
  `estado` ENUM('pendiente', 'activo', 'cancelado', 'finalizado') NOT NULL DEFAULT 'pendiente',
  `fechaInicio` DATE NOT NULL,
  `horaInicio` TIME NOT NULL,
  `horaFin` TIME NOT NULL,
  `observaciones` TEXT(300) NULL,
  `nombreSala` VARCHAR(20) NOT NULL,
  `nombreServicio` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idTurno`, `dniCliente`, `idMascota`),
  CONSTRAINT `fk_Turnos_Salas1`
    FOREIGN KEY (`nombreSala`)
    REFERENCES `Salas` (`nombreSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Turnos_Servicios1`
    FOREIGN KEY (`nombreServicio`)
    REFERENCES `Servicios` (`nombreServicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Turnos_Clientes1`
    FOREIGN KEY (`dniCliente`)
    REFERENCES `Clientes` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Turnos_Mascotas1`
    FOREIGN KEY (`idMascota`)
    REFERENCES `Mascotas` (`idMascota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Turnos_Salas1_idx` ON `Turnos` (`nombreSala` ASC);

CREATE INDEX `fk_Turnos_Servicios1_idx` ON `Turnos` (`nombreServicio` ASC);

CREATE INDEX `IX_fechaInicio` ON `Turnos` (`fechaInicio` ASC);

CREATE INDEX `fk_Turnos_Clientes1_idx` ON `Turnos` (`dniCliente` ASC);

CREATE INDEX `fk_Turnos_Mascotas1_idx` ON `Turnos` (`idMascota` ASC);


-- -----------------------------------------------------
-- Table `Chequeos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Chequeos` ;

CREATE TABLE IF NOT EXISTS `Chequeos` (
  `idChequeo` INT NOT NULL,
  `idTurno` INT NOT NULL,
  `dniCliente` INT NOT NULL,
  `idMascota` INT NOT NULL,
  `peso` FLOAT NOT NULL CHECK (`peso` > 0),
  `observaciones` TEXT(300) NULL,
  PRIMARY KEY (`idChequeo`, `idTurno`, `dniCliente`, `idMascota`),
  CONSTRAINT `fk_Chequeos_Turnos1`
    FOREIGN KEY (`idTurno` , `dniCliente` , `idMascota`)
    REFERENCES `Turnos` (`idTurno` , `dniCliente` , `idMascota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Chequeos_Turnos1_idx` ON `Chequeos` (`idTurno` ASC, `dniCliente` ASC, `idMascota` ASC);


-- -----------------------------------------------------
-- Table `VeterinarioAtiendeTurno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VeterinarioAtiendeTurno` ;

CREATE TABLE IF NOT EXISTS `VeterinarioAtiendeTurno` (
  `dniVeterinarios` INT NOT NULL,
  `dniCliente` INT NOT NULL,
  `idTurno` INT NOT NULL,
  `idMascota` INT NOT NULL,
  PRIMARY KEY (`dniVeterinarios`, `dniCliente`, `idTurno`, `idMascota`),
  CONSTRAINT `fk_Veterinarios_has_Turnos_Veterinarios1`
    FOREIGN KEY (`dniVeterinarios`)
    REFERENCES `Veterinarios` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Veterinarios_has_Turnos_Turnos1`
    FOREIGN KEY (`idTurno` , `dniCliente` , `idMascota`)
    REFERENCES `Turnos` (`idTurno` , `dniCliente` , `idMascota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Veterinarios_has_Turnos_Turnos1_idx` ON `VeterinarioAtiendeTurno` (`idTurno` ASC, `dniCliente` ASC, `idMascota` ASC);

CREATE INDEX `fk_Veterinarios_has_Turnos_Veterinarios1_idx` ON `VeterinarioAtiendeTurno` (`dniVeterinarios` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- INSERCIONES

-- PERSONAS

INSERT INTO `Personas` VALUES(25693587, 'Garcia', 'Maria', 'mariagarcia@gmail.com','155456987','Av. Peron 745');
INSERT INTO `Personas` VALUES(26694589, 'Martinez', 'Maria Carmen', 'mariamartinez@gmail.com','154456887','Colon 300');
INSERT INTO `Personas` VALUES(21293456, 'Lopez', 'Josefa', 'josefalopez@gmail.com','155453981','Jujuy 1630');
INSERT INTO `Personas` VALUES(32691594, 'Sanchez', 'Isabel', 'isabelsanchez@gmail.com','155452980','Av. Aconquija 2050');
INSERT INTO `Personas` VALUES(39694587, 'Gonzalez', 'Maria Dolores', 'mariagonzalez@gmail.com','154456380','Peru 852');
INSERT INTO `Personas` VALUES(36698591, 'Gomez', 'Carmen', 'carmengomez@gmail.com','155457972','Las Heras 78');
INSERT INTO `Personas` VALUES(37023484, 'Fernandez', 'Francisca', 'franciscafernandez@gmail.com','155446927','Lobo de la Vega 45');
INSERT INTO `Personas` VALUES(23691564, 'Moreno', 'Maria Pilar', 'mariamoreno@gmail.com','155157988','Magallanes 630');
INSERT INTO `Personas` VALUES(38683687, 'Jimenez', 'Dolores', 'doloresjimenez@gmail.com','155452982','Camino del Peru 508');
INSERT INTO `Personas` VALUES(30640582, 'Perez', 'Maria Jose', 'mariaperez@gmail.com','154457912','Las Piedras 769');
INSERT INTO `Personas` VALUES(37673557, 'Rodriguez', 'Antonia', 'antoniarodriguez@gmail.com','155626980','Av. Solano Vera 1000');
INSERT INTO `Personas` VALUES(40653287, 'Navarro', 'Ana', 'ananavarro@gmail.com','153457988','Entre Rios 639');
INSERT INTO `Personas` VALUES(31473680, 'Ruiz', 'Maria Isabel', 'mariaruiz@gmail.com','155406188','Brasil 745');
INSERT INTO `Personas` VALUES(33663597, 'Diaz', 'Maria Angeles', 'mariadiaz@gmail.com','155856389','Salta 125');
INSERT INTO `Personas` VALUES(38696507, 'Serrano', 'Pilar', 'pilarserrano@gmail.com','155552901','Roca 500');
INSERT INTO `Personas` VALUES(39143567, 'Hernandez', 'Ana Maria', 'anahernandez@gmail.com','155156017','Berutti 1896');
INSERT INTO `Personas` VALUES(40394570, 'Muñoz', 'Lucia', 'luciamuñoz@gmail.com','154456757','Higueritas 1450');
INSERT INTO `Personas` VALUES(33683881, 'Saez', 'Cristina', 'cristinasaez@gmail.com','154456182','Constancio Vigil 1330');
INSERT INTO `Personas` VALUES(22691577, 'Romero', 'Laura', 'lauraromero@gmail.com','155851980','Saaverdra Lamas 1205');
INSERT INTO `Personas` VALUES(27623507, 'Rubio', 'Juana', 'juanarubio@gmail.com','154446789','Lima 50');

INSERT INTO `Personas` VALUES(30117830,'Carlos','Albaca','CarlosAlbaca@gmail.com',2338638,'Apolinario Saravia 219');
INSERT INTO `Personas` VALUES(20117830,'Alfaro','Antonio','AlfaroAntonio@gmail.com',214965691,'12 de Octubre 123');
INSERT INTO `Personas` VALUES(32117830,'Molina','Francisco','MolinaFrancisco@gmail.com',85425112,'24 de Septiembre 300');
INSERT INTO `Personas` VALUES(34117830,'Lozano','Juan','LozanoJuan@gmail.com',16136291,'Colon 200');
INSERT INTO `Personas` VALUES(30317830,'Castillo','Manuel','CastilloManuel@gmail.com',4045187722,'Chiclana 122');
INSERT INTO `Personas` VALUES(30107830,'Picazo','Pedro','PicazoPedro@gmail.com',52795125,'Independencia 400');
INSERT INTO `Personas` VALUES(32317830,'Ortega','Jesus','OrtegaJesus@gmail.com',528356,'Roca 900');
INSERT INTO `Personas` VALUES(40417830,'Morcillo','Angel','MorcilloAngel@gmail.com',9615829,'Salta 345');
INSERT INTO `Personas` VALUES(50717830,'Cano','Miguel','CanoMiguel@gmail.com',4972249,'Jujuy 290');
INSERT INTO `Personas` VALUES(30417831,'Marin','Javier','MarinJavier@gmail.com',0224584,'Paraguay 460');

INSERT INTO `Personas` VALUES(30617830,'Cuenca','David','CuencaDavid@gmail.com',336809,'Cariola 980');
INSERT INTO `Personas` VALUES(60317832,'Garrido','Carlos','GarridoCarlos@gmail.com',94835241,'Sarmiento 765');
INSERT INTO `Personas` VALUES(31617830,'Torres','Alejandro','TorresAlejandro@gmail.com',3174273,'Belgrano 70');
INSERT INTO `Personas` VALUES(70117833,'Corcoles','Rafael','CorcolesRafael@gmail.com',761340313,'Lamadrid 840');
INSERT INTO `Personas` VALUES(30117730,'Gil','Daniel','GilDaniel@gmail.com',631665,'Charcas 30');
INSERT INTO `Personas` VALUES(80117930,'Ortiz','Luis','OrtizLuis@gmail.com',9701898568,'Chubut 324');
INSERT INTO `Personas` VALUES(30117450,'Calero','Pablo','CaleroPablo@gmail.com',767099,'Chaco 90');
INSERT INTO `Personas` VALUES(30117800,'Valero','Joaquin','ValeroJoaquin@gmail.com',547030,'Chacabuco 40');
INSERT INTO `Personas` VALUES(90117820,'Cebrian','Sergio','CebrianSergio@gmail.com',20999814,'Catamarca 45');
INSERT INTO `Personas` VALUES(30117850,'Rodenas','Fernando','RodenasFernando@gmail.com',0724840,'Misiones 64');

-- VETERINARIOS

INSERT INTO `Veterinarios` VALUES(25693587, 1856, 'Medicina interna');
INSERT INTO `Veterinarios` VALUES(26694589, 2035, 'Odontología');
INSERT INTO `Veterinarios` VALUES(21293456, 8963, 'Oncología');
INSERT INTO `Veterinarios` VALUES(32691594, 7630, 'Fisioterapia');
INSERT INTO `Veterinarios` VALUES(39694587, 1204, 'Oftalmología');
INSERT INTO `Veterinarios` VALUES(36698591, 0236,'Neurología');
INSERT INTO `Veterinarios` VALUES(37023484, 7961, 'Traumatología');
INSERT INTO `Veterinarios` VALUES(23691564, 1023,'Anestesia');
INSERT INTO `Veterinarios` VALUES(38683687, 1036, 'Medicina interna');
INSERT INTO `Veterinarios` VALUES(30640582, 8630, 'Fisioterapia');

INSERT INTO `Veterinarios` VALUES(30117830,8081,'Medicina interna');
INSERT INTO `Veterinarios` VALUES(20117830,7823,'Medicina interna');
INSERT INTO `Veterinarios` VALUES(32117830,1324,'Odontología');
INSERT INTO `Veterinarios` VALUES(34117830,5647,'Odontología');
INSERT INTO `Veterinarios` VALUES(30317830,4445,'Oncología');
INSERT INTO `Veterinarios` VALUES(30107830,4776,'Fisioterapia');
INSERT INTO `Veterinarios` VALUES(32317830,4449,'Oftalmología');
INSERT INTO `Veterinarios` VALUES(40417830,8001,'Neurología');
INSERT INTO `Veterinarios` VALUES(50717830,3030,'Traumatología');
INSERT INTO `Veterinarios` VALUES(30417831,2010,'Anestesia');

-- CLIENTES
INSERT INTO `Clientes` VALUES(37673557);
INSERT INTO `Clientes` VALUES(40653287);
INSERT INTO `Clientes` VALUES(31473680);
INSERT INTO `Clientes` VALUES(33663597);
INSERT INTO `Clientes` VALUES(38696507);
INSERT INTO `Clientes` VALUES(39143567);
INSERT INTO `Clientes` VALUES(40394570);
INSERT INTO `Clientes` VALUES(33683881);
INSERT INTO `Clientes` VALUES(22691577);
INSERT INTO `Clientes` VALUES(27623507);

INSERT INTO `Clientes` VALUES(30617830);
INSERT INTO `Clientes` VALUES(60317832);
INSERT INTO `Clientes` VALUES(31617830);
INSERT INTO `Clientes` VALUES(70117833);
INSERT INTO `Clientes` VALUES(30117730);
INSERT INTO `Clientes` VALUES(80117930);
INSERT INTO `Clientes` VALUES(30117450);
INSERT INTO `Clientes` VALUES(30117800);
INSERT INTO `Clientes` VALUES(90117820);
INSERT INTO `Clientes` VALUES(30117850);

-- MASCOTAS

INSERT INTO `Mascotas` VALUES(01,37673557,'2017-04-01','Max','Perro','Mestizo',0,0);
INSERT INTO `Mascotas` VALUES(02,40653287,'2020-03-20','Coco','Perro','Bulldog',0,1);
INSERT INTO `Mascotas` VALUES(03,31473680,'2016-07-05','Bruno', 'Perro','Boxer',0,1);
INSERT INTO `Mascotas` VALUES(04,33663597,'2018-10-02','Luna','Perro','San Bernardo',1,1);
INSERT INTO `Mascotas` VALUES(05,38696507,'2019-12-16','Lola', 'Perro','Rottweiler',1,0);
INSERT INTO `Mascotas` VALUES(06,39143567,'2017-09-25','Luchi','Gato','Calico',1,1);
INSERT INTO `Mascotas` VALUES(07,40394570,'2017-10-27','Lulu','Gato','Bengali',1,0);
INSERT INTO `Mascotas` VALUES(08,33683881,'2019-01-17','Rayitas','Gato','Mestizo',1,0);
INSERT INTO `Mascotas` VALUES(09,22691577,'2021-03-30','Oliver','Gato','Siberiano',0,1);
INSERT INTO `Mascotas` VALUES(10,27623507,'2015-11-29','Milo','Gato','Turco',0,1);

INSERT INTO `Mascotas` VALUES(11,30617830,'2021-01-10','Lola','Perro','Caniche',1,0);
INSERT INTO `Mascotas` VALUES(12,60317832,'2019-12-11','Luna','Gato','Persa',1,0);
INSERT INTO `Mascotas` VALUES(13,31617830,'2008-05-29','Mora','Perro','Caniche',1,0);
INSERT INTO `Mascotas` VALUES(14,70117833,'2016-01-24','Teo','Gato','Persa',0,0);
INSERT INTO `Mascotas` VALUES(15,30117730,'2007-04-14','Nina','Caballo','Frisón',1,1);
INSERT INTO `Mascotas` VALUES(16,80117930,'2007-07-09','Milo','Perro','Bulldog',0,1);
INSERT INTO `Mascotas` VALUES(17,30117450,'2013-02-02','Pancho','Gato','Siamés',0,0);
INSERT INTO `Mascotas` VALUES(18,30117800,'2012-12-16','Mía','Caballo','Pura Sangre Inglés',1,0);
INSERT INTO `Mascotas` VALUES(19,90117820,'2017-08-09','Rocco','Perro','Labrador',0,0);
INSERT INTO `Mascotas` VALUES(20,30117850,'2018-03-03','Ciro','Gato','Siamés',0,1);
INSERT INTO `Mascotas` VALUES(21,37673557,'2022-01-03','Manchita','Gato','Siamés',0,0);

INSERT INTO `Mascotas` VALUES(22,37673557,'2022-01-03','Ramses','Gato','Siamés',0,1);

-- SALAS
INSERT INTO `Salas` VALUES('01',1,'operaciones');
INSERT INTO `Salas` VALUES('02',0,'operaciones');
INSERT INTO `Salas` VALUES('03',1,'cuidados y observaciones');
INSERT INTO `Salas` VALUES('04',1,'consulta');
INSERT INTO `Salas` VALUES('05',0,'consulta');

-- SERVICIOS
INSERT INTO `Servicios` VALUES ('Castracion',1500,'activo');
INSERT INTO `Servicios` VALUES ('Operacion',5000,'no disponible');
INSERT INTO `Servicios` VALUES ('Vacunacion',500,'activo');
INSERT INTO `Servicios` VALUES ('Desparasitacion',250,'activo');
INSERT INTO `Servicios` VALUES ('Consulta',800,'activo');
INSERT INTO `Servicios` VALUES ('Baño',1500,'activo');

-- TURNOS 

INSERT INTO `Turnos` VALUES(01,37673557,01,'pendiente','2022-05-03','08:30','09:15','','01','Castracion');
INSERT INTO `Turnos` VALUES(02,40653287,02,'finalizado','2022-04-02','09:00','10:30','','03','Baño');
INSERT INTO `Turnos` VALUES(03,31473680,03,'finalizado','2022-04-14','11:30','12:00','Decaimiento y falta de animo','04','Consulta');
INSERT INTO `Turnos` VALUES(04,33663597,04,'cancelado','2022-05-03','10:30','10:15','','05','Vacunacion');
INSERT INTO `Turnos` VALUES(05,38696507,05,'activo','2022-04-15','18:30','19:15','','02','Castracion');
INSERT INTO `Turnos` VALUES(06,39143567,06,'activo','2022-04-15','17:00','17:15','','04','Desparasitacion');
INSERT INTO `Turnos` VALUES(07,40394570,07,'pendiente','2022-06-04','18:00','18:15','','05','Vacunacion');
INSERT INTO `Turnos` VALUES(08,33683881,08,'cancelado','2022-07-17','12:00','12:45','','01','Castracion');
INSERT INTO `Turnos` VALUES(09,22691577,09,'pendiente','2022-04-26','19:00','20:30','','04','Baño');
INSERT INTO `Turnos` VALUES(10,27623507,10,'pendiente','2022-04-17','10:00','10:30','vomitos y diarrea','05','Consulta');


INSERT INTO `Turnos` VALUES(11,30617830,11,'pendiente','2022-12-12','10:00','10:45','Se comporta de manera inquieta y trata de escaparce cada vez que abro la puerta','04','Castracion');
INSERT INTO `Turnos` VALUES(12,60317832,12,'finalizado','2021-01-12','08:00','08:15','Solo duerme y casi no come','04','Vacunacion');
INSERT INTO `Turnos` VALUES(13,31617830,13,'pendiente','2022-11-10','12:00','12:45','','05','Castracion');
INSERT INTO `Turnos` VALUES(14,70117833,14,'finalizado','2020-02-20','10:30','11:15','','05','Castracion');
INSERT INTO `Turnos` VALUES(15,30117730,15,'pendiente','2022-10-13','11:30','12:15','','01','Castracion');
INSERT INTO `Turnos` VALUES(16,80117930,16,'finalizado','2019-12-19','13:00','13:15','No quiere comer','05','Vacunacion');
INSERT INTO `Turnos` VALUES(17,30117450,17,'pendiente','2022-10-13','15:00','16:30','','04','Baño');
INSERT INTO `Turnos` VALUES(18,30117800,18,'finalizado','2019-12-19','17:30','18:00','Se comporta de manera agresiva y escupe espuma por el hocico','01','Consulta');
INSERT INTO `Turnos` VALUES(19,90117820,19,'finalizado','2019-12-19','15:30','15:45','-','02','Vacunacion');
INSERT INTO `Turnos` VALUES(20,30117850,20,'cancelado','2022-10-13','12:00','12:30','-','03','Consulta');

INSERT INTO `Turnos` VALUES(21,37673557,01,'pendiente','2022-12-12','11:00','11:45','Se comporta de manera inquieta.','04','Castracion');
INSERT INTO `Turnos` VALUES(22,37673557,01,'finalizado','2021-01-12','09:00','09:15','Solo duerme y casi no come.','04','Vacunacion');
INSERT INTO `Turnos` VALUES(23,37673557,01,'pendiente','2022-11-10','13:00','13:45','','05','Castracion');
INSERT INTO `Turnos` VALUES(24,37673557,01,'finalizado','2020-02-20','11:30','12:15','','05','Castracion');
INSERT INTO `Turnos` VALUES(25,37673557,01,'pendiente','2022-10-13','12:30','13:15','','01','Castracion');

INSERT INTO `Turnos` VALUES(26,37673557,01,'finalizado','2019-11-05','11:00','11:30','Vomitos','05','Consulta');
INSERT INTO `Turnos` VALUES(27,37673557,01,'pendiente','2022-06-11','09:00','10:30','','04','Baño');
INSERT INTO `Turnos` VALUES(28,37673557,01,'cancelado','2022-01-25','10:30','10:45','','05','Desparasitacion');
INSERT INTO `Turnos` VALUES(29,37673557,01,'finalizado','2022-04-20','08:30','08:45','','05','Vacunacion');
INSERT INTO `Turnos` VALUES(30,37673557,01,'finalizado','2022-03-25','09:00','09:30','','05','Consulta');

INSERT INTO `Turnos` VALUES(31,27623507,10,'finalizado','2022-04-17','10:00','10:30','','05','Consulta');
INSERT INTO `Turnos` VALUES(32,27623507,10,'pendiente','2022-05-30','09:00','0915','','05','Desparasitacion');
INSERT INTO `Turnos` VALUES(33,37673557,21,'pendiente','2022-05-30','08:30','08:45','','05','Vacunacion');
INSERT INTO `Turnos` VALUES(34,37673557,21,'pendiente','2022-06-02','17:30','17:45','','04','Desparasitacion');

-- CHEQUEOS

INSERT INTO `Chequeos` VALUES(01,01,37673557,01,22.9,'');
INSERT INTO `Chequeos` VALUES(02,02,40653287,02,15.8,'');
INSERT INTO `Chequeos` VALUES(03,03,31473680,03,25.4,'Se observo afeccion respiratoria');
INSERT INTO `Chequeos` VALUES(04,04,33663597,04,27.2,'');
INSERT INTO `Chequeos` VALUES(05,05,38696507,05,18.6,'');
INSERT INTO `Chequeos` VALUES(06,06,39143567,06,25.8,'');
INSERT INTO `Chequeos` VALUES(07,07,40394570,07,22.3,'');
INSERT INTO `Chequeos` VALUES(08,08,33683881,08,28.3,'');
INSERT INTO `Chequeos` VALUES(09,09,22691577,09,20.7,'');
INSERT INTO `Chequeos` VALUES(10,10,27623507,10,28.3,'');

INSERT INTO `Chequeos` VALUES(11,11,30617830,11,12.9,'');
INSERT INTO `Chequeos` VALUES(12,12,60317832,12,10.1,'Se presento leve reaccion alergica al medicamento suministrado');
INSERT INTO `Chequeos` VALUES(13,13,31617830,13,25.4,'');
INSERT INTO `Chequeos` VALUES(14,14,70117833,14,11.3,'Se debió aplicar una segunda dosis');
INSERT INTO `Chequeos` VALUES(15,15,30117730,15,22.9,'');
INSERT INTO `Chequeos` VALUES(16,16,80117930,16,10.0,'');
INSERT INTO `Chequeos` VALUES(17,17,30117450,17,25.4,'');
INSERT INTO `Chequeos` VALUES(18,18,30117800,18,140.3,'Se constató sintomas compatible con rabia. Se aplicó el tratamiento recomendado y el paciente evolucionó satisfactoriamente');
INSERT INTO `Chequeos` VALUES(19,19,90117820,19,25.4,'');
INSERT INTO `Chequeos` VALUES(20,20,30117850,20,1.3,'');

-- VETERINARIOATIENDETURNO

INSERT INTO `VeterinarioAtiendeTurno` VALUES(25693587,37673557,01,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(26694589,40653287,02,02);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(21293456,31473680,03,03);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(23691564,33663597,04,04);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(23691564,38696507,05,05);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,39143567,06,06);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,40394570,07,07);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(37023484,33683881,08,08);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30640582,22691577,09,09);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30640582,27623507,10,10);

INSERT INTO `VeterinarioAtiendeTurno` VALUES(30117830,30617830,11,11);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(20117830,60317832,12,12);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(32117830,31617830,13,13);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(34117830,70117833,14,14);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30317830,30117730,15,15);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30107830,80117930,16,16);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(32317830,30117450,17,17);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(40417830,30117800,18,18);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(50717830,90117820,19,19);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30417831,30117850,20,20);

INSERT INTO `VeterinarioAtiendeTurno` VALUES(32317830,37673557,21,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,37673557,22,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30640582,37673557,23,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30107830,37673557,24,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(40417830,37673557,25,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(50717830,37673557,26,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(21293456,37673557,27,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(26694589,37673557,28,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(20117830,37673557,29,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30417831,37673557,30,01);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,37673557,33,21);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(50717830,37673557,34,21);


-- Nuevos Turnos para asociarlos con chequeos y nuevos chequeos para dejarlos sin relacion con los turnos

-- Turnos
INSERT INTO `Turnos` VALUES(35,38696507,05,'activo','2022-04-16','18:30','19:15','','02','Castracion');
INSERT INTO `Turnos` VALUES(36,38696507,05,'activo','2022-04-12','17:00','17:15','','04','Desparasitacion');
INSERT INTO `Turnos` VALUES(37,39143567,06,'pendiente','2023-06-04','18:00','18:15','','05','Vacunacion');
INSERT INTO `Turnos` VALUES(38,39143567,06,'cancelado','2002-07-17','12:00','12:45','','01','Castracion');
INSERT INTO `Turnos` VALUES(39,39143567,06,'pendiente','2023-04-26','19:00','20:30','','04','Baño');
INSERT INTO `Turnos` VALUES(40,30117450,17,'pendiente','2023-04-17','10:00','10:30','vomitos y diarrea','05','Consulta');
INSERT INTO `Turnos` VALUES(41,40394570,07,'pendiente','2022-05-03','08:30','09:15','','01','Castracion');
INSERT INTO `Turnos` VALUES(42,40394570,07,'finalizado','2002-04-02','09:00','10:30','','03','Baño');
INSERT INTO `Turnos` VALUES(43,40394570,07,'finalizado','2002-04-14','11:30','12:00','Decaimiento y falta de animo','04','Consulta');
INSERT INTO `Turnos` VALUES(44,40394570,07,'cancelado','2022-05-03','10:30','10:15','','05','Vacunacion');

-- Chequeos Modificados
INSERT INTO `Chequeos` VALUES(16,35,38696507,05,10.0,'');
INSERT INTO `Chequeos` VALUES(16,36,38696507,05,10.0,'');
INSERT INTO `Chequeos` VALUES(17,37,39143567,06,25.4,'');
INSERT INTO `Chequeos` VALUES(17,38,39143567,06,140.3,'Se constató sintomas compatible con rabia. Se aplicó el tratamiento recomendado y el paciente evolucionó satisfactoriamente');
INSERT INTO `Chequeos` VALUES(17,39,39143567,06,25.4,'');
INSERT INTO `Chequeos` VALUES(18,40,30117450,17,1.3,'');
INSERT INTO `Chequeos` VALUES(19,41,40394570,07,1.3,'');
INSERT INTO `Chequeos` VALUES(19,42,40394570,07,1.3,'');
INSERT INTO `Chequeos` VALUES(19,43,40394570,07,1.3,'');
INSERT INTO `Chequeos` VALUES(19,44,40394570,07,1.3,'');



-- VeterinarioAtiendeTurno Nuevos
INSERT INTO `VeterinarioAtiendeTurno` VALUES(25693587,38696507,35,05);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(26694589,38696507,36,05);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(21293456,39143567,37,06);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(23691564,39143567,38,06);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(23691564,39143567,39,06);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,30117450,40,17);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(39694587,40394570,41,07);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(37023484,40394570,42,07);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30640582,40394570,43,07);
INSERT INTO `VeterinarioAtiendeTurno` VALUES(30640582,40394570,44,07);



-- CONSULTAS
/*
Triggers: implementar la lógica para llevar una auditoría para todos los apartados
siguientes de las operaciones de
*/
/*
1. Creación
*/

DROP TABLE IF EXISTS `AuditoriaMascotas` ;

-- Creacion de la tabla auditoria
CREATE TABLE IF NOT EXISTS `AuditoriaMascotas` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `IDMascota` INT NOT NULL,
  `dniCliente` INT NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  `especie` VARCHAR(20)  NOT NULL,
  `raza` VARCHAR(20)  NULL,
  `sexo` TINYINT NOT NULL,  
  `castrado` TINYINT NOT NULL,  
  `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, N: Modificación despues, V: Modificacion antes)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

DROP TRIGGER IF EXISTS Trig_Mascotas_Insercion;

DELIMITER //
CREATE TRIGGER `Trig_Mascotas_Insercion` 
AFTER INSERT ON `Mascotas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaMascotas VALUES (
		DEFAULT, 
		NEW.IDMascota,
		NEW.dniCliente, 
        NEW.fechaNacimiento,
        NEW.nombre,
        NEW.especie,
        NEW.raza,
		NEW.sexo,
        NEW.castrado,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;

-- correcta
/*
CALL NuevaMascota(31473680, 24,'Rita','2022-04-03','Perro','Caniche',1,0, @mensaje); 
SELECT @mensaje; 
*/

SELECT * FROM AuditoriaMascotas;


/*
2. Modificación 
*/

DROP TRIGGER IF EXISTS Trig_Mascotas_Modificacion;

DELIMITER //
CREATE TRIGGER `Trig_Mascotas_Modificacion` 
AFTER UPDATE ON `Mascotas` FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaMascotas VALUES (
		DEFAULT, 
		OLD.IDMascota,
		OLD.dniCliente, 
        OLD.fechaNacimiento,
        OLD.nombre,
        OLD.especie,
        OLD.raza,
		OLD.sexo,
        OLD.castrado,
		'V', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaMascotas VALUES (
		DEFAULT, 
		NEW.IDMascota,
		NEW.dniCliente, 
        NEW.fechaNacimiento,
        NEW.nombre,
        NEW.especie,
        NEW.raza,
		NEW.sexo,
        NEW.castrado,
		'N', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;

/*
CALL ModificarMascota(24,'Mora',NULL,NULL,'Mestizo',NULL,1, @mensaje); 
SELECT @mensaje; 
*/

SELECT * FROM AuditoriaMascotas;

/*
3. Borrado
Se deberá auditar el tipo de operación que se realizó (creación, borrado,
modificación), el usuario que la hizo, la fecha y hora de la operación, la máquina
desde donde se la hizo y todas las información necesaria para la auditoría (en el caso
de las modificaciones, se deberán auditar tanto los valores viejos como los nuevos).*/

DROP TRIGGER IF EXISTS Trig_Mascotas_Borradas;

DELIMITER //
CREATE TRIGGER `Trig_Mascotas_Borradas` 
AFTER DELETE ON `Mascotas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaMascotas VALUES (
		DEFAULT, 
		OLD.IDMascota,
		OLD.dniCliente, 
        OLD.fechaNacimiento,
        OLD.nombre,
        OLD.especie,
        OLD.raza,
		OLD.sexo,
        OLD.castrado,
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END //
DELIMITER ;

/*
DELETE FROM Mascotas WHERE idMascota=24;
*/

SELECT * FROM AuditoriaMascotas;

/*
Procedimientos almacenados: Realizar (lo más eficientemente posible) los siguientes
procedimientos almacenados, incluyendo el control de errores lógicos y mensajes de error:
*/

/*
4. Creación de una mascota.
*/

DROP PROCEDURE IF EXISTS NuevaMascota;

DELIMITER //
CREATE PROCEDURE NuevaMascota(pDni INT, pNombre VARCHAR(20), pNacimiento DATE, pEspecie VARCHAR(20),pRaza VARCHAR(20),pSexo TINYINT, pCastrado TINYINT,OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF (pDni IS NULL OR pDni <= 0) OR (pNombre IS NULL OR pNombre = '') OR (pNacimiento IS NULL) OR (pSexo IS NULL OR pSexo < 0) OR (pCastrado IS NULL OR pCastrado < 0) THEN
		SET mensaje = 'Existe por lo menos un parametro que no fue ingresado.';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT * FROM Clientes WHERE dni = pDni) THEN
		SET mensaje = 'No existe un cliente con ese DNI';
        LEAVE SALIR;
	ELSEIF  (pNacimiento < '1980-01-01') THEN
	SET mensaje = 'La fecha ingresada es demasiada antigua';
	LEAVE SALIR;    
	ELSE
		START TRANSACTION;
			INSERT INTO `Mascotas` (idMascota,dniCliente,fechaNacimiento,nombre,especie,raza,sexo,castrado)VALUES(DEFAULT,pDni,pNacimiento,pNombre,pEspecie,pRaza,pSexo,pCastrado);
            SET mensaje = 'Mascota creada con éxito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- correcta
CALL NuevaMascota(31473680,'Bartolo','2022-05-03','Perro','San Bernardo',0,0, @mensaje); 
SELECT @mensaje; 

-- No se crea la mascota, debido a que no existe un cliente con ese dni
CALL NuevaMascota(77777777,'Luna','2022-04-19','Gata','Angora Turco',1,0, @mensaje); 
SELECT @mensaje; 

-- No se crea la mascota, debido a que no existe un cliente con ese dni, se intenta ingresar una mascota para un veterinario
CALL NuevaMascota(30117830,'Luna','2022-04-19','Gata','Angora Turco',1,0, @mensaje); 
SELECT @mensaje; 

-- No se crea la mascota, debido a que se ingresa una cadena vacia en el nombre
CALL NuevaMascota(70117833,'','2022-04-19','Gata','Angora Turco',1,0, @mensaje); 
SELECT @mensaje; 



/*
5. Modificación de una mascota.
*/

DROP PROCEDURE IF EXISTS ModificarMascota;

DELIMITER //
CREATE PROCEDURE ModificarMascota(pId INT,pNombre VARCHAR(20), pNacimiento DATE, pEspecie VARCHAR(20),pRaza VARCHAR(20),pSexo TINYINT, pCastrado TINYINT,OUT mensaje VARCHAR(100))
SALIR:BEGIN  
	IF (pId IS NULL OR pId <= 0) OR (pNombre IS NULL OR pNombre = '') OR (pNacimiento IS NULL) OR (pSexo IS NULL OR pSexo < 0) OR (pCastrado IS NULL OR pCastrado < 0) THEN
	 SET mensaje = 'Existe por lo menos un parametro que no fue ingresado.';
	 LEAVE SALIR;
	 ELSE
		START TRANSACTION;
			UPDATE Mascotas
            SET fechaNacimiento = pNacimiento, nombre = pNombre, especie = pEspecie, raza = pRaza, sexo = pSexo, castrado = pCastrado
            WHERE idMascota = pId;
            SET mensaje = 'Mascota modificada con éxito';
		COMMIT;		

    END IF;
END //
DELIMITER ;

-- correcta
CALL ModificarMascota (23,'Barto','2022-05-05','Perro','Caniche',0,1,@mensaje); 
SELECT @mensaje; 

-- se ingresaron valores nulos
CALL ModificarMascota (23,NULL,NULL,NULL,'San Bernardo',NULL,NULL,@mensaje); 
SELECT @mensaje; 

 -- se ingresaron valores negativos
CALL ModificarMascota (-23,'Barto','2022-05-05','Perro','Caniche',0,1,@mensaje); 
SELECT @mensaje; 

-- no hay datos a modificar, ya que solo hay un espacio
CALL ModificarMascota (23,NULL,NULL,' ',NULL,NULL,NULL,@mensaje); 
SELECT @mensaje;


/*
6. Borrado de una mascota.
*/

DROP PROCEDURE IF EXISTS BorradoMascota;

DELIMITER //
CREATE PROCEDURE BorradoMascota(pId INT, OUT mensaje VARCHAR(100))
SALIR: BEGIN
  IF (pId IS NULL OR pId < 0) THEN
  SET mensaje = 'No se ingreso un ID valido';
  LEAVE SALIR;
  ELSEIF NOT EXISTS (SELECT * FROM Mascotas WHERE idMascota = pId) THEN
  SET mensaje = 'No existe la mascota';
  LEAVE SALIR;
  
  ELSEIF EXISTS (SELECT * FROM Turnos WHERE Turnos.idMascota = pId) THEN
    SET mensaje = 'Existe un turno asociado a la mascota';
    LEAVE SALIR;
  ELSE 
    DELETE FROM Mascotas WHERE idMascota = pId;
    SET mensaje = 'Se borro con exito la mascota';
  END IF;
END //
DELIMITER ;





-- correcta
CALL BorradoMascota(22,@mensaje);
SELECT @mensaje;

-- Error: la mascota tiene asociado un turno
CALL BorradoMascota(5,@mensaje);
SELECT @mensaje;

-- Error: no se existe una mascota con ese id
CALL BorradoMascota(100,@mensaje);
SELECT @mensaje;

-- Error: se ingreso null como id 
CALL BorradoMascota(NULL,@mensaje);
SELECT @mensaje;

-- Error: se ingreso id negativo
CALL BorradoMascota(-20,@mensaje);
SELECT @mensaje;


/*
7. Búsqueda de una mascota.
*/

DROP PROCEDURE IF EXISTS BuscarMascota;

DELIMITER //
CREATE PROCEDURE BuscarMascota(pDni INT, pNombre VARCHAR (20))
BEGIN
    SELECT Mascotas.idMascota AS 'ID Mascota',
    Mascotas.nombre AS 'Mascota',
    Mascotas.fechaNacimiento AS 'Fecha de Nacimiento',
    Mascotas.especie AS Especie,
    Mascotas.raza AS Raza,
    Mascotas.sexo AS Sexo,
    Mascotas.castrado AS Castrado
    FROM Mascotas 
    WHERE (Mascotas.dniCliente = pDni AND Mascotas.nombre = pNombre) OR (ISNULL(pNombre) AND ISNULL(pDni)) OR (ISNULL(pDni) AND Mascotas.nombre = pNombre) OR (ISNULL(pNombre) AND Mascotas.dniCliente = pDni)
	ORDER BY nombre ASC;
END //
DELIMITER ;


-- correcto
CALL BuscarMascota (37673557,'Manchita');

-- correcto: Muestra una mascota en especifico
CALL BuscarMascota (37673557,'Max');

-- Correcto: Muestra todas las mascotas con ese nombre
CALL BuscarMascota (NULL,'Max');

-- Correcto: Muestra todas las mascotas de todos los clientes
CALL BuscarMascota (NULL,NULL);

-- Correcto: Muestra todas las mascotas de ese cliente
CALL BuscarMascota (37673557,NULL);

-- Error: Se ingresa una cadena vacia para el nombre de la mascota
CALL BuscarMascota (37673557,'');

-- Error: El dni no esta registrado como cliente
CALL BuscarMascota (25693587,'Max');



/*
8. Listado de mascotas, ordenados por el criterio que considere más adecuado.
*/

DROP PROCEDURE IF EXISTS ListarMascotas;

DELIMITER //
CREATE PROCEDURE ListarMascotas()
BEGIN
   CALL BuscarMascota (NULL,NULL);
END //
DELIMITER ;

CALL ListarMascotas;

/*
9. Dado un veterinario y un rango de fechas, mostrar todas sus turnos ya finalizados
con sus respectivos chequeos, en ese rango, ordenadas cronológicamente.
*/

DROP PROCEDURE IF EXISTS TurnosVeterinario;

DELIMITER //
CREATE PROCEDURE TurnosVeterinario(pDni INT, pFechaDesde DATE, pFechaHasta DATE, OUT Mensaje VARCHAR(100))
SALIR:BEGIN
	DECLARE fechaAux DATE;
    IF (pDni IS NULL OR pDni <= 0) OR (pFechaDesde IS NULL) OR (pFechaHasta IS NULL) THEN
		SET mensaje = 'Existe por lo menos un parametro que no fue ingresado.';
        LEAVE SALIR;
    ELSEIF pFechaDesde > pFechaHasta THEN -- se invierten las fechas
		SET fechaAux = pFechaDesde;
        SET pFechaDesde = pFechaHasta;
        SET pFechaHasta = fechaAux;
    END IF;
    SELECT Turnos.idTurno AS 'ID Turno', 
    Turnos.dniCliente AS 'DNI Cliente', 
    Turnos.idMascota AS 'ID Mascota',
    Turnos.estado AS Estado, 
    Turnos.fechaInicio AS Fecha, 
    Turnos.horaInicio AS Hora, 
    Turnos.observaciones AS 'Observaciones del Cliente',
    Turnos.nombreSala AS Sala, 
    Turnos.nombreServicio AS 'Tipo de Atencion',
    Chequeos.idChequeo AS 'ID Chequeo',
    Chequeos.peso AS Peso,
    Chequeos.observaciones AS 'Observaciones del Veterinario'
    FROM Chequeos JOIN Turnos
	ON Turnos.idTurno = Chequeos.idTurno 
    AND Turnos.idMascota = Chequeos.idMascota 
    AND Turnos.dniCliente = Chequeos.dniCliente
    JOIN  VeterinarioAtiendeTurno
	ON Turnos.dniCliente = VeterinarioAtiendeTurno.dniCliente 
    AND Turnos.idTurno = VeterinarioAtiendeTurno.idTurno 
    AND Turnos.idMascota = VeterinarioAtiendeTurno.idMascota 
    WHERE DATE(fechaInicio) BETWEEN pFechaDesde AND pFechaHasta
    AND VeterinarioAtiendeTurno.dniVeterinarios = pDni 
    AND Turnos.estado = 'finalizado'
	ORDER BY Turnos.fechaInicio ASC,Turnos.horaInicio ASC;
END //
DELIMITER ;

-- correcto
CALL TurnosVeterinario(37023484,'2000-01-01','2025-01-01',@mensaje); 
SELECT @mensaje;

-- no se muestra debido a que falta dni de veterinario
CALL TurnosVeterinario(NULL,'2000-01-01','2025-01-01',@mensaje); 
SELECT @mensaje;

-- no se muestra debido a que dni de veterinario es cero
CALL TurnosVeterinario(0,'2000-01-01','2025-01-01',@mensaje); 
SELECT @mensaje;

-- no se muestra debido a que no se ingreso fecha desde
CALL TurnosVeterinario(37023484,NULL,'2025-01-01',@mensaje); 
SELECT @mensaje;

-- correcto: se agrego el chequeo que faltaba en el turno numero 29

INSERT INTO `Chequeos` VALUES(20,29,37673557,01,1.3,'');

CALL TurnosVeterinario(20117830,'2000-01-01','2025-01-01',@mensaje); 
SELECT @mensaje;


/*
10. Realizar un procedimiento almacenado con alguna funcionalidad que considere
de interés.
*/

/*Dado un cliente, crear un procedimiento donde se muestren todos los turnos de todas sus mascotas en un rango de fechas. 
Mostrar nombre de la mascota, fecha y hora del turno, estado del turno, el nombre de la sala,
la atencion que recibira y los datos del veterinario. Ordenar según la fecha en orden cronológico inverso.
*/

DROP PROCEDURE IF EXISTS TurnosMascotas;

DELIMITER //
CREATE PROCEDURE TurnosMascotas(pDni INT, pFechaDesde DATE, pFechaHasta DATE, OUT mensaje VARCHAR(100))
SALIR:BEGIN
	DECLARE fechaAux DATE;
    IF (pDni IS NULL OR pDni <= 0) OR (pFechaDesde IS NULL) OR (pFechaHasta IS NULL) THEN
		SET mensaje = 'Existe por lo menos un parametro que no fue ingresado.';
        LEAVE SALIR;
	END IF;
    IF pFechaDesde > pFechaHasta THEN -- se invierten las fechas
		SET fechaAux = pFechaDesde;
        SET pFechaDesde = pFechaHasta;
        SET pFechaHasta = fechaAux;
    END IF;
    SELECT Mascotas.nombre, Turnos.fechaInicio, Turnos.horaInicio, 
		 Turnos.estado, Turnos.nombreSala, Turnos.nombreServicio, Personas.apellido, Personas.nombre
		 FROM Clientes JOIN Mascotas
		 ON Clientes.dni = Mascotas.dniCliente
		 JOIN Turnos
		 ON Mascotas.idMascota = Turnos.idMascota AND Mascotas.dniCliente = Turnos.dniCliente 
		 JOIN VeterinarioAtiendeTurno
		 ON Turnos.idTurno = VeterinarioAtiendeTurno.idTurno AND Turnos.dniCliente = VeterinarioAtiendeTurno.dniCliente AND Turnos.idMascota = VeterinarioAtiendeTurno.idMascota
		 JOIN Veterinarios
		 ON VeterinarioAtiendeTurno.dniVeterinarios = Veterinarios.dni
		 JOIN Personas
		 ON Veterinarios.dni = Personas.dni
		 WHERE (DATE(fechaInicio) BETWEEN pFechaDesde AND pFechaHasta) 
         AND Clientes.dni = pDni
		 ORDER BY fechaInicio DESC,horaInicio ASC;    
END //
DELIMITER ;

-- correcto
CALL TurnosMascotas (37673557,'2002-01-01','2022-12-01',@mensaje);
SELECT @mensaje;

-- no muestra, falta dni del veterinario
CALL TurnosMascotas (NULL,'2002-01-01','2022-12-01',@mensaje); 
SELECT @mensaje;

-- no muestra, falta fecha desde
CALL TurnosMascotas (37673557,NULL,'2022-12-01',@mensaje); 
SELECT @mensaje;

-- no muestra, falta fecha hasta
CALL TurnosMascotas (37673557,'2002-01-01',NULL,@mensaje); 
SELECT @mensaje;


/*
11. Incluir las sentencias de llamada a los procedimientos. Para cada uno hacer 4
llamadas (una con salida correcta y las otras 3 con diferentes errores explicando su
intención en un comentario).
*/



