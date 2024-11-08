CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE IF NOT EXISTS users (
                                     user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                     number TEXT UNIQUE NOT NULL,
                                     password TEXT NOT NULL,
                                     user_name TEXT NOT NULL,
                                     photo_url TEXT,
                                     location TEXT,
                                     telegram_id TEXT
);

CREATE TABLE IF NOT EXISTS products (
                                        product_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                        price TEXT NOT NULL,
                                        title TEXT NOT NULL,
                                        owner_name TEXT NOT NULL,
                                        photo_url TEXT,
                                        location TEXT,
                                        description TEXT,
                                        category TEXT,
                                        user_id UUID NOT NULL,
                                        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS chats (
                                     chat_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                     other_name TEXT NOT NULL,
                                     other_photo_url TEXT,
                                     other_chat_id UUID NOT NULL,
                                     user_id UUID NOT NULL,
                                     FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS messages (
                                        message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                        text TEXT NOT NULL,
                                        time TIMESTAMP NOT NULL,
                                        chat_id UUID NOT NULL,
                                        user_id UUID NOT NULL,
                                        FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE flyway_schema_history (
                                       installed_rank INT NOT NULL,
                                       version VARCHAR(50),
                                       description VARCHAR(200),
                                       type VARCHAR(20) NOT NULL,
                                       script VARCHAR(1000) NOT NULL,
                                       checksum INT,
                                       installed_by VARCHAR(100) NOT NULL,
                                       installed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                       execution_time INT NOT NULL,
                                       success BOOLEAN NOT NULL
);
