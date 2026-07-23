-- Esquema + dades reals exportades amb pg_dump (backup.sql de l'usuari).
-- Sanejat: sense \restrict/\unrestrict (meta-comandes de psql 17+ no
-- suportades per la imatge postgres:16) i sense OWNER TO / GRANT a rols
-- (postgres, jordi) que no existeixen en un contenidor nou.

--
-- PostgreSQL database dump
--


-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: camera_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.camera_status AS ENUM (
    'pending',
    'accepted',
    'denied'
);



--
-- Name: permission_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.permission_type AS ENUM (
    'private',
    'community',
    'public'
);



--
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'admin',
    'user',
    'camera_user'
);



--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'waiting',
    'in_process',
    'validated',
    'not_validated'
);



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: camera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera (
    id integer NOT NULL,
    url text NOT NULL,
    owner_id integer NOT NULL,
    latitude numeric(10,8) NOT NULL,
    longitude numeric(11,8) NOT NULL,
    publish_token character varying(255),
    camera_status public.camera_status DEFAULT 'pending'::public.camera_status NOT NULL,
    rejection_reason text,
    reviewed_at timestamp without time zone,
    reviewed_by integer
);



--
-- Name: camera_community; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_community (
    camera_id integer NOT NULL,
    community_id integer NOT NULL
);



--
-- Name: camera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.camera_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: camera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.camera_id_seq OWNED BY public.camera.id;


--
-- Name: community; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.community (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    leader_id integer
);



--
-- Name: community_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.community_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: community_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.community_id_seq OWNED BY public.community.id;


--
-- Name: community_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.community_member (
    community_id integer NOT NULL,
    user_id integer NOT NULL
);



--
-- Name: detection_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detection_type (
    id integer NOT NULL,
    type character varying(100) NOT NULL
);



--
-- Name: detection_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detection_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: detection_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detection_type_id_seq OWNED BY public.detection_type.id;


--
-- Name: detections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detections (
    id integer NOT NULL,
    id_camera integer,
    detected_at timestamp without time zone NOT NULL,
    type integer NOT NULL,
    duration integer,
    status public.status NOT NULL,
    url text,
    user_id integer
);



--
-- Name: detections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: detections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detections_id_seq OWNED BY public.detections.id;


--
-- Name: display; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.display (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL
);



--
-- Name: display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.display_id_seq OWNED BY public.display.id;


--
-- Name: species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    url text NOT NULL
);



--
-- Name: species_detected; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species_detected (
    species_id integer NOT NULL,
    detection_id integer NOT NULL
);



--
-- Name: species_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.species_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: species_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.species_id_seq OWNED BY public.species.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    password_hash character varying(255) NOT NULL,
    mail character varying(255) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    role public.role DEFAULT 'user'::public.role NOT NULL,
    privacity public.permission_type DEFAULT 'private'::public.permission_type NOT NULL
);



--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: camera id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera ALTER COLUMN id SET DEFAULT nextval('public.camera_id_seq'::regclass);


--
-- Name: community id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community ALTER COLUMN id SET DEFAULT nextval('public.community_id_seq'::regclass);


--
-- Name: detection_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detection_type ALTER COLUMN id SET DEFAULT nextval('public.detection_type_id_seq'::regclass);


--
-- Name: detections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detections ALTER COLUMN id SET DEFAULT nextval('public.detections_id_seq'::regclass);


--
-- Name: display id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.display ALTER COLUMN id SET DEFAULT nextval('public.display_id_seq'::regclass);


