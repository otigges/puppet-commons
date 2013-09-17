CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'laravel';  

CREATE DATABASE laravel DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci;   

GRANT ALL PRIVILEGES ON *.* TO 'laravel'@'localhost' WITH GRANT OPTION;  