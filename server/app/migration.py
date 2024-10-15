import uuid

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
# from flask import Flask
# from flask_sqlalchemy import SQLAlchemy
# from flask_migrate import Migrate
# from sqlalchemy.dialects.postgresql import VARCHAR, UUID, TIMESTAMP
# # Initialize Flask application
# app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:9@localhost:5432/postgres'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# 
# # Initialize database and migration
# db = SQLAlchemy(app)
# migrate = Migrate(app, db)
# 
# class User(db.Model):
#     __tablename__ = 'users'
# 
#     userID = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     number = db.Column(VARCHAR(15), nullable=False)
#     password = db.Column(VARCHAR(30), nullable=False)
#     userName = db.Column(VARCHAR(30), nullable=False)
#     photoUrl = db.Column(VARCHAR(100))
#     location = db.Column(VARCHAR(30))
#     telegram = db.Column(VARCHAR(30))
# 
#     def __repr__(self):
#         return f'<User {self.userName}>'
# 
# class Product(db.Model):
#     __tablename__ = 'products'
# 
#     productID = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     price = db.Column(VARCHAR(10), nullable=False)
#     title = db.Column(VARCHAR(30), nullable=False)
#     ownerName = db.Column(VARCHAR(30), nullable=False)
#     photoUrl = db.Column(VARCHAR(100))
#     location = db.Column(VARCHAR(30))
#     description = db.Column(VARCHAR(100))
#     category = db.Column(VARCHAR(30))
#     userID = db.Column(UUID(as_uuid=True), db.ForeignKey('users.userID'), nullable=False)
# 
#     def __repr__(self):
#         return f'<Product {self.title}>'
# 
# class Chat(db.Model):
#     __tablename__ = 'chats'
# 
#     chatID = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     otherName = db.Column(VARCHAR(50), nullable=False)
#     otherPhotoUrl = db.Column(VARCHAR(255))
#     otherChatID = db.Column(UUID(as_uuid=True), nullable=False)
#     userID = db.Column(UUID(as_uuid=True), db.ForeignKey('users.userID'), nullable=False)
# 
#     def __repr__(self):
#         return f'<Chat {self.chatID}>'
# 
# class Message(db.Model):
#     __tablename__ = 'messages'
# 
#     messageID = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     text = db.Column(VARCHAR, nullable=False)
#     time = db.Column(TIMESTAMP, nullable=False)
#     chatID = db.Column(UUID(as_uuid=True), nullable=False)
#     userID = db.Column(UUID(as_uuid=True), db.ForeignKey('users.userID'), nullable=False)
# 
#     def __repr__(self):
#         return f'<Message {self.messageID}>'

# Migration script using raw SQL


#
 # in massage VARCHAR change on text or something else
 # MAKE ON DELETE
#
def create_table(app):
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:9@localhost:5432/postgres'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db = SQLAlchemy(app)
    with app.app_context():
        db.session.execute(text("""
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

        CREATE TABLE IF NOT EXISTS users (
            userID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            number VARCHAR(15) NOT NULL,
            password VARCHAR(30) NOT NULL,
            userName VARCHAR(30) NOT NULL,
            photoUrl VARCHAR(100),
            location VARCHAR(30),
            telegramID VARCHAR(30)
        );

        CREATE TABLE IF NOT EXISTS products (
            productID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            price VARCHAR(10) NOT NULL,
            title VARCHAR(30) NOT NULL,
            ownerName VARCHAR(30) NOT NULL,
            photoUrl VARCHAR(100),
            location VARCHAR(30),
            description VARCHAR(100),
            category VARCHAR(30),
            userID UUID NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID)
        );

        CREATE TABLE IF NOT EXISTS chats (
            chatID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            otherName VARCHAR(50) NOT NULL,
            otherPhotoUrl VARCHAR(100),
            otherChatID UUID NOT NULL,
            userID UUID NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID)
        );

        CREATE TABLE IF NOT EXISTS messages (
            messageID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            text VARCHAR NOT NULL,
            time TIMESTAMP NOT NULL,
            chatID UUID NOT NULL,
            userID UUID NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID)
        );
        """))
        db.session.commit()

