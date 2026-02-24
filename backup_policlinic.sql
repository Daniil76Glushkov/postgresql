--
-- PostgreSQL database dump
--

\restrict KbX3AuZLhFaAIZ6qvRdWD6r0smekhEQJJExeMuJG9WBxXoCGPWLrtjUyuYWgssZ

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-20 12:02:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16470)
-- Name: АмбулаторнаяКарта; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."АмбулаторнаяКарта" (
    card_number character varying(20) NOT NULL,
    creation_date date NOT NULL,
    patient_id integer NOT NULL,
    CONSTRAINT "АмбулаторнаяКарта_card_number_check" CHECK (((card_number)::text ~ '^АК-\d{10}$'::text)),
    CONSTRAINT "АмбулаторнаяКарта_creation_date_check" CHECK ((creation_date <= CURRENT_DATE))
);


ALTER TABLE public."АмбулаторнаяКарта" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16429)
-- Name: Врач; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Врач" (
    doctor_id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    medical_specialty character varying(100),
    medical_degree character varying(50),
    login character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    profile_id integer NOT NULL,
    department_id integer NOT NULL,
    CONSTRAINT "Врач_login_check" CHECK ((length((login)::text) >= 8)),
    CONSTRAINT "Врач_password_hash_check" CHECK ((length((password_hash)::text) >= 8))
);


ALTER TABLE public."Врач" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16428)
-- Name: Врач_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Врач_doctor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Врач_doctor_id_seq" OWNER TO postgres;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 226
-- Name: Врач_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Врач_doctor_id_seq" OWNED BY public."Врач".doctor_id;


--
-- TOC entry 234 (class 1259 OID 16536)
-- Name: Врач_Направление; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Врач_Направление" (
    doctor_id integer NOT NULL,
    direction_id integer NOT NULL
);


ALTER TABLE public."Врач_Направление" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: Кабинет; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Кабинет" (
    cabinet_number integer NOT NULL,
    CONSTRAINT "Кабинет_cabinet_number_check" CHECK ((cabinet_number >= 0))
);


ALTER TABLE public."Кабинет" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16407)
-- Name: Направление; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Направление" (
    direction_id integer NOT NULL,
    direction_name character varying(100) NOT NULL
);


ALTER TABLE public."Направление" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16406)
-- Name: Направление_direction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Направление_direction_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Направление_direction_id_seq" OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 222
-- Name: Направление_direction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Направление_direction_id_seq" OWNED BY public."Направление".direction_id;


--
-- TOC entry 220 (class 1259 OID 16389)
-- Name: Отделение; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Отделение" (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL
);


ALTER TABLE public."Отделение" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16388)
-- Name: Отделение_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Отделение_department_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Отделение_department_id_seq" OWNER TO postgres;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 219
-- Name: Отделение_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Отделение_department_id_seq" OWNED BY public."Отделение".department_id;


--
-- TOC entry 229 (class 1259 OID 16458)
-- Name: Пациент; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Пациент" (
    patient_id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    passport_series character varying(10),
    passport_number character varying(20),
    insurance_number character varying(20) NOT NULL,
    gender character(1),
    birth_date date NOT NULL,
    address character varying(200),
    phone character varying(20),
    CONSTRAINT "Пациент_birth_date_check" CHECK ((birth_date <= CURRENT_DATE)),
    CONSTRAINT "Пациент_gender_check" CHECK ((gender = ANY (ARRAY['М'::bpchar, 'Ж'::bpchar])))
);


ALTER TABLE public."Пациент" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16457)
-- Name: Пациент_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Пациент_patient_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Пациент_patient_id_seq" OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 228
-- Name: Пациент_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Пациент_patient_id_seq" OWNED BY public."Пациент".patient_id;


