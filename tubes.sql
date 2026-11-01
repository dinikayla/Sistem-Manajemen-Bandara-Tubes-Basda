DROP DATABASE IF EXISTS db_manajemen_bandara;
CREATE DATABASE IF NOT EXISTS db_manajemen_bandara;
USE db_manajemen_bandara;
 
CREATE TABLE terminal (
    terminal_id INT PRIMARY KEY,
    terminal_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
 
CREATE TABLE airline (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL,
    country VARCHAR(100)
);
 
CREATE TABLE passenger (
    passenger_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    passport_number VARCHAR(20),
    nationality VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);
 
CREATE TABLE gate (
    gate_id INT PRIMARY KEY,
    terminal_id INT,
    gate_number VARCHAR(10) NOT NULL,
    capacity INT,
    status VARCHAR(20) NOT NULL DEFAULT 'Tersedia',
    FOREIGN KEY (terminal_id)
        REFERENCES terminal(terminal_id)
);
 
CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    terminal_id INT,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    shift VARCHAR(20),
    FOREIGN KEY (terminal_id)
        REFERENCES terminal(terminal_id)
);
 
CREATE TABLE flight (
    flight_id INT PRIMARY KEY,
    airline_id INT,
    gate_id INT,
    flight_number VARCHAR(20) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Terjadwal',
    FOREIGN KEY (airline_id)
        REFERENCES airline(airline_id),
    FOREIGN KEY (gate_id)
        REFERENCES gate(gate_id)
);
 
CREATE TABLE booking (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    booking_code VARCHAR(20) NOT NULL,
    booking_date DATE NOT NULL,
    total_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (passenger_id)
        REFERENCES passenger(passenger_id),
    FOREIGN KEY (flight_id)
        REFERENCES flight(flight_id)
);
 
-- booking_id dibuat UNIQUE agar relasi Booking - Boarding_Pass bersifat 1:1
CREATE TABLE boarding_pass (
    bp_id INT PRIMARY KEY,
    booking_id INT UNIQUE,
    passenger_id INT,
    flight_id INT,
    staff_id INT,
    seat_number VARCHAR(5),
    `class` VARCHAR(20),
    issued_at DATETIME,
    status VARCHAR(20) NOT NULL DEFAULT 'Check-in',
    FOREIGN KEY (booking_id)
        REFERENCES booking(booking_id),
    FOREIGN KEY (passenger_id)
        REFERENCES passenger(passenger_id),
    FOREIGN KEY (flight_id)
        REFERENCES flight(flight_id),
    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
);
 
CREATE TABLE baggage (
    baggage_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    rfid_tag VARCHAR(30),
    weight DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (passenger_id)
        REFERENCES passenger(passenger_id),
    FOREIGN KEY (flight_id)
        REFERENCES flight(flight_id)
);
 
# ALTER: Mengubah ukuran tipe data kolom location
ALTER TABLE terminal
MODIFY location VARCHAR(150);
# ALTER: Menambahkan kolom sementara
ALTER TABLE terminal
ADD description VARCHAR(100);
# Menampilkan struktur tabel
DESCRIBE terminal;
 
INSERT INTO terminal (terminal_id, terminal_name, location, description) VALUES
(1, 'Terminal Keberangkatan', 'Gedung A Lantai 1, Bengkulu', 'Pelayanan check-in dan boarding'),
(2, 'Terminal Kedatangan',    'Gedung A Lantai 2, Bengkulu', 'Pelayanan penumpang datang'),
(3, 'Terminal Kargo',         'Gedung B Lantai 1, Bengkulu', 'Pengelolaan bagasi dan kargo');
SELECT * FROM terminal;
 
INSERT INTO airline (airline_id, airline_name, country) VALUES
(1, 'Garuda Indonesia', 'Indonesia'),
(2, 'Citilink',         'Indonesia'),
(3, 'Lion Air',         'Indonesia'),
(4, 'Batik Air',        'Indonesia');
SELECT * FROM airline;
 
