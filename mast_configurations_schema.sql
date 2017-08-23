--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.1
-- Started on 2016-04-05 09:11:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 315 (class 3079 OID 12617)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 315
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 316 (class 3079 OID 21624)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 316
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- TOC entry 1380 (class 1255 OID 23907)
-- Name: upd_usinstr(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_usinstr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN
       IF(TG_OP='INSERT') THEN
		IF(NEW.usin_str IS NULL) THEN
			Update public."spatial_unit" set usin_str = cast(to_char(New.usin,'000000000') as character varying) where usin = NEW.usin;
		END IF;
	END IF;
	RETURN NEW;
  END;
 $$;


ALTER FUNCTION public.upd_usinstr() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 300 (class 1259 OID 24240)
-- Name: Cosmetic_Line; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "Cosmetic_Line" (
    gid integer NOT NULL,
    id numeric(10,0),
    uid character varying(100),
    username character varying(100),
    the_geom geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'MULTILINESTRING'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


ALTER TABLE public."Cosmetic_Line" OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 24238)
-- Name: Cosmetic_Line_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Cosmetic_Line_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Cosmetic_Line_gid_seq" OWNER TO postgres;

--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 299
-- Name: Cosmetic_Line_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Cosmetic_Line_gid_seq" OWNED BY "Cosmetic_Line".gid;


--
-- TOC entry 302 (class 1259 OID 24255)
-- Name: Cosmetic_Point; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "Cosmetic_Point" (
    gid integer NOT NULL,
    id numeric(10,0),
    uid character varying(100),
    username character varying(100),
    label character varying(100),
    the_geom geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'POINT'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


ALTER TABLE public."Cosmetic_Point" OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 24253)
-- Name: Cosmetic_Point_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Cosmetic_Point_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Cosmetic_Point_gid_seq" OWNER TO postgres;

--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 301
-- Name: Cosmetic_Point_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Cosmetic_Point_gid_seq" OWNED BY "Cosmetic_Point".gid;


--
-- TOC entry 304 (class 1259 OID 24270)
-- Name: Cosmetic_Poly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "Cosmetic_Poly" (
    gid integer NOT NULL,
    id numeric(10,0),
    uid character varying(100),
    username character varying(100),
    the_geom geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


ALTER TABLE public."Cosmetic_Poly" OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 24268)
-- Name: Cosmetic_Poly_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Cosmetic_Poly_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Cosmetic_Poly_gid_seq" OWNER TO postgres;

--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 303
-- Name: Cosmetic_Poly_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Cosmetic_Poly_gid_seq" OWNED BY "Cosmetic_Poly".gid;


--
-- TOC entry 296 (class 1259 OID 24115)
-- Name: ilalasimba_harmlets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ilalasimba_harmlets (
    gid integer NOT NULL,
    id integer,
    harmlet_n character varying(50),
    the_geom geometry(MultiPolygon,4326)
);


ALTER TABLE public.ilalasimba_harmlets OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 24113)
-- Name: Ilalasimba_Harmlets_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Ilalasimba_Harmlets_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Ilalasimba_Harmlets_gid_seq" OWNER TO postgres;

--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 295
-- Name: Ilalasimba_Harmlets_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Ilalasimba_Harmlets_gid_seq" OWNED BY ilalasimba_harmlets.gid;


--
-- TOC entry 183 (class 1259 OID 22910)
-- Name: action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE action (
    name character varying(255) NOT NULL,
    description character varying(255),
    id integer NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.action OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 22916)
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actions_id_seq OWNER TO postgres;

--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 184
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE actions_id_seq OWNED BY action.id;


--
-- TOC entry 185 (class 1259 OID 22918)
-- Name: adjacent_property; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE adjacent_property (
    adjpropertyid integer NOT NULL,
    usin bigint NOT NULL,
    adjescent_usin integer NOT NULL,
    direction character varying NOT NULL
);


ALTER TABLE public.adjacent_property OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 22924)
-- Name: annual_holiday_calendar; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE annual_holiday_calendar (
    id integer NOT NULL,
    holiday_date date NOT NULL,
    holiday_type character varying(50),
    holiday_occassion character varying(100)
);


ALTER TABLE public.annual_holiday_calendar OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 22927)
-- Name: attachment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attachment (
    layername character varying(25) NOT NULL,
    keyfield character varying(25) NOT NULL,
    filename character varying(255),
    description character varying(255),
    extension character varying(20),
    id integer NOT NULL,
    tenantid character varying(25),
    filepath character varying(255) NOT NULL,
    associationid integer NOT NULL,
    gid integer NOT NULL
);


ALTER TABLE public.attachment OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 22933)
-- Name: attachment_associationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attachment_associationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attachment_associationid_seq OWNER TO postgres;

--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 188
-- Name: attachment_associationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attachment_associationid_seq OWNED BY attachment.associationid;


--
-- TOC entry 189 (class 1259 OID 22935)
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attachments_id_seq OWNER TO postgres;

--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 189
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachment.id;


--
-- TOC entry 190 (class 1259 OID 22937)
-- Name: attribute; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attribute (
    value character varying(3000) NOT NULL,
    attributevalueid bigint NOT NULL,
    parentuid bigint,
    uid bigint NOT NULL
);


ALTER TABLE public.attribute OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 22943)
-- Name: attribute_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attribute_category (
    attributecategoryid integer NOT NULL,
    category_name character varying NOT NULL
);


ALTER TABLE public.attribute_category OWNER TO postgres;

--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 191
-- Name: TABLE attribute_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE attribute_category IS '1. General
2. Person
3. Tenure
4 Multimedia
etc';


--
-- TOC entry 192 (class 1259 OID 22949)
-- Name: attribute_master; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attribute_master (
    id integer NOT NULL,
    alias character varying NOT NULL,
    fieldname character varying NOT NULL,
    datatype_id integer NOT NULL,
    attributecategoryid integer NOT NULL,
    reftable character varying NOT NULL,
    size character varying NOT NULL,
    mandatory boolean NOT NULL,
    listing integer,
    active boolean DEFAULT true,
    alias_second_language character varying,
    master_attrib boolean
);


ALTER TABLE public.attribute_master OWNER TO postgres;

--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 192
-- Name: TABLE attribute_master; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE attribute_master IS 'Stores all the attributes for lookup purpose';


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN attribute_master.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN attribute_master.id IS 'primary key';


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN attribute_master.alias; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN attribute_master.alias IS 'Display name';


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN attribute_master.fieldname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN attribute_master.fieldname IS 'actual field name';


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN attribute_master.reftable; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN attribute_master.reftable IS 'Stores the actual table name that the attribute extends';


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN attribute_master.mandatory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN attribute_master.mandatory IS 'true of the attribute refers to standard tables';


--
-- TOC entry 193 (class 1259 OID 22956)
-- Name: attribute_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attribute_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attribute_master_id_seq OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 22958)
-- Name: attribute_options; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attribute_options (
    id integer NOT NULL,
    optiontext character varying,
    attribute_id integer,
    optiontext_second_language character varying,
    parent_id integer
);


ALTER TABLE public.attribute_options OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 22964)
-- Name: attribute_value_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attribute_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attribute_value_id_seq OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 22966)
-- Name: baselayer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE baselayer_id_seq
    START WITH 9
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.baselayer_id_seq OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 22968)
-- Name: baselayer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE baselayer (
    id integer DEFAULT nextval('baselayer_id_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(100)
);


ALTER TABLE public.baselayer OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 22972)
-- Name: bookmark; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bookmark (
    name character varying(255) NOT NULL,
    description character varying(255),
    minx double precision NOT NULL,
    miny double precision NOT NULL,
    maxx double precision NOT NULL,
    maxy double precision NOT NULL,
    project character varying(25) NOT NULL,
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.bookmark OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 22978)
-- Name: bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE bookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookmark_id_seq OWNER TO postgres;

--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 199
-- Name: bookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE bookmark_id_seq OWNED BY bookmark.id;


--
-- TOC entry 314 (class 1259 OID 24376)
-- Name: citizenship; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE citizenship (
    id bigint NOT NULL,
    citizenname character varying(50),
    citizenname_sw character varying(50)
);


ALTER TABLE public.citizenship OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 22980)
-- Name: datatype_id; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE datatype_id (
    datatype_id integer NOT NULL,
    datatype character varying(25) NOT NULL
);


ALTER TABLE public.datatype_id OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 22983)
-- Name: defined_attributes_key_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE defined_attributes_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.defined_attributes_key_seq OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 22985)
-- Name: education_level; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE education_level (
    level_id integer NOT NULL,
    education_level character varying NOT NULL
);


ALTER TABLE public.education_level OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 22991)
-- Name: gender; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gender (
    gender_id integer NOT NULL,
    gender character varying NOT NULL,
    gender_sw character varying(50)
);


ALTER TABLE public.gender OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 22997)
-- Name: gender_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gender_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gender_id_seq OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 22999)
-- Name: group_person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_person (
    gid integer NOT NULL,
    group_name character varying(25),
    rep_person_gid bigint NOT NULL,
    ownership_type character varying(25)
);


ALTER TABLE public.group_person OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 23002)
-- Name: group_person_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE group_person_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_person_gid_seq OWNER TO postgres;

--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 206
-- Name: group_person_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE group_person_gid_seq OWNED BY group_person.gid;


--
-- TOC entry 290 (class 1259 OID 23876)
-- Name: group_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_type (
    group_id integer NOT NULL,
    group_value character varying(50),
    group_value_sw character varying(50)
);


ALTER TABLE public.group_type OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 23881)
-- Name: land_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE land_type (
    landtype_id integer NOT NULL,
    landtype_value character varying(50),
    landtype_value_sw character varying(50)
);


