--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: scapula; Type: COMMENT; Schema: -; Owner: conrad
--

COMMENT ON DATABASE scapula IS 'database for SCAPula library';


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
-- Name: Events; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Events" (
);


ALTER TABLE public."Events" OWNER TO conrad;

--
-- Name: HostConfigs; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "HostConfigs" (
);


ALTER TABLE public."HostConfigs" OWNER TO conrad;

--
-- Name: Hosts; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Hosts" (
);


ALTER TABLE public."Hosts" OWNER TO conrad;

--
-- Name: Incidents; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Incidents" (
);


ALTER TABLE public."Incidents" OWNER TO conrad;

--
-- Name: IntelligenceEntities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceEntities" (
);


ALTER TABLE public."IntelligenceEntities" OWNER TO conrad;

--
-- Name: IntelligenceSources; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceSources" (
);


ALTER TABLE public."IntelligenceSources" OWNER TO conrad;

--
-- Name: KnowledgeBase; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "KnowledgeBase" (
);


ALTER TABLE public."KnowledgeBase" OWNER TO conrad;

--
-- Name: Networks; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Networks" (
);


ALTER TABLE public."Networks" OWNER TO conrad;

--
-- Name: Notes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Notes" (
);


ALTER TABLE public."Notes" OWNER TO conrad;

--
-- Name: OrgUnits; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "OrgUnits" (
);


ALTER TABLE public."OrgUnits" OWNER TO conrad;

--
-- Name: Organizations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Organizations" (
);


ALTER TABLE public."Organizations" OWNER TO conrad;

--
-- Name: Platforms; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Platforms" (
);


ALTER TABLE public."Platforms" OWNER TO conrad;

--
-- Name: Procedures; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Procedures" (
);


ALTER TABLE public."Procedures" OWNER TO conrad;

--
-- Name: Proceedings; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Proceedings" (
);


ALTER TABLE public."Proceedings" OWNER TO conrad;

--
-- Name: Processes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Processes" (
);


ALTER TABLE public."Processes" OWNER TO conrad;

--
-- Name: Users; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Users" (
);


ALTER TABLE public."Users" OWNER TO conrad;

--
-- Name: Vulnerabilities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Vulnerabilities" (
);


ALTER TABLE public."Vulnerabilities" OWNER TO conrad;

--
-- Name: investigations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE investigations (
);


ALTER TABLE public.investigations OWNER TO conrad;

--
-- Data for Name: Events; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Events"  FROM stdin;
\.


--
-- Data for Name: HostConfigs; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "HostConfigs"  FROM stdin;
\.


--
-- Data for Name: Hosts; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Hosts"  FROM stdin;
\.


--
-- Data for Name: Incidents; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Incidents"  FROM stdin;
\.


--
-- Data for Name: IntelligenceEntities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceEntities"  FROM stdin;
\.


--
-- Data for Name: IntelligenceSources; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceSources"  FROM stdin;
\.


--
-- Data for Name: KnowledgeBase; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "KnowledgeBase"  FROM stdin;
\.


--
-- Data for Name: Networks; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Networks"  FROM stdin;
\.


--
-- Data for Name: Notes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Notes"  FROM stdin;
\.


--
-- Data for Name: OrgUnits; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "OrgUnits"  FROM stdin;
\.


--
-- Data for Name: Organizations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Organizations"  FROM stdin;
\.


--
-- Data for Name: Platforms; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Platforms"  FROM stdin;
\.


--
-- Data for Name: Procedures; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Procedures"  FROM stdin;
\.


--
-- Data for Name: Proceedings; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Proceedings"  FROM stdin;
\.


--
-- Data for Name: Processes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Processes"  FROM stdin;
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Users"  FROM stdin;
\.


--
-- Data for Name: Vulnerabilities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Vulnerabilities"  FROM stdin;
\.


--
-- Data for Name: investigations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY investigations  FROM stdin;
\.


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

