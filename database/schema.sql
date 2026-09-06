-- ===================================================================
-- Script tao bang cho project jpa_api
-- Database: jakartaJPA (SQL Server)
-- Chay bang sqlcmd hoac SSMS
-- ===================================================================

-- Su dung database
USE jakartaJPA;
GO

-- ===================================================================
-- BANG CATEGORIES (phai tao truoc products vi co foreign key)
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='categories' AND xtype='U')
CREATE TABLE categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    description NVARCHAR(500) NULL,
    Images NVARCHAR(500) NULL,
    status INT DEFAULT 1,
    createdAt DATETIME DEFAULT GETDATE()
);
GO

-- ===================================================================
-- BANG USERS
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(200) NOT NULL,    -- Luu dang hash (SHA-256 + salt), can nhieu ky tu hon
    fullname NVARCHAR(100),
    email NVARCHAR(100),
    isActive BIT DEFAULT 0,
    otp NVARCHAR(10) NULL,
    otpExpiredAt BIGINT NULL,           -- Epoch millis
    otpType NVARCHAR(20) NULL           -- ACTIVATION hoac RESET_PASSWORD
);
GO

-- ===================================================================
-- BANG PRODUCTS
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='products' AND xtype='U')
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    price FLOAT NOT NULL,
    quantity INT DEFAULT 0,
    description NVARCHAR(MAX) NULL,
    image NVARCHAR(500) NULL,
    createdDate DATETIME DEFAULT GETDATE(),
    updatedDate DATETIME NULL,
    CategoryId INT NULL,
    CONSTRAINT FK_products_categories FOREIGN KEY (CategoryId) REFERENCES categories(CategoryId)
);
GO

-- ===================================================================
-- BANG VIDEOS (da co san trong project)
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Videos' AND xtype='U')
CREATE TABLE Videos (
    VideoId NVARCHAR(50) PRIMARY KEY,
    Active INT DEFAULT 1,
    Description NVARCHAR(500) NULL,
    Poster NVARCHAR(500) NULL,
    Title NVARCHAR(500) NULL,
    Views INT DEFAULT 0,
    CategoryId INT NULL,
    CONSTRAINT FK_videos_categories FOREIGN KEY (CategoryId) REFERENCES categories(CategoryId)
);
GO

-- ===================================================================
-- DU LIEU MAU
-- ===================================================================

-- Categories mau
IF NOT EXISTS (SELECT 1 FROM categories)
BEGIN
    INSERT INTO categories (CategoryName, description, Images, status) VALUES
    ('Dien thoai', 'Cac loai dien thoai thong minh', 'phone.jpg', 1),
    ('Laptop', 'Cac loai may tinh xach tay', 'laptop.jpg', 1),
    ('Phu kien', 'Phu kien dien tu', 'accessory.jpg', 1);
END
GO

-- Users mau (password da hash bang SHA-256 + salt)
-- Luu y: khi chay lan dau, user mau dung password plaintext
-- De test nhanh, ban co the dang ky user moi qua form Register
IF NOT EXISTS (SELECT 1 FROM users)
BEGIN
    -- Password: admin123 (da hash SHA-256 + salt)
    INSERT INTO users (username, password, fullname, email, isActive) VALUES
    ('admin', 'yqDlW9IXEoEt49nQae36xg==:gbFPlQYuAzHwgk8GcTJyezH456nzaWUCL6Hei3wT/HE=', 'Admin User', 'admin@example.com', 1);
END
GO

-- Products mau
IF NOT EXISTS (SELECT 1 FROM products)
BEGIN
    INSERT INTO products (name, price, quantity, description, CategoryId) VALUES
    ('iPhone 15', 25000000, 5, 'Apple iPhone 15 128GB', 1),
    ('Samsung Galaxy S24', 20000000, 8, 'Samsung Galaxy S24 Ultra', 1),
    ('Laptop Dell Inspiron', 15000000, 10, 'Laptop Dell Inspiron 15 inch', 2),
    ('MacBook Air M2', 28000000, 3, 'Apple MacBook Air M2 13 inch', 2),
    ('Tai nghe AirPods', 4500000, 20, 'Apple AirPods Pro 2nd Gen', 3),
    ('Sac nhanh 65W', 500000, 50, 'Cu sac nhanh 65W GaN', 3);
END
GO

-- ===================================================================
-- MIGRATION: Them cot moi neu bang da ton tai tu truoc
-- (Danh cho truong hop chay tren DB cu)
-- ===================================================================

-- Them cot OTP moi cho users
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'isActive')
    ALTER TABLE users ADD isActive BIT DEFAULT 0;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'otp')
    ALTER TABLE users ADD otp NVARCHAR(10) NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'otpExpiredAt')
    ALTER TABLE users ADD otpExpiredAt BIGINT NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'otpType')
    ALTER TABLE users ADD otpType NVARCHAR(20) NULL;
GO

-- Xoa cot cu otpExpiry neu ton tai (doi sang otpExpiredAt)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'otpExpiry')
    ALTER TABLE users DROP COLUMN otpExpiry;
GO

-- Them cot cho Products
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('products') AND name = 'image')
    ALTER TABLE products ADD image NVARCHAR(500) NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('products') AND name = 'createdDate')
    ALTER TABLE products ADD createdDate DATETIME DEFAULT GETDATE();
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('products') AND name = 'updatedDate')
    ALTER TABLE products ADD updatedDate DATETIME NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('products') AND name = 'CategoryId')
    ALTER TABLE products ADD CategoryId INT NULL;
GO

-- Them cot cho Categories
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('categories') AND name = 'description')
    ALTER TABLE categories ADD description NVARCHAR(500) NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('categories') AND name = 'createdAt')
    ALTER TABLE categories ADD createdAt DATETIME DEFAULT GETDATE();
GO

-- Tang do dai cot password de chua hash
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'password')
BEGIN
    ALTER TABLE users ALTER COLUMN password NVARCHAR(200) NOT NULL;
END
GO

-- Foreign key (neu chua co)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_products_categories')
    ALTER TABLE products ADD CONSTRAINT FK_products_categories 
    FOREIGN KEY (CategoryId) REFERENCES categories(CategoryId);
GO

PRINT 'Schema update hoan tat!';
GO