ALTER TABLE public.land_type OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 23004)
-- Name: land_use_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE land_use_type (
    use_type_id integer NOT NULL,
    land_use_type character varying NOT NULL,
    land_use_type_sw character varying(50)
);


ALTER TABLE public.land_use_type OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 23010)
-- Name: layer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE layer (
    name character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    projection character varying(255) NOT NULL,
    unit character varying(255),
    maxextent character varying(255) NOT NULL,
    minextent character varying(255),
    maxresolution integer,
    minresolution integer,
    numzoomlevels integer,
    minscale integer,
    maxscale integer,
    transitioneffect character varying(255),
    type character varying(255) NOT NULL,
    style text,
    filter character varying(255),
    url character varying(255) NOT NULL,
    tilesize integer,
    buffer integer,
    format character varying(255) NOT NULL,
    apikey character varying(255),
    version character varying(255),
    featurens character varying(255),
    featuretype character varying(255),
    geometryname character varying(255),
    schemaname character varying(255),
    geomtype character varying(255),
    wfsname character varying(255),
    displayname character varying(255),
    tenantid character varying(50),
    isbaselayer boolean DEFAULT false,
    displayinlayermanager boolean DEFAULT false,
    displayoutsidemaxextent boolean DEFAULT false,
    wrapdateline boolean DEFAULT false,
    sphericalmercator boolean DEFAULT false,
    editable boolean DEFAULT false,
    queryable boolean DEFAULT false,
    exportable boolean DEFAULT false,
    selectable boolean DEFAULT false,
    tiled boolean DEFAULT true,
    visibility boolean DEFAULT true
);


ALTER TABLE public.layer OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 23027)
-- Name: layer_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE layer_fields_id_seq
    START WITH 8105
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layer_fields_id_seq OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 23029)
-- Name: layer_field; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE layer_field (
    layer character varying(255) NOT NULL,
    field character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    keyfield character varying(255) NOT NULL,
    id integer DEFAULT nextval('layer_fields_id_seq'::regclass) NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.layer_field OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 23036)
-- Name: layer_layergroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE layer_layergroup (
    layer character varying(255) NOT NULL,
    layergroup character varying(255) NOT NULL,
    layerorder integer NOT NULL,
    id integer NOT NULL,
    tenantid character varying(50),
    layervisibility boolean DEFAULT true NOT NULL
);


ALTER TABLE public.layer_layergroup OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 23043)
-- Name: layer_layergroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE layer_layergroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layer_layergroup_id_seq OWNER TO postgres;

--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 212
-- Name: layer_layergroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE layer_layergroup_id_seq OWNED BY layer_layergroup.id;


--
-- TOC entry 213 (class 1259 OID 23045)
-- Name: layergroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE layergroup (
    name character varying(255) NOT NULL,
    alias character varying(255),
    id integer NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.layergroup OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 23051)
-- Name: layergroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE layergroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layergroup_id_seq OWNER TO postgres;

--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 214
-- Name: layergroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE layergroup_id_seq OWNED BY layergroup.id;


--
-- TOC entry 215 (class 1259 OID 23053)
-- Name: layertype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE layertype (
    name character varying(255) NOT NULL,
    description character varying(255),
    id integer NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.layertype OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 23059)
-- Name: layertype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE layertype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layertype_id_seq OWNER TO postgres;

--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 216
-- Name: layertype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE layertype_id_seq OWNED BY layertype.id;


--
-- TOC entry 217 (class 1259 OID 23061)
-- Name: maptip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE maptip (
    name character varying(25) NOT NULL,
    project character varying(255) NOT NULL,
    layer character varying(255) NOT NULL,
    queryexpression character varying,
    field character varying(25) NOT NULL
);


ALTER TABLE public.maptip OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 23067)
-- Name: marital_status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE marital_status (
    maritalstatus_id integer NOT NULL,
    maritalstatus character varying NOT NULL,
    maritalstatus_sw character varying(50)
);


ALTER TABLE public.marital_status OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 23073)
-- Name: marital_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE marital_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.marital_status_id_seq OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 23075)
-- Name: module; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE module (
    name character varying(25) NOT NULL,
    description character varying(255),
    tenantid character varying(25),
    id integer NOT NULL
);


ALTER TABLE public.module OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 23078)
-- Name: module_action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE module_action (
    action character varying(25) NOT NULL,
    module character varying(25) NOT NULL,
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.module_action OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 23081)
-- Name: module_action_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE module_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.module_action_id_seq OWNER TO postgres;

--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 222
-- Name: module_action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE module_action_id_seq OWNED BY module_action.id;


--
-- TOC entry 223 (class 1259 OID 23083)
-- Name: module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.module_id_seq OWNER TO postgres;

--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 223
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE module_id_seq OWNED BY module.id;


--
-- TOC entry 224 (class 1259 OID 23085)
-- Name: module_role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE module_role (
    role character varying(25) NOT NULL,
    module character varying(25) NOT NULL,
    action character varying(25),
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.module_role OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 23088)
-- Name: natural_person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE natural_person (
    gid bigint NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    middle_name character varying(100),
    alias character varying,
    gender integer NOT NULL,
    photo bytea,
    mobile character varying(100),
    identity character varying(50),
    age integer DEFAULT 0,
    occupation character varying(100),
    occ_age_below integer DEFAULT 0,
    tenure_relation character varying(50),
    household_relation character varying(50),
    witness character varying(100),
    marital_status integer,
    household_gid integer,
    active boolean DEFAULT true,
    education integer,
    administator character varying(100),
    citizenship character varying(100),
    owner boolean DEFAULT false,
    resident_of_village boolean DEFAULT false,
    personsub_type integer,
    citizenship_id bigint DEFAULT 0
);


ALTER TABLE public.natural_person OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 23097)
-- Name: natural_person_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE natural_person_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.natural_person_gid_seq OWNER TO postgres;

--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 226
-- Name: natural_person_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE natural_person_gid_seq OWNED BY natural_person.gid;


--
-- TOC entry 227 (class 1259 OID 23099)
-- Name: non_natural_person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE non_natural_person (
    non_natural_person_gid bigint NOT NULL,
    instutution_name character varying NOT NULL,
    address character varying,
    phone_number character varying,
    poc_gid bigint,
    active boolean DEFAULT true,
    group_type integer
);


ALTER TABLE public.non_natural_person OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 23106)
-- Name: nonspatial_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nonspatial_attachments_id_seq
    START WITH 89
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nonspatial_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 23108)
-- Name: nonspatial_attachment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nonspatial_attachment (
    layername character varying(25) NOT NULL,
    keyfield character varying(25) NOT NULL,
    filename character varying(255),
    description character varying(255),
    extension character varying(20),
    id integer DEFAULT nextval('nonspatial_attachments_id_seq'::regclass) NOT NULL,
    tenantid character varying(25),
    filepath character varying(255) NOT NULL,
    associationid integer NOT NULL,
    gid integer NOT NULL
);


ALTER TABLE public.nonspatial_attachment OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 23115)
-- Name: nonspatial_attachment_associationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nonspatial_attachment_associationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nonspatial_attachment_associationid_seq OWNER TO postgres;

--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 230
-- Name: nonspatial_attachment_associationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nonspatial_attachment_associationid_seq OWNED BY nonspatial_attachment.associationid;


--
-- TOC entry 231 (class 1259 OID 23117)
-- Name: occupancy_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE occupancy_type (
    occupancy_type_id integer NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.occupancy_type OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 23123)
-- Name: occupancy_type_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE occupancy_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.occupancy_type_gid_seq OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 23125)
-- Name: outputformat; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE outputformat (
    name character varying(255) NOT NULL,
    mimetype character varying(255),
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.outputformat OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 23131)
-- Name: outputformat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE outputformat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.outputformat_id_seq OWNER TO postgres;

--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 234
-- Name: outputformat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE outputformat_id_seq OWNED BY outputformat.id;


--
-- TOC entry 235 (class 1259 OID 23133)
-- Name: overviewmap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE overviewmap (
    project character varying(25) NOT NULL,
    layer character varying(25) NOT NULL,
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.overviewmap OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 23136)
-- Name: overviewmap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE overviewmap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.overviewmap_id_seq OWNER TO postgres;

--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 236
-- Name: overviewmap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE overviewmap_id_seq OWNED BY overviewmap.id;


--
-- TOC entry 237 (class 1259 OID 23138)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    person_gid bigint NOT NULL,
    person_type_gid integer NOT NULL,
    resident boolean NOT NULL,
    mobile_group_id character varying
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 24196)
-- Name: personadmin_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personadmin_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personadmin_gid_seq OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 24167)
-- Name: person_administrator; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person_administrator (
    adminid bigint DEFAULT nextval('personadmin_gid_seq'::regclass) NOT NULL,
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100),
    gender integer NOT NULL,
    age integer DEFAULT 0,
    maritalstatus integer NOT NULL,
    citizenship character varying(100),
    address character varying(300),
    resident boolean DEFAULT true NOT NULL,
    phonenumber character varying(10)
);


ALTER TABLE public.person_administrator OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 23144)
-- Name: person_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE person_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_gid_seq OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 23146)
-- Name: person_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person_type (
    person_type_gid integer NOT NULL,
    person_type character varying NOT NULL,
    person_type_sw character varying
);


ALTER TABLE public.person_type OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 23152)
-- Name: person_type_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE person_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_type_gid_seq OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 23154)
-- Name: printtemplate; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE printtemplate (
    name character varying(255) NOT NULL,
    templatefile character varying(2000) NOT NULL,
    project character varying(255),
    id integer NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.printtemplate OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 23160)
-- Name: printtemplate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE printtemplate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.printtemplate_id_seq OWNER TO postgres;

