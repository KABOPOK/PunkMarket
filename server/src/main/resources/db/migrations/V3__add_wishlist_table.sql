CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE IF NOT EXISTS users (
                                     user_id UUID PRIMARY KEY,
                                     number TEXT UNIQUE NOT NULL,
                                     password TEXT NOT NULL,
                                     user_name TEXT NOT NULL,
                                     photo_url TEXT,
                                     location TEXT,
                                     telegram_id TEXT
);
CREATE TABLE IF NOT EXISTS products (
                                        product_id UUID PRIMARY KEY,
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
                                     chat_id UUID PRIMARY KEY,
                                     other_name TEXT NOT NULL,
                                     other_photo_url TEXT,
                                     other_chat_id UUID NOT NULL,
                                     user_id UUID NOT NULL,
                                     FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
CREATE TABLE IF NOT EXISTS messages (
                                        message_id UUID PRIMARY KEY,
                                        text TEXT NOT NULL,
                                        time TIMESTAMP NOT NULL,
                                        chat_id UUID NOT NULL,
                                        user_id UUID NOT NULL,
                                        FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
CREATE TABLE IF NOT EXISTS users_products (
                                        user_id UUID NOT NULL,
                                        product_id UUID NOT NULL,
                                        primary key (user_id, product_id),
                                        FOREIGN KEY (user_id) REFERENCES users(user_id),
                                        FOREIGN KEY (product_id) REFERENCES products(product_id)
    );