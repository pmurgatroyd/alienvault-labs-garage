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
-- Name: AuthDomains; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "AuthDomains" (
);


ALTER TABLE public."AuthDomains" OWNER TO conrad;

--
-- Name: Domains; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Domains" (
    "ID" bigint NOT NULL,
    name character varying(255),
    organization_id bigint
);


ALTER TABLE public."Domains" OWNER TO conrad;

--
-- Name: EventSources; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "EventSources" (
);


ALTER TABLE public."EventSources" OWNER TO conrad;

--
-- Name: EventTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "EventTypes" (
);


ALTER TABLE public."EventTypes" OWNER TO conrad;

--
-- Name: Events; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Events" (
    "ID" bigint NOT NULL,
    "Timestamp" date
);


ALTER TABLE public."Events" OWNER TO conrad;

--
-- Name: GeolocationRegions; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "GeolocationRegions" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."GeolocationRegions" OWNER TO conrad;

--
-- Name: Geolocations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Geolocations" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Geolocations" OWNER TO conrad;

--
-- Name: HostConfigs; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "HostConfigs" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."HostConfigs" OWNER TO conrad;

--
-- Name: Hosts; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Hosts" (
    "ID" bigint NOT NULL,
    hostname character varying,
    dnsname character varying(63),
    address inet,
    mac macaddr,
    domain_id bigint,
    authdomain_id bigint
);


ALTER TABLE public."Hosts" OWNER TO conrad;

--
-- Name: Incidents; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Incidents" (
    "ID" bigint NOT NULL,
    creationtime date,
    title character varying,
    impact_id bigint
);


ALTER TABLE public."Incidents" OWNER TO conrad;

--
-- Name: IntelligenceEntities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceEntities" (
    "ID" bigint NOT NULL,
    source_id bigint,
    type_id bigint
);


ALTER TABLE public."IntelligenceEntities" OWNER TO conrad;

--
-- Name: IntelligenceSources; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceSources" (
    "ID" bigint NOT NULL,
    name character varying,
    location character varying,
    lastupdated date
);


ALTER TABLE public."IntelligenceSources" OWNER TO conrad;

--
-- Name: IntelligenceTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceTypes" (
    "ID" bigint NOT NULL,
    typename character varying NOT NULL
);


ALTER TABLE public."IntelligenceTypes" OWNER TO conrad;

--
-- Name: Investigations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Investigations" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Investigations" OWNER TO conrad;

--
-- Name: KnowledgeBase; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "KnowledgeBase" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."KnowledgeBase" OWNER TO conrad;

--
-- Name: Networks; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Networks" (
    "ID" bigint NOT NULL,
    address inet NOT NULL,
    mask smallint NOT NULL,
    subnet cidr NOT NULL,
    zone character varying,
    description character varying,
    geolocation_id bigint
);


ALTER TABLE public."Networks" OWNER TO conrad;

--
-- Name: Notes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Notes" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Notes" OWNER TO conrad;

--
-- Name: OrgUnits; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "OrgUnits" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."OrgUnits" OWNER TO conrad;

--
-- Name: Organizations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Organizations" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Organizations" OWNER TO conrad;

--
-- Name: Platforms; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Platforms" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Platforms" OWNER TO conrad;

--
-- Name: Procedures; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Procedures" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Procedures" OWNER TO conrad;

--
-- Name: Proceedings; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Proceedings" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Proceedings" OWNER TO conrad;

--
-- Name: Processes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Processes" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Processes" OWNER TO conrad;

--
-- Name: Users; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Users" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Users" OWNER TO conrad;

--
-- Name: Vulnerabilities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Vulnerabilities" (
    "ID" bigint NOT NULL
);


ALTER TABLE public."Vulnerabilities" OWNER TO conrad;

--
-- Data for Name: AuthDomains; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "AuthDomains"  FROM stdin;
\.


--
-- Data for Name: Domains; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Domains" ("ID", name, organization_id) FROM stdin;
\.


--
-- Data for Name: EventSources; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "EventSources"  FROM stdin;
\.


--
-- Data for Name: EventTypes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "EventTypes"  FROM stdin;
\.


--
-- Data for Name: Events; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Events" ("ID", "Timestamp") FROM stdin;
\.


--
-- Data for Name: GeolocationRegions; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "GeolocationRegions" ("ID") FROM stdin;
\.


--
-- Data for Name: Geolocations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Geolocations" ("ID") FROM stdin;
\.


--
-- Data for Name: HostConfigs; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "HostConfigs" ("ID") FROM stdin;
\.