INSERT INTO passenger (passenger_id, full_name, passport_number, nationality, email, phone) VALUES
(1, 'BangChan',    'A1234501', 'Indonesia', 'chanie@mail.com',   '081234567801'),
(2, 'Soyeon',    'A1234502', 'Indonesia', 'gidle@mail.com',   '081234567802'),
(3, 'Miguel Mora',   'A1234503', 'Indonesia', 'miguel@mail.com',  '081234567803'),
(4, 'Walker Scobbel',  'A1234504', 'Indonesia', 'scooba@mail.com',   '081234567804'),
(5, 'Finn Wolfhard',    'A1234505', 'Indonesia', 'noah@mail.com',    '081234567805'),
(6, 'Caroline Harvey',    'S9876506', 'Singapura', 'khveyy@mail.com','081234567806'),
(7, 'Shane Hollander',     'P5551207', 'Australia', 'ilya@mail.com',   '081234567807'),
(8, 'Deena',    'A1234508', 'Indonesia', 'sam@mail.com',   '081234567808');
SELECT * FROM passenger;
 
INSERT INTO gate (gate_id, terminal_id, gate_number, capacity, status) VALUES
(1, 1, 'A1', 150, 'Digunakan'),
(2, 1, 'A2', 150, 'Tersedia'),
(3, 1, 'A3', 100, 'Tersedia'),
(4, 2, 'B1', 200, 'Digunakan'),
(5, 3, 'C1',  50, 'Perawatan');
SELECT * FROM gate;
 
INSERT INTO staff (staff_id, terminal_id, staff_name, role, shift) VALUES
(101, 1, 'Dini Kayla',       'Check-in Agent',  'Pagi'),
(102, 1, 'Fadhil',    'Check-in Agent',  'Siang'),
(103, 1, 'Nnaufal',    'Boarding Staff',  'Pagi'),
(104, 1, 'Alghani Akbar',  'Boarding Staff',  'Siang'),
(105, 3, 'Haris Marvela',     'Baggage Handler', 'Pagi'),
(106, 3, 'Lina Marlina',    'Baggage Handler', 'Malam'),
(107, 2, 'Fajar Nugroho',   'Check-in Agent',  'Pagi'),
(108, 2, 'Olivia',      'Boarding Staff',  'Malam');
SELECT * FROM staff;
 
INSERT INTO flight (flight_id, airline_id, gate_id, flight_number, departure_time, arrival_time, status) VALUES
(201, 1, 1, 'GA-420',  '2026-11-05 07:30:00', '2026-11-05 09:00:00', 'Terjadwal'),
(202, 2, 2, 'QG-901',  '2026-11-05 10:15:00', '2026-11-05 11:45:00', 'Terjadwal'),
(203, 3, 3, 'JT-310',  '2026-11-05 13:00:00', '2026-11-05 14:30:00', 'Terjadwal'),
(204, 4, 4, 'ID-6840', '2026-11-06 08:00:00', '2026-11-06 09:05:00', 'Tertunda'),
(205, 1, 1, 'GA-421',  '2026-11-06 16:00:00', '2026-11-06 17:30:00', 'Terjadwal');
SELECT * FROM flight;
 
INSERT INTO booking (booking_id, passenger_id, flight_id, booking_code, booking_date, total_price, payment_status) VALUES
(1001, 1, 201, 'BK-0001', '2026-10-20', 1250000.00, 'Lunas'),
(1002, 2, 201, 'BK-0002', '2026-10-20', 1250000.00, 'Lunas'),
(1003, 3, 201, 'BK-0003', '2026-10-21', 2800000.00, 'Lunas'),
(1004, 4, 202, 'BK-0004', '2026-10-22',  900000.00, 'Lunas'),
(1005, 5, 203, 'BK-0005', '2026-10-22',  950000.00, 'Lunas'),
(1006, 6, 203, 'BK-0006', '2026-10-23',  950000.00, 'Lunas'),
(1007, 7, 204, 'BK-0007', '2026-10-23',  700000.00, 'Lunas'),
(1008, 8, 205, 'BK-0008', '2026-10-24', 1300000.00, 'Pending'),
(1009, 2, 205, 'BK-0009', '2026-10-25', 1300000.00, 'Pending');
SELECT * FROM booking;
 
