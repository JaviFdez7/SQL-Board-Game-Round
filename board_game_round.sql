-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.6.4-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para board_game_round
CREATE DATABASE IF NOT EXISTS `board_game_round` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `board_game_round`;

-- Volcando estructura para tabla board_game_round.compras
CREATE TABLE IF NOT EXISTS `compras` (
  `compraId` int(11) NOT NULL AUTO_INCREMENT,
  `nombreJuego` varchar(30) NOT NULL,
  `precio` double NOT NULL,
  `fechaVent` date NOT NULL DEFAULT current_timestamp(),
  `descuento` double DEFAULT NULL,
  `usuarioId` int(11) NOT NULL,
  PRIMARY KEY (`compraId`),
  KEY `fk_id_usuario2` (`usuarioId`),
  CONSTRAINT `fk_id_usuario2` FOREIGN KEY (`usuarioId`) REFERENCES `usuarios` (`usuarioId`),
  CONSTRAINT `descuento_max` CHECK (0.5 > `descuento` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.compras: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
INSERT INTO `compras` (`compraId`, `nombreJuego`, `precio`, `fechaVent`, `descuento`, `usuarioId`) VALUES
	(1, 'Monopoly', 20, '2021-12-09', 0, 1),
	(2, 'Cluedo', 40.5, '2021-11-28', 0, 1),
	(3, 'Oca', 10, '2021-12-05', 0, 3),
	(4, 'Cluedo', 40.5, '2021-10-12', 0, 2);
/*!40000 ALTER TABLE `compras` ENABLE KEYS */;

-- Volcando estructura para tabla board_game_round.historial_depreciaciones
CREATE TABLE IF NOT EXISTS `historial_depreciaciones` (
  `depreciacionId` int(11) NOT NULL AUTO_INCREMENT,
  `fechaUlt` date DEFAULT NULL,
  `ratioDep` double DEFAULT NULL,
  `productoId` int(11) NOT NULL,
  PRIMARY KEY (`depreciacionId`),
  KEY `fk_id_producto` (`productoId`),
  CONSTRAINT `fk_id_producto` FOREIGN KEY (`productoId`) REFERENCES `productos` (`productoId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.historial_depreciaciones: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `historial_depreciaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_depreciaciones` ENABLE KEYS */;

-- Volcando estructura para tabla board_game_round.interacciones
CREATE TABLE IF NOT EXISTS `interacciones` (
  `interaccionesId` int(11) NOT NULL AUTO_INCREMENT,
  `coment` varchar(500) DEFAULT NULL,
  `puntuación` double NOT NULL,
  `usuarioId` int(11) NOT NULL,
  `juegoId` int(11) NOT NULL,
  PRIMARY KEY (`interaccionesId`),
  KEY `fk_id_usuario` (`usuarioId`),
  KEY `fk_id_juego` (`juegoId`),
  CONSTRAINT `fk_id_juego` FOREIGN KEY (`juegoId`) REFERENCES `juegos` (`juegoId`),
  CONSTRAINT `fk_id_usuario` FOREIGN KEY (`usuarioId`) REFERENCES `usuarios` (`usuarioId`),
  CONSTRAINT `limite_comentario` CHECK (char_length(`coment`) <= 500),
  CONSTRAINT `intervalo_puntuación` CHECK (`puntuación` >= 0 and `puntuación` <= 5)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.interacciones: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `interacciones` DISABLE KEYS */;
INSERT INTO `interacciones` (`interaccionesId`, `coment`, `puntuación`, `usuarioId`, `juegoId`) VALUES
	(1, 'Estuvo chido', 3.4, 1, 1),
	(2, 'Estuvo chido', 4.5, 3, 2),
	(3, 'Estuvo chido', 2.1, 2, 3);
/*!40000 ALTER TABLE `interacciones` ENABLE KEYS */;

-- Volcando estructura para tabla board_game_round.juegos
CREATE TABLE IF NOT EXISTS `juegos` (
  `juegoId` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(30) NOT NULL,
  `autor` varchar(30) NOT NULL,
  `categoria` enum('Familiar','Estrategia','Infantil','Eurogame','Narrativo') DEFAULT NULL,
  `numJug` varchar(30) NOT NULL,
  `tiemJuego` varchar(30) NOT NULL,
  `editorial` varchar(30) NOT NULL,
  `contenido` varchar(100) DEFAULT NULL,
  `estado` enum('conStock','agotado','stockBajos') NOT NULL,
  `puntuacion` double DEFAULT 0,
  `fechaLanz` date NOT NULL,
  PRIMARY KEY (`juegoId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.juegos: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `juegos` DISABLE KEYS */;
INSERT INTO `juegos` (`juegoId`, `titulo`, `autor`, `categoria`, `numJug`, `tiemJuego`, `editorial`, `contenido`, `estado`, `puntuacion`, `fechaLanz`) VALUES
	(1, 'Oca', 'Maurice Ravel', 'Familiar', '4 jugadores', '5-20 minutos', 'aldearac', 'dados, cubos, fichas', 'conStock', 9.3, '2020-09-10'),
	(2, 'Monopoly', 'Elizabeth Magie', 'Familiar', '8 jugadores', '60 minutos', 'Hasbro', NULL, 'stockBajos', 8.5, '1935-11-05'),
	(3, 'Cluedo', 'Lledo', 'Estrategia', '2-6 jugadores', '120 minutos', 'Hasbro', NULL, 'conStock', 7.5, '1948-08-07');
/*!40000 ALTER TABLE `juegos` ENABLE KEYS */;

-- Volcando estructura para tabla board_game_round.productos
CREATE TABLE IF NOT EXISTS `productos` (
  `productoId` int(11) NOT NULL AUTO_INCREMENT,
  `codigoEAN` varchar(13) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `compraId` int(11) NOT NULL,
  `juegoId` int(11) NOT NULL,
  PRIMARY KEY (`productoId`),
  KEY `fk_id_compra` (`compraId`),
  KEY `fk_id_juego2` (`juegoId`),
  CONSTRAINT `fk_id_compra` FOREIGN KEY (`compraId`) REFERENCES `compras` (`compraId`),
  CONSTRAINT `fk_id_juego2` FOREIGN KEY (`juegoId`) REFERENCES `juegos` (`juegoId`),
  CONSTRAINT `códigoEAN_correcto` CHECK (char_length(`codigoEAN`) = 13),
  CONSTRAINT `stock_positivo` CHECK (`stock` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.productos: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` (`productoId`, `codigoEAN`, `stock`, `compraId`, `juegoId`) VALUES
	(1, '8491029481023', 18, 1, 1),
	(2, '3415634298181', 4, 3, 2),
	(3, '0491021281023', 10, 2, 3),
	(4, '0491021281023', 9, 4, 3);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;

-- Volcando estructura para tabla board_game_round.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `usuarioId` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `apellido` varchar(70) NOT NULL,
  `nomUsu` varchar(15) NOT NULL,
  `dni` char(9) NOT NULL,
  `email` varchar(64) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `edad` int(11) NOT NULL,
  `pass` varchar(20) NOT NULL,
  `fichas` int(11) DEFAULT 0,
  PRIMARY KEY (`usuarioId`),
  UNIQUE KEY `nomUsu` (`nomUsu`,`dni`,`email`),
  CONSTRAINT `limite_edad` CHECK (`edad` > 13),
  CONSTRAINT `limite_fichas` CHECK (`fichas` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla board_game_round.usuarios: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` (`usuarioId`, `nombre`, `apellido`, `nomUsu`, `dni`, `email`, `direccion`, `edad`, `pass`, `fichas`) VALUES
	(1, 'Manu', 'Fernández', 'ManFer', '24918420P', 'ManFer@gmail.com', 'Av Andalucia', 21, 'puertas90', 240),
	(2, 'Rafael', 'González', 'RaGon', '31556098I', 'RaGon@gmail.com', 'Av Escapulario', 45, 'mansui89', 10),
	(3, 'Javier', 'García', 'JaGar', '93791009R', 'JaGar@gmail.com', 'Av Luis Montoto', 20, 'genopl13', 100);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;

-- Volcando estructura para procedimiento board_game_round.clientes_mas_frecuentes
DELIMITER //
CREATE PROCEDURE `clientes_mas_frecuentes`()
BEGIN 
		SELECT nomUsu,  COUNT(usuarioId) pedidos_realizados
		FROM compras c NATURAL JOIN usuarios u
		GROUP BY nomUsu ORDER BY pedidos_realizados DESC;
	END//
DELIMITER ;

-- Volcando estructura para procedimiento board_game_round.pedidos_usuario
DELIMITER //
CREATE PROCEDURE `pedidos_usuario`()
BEGIN 
		SELECT nomUsu,  nombreJuego, precio, fechaVent, descuento
		FROM compras c NATURAL JOIN usuarios u
		WHERE c.usuarioId=u.usuarioId;
	END//
DELIMITER ;

-- Volcando estructura para procedimiento board_game_round.ranking_puntuacion_juegos
DELIMITER //
CREATE PROCEDURE `ranking_puntuacion_juegos`()
BEGIN 
		SELECT titulo, puntuacion
		FROM juegos ORDER BY puntuacion DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento board_game_round.ranking_ventas
DELIMITER //
CREATE PROCEDURE `ranking_ventas`()
BEGIN 
		SELECT nombreJuego, count(juegoId) ventas
		FROM productos NATURAL JOIN compras
		GROUP BY juegoId ORDER BY ventas DESC;
	END//
DELIMITER ;

-- Volcando estructura para procedimiento board_game_round.reposicion_stock
DELIMITER //
CREATE PROCEDURE `reposicion_stock`(juego VARCHAR(30), n INT)
BEGIN
		UPDATE productos p JOIN compras c 
		ON p.compraId = c.compraId
		SET stock=n 
		WHERE c.nombreJuego=juego;
	END//
DELIMITER ;

-- Volcando estructura para procedimiento board_game_round.venta_dia2
DELIMITER //
CREATE PROCEDURE `venta_dia2`(d DATE)
BEGIN
		SELECT nombreJuego, fechaVent, COUNT(nombreJuego) cantidad
		FROM compras
		WHERE(compras.fechaVent = d) GROUP BY nombreJuego;
	END//
DELIMITER ;

-- Volcando estructura para función board_game_round.ingresos_intervalo
DELIMITER //
CREATE FUNCTION `ingresos_intervalo`(fi DATE, ff DATE) RETURNS double
BEGIN
		RETURN (SELECT SUM(precio) ingresos
		FROM compras
		WHERE(compras.fechaVent BETWEEN fi AND ff));
	END//
DELIMITER ;

-- Volcando estructura para función board_game_round.stock_juego
DELIMITER //
CREATE FUNCTION `stock_juego`(juego VARCHAR(30)) RETURNS int(11)
BEGIN
		RETURN (SELECT MIN(stock) stock
		FROM productos NATURAL JOIN compras
		WHERE(compras.nombreJuego = juego));
	END//
DELIMITER ;

-- Volcando estructura para función board_game_round.ventas_juego_intervalo
DELIMITER //
CREATE FUNCTION `ventas_juego_intervalo`(fi DATE, ff DATE, nombre VARCHAR(80)) RETURNS int(11)
BEGIN
		RETURN (SELECT count(nombre) ventas
		FROM compras
		WHERE compras.nombreJuego=nombre AND (compras.fechaVent BETWEEN fi AND ff));
	END//
DELIMITER ;

-- Volcando estructura para disparador board_game_round.estado_agotado
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER estado_agotado
	AFTER UPDATE ON productos
	FOR EACH ROW
	BEGIN
		UPDATE juegos NATURAL JOIN productos
		SET juegos.estado = 'agotado'
		WHERE productos.stock=0
AND productos.juegoId=juegos.juegoId;
	END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador board_game_round.estado_constock
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER estado_constock
	AFTER UPDATE ON productos
	FOR EACH ROW
	BEGIN
		UPDATE juegos NATURAL JOIN productos
		SET juegos.estado = 'conStock'
		WHERE productos.stock>5
AND productos.juegoId=juegos.juegoId;
	END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador board_game_round.estado_stockbajo
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER estado_stockbajo
	AFTER UPDATE ON productos
	FOR EACH ROW
	BEGIN
		UPDATE juegos NATURAL JOIN productos
		SET juegos.estado = 'stockBajos'
		WHERE productos.stock BETWEEN 1 AND 5
AND productos.juegoId=juegos.juegoId;		
	END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador board_game_round.sistema_puntuacion_compras
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER sistema_puntuacion_compras
AFTER INSERT ON compras
FOR EACH ROW
	UPDATE usuarios u NATURAL JOIN compras c
	SET u.fichas = (SELECT  (3*(SELECT precio FROM compras order by compraId desc LIMIT 1)+ 
			(SELECT fichas FROM usuarios natural JOIN compras  WHERE 
			(SELECT usuarioId FROM compras order by compraId desc LIMIT 1)=compras.usuarioId LIMIT 1))
			FROM usuarios NATURAL JOIN compras GROUP BY usuarioId order by compraId DESC LIMIT 1)
	WHERE (SELECT usuarioId FROM compras ORDER BY compraId DESC LIMIT 1)=c.usuarioId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador board_game_round.sistema_puntuacion_interacciones
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER sistema_puntuacion_interacciones
AFTER INSERT ON interacciones
FOR EACH ROW
	UPDATE usuarios u NATURAL JOIN interacciones i
	SET u.fichas = (SELECT  (1 + (SELECT fichas FROM usuarios NATURAL JOIN interacciones  
						WHERE (SELECT usuarioId FROM interacciones ORDER BY interaccionesId DESC LIMIT 1)=
						interacciones.usuarioId LIMIT 1)) FROM usuarios NATURAL JOIN interacciones 
						GROUP BY usuarioId ORDER BY interaccionesId DESC LIMIT 1)
	WHERE (SELECT usuarioId FROM interacciones ORDER BY interaccionesId DESC LIMIT 1)=i.usuarioId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
