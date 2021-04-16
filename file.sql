
CREATE TABLE `stock_entreprise` (
  `id` int(11) NOT NULL,
  `item` varchar(255) DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `nombre` int(11) DEFAULT NULL,
  `metier` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `stock_entreprise`
ADD PRIMARY KEY (`id`);

ALTER TABLE `stock_entreprise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
COMMIT;


CREATE TABLE `argent_entreprise` (
  `id` int(11) NOT NULL,
  `metier` varchar(50) DEFAULT '',
  `argentpropre` int(11) DEFAULT 0,
  `argentsale` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `argent_entreprise`
ADD PRIMARY KEY (`id`);


ALTER TABLE `argent_entreprise`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;