INSERT INTO boarding_pass (bp_id, booking_id, passenger_id, flight_id, staff_id, seat_number, `class`, issued_at, status) VALUES
(1, 1001, 1, 201, 101, '12A', 'Ekonomi', '2026-11-05 05:30:00', 'Check-in'),
(2, 1002, 2, 201, 101, '12B', 'Ekonomi', '2026-11-05 05:35:00', 'Check-in'),
(3, 1003, 3, 201, 102, '2A',  'Bisnis',  '2026-11-05 05:40:00', 'Boarding'),
(4, 1004, 4, 202, 102, '15C', 'Ekonomi', '2026-11-05 08:20:00', 'Check-in'),
(5, 1005, 5, 203, 103, '7A',  'Ekonomi', '2026-11-05 11:00:00', 'Check-in'),
(6, 1006, 6, 203, 103, '7B',  'Ekonomi', '2026-11-05 11:05:00', 'Check-in'),
(7, 1007, 7, 204, 104, '3A',  'Ekonomi', '2026-11-06 06:00:00', 'Check-in');
SELECT * FROM boarding_pass;
 
INSERT INTO baggage (baggage_id, passenger_id, flight_id, rfid_tag, weight) VALUES
(1, 1, 201, 'RFID-0001', 15.50),
(2, 2, 201, 'RFID-0002', 10.00),
(3, 3, 201, 'RFID-0003', 22.75),
(4, 5, 203, 'RFID-0004', 18.20),
(5, 6, 203, 'RFID-0005', 12.30),
(6, 8, 205, 'RFID-0006',  9.80);
SELECT * FROM baggage;
 
UPDATE booking
SET total_price = total_price * 1.10
WHERE flight_id = 204;
SELECT * FROM booking;
 
UPDATE flight
SET status = 'Boarding'
WHERE flight_id = 201;
SELECT * FROM flight;
 
# 1. Hapus dulu bagasi milik penumpang 8
DELETE FROM baggage
WHERE passenger_id = 8;
# 2. Hapus boarding pass milik penumpang 8
DELETE FROM boarding_pass
WHERE passenger_id = 8;
# 3. Hapus data booking milik penumpang 8
DELETE FROM booking
WHERE passenger_id = 8;
# 4. Terakhir, hapus data penumpangnya
DELETE FROM passenger
WHERE passenger_id = 8;
# 5. Tampilkan tabel passenger terbaru
SELECT * FROM passenger;
 
# implementasi operasi JOIN
SELECT p.full_name,
       b.booking_code,
       f.flight_number,
       a.airline_name,
       t.terminal_name,
       g.gate_number,
       bp.seat_number,
       bp.`class`,
       s.staff_name AS petugas_validasi
FROM boarding_pass bp
JOIN booking b    ON bp.booking_id = b.booking_id
JOIN passenger p  ON bp.passenger_id = p.passenger_id
JOIN flight f     ON bp.flight_id = f.flight_id
JOIN airline a    ON f.airline_id = a.airline_id
JOIN gate g       ON f.gate_id = g.gate_id
JOIN terminal t   ON g.terminal_id = t.terminal_id
JOIN staff s      ON bp.staff_id = s.staff_id;
 
# LEFT JOIN: semua booking beserta boarding pass-nya (yang belum terbit tetap tampil)
SELECT b.booking_code,
       b.payment_status,
       bp.bp_id,
       bp.seat_number
FROM booking b
LEFT JOIN boarding_pass bp ON b.booking_id = bp.booking_id;
 
# Query penggunaan Alias dan Operator SQL (Aritmatika, Perbandingan, Logika, BETWEEN, IN)
SELECT b.booking_id                              AS id,
       p.full_name                               AS nama,
       f.flight_number                           AS penerbangan,
       b.total_price                             AS harga,
       (b.total_price * 0.11)                    AS ppn,
       (b.total_price + b.total_price * 0.11)    AS total_bayar,
       ROUND(b.total_price / 1000000, 2)         AS harga_juta