--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 242
-- Name: printtemplate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE printtemplate_id_seq OWNED BY printtemplate.id;


--
-- TOC entry 243 (class 1259 OID 23162)
-- Name: project; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project (
    name character varying(25) NOT NULL,
    width integer,
    height integer,
    projection character varying(25),
    unit character varying(25),
    minresolutions double precision,
    maxresolutions double precision,
    numzoomlevels integer,
    displayprojection character varying(25),
    outputformat character varying(25),
    copyright character varying(255),
    watermask character varying(255),
    thumbnail bytea,
    disclaimer text,
    activelayer character varying(25) NOT NULL,
    description character varying(255),
    overlaymap character varying(25),
    id integer,
    tenantid character varying(25),
    active boolean,
    cosmetic boolean,
    minextent character varying(255),
    maxextent character varying(255),
    restrictedextent character varying(255),
    admincreated boolean DEFAULT true,
    owner character varying(255)
);


ALTER TABLE public.project OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 24288)
-- Name: project_adjudicators; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_adjudicators (
    id integer NOT NULL,
    project_name character varying(100),
    adjudicator_name character varying(200)
);


ALTER TABLE public.project_adjudicators OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 24298)
-- Name: project_adjudicators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_adjudicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_adjudicators_id_seq OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 23169)
-- Name: project_area; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_area (
    bounding_box character varying(100),
    projectid integer,
    city character varying(50),
    gid integer,
    location character varying(50),
    perimeter character varying(35),
    category character varying(25),
    initiation_date date NOT NULL,
    recommendation_date date,
    village_chairman character varying,
    authority_approve boolean,
    village_chairman_approval_date date,
    approving_executive character varying,
    executive_approve boolean,
    executive_approval_date date,
    name character varying(100) NOT NULL,
    country_name character varying(30) NOT NULL,
    state_name character varying(30),
    province character varying(25),
    district_name character varying(25) NOT NULL,
    municipality character varying(25),
    region character varying(25) NOT NULL,
    wards character varying(30),
    village character varying(30),
    area_id integer NOT NULL,
    district_officer character varying(200),
    village_code character varying(10),
    address character varying(200)
);


ALTER TABLE public.project_area OWNER TO postgres;

--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN project_area.bounding_box; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN project_area.bounding_box IS 'store values as xmin,xmax,ymin,ymax';


--
-- TOC entry 245 (class 1259 OID 23175)
-- Name: project_area_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_area_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_area_gid_seq OWNER TO postgres;

--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 245
-- Name: project_area_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE project_area_gid_seq OWNED BY project_area.gid;


--
-- TOC entry 246 (class 1259 OID 23177)
-- Name: project_baselayer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_baselayer_id_seq
    START WITH 379
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_baselayer_id_seq OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 23179)
-- Name: project_baselayer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_baselayer (
    id integer DEFAULT nextval('project_baselayer_id_seq'::regclass) NOT NULL,
    project character varying NOT NULL,
    baselayer character varying NOT NULL,
    baselayerorder integer NOT NULL
);


ALTER TABLE public.project_baselayer OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 24300)
-- Name: project_hamlets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_hamlets (
    id bigint NOT NULL,
    hamlet_name character varying(100),
    project_name character varying(100),
    hamlet_name_second_language character varying(100),
    hamlet_code character varying(10),
    count integer
)
WITH (autovacuum_enabled=true);


ALTER TABLE public.project_hamlets OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 24310)
-- Name: project_hamlets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_hamlets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_hamlets_id_seq OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 23186)
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_id_seq OWNER TO postgres;

--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 248
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE project_id_seq OWNED BY project.id;


--
-- TOC entry 249 (class 1259 OID 23188)
-- Name: project_layergroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_layergroup (
    project character varying(255) NOT NULL,
    layergroup character varying(255) NOT NULL,
    grouporder integer NOT NULL,
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.project_layergroup OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 23194)
-- Name: project_layergroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_layergroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_layergroup_id_seq OWNER TO postgres;

--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 250
-- Name: project_layergroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE project_layergroup_id_seq OWNED BY project_layergroup.id;


--
-- TOC entry 251 (class 1259 OID 23196)
-- Name: project_region; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_region (
    gid integer NOT NULL,
    country_name character varying(30),
    state_name character varying(30),
    province character varying(25),
    district_name character varying(25),
    municipality character varying(25),
    region character varying(25),
    division character varying(30),
    wards character varying(30),
    village character varying(30),
    hamlet character varying(30)
);


ALTER TABLE public.project_region OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 23199)
-- Name: project_region_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_region_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_region_gid_seq OWNER TO postgres;

--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 252
-- Name: project_region_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE project_region_gid_seq OWNED BY project_region.gid;


--
-- TOC entry 253 (class 1259 OID 23201)
-- Name: project_spatial_data; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project_spatial_data (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    file_name character varying(50) NOT NULL,
    file_extension character varying(10) NOT NULL,
    file_location character varying NOT NULL,
    file_size integer DEFAULT 0,
    alias character varying(50)
);


ALTER TABLE public.project_spatial_data OWNER TO postgres;

--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE project_spatial_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE project_spatial_data IS 'table to store spatial data upload details';


--
-- TOC entry 254 (class 1259 OID 23208)
-- Name: project_spatial_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_spatial_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_spatial_data_id_seq OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 23210)
-- Name: projection; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE projection (
    code character varying(25) NOT NULL,
    description character varying(255),
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.projection OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 23213)
-- Name: projection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE projection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projection_id_seq OWNER TO postgres;

--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 256
-- Name: projection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE projection_id_seq OWNED BY projection.id;


--
-- TOC entry 257 (class 1259 OID 23215)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role (
    name character varying(25) NOT NULL,
    description character varying(255),
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 23218)
-- Name: role_module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_module_id_seq OWNER TO postgres;

--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 258
-- Name: role_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role_module_id_seq OWNED BY module_role.id;


--
-- TOC entry 259 (class 1259 OID 23220)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 259
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roles_id_seq OWNED BY role.id;


--
-- TOC entry 260 (class 1259 OID 23222)
-- Name: savedquery; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE savedquery (
    name character varying(25) NOT NULL,
    layer character varying(25) NOT NULL,
    whereexpression character varying(255) NOT NULL,
    description character varying(255),
    project character varying(25),
    tenantid character varying(25)
);


ALTER TABLE public.savedquery OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 23228)
-- Name: share_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE share_type (
    gid integer NOT NULL,
    share_type character varying NOT NULL,
    share_type_sw character varying
);


ALTER TABLE public.share_type OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 23886)
-- Name: slope_values; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE slope_values (
    id integer NOT NULL,
    slope_value character varying(50)
);


ALTER TABLE public.slope_values OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 23234)
-- Name: social_tenure_relationship; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE social_tenure_relationship (
    gid integer NOT NULL,
    social_tenure_relationship_type integer,
    usin bigint NOT NULL,
    share integer,
    person_gid bigint NOT NULL,
    occupancy_type_id integer,
    tenureclass_id integer,
    social_tenure_startdate date,
    social_tenure_enddate date,
    tenure_duration real,
    isactive boolean DEFAULT true,
    ccro_issue_date date,
    sharepercentage character varying(20) DEFAULT 0,
    resident boolean DEFAULT true
);


ALTER TABLE public.social_tenure_relationship OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 23238)
-- Name: social_tenure_relationship_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE social_tenure_relationship_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.social_tenure_relationship_gid_seq OWNER TO postgres;

--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 263
-- Name: social_tenure_relationship_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE social_tenure_relationship_gid_seq OWNED BY social_tenure_relationship.gid;


--
-- TOC entry 264 (class 1259 OID 23240)
-- Name: socialtenure_relationtype_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE socialtenure_relationtype_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialtenure_relationtype_gid_seq OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 23891)
-- Name: soil_quality_values; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE soil_quality_values (
    id integer NOT NULL,
    quality character varying(50)
);


ALTER TABLE public.soil_quality_values OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 23242)
-- Name: source_document; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE source_document (
    gid integer NOT NULL,
    id character varying(50),
    recordation date NOT NULL,
    scanned_source_document character varying(500),
    location_scanned_source_document character varying(1000),
    quality_type character varying(50),
    social_tenure_inventory_type character varying(50),
    spatial_unit_inventory_type character varying(50),
    comments character varying(2000),
    srs_id integer DEFAULT 0,
    source_doc_admin_unit_id integer,
    usin bigint NOT NULL,
    entity_name character varying(50),
    househld_gid integer,
    person_gid bigint,
    social_tenure_gid integer,
    active boolean DEFAULT true,
    mediatype character varying(10),
    adminid bigint
);


ALTER TABLE public.source_document OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 23250)
-- Name: source_document_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE source_document_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.source_document_gid_seq OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 23252)
-- Name: spatial_unit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatial_unit (
    usin bigint NOT NULL,
    spatial_unit_type character varying(50),
    project_name character varying(100),
    type_name character varying(500),
    identity character varying(50),
    house_type character varying(50),
    total_househld_no integer DEFAULT 0,
    other_use_type character varying(50),
    perimeter double precision,
    house_shape character varying(50),
    area double precision NOT NULL,
    measurement_unit character varying(25),
    land_owner character varying(100),
    uka_propertyno character varying,
    comments character varying,
    gtype character varying(10) NOT NULL,
    current_workflow_status_id bigint NOT NULL,
    workflow_status_update_time timestamp without time zone NOT NULL,
    userid integer NOT NULL,
    survey_date timestamp without time zone NOT NULL,
    imei_number character varying NOT NULL,
    the_geom geometry(Geometry,4326),
    address1 character varying,
    address2 character varying,
    postal_code character varying(10),
    existing_use integer,
    proposed_use integer,
    neighbor_north character varying(200),
    neighbor_south character varying(200),
    neighbor_east character varying(200),
    neighbor_west character varying(200),
    witness_1 character varying(200),
    witness_2 character varying(200),
    witness_3 character varying(200),
    witness_4 character varying(200),
    quality_of_soil integer,
    slope integer,
    line geometry,
    point geometry,
    polygon geometry,
    usin_str character varying(20),
    active boolean DEFAULT true,
    hamlet_id bigint
);


