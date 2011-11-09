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
-- Name: SEQUENCE analysts_pk_seq; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON SEQUENCE analysts_pk_seq IS 'Primary Key for Analysts Table';


--
-- Name: analysts_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('analysts_pk_seq', 1, true);


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
-- Name: SEQUENCE authdomains_pk_seq; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON SEQUENCE authdomains_pk_seq IS 'Primary Key for Authdomains table';


--
-- Name: authdomains_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('authdomains_pk_seq', 1, true);


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
-- Name: SEQUENCE domains_pk_seq; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON SEQUENCE domains_pk_seq IS 'Primary key for Domains table';


--
-- Name: domains_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: conrad
--

SELECT pg_catalog.setval('domains_pk_seq', 1, true);


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
-- Name: TABLE "Domains"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Domains" IS 'DNS Domains';


--
-- Name: COLUMN "Domains"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Domains"."ID" IS 'Primary Key';


--
-- Name: COLUMN "Domains".name; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Domains".name IS 'RFC-compliant domain name string';


--
-- Name: COLUMN "Domains".organization_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Domains".organization_id IS 'link to the org that owns this domain';


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
    "ID" bigint DEFAULT nextval('eventtypes_pk_seq'::regclass) NOT NULL,
    name character varying,
    procedure_id bigint,
    description character varying,
    eventsource_id bigint
);


ALTER TABLE public."EventTypes" OWNER TO conrad;

--
-- Name: TABLE "EventTypes"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "EventTypes" IS 'Event Types are the Events coming in from Security monitoring: Usually these are names of correlation rules and alerts. ';


--
-- Name: COLUMN "EventTypes"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "EventTypes"."ID" IS 'Primary Key';


--
-- Name: COLUMN "EventTypes".name; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "EventTypes".name IS 'The title of the Event';


--
-- Name: COLUMN "EventTypes".procedure_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "EventTypes".procedure_id IS 'Link to the Procedure record that describes how to address the event';


--
-- Name: COLUMN "EventTypes".description; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "EventTypes".description IS 'a longer-form description of what the event represents';


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
-- Name: SEQUENCE events_pk_seq; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON SEQUENCE events_pk_seq IS 'Primary key for Events table';


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
    case_id bigint,
    type_id bigint NOT NULL,
    source_id bigint,
    dest_ids bigint[],
    "IndicatorOfCompromise" bit(1),
    rawdata character varying
);


ALTER TABLE public."Events" OWNER TO conrad;

--
-- Name: TABLE "Events"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Events" IS 'Security-Relevant Events and Alerts, from Controls';


--
-- Name: COLUMN "Events"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events"."ID" IS 'Primary Key';


--
-- Name: COLUMN "Events".case_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events".case_id IS 'Link to the case record this event supports';


--
-- Name: COLUMN "Events".type_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events".type_id IS 'Link to this event''s Type';


--
-- Name: COLUMN "Events"."IndicatorOfCompromise"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events"."IndicatorOfCompromise" IS 'Is this event an Indicator of Compromise?';


--
-- Name: COLUMN "Events".rawdata; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Events".rawdata IS 'Raw message of the Event';


--
-- Name: GeoLocationRegions; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "GeoLocationRegions" (
    "ID" bigint NOT NULL,
    "Region" character varying,
    "Country" character varying,
    "Zone" character varying,
    "Postcode" character varying,
    "CountryCode" character(2)
);


ALTER TABLE public."GeoLocationRegions" OWNER TO conrad;

--
-- Name: TABLE "GeoLocationRegions"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "GeoLocationRegions" IS 'Geographic Named Locations';


--
-- Name: COLUMN "GeoLocationRegions"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeoLocationRegions"."ID" IS 'Primary Key';


--
-- Name: COLUMN "GeoLocationRegions"."Region"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeoLocationRegions"."Region" IS 'Region within a nation (State, County, Territory, etc)';


--
-- Name: COLUMN "GeoLocationRegions"."Country"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeoLocationRegions"."Country" IS 'ISO Country Name';


--
-- Name: COLUMN "GeoLocationRegions"."CountryCode"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeoLocationRegions"."CountryCode" IS 'ISO 2-Character Country Code';


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
-- Name: GeolocationCities; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "GeolocationCities" (
    "ID" bigint DEFAULT nextval('geolocationregions_pk_seq'::regclass) NOT NULL,
    "Region" character varying,
    "City" character varying,
    "Country" character varying
);