FROM booking b
JOIN passenger p ON b.passenger_id = p.passenger_id
JOIN flight f    ON b.flight_id = f.flight_id
WHERE b.total_price BETWEEN 700000 AND 3000000
  AND f.status IN ('Terjadwal', 'Tertunda', 'Boarding')
  AND b.payment_status = 'Lunas'
ORDER BY total_bayar DESC;
 
-- Menghitung jumlah booking, rata-rata harga, dan total pendapatan per maskapai
SELECT a.airline_name,
       COUNT(b.booking_id) AS total_booking,
       AVG(b.total_price)  AS rata_rata_harga,
       SUM(b.total_price)  AS total_pendapatan
FROM airline a
JOIN flight f  ON a.airline_id = f.airline_id
JOIN booking b ON f.flight_id = b.flight_id
GROUP BY a.airline_name
ORDER BY total_pendapatan DESC;
 
-- Bagasi terberat dan teringan per penerbangan (GROUP BY + HAVING)
SELECT f.flight_number,
       COUNT(bg.baggage_id) AS jumlah_bagasi,
       MAX(bg.weight)       AS bagasi_terberat,
       MIN(bg.weight)       AS bagasi_teringan
FROM flight f
JOIN baggage bg ON f.flight_id = bg.flight_id
GROUP BY f.flight_number
HAVING COUNT(bg.baggage_id) >= 2
ORDER BY bagasi_terberat DESC;
 
-- 1. Membuat akun pengguna (user) baru
DROP USER IF EXISTS 'petugas_checkin'@'localhost';
CREATE USER 'petugas_checkin'@'localhost' IDENTIFIED BY 'PasswordCheckin123!';
 
-- 2. Memberikan hak akses (GRANT)
GRANT SELECT, INSERT, UPDATE ON db_manajemen_bandara.boarding_pass TO 'petugas_checkin'@'localhost';
GRANT SELECT ON db_manajemen_bandara.flight TO 'petugas_checkin'@'localhost';
 
-- 3. Memuat ulang hak akses
FLUSH PRIVILEGES;
 
-- 4. Mencabut hak akses tertentu (REVOKE)
REVOKE UPDATE ON db_manajemen_bandara.boarding_pass FROM 'petugas_checkin'@'localhost';
FLUSH PRIVILEGES;
 
-- Membuat view untuk rekapitulasi boarding pass lengkap
CREATE OR REPLACE VIEW v_rekap_boarding_pass AS
SELECT bp.bp_id,
       bp.issued_at,
       p.full_name,
       b.booking_code,
       f.flight_number,
       a.airline_name,
       t.terminal_name,
       g.gate_number,
       bp.seat_number,
       bp.`class`,
       bp.status,
       s.staff_name AS petugas_validasi
FROM boarding_pass bp
JOIN booking b    ON bp.booking_id = b.booking_id
JOIN passenger p  ON bp.passenger_id = p.passenger_id
JOIN flight f     ON bp.flight_id = f.flight_id
JOIN airline a    ON f.airline_id = a.airline_id
JOIN gate g       ON f.gate_id = g.gate_id
JOIN terminal t   ON g.terminal_id = t.terminal_id
JOIN staff s      ON bp.staff_id = s.staff_id;
 
-- Cara memanggil / mengeksekusi VIEW:
SELECT * FROM v_rekap_boarding_pass WHERE airline_name = 'Garuda Indonesia';
 
-- Stored Procedure 1: menampilkan daftar penumpang pada satu penerbangan
DROP PROCEDURE IF EXISTS sp_daftar_penumpang_penerbangan;
CREATE PROCEDURE sp_daftar_penumpang_penerbangan(IN p_flight_id INT)
SELECT p.full_name,
       b.booking_code,
       bp.seat_number,
       bp.`class`,
       bp.status