ALTER TABLE public.spatial_unit OWNER TO postgres;

--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN spatial_unit.the_geom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN spatial_unit.the_geom IS 'Store the common geometry for a row';


--
-- TOC entry 312 (class 1259 OID 24348)
-- Name: spatial_unit_deceased_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE spatial_unit_deceased_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spatial_unit_deceased_person_id_seq OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 24325)
-- Name: spatial_unit_person_with_interest_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE spatial_unit_person_with_interest_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spatial_unit_person_with_interest_seq OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 24007)
-- Name: spatial_unit_tmp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatial_unit_tmp (
    usin bigint NOT NULL,
    spatial_unit_type character varying(50),
    project_name character varying(100),
    type_name character varying(500),
    identity character varying(50),
    house_type character varying(50),
    total_househld_no integer DEFAULT 0,
    other_use_type character varying(50),
    perimeter double precision,
    house_shape character varying(50),
    area double precision NOT NULL,
    measurement_unit character varying(25),
    land_owner character varying(100),
    uka_propertyno character varying,
    comments character varying,
    gtype character varying(10) NOT NULL,
    current_workflow_status_id bigint NOT NULL,
    workflow_status_update_time timestamp without time zone NOT NULL,
    userid integer NOT NULL,
    survey_date timestamp without time zone NOT NULL,
    imei_number character varying NOT NULL,
    the_geom geometry(Geometry,4326),
    address1 character varying,
    address2 character varying,
    postal_code character varying(10),
    existing_use integer,
    proposed_use integer,
    neighbor_north character varying(200),
    neighbor_south character varying(200),
    neighbor_east character varying(200),
    neighbor_west character varying(200),
    witness_1 character varying(200),
    witness_2 character varying(200),
    witness_3 character varying(200),
    witness_4 character varying(200),
    quality_of_soil integer,
    slope integer,
    line geometry,
    point geometry,
    polygon geometry,
    usin_str character varying(20),
    active boolean DEFAULT true
);


ALTER TABLE public.spatial_unit_tmp OWNER TO postgres;

--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 294
-- Name: COLUMN spatial_unit_tmp.the_geom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN spatial_unit_tmp.the_geom IS 'Store the common geometry for a row';


--
-- TOC entry 268 (class 1259 OID 23264)
-- Name: spatial_unit_usin_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE spatial_unit_usin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spatial_unit_usin_seq OWNER TO postgres;

--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 268
-- Name: spatial_unit_usin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE spatial_unit_usin_seq OWNED BY spatial_unit.usin;


--
-- TOC entry 311 (class 1259 OID 24335)
-- Name: spatialunit_deceased_person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatialunit_deceased_person (
    id bigint NOT NULL,
    firstname character varying,
    middlename character varying,
    lastname character varying,
    usin bigint
);


ALTER TABLE public.spatialunit_deceased_person OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 24312)
-- Name: spatialunit_personwithinterest; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatialunit_personwithinterest (
    id bigint NOT NULL,
    usin bigint NOT NULL,
    person_name character varying(200) NOT NULL
);


ALTER TABLE public.spatialunit_personwithinterest OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 23856)
-- Name: status_hist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE status_hist_id_seq
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_hist_id_seq OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 23266)
-- Name: structure_facility; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE structure_facility (
    gid integer NOT NULL,
    water character varying(10),
    toilet character varying(10),
    electricity character varying(10),
    extension_id character varying(25),
    extension_name character varying(200),
    usin bigint,
    extension_2 character varying(50),
    extension_3 character varying(50),
    extension_4 character varying(50)
);


ALTER TABLE public.structure_facility OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 23269)
-- Name: structure_facility_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE structure_facility_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.structure_facility_gid_seq OWNER TO postgres;

--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 270
-- Name: structure_facility_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE structure_facility_gid_seq OWNED BY structure_facility.gid;


--
-- TOC entry 271 (class 1259 OID 23271)
-- Name: style; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE style (
    name character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    id integer NOT NULL,
    tenantid character varying(50)
);


ALTER TABLE public.style OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 23277)
-- Name: styles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.styles_id_seq OWNER TO postgres;

--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 272
-- Name: styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE styles_id_seq OWNED BY style.id;


--
-- TOC entry 273 (class 1259 OID 23279)
-- Name: sunit_status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sunit_status (
    workflow_status_id integer NOT NULL,
    workflow_status character varying NOT NULL
);


ALTER TABLE public.sunit_status OWNER TO postgres;

--
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE sunit_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE sunit_status IS '1. New
2. Adjudicated
3. Spatially Validated
4. Approved
5. Rejected
6. CCRO Generated';


--
-- TOC entry 289 (class 1259 OID 23858)
-- Name: sunit_workflow_status_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sunit_workflow_status_history_seq
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sunit_workflow_status_history_seq OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 23285)
-- Name: sunit_workflow_status_history; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sunit_workflow_status_history (
    status_hist_id bigint DEFAULT nextval('sunit_workflow_status_history_seq'::regclass) NOT NULL,
    usin bigint NOT NULL,
    workflow_status_id integer NOT NULL,
    userid bigint NOT NULL,
    status_change_time date NOT NULL
);


ALTER TABLE public.sunit_workflow_status_history OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 23288)
-- Name: surveyprojectattributes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE surveyprojectattributes (
    name character varying(100) NOT NULL,
    id integer NOT NULL,
    uid bigint NOT NULL,
    attributecategoryid integer NOT NULL,
    attributeorder integer DEFAULT 0
);


ALTER TABLE public.surveyprojectattributes OWNER TO postgres;

--
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE surveyprojectattributes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE surveyprojectattributes IS 'stores the attribute and survey project mapping';


--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 275
-- Name: COLUMN surveyprojectattributes.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN surveyprojectattributes.id IS 'primary key';


--
-- TOC entry 276 (class 1259 OID 23291)
-- Name: surveyprojectattributes_uid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE surveyprojectattributes_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveyprojectattributes_uid_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 23293)
-- Name: task; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task (
    tasktypeid integer NOT NULL,
    task character varying(50),
    survey_type character varying(50)
);


ALTER TABLE public.task OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 23296)
-- Name: task_scheduler; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task_scheduler (
    taskid integer NOT NULL,
    priority smallint,
    task_prompt integer,
    target_days integer NOT NULL,
    tasktype integer
);


ALTER TABLE public.task_scheduler OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 23299)
-- Name: tenure_class; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tenure_class (
    tenureclass_id integer NOT NULL,
    tenure_class character varying NOT NULL,
    active boolean DEFAULT false
);


ALTER TABLE public.tenure_class OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 23305)
-- Name: unit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unit (
    name character varying(25) NOT NULL,
    description character varying(255),
    id integer NOT NULL,
    tenantid character varying(25)
);


ALTER TABLE public.unit OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 23308)
-- Name: unit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_id_seq OWNER TO postgres;

--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 281
-- Name: unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE unit_id_seq OWNED BY unit.id;


--
-- TOC entry 282 (class 1259 OID 23310)
-- Name: user_project; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_project (
    project character varying(100) NOT NULL,
    id integer NOT NULL,
    tenantid character varying(25),
    userid integer
);


ALTER TABLE public.user_project OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 23313)
-- Name: user_project_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_project_id_seq OWNER TO postgres;

--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 283
-- Name: user_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_project_id_seq OWNED BY user_project.id;


--
-- TOC entry 284 (class 1259 OID 23315)
-- Name: user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_role_id_seq
    START WITH 352
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_role_id_seq OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 23317)
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_role (
    role character varying(25) NOT NULL,
    id integer DEFAULT nextval('user_role_id_seq'::regclass) NOT NULL,
    tenantid character varying(25),
    userid integer
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 23321)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    username character varying(75) NOT NULL,
    defaultproject character varying(25),
    email character varying(75) NOT NULL,
    passwordexpires date,
    lastactivitydate date,
    tenantid character varying(25),
    active boolean,
    password character varying(70),
    authkey character varying(255),
    id integer NOT NULL,
    phone character varying(12),
    manager_name character varying(25),
    name character varying(100)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 23327)
-- Name: users_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_gid_seq OWNER TO postgres;

--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 287
-- Name: users_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_gid_seq OWNED BY users.id;


--
-- TOC entry 313 (class 1259 OID 24363)
-- Name: vertexlabel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vertexlabel (
    gid integer NOT NULL,
    the_geom geometry(Geometry,4326) NOT NULL
);


ALTER TABLE public.vertexlabel OWNER TO postgres;

--
-- TOC entry 4452 (class 2604 OID 24243)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Cosmetic_Line" ALTER COLUMN gid SET DEFAULT nextval('"Cosmetic_Line_gid_seq"'::regclass);


--
-- TOC entry 4456 (class 2604 OID 24258)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Cosmetic_Point" ALTER COLUMN gid SET DEFAULT nextval('"Cosmetic_Point_gid_seq"'::regclass);


--
-- TOC entry 4460 (class 2604 OID 24273)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Cosmetic_Poly" ALTER COLUMN gid SET DEFAULT nextval('"Cosmetic_Poly_gid_seq"'::regclass);


--
-- TOC entry 4387 (class 2604 OID 23329)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY action ALTER COLUMN id SET DEFAULT nextval('actions_id_seq'::regclass);


