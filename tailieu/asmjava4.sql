CREATE DATABASE asmjava4
GO
USE asmjava4
GO

CREATE TABLE [User] (
    Id VARCHAR(50) PRIMARY KEY,
    Password VARCHAR(100),
    Email VARCHAR(100),
    Fullname NVARCHAR(100),
    Admin BIT
)

CREATE TABLE Video (
    Id VARCHAR(50) PRIMARY KEY,
    Title NVARCHAR(200),
    Poster NVARCHAR(200),
    Views INT,
    Description NVARCHAR(MAX),
    Active BIT
)

CREATE TABLE Favorite (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    UserId VARCHAR(50),
    VideoId VARCHAR(50),
    LikeDate DATE,
    FOREIGN KEY (UserId) REFERENCES [User](Id),
    FOREIGN KEY (VideoId) REFERENCES Video(Id)
)

CREATE TABLE Share (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    UserId VARCHAR(50),
    VideoId VARCHAR(50),
    Emails VARCHAR(500),
    ShareDate DATE,
    FOREIGN KEY (UserId) REFERENCES [User](Id),
    FOREIGN KEY (VideoId) REFERENCES Video(Id)
)

INSERT INTO [User] VALUES
('admin', '123', 'admin@email.com', N'Quản trị viên', 1),
('user', '123', 'user@email.com', N'Người dùng thường', 0)

INSERT INTO Video VALUES
('v01', N'Video A', 'poster1.jpg', 100, N'Mô tả A', 1),
('v02', N'Video B', 'poster2.jpg', 150, N'Mô tả B', 1),
('v03', N'Video C', 'poster3.jpg', 200, N'Mô tả C', 1),
('v04', N'Video D', 'poster4.jpg', 250, N'Mô tả D', 1),
('v05', N'Video E', 'poster5.jpg', 300, N'Mô tả E', 1),
('v06', N'Video F', 'poster6.jpg', 350, N'Mô tả F', 1),
('v07', N'Video G', 'poster7.jpg', 400, N'Mô tả G', 1),
('v08', N'Video H', 'poster8.jpg', 450, N'Mô tả H', 1),
('v09', N'Video I', 'poster9.jpg', 500, N'Mô tả I', 1),
('v10', N'Video J', 'poster10.jpg', 550, N'Mô tả J', 0)

INSERT INTO Favorite(UserId, VideoId, LikeDate) VALUES
('user', 'v01', '2025-07-01'),
('user', 'v02', '2025-07-02'),
('admin', 'v03', '2025-07-03'),
('admin', 'v04', '2025-07-04'),
('user', 'v05', '2025-07-05'),
('admin', 'v06', '2025-07-06'),
('user', 'v07', '2025-07-07'),
('admin', 'v08', '2025-07-08'),
('user', 'v09', '2025-07-09'),
('admin', 'v10', '2025-07-10')

INSERT INTO Share(UserId, VideoId, Emails, ShareDate) VALUES
('user', 'v01', 'a@example.com', '2025-07-01'),
('user', 'v02', 'b@example.com', '2025-07-02'),
('admin', 'v03', 'c@example.com', '2025-07-03'),
('admin', 'v04', 'd@example.com', '2025-07-04'),
('user', 'v05', 'e@example.com', '2025-07-05'),
('admin', 'v06', 'f@example.com', '2025-07-06'),
('user', 'v07', 'g@example.com', '2025-07-07'),
('admin', 'v08', 'h@example.com', '2025-07-08'),
('user', 'v09', 'i@example.com', '2025-07-09'),
('admin', 'v10', 'j@example.com', '2025-07-10')