FROM boarding_pass bp
JOIN passenger p ON bp.passenger_id = p.passenger_id
JOIN booking b   ON bp.booking_id = b.booking_id
WHERE bp.flight_id = p_flight_id
ORDER BY bp.seat_number;
 
-- Stored Procedure 2: mengubah status penerbangan
DROP PROCEDURE IF EXISTS sp_ubah_status_penerbangan;
CREATE PROCEDURE sp_ubah_status_penerbangan(IN p_flight_id INT, IN p_status VARCHAR(20))
UPDATE flight
SET status = p_status
WHERE flight_id = p_flight_id;
 
-- Cara memanggil Stored Procedure:
CALL sp_daftar_penumpang_penerbangan(201);
CALL sp_ubah_status_penerbangan(204, 'Terjadwal');
SELECT * FROM flight;
 
-- Membuat tabel untuk mencatat aktivitas penghapusan penumpang
CREATE TABLE IF NOT EXISTS log_passenger (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    full_name VARCHAR(100),
    aksi VARCHAR(20),
    waktu_eksekusi DATETIME
);
 
-- TRIGGER 1: Mencatat penumpang yang dihapus
DROP TRIGGER IF EXISTS trg_after_delete_passenger;
CREATE TRIGGER trg_after_delete_passenger
AFTER DELETE ON passenger
FOR EACH ROW
INSERT INTO log_passenger
(passenger_id, full_name, aksi, waktu_eksekusi)
VALUES
(OLD.passenger_id, OLD.full_name, 'DELETE', NOW());
 
-- TRIGGER 2: Menambah biaya kelebihan bagasi (di atas 20 kg, Rp 50.000 per kg) ke total_price booking
DROP TRIGGER IF EXISTS trg_after_insert_baggage;
CREATE TRIGGER trg_after_insert_baggage
AFTER INSERT ON baggage
FOR EACH ROW
UPDATE booking b
SET b.total_price = b.total_price + ((NEW.weight - 20) * 50000)
WHERE b.passenger_id = NEW.passenger_id
  AND b.flight_id = NEW.flight_id
  AND NEW.weight > 20;
 
-- Nested query: penumpang dengan booking di atas rata-rata harga
SELECT p.full_name,
       b.booking_code,
       f.flight_number,
       b.total_price
FROM booking b
JOIN passenger p ON b.passenger_id = p.passenger_id
JOIN flight f    ON b.flight_id = f.flight_id
WHERE b.total_price > (
    SELECT AVG(total_price)
    FROM booking
);
 
-- Nested query: penumpang yang membawa bagasi lebih berat dari rata-rata bagasi
SELECT full_name, nationality
FROM passenger
WHERE passenger_id IN (
    SELECT passenger_id
    FROM baggage
    WHERE weight > (SELECT AVG(weight) FROM baggage)
);
 
-- PENGUJIAN TRIGGER 1
-- Menambahkan penumpang sementara
INSERT INTO passenger
(passenger_id, full_name, passport_number, nationality, email, phone)
VALUES
(9, 'Coba Trigger', 'A1234509', 'Indonesia', 'coba@mail.com', '081234567809');
 
-- Menghapus penumpang sementara
DELETE FROM passenger
WHERE passenger_id = 9;
 
-- Menampilkan hasil pencatatan penghapusan
SELECT * FROM log_passenger;
 
-- PENGUJIAN TRIGGER 2
-- Total harga booking penumpang 1 sebelum bagasi baru ditambahkan
SELECT booking_id, total_price FROM booking WHERE booking_id = 1001;
 
-- Menambahkan bagasi 25 kg (kelebihan 5 kg = Rp 250.000)
INSERT INTO baggage
(baggage_id, passenger_id, flight_id, rfid_tag, weight)
VALUES
(7, 1, 201, 'RFID-0007', 25.00);
 
-- Menampilkan hasil perhitungan total_price setelah trigger berjalan
SELECT booking_id, total_price FROM booking WHERE booking_id = 1001;