--
-- TOC entry 233 (class 1259 OID 16512)
-- Name: Прием; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Прием" (
    ticket_number character varying(20) NOT NULL,
    appointment_date date NOT NULL,
    appointment_time time without time zone NOT NULL,
    status character varying(20) NOT NULL,
    doctor_id integer NOT NULL,
    patient_id integer NOT NULL,
    CONSTRAINT "Прием_appointment_date_check" CHECK ((appointment_date >= CURRENT_DATE)),
    CONSTRAINT "Прием_status_check" CHECK (((status)::text = ANY ((ARRAY['Запланирован'::character varying, 'Завершен'::character varying, 'Отменен'::character varying])::text[]))),
    CONSTRAINT "Прием_ticket_number_check" CHECK (((ticket_number)::text ~ '^Т-\d{6}-\d{2}$'::text))
);


ALTER TABLE public."Прием" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16418)
-- Name: ПрофильВрача; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ПрофильВрача" (
    profile_id integer NOT NULL,
    profile_name character varying(100) NOT NULL
);


ALTER TABLE public."ПрофильВрача" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16417)
-- Name: ПрофильВрача_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ПрофильВрача_profile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ПрофильВрача_profile_id_seq" OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 224
-- Name: ПрофильВрача_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ПрофильВрача_profile_id_seq" OWNED BY public."ПрофильВрача".profile_id;


--
-- TOC entry 232 (class 1259 OID 16488)
-- Name: Расписание; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Расписание" (
    schedule_id integer NOT NULL,
    day_of_week character varying(20) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    shift character varying(20),
    doctor_id integer NOT NULL,
    cabinet_number integer NOT NULL,
    CONSTRAINT "Расписание_check" CHECK ((end_time > start_time)),
    CONSTRAINT "Расписание_day_of_week_check" CHECK (((day_of_week)::text = ANY ((ARRAY['Понедельник'::character varying, 'Вторник'::character varying, 'Среда'::character varying, 'Четверг'::character varying, 'Пятница'::character varying, 'Суббота'::character varying])::text[])))
);


ALTER TABLE public."Расписание" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16487)
-- Name: Расписание_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Расписание_schedule_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Расписание_schedule_id_seq" OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 231
-- Name: Расписание_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Расписание_schedule_id_seq" OWNED BY public."Расписание".schedule_id;


--
-- TOC entry 4799 (class 2604 OID 16432)
-- Name: Врач doctor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач" ALTER COLUMN doctor_id SET DEFAULT nextval('public."Врач_doctor_id_seq"'::regclass);


--
-- TOC entry 4797 (class 2604 OID 16410)
-- Name: Направление direction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Направление" ALTER COLUMN direction_id SET DEFAULT nextval('public."Направление_direction_id_seq"'::regclass);


--
-- TOC entry 4796 (class 2604 OID 16392)
-- Name: Отделение department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Отделение" ALTER COLUMN department_id SET DEFAULT nextval('public."Отделение_department_id_seq"'::regclass);


--
-- TOC entry 4800 (class 2604 OID 16461)
-- Name: Пациент patient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Пациент" ALTER COLUMN patient_id SET DEFAULT nextval('public."Пациент_patient_id_seq"'::regclass);


--
-- TOC entry 4798 (class 2604 OID 16421)
-- Name: ПрофильВрача profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ПрофильВрача" ALTER COLUMN profile_id SET DEFAULT nextval('public."ПрофильВрача_profile_id_seq"'::regclass);


--
-- TOC entry 4801 (class 2604 OID 16491)
-- Name: Расписание schedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Расписание" ALTER COLUMN schedule_id SET DEFAULT nextval('public."Расписание_schedule_id_seq"'::regclass);


--
-- TOC entry 5024 (class 0 OID 16470)
-- Dependencies: 230
-- Data for Name: АмбулаторнаяКарта; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."АмбулаторнаяКарта" (card_number, creation_date, patient_id) FROM stdin;
\.


--
-- TOC entry 5021 (class 0 OID 16429)
-- Dependencies: 227
-- Data for Name: Врач; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Врач" (doctor_id, full_name, medical_specialty, medical_degree, login, password_hash, profile_id, department_id) FROM stdin;
\.