--
-- TOC entry 4388 (class 2604 OID 23330)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attachment ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- TOC entry 4389 (class 2604 OID 23331)
-- Name: associationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attachment ALTER COLUMN associationid SET DEFAULT nextval('attachment_associationid_seq'::regclass);


--
-- TOC entry 4392 (class 2604 OID 23332)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bookmark ALTER COLUMN id SET DEFAULT nextval('bookmark_id_seq'::regclass);


--
-- TOC entry 4448 (class 2604 OID 24118)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ilalasimba_harmlets ALTER COLUMN gid SET DEFAULT nextval('"Ilalasimba_Harmlets_gid_seq"'::regclass);


--
-- TOC entry 4406 (class 2604 OID 23333)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer_layergroup ALTER COLUMN id SET DEFAULT nextval('layer_layergroup_id_seq'::regclass);


--
-- TOC entry 4407 (class 2604 OID 23334)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layergroup ALTER COLUMN id SET DEFAULT nextval('layergroup_id_seq'::regclass);


--
-- TOC entry 4408 (class 2604 OID 23335)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layertype ALTER COLUMN id SET DEFAULT nextval('layertype_id_seq'::regclass);


--
-- TOC entry 4409 (class 2604 OID 23336)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module ALTER COLUMN id SET DEFAULT nextval('module_id_seq'::regclass);


--
-- TOC entry 4410 (class 2604 OID 23337)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_action ALTER COLUMN id SET DEFAULT nextval('module_action_id_seq'::regclass);


--
-- TOC entry 4411 (class 2604 OID 23338)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_role ALTER COLUMN id SET DEFAULT nextval('role_module_id_seq'::regclass);


--
-- TOC entry 4420 (class 2604 OID 23339)
-- Name: associationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nonspatial_attachment ALTER COLUMN associationid SET DEFAULT nextval('nonspatial_attachment_associationid_seq'::regclass);


--
-- TOC entry 4421 (class 2604 OID 23340)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY outputformat ALTER COLUMN id SET DEFAULT nextval('outputformat_id_seq'::regclass);


--
-- TOC entry 4422 (class 2604 OID 23341)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY overviewmap ALTER COLUMN id SET DEFAULT nextval('overviewmap_id_seq'::regclass);


--
-- TOC entry 4423 (class 2604 OID 23342)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY printtemplate ALTER COLUMN id SET DEFAULT nextval('printtemplate_id_seq'::regclass);


--
-- TOC entry 4425 (class 2604 OID 23343)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project ALTER COLUMN id SET DEFAULT nextval('project_id_seq'::regclass);


--
-- TOC entry 4427 (class 2604 OID 23344)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_layergroup ALTER COLUMN id SET DEFAULT nextval('project_layergroup_id_seq'::regclass);


--
-- TOC entry 4429 (class 2604 OID 23345)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY projection ALTER COLUMN id SET DEFAULT nextval('projection_id_seq'::regclass);


--
-- TOC entry 4430 (class 2604 OID 23346)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- TOC entry 4438 (class 2604 OID 23347)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY style ALTER COLUMN id SET DEFAULT nextval('styles_id_seq'::regclass);


--
-- TOC entry 4442 (class 2604 OID 23348)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unit ALTER COLUMN id SET DEFAULT nextval('unit_id_seq'::regclass);


--
-- TOC entry 4443 (class 2604 OID 23349)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_project ALTER COLUMN id SET DEFAULT nextval('user_project_id_seq'::regclass);


--
-- TOC entry 4445 (class 2604 OID 23350)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_gid_seq'::regclass);


--
-- TOC entry 4618 (class 2606 OID 24251)
-- Name: Cosmetic_Line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Cosmetic_Line"
    ADD CONSTRAINT "Cosmetic_Line_pkey" PRIMARY KEY (gid);


--
-- TOC entry 4621 (class 2606 OID 24266)
-- Name: Cosmetic_Point_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Cosmetic_Point"
    ADD CONSTRAINT "Cosmetic_Point_pkey" PRIMARY KEY (gid);


--
-- TOC entry 4624 (class 2606 OID 24281)
-- Name: Cosmetic_Poly_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Cosmetic_Poly"
    ADD CONSTRAINT "Cosmetic_Poly_pkey" PRIMARY KEY (gid);


--
-- TOC entry 4614 (class 2606 OID 24120)
-- Name: Ilalasimba_Harmlets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ilalasimba_harmlets
    ADD CONSTRAINT "Ilalasimba_Harmlets_pkey" PRIMARY KEY (gid);


--
-- TOC entry 4472 (class 2606 OID 23362)
-- Name: PK_ATTACHMENT_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT "PK_ATTACHMENT_ID" PRIMARY KEY (associationid);


--
-- TOC entry 4470 (class 2606 OID 23364)
-- Name: PK_HOLIDAY_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY annual_holiday_calendar
    ADD CONSTRAINT "PK_HOLIDAY_ID" PRIMARY KEY (id);


--
-- TOC entry 4500 (class 2606 OID 23366)
-- Name: PK_LAYER_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY layer_field
    ADD CONSTRAINT "PK_LAYER_ID" PRIMARY KEY (id);


--
-- TOC entry 4502 (class 2606 OID 23368)
-- Name: PK_LAYER_LAYERGROUP_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY layer_layergroup
    ADD CONSTRAINT "PK_LAYER_LAYERGROUP_ID" PRIMARY KEY (id);


--
-- TOC entry 4510 (class 2606 OID 23370)
-- Name: PK_MAP_TIP; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY maptip
    ADD CONSTRAINT "PK_MAP_TIP" PRIMARY KEY (project, layer);


--
-- TOC entry 4519 (class 2606 OID 23372)
-- Name: PK_MODULE_ACTION_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_action
    ADD CONSTRAINT "PK_MODULE_ACTION_ID" PRIMARY KEY (id);


--
-- TOC entry 4527 (class 2606 OID 23374)
-- Name: PK_NONSPATIALATTACHMENT_ID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nonspatial_attachment
    ADD CONSTRAINT "PK_NONSPATIALATTACHMENT_ID" PRIMARY KEY (associationid);


--
-- TOC entry 4534 (class 2606 OID 23376)
-- Name: PK_OVERVIEWMAP; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY overviewmap
    ADD CONSTRAINT "PK_OVERVIEWMAP" PRIMARY KEY (id);


--
-- TOC entry 4548 (class 2606 OID 23378)
-- Name: PK_PROECT_BASELAYER; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_baselayer
    ADD CONSTRAINT "PK_PROECT_BASELAYER" PRIMARY KEY (id);


--
-- TOC entry 4552 (class 2606 OID 23380)
-- Name: PK_PROJECT_LAYERGROUP; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_layergroup
    ADD CONSTRAINT "PK_PROJECT_LAYERGROUP" PRIMARY KEY (id);


--
-- TOC entry 4521 (class 2606 OID 23382)
-- Name: PK_ROLE_MODULE; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_role
    ADD CONSTRAINT "PK_ROLE_MODULE" PRIMARY KEY (id);


--
-- TOC entry 4564 (class 2606 OID 23384)
-- Name: PK_SAVEDQUERY; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY savedquery
    ADD CONSTRAINT "PK_SAVEDQUERY" PRIMARY KEY (name);


--
-- TOC entry 4587 (class 2606 OID 23386)
-- Name: PK_TASK; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "PK_TASK" PRIMARY KEY (tasktypeid);


--
-- TOC entry 4589 (class 2606 OID 23388)
-- Name: PK_TASK_SCHEDULER; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task_scheduler
    ADD CONSTRAINT "PK_TASK_SCHEDULER" PRIMARY KEY (taskid);


--
-- TOC entry 4596 (class 2606 OID 23390)
-- Name: PK_USER_PROECT; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT "PK_USER_PROECT" PRIMARY KEY (id);


--
-- TOC entry 4598 (class 2606 OID 23392)
-- Name: PK_USER_ROLE; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT "PK_USER_ROLE" PRIMARY KEY (id);


--
-- TOC entry 4495 (class 2606 OID 23394)
-- Name: Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY land_use_type
    ADD CONSTRAINT "Primary Key" PRIMARY KEY (use_type_id);


--
-- TOC entry 4600 (class 2606 OID 23396)
-- Name: UK_USERID; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "UK_USERID" PRIMARY KEY (id);


--
-- TOC entry 4512 (class 2606 OID 23398)
-- Name: UQ_MAP_TIP_NAME; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY maptip
    ADD CONSTRAINT "UQ_MAP_TIP_NAME" UNIQUE (name);


--
-- TOC entry 4485 (class 2606 OID 23400)
-- Name: aaaaabookmark_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bookmark
    ADD CONSTRAINT aaaaabookmark_pk PRIMARY KEY (name);


--
-- TOC entry 4505 (class 2606 OID 23402)
-- Name: aaaaalayergroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY layergroup
    ADD CONSTRAINT aaaaalayergroup_pk PRIMARY KEY (name);


--
-- TOC entry 4532 (class 2606 OID 23404)
-- Name: aaaaaoutputformat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY outputformat
    ADD CONSTRAINT aaaaaoutputformat_pk PRIMARY KEY (name);


--
-- TOC entry 4544 (class 2606 OID 23406)
-- Name: aaaaaproject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT aaaaaproject_pk PRIMARY KEY (name);


--
-- TOC entry 4559 (class 2606 OID 23408)
-- Name: aaaaaprojection_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY projection
    ADD CONSTRAINT aaaaaprojection_pk PRIMARY KEY (code);


--
-- TOC entry 4517 (class 2606 OID 23410)
-- Name: aaaaatool_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module
    ADD CONSTRAINT aaaaatool_pk PRIMARY KEY (name);