--
-- Name: species id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species ALTER COLUMN id SET DEFAULT nextval('public.species_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: camera; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.camera (id, url, owner_id, latitude, longitude, publish_token, camera_status, rejection_reason, reviewed_at, reviewed_by) FROM stdin;
2	rtsp://192.168.1.20:8554/cam2	1	41.39000000	2.17000000	secreto_edge_456	accepted	\N	\N	\N
1	rtsp://192.168.1.20:8554/cam1	1	41.23000000	1.72000000	secreto_edge_123	accepted	\N	\N	\N
3	rtsp://192.168.1.20:8554/cam3	7	40.12000000	2.00000000	irmmGYQY_1hbGra4HsER8vIfjTurto0SJyWL-6E9dDs	accepted	\N	2026-06-15 14:33:08.548638	6
\.


--
-- Data for Name: camera_community; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.camera_community (camera_id, community_id) FROM stdin;
1	1
1	2
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.community (id, name, leader_id) FROM stdin;
1	epsevg	4
2	upc	1
\.


--
-- Data for Name: community_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.community_member (community_id, user_id) FROM stdin;
1	1
1	4
2	1
\.


--
-- Data for Name: detection_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detection_type (id, type) FROM stdin;
1	frame_detection
2	video_detection
\.


--
-- Data for Name: detections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detections (id, id_camera, detected_at, type, duration, status, url, user_id) FROM stdin;
1	1	2026-04-20 10:30:00	1	\N	waiting	/detections/frame_001.jpg	1
\.


--
-- Data for Name: display; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.display (id, user_id, date) FROM stdin;
\.


--
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species (id, name, url) FROM stdin;
\.


--
-- Data for Name: species_detected; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species_detected (species_id, detection_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, password_hash, mail, created_at, role, privacity) FROM stdin;
1	123	hola@gmail.com	2026-04-19	user	private
2	123	2@gmai.com	2026-04-19	user	private
3	123	2@gmail.com	2026-04-19	user	private
4	hola	1@gmail.com	2026-04-20	user	private
5	1	aaaaa@gmail.com	2026-04-20	user	private
6	admin	admin@gmail.com	2026-04-26	admin	private
7	user	user@gmail.com	2026-06-15	user	private
\.


--
-- Name: camera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.camera_id_seq', 3, true);


--
-- Name: community_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.community_id_seq', 2, true);


--
-- Name: detection_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detection_type_id_seq', 2, true);


--
-- Name: detections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detections_id_seq', 7, true);


--
-- Name: display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.display_id_seq', 1, false);


--
-- Name: species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.species_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: camera camera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera
    ADD CONSTRAINT camera_pkey PRIMARY KEY (id);


--
-- Name: camera_community cameracommunity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_community
    ADD CONSTRAINT cameracommunity_pkey PRIMARY KEY (camera_id, community_id);


--
-- Name: community community_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_name_key UNIQUE (name);


--
-- Name: community community_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (id);


--
-- Name: community_member communitymember_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community_member
    ADD CONSTRAINT communitymember_pkey PRIMARY KEY (community_id, user_id);


--
-- Name: detection_type detection_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detection_type
    ADD CONSTRAINT detection_type_pkey PRIMARY KEY (id);


--
-- Name: detections detections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detections
    ADD CONSTRAINT detections_pkey PRIMARY KEY (id);


--
-- Name: display display_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.display
    ADD CONSTRAINT display_pkey PRIMARY KEY (id);


--
-- Name: species species_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_name_key UNIQUE (name);


--
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);


--
-- Name: species_detected speciesdetected_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_detected
    ADD CONSTRAINT speciesdetected_pkey PRIMARY KEY (species_id, detection_id);


--
-- Name: users users_mail_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mail_key UNIQUE (mail);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: camera camera_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera
    ADD CONSTRAINT camera_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: camera camera_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera
    ADD CONSTRAINT camera_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: camera_community cameracommunity_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_community
    ADD CONSTRAINT cameracommunity_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.camera(id) ON DELETE CASCADE;


--
-- Name: camera_community cameracommunity_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_community
    ADD CONSTRAINT cameracommunity_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(id) ON DELETE CASCADE;


--
-- Name: community community_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES public.users(id);


--
-- Name: community_member communitymember_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community_member
    ADD CONSTRAINT communitymember_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(id) ON DELETE CASCADE;


--
-- Name: community_member communitymember_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.community_member
    ADD CONSTRAINT communitymember_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: detections detections_id_camera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detections
    ADD CONSTRAINT detections_id_camera_fkey FOREIGN KEY (id_camera) REFERENCES public.camera(id) ON DELETE SET NULL;


--
-- Name: detections detections_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detections
    ADD CONSTRAINT detections_type_fkey FOREIGN KEY (type) REFERENCES public.detection_type(id);


--
-- Name: detections detections_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detections
    ADD CONSTRAINT detections_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: display display_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.display
    ADD CONSTRAINT display_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: species_detected speciesdetected_detection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_detected
    ADD CONSTRAINT speciesdetected_detection_id_fkey FOREIGN KEY (detection_id) REFERENCES public.detections(id) ON DELETE CASCADE;


--
-- Name: species_detected speciesdetected_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_detected
    ADD CONSTRAINT speciesdetected_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--



--
-- Name: TABLE camera; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE camera_community; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE camera_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE community; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE community_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE community_member; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE detection_type; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE detection_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE detections; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE detections_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE display; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE display_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE species; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE species_detected; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE species_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--



--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--



--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--



--
-- PostgreSQL database dump complete
--