--
-- TOC entry 5028 (class 0 OID 16536)
-- Dependencies: 234
-- Data for Name: Врач_Направление; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Врач_Направление" (doctor_id, direction_id) FROM stdin;
\.


--
-- TOC entry 5015 (class 0 OID 16399)
-- Dependencies: 221
-- Data for Name: Кабинет; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Кабинет" (cabinet_number) FROM stdin;
\.


--
-- TOC entry 5017 (class 0 OID 16407)
-- Dependencies: 223
-- Data for Name: Направление; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Направление" (direction_id, direction_name) FROM stdin;
\.


--
-- TOC entry 5014 (class 0 OID 16389)
-- Dependencies: 220
-- Data for Name: Отделение; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Отделение" (department_id, department_name) FROM stdin;
\.


--
-- TOC entry 5023 (class 0 OID 16458)
-- Dependencies: 229
-- Data for Name: Пациент; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Пациент" (patient_id, full_name, passport_series, passport_number, insurance_number, gender, birth_date, address, phone) FROM stdin;
\.


--
-- TOC entry 5027 (class 0 OID 16512)
-- Dependencies: 233
-- Data for Name: Прием; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Прием" (ticket_number, appointment_date, appointment_time, status, doctor_id, patient_id) FROM stdin;
\.


--
-- TOC entry 5019 (class 0 OID 16418)
-- Dependencies: 225
-- Data for Name: ПрофильВрача; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ПрофильВрача" (profile_id, profile_name) FROM stdin;
\.


--
-- TOC entry 5026 (class 0 OID 16488)
-- Dependencies: 232
-- Data for Name: Расписание; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Расписание" (schedule_id, day_of_week, start_time, end_time, shift, doctor_id, cabinet_number) FROM stdin;
\.


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 226
-- Name: Врач_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Врач_doctor_id_seq"', 1, false);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 222
-- Name: Направление_direction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Направление_direction_id_seq"', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 219
-- Name: Отделение_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Отделение_department_id_seq"', 1, false);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 228
-- Name: Пациент_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Пациент_patient_id_seq"', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 224
-- Name: ПрофильВрача_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ПрофильВрача_profile_id_seq"', 1, false);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 231
-- Name: Расписание_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Расписание_schedule_id_seq"', 1, false);


--
-- TOC entry 4841 (class 2606 OID 16481)
-- Name: АмбулаторнаяКарта АмбулаторнаяКарта_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."АмбулаторнаяКарта"
    ADD CONSTRAINT "АмбулаторнаяКарта_patient_id_key" UNIQUE (patient_id);


--
-- TOC entry 4843 (class 2606 OID 16479)
-- Name: АмбулаторнаяКарта АмбулаторнаяКарта_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."АмбулаторнаяКарта"
    ADD CONSTRAINT "АмбулаторнаяКарта_pkey" PRIMARY KEY (card_number);


--
-- TOC entry 4832 (class 2606 OID 16446)
-- Name: Врач Врач_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач"
    ADD CONSTRAINT "Врач_login_key" UNIQUE (login);


--
-- TOC entry 4834 (class 2606 OID 16444)
-- Name: Врач Врач_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач"
    ADD CONSTRAINT "Врач_pkey" PRIMARY KEY (doctor_id);


--
-- TOC entry 4856 (class 2606 OID 16542)
-- Name: Врач_Направление Врач_Направление_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач_Направление"
    ADD CONSTRAINT "Врач_Направление_pkey" PRIMARY KEY (doctor_id, direction_id);


--
-- TOC entry 4819 (class 2606 OID 16405)
-- Name: Кабинет Кабинет_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Кабинет"
    ADD CONSTRAINT "Кабинет_pkey" PRIMARY KEY (cabinet_number);


--
-- TOC entry 4821 (class 2606 OID 16416)
-- Name: Направление Направление_direction_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Направление"
    ADD CONSTRAINT "Направление_direction_name_key" UNIQUE (direction_name);


--
-- TOC entry 4823 (class 2606 OID 16414)
-- Name: Направление Направление_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Направление"
    ADD CONSTRAINT "Направление_pkey" PRIMARY KEY (direction_id);


