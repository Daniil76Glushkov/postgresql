CREATE TABLE Отделение (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Кабинет (
    cabinet_number INTEGER PRIMARY KEY
);

CREATE TABLE Направление (
    direction_id SERIAL PRIMARY KEY,
    direction_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE ПрофильВрача (
    profile_id SERIAL PRIMARY KEY,
    profile_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Врач (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    medical_specialty VARCHAR(100),
    medical_degree VARCHAR(50),
    login VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    profile_id INTEGER NOT NULL REFERENCES ПрофильВрача(profile_id),
    department_id INTEGER NOT NULL REFERENCES Отделение(department_id)
);

CREATE TABLE Пациент (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    passport_series VARCHAR(10),
    passport_number VARCHAR(20),
    insurance_number VARCHAR(20) NOT NULL,
    gender CHAR(1),
    birth_date DATE NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20)
);

CREATE TABLE АмбулаторнаяКарта (
    card_number VARCHAR(20) PRIMARY KEY,
    creation_date DATE NOT NULL,
    patient_id INTEGER NOT NULL UNIQUE REFERENCES Пациент(patient_id)
);

CREATE TABLE Расписание (
    schedule_id SERIAL PRIMARY KEY,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    shift VARCHAR(20),
    doctor_id INTEGER NOT NULL REFERENCES Врач(doctor_id),
    cabinet_number INTEGER NOT NULL REFERENCES Кабинет(cabinet_number)
);

CREATE TABLE Прием (
    ticket_number VARCHAR(20) PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    doctor_id INTEGER NOT NULL REFERENCES Врач(doctor_id),
    patient_id INTEGER NOT NULL REFERENCES Пациент(patient_id)
);

CREATE TABLE Врач_Направление (
    doctor_id INTEGER NOT NULL REFERENCES Врач(doctor_id),
    direction_id INTEGER NOT NULL REFERENCES Направление(direction_id),
    PRIMARY KEY (doctor_id, direction_id)
);