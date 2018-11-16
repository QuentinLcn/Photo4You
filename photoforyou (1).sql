-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  ven. 16 nov. 2018 à 12:59
-- Version du serveur :  5.7.19
-- Version de PHP :  5.6.31

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `photoforyou`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `moyenneCredits`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `moyenneCredits` ()  BEGIN
declare valeur float;
Select avg(credits) into valeur
from users
where type = 1;

insert into logs values(date(now()), 'Moyenne crédit photographe', valeur);
END$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `InitCap`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InitCap` (`prenom` VARCHAR(30)) RETURNS VARCHAR(30) CHARSET latin1 BEGIN
declare lettre varchar(1);
declare reste varchar(20);
set lettre = upper(substr(prenom,1,1));
set reste = lower(substr(prenom,2));
set prenom = concat(lettre,reste);
RETURN prenom;
END$$

DROP FUNCTION IF EXISTS `nbPhoto`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `nbPhoto` (`id` INT) RETURNS INT(11) BEGIN

declare qui int;
declare nbPhoto int;

select type into qui from users where id_user = id ;
IF (qui = 0) THEN
	return -1;
ELSE
	select count(*) into nbPhoto from photos where id_user = id;
END IF;
Return nbPhoto;

END$$

DROP FUNCTION IF EXISTS `sansCredit`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `sansCredit` (`v_type` INT(1)) RETURNS INT(11) BEGIN
DECLARE nbClient int;
SELECT COUNT(*) into nbClient
FROM users 
where credits = 0
and type = v_type;
RETURN nbClient;
END$$

DROP FUNCTION IF EXISTS `total_poids`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `total_poids` () RETURNS INT(11) BEGIN

declare total INT default 0;
declare poid INT;
declare fin tinyint default 0;

declare curs_poids cursor for
SELECT poids 
FROM photos;

declare continue handler for not found set fin = 1;

OPEN curs_poids;

loop_curseur : loop
	FETCH curs_poids INTO poid;
		IF fin = 1 THEN
			leave loop_curseur;
		END IF;
        SET total = total + poid ;
END loop ;

close curs_poids;	

RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `date` date NOT NULL,
  `champs` varchar(255) NOT NULL,
  `valeur` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `logs`
--

INSERT INTO `logs` (`date`, `champs`, `valeur`) VALUES
('2018-11-09', 'Moyenne crédit photographe', 4),
('2018-11-09', 'Moyenne crédit photographe', 4),
('2018-11-15', 'Moyenne crédit photographe', 4);

-- --------------------------------------------------------

--
-- Structure de la table `menu`
--

DROP TABLE IF EXISTS `menu`;
CREATE TABLE IF NOT EXISTS `menu` (
  `idMenu` int(11) NOT NULL AUTO_INCREMENT,
  `nomMenu` varchar(255) NOT NULL,
  `lien` varchar(255) NOT NULL,
  PRIMARY KEY (`idMenu`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `menu`
--

INSERT INTO `menu` (`idMenu`, `nomMenu`, `lien`) VALUES
(1, 'Acheter des crédits', 'achatcredits.php'),
(2, 'Acheter des images', 'achatimages.php'),
(3, 'Nous contacter', 'contacts.php'),
(4, 'Connexion', 'connexion.php'),
(5, 'S\'inscrire', 'inscription.php');

-- --------------------------------------------------------

--
-- Structure de la table `photos`
--

DROP TABLE IF EXISTS `photos`;
CREATE TABLE IF NOT EXISTS `photos` (
  `id_photo` int(11) NOT NULL AUTO_INCREMENT,
  `nom_photo` varchar(255) NOT NULL,
  `taille_pixel_x` int(11) NOT NULL,
  `taille_pixel_y` int(11) NOT NULL,
  `poids` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_photo`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `photos`
--

INSERT INTO `photos` (`id_photo`, `nom_photo`, `taille_pixel_x`, `taille_pixel_y`, `poids`, `url`, `id_user`) VALUES
(1, 'photo1', 1, 1, 1, '', 1),
(2, 'photo2', 222, 222, 33, '', 1),
(3, 'phoyo3', 85, 858, 8, '', 2);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `prenom` varchar(20) NOT NULL,
  `nom` varchar(40) NOT NULL,
  `pseudo` varchar(30) NOT NULL,
  `type` int(1) NOT NULL COMMENT '1 : photo 0 : client',
  `adresse` varchar(50) NOT NULL,
  `mdp` varchar(200) NOT NULL,
  `credits` int(11) NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `adresse` (`adresse`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id_user`, `prenom`, `nom`, `pseudo`, `type`, `adresse`, `mdp`, `credits`) VALUES
(1, 'Quentin', 'aaaaaaaaaaaaa', 'aaaa', 1, 'quentin.lucon@hotmail.fr', 'az', 12),
(2, 'aze', 'aze', 'aze', 1, 'azertyui@fe.fr', 'ab4f63f9ac65152575886860dde480a1', 0),
(3, 'Quentin', 'Lucon', 'Quentin Lucon', 1, 'abc@lol.fr', 'ab4f63f9ac65152575886860dde480a1', 0),
(4, 'test', 'testphoto', 'photogra', 0, 'asasasass', 'testbdd', 0);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