--
-- TOC entry 4815 (class 2606 OID 16398)
-- Name: Отделение Отделение_department_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Отделение"
    ADD CONSTRAINT "Отделение_department_name_key" UNIQUE (department_name);


--
-- TOC entry 4817 (class 2606 OID 16396)
-- Name: Отделение Отделение_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Отделение"
    ADD CONSTRAINT "Отделение_pkey" PRIMARY KEY (department_id);


--
-- TOC entry 4839 (class 2606 OID 16469)
-- Name: Пациент Пациент_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Пациент"
    ADD CONSTRAINT "Пациент_pkey" PRIMARY KEY (patient_id);


--
-- TOC entry 4854 (class 2606 OID 16525)
-- Name: Прием Прием_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Прием"
    ADD CONSTRAINT "Прием_pkey" PRIMARY KEY (ticket_number);


--
-- TOC entry 4825 (class 2606 OID 16425)
-- Name: ПрофильВрача ПрофильВрача_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ПрофильВрача"
    ADD CONSTRAINT "ПрофильВрача_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 4827 (class 2606 OID 16427)
-- Name: ПрофильВрача ПрофильВрача_profile_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ПрофильВрача"
    ADD CONSTRAINT "ПрофильВрача_profile_name_key" UNIQUE (profile_name);


--
-- TOC entry 4848 (class 2606 OID 16501)
-- Name: Расписание Расписание_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Расписание"
    ADD CONSTRAINT "Расписание_pkey" PRIMARY KEY (schedule_id);


--
-- TOC entry 4849 (class 1259 OID 16562)
-- Name: idx_appointment_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointment_date ON public."Прием" USING btree (appointment_date);


--
-- TOC entry 4850 (class 1259 OID 16563)
-- Name: idx_appointment_doctor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointment_doctor ON public."Прием" USING btree (doctor_id);


--
-- TOC entry 4851 (class 1259 OID 16564)
-- Name: idx_appointment_patient; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointment_patient ON public."Прием" USING btree (patient_id);


--
-- TOC entry 4852 (class 1259 OID 16565)
-- Name: idx_appointment_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointment_status ON public."Прием" USING btree (status);


--
-- TOC entry 4835 (class 1259 OID 16558)
-- Name: idx_birth_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_birth_date ON public."Пациент" USING btree (birth_date);


--
-- TOC entry 4828 (class 1259 OID 16555)
-- Name: idx_doctor_department; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_doctor_department ON public."Врач" USING btree (department_id);


--
-- TOC entry 4829 (class 1259 OID 16553)
-- Name: idx_doctor_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_doctor_name ON public."Врач" USING btree (full_name);


--
-- TOC entry 4830 (class 1259 OID 16554)
-- Name: idx_doctor_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_doctor_profile ON public."Врач" USING btree (profile_id);


--
-- TOC entry 4836 (class 1259 OID 16557)
-- Name: idx_insurance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_insurance ON public."Пациент" USING btree (insurance_number);


--
-- TOC entry 4837 (class 1259 OID 16556)
-- Name: idx_patient_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_patient_name ON public."Пациент" USING btree (full_name);


--
-- TOC entry 4844 (class 1259 OID 16560)
-- Name: idx_schedule_cabinet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_cabinet ON public."Расписание" USING btree (cabinet_number);


--
-- TOC entry 4845 (class 1259 OID 16561)
-- Name: idx_schedule_day; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_day ON public."Расписание" USING btree (day_of_week);


--
-- TOC entry 4846 (class 1259 OID 16559)
-- Name: idx_schedule_doctor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_doctor ON public."Расписание" USING btree (doctor_id);


--
-- TOC entry 4859 (class 2606 OID 16482)
-- Name: АмбулаторнаяКарта АмбулаторнаяКарта_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."АмбулаторнаяКарта"
    ADD CONSTRAINT "АмбулаторнаяКарта_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public."Пациент"(patient_id);


