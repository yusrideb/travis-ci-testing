-- 1 up
CREATE TABLE IF NOT EXISTS `users`
(
    `id_users` int not null auto_increment primary key,
    `username` text not null,
    `password` text not null,
    `fullname` varchar(200) not null,
    `status` int not null
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

INSERT INTO `users` (username, password, fullname, status)
VALUES ('yusrideb', '123456', 'Yusrideb', 1);

-- 1 down
DROP TABLE `users`;