--
-- TOC entry 4466 (class 2606 OID 23412)
-- Name: actions_actions_pk_actions; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY action
    ADD CONSTRAINT actions_actions_pk_actions PRIMARY KEY (name);


--
-- TOC entry 4468 (class 2606 OID 23414)
-- Name: adjacent_property_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY adjacent_property
    ADD CONSTRAINT adjacent_property_pk PRIMARY KEY (adjpropertyid);


--
-- TOC entry 4478 (class 2606 OID 23416)
-- Name: attribute_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attribute_master
    ADD CONSTRAINT attribute_master_pk PRIMARY KEY (id);


--
-- TOC entry 4480 (class 2606 OID 23418)
-- Name: attribute_option_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attribute_options
    ADD CONSTRAINT attribute_option_id_pk PRIMARY KEY (id);


--
-- TOC entry 4474 (class 2606 OID 23420)
-- Name: attributevalueid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attribute
    ADD CONSTRAINT attributevalueid_pk PRIMARY KEY (attributevalueid);


--
-- TOC entry 4482 (class 2606 OID 23422)
-- Name: baselayer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY baselayer
    ADD CONSTRAINT baselayer_pkey PRIMARY KEY (name);


--
-- TOC entry 4476 (class 2606 OID 23424)
-- Name: category_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attribute_category
    ADD CONSTRAINT category_pk PRIMARY KEY (attributecategoryid);


--
-- TOC entry 4637 (class 2606 OID 24380)
-- Name: citizen_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY citizenship
    ADD CONSTRAINT citizen_primarykey PRIMARY KEY (id);


--
-- TOC entry 4487 (class 2606 OID 23426)
-- Name: datatype_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY datatype_id
    ADD CONSTRAINT datatype_id_pk PRIMARY KEY (datatype_id);


--
-- TOC entry 4489 (class 2606 OID 23428)
-- Name: education_level_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY education_level
    ADD CONSTRAINT education_level_id_pk PRIMARY KEY (level_id);


--
-- TOC entry 4491 (class 2606 OID 23430)
-- Name: gender_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_pk PRIMARY KEY (gender_id);


--
-- TOC entry 4493 (class 2606 OID 23432)
-- Name: gid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_person
    ADD CONSTRAINT gid PRIMARY KEY (gid);


--
-- TOC entry 4602 (class 2606 OID 23880)
-- Name: group_type_group_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_type
    ADD CONSTRAINT group_type_group_id_pk PRIMARY KEY (group_id);


--
-- TOC entry 4633 (class 2606 OID 24342)
-- Name: id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatialunit_deceased_person
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- TOC entry 4604 (class 2606 OID 23885)
-- Name: land_type_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY land_type
    ADD CONSTRAINT land_type_id_pk PRIMARY KEY (landtype_id);


--
-- TOC entry 4514 (class 2606 OID 23434)
-- Name: marital_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY marital_status
    ADD CONSTRAINT marital_status_pk PRIMARY KEY (maritalstatus_id);


--
-- TOC entry 4523 (class 2606 OID 23436)
-- Name: natural_person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY natural_person
    ADD CONSTRAINT natural_person_pkey PRIMARY KEY (gid);


--
-- TOC entry 4525 (class 2606 OID 23438)
-- Name: non_natural_person_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY non_natural_person
    ADD CONSTRAINT non_natural_person_pk PRIMARY KEY (non_natural_person_gid);


--
-- TOC entry 4529 (class 2606 OID 23440)
-- Name: occupancy_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY occupancy_type
    ADD CONSTRAINT occupancy_type_pk PRIMARY KEY (occupancy_type_id);


--
-- TOC entry 4616 (class 2606 OID 24176)
-- Name: person_administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person_administrator
    ADD CONSTRAINT person_administrator_pkey PRIMARY KEY (adminid);


--
-- TOC entry 4536 (class 2606 OID 23442)
-- Name: person_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pk PRIMARY KEY (person_gid);


--
-- TOC entry 4538 (class 2606 OID 23444)
-- Name: person_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person_type
    ADD CONSTRAINT person_type_pk PRIMARY KEY (person_type_gid);


--
-- TOC entry 4498 (class 2606 OID 23446)
-- Name: pk_layer; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT pk_layer PRIMARY KEY (alias);


--
-- TOC entry 4508 (class 2606 OID 23448)
-- Name: pk_layertype; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY layertype
    ADD CONSTRAINT pk_layertype PRIMARY KEY (name);


--
-- TOC entry 4562 (class 2606 OID 23450)
-- Name: pk_role; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT pk_role PRIMARY KEY (name);


--
-- TOC entry 4568 (class 2606 OID 23452)
-- Name: pk_social_tenure_relationship; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT pk_social_tenure_relationship PRIMARY KEY (gid);


--
-- TOC entry 4570 (class 2606 OID 23454)
-- Name: pk_source_document; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY source_document
    ADD CONSTRAINT pk_source_document PRIMARY KEY (gid);


--
-- TOC entry 4572 (class 2606 OID 23456)
-- Name: pk_spatial_unit; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT pk_spatial_unit PRIMARY KEY (usin);


--
-- TOC entry 4579 (class 2606 OID 23458)
-- Name: pk_styles; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT pk_styles PRIMARY KEY (name);


--
-- TOC entry 4594 (class 2606 OID 23460)
-- Name: pk_unit; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT pk_unit PRIMARY KEY (name);


--
-- TOC entry 4635 (class 2606 OID 24370)
-- Name: primary_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vertexlabel
    ADD CONSTRAINT primary_key PRIMARY KEY (gid);


--
-- TOC entry 4541 (class 2606 OID 23462)
-- Name: printtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY printtemplate
    ADD CONSTRAINT printtemplate_pkey PRIMARY KEY (name);


--
-- TOC entry 4546 (class 2606 OID 23464)
-- Name: project_area_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_area
    ADD CONSTRAINT project_area_id_pk PRIMARY KEY (area_id);


--
-- TOC entry 4629 (class 2606 OID 24304)
-- Name: project_hamlets_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_hamlets
    ADD CONSTRAINT project_hamlets_pk PRIMARY KEY (id);


--
-- TOC entry 4554 (class 2606 OID 23466)
-- Name: project_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_region
    ADD CONSTRAINT project_region_pkey PRIMARY KEY (gid);


--
-- TOC entry 4556 (class 2606 OID 23468)
-- Name: project_spatial_data_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_spatial_data
    ADD CONSTRAINT project_spatial_data_pk PRIMARY KEY (id);


--
-- TOC entry 4606 (class 2606 OID 23890)
-- Name: slope_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY slope_values
    ADD CONSTRAINT slope_id_pk PRIMARY KEY (id);


--
-- TOC entry 4566 (class 2606 OID 23470)
-- Name: socialtenure_relationtype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY share_type
    ADD CONSTRAINT socialtenure_relationtype_pk PRIMARY KEY (gid);


--
-- TOC entry 4608 (class 2606 OID 23895)
-- Name: soil_quality_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY soil_quality_values
    ADD CONSTRAINT soil_quality_id_pk PRIMARY KEY (id);


--
-- TOC entry 4627 (class 2606 OID 24292)
-- Name: spatial_adjudicator_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project_adjudicators
    ADD CONSTRAINT spatial_adjudicator_pk PRIMARY KEY (id);


--
-- TOC entry 4574 (class 2606 OID 23472)
-- Name: spatial_unit_identity_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT spatial_unit_identity_key UNIQUE (identity);


--
-- TOC entry 4610 (class 2606 OID 24017)
-- Name: spatial_unit_tmp_identity_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_unit_tmp
    ADD CONSTRAINT spatial_unit_tmp_identity_key UNIQUE (identity);


--
-- TOC entry 4612 (class 2606 OID 24015)
-- Name: spatial_unit_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_unit_tmp
    ADD CONSTRAINT spatial_unit_tmp_pkey PRIMARY KEY (usin);


--
-- TOC entry 4631 (class 2606 OID 24316)
-- Name: spatialunit_personwithinterest_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatialunit_personwithinterest
    ADD CONSTRAINT spatialunit_personwithinterest_pk PRIMARY KEY (id);


--
-- TOC entry 4576 (class 2606 OID 23474)
-- Name: structure_facility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY structure_facility
    ADD CONSTRAINT structure_facility_pkey PRIMARY KEY (gid);


--
-- TOC entry 4581 (class 2606 OID 23476)
-- Name: sunit_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sunit_status
    ADD CONSTRAINT sunit_status_pk PRIMARY KEY (workflow_status_id);


--
-- TOC entry 4583 (class 2606 OID 23478)
-- Name: sunit_workflow_status_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sunit_workflow_status_history
    ADD CONSTRAINT sunit_workflow_status_history_pk PRIMARY KEY (status_hist_id);


--
-- TOC entry 4585 (class 2606 OID 23480)
-- Name: surveyprojectattributes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY surveyprojectattributes
    ADD CONSTRAINT surveyprojectattributes_pk PRIMARY KEY (uid);


--
-- TOC entry 4591 (class 2606 OID 23482)
-- Name: tenure_class_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tenure_class
    ADD CONSTRAINT tenure_class_pk PRIMARY KEY (tenureclass_id);


--
-- TOC entry 4619 (class 1259 OID 24252)
-- Name: Cosmetic_Line_the_geom_gist; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "Cosmetic_Line_the_geom_gist" ON "Cosmetic_Line" USING gist (the_geom);


--
-- TOC entry 4622 (class 1259 OID 24267)
-- Name: Cosmetic_Point_the_geom_gist; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "Cosmetic_Point_the_geom_gist" ON "Cosmetic_Point" USING gist (the_geom);


