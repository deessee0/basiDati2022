-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema myplanes2022
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `myplanes2022` ;

-- -----------------------------------------------------
-- Schema myplanes2022
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `myplanes2022` DEFAULT CHARACTER SET utf8 ;
USE `myplanes2022` ;

-- -----------------------------------------------------
-- Table `myplanes2022`.`compagnia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`compagnia` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`compagnia` (
  `idCompagnia` VARCHAR(45) NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `telefono` DOUBLE NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCompagnia`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`aereo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`aereo` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`aereo` (
  `idAereo` INT NOT NULL AUTO_INCREMENT,
  `sigla` VARCHAR(45) NOT NULL,
  `posti` VARCHAR(4) NOT NULL,
  `produttore` VARCHAR(45) NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAereo`),
  UNIQUE INDEX `idAereo_UNIQUE` (`idAereo` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  CONSTRAINT `idCompagniaAereo`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `myplanes2022`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`aereoporto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`aereoporto` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`aereoporto` (
  `idAereoporto` VARCHAR(3) NOT NULL,
  `nazione` VARCHAR(45) NOT NULL,
  `regione` VARCHAR(45) NOT NULL,
  `coordinate` GEOMETRY NULL DEFAULT NULL,
  PRIMARY KEY (`idAereoporto`),
  UNIQUE INDEX `idAereoporto_UNIQUE` (`idAereoporto` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`passeggero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`passeggero` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`passeggero` (
  `idPasseggero` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `telefono` DOUBLE NOT NULL,
  `dataNascita` DATE NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `passaporto` MEDIUMBLOB NULL DEFAULT NULL,
  `sesso` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`idPasseggero`),
  UNIQUE INDEX `cf_UNIQUE` (`idPasseggero` ASC) VISIBLE,
  UNIQUE INDEX `password_UNIQUE` (`password` ASC) VISIBLE,
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`tratta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`tratta` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`tratta` (
  `idTratta` INT NOT NULL AUTO_INCREMENT,
  `idAereoportoPartenza` VARCHAR(5) NOT NULL,
  `idAereoportoArrivo` VARCHAR(5) NOT NULL,
  `idAereo` INT NOT NULL,
  `ritardo` TIME NULL DEFAULT NULL,
  `cancellata` TINYINT NULL DEFAULT '0',
  PRIMARY KEY (`idTratta`),
  INDEX `idAereoportoPartenza_idx` (`idAereoportoPartenza` ASC) VISIBLE,
  INDEX `idAereoportoArrivo_idx` (`idAereoportoArrivo` ASC) VISIBLE,
  INDEX `idAereo_idx` (`idAereo` ASC) VISIBLE,
  CONSTRAINT `idAereoportoArrivoTratta`
    FOREIGN KEY (`idAereoportoArrivo`)
    REFERENCES `myplanes2022`.`aereoporto` (`idAereoporto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idAereoportoPartenzaTratta`
    FOREIGN KEY (`idAereoportoPartenza`)
    REFERENCES `myplanes2022`.`aereoporto` (`idAereoporto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idAereoTratta`
    FOREIGN KEY (`idAereo`)
    REFERENCES `myplanes2022`.`aereo` (`idAereo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`biglietto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`biglietto` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`biglietto` (
  `idBiglietto` INT NOT NULL AUTO_INCREMENT,
  `check_in` TINYINT NOT NULL DEFAULT '0',
  `prezzo` INT NOT NULL,
  `classe` VARCHAR(25) NOT NULL,
  `posto` VARCHAR(3) NOT NULL,
  `dataAcquisto` DATETIME NOT NULL,
  `assicurazione` TINYINT NULL DEFAULT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  `idPasseggero` VARCHAR(45) NOT NULL,
  `idTratta` INT NOT NULL,
  PRIMARY KEY (`idBiglietto`),
  UNIQUE INDEX `idBiglietto_UNIQUE` (`idBiglietto` ASC) VISIBLE,
  INDEX `idTratta_idx` (`idTratta` ASC) VISIBLE,
  INDEX `idPasseggero_idx` (`idPasseggero` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  CONSTRAINT `idCompagniaBiglietto`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `myplanes2022`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idPasseggeroBiglietto`
    FOREIGN KEY (`idPasseggero`)
    REFERENCES `myplanes2022`.`passeggero` (`idPasseggero`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idTrattaBiglietto`
    FOREIGN KEY (`idTratta`)
    REFERENCES `myplanes2022`.`tratta` (`idTratta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`ruolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`ruolo` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`ruolo` (
  `idRuolo` VARCHAR(100) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descrizione` VARCHAR(45) NOT NULL,
  `ral` DOUBLE NOT NULL,
  `idReferente` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`idRuolo`),
  UNIQUE INDEX `idReferente_UNIQUE` (`idReferente` ASC) VISIBLE,
  UNIQUE INDEX `idRuolo_UNIQUE` (`idRuolo` ASC) VISIBLE,
  CONSTRAINT `idReferentePersonale`
    FOREIGN KEY (`idReferente`)
    REFERENCES `myplanes2022`.`personale` (`idPersonale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`personale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`personale` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`personale` (
  `idPersonale` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `telefono` DOUBLE NOT NULL,
  `sesso` TINYINT NULL DEFAULT NULL,
  `idCompagnia` VARCHAR(45) NOT NULL,
  `idRuolo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idPersonale`),
  UNIQUE INDEX `password_UNIQUE` (`password` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  INDEX `idRuoloPersonale_idx` (`idRuolo` ASC) VISIBLE,
  CONSTRAINT `idCompagniaPersonale`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `myplanes2022`.`compagnia` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idRuoloPersonale`
    FOREIGN KEY (`idRuolo`)
    REFERENCES `myplanes2022`.`ruolo` (`idRuolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `myplanes2022`.`turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myplanes2022`.`turno` ;

CREATE TABLE IF NOT EXISTS `myplanes2022`.`turno` (
  `idPersonale` VARCHAR(16) NOT NULL,
  `idAereo` INT NOT NULL,
  `inizioTurno` DATETIME(6) NOT NULL,
  `fineTurno` DATETIME(6) NOT NULL,
  PRIMARY KEY (`idPersonale`, `idAereo`),
  INDEX `idAereo_idx` (`idAereo` ASC) VISIBLE,
  CONSTRAINT `idAereoTurno`
    FOREIGN KEY (`idAereo`)
    REFERENCES `myplanes2022`.`aereo` (`idAereo`),
  CONSTRAINT `idPersonaleTurno`
    FOREIGN KEY (`idPersonale`)
    REFERENCES `myplanes2022`.`personale` (`idPersonale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