--
-- Data for Name: Hosts; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Hosts" ("ID", hostname, dnsname, address, mac, domain_id, authdomain_id) FROM stdin;
\.


--
-- Data for Name: Incidents; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Incidents" ("ID", creationtime, title, impact_id) FROM stdin;
\.


--
-- Data for Name: IntelligenceEntities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceEntities" ("ID", source_id, type_id) FROM stdin;
\.


--
-- Data for Name: IntelligenceSources; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceSources" ("ID", name, location, lastupdated) FROM stdin;
\.


--
-- Data for Name: IntelligenceTypes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceTypes" ("ID", typename) FROM stdin;
\.


--
-- Data for Name: Investigations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Investigations" ("ID") FROM stdin;
\.


--
-- Data for Name: KnowledgeBase; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "KnowledgeBase" ("ID") FROM stdin;
\.


--
-- Data for Name: Networks; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Networks" ("ID", address, mask, subnet, zone, description, geolocation_id) FROM stdin;
\.


--
-- Data for Name: Notes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Notes" ("ID") FROM stdin;
\.


--
-- Data for Name: OrgUnits; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "OrgUnits" ("ID") FROM stdin;
\.


--
-- Data for Name: Organizations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Organizations" ("ID") FROM stdin;
\.


--
-- Data for Name: Platforms; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Platforms" ("ID") FROM stdin;
\.


--
-- Data for Name: Procedures; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Procedures" ("ID") FROM stdin;
\.


--
-- Data for Name: Proceedings; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Proceedings" ("ID") FROM stdin;
\.


--
-- Data for Name: Processes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Processes" ("ID") FROM stdin;
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Users" ("ID") FROM stdin;
\.


--
-- Data for Name: Vulnerabilities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Vulnerabilities" ("ID") FROM stdin;
\.


--
-- Name: Events_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Events"
    ADD CONSTRAINT "Events_pkey" PRIMARY KEY ("ID");


--
-- Name: GeolocationRegions_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "GeolocationRegions"
    ADD CONSTRAINT "GeolocationRegions_pkey" PRIMARY KEY ("ID");


--
-- Name: Geolocations_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Geolocations"
    ADD CONSTRAINT "Geolocations_pkey" PRIMARY KEY ("ID");


--
-- Name: HostConfigs_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "HostConfigs"
    ADD CONSTRAINT "HostConfigs_pkey" PRIMARY KEY ("ID");


--
-- Name: Hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Hosts"
    ADD CONSTRAINT "Hosts_pkey" PRIMARY KEY ("ID");


--
-- Name: Incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Incidents"
    ADD CONSTRAINT "Incidents_pkey" PRIMARY KEY ("ID");


--
-- Name: IntelligenceEntities_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "IntelligenceEntities"
    ADD CONSTRAINT "IntelligenceEntities_pkey" PRIMARY KEY ("ID");


--
-- Name: IntelligenceSource_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "IntelligenceSources"
    ADD CONSTRAINT "IntelligenceSource_pkey" PRIMARY KEY ("ID");


--
-- Name: Investigations_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Investigations"
    ADD CONSTRAINT "Investigations_pkey" PRIMARY KEY ("ID");


--
-- Name: KnowledgeBase_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "KnowledgeBase"
    ADD CONSTRAINT "KnowledgeBase_pkey" PRIMARY KEY ("ID");


--
-- Name: Networks_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Networks"
    ADD CONSTRAINT "Networks_pkey" PRIMARY KEY ("ID");


--
-- Name: Notes_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Notes"
    ADD CONSTRAINT "Notes_pkey" PRIMARY KEY ("ID");


--
-- Name: Organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Organizations"
    ADD CONSTRAINT "Organizations_pkey" PRIMARY KEY ("ID");


--
-- Name: Platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Platforms"
    ADD CONSTRAINT "Platforms_pkey" PRIMARY KEY ("ID");


--
-- Name: Procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Procedures"
    ADD CONSTRAINT "Procedures_pkey" PRIMARY KEY ("ID");


--
-- Name: Proceedings_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Proceedings"
    ADD CONSTRAINT "Proceedings_pkey" PRIMARY KEY ("ID");


--
-- Name: Processes_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Processes"
    ADD CONSTRAINT "Processes_pkey" PRIMARY KEY ("ID");


--
-- Name: Users_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("ID");


--
-- Name: Vulnerabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Vulnerabilities"
    ADD CONSTRAINT "Vulnerabilities_pkey" PRIMARY KEY ("ID");


--
-- Name: orgUnits_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "OrgUnits"
    ADD CONSTRAINT "orgUnits_pkey" PRIMARY KEY ("ID");


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