--
-- TOC entry 4625 (class 1259 OID 24282)
-- Name: Cosmetic_Poly_the_geom_gist; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "Cosmetic_Poly_the_geom_gist" ON "Cosmetic_Poly" USING gist (the_geom);


--
-- TOC entry 4464 (class 1259 OID 23483)
-- Name: PK_Actions; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_Actions" ON action USING btree (name);

ALTER TABLE action CLUSTER ON "PK_Actions";


--
-- TOC entry 4496 (class 1259 OID 23484)
-- Name: PK_Layer; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_Layer" ON layer USING btree (alias);

ALTER TABLE layer CLUSTER ON "PK_Layer";


--
-- TOC entry 4506 (class 1259 OID 23485)
-- Name: PK_LayerType; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_LayerType" ON layertype USING btree (name);

ALTER TABLE layertype CLUSTER ON "PK_LayerType";


--
-- TOC entry 4560 (class 1259 OID 23486)
-- Name: PK_Role; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_Role" ON role USING btree (name);


--
-- TOC entry 4577 (class 1259 OID 23487)
-- Name: PK_Styles; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_Styles" ON style USING btree (name);

ALTER TABLE style CLUSTER ON "PK_Styles";


--
-- TOC entry 4592 (class 1259 OID 23488)
-- Name: PK_Unit; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "PK_Unit" ON unit USING btree (name);


--
-- TOC entry 4483 (class 1259 OID 23489)
-- Name: aaaaaBOOKMARK_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaBOOKMARK_PK" ON bookmark USING btree (name);


--
-- TOC entry 4503 (class 1259 OID 23490)
-- Name: aaaaaLAYERGROUP_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaLAYERGROUP_PK" ON layergroup USING btree (name);

ALTER TABLE layergroup CLUSTER ON "aaaaaLAYERGROUP_PK";


--
-- TOC entry 4530 (class 1259 OID 23491)
-- Name: aaaaaOutputFormat_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaOutputFormat_PK" ON outputformat USING btree (name);


--
-- TOC entry 4539 (class 1259 OID 23492)
-- Name: aaaaaPRINTTEMPLATE_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaPRINTTEMPLATE_PK" ON printtemplate USING btree (name);

ALTER TABLE printtemplate CLUSTER ON "aaaaaPRINTTEMPLATE_PK";


--
-- TOC entry 4557 (class 1259 OID 23493)
-- Name: aaaaaPROJECTION_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaPROJECTION_PK" ON projection USING btree (code);


--
-- TOC entry 4542 (class 1259 OID 23494)
-- Name: aaaaaPROJECT_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaPROJECT_PK" ON project USING btree (name);


--
-- TOC entry 4515 (class 1259 OID 23495)
-- Name: aaaaaTOOL_PK; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "aaaaaTOOL_PK" ON module USING btree (name);


--
-- TOC entry 4549 (class 1259 OID 23496)
-- Name: fki_projectbaselayer_baselayer; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_projectbaselayer_baselayer ON project_baselayer USING btree (baselayer);


--
-- TOC entry 4550 (class 1259 OID 23497)
-- Name: fki_projectbaselayer_project; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_projectbaselayer_project ON project_baselayer USING btree (project);


--
-- TOC entry 4707 (class 2620 OID 23913)
-- Name: upd_usinstr; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_usinstr AFTER INSERT OR UPDATE OF usin_str ON spatial_unit FOR EACH ROW EXECUTE PROCEDURE upd_usinstr();


--
-- TOC entry 4651 (class 2606 OID 23498)
-- Name: FK_LAYER_MAPTIP; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY maptip
    ADD CONSTRAINT "FK_LAYER_MAPTIP" FOREIGN KEY (layer) REFERENCES layer(alias);


--
-- TOC entry 4652 (class 2606 OID 23503)
-- Name: FK_Project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY maptip
    ADD CONSTRAINT "FK_Project" FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4697 (class 2606 OID 23508)
-- Name: FK_TASK_TYPE; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_scheduler
    ADD CONSTRAINT "FK_TASK_TYPE" FOREIGN KEY (tasktype) REFERENCES task(tasktypeid);


--
-- TOC entry 4698 (class 2606 OID 23513)
-- Name: FK_USERPROJECT_USERS; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT "FK_USERPROJECT_USERS" FOREIGN KEY (userid) REFERENCES users(id);


--
-- TOC entry 4701 (class 2606 OID 23518)
-- Name: FK_USERROLE_USERS; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT "FK_USERROLE_USERS" FOREIGN KEY (userid) REFERENCES users(id);


--
-- TOC entry 4703 (class 2606 OID 24293)
-- Name: adjudicator_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_adjudicators
    ADD CONSTRAINT adjudicator_project_fk FOREIGN KEY (project_name) REFERENCES project(name) ON DELETE RESTRICT;


--
-- TOC entry 4640 (class 2606 OID 23523)
-- Name: attribute_category_attribute_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attribute_master
    ADD CONSTRAINT attribute_category_attribute_master_fk FOREIGN KEY (attributecategoryid) REFERENCES attribute_category(attributecategoryid);


--
-- TOC entry 4695 (class 2606 OID 23528)
-- Name: attribute_master_surveyprojectattributes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY surveyprojectattributes
    ADD CONSTRAINT attribute_master_surveyprojectattributes_fk FOREIGN KEY (id) REFERENCES attribute_master(id);


--
-- TOC entry 4642 (class 2606 OID 23533)
-- Name: attribute_option_attributeid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attribute_options
    ADD CONSTRAINT attribute_option_attributeid_fk FOREIGN KEY (attribute_id) REFERENCES attribute_master(id);


--
-- TOC entry 4641 (class 2606 OID 23538)
-- Name: datatype_id_attribute_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attribute_master
    ADD CONSTRAINT datatype_id_attribute_master_fk FOREIGN KEY (datatype_id) REFERENCES datatype_id(datatype_id);


--
-- TOC entry 4659 (class 2606 OID 23543)
-- Name: education_level; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natural_person
    ADD CONSTRAINT education_level FOREIGN KEY (education) REFERENCES education_level(level_id);


--
-- TOC entry 4687 (class 2606 OID 23548)
-- Name: existing_use; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT existing_use FOREIGN KEY (existing_use) REFERENCES land_use_type(use_type_id);


--
-- TOC entry 4639 (class 2606 OID 23553)
-- Name: fk_attachment_layer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT fk_attachment_layer FOREIGN KEY (layername) REFERENCES layer(alias);


--
-- TOC entry 4643 (class 2606 OID 23558)
-- Name: fk_bookmark_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bookmark
    ADD CONSTRAINT fk_bookmark_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4649 (class 2606 OID 23563)
-- Name: fk_layer_fields_layer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer_field
    ADD CONSTRAINT fk_layer_fields_layer FOREIGN KEY (layer) REFERENCES layer(alias);


--
-- TOC entry 4650 (class 2606 OID 23568)
-- Name: fk_layer_layergroup_layergroup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer_layergroup
    ADD CONSTRAINT fk_layer_layergroup_layergroup FOREIGN KEY (layergroup) REFERENCES layergroup(name);


--
-- TOC entry 4645 (class 2606 OID 23573)
-- Name: fk_layer_layertype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT fk_layer_layertype FOREIGN KEY (type) REFERENCES layertype(name);


--
-- TOC entry 4646 (class 2606 OID 23578)
-- Name: fk_layer_outputformat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT fk_layer_outputformat FOREIGN KEY (format) REFERENCES outputformat(name);


--
-- TOC entry 4647 (class 2606 OID 23583)
-- Name: fk_layer_projection; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT fk_layer_projection FOREIGN KEY (projection) REFERENCES projection(code);


--
-- TOC entry 4648 (class 2606 OID 23588)
-- Name: fk_layer_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT fk_layer_unit FOREIGN KEY (unit) REFERENCES unit(name);


--
-- TOC entry 4654 (class 2606 OID 23593)
-- Name: fk_moduleaction_actions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_action
    ADD CONSTRAINT fk_moduleaction_actions FOREIGN KEY (action) REFERENCES action(name);


--
-- TOC entry 4655 (class 2606 OID 23598)
-- Name: fk_moduleaction_modules; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_action
    ADD CONSTRAINT fk_moduleaction_modules FOREIGN KEY (module) REFERENCES module(name);


--
-- TOC entry 4664 (class 2606 OID 23603)
-- Name: fk_overviewmap_layergroup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY overviewmap
    ADD CONSTRAINT fk_overviewmap_layergroup FOREIGN KEY (layer) REFERENCES layergroup(name);


--
-- TOC entry 4665 (class 2606 OID 23608)
-- Name: fk_overviewmap_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY overviewmap
    ADD CONSTRAINT fk_overviewmap_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4653 (class 2606 OID 23613)
-- Name: fk_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY maptip
    ADD CONSTRAINT fk_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4667 (class 2606 OID 23618)
-- Name: fk_project_outputformat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_project_outputformat FOREIGN KEY (outputformat) REFERENCES outputformat(name);


--
-- TOC entry 4668 (class 2606 OID 23623)
-- Name: fk_project_projection; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_project_projection FOREIGN KEY (projection) REFERENCES projection(code);


--
-- TOC entry 4669 (class 2606 OID 23628)
-- Name: fk_project_projection1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_project_projection1 FOREIGN KEY (displayprojection) REFERENCES projection(code);


--
-- TOC entry 4670 (class 2606 OID 23633)
-- Name: fk_project_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_project_unit FOREIGN KEY (unit) REFERENCES unit(name);


--
-- TOC entry 4672 (class 2606 OID 23638)
-- Name: fk_projectbaselayer_baselayer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_baselayer
    ADD CONSTRAINT fk_projectbaselayer_baselayer FOREIGN KEY (baselayer) REFERENCES baselayer(name);


