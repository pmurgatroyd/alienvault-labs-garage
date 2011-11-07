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

--
-- Name: analysts_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE analysts_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analysts_pk_seq OWNER TO conrad;

--
-- Name: analysts_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('analysts_pk_seq', 0, false);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Analysts; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Analysts" (
    "ID" bigint DEFAULT nextval('analysts_pk_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE public."Analysts" OWNER TO conrad;

--
-- Name: authdomains_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE authdomains_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authdomains_pk_seq OWNER TO conrad;

--
-- Name: authdomains_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('authdomains_pk_seq', 0, false);


--
-- Name: AuthDomains; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "AuthDomains" (
    "ID" bigint DEFAULT nextval('authdomains_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."AuthDomains" OWNER TO conrad;

--
-- Name: domains_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE domains_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domains_pk_seq OWNER TO conrad;

--
-- Name: domains_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('domains_pk_seq', 0, false);


--
-- Name: Domains; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Domains" (
    "ID" bigint DEFAULT nextval('domains_pk_seq'::regclass) NOT NULL,
    name character varying(255),
    organization_id bigint
);


ALTER TABLE public."Domains" OWNER TO conrad;

--
-- Name: COLUMN "Domains"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Domains"."ID" IS 'Primary Key';


--
-- Name: eventsources_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE eventsources_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eventsources_pk_seq OWNER TO conrad;

--
-- Name: eventsources_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('eventsources_pk_seq', 0, false);


--
-- Name: EventSources; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "EventSources" (
    "ID" bigint DEFAULT nextval('eventsources_pk_seq'::regclass) NOT NULL,
    hostname character varying,
    address inet,
    type bigint,
    network_id bigint,
    description character varying
);


ALTER TABLE public."EventSources" OWNER TO conrad;

--
-- Name: COLUMN "EventSources".network_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "EventSources".network_id IS 'link to the networks table to indicate what network segment this event source resides on';


--
-- Name: eventtypes_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE eventtypes_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eventtypes_pk_seq OWNER TO conrad;

--
-- Name: eventtypes_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('eventtypes_pk_seq', 0, false);


--
-- Name: EventTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "EventTypes" (
    "ID" bigint DEFAULT nextval('eventtypes_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."EventTypes" OWNER TO conrad;

--
-- Name: events_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE events_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_pk_seq OWNER TO conrad;

--
-- Name: events_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('events_pk_seq', 0, false);


--
-- Name: Events; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Events" (
    "ID" bigint DEFAULT nextval('events_pk_seq'::regclass) NOT NULL,
    "Timestamp" date,
    incident_id bigint,
    type_id bigint NOT NULL,
    source_id bigint,
    dest_ids bigint[]
);


ALTER TABLE public."Events" OWNER TO conrad;

--
-- Name: COLUMN "Events"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events"."ID" IS 'Primary Key';


--
-- Name: geolocationregions_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE geolocationregions_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geolocationregions_pk_seq OWNER TO conrad;

--
-- Name: geolocationregions_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('geolocationregions_pk_seq', 0, false);


--
-- Name: GeolocationRegions; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "GeolocationRegions" (
    "ID" bigint DEFAULT nextval('geolocationregions_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."GeolocationRegions" OWNER TO conrad;

--
-- Name: COLUMN "GeolocationRegions"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeolocationRegions"."ID" IS 'Primary Key';


--
-- Name: geolocations_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE geolocations_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geolocations_pk_seq OWNER TO conrad;

--
-- Name: geolocations_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('geolocations_pk_seq', 0, false);


--
-- Name: Geolocations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Geolocations" (
    "ID" bigint DEFAULT nextval('geolocations_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Geolocations" OWNER TO conrad;

--
-- Name: COLUMN "Geolocations"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Geolocations"."ID" IS 'Primary Key';


--
-- Name: hostconfigs_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE hostconfigs_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hostconfigs_pk_seq OWNER TO conrad;

--
-- Name: hostconfigs_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('hostconfigs_pk_seq', 0, false);


--
-- Name: HostConfigs; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "HostConfigs" (
    "ID" bigint DEFAULT nextval('hostconfigs_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."HostConfigs" OWNER TO conrad;

--
-- Name: hosts_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE hosts_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hosts_pk_seq OWNER TO conrad;

--
-- Name: hosts_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('hosts_pk_seq', 0, false);


--
-- Name: Hosts; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Hosts" (
    "ID" bigint DEFAULT nextval('hosts_pk_seq'::regclass) NOT NULL,
    hostname character varying,
    dnsname character varying(63),
    address inet,
    mac macaddr,
    domain_id bigint,
    authdomain_id bigint
);


ALTER TABLE public."Hosts" OWNER TO conrad;

--
-- Name: COLUMN "Hosts"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Hosts"."ID" IS 'Primary Key';


--
-- Name: Incidents; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Incidents" (
    "ID" bigint DEFAULT nextval('hosts_pk_seq'::regclass) NOT NULL,
    creationtime date,
    title character varying,
    impact_id bigint,
    owner_id bigint,
    related_incidents bigint[]
);


ALTER TABLE public."Incidents" OWNER TO conrad;

--
-- Name: COLUMN "Incidents"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Incidents"."ID" IS 'Primary key';


--
-- Name: intelligenceindicatortypes_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE intelligenceindicatortypes_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intelligenceindicatortypes_pk_seq OWNER TO conrad;

--
-- Name: intelligenceindicatortypes_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('intelligenceindicatortypes_pk_seq', 0, false);


--
-- Name: IntelligenceIndicatorTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceIndicatorTypes" (
    "ID" bigint DEFAULT nextval('intelligenceindicatortypes_pk_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE public."IntelligenceIndicatorTypes" OWNER TO conrad;

--
-- Name: COLUMN "IntelligenceIndicatorTypes"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceIndicatorTypes"."ID" IS 'Primary Key';


--
-- Name: intelligenceindicators_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE intelligenceindicators_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intelligenceindicators_pk_seq OWNER TO conrad;

--
-- Name: intelligenceindicators_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('intelligenceindicators_pk_seq', 0, false);


--
-- Name: IntelligenceIndicators; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceIndicators" (
    "ID" bigint DEFAULT nextval('intelligenceindicators_pk_seq'::regclass) NOT NULL,
    source_id bigint,
    type_id bigint,
    description character varying
);


ALTER TABLE public."IntelligenceIndicators" OWNER TO conrad;

--
-- Name: COLUMN "IntelligenceIndicators"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceIndicators"."ID" IS 'Primary Key';


--
-- Name: COLUMN "IntelligenceIndicators".description; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceIndicators".description IS 'human-readable description of the indicator type';


--
-- Name: intelligencesources_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE intelligencesources_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intelligencesources_pk_seq OWNER TO conrad;

--
-- Name: intelligencesources_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('intelligencesources_pk_seq', 0, false);


--
-- Name: IntelligenceSources; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceSources" (
    "ID" bigint DEFAULT nextval('intelligencesources_pk_seq'::regclass) NOT NULL,
    name character varying,
    location character varying,
    lastupdated date
);


ALTER TABLE public."IntelligenceSources" OWNER TO conrad;

--
-- Name: COLUMN "IntelligenceSources"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceSources"."ID" IS 'Primary Key';


--
-- Name: IntelligenceTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceTypes" (
    "ID" bigint NOT NULL,
    typename character varying NOT NULL
);


ALTER TABLE public."IntelligenceTypes" OWNER TO conrad;

--
-- Name: investigations_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE investigations_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.investigations_pk_seq OWNER TO conrad;

--
-- Name: investigations_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('investigations_pk_seq', 0, false);


--
-- Name: Investigations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Investigations" (
    "ID" bigint DEFAULT nextval('investigations_pk_seq'::regclass) NOT NULL,
    title character varying,
    owner_id bigint
);


ALTER TABLE public."Investigations" OWNER TO conrad;

--
-- Name: COLUMN "Investigations"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Investigations"."ID" IS 'Primary Key';


--
-- Name: knowledgebase_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE knowledgebase_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knowledgebase_pk_seq OWNER TO conrad;

--
-- Name: knowledgebase_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('knowledgebase_pk_seq', 0, false);


--
-- Name: KnowledgeBase; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "KnowledgeBase" (
    "ID" bigint DEFAULT nextval('knowledgebase_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."KnowledgeBase" OWNER TO conrad;

--
-- Name: COLUMN "KnowledgeBase"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "KnowledgeBase"."ID" IS 'Primary Key';


--
-- Name: networks_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE networks_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.networks_pk_seq OWNER TO conrad;

--
-- Name: networks_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('networks_pk_seq', 0, false);


--
-- Name: Networks; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Networks" (
    "ID" bigint DEFAULT nextval('networks_pk_seq'::regclass) NOT NULL,
    address inet NOT NULL,
    mask smallint NOT NULL,
    subnet cidr NOT NULL,
    zone character varying,
    description character varying,
    geolocation_id bigint,
    domain_id bigint
);


ALTER TABLE public."Networks" OWNER TO conrad;

--
-- Name: TABLE "Networks"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Networks" IS 'Discrete Subnet ranges';


--
-- Name: COLUMN "Networks"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks"."ID" IS 'Primary Key';


--
-- Name: COLUMN "Networks".address; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".address IS 'Base network address IP';


--
-- Name: COLUMN "Networks".mask; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".mask IS 'CIDR style mask bits';


--
-- Name: COLUMN "Networks".subnet; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".subnet IS 'CIDR subnet';


--
-- Name: COLUMN "Networks".zone; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".zone IS 'The network''s classification';


--
-- Name: COLUMN "Networks".description; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".description IS 'A free-form description of this subnets purpose and characteristics';


--
-- Name: COLUMN "Networks".geolocation_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".geolocation_id IS 'Link to the geolocation for where this subnet is physically located';


--
-- Name: COLUMN "Networks".domain_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".domain_id IS 'link to the domain this network reverse maps to';


--
-- Name: notes_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE notes_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_pk_seq OWNER TO conrad;

--
-- Name: notes_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('notes_pk_seq', 0, false);


--
-- Name: Notes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Notes" (
    "ID" bigint DEFAULT nextval('notes_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Notes" OWNER TO conrad;

--
-- Name: TABLE "Notes"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Notes" IS 'Short notes about any entity in this database';


--
-- Name: COLUMN "Notes"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Notes"."ID" IS 'Primary Key';


--
-- Name: orgunits_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE orgunits_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orgunits_pk_seq OWNER TO conrad;

--
-- Name: orgunits_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('orgunits_pk_seq', 0, false);


--
-- Name: OrgUnits; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "OrgUnits" (
    "ID" bigint DEFAULT nextval('orgunits_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."OrgUnits" OWNER TO conrad;

--
-- Name: TABLE "OrgUnits"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "OrgUnits" IS 'Organizational Units within the monitored space.';


--
-- Name: COLUMN "OrgUnits"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "OrgUnits"."ID" IS 'Primary Key';


--
-- Name: organizations_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE organizations_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_pk_seq OWNER TO conrad;

--
-- Name: organizations_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('organizations_pk_seq', 0, false);


--
-- Name: Organizations; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Organizations" (
    "ID" bigint DEFAULT nextval('organizations_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Organizations" OWNER TO conrad;

--
-- Name: TABLE "Organizations"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Organizations" IS 'Commercial and Other Registered organizations listed as the owners of internet elements';


--
-- Name: COLUMN "Organizations"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Organizations"."ID" IS 'Primary Key';


--
-- Name: Platforms; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Platforms" (
    "ID" bigint DEFAULT nextval('analysts_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Platforms" OWNER TO conrad;

--
-- Name: TABLE "Platforms"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Platforms" IS 'Platform Definitions for host systems';


--
-- Name: COLUMN "Platforms"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Platforms"."ID" IS 'Primary Key';


--
-- Name: procedures_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE procedures_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedures_pk_seq OWNER TO conrad;

--
-- Name: procedures_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('procedures_pk_seq', 0, false);


--
-- Name: Procedures; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Procedures" (
    "ID" bigint DEFAULT nextval('procedures_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Procedures" OWNER TO conrad;

--
-- Name: TABLE "Procedures"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Procedures" IS 'Procedures for handling Event Records';


--
-- Name: COLUMN "Procedures"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Procedures"."ID" IS 'Primary Key';


--
-- Name: proceedings_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE proceedings_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proceedings_pk_seq OWNER TO conrad;

--
-- Name: proceedings_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('proceedings_pk_seq', 0, false);


--
-- Name: Proceedings; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Proceedings" (
    "ID" bigint DEFAULT nextval('proceedings_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Proceedings" OWNER TO conrad;

--
-- Name: TABLE "Proceedings"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Proceedings" IS 'Proceedings documents for handling Investigation Records';


--
-- Name: COLUMN "Proceedings"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Proceedings"."ID" IS 'Primary Key';


--
-- Name: processes_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE processes_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.processes_pk_seq OWNER TO conrad;

--
-- Name: processes_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('processes_pk_seq', 0, false);


--
-- Name: Processes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Processes" (
    "ID" bigint DEFAULT nextval('processes_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Processes" OWNER TO conrad;

--
-- Name: TABLE "Processes"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Processes" IS 'Process documents for guiding handling of Incident Records';


--
-- Name: COLUMN "Processes"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Processes"."ID" IS 'Primary Key';


--
-- Name: users_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE users_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_pk_seq OWNER TO conrad;

--
-- Name: users_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('users_pk_seq', 0, false);


--
-- Name: Users; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Users" (
    "ID" bigint DEFAULT nextval('users_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Users" OWNER TO conrad;

--
-- Name: COLUMN "Users"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Users"."ID" IS 'Primary Key';


--
-- Name: vulnerabilities_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE vulnerabilities_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerabilities_pk_seq OWNER TO conrad;

--
-- Name: vulnerabilities_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('vulnerabilities_pk_seq', 0, false);


--
-- Name: Vulnerabilities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Vulnerabilities" (
    "ID" bigint DEFAULT nextval('vulnerabilities_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public."Vulnerabilities" OWNER TO conrad;

--
-- Name: COLUMN "Vulnerabilities"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Vulnerabilities"."ID" IS 'Primary Key';


--
-- Name: incidents_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE incidents_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incidents_pk_seq OWNER TO conrad;

--
-- Name: incidents_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('incidents_pk_seq', 0, false);


--
-- Name: intelligencetype_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE intelligencetype_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intelligencetype_pk_seq OWNER TO conrad;

--
-- Name: intelligencetype_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('intelligencetype_pk_seq', 0, false);


--
-- Name: organazations_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE organazations_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organazations_pk_seq OWNER TO conrad;

--
-- Name: organazations_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('organazations_pk_seq', 0, false);


--
-- Name: platforms_pk_seq; Type: SEQUENCE; Schema: public; Owner: conrad
--

CREATE SEQUENCE platforms_pk_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.platforms_pk_seq OWNER TO conrad;

--
-- Name: platforms_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('platforms_pk_seq', 0, false);


--
-- Data for Name: Analysts; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Analysts" ("ID", name) FROM stdin;
\.


--
-- Data for Name: AuthDomains; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "AuthDomains" ("ID") FROM stdin;
\.


--
-- Data for Name: Domains; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Domains" ("ID", name, organization_id) FROM stdin;
\.


--
-- Data for Name: EventSources; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "EventSources" ("ID", hostname, address, type, network_id, description) FROM stdin;
\.


--
-- Data for Name: EventTypes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "EventTypes" ("ID") FROM stdin;
\.


--
-- Data for Name: Events; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Events" ("ID", "Timestamp", incident_id, type_id, source_id, dest_ids) FROM stdin;
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

COPY "Incidents" ("ID", creationtime, title, impact_id, owner_id, related_incidents) FROM stdin;
\.


--
-- Data for Name: IntelligenceIndicatorTypes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceIndicatorTypes" ("ID", name) FROM stdin;
\.


--
-- Data for Name: IntelligenceIndicators; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "IntelligenceIndicators" ("ID", source_id, type_id, description) FROM stdin;
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

COPY "Investigations" ("ID", title, owner_id) FROM stdin;
\.


--
-- Data for Name: KnowledgeBase; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "KnowledgeBase" ("ID") FROM stdin;
\.


--
-- Data for Name: Networks; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Networks" ("ID", address, mask, subnet, zone, description, geolocation_id, domain_id) FROM stdin;
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

ALTER TABLE ONLY "IntelligenceIndicators"
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
-- Name: address_uniq; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Networks"
    ADD CONSTRAINT address_uniq UNIQUE (address);


--
-- Name: CONSTRAINT address_uniq ON "Networks"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON CONSTRAINT address_uniq ON "Networks" IS 'Networks should only appear once';


--
-- Name: eventtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "EventTypes"
    ADD CONSTRAINT eventtypes_pkey PRIMARY KEY ("ID");


--
-- Name: intelligencetypes_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "IntelligenceTypes"
    ADD CONSTRAINT intelligencetypes_pkey PRIMARY KEY ("ID");


--
-- Name: orgUnits_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "OrgUnits"
    ADD CONSTRAINT "orgUnits_pkey" PRIMARY KEY ("ID");


--
-- Name: fki_dest_fkey; Type: INDEX; Schema: public; Owner: conrad; Tablespace: 
--

CREATE INDEX fki_dest_fkey ON "Events" USING btree (source_id);


--
-- Name: dest_fkey; Type: FK CONSTRAINT; Schema: public; Owner: conrad
--

ALTER TABLE ONLY "Events"
    ADD CONSTRAINT dest_fkey FOREIGN KEY (source_id) REFERENCES "Hosts"("ID");


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

