-- 1 up
CREATE TABLE IF NOT EXISTS users
(
    id_users bigserial NOT NULL PRIMARY KEY,
    username text not null,
    password text not null,
    fullname varchar(200) not null,
    status int not null
);

INSERT INTO users (username, password, fullname, status)
VALUES ('yusrideb', '123456', 'Yusrideb', 1);

-- 1 down
DROP TABLE users;
