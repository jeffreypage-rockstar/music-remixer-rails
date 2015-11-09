--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clip_types; Type: TABLE; Schema: public; Owner: rails; Tablespace: 
--

CREATE TABLE clip_types (
    id integer NOT NULL,
    song_id integer,
    name character varying,
    "row" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.clip_types OWNER TO rails;

--
-- Name: clip_types_id_seq; Type: SEQUENCE; Schema: public; Owner: rails
--

CREATE SEQUENCE clip_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clip_types_id_seq OWNER TO rails;

--
-- Name: clip_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rails
--

ALTER SEQUENCE clip_types_id_seq OWNED BY clip_types.id;


--
-- Name: clips; Type: TABLE; Schema: public; Owner: rails; Tablespace: 
--

CREATE TABLE clips (
    id integer NOT NULL,
    song_id integer,
    name character varying,
    "row" character varying,
    "column" character varying,
    duration double precision,
    state boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    part_id integer,
    file text,
    state2 boolean DEFAULT false,
    state3 boolean DEFAULT false,
    user_content boolean DEFAULT false
);


ALTER TABLE public.clips OWNER TO rails;

--
-- Name: clips_id_seq; Type: SEQUENCE; Schema: public; Owner: rails
--

CREATE SEQUENCE clips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clips_id_seq OWNER TO rails;

--
-- Name: clips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rails
--

ALTER SEQUENCE clips_id_seq OWNED BY clips.id;


--
-- Name: parts; Type: TABLE; Schema: public; Owner: rails; Tablespace: 
--

CREATE TABLE parts (
    id integer NOT NULL,
    song_id integer,
    name character varying,
    duration double precision,
    "column" character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.parts OWNER TO rails;

--
-- Name: parts_id_seq; Type: SEQUENCE; Schema: public; Owner: rails
--

CREATE SEQUENCE parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parts_id_seq OWNER TO rails;

--
-- Name: parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rails
--

ALTER SEQUENCE parts_id_seq OWNED BY parts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: rails; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO rails;

--
-- Name: songs; Type: TABLE; Schema: public; Owner: rails; Tablespace: 
--

CREATE TABLE songs (
    id integer NOT NULL,
    name character varying,
    duration double precision,
    zipfile text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mixaudio text,
    mixaudio2 text,
    mixaudio3 text
);


ALTER TABLE public.songs OWNER TO rails;

--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: rails
--

CREATE SEQUENCE songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_id_seq OWNER TO rails;

--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rails
--

ALTER SEQUENCE songs_id_seq OWNED BY songs.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rails
--

ALTER TABLE ONLY clip_types ALTER COLUMN id SET DEFAULT nextval('clip_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rails
--

ALTER TABLE ONLY clips ALTER COLUMN id SET DEFAULT nextval('clips_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rails
--

ALTER TABLE ONLY parts ALTER COLUMN id SET DEFAULT nextval('parts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rails
--

ALTER TABLE ONLY songs ALTER COLUMN id SET DEFAULT nextval('songs_id_seq'::regclass);


--
-- Data for Name: clip_types; Type: TABLE DATA; Schema: public; Owner: rails
--

COPY clip_types (id, song_id, name, "row", created_at, updated_at) FROM stdin;
17	12	Bass	2	2015-10-07 04:41:16.612201	2015-10-07 04:41:16.612201
18	12	Crash	8	2015-10-07 04:41:16.783221	2015-10-07 04:41:16.783221
19	12	Dive	7	2015-10-07 04:41:16.901795	2015-10-07 04:41:16.901795
20	12	Drums	3	2015-10-07 04:41:16.980442	2015-10-07 04:41:16.980442
21	12	DTPerc	6	2015-10-07 04:41:17.162261	2015-10-07 04:41:17.162261
22	12	Inst	4	2015-10-07 04:41:17.263277	2015-10-07 04:41:17.263277
23	12	UpPerc	5	2015-10-07 04:41:17.369326	2015-10-07 04:41:17.369326
24	12	Vocals	1	2015-10-07 04:41:17.624977	2015-10-07 04:41:17.624977
\.


--
-- Name: clip_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rails
--

SELECT pg_catalog.setval('clip_types_id_seq', 24, true);


--
-- Data for Name: clips; Type: TABLE DATA; Schema: public; Owner: rails
--

COPY clips (id, song_id, name, "row", "column", duration, state, created_at, updated_at, part_id, file, state2, state3, user_content) FROM stdin;
402	12	\N	2	5	\N	f	2015-10-07 04:41:16.719912	2015-10-07 04:41:16.719912	45	/uploads/songs/12/jai_ambe/O-Bass_5a.m4a	f	f	f
451	12	\N	2	6	\N	t	2015-10-07 04:41:17.513822	2015-10-21 03:29:21.290285	46	/uploads/songs/12/jai_ambe/O-Up Perc_6g.m4a	f	f	f
453	12	\N	5	8	\N	t	2015-10-07 04:41:17.535965	2015-10-15 21:04:59.950564	48	/uploads/songs/12/jai_ambe/O-Up Perc_8g.m4a	f	f	f
421	12	\N	7	8	\N	f	2015-10-07 04:41:16.959927	2015-10-21 12:37:42.416869	48	/uploads/songs/12/jai_ambe/O-Dive_8c.m4a	f	f	f
442	12	\N	4	5	\N	t	2015-10-07 04:41:17.308145	2015-10-21 03:29:10.584977	45	/uploads/songs/12/jai_ambe/O-Inst_5f.m4a	f	f	f
450	12	\N	6	5	\N	f	2015-10-07 04:41:17.500348	2015-10-21 03:29:12.141801	45	/uploads/songs/12/jai_ambe/O-Up Perc_5g.m4a	f	f	f
445	12	\N	4	8	\N	t	2015-10-07 04:41:17.344288	2015-10-21 03:29:31.799203	48	/uploads/songs/12/jai_ambe/O-Inst_8f.m4a	f	f	f
437	12	\N	6	8	\N	f	2015-10-07 04:41:17.238534	2015-10-21 03:29:33.023447	48	/uploads/songs/12/jai_ambe/O-DT-Perc_8e.m4a	f	f	f
401	12	\N	2	4	\N	f	2015-10-07 04:41:16.701809	2015-10-22 02:19:02.110611	44	/uploads/songs/12/jai_ambe/O-Bass_4a.m4a	f	f	f
433	12	\N	6	4	\N	f	2015-10-07 04:41:17.195893	2015-11-04 02:42:06.200939	44	/uploads/songs/12/jai_ambe/O-DT-Perc_4e.m4a	f	f	f
459	12	\N	1	6	\N	t	2015-10-07 04:41:17.696484	2015-10-30 11:02:11.14468	46	/uploads/songs/12/jai_ambe/O-Vocals_6h.m4a	f	f	f
454	12	\N	1	1	\N	t	2015-10-07 04:41:17.629504	2015-11-04 02:40:39.362221	41	/uploads/songs/12/jai_ambe/O-Vocals_1h.m4a	f	t	f
429	12	\N	3	8	\N	t	2015-10-07 04:41:17.137997	2015-11-04 02:41:27.307258	48	/uploads/songs/12/jai_ambe/O-Drums_8d.m4a	f	f	f
440	12	\N	5	3	\N	t	2015-10-07 04:41:17.291255	2015-11-04 02:41:33.440157	43	/uploads/songs/12/jai_ambe/O-Inst_3f.m4a	f	f	f
398	12	\N	2	1	\N	f	2015-10-07 04:41:16.641732	2015-10-30 10:59:17.474955	41	/uploads/songs/12/jai_ambe/O-Bass_1a.m4a	f	f	f
406	12	\N	8	1	\N	f	2015-10-07 04:41:16.790256	2015-10-21 12:13:52.787132	41	/uploads/songs/12/jai_ambe/O-Crash_1b.m4a	f	f	t
416	12	\N	7	3	\N	f	2015-10-07 04:41:16.919315	2015-10-30 11:01:47.978105	43	/uploads/songs/12/jai_ambe/O-Dive_3c.m4a	f	f	f
404	12	\N	2	7	\N	f	2015-10-07 04:41:16.760059	2015-10-30 11:01:55.015797	47	/uploads/songs/12/jai_ambe/O-Bass_7a.m4a	f	f	t
419	12	\N	7	6	\N	t	2015-10-07 04:41:16.937382	2015-10-30 12:13:58.164852	46	/uploads/songs/12/jai_ambe/O-Dive_6c.m4a	f	f	f
405	12	\N	2	8	\N	f	2015-10-07 04:41:16.774631	2015-10-30 11:01:55.474182	48	/uploads/songs/12/jai_ambe/O-Bass_8a.m4a	f	f	f
430	12	\N	5	1	\N	t	2015-10-07 04:41:17.16709	2015-11-04 02:40:52.324516	41	/uploads/songs/12/jai_ambe/O-DT-Perc_1e.m4a	t	f	f
410	12	\N	8	5	\N	t	2015-10-07 04:41:16.834184	2015-11-04 02:43:15.631775	45	/uploads/songs/12/jai_ambe/O-Crash_5b.m4a	f	f	f
436	12	\N	6	7	\N	f	2015-10-07 04:41:17.226175	2015-10-21 03:29:29.181107	47	/uploads/songs/12/jai_ambe/O-DT-Perc_7e.m4a	f	f	t
414	12	\N	7	1	\N	f	2015-10-07 04:41:16.906788	2015-10-29 05:14:45.992957	41	/uploads/songs/12/jai_ambe/O-Dive_1c.m4a	f	f	f
446	12	\N	6	1	\N	f	2015-10-07 04:41:17.374093	2015-10-29 05:14:43.019252	41	/uploads/songs/12/jai_ambe/O-Up Perc_1g.m4a	f	f	f
417	12	\N	7	4	\N	t	2015-10-07 04:41:16.925145	2015-10-26 17:04:59.562569	44	/uploads/songs/12/jai_ambe/O-Dive_4c.m4a	f	f	f
441	12	\N	4	4	\N	f	2015-10-07 04:41:17.300089	2015-10-29 19:25:40.37458	44	/uploads/songs/12/jai_ambe/O-Inst_4f.m4a	t	f	t
423	12	\N	3	2	\N	t	2015-10-07 04:41:16.998543	2015-11-04 02:41:42.47306	42	/uploads/songs/12/jai_ambe/O-Drums_2d.m4a	f	f	f
455	12	\N	1	2	\N	t	2015-10-07 04:41:17.643129	2015-11-04 02:41:16.053911	42	/uploads/songs/12/jai_ambe/O-Vocals_2h.m4a	t	f	t
456	12	\N	1	3	\N	t	2015-10-07 04:41:17.657533	2015-11-04 02:41:16.551573	43	/uploads/songs/12/jai_ambe/O-Vocals_3h.m4a	f	f	t
458	12	\N	1	5	\N	t	2015-10-07 04:41:17.683499	2015-11-04 02:41:17.500971	45	/uploads/songs/12/jai_ambe/O-Vocals_5h.m4a	f	f	f
438	12	\N	4	1	\N	f	2015-10-07 04:41:17.268435	2015-10-30 10:59:24.746142	41	/uploads/songs/12/jai_ambe/O-Inst_1f.m4a	t	t	t
399	12	\N	2	2	\N	f	2015-10-07 04:41:16.667062	2015-10-29 19:24:53.185451	42	/uploads/songs/12/jai_ambe/O-Bass_2a.m4a	f	f	f
431	12	\N	6	2	\N	f	2015-10-07 04:41:17.178674	2015-10-29 19:24:56.415362	42	/uploads/songs/12/jai_ambe/O-DT-Perc_2e.m4a	t	f	f
415	12	\N	7	2	\N	f	2015-10-07 04:41:16.91334	2015-10-30 12:14:00.663193	42	/uploads/songs/12/jai_ambe/O-Dive_2c.m4a	t	f	f
434	12	\N	5	5	\N	t	2015-10-07 04:41:17.204313	2015-11-04 02:41:34.337452	45	/uploads/songs/12/jai_ambe/O-DT-Perc_5e.m4a	f	f	f
448	12	\N	4	3	\N	f	2015-10-07 04:41:17.41034	2015-10-30 11:01:50.087782	43	/uploads/songs/12/jai_ambe/O-Up Perc_3g.m4a	f	f	f
425	12	\N	3	4	\N	t	2015-10-07 04:41:17.016325	2015-11-04 02:41:26.10253	44	/uploads/songs/12/jai_ambe/O-Drums_4d.m4a	f	f	f
427	12	\N	3	6	\N	t	2015-10-07 04:41:17.115595	2015-10-30 11:02:35.642285	46	/uploads/songs/12/jai_ambe/O-Drums_6d.m4a	f	f	f
426	12	\N	3	5	\N	t	2015-10-07 04:41:17.102341	2015-10-29 19:25:02.81377	45	/uploads/songs/12/jai_ambe/O-Drums_5d.m4a	f	f	f
428	12	\N	3	7	\N	t	2015-10-07 04:41:17.128431	2015-10-30 12:13:56.363336	47	/uploads/songs/12/jai_ambe/O-Drums_7d.m4a	f	f	f
407	12	\N	8	2	\N	f	2015-10-07 04:41:16.800779	2015-11-04 02:41:46.835072	42	/uploads/songs/12/jai_ambe/O-Crash_2b.m4a	f	f	f
418	12	\N	7	5	\N	t	2015-10-07 04:41:16.9308	2015-10-30 12:13:58.760488	45	/uploads/songs/12/jai_ambe/O-Dive_5c.m4a	f	f	f
444	12	\N	4	7	\N	f	2015-10-07 04:41:17.330969	2015-10-30 12:13:55.508654	47	/uploads/songs/12/jai_ambe/O-Inst_7f.m4a	f	f	f
432	12	\N	6	3	\N	f	2015-10-07 04:41:17.186754	2015-10-30 11:01:48.366133	43	/uploads/songs/12/jai_ambe/O-DT-Perc_3e.m4a	f	f	f
400	12	\N	2	3	\N	f	2015-10-07 04:41:16.684011	2015-11-04 02:42:26.067411	43	/uploads/songs/12/jai_ambe/O-Bass_3a.m4a	f	f	f
457	12	\N	1	4	\N	t	2015-10-07 04:41:17.663002	2015-11-04 02:41:17.062224	44	/uploads/songs/12/jai_ambe/O-Vocals_4h.m4a	t	f	f
443	12	\N	4	6	\N	t	2015-10-07 04:41:17.319212	2015-10-30 11:01:56.77961	46	/uploads/songs/12/jai_ambe/O-Inst_6f.m4a	f	f	f
413	12	\N	8	8	\N	t	2015-10-07 04:41:16.895497	2015-11-04 02:43:12.303101	48	/uploads/songs/12/jai_ambe/O-Crash_8b.m4a	f	f	f
435	12	\N	6	6	\N	f	2015-10-07 04:41:17.214764	2015-10-30 12:13:57.659183	46	/uploads/songs/12/jai_ambe/O-DT-Perc_6e.m4a	f	f	t
411	12	\N	8	6	\N	t	2015-10-07 04:41:16.84224	2015-11-04 02:43:08.544109	46	/uploads/songs/12/jai_ambe/O-Crash_6b.m4a	f	f	t
422	12	\N	3	1	\N	t	2015-10-07 04:41:16.98519	2015-11-04 02:40:37.597848	41	/uploads/songs/12/jai_ambe/O-Drums_1d.m4a	f	t	t
460	12	\N	1	7	\N	t	2015-10-07 04:41:17.708226	2015-11-04 02:41:18.169388	47	/uploads/songs/12/jai_ambe/O-Vocals_7h.m4a	f	f	f
461	12	\N	1	8	\N	t	2015-10-07 04:41:17.714662	2015-11-04 02:41:18.535248	48	/uploads/songs/12/jai_ambe/O-Vocals_8h.m4a	f	f	f
424	12	\N	3	3	\N	t	2015-10-07 04:41:17.007323	2015-11-04 02:41:25.495835	43	/uploads/songs/12/jai_ambe/O-Drums_3d.m4a	f	f	f
447	12	\N	5	2	\N	t	2015-10-07 04:41:17.393098	2015-11-04 02:41:32.611011	42	/uploads/songs/12/jai_ambe/O-Up Perc_2g.m4a	f	f	f
452	12	\N	5	7	\N	t	2015-10-07 04:41:17.526608	2015-11-04 02:41:35.530224	47	/uploads/songs/12/jai_ambe/O-Up Perc_7g.m4a	f	f	f
449	12	\N	5	4	\N	t	2015-10-07 04:41:17.489794	2015-11-04 02:41:36.219761	44	/uploads/songs/12/jai_ambe/O-Up Perc_4g.m4a	t	f	f
403	12	\N	5	6	\N	t	2015-10-07 04:41:16.740955	2015-11-04 02:41:36.84119	46	/uploads/songs/12/jai_ambe/O-Bass_6a.m4a	f	f	f
408	12	\N	8	3	\N	f	2015-10-07 04:41:16.810819	2015-11-04 02:41:47.894329	43	/uploads/songs/12/jai_ambe/O-Crash_3b.m4a	f	f	f
409	12	\N	8	4	\N	t	2015-10-07 04:41:16.822432	2015-11-04 02:43:18.592516	44	/uploads/songs/12/jai_ambe/O-Crash_4b.m4a	t	f	f
420	12	\N	7	7	\N	f	2015-10-07 04:41:16.948044	2015-11-04 02:43:54.941512	47	/uploads/songs/12/jai_ambe/O-Dive_7c.m4a	f	f	t
412	12	\N	8	7	\N	t	2015-10-07 04:41:16.887234	2015-11-04 02:43:10.634725	47	/uploads/songs/12/jai_ambe/O-Crash_7b.m4a	f	f	t
439	12	\N	4	2	\N	f	2015-10-07 04:41:17.282236	2015-11-04 02:41:56.31231	42	/uploads/songs/12/jai_ambe/O-Inst_2f.m4a	t	f	f
\.


--
-- Name: clips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rails
--

SELECT pg_catalog.setval('clips_id_seq', 461, true);


--
-- Data for Name: parts; Type: TABLE DATA; Schema: public; Owner: rails
--

COPY parts (id, song_id, name, duration, "column", created_at, updated_at) FROM stdin;
41	12	Part 1	88	1	2015-10-07 04:41:16.634783	2015-10-07 04:41:16.634783
42	12	Part 2	41	2	2015-10-07 04:41:16.660549	2015-10-07 04:41:16.660549
43	12	Part 3	20	3	2015-10-07 04:41:16.678705	2015-10-07 04:41:16.678705
45	12	Part 5	20	5	2015-10-07 04:41:16.71328	2015-10-07 04:41:16.71328
46	12	Part 6	41	6	2015-10-07 04:41:16.735604	2015-10-07 04:41:16.735604
47	12	Part 7	41	7	2015-10-07 04:41:16.755586	2015-10-07 04:41:16.755586
48	12	Part 8	52	8	2015-10-07 04:41:16.770396	2015-10-07 04:41:16.770396
44	12	BEATNICK	20	4	2015-10-07 04:41:16.695233	2015-10-22 02:18:53.318754
\.


--
-- Name: parts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rails
--

SELECT pg_catalog.setval('parts_id_seq', 48, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: rails
--

COPY schema_migrations (version) FROM stdin;
20150825110235
20150826052325
20150909090633
20150909090852
20150909092216
20150910122401
20150921075600
20150921081300
20150925101655
20150930075139
20151023041849
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: rails
--

COPY songs (id, name, duration, zipfile, created_at, updated_at, mixaudio, mixaudio2, mixaudio3) FROM stdin;
12	Jerry's Jammie Jam	323	jai_ambe.zip	2015-10-07 04:41:16.389684	2015-10-29 05:15:45.452166	/uploads/songs/12/mix-audio-2b76b70279323a14fc1192ad1711af74.m4a	\N	\N
\.


--
-- Name: songs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rails
--

SELECT pg_catalog.setval('songs_id_seq', 12, true);


--
-- Name: clip_types_pkey; Type: CONSTRAINT; Schema: public; Owner: rails; Tablespace: 
--

ALTER TABLE ONLY clip_types
    ADD CONSTRAINT clip_types_pkey PRIMARY KEY (id);


--
-- Name: clips_pkey; Type: CONSTRAINT; Schema: public; Owner: rails; Tablespace: 
--

ALTER TABLE ONLY clips
    ADD CONSTRAINT clips_pkey PRIMARY KEY (id);


--
-- Name: parts_pkey; Type: CONSTRAINT; Schema: public; Owner: rails; Tablespace: 
--

ALTER TABLE ONLY parts
    ADD CONSTRAINT parts_pkey PRIMARY KEY (id);


--
-- Name: songs_pkey; Type: CONSTRAINT; Schema: public; Owner: rails; Tablespace: 
--

ALTER TABLE ONLY songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: rails; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