--
-- TOC entry 4857 (class 2606 OID 16452)
-- Name: Врач Врач_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач"
    ADD CONSTRAINT "Врач_department_id_fkey" FOREIGN KEY (department_id) REFERENCES public."Отделение"(department_id);


--
-- TOC entry 4858 (class 2606 OID 16447)
-- Name: Врач Врач_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач"
    ADD CONSTRAINT "Врач_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."ПрофильВрача"(profile_id);


--
-- TOC entry 4864 (class 2606 OID 16548)
-- Name: Врач_Направление Врач_Направление_direction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач_Направление"
    ADD CONSTRAINT "Врач_Направление_direction_id_fkey" FOREIGN KEY (direction_id) REFERENCES public."Направление"(direction_id);


--
-- TOC entry 4865 (class 2606 OID 16543)
-- Name: Врач_Направление Врач_Направление_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Врач_Направление"
    ADD CONSTRAINT "Врач_Направление_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public."Врач"(doctor_id);


--
-- TOC entry 4862 (class 2606 OID 16526)
-- Name: Прием Прием_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Прием"
    ADD CONSTRAINT "Прием_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public."Врач"(doctor_id);


--
-- TOC entry 4863 (class 2606 OID 16531)
-- Name: Прием Прием_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Прием"
    ADD CONSTRAINT "Прием_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public."Пациент"(patient_id);


--
-- TOC entry 4860 (class 2606 OID 16507)
-- Name: Расписание Расписание_cabinet_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Расписание"
    ADD CONSTRAINT "Расписание_cabinet_number_fkey" FOREIGN KEY (cabinet_number) REFERENCES public."Кабинет"(cabinet_number);


--
-- TOC entry 4861 (class 2606 OID 16502)
-- Name: Расписание Расписание_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Расписание"
    ADD CONSTRAINT "Расписание_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public."Врач"(doctor_id);


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE "АмбулаторнаяКарта"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."АмбулаторнаяКарта" TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public."АмбулаторнаяКарта" TO doctor;
GRANT SELECT,INSERT,UPDATE ON TABLE public."АмбулаторнаяКарта" TO reception;


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE "Врач"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Врач" TO admin;
GRANT SELECT,UPDATE ON TABLE public."Врач" TO doctor;
GRANT SELECT ON TABLE public."Врач" TO reception;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE "Врач_doctor_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Врач_doctor_id_seq" TO admin;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "Врач_Направление"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Врач_Направление" TO admin;
GRANT SELECT ON TABLE public."Врач_Направление" TO doctor;


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "Кабинет"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Кабинет" TO admin;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "Направление"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Направление" TO admin;
GRANT SELECT ON TABLE public."Направление" TO doctor;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE "Направление_direction_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Направление_direction_id_seq" TO admin;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "Отделение"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Отделение" TO admin;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE "Отделение_department_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Отделение_department_id_seq" TO admin;


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "Пациент"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Пациент" TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Пациент" TO doctor;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Пациент" TO reception;
GRANT SELECT,UPDATE ON TABLE public."Пациент" TO patient;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE "Пациент_patient_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Пациент_patient_id_seq" TO admin;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE "Прием"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Прием" TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Прием" TO doctor;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Прием" TO reception;
GRANT SELECT ON TABLE public."Прием" TO patient;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "ПрофильВрача"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."ПрофильВрача" TO admin;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE "ПрофильВрача_profile_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."ПрофильВрача_profile_id_seq" TO admin;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "Расписание"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Расписание" TO admin;
GRANT SELECT,UPDATE ON TABLE public."Расписание" TO doctor;
GRANT SELECT ON TABLE public."Расписание" TO reception;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE "Расписание_schedule_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Расписание_schedule_id_seq" TO admin;


-- Completed on 2026-02-20 12:02:42

--
-- PostgreSQL database dump complete
--

\unrestrict KbX3AuZLhFaAIZ6qvRdWD6r0smekhEQJJExeMuJG9WBxXoCGPWLrtjUyuYWgssZ

