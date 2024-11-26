-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 07 juin 2022 à 16:40
-- Version du serveur : 8.0.27
-- Version de PHP : 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `redoc`
--

-- --------------------------------------------------------

--
-- Structure de la table `releases`
--

DROP TABLE IF EXISTS `releases`;
CREATE TABLE IF NOT EXISTS `releases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producer` char(50) NOT NULL DEFAULT '',
  `program` char(50) NOT NULL DEFAULT '',
  `versiontype` char(30) NOT NULL DEFAULT '',
  `versionnumber` char(30) NOT NULL DEFAULT '',
  `rlstype` char(30) NOT NULL DEFAULT '',
  `cracker` char(30) DEFAULT '',
  `rlsdate` date NOT NULL DEFAULT '2007-05-01',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=422 DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

--
-- Déchargement des données de la table `releases`
--

INSERT INTO `releases` (`id`, `producer`, `program`, `versiontype`, `versionnumber`, `rlstype`, `cracker`, `rlsdate`) VALUES
(1, 'in media', 'profisubmit', '', 'v9.3.3', 'patch', 'ReD0c', '2006-01-08'),
(2, 'browserbob software', 'browserbob', 'pro', 'v4.1.3.0', 'patch', 'ReD0c', '2006-01-08'),
(3, 'in media', 'diashow pro', 'de', 'v9.8', 'patch', 'ReD0c', '2006-01-08'),
(4, 'in media', 'fotoarchiv plus', '', 'v5.50', 'patch', 'ReD0c', '2006-01-08'),
(5, 'in media', 'fotoworks', '', 'v9.30', 'patch', 'ReD0c', '2006-01-18'),
(6, 'desksoft', 'earthview', '', 'v3.4.0', 'patch', 'ReD0c', '2006-02-18'),
(7, 'iok', 'promoware', '', 'v3.0.0.8', 'patch', 'ReD0c', '2006-02-18'),
(8, 'desksoft', 'checkmail', '', 'v2.6.0', 'patch', 'ReD0c', '2006-02-18'),
(9, 'dreamware', 'bink', '', 'v2.00.0644', 'patch', 'ReD0c', '2006-02-21'),
(10, 'jlsoft', 'picture resizer', '', 'v2.0', 'serial', 'ReD0c', '2006-02-22'),
(11, 'desksoft', 'hardcopy', 'pro', 'v2.6.0', 'patch', 'ReD0c', '2006-02-25'),
(12, 'desksoft', 'bwmeter', '', 'v2.4.0', 'patch', 'ReD0c', '2006-02-26'),
(13, 'cursorarts', 'imageforge', 'de', 'v3.41', 'patch', 'ReD0c', '2006-03-03'),
(14, 'cursorarts', 'imageforge', 'en', 'v3.60', 'patch', 'ReD0c', '2006-03-03'),
(15, 'philaware', 'ab ranking tool', '', 'v1.6.0.9', 'keygen', 'ReD0c', '2006-03-05'),
(16, 'cursorarts', 'iconforge', 'de', 'v6.33d', 'patch', 'ReD0c', '2006-03-05'),
(17, 'cursorarts', 'iconforge', 'en', 'v7.20', 'patch', 'ReD0c', '2006-03-05'),
(18, 'hgs', 'adressen archiv', '', 'v8.0', 'serial', 'ReD0c', '2006-03-09'),
(19, 'hgs', 'autokosten', '', 'v8.0', 'keygen', 'ReD0c', '2006-03-12'),
(20, 'hgs', 'auto-manager', '', 'v8.0', 'keygen', 'ReD0c', '2006-03-13'),
(21, 'hgs', 'buch-archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-03-15'),
(22, 'hgs', 'video-archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-03-17'),
(23, 'mp3developments', 'cdripper', '', 'v2.86', 'serial', 'Max Zero', '2006-03-23'),
(24, 'mp3developments', 'mp3producer', '', 'v2.48', 'serial', 'Max Zero', '2006-03-23'),
(25, 'salfeld', 'kindersicherung 2005', '', 'v8.xxx', 'universalpatch regpatch', 'Max Zero', '2006-03-23'),
(26, 'alwil', 'avast!', 'pro', '4.6.763', 'serial', 'Max Zero', '2006-03-30'),
(27, 'audiotoolsfactory', 'mp3 cutter joiner', '', 'v2.00', 'serial', 'Max Zero', '2006-03-30'),
(28, 'hgs', 'bundesliga', '', 'v8.0', 'keygen', 'ReD0c', '2006-03-30'),
(29, 'imtoo', 'avi to dvd converter', '', 'v2.0.07.build.0317', 'serial', 'Max Zero', '2006-03-30'),
(30, 'hgs', 'cd archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-02'),
(31, 'hgs', 'comic archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-05'),
(32, 'catbytes', 'ram defrag', 'de', 'v2.82', 'patch', 'ReD0c', '2006-04-05'),
(33, 'uestudio', 'ultraedit-32', '', 'v12.00+x', 'serial', 'ReD0c', '2006-04-06'),
(34, 'acoustica', 'mp3 cd burner', '', 'v4.11', 'serial', 'Max Zero', '2006-04-08'),
(35, 'sefe', 'pnote', '', 'v1.1', 'patch', 'Phil8900', '2006-04-08'),
(36, 'sefe', 'easyfilerenamer', '', 'v1.0', 'patch', 'Phil8900', '2006-04-08'),
(37, 'hgs', 'dia archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-08'),
(38, 'hgs', 'dvd archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-12'),
(39, 'hgs', 'ea buchfuehrung', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-16'),
(40, 'desksoft', 'hardcopy', 'pro', 'v2.6.1', 'patch', 'ReD0c', '2006-04-17'),
(41, 'cagoo', 'qletter newsletter', '', 'v1.0.0.0', 'patch', 'ReD0c', '2006-04-17'),
(42, '', 'goldwave', '', 'v5.13', 'patch', 'Max Zero', '2006-04-17'),
(43, 'cluesoft', 'brain!fix', '', 'v2.0.0.4', 'patch', 'ReD0c', '2006-04-21'),
(44, 'advanced', 'mp3 converter', '', 'v2.62', 'serial', 'Dietm0r', '2006-04-23'),
(45, 'mp3do', 'real rm converter', '', 'v1.10', 'serial', 'Dietm0r', '2006-04-23'),
(46, 'ifoxsoft', 'photocollage', '', 'v1.38', 'patch', 'Dietm0r', '2006-04-23'),
(47, 'mp3do', 'cd mp3 burner', '', 'v2.15', 'serial', 'Dietm0r', '2006-04-23'),
(48, 'kaemsoft', 'screeny!', '', 'v1.5.2', 'regfile', 'Dietm0r', '2006-04-23'),
(49, 'advanced', 'cd ripper pro', '', 'v2.61', 'serial', 'Dietm0r', '2006-04-23'),
(50, 'aone', 'easy video to audio converter', '', 'v1.5.0', 'patch', 'chAosBIT', '2006-04-23'),
(51, 'aone', 'mov to avi mpeg wmv converter', '', 'v2.0.0', 'patch', 'chAosBIT', '2006-04-23'),
(52, 'all sound', 'recorder xp', '', 'v2.28', 'serial', 'Dietm0r', '2006-04-23'),
(53, '', 'spy-kill', 'deluxe', 'v3.35', 'patch', 'Dietm0r', '2006-04-23'),
(54, 'all sound', 'editor xp', '', 'v1.10', 'serial', 'Dietm0r', '2006-04-23'),
(55, 'aone', 'ultra mpeg converter', '', 'v2.0.6', 'patch', 'chAosBIT', '2006-04-23'),
(56, 'aone', 'ultra wmv converter', '', 'v2.1.2', 'patch', 'chAosBIT', '2006-04-23'),
(57, 'aone', 'ultra avi converter', '', 'v2.1.8', 'patch', 'chAosBIT', '2006-04-23'),
(58, 'planetiltis', 'dvd cover designer', '', 'v1.05', 'patch', 'Dietm0r', '2006-04-24'),
(59, '', 'linkdesktop', '', 'v1.5.0.16', 'cracked', 'ReD0c', '2006-04-24'),
(60, 'qwerks', 'capture studio', '', 'v1.63', 'patch', 'ReD0c', '2006-04-24'),
(61, 'hgs', 'fahrtenbuch', '', 'v8.0', 'keygen', 'ReD0c', '2006-04-24'),
(62, 'alivemedia', 'alive mp3 wav converter', '', 'v3.8.0.9', 'serial', 'Dietm0r', '2006-04-25'),
(63, 'alivemedia', 'alive video converter', '', 'v2.6.8.0', 'serial', 'Dietm0r', '2006-04-25'),
(64, 'alivemedia', 'alive wma mp3 recorder', '', 'v2.3.3.8', 'serial', 'Dietm0r', '2006-04-25'),
(65, '', 'vokabelmeister', '', 'v2.14', 'regfile patch', 'Dietm0r', '2006-04-25'),
(66, 'alivemedia', 'alive video joiner', '', 'v1.2.8.2', 'serial', 'Dietm0r', '2006-04-25'),
(67, 'alivemedia', 'alive text to speech', '', 'v5.2.3.8', 'serial', 'Dietm0r', '2006-04-25'),
(68, 'onl!ne', 'email grabber professional', 'en', 'v1.3', 'patch', 'ReD0c', '2006-04-25'),
(69, 'onl!ne', 'email grabber professional', 'de', 'v1.3', 'patch', 'ReD0c', '2006-04-25'),
(70, 'alivemedia', 'alive dvd ripper', '', 'v1.3.2.8', 'serial', 'Dietm0r', '2006-04-25'),
(71, 'alivemedia', 'alive cd ripper', '', 'v1.5.2.0', 'serial', 'Dietm0r', '2006-04-25'),
(72, 'alivemedia', 'alive mp3 cd burner', '', 'v1.2.9.2', 'serial', 'Dietm0r', '2006-04-25'),
(73, 'sprulex', 'sprueche- und zitate-lexikon', '', 'v4.0', 'serial', 'chAosBIT', '2006-05-06'),
(74, 'surfmusik', 'podspider', '', 'v1.5.37.1', 'cracked', 'ReD0c', '2006-05-06'),
(75, 'cad-kas', 'barcode creator', 'de', 'v1.0', 'patch', 'ReD0c', '2006-05-08'),
(76, 'cad-kas', 'barcode creator', 'en', 'v1.0', 'patch', 'ReD0c', '2006-05-08'),
(77, 'gesoft', 'gcmail 2006 mail client', '', 'v3.5.0.0', 'cracked', 'ReD0c', '2006-05-09'),
(78, 'py software', '2d and 3d animator', '', 'v1.5.0.0', 'cracked', 'ReD0c', '2006-05-09'),
(79, 'cad-kas', 'business card printery', 'en', 'v3.5', 'patch', 'ReD0c', '2006-05-10'),
(80, 'cad-kas', 'appointments', 'en', 'v1.0', 'patch', 'ReD0c', '2006-05-10'),
(81, 'hgs', 'grand prix', '', 'v8.0', 'keygen', 'ReD0c', '2006-05-11'),
(82, 'cad-kas', 'cd to mp3 ripper', 'en', 'v1.0', 'patch', 'ReD0c', '2006-05-11'),
(83, 'cad-kas', 'cd-cover', 'en', 'v1.1', 'patch', 'ReD0c', '2006-05-11'),
(84, 'hgs', 'handball', '', 'v8.0', 'keygen', 'ReD0c', '2006-05-12'),
(85, 'cad-kas', 'cd-menusystem', 'en', 'v1.1', 'universalpatch', 'ReD0c', '2006-05-12'),
(86, 'acon', 'digital media acoustica', 'en', 'v3.30.0.0', 'patch', 'ReD0c', '2006-05-13'),
(87, 'acon', 'digital media acoustica', 'de', 'v3.30.0.0', 'patch', 'ReD0c', '2006-05-13'),
(88, 'ashampoo', 'magical snap', 'de', 'v1.10', 'patch', 'ReD0c', '2006-05-17'),
(89, 'hgs', 'hausrat', '', 'v8.0', 'keygen', 'ReD0c', '2006-05-20'),
(90, 'hgs', 'kassenbuch', '', 'v8.0', 'keygen', 'ReD0c', '2006-06-01'),
(91, 'newsgator', 'feeddemon', '', 'v2.0.0.23', 'patch', 'ReD0c', '2006-06-01'),
(92, 'hgs', 'liga', '', 'v8.0', 'keygen', 'ReD0c', '2006-06-04'),
(93, 'cad-kas', 'diashow', '', 'v3.0', 'patch', 'ReD0c', '2006-06-04'),
(94, 'widisoft', 'widi recognition system', '', 'v3.3.0.583', 'patch', 'ReD0c', '2006-06-05'),
(95, 'softeza', 'easy install maker', '', 'v2.18', 'patch', 'Phil8900', '2006-06-05'),
(96, 'inge beyer', 'belegungsplaner', '', 'v4.0.0.0', 'patch', 'ReD0c', '2006-06-10'),
(97, 'inge beyer', 'wandkalender-drucker', '', 'v2.2.1.0', 'patch', 'ReD0c', '2006-06-10'),
(98, 'primus', 'data primcam', '', 'v2.8.6', 'patch', 'ReD0c', '2006-06-10'),
(99, 'primus', 'data primcam', '', 'v2.9.6.beta.24', 'patch', 'ReD0c', '2006-06-11'),
(100, 'tse', 'nc programmierung', '', 'v7.7.0.17', 'patch', 'ReD0c', '2006-06-12'),
(101, 'katzenminze', 'areal', '', 'v1.9.4', 'patch', 'ReD0c', '2006-06-13'),
(102, 'katzenminze', 'allerlei rechnen 1 bis 20', '', 'v1.7', 'patch', 'ReD0c', '2006-06-13'),
(103, 'automated office systems', 'active screensaver personal', '', 'v3.0', 'serial', 'ReD0c', '2006-06-14'),
(104, 'automated office systems', 'dbcompare', '', 'v1.0', 'serial', 'ReD0c', '2006-06-14'),
(105, 'automated office systems', 'active screen saver development kit', '', 'v3.0.0.200', 'serial', 'ReD0c', '2006-06-14'),
(106, '1st', 'atomic time', '', 'v2.1.1.110', 'patch', 'ReD0c', '2006-06-15'),
(107, 'tmx communications', 'vokabeltrainer englisch', 'full', 'v5.0.0.6', 'patch', 'ReD0c', '2006-06-16'),
(108, 'tmx communications', 'vokabeltrainer englisch', 'basic', 'v5.0.0.6', 'patch', 'ReD0c', '2006-06-16'),
(109, 'poco', 'systems barca', '', 'v2.1.0.3650', 'patch', 'ReD0c', '2006-06-16'),
(110, 'terminal', 'studio tetris revolution', '', 'v1.0', 'patch', 'ReD0c', '2006-06-19'),
(111, 'terminal', 'studio tetris arena', '', 'v1.4', 'patch', 'ReD0c', '2006-06-19'),
(112, 'terminal', 'studio challenger tetris', '', 'v1.1', 'patch', 'ReD0c', '2006-06-19'),
(113, 'hgs', 'modellbahn', '', 'v8.0', 'keygen', 'ReD0c', '2006-06-20'),
(114, 'hgs', 'modellauto', '', 'v8.0', 'keygen', 'ReD0c', '2006-06-20'),
(115, 'computentsystems', 'getstarted!xp', '', 'v4.5.6', 'patch', 'ReD0c', '2006-06-20'),
(116, 'in media', 'fotoworks', '', 'v9.3.5', 'patch', 'ReD0c', '2006-06-22'),
(117, 'in media', 'intelligent shutdown', '', 'v1.3.5', 'patch', 'ReD0c', '2006-06-23'),
(118, 'in media', 'slideshow pro', 'en', 'v9.8.6', 'patch', 'ReD0c', '2006-06-23'),
(119, 'hgs', 'marken archiv', '', 'v8.0', 'keygen', 'ReD0c', '2006-06-23'),
(120, 'ashampoo', 'convertya', '', 'v1.0.0.8', 'patch', 'ReD0c', '2006-06-29'),
(121, 'ashampoo', 'antispyware', '', 'v1.30', 'patch', 'ReD0c', '2006-06-29'),
(122, 'acala', 'dvd copy', '', 'v2.1.3', 'patch', 'chAosBIT', '2006-07-01'),
(123, 'acala', 'divx to ipod', '', 'v2.2.3', 'patch', 'ReD0c', '2006-07-01'),
(124, '1-more', 'webcam', '', 'v1.0.3', 'patch', 'chAosBIT', '2006-07-02'),
(125, 'acala', 'dvd ripper', '', 'v2.2.0', 'patch', 'chAosBIT', '2006-07-05'),
(126, 'jlsoft', 'notenkalkulator', '', 'v2.0', 'serial', 'chAosBIT', '2006-07-05'),
(127, 'jlsoft', 'picture resizer', '', 'v2.1', 'serial', 'chAosBIT', '2006-07-05'),
(128, 'acala', 'avi divx mpeg xvid vob to psp', '', 'v2.2.2', 'patch', 'chAosBIT', '2006-07-06'),
(129, 'eusoftware', 'wizardbrush', '', 'v6.x', 'regpatch', 'ReD0c', '2006-07-06'),
(130, '1-more', 'scanner', '', 'v1.25', 'serial', 'chAosBIT', '2006-07-06'),
(131, '1-more', 'watermarker', '', 'v1.25', 'serial', 'chAosBIT', '2006-07-06'),
(132, '1-more', 'photoshow', '', 'v1.04', 'patch', 'ReD0c', '2006-07-06'),
(133, '1-more', 'photocalender', '', 'v1.80', 'serial', 'chAosBIT', '2006-07-06'),
(134, '1-more', 'photomanager', '', 'v1.40', 'patch', 'ReD0c', '2006-07-06'),
(135, 'cad-kas', 'pool billard', 'de', 'v1.0', 'patch', 'ReD0c', '2006-07-07'),
(136, 'acez', 'screen saver builder', '', 'v2.1.0.1', 'serial', 'ReD0c', '2006-07-08'),
(137, 'cad-kas', 'pool billiard', 'en', 'v1.0', 'patch', 'ReD0c', '2006-07-08'),
(138, '1street', 'pdf galerie', 'de', 'v20008.key.1.5', 'patch', 'ReD0c', '2006-07-09'),
(139, '1street', 'pdf galerie', 'en', 'v20008.key.1.5', 'patch', 'ReD0c', '2006-07-09'),
(140, '1street', 'wasserzeichen', 'de', 'v06152005-300007947', 'patch', 'ReD0c', '2006-07-09'),
(141, '1street', 'file fuchs', '', 'v1.5.1-222457', 'patch', 'ReD0c', '2006-07-10'),
(142, '1street', '3d pack', '', 'v1.5-222459', 'patch', 'ReD0c', '2006-07-10'),
(143, '1street', 'klick thumbnails digistar', '', 'v20007.key.3.3.1-222310', 'patch', 'ReD0c', '2006-07-11'),
(144, '1street', 'public pdf', 'de', 'v20006-222458', 'patch', 'ReD0c', '2006-07-11'),
(145, '1street', 'klick thumbnails xpress', '', 'v06152005-222456', 'patch', 'ReD0c', '2006-07-11'),
(146, 'alltags-programme', 'alltags-adressen', '', 'v2006.7.0.2774', 'serial', 'ReD0c', '2006-07-12'),
(147, 'alltags-programme', 'alltags-tagebuch', '', 'v2006.7.0.1200', 'serial', 'ReD0c', '2006-07-12'),
(148, 'alltags-programme', 'alltags-planer', '', 'v2006.7.0.1163', 'serial', 'ReD0c', '2006-07-12'),
(149, 'alltags-programme', 'alltags-notizen', '', 'v2006.7.0.1247', 'serial', 'ReD0c', '2006-07-12'),
(150, 'aspoa', 'scan2find', 'multi-user', 'v3.14', 'serial', 'ReD0c', '2006-07-13'),
(151, 'aspoa', 'scan2find', 'multi-user test version', 'v3.14', 'patch', 'ReD0c', '2006-07-13'),
(152, 'kc softwares', 'k-ml', '', 'v3.34.0.353', 'serial', 'ReD0c', '2006-07-14'),
(153, 'kc softwares', 'phototofilm', '', 'v2.6.0.63', 'serial', 'ReD0c', '2006-07-15'),
(154, 'grouppk', '1tabview', '', 'v2.2.0.0', 'patch', 'ReD0c', '2006-07-18'),
(155, 'grouppk', '1uglyftp', '', 'v2.30', 'patch', 'ReD0c', '2006-07-18'),
(156, 'grouppk', 'sitelogz', '', 'v3.0.1.1', 'patch', 'ReD0c', '2006-07-20'),
(157, 'grouppk', '1logview', '', 'v3.0.3.1', 'patch', 'ReD0c', '2006-07-21'),
(158, 'grouppk', '1cleanup', '', 'v3.2.0.0', 'patch', 'ReD0c', '2006-07-22'),
(159, 'grouppk', '1popcheck', '', 'v1.0.0.0', 'patch', 'ReD0c', '2006-07-23'),
(160, 'lsusoft', 'bookworm', '', 'v4.2.1', 'patch', 'ReD0c', '2006-07-24'),
(161, 'cad-kas', 'html2exe baler', '', 'v2.0', 'patch', 'ReD0c', '2006-07-24'),
(162, 'cad-kas', 'web photoalbum', '', 'v1.0', 'patch', 'ReD0c', '2006-07-24'),
(163, 'cad-kas', 'play any cd', '', 'v1.0', 'patch', 'ReD0c', '2006-07-25'),
(164, 'cad-kas', 'text 2 speech', '', 'v1.0', 'patch', 'ReD0c', '2006-07-25'),
(165, 'cad-kas', 'dictionary german', '', 'v1.0', 'patch', 'ReD0c', '2006-07-29'),
(166, 'kaemsoft', 'screeny', '', 'v1.6.0.0', 'serial', 'ReD0c', '2006-08-02'),
(167, 'acala', 'video mp3 ripper', '', 'v2.2.8', 'patch', 'chAosBIT', '2006-08-19'),
(168, 'acala', 'dvd to pocket pc movie', '', 'v2.3.6', 'patch', 'chAosBIT', '2006-08-19'),
(169, 'acala', 'dvd audio ripper', '', 'v2.3.2', 'patch', 'chAosBIT', '2006-08-19'),
(170, 'acala', 'dvd ipod ripper', '', 'v2.3.2', 'patch', 'chAosBIT', '2006-08-19'),
(171, 'acala', 'dvd psp ripper', '', 'v2.3.2', 'patch', 'chAosBIT', '2006-08-19'),
(172, 'cad-kas', 'umfrage formulare', '', 'v1.0.0.0', 'patch cracked', 'ReD0c', '2006-08-20'),
(173, 'tennyson maxwell information systems', 'teleport', 'pro', 'v1.41', 'keygen', 'ReD0c', '2006-08-21'),
(174, 'benedikt iltisberger', 'dvd cover designer 2005', '', 'v1.x', 'keygen', 'ReD0c', '2006-08-25'),
(175, 'lighttek', 'icontoy', '', 'v3.1.x', 'keygen', 'ReD0c', '2006-08-28'),
(176, '', 'browserbob', 'pro', 'v4.1.3.0', 'patch', 'ReD0c', '2006-08-31'),
(177, 'eberhard werner', 'auto master', '', 'v8.67p', 'patch', 'ReD0c', '2006-09-09'),
(178, 'eberhard werner', 'schluessel master', '', 'v6.72', 'patch', 'ReD0c', '2006-09-10'),
(179, 'eberhard werner', 'lotto auswahl master', '', 'v4.25', 'patch', 'ReD0c', '2006-09-10'),
(180, 'eberhard werner', 'hausrat und inventar master', '', 'v4.60', 'patch', 'ReD0c', '2006-09-11'),
(181, 'eberhard werner', 'termin master', '', 'v5.03', 'patch', 'ReD0c', '2006-09-12'),
(182, 'eberhard werner', 'budget master', '', 'v2.27', 'patch', 'ReD0c', '2006-09-13'),
(183, 'my-niche', 'buttonex', '', 'v1.0.57', 'patch', 'chAosBIT', '2006-09-13'),
(184, 'eberhard werner', 'garantie master', '', 'v2.17', 'patch', 'ReD0c', '2006-09-14'),
(185, ' to-spy-on software', 'to-spy-on', '', 'v2.4.0.0', 'patch', 'ReD0c', '2006-09-15'),
(186, 'eberhard werner', 'literatur master', '', 'v1.48', 'patch', 'ReD0c', '2006-09-16'),
(187, 'eberhard werner', 'geschenk master', '', 'v1.74', 'patch', 'ReD0c', '2006-09-17'),
(188, 'eberhard werner', 'zuzahlungs master', '', 'v1.61', 'patch', 'ReD0c', '2006-09-17'),
(189, 'eberhard werner', 'hausenergie master', '', 'v1.55', 'patch', 'ReD0c', '2006-09-18'),
(190, 'eberhard werner', 'versicherungs master', '', 'v1.18', 'patch', 'ReD0c', '2006-09-19'),
(191, 'eberhard werner', 'ereignis master', '', 'v1.01', 'patch', 'ReD0c', '2006-09-20'),
(192, 'man-tech', 'camspy', 'pro', 'v3.4.2', 'serial', 'chAosBIT', '2006-09-22'),
(193, 'plusaufbau software', 'plusaufbau', '', 'v2.5.0.0', 'patch', 'ReD0c', '2006-09-22'),
(194, 'primdata', 'primcam', '', 'v2.9.6', 'patch', 'chAosBIT', '2006-09-22'),
(195, 'alivemedia', 'alive dvd ripper', '', 'v1.6.8.2', 'serial', 'chAosBIT', '2006-09-26'),
(196, 'alivemedia', 'alive ipod video converter', '', 'v2.0.3.3', 'serial', 'chAosBIT', '2006-09-26'),
(197, 'alivemedia', 'alive mp4 converter', '', 'v1.3.6.6', 'serial', 'chAosBIT', '2006-09-26'),
(198, 'alivemedia', 'alive wma mp3 recorder', '', 'v2.6.3.6', 'serial', 'chAosBIT', '2006-09-26'),
(199, 'a. weintrub', 'visicard visitenkartendesigner', '', 'v2.0.0.8', 'serial', 'ReD0c', '2006-10-07'),
(200, 'a. weintrub', 'cinema videothekenverwaltung', '', 'v2.0.0.19', 'serial', 'ReD0c', '2006-10-07'),
(201, 'ah soft', 'emill2d(se)', '', 'v6.419', 'patch', 'chAosBIT', '2006-10-08'),
(202, 'ah soft', 'emillphoto(se)', '', 'v6.419', 'patch', 'chAosBIT', '2006-10-08'),
(203, 'ah soft', 'emillstl(se)', '', 'v6.419', 'patch', 'chAosBIT', '2006-10-08'),
(204, 'ah soft', 'isign+', '', 'v6.419', 'patch', 'chAosBIT', '2006-10-08'),
(205, 'ah soft', 'rasterphoto(se)', '', 'v7.000', 'patch', 'chAosBIT', '2006-10-08'),
(206, 'ulead systems', 'photoimpact', 'trial', 'v12.00.0000.0', 'patch', 'FleN', '2006-10-10'),
(207, 'dvv software', 'happy birthday', 'xp', 'v1.0', 'serial', 'chAosBIT', '2006-10-11'),
(208, 'atousoft', 'world of santes', '', 'v2006', 'serial', 'FleN', '2006-10-12'),
(209, 'atousoft', 'world of livres', '', 'v2006', 'serial', 'FleN', '2006-10-12'),
(210, 'atousoft', 'world of ephemerides', '', 'v2006', 'serial', 'FleN', '2006-10-12'),
(211, 'atousoft', 'visutech', '', 'v2006c', 'serial', 'FleN', '2006-10-12'),
(212, 'tennyson maxwell information systems', 'teleport', 'pro', 'v1.42', 'keygen', 'ReD0c', '2006-10-14'),
(213, 'rarlab', 'winrar', 'multilingual', 'v3.xxx', 'universalpatch', 'FleN', '2006-10-15'),
(214, 'g.t.m', 'verbe', '', 'v5.8', 'keyfile', 'FleN', '2006-10-15'),
(215, 'remy pialat', 'ramcal', '', 'v2.02', 'serial', 'FleN', '2006-10-19'),
(216, 'remy pialat', 'ramville', '', 'v1.41c', 'serial', 'FleN', '2006-10-19'),
(217, 'maximumsoft', 'webcopier', '', 'v4.4', 'patch', 'FleN', '2006-10-20'),
(218, 'maximumsoft', 'webcopier', 'pro', 'v4.3.1', 'patch', 'FleN', '2006-10-20'),
(219, 'winzip', 'winzip', '', 'v11.xx', 'universalpatch', 'FleN', '2006-10-24'),
(220, 'gernova', 'observe', '', 'v1.106.2510', 'patch', 'chAosBIT', '2006-10-26'),
(221, 'gernova', 'passbox', '', 'v1.105.2510', 'patch', 'FleN', '2006-10-26'),
(222, 'coolmasoft', 'multisync', '', 'v2.4.2.0', 'serial', 'ReD0c', '2006-10-29'),
(223, 'coolmasoft', 'websharp', '', 'v1.x', 'serial', 'Phil8900', '2006-10-29'),
(224, 'coolmasoft', 'changeip', '', 'v1.2', 'serial', 'Phil8900', '2006-10-29'),
(225, 'ak it-solutions', 'winscan', '', 'v5.0.102.122', 'patch', 'phil8900', '2006-11-02'),
(226, 'modulesoft', 'createmovie', '', 'v1.0.0.2', 'cracked', 'phil8900', '2006-11-02'),
(227, 'gerard faye', 'l3t', '', 'v4.4-52', 'serial', 'fLiToX', '2006-11-03'),
(228, 'modulesoft', 'allextractbuilder', 'en', 'v1.3.1.0', 'cracked', 'phil8900', '2006-11-04'),
(229, 'modulesoft', 'allextractbuilder', 'de', 'v1.3.1.0', 'cracked', 'phil8900', '2006-11-04'),
(230, 'modulesoft', 'cpuuse', '', 'v1.1.0.0', 'cracked', 'phil8900', '2006-11-04'),
(231, 'trian software', 'domino3d', '', 'v1.2.2', 'cracked', 'fLiToX', '2006-11-04'),
(232, 'trian software', 'the king', '', 'v3.3.0.1694', 'cracked', 'fLiToX', '2006-11-04'),
(233, 'oggisoft', 'adressverwaltung', '', 'v2005.9.0.65', 'regfile', 'ReD0c', '2006-11-19'),
(234, 'oggisoft', 'exe blocker', '', 'v2005.9.0.34', 'regfile', 'ReD0c', '2006-11-19'),
(235, 'oggisoft', 'backup list', '', 'v2005.9.0.107', 'regfile', 'ReD0c', '2006-11-20'),
(236, 'oggisoft', 'benzinkosten', '', 'v2005.12.0.60', 'regfile', 'ReD0c', '2006-11-20'),
(237, 'oggisoft', 'bibliothek', '', 'v2006.10.0.170', 'regfile', 'ReD0c', '2006-11-21'),
(238, 'oggisoft', 'bibliothek', '', 'v2005.11.0.143', 'regfile', 'ReD0c', '2006-11-21'),
(239, 'oggisoft', 'bibliothek', 'pro', 'v2006.10.0.139', 'regfile', 'ReD0c', '2006-11-21'),
(240, 'oggisoft', 'bibliothek', 'pro', 'v2005.11.0.108', 'regfile', 'ReD0c', '2006-11-21'),
(241, 'oggisoft', 'desktop bildmanager', '', 'v2005.9.0.34', 'regfile', 'ReD0c', '2006-11-22'),
(242, 'oggisoft', 'energiekosten', '', 'v2006.1.0.44', 'regfile', 'ReD0c', '2006-11-22'),
(243, ' eurothink', 'adresses', '', 'v2.1x', 'universalpatch', 'FleN', '2006-11-23'),
(244, ' eurothink', 'agenda', '', 'v2.1x', 'universalpatch', 'FleN', '2006-11-23'),
(245, ' eurothink', 'archives perso', '', 'v2.6x', 'universalpatch', 'FleN', '2006-11-23'),
(246, ' eurothink', 'articles de presse', '', 'v1.1x', 'universalpatch', 'FleN', '2006-11-23'),
(247, ' eurothink', 'bdtheque', '', 'v1.1x', 'universalpatch', 'FleN', '2006-11-23'),
(248, ' eurothink', 'bibliotheque', '', 'v2.5x', 'universalpatch', 'FleN', '2006-11-23'),
(249, ' eurothink', 'cave a vin', '', 'v1.6x', 'universalpatch', 'FleN', '2006-11-23'),
(250, ' eurothink', 'cdtheque', '', 'v2.0x', 'universalpatch', 'FleN', '2006-11-23'),
(251, ' eurothink', 'cheque', '', 'v1.6x', 'universalpatch', 'FleN', '2006-11-23'),
(252, ' eurothink', 'consommation', '', 'v1.6x', 'universalpatch', 'FleN', '2006-11-23'),
(253, ' eurothink', 'contrats', '', 'v1.1x', 'universalpatch', 'FleN', '2006-11-23'),
(254, ' eurothink', 'inventaire perso', '', 'v2.6x', 'universalpatch', 'FleN', '2006-11-23'),
(255, ' eurothink', 'planning', '', 'v1.1x', 'universalpatch', 'FleN', '2006-11-23'),
(256, ' eurothink', 'santalite', '', 'v2.1x', 'universalpatch', 'FleN', '2006-11-23'),
(257, ' eurothink', 'smart organizer', 'pro', 'v2.1x', 'universalpatch', 'FleN', '2006-11-23'),
(258, ' eurothink', 'smart organizer', '', 'v2.1x', 'universalpatch', 'FleN', '2006-11-23'),
(259, ' eurothink', 'supermarche', '', 'v1.6x', 'universalpatch', 'FleN', '2006-11-23'),
(260, ' eurothink', 'videotheque', '', 'v2.5x', 'universalpatch', 'FleN', '2006-11-23'),
(261, 'oggisoft', 'girokonto', '', 'v2006.7.0.79', 'regfile', 'ReD0c', '2006-11-24'),
(262, 'oggisoft', 'lan email', '', 'v2006.11.0.1143', 'regfile', 'ReD0c', '2006-11-24'),
(263, 'oggisoft', 'lan email', 'pro', 'v2006.11.0.1183', 'regfile', 'ReD0c', '2006-11-25'),
(264, 'oggisoft', 'morsen', '', 'v2006.11.0.57', 'regfile', 'ReD0c', '2006-11-25'),
(265, 'oggisoft', 'network traffic', '', 'v2005.9.0.89', 'regfile', 'ReD0c', '2006-11-26'),
(266, 'oggisoft', 'notizen manager', '', 'v2006.11.0.243', 'regfile', 'ReD0c', '2006-11-27'),
(267, 'oggisoft', 'passwort generator', '', 'v2005.12.0.63', 'regfile', 'ReD0c', '2006-11-27'),
(268, 'oggisoft', 'photoview', '', 'v2006.9.0.114', 'regfile', 'ReD0c', '2006-11-27'),
(269, 'big informatique', 'winbudget', '', 'v1.03', 'serial', 'fLiToX', '2006-11-27'),
(270, 'big informatique', 'wincompt', '', 'v2.5', 'serial', 'fLiToX', '2006-11-27'),
(271, 'didaclick', 'carfactou', '', 'v6.0', 'serial', 'fLiToX', '2006-11-27'),
(272, 'didaclick', 'funny pro us', '', 'v2.0', 'serial', 'fLiToX', '2006-11-27'),
(273, 'emailarms', 'best smtp server', '', 'v2.1', 'keygen', 'fLiToX', '2006-11-27'),
(274, 'freezbe', 'freezbe', '', 'v1.0', 'serial', 'fLiToX', '2006-11-27'),
(275, 'mpicaud', 'calendrier automatique', '', 'v5.29', 'serial', 'fLiToX', '2006-11-27'),
(276, 'desksoft', 'hardcopy', 'pro', 'v2.7.6.0', 'patch', 'ReD0c', '2006-11-28'),
(277, 'team technologies', 'teamup pcm tools', '', 'v07.08.1999-200', 'patch', 'ReD0c', '2006-11-28'),
(278, 'desksoft', 'bwmeter', '', 'v2.6.3.0', 'patch', 'ReD0c', '2006-11-29'),
(279, 'oggisoft', 'register editor', '', 'v2006.2.0.91', 'regfile', 'ReD0c', '2006-11-29'),
(280, 'computent systems', 'getstarted!xp', 'de en', 'v4.5.6.x', 'patch', 'ReD0c', '2006-11-30'),
(281, 'desksoft', 'earthview', '', 'v3.6.2.0', 'patch', 'ReD0c', '2006-11-30'),
(282, 'oggisoft', 'schallarchiv', '', 'v2005.10.0.128', 'regfile', 'ReD0c', '2006-11-30'),
(283, 'oggisoft', 'schallarchiv', '', 'v2006.12.0.192', 'regfile', 'ReD0c', '2006-11-30'),
(284, 'oggisoft', 'systemzeit', '', 'v2005.10.0.52', 'regfile', 'ReD0c', '2006-12-02'),
(285, 'desksoft', 'scrollnavigator', '', 'v2.0.3.0', 'patch', 'ReD0c', '2006-12-03'),
(286, 'desksoft', 'smartcapture', '', 'v1.7.11.0', 'patch', 'ReD0c', '2006-12-03'),
(287, 'oggisoft', 'tipptrainerin', '', 'v2006.9.0.26', 'regfile', 'ReD0c', '2006-12-03'),
(288, 'desksoft', 'checkmail', '', 'v3.1.3.0', 'patch', 'ReD0c', '2006-12-04'),
(289, 'desksoft', 'desktopplant', '', 'v2.2.6.0', 'patch', 'ReD0c', '2006-12-04'),
(290, 'desksoft', 'earthtime', '', 'v1.6.1.0', 'patch', 'ReD0c', '2006-12-05'),
(291, 'softx', 'ftp client', '', 'v3.0.0.1', 'patch', 'ReD0c', '2006-12-06'),
(292, 'softx', 'http debugger', '', 'v4.0.0.1', 'patch', 'ReD0c', '2006-12-06'),
(293, 'loguyciel', 'a vos grilles', '', 'v5.50', 'regfile', 'FleN', '2006-12-07'),
(294, 'loguyciel', 'anonymail', '', 'v1.51', 'regfile', 'FleN', '2006-12-07'),
(295, 'loguyciel', 'belote renversee', '', 'v1.50', 'regfile', 'FleN', '2006-12-07'),
(296, 'loguyciel', 'cruciver', '', 'v4.23', 'regfile', 'FleN', '2006-12-07'),
(297, 'loguyciel', 'dicorime', '', 'v2.10', 'regfile', 'FleN', '2006-12-07'),
(298, 'loguyciel', 'micro motus', '', 'v1.00', 'regfile', 'FleN', '2006-12-07'),
(299, 'loguyciel', 'micro scrabble', '', 'v2.51', 'regfile', 'FleN', '2006-12-07'),
(300, 'loguyciel', 'micro trivial pursuit', '', 'v1.71', 'regfile', 'FleN', '2006-12-07'),
(301, 'loguyciel', 'sos jeux de lettres', '', 'v2.41', 'regfile', 'FleN', '2006-12-07'),
(302, 'loguyciel', 'super grilles', '', 'v1.30', 'regfile', 'FleN', '2006-12-07'),
(303, 'tx software', 'ones', 'trial', 'v2.0.358', 'patch', 'FleN', '2006-12-07'),
(304, 'collection manager', 'collection manager 2006', '', 'v5.0', 'serial', 'FleN', '2006-12-11'),
(305, 'emailarms', 'internet kiosk', 'pro', 'v3.3', 'keygen', 'fLiToX', '2006-12-11'),
(306, 'mutexdevelopments', '4womenonly', '', 'v5.2', 'patch', 'fLiToX', '2006-12-11'),
(307, 'charles shmidt', 'puzzle', '', 'v2.0', 'keyfile', 'FleN', '2006-12-12'),
(308, 'charles shmidt', 'sudoku', '', 'v1.0', 'keyfile', 'FleN', '2006-12-12'),
(309, 'charles shmidt', 'fubuki', '', 'v1.0', 'keyfile', 'FleN', '2006-12-12'),
(310, 'pierre e gougelet', 'xnview', '', 'v1.90 beta 4', 'serial', 'Max_Zero', '2006-12-12'),
(311, 'baliciel', 'bali turf', '', 'v2.2', 'cracked', 'fLiToX', '2006-12-11'),
(312, 'tuneup software', 'tuneup utilities', '', 'v2007.6.x', 'universalpatch', 'Max_Zero', '2006-12-13'),
(313, 'slysoft', 'anydvd', '', 'v6.0.9.5', 'patch', 'Max_Zero', '2006-12-13'),
(314, 'capturetext.com', 'capture text', '', 'v4.9', 'patch', 'ReD0c', '2006-12-13'),
(315, 'electronic arts', 'need for speed carbon 8 multi language changer', '', 'v1.0', 'regpatch', 'Max_Zero', '2006-12-13'),
(316, 'tukanas', 'email extractor', 'french', 'v1.0', 'patch', 'ReD0c', '2006-12-14'),
(317, 'tukanas', 'email extractor', 'english', 'v1.0', 'patch', 'ReD0c', '2006-12-14'),
(318, 'vso', 'convertxtodvd', '', 'v2.1.x', 'universalpatch', 'Max_Zero', '2006-12-14'),
(319, 'ejoystudio', 'oripa yahoo webcam recorder', '', 'v1.2.3.x', 'patch', 'ReD0c', '2006-12-15'),
(320, 'ejoystudio', 'oripa msn webcam recorder', '', 'v1.2.1.x', 'patch', 'ReD0c', '2006-12-16'),
(321, 'ejoystudio', 'oripa video recorder', '', 'v1.2.x', 'patch', 'ReD0c', '2006-12-16'),
(322, 'nagel software', 'objekteditor', 'pro', 'v1.2.1.x', 'serial', 'ReD0c', '2006-12-17'),
(323, 'aaapdf', 'aaa pdf to word batch converter', '', 'v2.0', 'serial', 'FleN', '2006-12-18'),
(324, 'aaapdf', 'aaa pdf to text batch converter', '', 'v2.0', 'serial', 'FleN', '2006-12-18'),
(325, 'aaapdf', 'aaa pdf to password remover', '', 'v2.0', 'serial', 'FleN', '2006-12-18'),
(326, 'aaapdf', 'aaa pdf to html batch converter', '', 'v2.0', 'serial', 'FleN', '2006-12-18'),
(327, 'orplan', 'facturation orplan', '', 'v3.2', 'regfile', 'FleN', '2006-12-18'),
(328, 'jeroboam', 'facturation', '', 'v5.1', 'serial', 'FleN', '2006-12-19'),
(329, 'jeroboam', 'facturation', '', 'v5.18', 'serial', 'FleN', '2006-12-19'),
(330, 'jeroboam', 'facturation', '', 'v6.31', 'serial', 'FleN', '2006-12-19'),
(331, 'tukanas', 'hits.generator', '', 'v1.0.0.x', 'patch', 'ReD0c', '2006-12-19'),
(332, 'ejoystudio', 'fast cap game recorder', 'mini', 'v1.4.7', 'serial', 'ReD0c', '2006-12-20'),
(333, 'ejoystudio', 'fast cap game recorder', 'pro', 'v1.4.7', 'serial', 'ReD0c', '2006-12-20'),
(334, 'bufo project damian schmidt', 'bufovok vokabeltrainer', '', 'v3.x', 'universalpatch', 'ReD0c', '2006-12-21'),
(335, 'big informatique', 'winbudget', '', 'v1.03', 'serial', 'fLiToX', '2006-12-22'),
(336, 'big informatique', 'wincompt', '', 'v2.5', 'serial', 'fLiToX', '2006-12-22'),
(337, 'big informatique', 'winfact', '', 'v4.0.0.103', 'serial', 'fLiToX', '2006-12-22'),
(338, 'big informatique', 'winpharm', '', 'v3.04', 'serial', 'fLiToX', '2006-12-22'),
(339, 'big informatique', 'winstock', '', 'v4.0.0.103', 'serial', 'fLiToX', '2006-12-22'),
(340, 'big informatique', 'wintresor', '', 'v1.01', 'serial', 'fLiToX', '2006-12-22'),
(341, 'emailarms', '1st desktop guard', '', 'v1.8', 'keygen', 'fLiToX', '2006-12-22'),
(342, 'emailarms', '1st disk drive protector', '', 'v1.4', 'keygen', 'fLiToX', '2006-12-22'),
(343, 'emailarms', '1st smtp server', '', 'v2.8', 'keygen', 'fLiToX', '2006-12-22'),
(344, 'emailarms', 'advanced emailer', '', 'v3.1', 'keygen', 'fLiToX', '2006-12-22'),
(345, 'emailarms', 'evidence destructor', '', 'v2.2', 'keygen', 'fLiToX', '2006-12-22'),
(346, 'emailarms', 'local smtp server', 'pro', 'v2.8', 'keygen', 'fLiToX', '2006-12-22'),
(347, 'pixelie', 'boursiclub', '', 'v3.3.0.1', 'cracked', 'FleN', '2006-12-25'),
(348, 'pixelie', 'euro moondial', '', 'v2.2.2', 'keyfile', 'FleN', '2006-12-25'),
(349, 'big informatique', 'windentist', '', 'v1.0', 'cracked', 'fLiToX', '2006-12-28'),
(350, 'keroon software', 'active directory list users and computers', '', 'v2.0.3', 'patch', 'fLiToX', '2006-12-28'),
(351, 'keroon software', 'keroon service monitor', '', 'v1.1.0', 'patch', 'fLiToX', '2006-12-28'),
(352, 'pixelie', 'rapdate', '', 'v5.0.0.0', 'keyfile', 'FleN', '2006-12-28'),
(353, 'win&soft', 'ebackup', '', 'v1.7.x', 'serial', 'FleN', '2006-12-28'),
(354, 'win&soft', 'mediatek perso', '', 'v3.102', 'serial', 'FleN', '2006-12-28'),
(355, 'win&soft', 'mediatek pro', '', 'v4.30', 'serial', 'FleN', '2006-12-28'),
(356, 'ashampoo nikolaus brennig', 'photo commander', '', 'v5.1.x', 'patch', 'ReD0c', '2006-12-29'),
(357, 'bitwerk', 'faxalarm', '', 'v2.3.x', 'patch', 'ReD0c', '2006-12-30'),
(358, 'bitwerk', 'startmanager', '', 'v1.2.x', 'patch', 'ReD0c', '2006-12-30'),
(359, 'boesi software tools', 'rename tool', '', 'v1.2.x', 'patch', 'ReD0c', '2006-12-30'),
(360, 'boesi software tools', 'easy bar code printer', '', 'v1.0.x', 'serial', 'ReD0c', '2006-12-31'),
(361, 'boesi software tools', 'hro netz lager and auftragsabwicklung', '', 'v1.4.x', 'serial', 'ReD0c', '2006-12-31'),
(362, 'asso', 'asso compta', '', 'v1.00 build 130', 'serial', 'fLiToX', '2007-01-01'),
(363, 'objectrescue.com', 'photorescue', 'pro', 'v4.4.x', 'universalpatch', 'ReD0c', '2007-01-02'),
(364, 'rs soft', 'pc biorhythmus 32', '', 'v3.7.0.0', 'cracked', 'ReD0c', '2007-01-05'),
(365, 'jeroboam', 'jeroboam', '', 'v6.0x', 'serial', 'FleN', '2007-01-05'),
(366, 'mpicaud', 'calendrier automatique', '', 'v5.30', 'serial', 'FleN', '2007-01-05'),
(367, 'objectrescue.com', 'mediarescue', 'pro', 'v4.4.x', 'universalpatch', 'ReD0c', '2007-01-06'),
(368, 'webtweaktools.net', 'fast link checker', '', 'v1.5.0.568', 'cracked', 'ReD0c', '2007-01-06'),
(369, 'objectrescue.com', 'documentsrescue', 'pro', 'v4.4.x', 'universalpatch', 'ReD0c', '2007-01-07'),
(370, 'objectrescue.com', 'objectrescue', 'pro', 'v4.4.x', 'universalpatch', 'ReD0c', '2007-01-07'),
(371, 'objectrescue.com', 'easy photo recovery', '', 'v1.3.x', 'universalpatch', 'ReD0c', '2007-01-07'),
(372, 'emailarms', 'best smtp server', '', 'v2.2', 'universalpatch', 'fLiToX', '2007-01-09'),
(373, 'smart caisse', 'belgique smart caisse full', 'pro', 'v1.01', 'cracked', 'keygen', '2007-01-09'),
(374, 'smart caisse', 'boulangerie smart caisse full', 'pro', 'v1.01', 'cracked', 'fLiToX', '2007-01-09'),
(375, 'smart caisse', 'canada smart caisse full', 'pro', 'v2.00', 'cracked', 'fLiToX', '2007-01-09'),
(376, 'smart caisse', 'smart caisse full', 'pro', 'v1.01', 'cracked', 'fLiToX', '2007-01-09'),
(377, 'smart caisse', 'suisse smart caisse full', 'pro', 'v1.01', 'cracked', 'fLiToX', '2007-01-09'),
(378, 'objectrescue.com', 'file rescue for ntfs', '', 'v2.6.x', 'universalpatch', 'ReD0c', '2007-01-10'),
(379, 'respect soft', 'weather alarm clock', '', 'v1.5.x', 'universalpatch', 'ReD0c', '2007-01-10'),
(380, 'objectrescue.com', 'filerescue for fat', '', 'v2.6.x', 'universalpatch', 'ReD0c', '2007-01-11'),
(381, 'in media kg', 'diashow generator slideshow', 'pro', 'v9.8.x', 'universalpatch', 'ReD0c', '2007-01-12'),
(382, 'in media kg', 'fotoworks', '', 'v9.4.x', 'universalpatch', 'ReD0c', '2007-01-12'),
(383, 'in media kg', 'promoware', '', 'v9.5.x', 'universalpatch', 'ReD0c', '2007-01-12'),
(384, 'in media kg', 'fotoarchiv', 'plus', 'v5.6.x', 'universalpatch', 'ReD0c', '2007-01-13'),
(385, 'in media kg', 'profisubmit', '', 'v9.5.x', 'universalpatch', 'ReD0c', '2007-01-13'),
(386, 'in media kg', 'linktausch', 'pro', 'v1.1.x', 'universalpatch', 'ReD0c', '2007-01-13'),
(387, 'in media kg', 'intelligent shutdown', '', 'v1.3.x', 'universalpatch', 'ReD0c', '2007-01-13'),
(388, 'in media kg', 'datenbank software abetone', '', 'v7.2.x', 'universalpatch', 'ReD0c', '2007-01-14'),
(389, 'in media kg', 'mailout enterprise', '', 'v9.9.x', 'universalpatch', 'ReD0c', '2007-01-14'),
(390, 'in media kg', 'newsletter designer', 'pro', 'v9.5.x', 'universalpatch', 'ReD0c', '2007-01-14'),
(391, 'in media kg', 'serienbrief software abetone', '', 'v7.2.x', 'universalpatch', 'ReD0c', '2007-01-14'),
(392, 'jlf', 'cheques editor', '', 'v5.00', 'serial', 'FleN', '2007-01-14'),
(393, 'comptin', 'comptin', '', 'v4.2.0', 'serial', 'FleN', '2007-01-15'),
(394, 'tennyson maxwell information systems', 'teleport', 'pro', 'v1.4.3', 'universalpatch', 'ReD0c', '2007-01-16'),
(395, 'big informatique', 'win star', '', 'v1.0', 'serial', 'fLiToX', '2007-01-17'),
(396, 'objectrescue.com', 'filerescue professional', '', 'v2.6.x', 'universalpatch', 'ReD0c', '2007-01-21'),
(397, 'objectrescue.com', 'object wipe', '', 'v1.5.x', 'universalpatch', 'ReD0c', '2007-01-24'),
(398, 'sowsoft', 'effective file search', '', 'v4.3', 'cracked', 'FleN', '2007-01-27'),
(399, 'pablo solutions', 'wysiwyg web builder', '', 'v4.07', 'cracked', 'FleN', '2007-02-01'),
(400, 'ccla', 'music mixer', 'fr, en', 'v4.0.x', 'serial', 'FleN', '2007-02-02'),
(401, 'ccla', 'photo mixer', 'fr, en', 'v3.0.x', 'patch', 'FleN', '2007-02-03'),
(402, 'objectrescue.com', 'grandbackup', 'personal', 'v1.1 build 428', 'cracked', 'FleN', '2007-02-05'),
(403, 'tibo', 'jigs@w puzzle', 'all puzzles', 'v2.26', 'cracked', 'FleN', '2007-02-07'),
(404, 'stenzel ing', 'sd reisekosten fahrtenbuch', 'estg', 'v2007', 'patch', 'ReD0c', '2007-02-15'),
(405, 'all for mp3', 'audio mp3 converter', '', 'v2.42', 'serial', 'fLiToX', '2007-02-15'),
(406, 'mpicaud', 'calendrier automatique', '', 'v5.33', 'serial', 'fLiToX', '2007-02-15'),
(407, 'd ch', 'motamo', 'fevrier 2007', 'n/a', 'patch', 'FleN', '2007-02-16'),
(408, 'd ch', 'super sokoban', 'fevrier 2007', 'v1.1', 'patch', 'FleN', '2007-02-16'),
(409, 'static', 'static', 'demo', 'v1.3.5', 'patch', 'FleN', '2007-02-16'),
(410, 'inge beyer', 'picture kit', 'de', 'v1.x', 'universalpatch', 'ReD0c', '2007-02-19'),
(411, 'inge beyer', 'synchronizer', 'de', 'v1.x', 'universalpatch', 'ReD0c', '2007-02-20'),
(412, 'inge beyer', 'bel plan', 'de', 'v4.3.x', 'universalpatch', 'ReD0c', '2007-02-21'),
(413, 'inge beyer', 'wand kalender', 'de', 'v2.3.x', 'universalpatch', 'ReD0c', '2007-02-22'),
(414, 'makeittrue', 'make your album', '', 'v1.2.4.x', 'patch', 'ReD0c', '2007-02-23'),
(415, 'pc privacy software', 'registry rescue', '', 'v3.0.0.0', 'cracked', 'ReD0c', '2007-03-08'),
(416, 'fresh devices', 'fresh diagnose', '', 'v7.54.0.0', 'cracked', 'ReD0c', '2007-03-09'),
(417, 'pc privacy software', 'wiper wizard', '', 'v2.80.0.0', 'cracked', 'ReD0c', '2007-03-10'),
(418, 'pc privacy software', 'ads alert', '', 'v3.0.0.0', 'cracked', 'ReD0c', '2007-03-13'),
(419, 'pc privacy software', 'spam sweeper', '', 'v3.40.0.0', 'cracked', 'ReD0c', '2007-03-14'),
(420, 'in media kg', '1x amp', 'de en', 'v2.2.2', 'patch', 'ReD0c', '2007-03-22'),
(421, 'csfsoftware', 'teachers personal information manager', '', 'v2.0.0.4', 'patch', 'ReD0c', '2007-04-30');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;