ALTER TABLE public."GeolocationCities" OWNER TO conrad;

--
-- Name: COLUMN "GeolocationCities"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "GeolocationCities"."ID" IS 'Primary Key';


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
    "ID" bigint DEFAULT nextval('geolocations_pk_seq'::regclass) NOT NULL,
    latitude numeric,
    longitude numeric,
    radius numeric,
    city_id bigint
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
-- Name: TABLE "Hosts"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Hosts" IS 'Hosts are discrete working systems (usually a hardware platform) that may have multiple interfaces and addresses';


--
-- Name: COLUMN "Hosts"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Hosts"."ID" IS 'Primary Key';


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
-- Name: Incidents; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Incidents" (
    "ID" bigint DEFAULT nextval('incidents_pk_seq'::regclass) NOT NULL,
    creationtime date,
    title character varying,
    impact_id bigint,
    owner_id bigint,
    related_incidents bigint[]
);


ALTER TABLE public."Incidents" OWNER TO conrad;

--
-- Name: TABLE "Incidents"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Incidents" IS 'Incidents are Case Groupings that have passed certain thresholds to become active Incidents';


--
-- Name: COLUMN "Incidents"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Incidents"."ID" IS 'Primary key';


--
-- Name: COLUMN "Incidents".creationtime; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Incidents".creationtime IS 'Time the incident was first elevated from a Case';


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
-- Name: TABLE "IntelligenceIndicators"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "IntelligenceIndicators" IS 'Specific IOC''s for mapping event data against';


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
    name character varying NOT NULL,
    location character varying,
    lastupdated date
);


ALTER TABLE public."IntelligenceSources" OWNER TO conrad;

--
-- Name: COLUMN "IntelligenceSources"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceSources"."ID" IS 'Primary Key';


--
-- Name: COLUMN "IntelligenceSources".name; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceSources".name IS 'Short name of the Intelligence Provider. usually the name of the organization.';


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
-- Name: IntelligenceTypes; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "IntelligenceTypes" (
    "ID" bigint DEFAULT nextval('intelligencetype_pk_seq'::regclass) NOT NULL,
    typename character varying NOT NULL,
    typedescription character varying
);


ALTER TABLE public."IntelligenceTypes" OWNER TO conrad;

--
-- Name: TABLE "IntelligenceTypes"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "IntelligenceTypes" IS 'Intelligence Types describe specific data formats used to map for IOC''s';


--
-- Name: COLUMN "IntelligenceTypes"."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceTypes"."ID" IS 'Primary Key';


--
-- Name: COLUMN "IntelligenceTypes".typename; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceTypes".typename IS 'short form of the Intelligence Datatype name';


--
-- Name: COLUMN "IntelligenceTypes".typedescription; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "IntelligenceTypes".typedescription IS 'Extended description of what the intel type conveys';


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
-- Name: TABLE "Investigations"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Investigations" IS 'Investigations are a grouping of Incidents, that are likely all tied to the same threat actor or business-impacting event.';


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
    site_id bigint,
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
-- Name: COLUMN "Networks".site_id; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN "Networks".site_id IS 'Link to the physical site for where this subnet is physically located';


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
    "ID" bigint DEFAULT nextval('orgunits_pk_seq'::regclass) NOT NULL,
    name character varying,
    parent_id bigint,
    org_id bigint
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
-- Name: RiskFactors; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "RiskFactors" (
    "ID" bigint NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    zone_id character varying,
    duration interval
);


ALTER TABLE public."RiskFactors" OWNER TO conrad;

--
-- Name: RiskLayers; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "RiskLayers" (
    "ID" bigint NOT NULL,
    name character varying
);


ALTER TABLE public."RiskLayers" OWNER TO conrad;

--
-- Name: TABLE "RiskLayers"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "RiskLayers" IS 'Geometric Risk layers';


--
-- Name: RiskZones; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "RiskZones" (
    "ID" bigint NOT NULL,
    zone polygon NOT NULL
);


ALTER TABLE public."RiskZones" OWNER TO conrad;

--
-- Name: TABLE "RiskZones"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "RiskZones" IS 'Geometric risk areas';


--
-- Name: Sites; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE "Sites" (
);


ALTER TABLE public."Sites" OWNER TO conrad;