--
-- TOC entry 4673 (class 2606 OID 23643)
-- Name: fk_projectbaselayer_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_baselayer
    ADD CONSTRAINT fk_projectbaselayer_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4674 (class 2606 OID 23648)
-- Name: fk_projectlayer_group_layergroup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_layergroup
    ADD CONSTRAINT fk_projectlayer_group_layergroup FOREIGN KEY (layergroup) REFERENCES layergroup(name);


--
-- TOC entry 4675 (class 2606 OID 23653)
-- Name: fk_projectlayergroup_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_layergroup
    ADD CONSTRAINT fk_projectlayergroup_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4656 (class 2606 OID 23658)
-- Name: fk_role_module_actions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_role
    ADD CONSTRAINT fk_role_module_actions FOREIGN KEY (action) REFERENCES action(name);


--
-- TOC entry 4657 (class 2606 OID 23663)
-- Name: fk_roletool_roles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_role
    ADD CONSTRAINT fk_roletool_roles FOREIGN KEY (role) REFERENCES role(name);


--
-- TOC entry 4658 (class 2606 OID 23668)
-- Name: fk_roletool_tool; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_role
    ADD CONSTRAINT fk_roletool_tool FOREIGN KEY (module) REFERENCES module(name);


--
-- TOC entry 4677 (class 2606 OID 23673)
-- Name: fk_savedquery_layer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY savedquery
    ADD CONSTRAINT fk_savedquery_layer FOREIGN KEY (layer) REFERENCES layer(alias);


--
-- TOC entry 4678 (class 2606 OID 23678)
-- Name: fk_savedquery_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY savedquery
    ADD CONSTRAINT fk_savedquery_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4692 (class 2606 OID 23683)
-- Name: fk_spatial_unit_gid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY structure_facility
    ADD CONSTRAINT fk_spatial_unit_gid FOREIGN KEY (usin) REFERENCES spatial_unit(usin) ON DELETE SET NULL;


--
-- TOC entry 4679 (class 2606 OID 23688)
-- Name: fk_str_spatial_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT fk_str_spatial_unit FOREIGN KEY (usin) REFERENCES spatial_unit(usin);


--
-- TOC entry 4699 (class 2606 OID 23693)
-- Name: fk_userproject_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT fk_userproject_project FOREIGN KEY (project) REFERENCES project(name);


--
-- TOC entry 4700 (class 2606 OID 23698)
-- Name: fk_userproject_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT fk_userproject_users FOREIGN KEY (userid) REFERENCES users(id);


--
-- TOC entry 4702 (class 2606 OID 23703)
-- Name: fk_userrole_roles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk_userrole_roles FOREIGN KEY (role) REFERENCES role(name);


--
-- TOC entry 4660 (class 2606 OID 23708)
-- Name: gender_natural_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natural_person
    ADD CONSTRAINT gender_natural_person_fk FOREIGN KEY (gender) REFERENCES gender(gender_id);


--
-- TOC entry 4691 (class 2606 OID 24327)
-- Name: hamlet_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT hamlet_id_fk FOREIGN KEY (hamlet_id) REFERENCES project_hamlets(id) ON DELETE RESTRICT;


--
-- TOC entry 4661 (class 2606 OID 23713)
-- Name: marital_status_natural_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natural_person
    ADD CONSTRAINT marital_status_natural_person_fk FOREIGN KEY (marital_status) REFERENCES marital_status(maritalstatus_id);


--
-- TOC entry 4662 (class 2606 OID 23718)
-- Name: natural_person_non_natural_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY non_natural_person
    ADD CONSTRAINT natural_person_non_natural_person_fk FOREIGN KEY (poc_gid) REFERENCES natural_person(gid);


--
-- TOC entry 4680 (class 2606 OID 23723)
-- Name: occupancy_type_social_tenure_relationship_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT occupancy_type_social_tenure_relationship_fk FOREIGN KEY (occupancy_type_id) REFERENCES occupancy_type(occupancy_type_id);


--
-- TOC entry 4644 (class 2606 OID 23728)
-- Name: person_group_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_person
    ADD CONSTRAINT person_group_person_fk FOREIGN KEY (rep_person_gid) REFERENCES person(person_gid);


--
-- TOC entry 4663 (class 2606 OID 23733)
-- Name: person_non_natural_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY non_natural_person
    ADD CONSTRAINT person_non_natural_person_fk FOREIGN KEY (non_natural_person_gid) REFERENCES person(person_gid);


--
-- TOC entry 4681 (class 2606 OID 23738)
-- Name: person_social_tenure_relationship_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT person_social_tenure_relationship_fk FOREIGN KEY (person_gid) REFERENCES person(person_gid);


--
-- TOC entry 4684 (class 2606 OID 23743)
-- Name: person_source_document_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY source_document
    ADD CONSTRAINT person_source_document_fk FOREIGN KEY (person_gid) REFERENCES person(person_gid);


--
-- TOC entry 4666 (class 2606 OID 23748)
-- Name: person_type_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_type_person_fk FOREIGN KEY (person_type_gid) REFERENCES person_type(person_type_gid);


--
-- TOC entry 4704 (class 2606 OID 24305)
-- Name: project_hamlets_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_hamlets
    ADD CONSTRAINT project_hamlets_project_fk FOREIGN KEY (project_name) REFERENCES project(name) ON DELETE RESTRICT;


--
-- TOC entry 4671 (class 2606 OID 23753)
-- Name: project_project_area_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_area
    ADD CONSTRAINT project_project_area_fk FOREIGN KEY (name) REFERENCES project(name);


--
-- TOC entry 4676 (class 2606 OID 23758)
-- Name: project_project_spatial_data_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project_spatial_data
    ADD CONSTRAINT project_project_spatial_data_fk FOREIGN KEY (name) REFERENCES project(name);


--
-- TOC entry 4688 (class 2606 OID 23763)
-- Name: project_spatial_unit_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT project_spatial_unit_fk FOREIGN KEY (project_name) REFERENCES project(name);


--
-- TOC entry 4696 (class 2606 OID 23768)
-- Name: project_surveyprojectattributes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY surveyprojectattributes
    ADD CONSTRAINT project_surveyprojectattributes_fk FOREIGN KEY (name) REFERENCES project(name);


--
-- TOC entry 4689 (class 2606 OID 23773)
-- Name: proposed_use; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT proposed_use FOREIGN KEY (proposed_use) REFERENCES land_use_type(use_type_id);


--
-- TOC entry 4685 (class 2606 OID 23778)
-- Name: social_tenure_relationship_source_document_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY source_document
    ADD CONSTRAINT social_tenure_relationship_source_document_fk FOREIGN KEY (social_tenure_gid) REFERENCES social_tenure_relationship(gid);


--
-- TOC entry 4682 (class 2606 OID 23783)
-- Name: socialtenure_relationtype_social_tenure_relationship_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT socialtenure_relationtype_social_tenure_relationship_fk FOREIGN KEY (social_tenure_relationship_type) REFERENCES share_type(gid);


--
-- TOC entry 4686 (class 2606 OID 23788)
-- Name: source_document_struct_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY source_document
    ADD CONSTRAINT source_document_struct_gid_fkey FOREIGN KEY (usin) REFERENCES spatial_unit(usin);


--
-- TOC entry 4638 (class 2606 OID 23793)
-- Name: spatial_unit_adjacent_property_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY adjacent_property
    ADD CONSTRAINT spatial_unit_adjacent_property_fk FOREIGN KEY (usin) REFERENCES spatial_unit(usin);


--
-- TOC entry 4693 (class 2606 OID 23798)
-- Name: spatial_unit_sunit_workflow_status_history_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sunit_workflow_status_history
    ADD CONSTRAINT spatial_unit_sunit_workflow_status_history_fk FOREIGN KEY (usin) REFERENCES spatial_unit(usin);


--
-- TOC entry 4705 (class 2606 OID 24317)
-- Name: spatiaunit_pwi_sptialunit_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatialunit_personwithinterest
    ADD CONSTRAINT spatiaunit_pwi_sptialunit_fk FOREIGN KEY (usin) REFERENCES spatial_unit(usin) ON DELETE RESTRICT;


--
-- TOC entry 4694 (class 2606 OID 23803)
-- Name: sunit_status_sunit_workflow_status_history_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sunit_workflow_status_history
    ADD CONSTRAINT sunit_status_sunit_workflow_status_history_fk FOREIGN KEY (workflow_status_id) REFERENCES sunit_status(workflow_status_id);


--
-- TOC entry 4683 (class 2606 OID 23808)
-- Name: tenure_class_social_tenure_relationship_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_tenure_relationship
    ADD CONSTRAINT tenure_class_social_tenure_relationship_fk FOREIGN KEY (tenureclass_id) REFERENCES tenure_class(tenureclass_id);


--
-- TOC entry 4690 (class 2606 OID 23813)
-- Name: unit_spatial_unit_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatial_unit
    ADD CONSTRAINT unit_spatial_unit_fk FOREIGN KEY (measurement_unit) REFERENCES unit(name);


--
-- TOC entry 4706 (class 2606 OID 24343)
-- Name: usin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spatialunit_deceased_person
    ADD CONSTRAINT usin FOREIGN KEY (usin) REFERENCES spatial_unit(usin);


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 289
-- Name: sunit_workflow_status_history_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE sunit_workflow_status_history_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sunit_workflow_status_history_seq FROM postgres;
GRANT ALL ON SEQUENCE sunit_workflow_status_history_seq TO postgres;
GRANT ALL ON SEQUENCE sunit_workflow_status_history_seq TO PUBLIC;


-- Completed on 2016-04-05 09:14:44

--
-- PostgreSQL database dump complete
--

