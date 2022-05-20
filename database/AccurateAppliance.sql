SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;

CREATE OR REPLACE TABLE `appliances` (
  `applianceID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `type` varchar(45) NOT NULL,
  `brand` varchar(45) NOT NULL,
  `modelNum` varchar(45) NOT NULL,
  `serialNum` varchar(45) NOT NULL,
  PRIMARY KEY (applianceID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `appliances` (`applianceID`, `type`, `brand`, `modelNum`, `serialNum`) VALUES
(1, 'Fridge', 'Whirlpool', 'WRX735SDHZ', 'SE38427'),
(2, 'Washer', 'Samsung', 'WF45T6000AW', 'SE889923'),
(3, 'Dryer', 'GE', 'GTD42EASJWW', 'SE4898227'),
(4, 'Range', 'Hotpoint', 'RBS330DRWW', 'SE09972');

CREATE OR REPLACE TABLE `customers` (
  `customerID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `totalBought` decimal(9,2) DEFAULT 0.00,
  `totalRepaired` decimal(9,2) DEFAULT 0.00,
  PRIMARY KEY (customerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `customers` (`customerID`, `name`, `phone`, `totalBought`, `totalRepaired`) VALUES
(1, 'John Denver', '6185555555', '0.00', '0.00'),
(2, 'David Wallace', '5035555555', '0.00', '0.00'),
(3, 'Hillary Clinton', '2025555555', '0.00', '0.00'),
(4, 'Eddie George', '6155555555', '0.00', '0.00');


CREATE OR REPLACE TABLE `employees` (
  `employeeID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `employeeType` varchar(45) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `hourly` decimal(4,2) NOT NULL DEFAULT 15.00,
  `hoursWorked` int(11) NOT NULL DEFAULT 0,
  `doesRefrigerant` tinyint(1) NOT NULL DEFAULT 0,
  `totalRepaired` decimal(9,2) NOT NULL DEFAULT 0.00,
  `totalSold` decimal(9,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (employeeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `employees` (`employeeID`, `name`, `employeeType`, `phone`, `hourly`, `hoursWorked`, `doesRefrigerant`, `totalRepaired`, `totalSold`) VALUES
(1, 'Carl Orlonski', 'Repair', '3195555555', '20.00', 25, 1, '0.00', '0.00'),
(2, 'Patricia Orlonski', 'Sales', '6195555555', '20.00', 15, 0, '0.00', '0.00'),
(3, 'Sam Jackson', 'Repair', '7135555555', '18.00', 30, 0, '0.00', '0.00'),
(4, 'Shelly Johnson', 'Sales', '3135555555', '15.00', 21, 0, '0.00', '0.00');

CREATE OR REPLACE TABLE `employeesRepairs` (
  `employeesEmployeeID` int(11) NOT NULL,
  `repairsRepairID` int(11) NOT NULL,
  FOREIGN KEY (employeesEmployeeID) REFERENCES employees(employeeID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (repairsRepairID) REFERENCES repairs(repairID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `employeesRepairs` (`employeesEmployeeID`, `repairsRepairID`) VALUES
(1, 2),
(1, 3),
(3, 1);

CREATE OR REPLACE TABLE `parts` (
  `partID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `partNum` varchar(45) NOT NULL,
  `cost` decimal(6,2) NOT NULL,
  `partName` varchar(50) NOT NULL,
  PRIMARY KEY (partID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `parts` (`partID`, `partNum`, `cost`, `partName`) VALUES
(1, 'WPW1033', '19.95', 'Drain Pump'),
(2, 'WPW6832', '103.50', 'Control Board'),
(3, 'WPW38427', '25.00', 'Thermostat'),
(4, 'GE33992', '34.99', 'Timer');

CREATE OR REPLACE TABLE `repairs` (
  `repairID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `date` date NOT NULL,
  `cost` decimal(6,2) NOT NULL,
  `partsPartID` int(11) DEFAULT NULL,
  `customersCustomerID` int(11) NOT NULL,
  `appliancesApplianceID` int(11) NOT NULL,
  PRIMARY KEY (repairID),
  FOREIGN KEY (partsPartID) REFERENCES parts(partID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (customersCustomerID) REFERENCES customers(customerID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (appliancesApplianceID) REFERENCES appliances(applianceID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `repairs` (`repairID`, `date`, `cost`, `partsPartID`, `customersCustomerID`, `appliancesApplianceID`) VALUES
(1, '2022-04-19', '42.06', 1, 4, 1),
(2, '2022-04-08', '111.23', 4, 1, 3),
(3, '2022-04-05', '89.00', NULL, 4, 1);

CREATE OR REPLACE TABLE `sales` (
  `saleID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `date` date NOT NULL,
  `cost` decimal(7,2) NOT NULL,
  `customersCustomerID` int(11) NOT NULL,
  `partsPartID` int(11) DEFAULT NULL,
  `appliancesApplianceID` int(11) DEFAULT NULL,
  `employeesEmployeeID` int(11) NOT NULL,
  PRIMARY KEY (saleID),
  FOREIGN KEY (customersCustomerID) REFERENCES customers(customerID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (partsPartID) REFERENCES parts(partID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (appliancesApplianceID) REFERENCES appliances(applianceID) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (employeesEmployeeID) REFERENCES employees(employeeID) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `sales` (`saleID`, `date`, `cost`, `customersCustomerID`, `partsPartID`, `appliancesApplianceID`, `employeesEmployeeID`) VALUES
(1, '2022-04-01', '1099.00', 3, NULL, 2, 2),
(2, '2022-04-02', '3055.99', 4, NULL, 1, 3),
(3, '2022-04-21', '35.00', 2, 1, NULL, 1);

SET foreign_KEY_CHECKS=1;
COMMIT;