--
-- Name: TABLE "Sites"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE "Sites" IS 'Physical sites within the organization';


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
-- Name: users; Type: TABLE; Schema: public; Owner: conrad; Tablespace: 
--

CREATE TABLE users (
    "ID" bigint DEFAULT nextval('users_pk_seq'::regclass) NOT NULL
);


ALTER TABLE public.users OWNER TO conrad;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON TABLE users IS 'Users and access accounts';


--
-- Name: COLUMN users."ID"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON COLUMN users."ID" IS 'Primary Key';


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

COPY "EventTypes" ("ID", name, procedure_id, description, eventsource_id) FROM stdin;
\.


--
-- Data for Name: Events; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Events" ("ID", "Timestamp", case_id, type_id, source_id, dest_ids, "IndicatorOfCompromise", rawdata) FROM stdin;
\.


--
-- Data for Name: GeoLocationRegions; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "GeoLocationRegions" ("ID", "Region", "Country", "Zone", "Postcode", "CountryCode") FROM stdin;
\.


--
-- Data for Name: GeolocationCities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "GeolocationCities" ("ID", "Region", "City", "Country") FROM stdin;
\.


--
-- Data for Name: Geolocations; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Geolocations" ("ID", latitude, longitude, radius, city_id) FROM stdin;
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

COPY "IntelligenceTypes" ("ID", typename, typedescription) FROM stdin;
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

COPY "Networks" ("ID", address, mask, subnet, zone, description, site_id, domain_id) FROM stdin;
\.


--
-- Data for Name: Notes; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Notes" ("ID") FROM stdin;
\.


--
-- Data for Name: OrgUnits; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "OrgUnits" ("ID", name, parent_id, org_id) FROM stdin;
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
-- Data for Name: RiskFactors; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "RiskFactors" ("ID", name, description, zone_id, duration) FROM stdin;
\.


--
-- Data for Name: RiskLayers; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "RiskLayers" ("ID", name) FROM stdin;
\.


--
-- Data for Name: RiskZones; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "RiskZones" ("ID", zone) FROM stdin;
\.


--
-- Data for Name: Sites; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Sites"  FROM stdin;
\.


--
-- Data for Name: Vulnerabilities; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY "Vulnerabilities" ("ID") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: conrad
--

COPY users ("ID") FROM stdin;
\.


--
-- Name: Events_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "Events"
    ADD CONSTRAINT "Events_pkey" PRIMARY KEY ("ID");


--
-- Name: GeolocationRegions_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "GeolocationCities"
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

ALTER TABLE ONLY users
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
-- Name: geolocationregions_pkey; Type: CONSTRAINT; Schema: public; Owner: conrad; Tablespace: 
--

ALTER TABLE ONLY "GeoLocationRegions"
    ADD CONSTRAINT geolocationregions_pkey PRIMARY KEY ("ID");


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
-- Name: fki_geolocation_city_fkey; Type: INDEX; Schema: public; Owner: conrad; Tablespace: 
--

CREATE INDEX fki_geolocation_city_fkey ON "Geolocations" USING btree (city_id);


--
-- Name: fki_procedure_fkey; Type: INDEX; Schema: public; Owner: conrad; Tablespace: 
--

CREATE INDEX fki_procedure_fkey ON "EventTypes" USING btree (procedure_id);


--
-- Name: dest_fkey; Type: FK CONSTRAINT; Schema: public; Owner: conrad
--

ALTER TABLE ONLY "Events"
    ADD CONSTRAINT dest_fkey FOREIGN KEY (source_id) REFERENCES "Hosts"("ID");


--
-- Name: geolocation_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: conrad
--

ALTER TABLE ONLY "Geolocations"
    ADD CONSTRAINT geolocation_city_fkey FOREIGN KEY (city_id) REFERENCES "GeolocationCities"("ID") ON UPDATE RESTRICT;


--
-- Name: procedure_fkey; Type: FK CONSTRAINT; Schema: public; Owner: conrad
--

ALTER TABLE ONLY "EventTypes"
    ADD CONSTRAINT procedure_fkey FOREIGN KEY (procedure_id) REFERENCES "Procedures"("ID") ON UPDATE RESTRICT;


--
-- Name: CONSTRAINT procedure_fkey ON "EventTypes"; Type: COMMENT; Schema: public; Owner: conrad
--

COMMENT ON CONSTRAINT procedure_fkey ON "EventTypes" IS 'link to appropriate procedure for this event type';


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

