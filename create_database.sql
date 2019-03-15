
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

CREATE FUNCTION check_id_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$    BEGIN
    if (old.landid in(Select LD.landid  from la_spatialunit_land LD 
inner join la_ext_landworkflowhistory lw on LD.landid = lw.landid
where lw.workflowid=6  and lw.applicationstatusid=5 
and LD.isactive = true and LD.landid not in(select landid from la_ext_parcelSplitLand) order by LD.landid)) 
         THEN
            RAISE EXCEPTION 'Can’t modify the Approved/Registered Parcel.';
            
             END IF;
        RETURN NEW;
    END;
    $$;


ALTER FUNCTION public.check_id_change() OWNER TO postgres;

CREATE FUNCTION ins_toplology_error() RETURNS TABLE(geometry geometry, error_message character varying, layer_name character varying, landid bigint, remarks character varying, statusfixed character varying)
    LANGUAGE plpgsql
    AS $$
 
BEGIN

   INSERT INTO public.topology_checks_error_log(geometry, error_message, layer_name, landid)

select  a.geometry,'invalid geometry','la_spatialunit_land',a.landid from la_spatialunit_land a where st_isvalid(a.geometry)=false union all

select a.geometry,'intersect','la_spatialunit_land',a.landid FROM la_spatialunit_land a INNER JOIN la_spatialunit_land b ON ST_Intersects(a.geometry,b.geometry) where a.geometry<b.geometry union all

select a.geometry, 'small area','la_spatialunit_land',a.landid from la_spatialunit_land a WHERE  ST_Area(a.geometry) < 0.00001 union all
SELECT a.geometry,'invalid geometry','la_spatialunit_land',a.landid from la_spatialunit_land a where  ST_IsEmpty(ST_GeomFromText('GEOMETRYCOLLECTION EMPTY'))=false;
 RETURN QUERY EXECUTE 'select geometry,error_message,layer_name,landid,remarks,statusfixed
  from topology_checks_error_log';

END;

$$;


ALTER FUNCTION public.ins_toplology_error() OWNER TO postgres;

CREATE FUNCTION update_area() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
-- IF NEW.landid=OLD.landid THEN
--update la_spatialunit_land set Area= (CAST(ST_Area(geometry) AS DOUBLE PRECISION)* CAST(111319 AS DOUBLE PRECISION)*CAST(111319 AS DOUBLE PRECISION)*0.00024710538149159)  Where NEW.LandID=OLD.LandID;
--ALTER TABLE la_spatialunit_land DISABLE TRIGGER client_update_trigger; 
 IF Exists (select landid from la_spatialunit_land Where oldLandID=new.OLDLandID) THEN
update la_spatialunit_land set Area=  round(cast((CAST(ST_Area(geometry) AS DOUBLE PRECISION)* CAST(111319 AS DOUBLE PRECISION)*
CAST(111319 AS DOUBLE PRECISION)*0.00024710538149159)as numeric),2)   Where oldLandID=new.OLDLandID and landid in(
select landid from la_spatialunit_land Where oldLandID=new.OLDLandID);
  
 
END IF;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_area() OWNER TO postgres;

CREATE FUNCTION updatearea() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

IF (select st_equals(new.geometry,old.geometry) FROM la_spatialunit_land where landid=new.landid) ='False' Then
update la_spatialunit_land set Area=round(cast((CAST(ST_Area(geometry) AS DOUBLE PRECISION)* CAST(111319 AS DOUBLE PRECISION)*
CAST(111319 AS DOUBLE PRECISION)*0.00024710538149159)as numeric),2)   Where LandID=new.LandID;

  END IF;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.updatearea() OWNER TO postgres;

CREATE FUNCTION updatearea_resourceland() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
IF (select st_equals(new.geometry,old.geometry) FROM la_spatialunit_resource_land where landid=new.landid) ='False' Then
update la_spatialunit_resource_land set Area= 
(CAST(ST_Area(geometry) AS DOUBLE PRECISION)* CAST(111319 AS DOUBLE PRECISION)*
 CAST(111319 AS DOUBLE PRECISION)*0.00024710538149159)  Where LandID=new.LandID;

  END IF;  

RETURN NEW;
END;
$$;


ALTER FUNCTION public.updatearea_resourceland() OWNER TO postgres;

CREATE SEQUENCE error_log_seq
    START WITH 1242
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE error_log_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

CREATE TABLE la_baunit_landsoilquality (
    landsoilqualityid integer NOT NULL,
    landsoilqualitytype character varying(50) NOT NULL,
    landsoilqualitytype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_baunit_landsoilquality OWNER TO postgres;

CREATE SEQUENCE la_baunit_landsoilquality_landsoilqualityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_baunit_landsoilquality_landsoilqualityid_seq OWNER TO postgres;

ALTER SEQUENCE la_baunit_landsoilquality_landsoilqualityid_seq OWNED BY la_baunit_landsoilquality.landsoilqualityid;

CREATE TABLE la_baunit_landtype (
    landtypeid integer NOT NULL,
    landtype character varying(50) NOT NULL,
    landtype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_baunit_landtype OWNER TO postgres;

--
-- Name: la_baunit_landtype_landtypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_baunit_landtype_landtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_baunit_landtype_landtypeid_seq OWNER TO postgres;

--
-- Name: la_baunit_landtype_landtypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_baunit_landtype_landtypeid_seq OWNED BY la_baunit_landtype.landtypeid;


--
-- Name: la_baunit_landusetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_baunit_landusetype (
    landusetypeid integer NOT NULL,
    landusetype character varying(50) NOT NULL,
    landusetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_baunit_landusetype OWNER TO postgres;

--
-- Name: la_baunit_landusetype_landusetypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_baunit_landusetype_landusetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_baunit_landusetype_landusetypeid_seq OWNER TO postgres;

--
-- Name: la_baunit_landusetype_landusetypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_baunit_landusetype_landusetypeid_seq OWNED BY la_baunit_landusetype.landusetypeid;


--
-- Name: la_ext_applicationstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_applicationstatus (
    applicationstatusid integer NOT NULL,
    applicationstatus character varying(50) NOT NULL,
    applicationstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_applicationstatus OWNER TO postgres;

--
-- Name: la_ext_applicationstatus_applicationstatusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_applicationstatus_applicationstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_applicationstatus_applicationstatusid_seq OWNER TO postgres;

--
-- Name: la_ext_applicationstatus_applicationstatusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_applicationstatus_applicationstatusid_seq OWNED BY la_ext_applicationstatus.applicationstatusid;


--
-- Name: la_ext_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_attribute (
    attributeid integer NOT NULL,
    attributevalue character varying(50) NOT NULL,
    attributemasterid integer NOT NULL,
    parentuid integer NOT NULL
);


ALTER TABLE la_ext_attribute OWNER TO postgres;

--
-- Name: la_ext_attribute_attributeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_attribute_attributeid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attribute_attributeid_seq OWNER TO postgres;

--
-- Name: la_ext_attribute_attributeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_attribute_attributeid_seq OWNED BY la_ext_attribute.attributeid;


--
-- Name: la_ext_attributecategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_attributecategory (
    attributecategoryid integer NOT NULL,
    categoryname character varying(50) NOT NULL,
    categorytypeid integer,
    categorydisplayorder integer DEFAULT 1 NOT NULL
);


ALTER TABLE la_ext_attributecategory OWNER TO postgres;

--
-- Name: la_ext_attributecategory_attributecategoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_attributecategory_attributecategoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributecategory_attributecategoryid_seq OWNER TO postgres;

--
-- Name: la_ext_attributecategory_attributecategoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_attributecategory_attributecategoryid_seq OWNED BY la_ext_attributecategory.attributecategoryid;


--
-- Name: la_ext_attributedatatype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_attributedatatype (
    datatypemasterid integer NOT NULL,
    datatype character varying(20) NOT NULL
);


ALTER TABLE la_ext_attributedatatype OWNER TO postgres;

--
-- Name: la_ext_attributedatatype_datatypemasterid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_attributedatatype_datatypemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributedatatype_datatypemasterid_seq OWNER TO postgres;

--
-- Name: la_ext_attributedatatype_datatypemasterid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_attributedatatype_datatypemasterid_seq OWNED BY la_ext_attributedatatype.datatypemasterid;


--
-- Name: la_ext_attributemaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_attributemaster (
    attributemasterid integer NOT NULL,
    fieldname character varying(50) NOT NULL,
    fieldaliasname character varying(50),
    datatypemasterid integer NOT NULL,
    attributecategoryid integer,
    referencetable character varying(50) NOT NULL,
    size character varying(5) NOT NULL,
    mandatory boolean,
    listing character varying(5),
    isactive boolean DEFAULT true NOT NULL,
    masterattribute boolean DEFAULT true
);


ALTER TABLE la_ext_attributemaster OWNER TO postgres;

--
-- Name: la_ext_attributemaster_attributemasterid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_attributemaster_attributemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributemaster_attributemasterid_seq OWNER TO postgres;

--
-- Name: la_ext_attributemaster_attributemasterid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_attributemaster_attributemasterid_seq OWNED BY la_ext_attributemaster.attributemasterid;


--
-- Name: la_ext_attributeoptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_attributeoptions (
    attributeoptionsid integer NOT NULL,
    optiontext character varying(50),
    attributemasterid integer NOT NULL,
    parentid integer
);


ALTER TABLE la_ext_attributeoptions OWNER TO postgres;

--
-- Name: la_ext_attributeoptions_attributeoptionsid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributeoptions_attributeoptionsid_seq OWNER TO postgres;

--
-- Name: la_ext_attributeoptions_attributeoptionsid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq OWNED BY la_ext_attributeoptions.attributeoptionsid;


--
-- Name: la_ext_baselayer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_baselayer (
    baselayerid integer NOT NULL,
    baselayer character varying(50) NOT NULL,
    baselayer_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_baselayer OWNER TO postgres;

--
-- Name: la_ext_baselayer_baselayerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_baselayer_baselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_baselayer_baselayerid_seq OWNER TO postgres;

--
-- Name: la_ext_baselayer_baselayerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_baselayer_baselayerid_seq OWNED BY la_ext_baselayer.baselayerid;


--
-- Name: la_ext_bookmark; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_bookmark (
    bookmarkid integer NOT NULL,
    bookmarkname character varying(100) NOT NULL,
    projectnameid integer NOT NULL,
    description character varying(100),
    minx double precision NOT NULL,
    miny double precision NOT NULL,
    maxx double precision,
    maxy double precision NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_bookmark OWNER TO postgres;

--
-- Name: la_ext_bookmark_bookmarkid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_bookmark_bookmarkid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_bookmark_bookmarkid_seq OWNER TO postgres;

--
-- Name: la_ext_bookmark_bookmarkid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_bookmark_bookmarkid_seq OWNED BY la_ext_bookmark.bookmarkid;


--
-- Name: la_ext_categorytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_categorytype (
    categorytypeid integer NOT NULL,
    typename character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_categorytype OWNER TO postgres;

--
-- Name: la_ext_categorytype_categorytypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_categorytype_categorytypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_categorytype_categorytypeid_seq OWNER TO postgres;

--
-- Name: la_ext_categorytype_categorytypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_categorytype_categorytypeid_seq OWNED BY la_ext_categorytype.categorytypeid;


--
-- Name: la_ext_customattributeoptionsid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_customattributeoptionsid_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_customattributeoptionsid_seq OWNER TO postgres;

--
-- Name: la_ext_customattributeoptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_customattributeoptions (
    attributeoptionsid integer DEFAULT nextval('la_ext_customattributeoptionsid_seq'::regclass) NOT NULL,
    optiontext character varying(50),
    customattributeid integer NOT NULL,
    parentid integer
);


ALTER TABLE la_ext_customattributeoptions OWNER TO postgres;

--
-- Name: la_ext_dispute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_dispute (
    disputeid integer NOT NULL,
    landid bigint NOT NULL,
    disputetypeid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    comment character(500),
    disputestatusid bigint
);


ALTER TABLE la_ext_dispute OWNER TO postgres;

--
-- Name: la_ext_dispute_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_dispute_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_dispute_seq OWNER TO postgres;

--
-- Name: la_ext_disputelandmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_disputelandmapping (
    disputelandid integer NOT NULL,
    partyid bigint,
    landid integer NOT NULL,
    persontypeid integer NOT NULL,
    disputetypeid integer NOT NULL,
    transactionid integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    comment character(500),
    disputeid bigint
);


ALTER TABLE la_ext_disputelandmapping OWNER TO postgres;

--
-- Name: la_ext_disputelandmapping_disputelandid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_disputelandmapping_disputelandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputelandmapping_disputelandid_seq OWNER TO postgres;

--
-- Name: la_ext_disputelandmapping_disputelandid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_disputelandmapping_disputelandid_seq OWNED BY la_ext_disputelandmapping.disputelandid;


--
-- Name: la_ext_disputestatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_disputestatus (
    disputestatusid integer NOT NULL,
    disputestatus character varying(50) NOT NULL,
    disputestatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_disputestatus OWNER TO postgres;

--
-- Name: la_ext_disputestatus_disputestatusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_disputestatus_disputestatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputestatus_disputestatusid_seq OWNER TO postgres;

--
-- Name: la_ext_disputestatus_disputestatusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_disputestatus_disputestatusid_seq OWNED BY la_ext_disputestatus.disputestatusid;


--
-- Name: la_ext_disputetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_disputetype (
    disputetypeid integer NOT NULL,
    disputetype character varying(50) NOT NULL,
    disputetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_disputetype OWNER TO postgres;

--
-- Name: la_ext_disputetype_disputetypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_disputetype_disputetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputetype_disputetypeid_seq OWNER TO postgres;

--
-- Name: la_ext_disputetype_disputetypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_disputetype_disputetypeid_seq OWNED BY la_ext_disputetype.disputetypeid;


--
-- Name: la_ext_documentdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_documentdetails (
    documentid integer NOT NULL,
    transactionid integer NOT NULL,
    landid bigint NOT NULL,
    partyid bigint,
    documentformatid integer,
    documentname character varying(50) NOT NULL,
    documentlocation character varying(100) NOT NULL,
    recordationdate date,
    remarks character varying(250) NOT NULL,
    documenttypeid integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_documentdetails OWNER TO postgres;

--
-- Name: la_ext_documentdetails_documentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_documentdetails_documentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documentdetails_documentid_seq OWNER TO postgres;

--
-- Name: la_ext_documentdetails_documentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_documentdetails_documentid_seq OWNED BY la_ext_documentdetails.documentid;


--
-- Name: la_ext_documentformat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_documentformat (
    documentformatid integer NOT NULL,
    documentformat character varying(50) NOT NULL,
    documentformat_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_documentformat OWNER TO postgres;

--
-- Name: la_ext_documentformat_documentformatid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_documentformat_documentformatid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documentformat_documentformatid_seq OWNER TO postgres;

--
-- Name: la_ext_documentformat_documentformatid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_documentformat_documentformatid_seq OWNED BY la_ext_documentformat.documentformatid;


--
-- Name: la_ext_documenttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_documenttype (
    documenttypeid integer NOT NULL,
    documenttype character varying(50) NOT NULL,
    documenttype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    processid integer
);


ALTER TABLE la_ext_documenttype OWNER TO postgres;

--
-- Name: la_ext_documenttype_documenttypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_documenttype_documenttypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documenttype_documenttypeid_seq OWNER TO postgres;

--
-- Name: la_ext_documenttype_documenttypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_documenttype_documenttypeid_seq OWNED BY la_ext_documenttype.documenttypeid;


--
-- Name: la_ext_existingclaim_documentdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_existingclaim_documentdetails (
    claimdocumentid integer NOT NULL,
    landid bigint NOT NULL,
    documentrefno character varying(150) NOT NULL,
    documentdate date,
    documenttype character varying(50) NOT NULL,
    plotno integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_existingclaim_documentdetails OWNER TO postgres;

--
-- Name: la_ext_existingclaim_documentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_existingclaim_documentid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_existingclaim_documentid_seq OWNER TO postgres;

--
-- Name: la_ext_financialagency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_financialagency (
    financialagencyid integer NOT NULL,
    financialagency character varying(100) NOT NULL,
    financialagency_en character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_financialagency OWNER TO postgres;

--
-- Name: la_ext_financialagency_financialagencyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_financialagency_financialagencyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_financialagency_financialagencyid_seq OWNER TO postgres;

--
-- Name: la_ext_financialagency_financialagencyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_financialagency_financialagencyid_seq OWNED BY la_ext_financialagency.financialagencyid;


--
-- Name: la_ext_geometrytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_geometrytype (
    geometrytypeid integer NOT NULL,
    geometryname character varying(20) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_geometrytype OWNER TO postgres;

--
-- Name: la_ext_geometrytype_geometryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_geometrytype_geometryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_geometrytype_geometryid_seq OWNER TO postgres;

--
-- Name: la_ext_geometrytype_geometryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_geometrytype_geometryid_seq OWNED BY la_ext_geometrytype.geometrytypeid;


--
-- Name: la_ext_grouptype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_grouptype (
    grouptypeid integer NOT NULL,
    grouptype character varying(50) NOT NULL,
    grouptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_grouptype OWNER TO postgres;

--
-- Name: la_ext_grouptype_grouptypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_grouptype_grouptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_grouptype_grouptypeid_seq OWNER TO postgres;

--
-- Name: la_ext_grouptype_grouptypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_grouptype_grouptypeid_seq OWNED BY la_ext_grouptype.grouptypeid;


--
-- Name: la_ext_landapplicationstatus_landapplicationstatusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_landapplicationstatus_landapplicationstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_landapplicationstatus_landapplicationstatusid_seq OWNER TO postgres;

--
-- Name: la_ext_landapplicationstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_landapplicationstatus (
    landapplicationstatusid integer DEFAULT nextval('la_ext_landapplicationstatus_landapplicationstatusid_seq'::regclass) NOT NULL,
    landid integer,
    applicationstatusid integer,
    workflowstatusid integer,
    occupancylength integer
);


ALTER TABLE la_ext_landapplicationstatus OWNER TO postgres;

--
-- Name: la_ext_landworkflowhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_landworkflowhistory (
    landworkflowhistoryid integer NOT NULL,
    landid bigint NOT NULL,
    applicationstatusid integer NOT NULL,
    userid integer NOT NULL,
    statuschangedate date NOT NULL,
    comments character varying(4000),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    workflowid integer
);


ALTER TABLE la_ext_landworkflowhistory OWNER TO postgres;

--
-- Name: la_ext_landworkflowhistory_landworkflowhistoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_landworkflowhistory_landworkflowhistoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_landworkflowhistory_landworkflowhistoryid_seq OWNER TO postgres;

--
-- Name: la_ext_landworkflowhistory_landworkflowhistoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_landworkflowhistory_landworkflowhistoryid_seq OWNED BY la_ext_landworkflowhistory.landworkflowhistoryid;


--
-- Name: la_ext_layer_layergroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_layer_layergroup (
    layer_layergroupid integer NOT NULL,
    layerid integer NOT NULL,
    layergroupid integer NOT NULL,
    layerorder integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_layer_layergroup OWNER TO postgres;

--
-- Name: la_ext_layer_layergroup_layer_layergroupid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_layer_layergroup_layer_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layer_layergroup_layer_layergroupid_seq OWNER TO postgres;

--
-- Name: la_ext_layer_layergroup_layer_layergroupid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_layer_layergroup_layer_layergroupid_seq OWNED BY la_ext_layer_layergroup.layer_layergroupid;


--
-- Name: la_ext_layerfield; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_layerfield (
    layerfieldid integer NOT NULL,
    layerid integer NOT NULL,
    layerfield character varying(255) NOT NULL,
    layerfield_en character varying(255) NOT NULL,
    keyfield character varying(50),
    isactive boolean DEFAULT true NOT NULL,
    alias character varying(255)
);


ALTER TABLE la_ext_layerfield OWNER TO postgres;

--
-- Name: la_ext_layerfield_layerfieldid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_layerfield_layerfieldid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layerfield_layerfieldid_seq OWNER TO postgres;

--
-- Name: la_ext_layerfield_layerfieldid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_layerfield_layerfieldid_seq OWNED BY la_ext_layerfield.layerfieldid;


--
-- Name: la_ext_layergroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_layergroup (
    layergroupid integer NOT NULL,
    layergroupname character varying(50) NOT NULL,
    remarks character varying(250),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_layergroup OWNER TO postgres;

--
-- Name: la_ext_layergroup_layergroupid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_layergroup_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layergroup_layergroupid_seq OWNER TO postgres;

--
-- Name: la_ext_layergroup_layergroupid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_layergroup_layergroupid_seq OWNED BY la_ext_layergroup.layergroupid;


--
-- Name: la_ext_layertype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_layertype (
    layertypeid integer NOT NULL,
    layertype character varying(50) NOT NULL,
    layertype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_layertype OWNER TO postgres;

--
-- Name: la_ext_layertype_layertypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_layertype_layertypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layertype_layertypeid_seq OWNER TO postgres;

--
-- Name: la_ext_layertype_layertypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_layertype_layertypeid_seq OWNED BY la_ext_layertype.layertypeid;


--
-- Name: la_ext_module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_module (
    moduleid integer NOT NULL,
    modulename character varying(50) NOT NULL,
    modulename_en character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_module OWNER TO postgres;

--
-- Name: la_ext_module_moduleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_module_moduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_module_moduleid_seq OWNER TO postgres;

--
-- Name: la_ext_module_moduleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_module_moduleid_seq OWNED BY la_ext_module.moduleid;


--
-- Name: la_ext_month; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_month (
    monthid integer NOT NULL,
    month character varying(10) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_month OWNER TO postgres;

--
-- Name: la_ext_month_monthid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_month_monthid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_month_monthid_seq OWNER TO postgres;

--
-- Name: la_ext_month_monthid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_month_monthid_seq OWNED BY la_ext_month.monthid;


--
-- Name: la_ext_parcelsplitland_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_parcelsplitland_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_parcelsplitland_seq OWNER TO postgres;

--
-- Name: la_ext_parcelsplitland; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_parcelsplitland (
    parcelsplitid integer DEFAULT nextval('la_ext_parcelsplitland_seq'::regclass) NOT NULL,
    landid bigint,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_parcelsplitland OWNER TO postgres;

--
-- Name: la_ext_personlandmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_personlandmapping (
    personlandid integer NOT NULL,
    partyid bigint NOT NULL,
    landid bigint NOT NULL,
    persontypeid integer NOT NULL,
    transactionid integer NOT NULL,
    certificateissuedate date,
    certificateno character varying(50),
    sharepercentage character varying(10),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_personlandmapping OWNER TO postgres;

--
-- Name: la_ext_personlandmapping_personlandid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_personlandmapping_personlandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_personlandmapping_personlandid_seq OWNER TO postgres;

--
-- Name: la_ext_personlandmapping_personlandid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_personlandmapping_personlandid_seq OWNED BY la_ext_personlandmapping.personlandid;


--
-- Name: la_ext_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_process (
    processid integer NOT NULL,
    processname character varying(50),
    processname_en character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_process OWNER TO postgres;

--
-- Name: la_ext_process_processid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_process_processid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_process_processid_seq OWNER TO postgres;

--
-- Name: la_ext_process_processid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_process_processid_seq OWNED BY la_ext_process.processid;


--
-- Name: la_ext_projectadjudicator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projectadjudicator (
    projectadjudicatorid integer NOT NULL,
    adjudicatorname character varying(100),
    adjudicatorname_en character varying(100),
    projectnameid integer NOT NULL,
    signaturepath character varying(250),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projectadjudicator OWNER TO postgres;

--
-- Name: la_ext_projectadjudicator_projectadjudicatorid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projectadjudicator_projectadjudicatorid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectadjudicator_projectadjudicatorid_seq OWNER TO postgres;

--
-- Name: la_ext_projectadjudicator_projectadjudicatorid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projectadjudicator_projectadjudicatorid_seq OWNED BY la_ext_projectadjudicator.projectadjudicatorid;


--
-- Name: la_ext_projectarea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projectarea (
    projectareaid integer NOT NULL,
    projectnameid integer NOT NULL,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer NOT NULL,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    initiationdate date,
    description character varying(250),
    vc_meetingdate date,
    postalcode character varying(50),
    authorizedmember character varying(50),
    authorizedmembersignature character varying(550),
    landofficer character varying(50),
    landofficersignature character varying(550),
    executiveofficer character varying(50),
    executiveofficersignature character varying(550),
    certificatenumber character varying(50),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projectarea OWNER TO postgres;

--
-- Name: la_ext_projectarea_projectareaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projectarea_projectareaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectarea_projectareaid_seq OWNER TO postgres;

--
-- Name: la_ext_projectarea_projectareaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projectarea_projectareaid_seq OWNED BY la_ext_projectarea.projectareaid;


--
-- Name: la_ext_projectbaselayermapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projectbaselayermapping (
    projectbaselayerid integer NOT NULL,
    baselayerid integer NOT NULL,
    projectnameid integer NOT NULL,
    baselayerorder integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projectbaselayermapping OWNER TO postgres;

--
-- Name: la_ext_projectbaselayermapping_projectbaselayerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projectbaselayermapping_projectbaselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectbaselayermapping_projectbaselayerid_seq OWNER TO postgres;

--
-- Name: la_ext_projectbaselayermapping_projectbaselayerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projectbaselayermapping_projectbaselayerid_seq OWNED BY la_ext_projectbaselayermapping.projectbaselayerid;


--
-- Name: la_ext_projectfile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projectfile (
    projectfileid integer NOT NULL,
    projectfilename character varying(50) NOT NULL,
    projectnameid integer NOT NULL,
    filelocation character varying(250) NOT NULL,
    documentformatid integer,
    filesize integer,
    description character varying(250),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projectfile OWNER TO postgres;

INSERT INTO public.la_ext_projectfile(projectfilename, projectnameid, filelocation, documentformatid, filesize, description, isactive, createdby, createddate, modifiedby, modifieddate)
    VALUES ('Community_boundary.mbtiles', 2, 'resources/documents/demo/mbtiles', 1, 0, 'Mbtile file', 't', 24, now(), 24, now());

--
-- Name: la_ext_projectfile_projectfileid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projectfile_projectfileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectfile_projectfileid_seq OWNER TO postgres;

--
-- Name: la_ext_projectfile_projectfileid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projectfile_projectfileid_seq OWNED BY la_ext_projectfile.projectfileid;


--
-- Name: la_ext_projecthamlet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projecthamlet (
    projecthamletid integer NOT NULL,
    hamletname character varying(100),
    hamletname_en character varying(100),
    projectnameid integer NOT NULL,
    hamletcode character varying(10),
    count integer,
    hamletleadername character varying(500),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projecthamlet OWNER TO postgres;

--
-- Name: la_ext_projecthamlet_projecthamletid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projecthamlet_projecthamletid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projecthamlet_projecthamletid_seq OWNER TO postgres;

--
-- Name: la_ext_projecthamlet_projecthamletid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projecthamlet_projecthamletid_seq OWNED BY la_ext_projecthamlet.projecthamletid;


--
-- Name: la_ext_projection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projection (
    projectionid integer NOT NULL,
    projection character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_projection OWNER TO postgres;

--
-- Name: la_ext_projection_projectionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projection_projectionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projection_projectionid_seq OWNER TO postgres;

--
-- Name: la_ext_projection_projectionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projection_projectionid_seq OWNED BY la_ext_projection.projectionid;


--
-- Name: la_ext_projectlayergroupmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_projectlayergroupmapping (
    projectlayergroupid integer NOT NULL,
    layergroupid integer NOT NULL,
    projectnameid integer NOT NULL,
    grouporder integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_projectlayergroupmapping OWNER TO postgres;

--
-- Name: la_ext_projectlayergroupmapping_projectlayergroupid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectlayergroupmapping_projectlayergroupid_seq OWNER TO postgres;

--
-- Name: la_ext_projectlayergroupmapping_projectlayergroupid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq OWNED BY la_ext_projectlayergroupmapping.projectlayergroupid;


--
-- Name: la_registrationsharetype_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_registrationsharetype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_registrationsharetype_seq OWNER TO postgres;

--
-- Name: la_ext_registrationsharetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_registrationsharetype (
    registrationsharetypeid integer DEFAULT nextval('la_registrationsharetype_seq'::regclass) NOT NULL,
    landid bigint,
    landsharetypeid bigint,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_registrationsharetype OWNER TO postgres;

--
-- Name: la_ext_resource_custom_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resource_custom_attribute (
    customattributeid integer NOT NULL,
    fieldname character varying(50) NOT NULL,
    fieldaliasname character varying(50),
    datatypemasterid integer NOT NULL,
    attributecategoryid integer,
    referencetable character varying(50) NOT NULL,
    size character varying(5) NOT NULL,
    mandatory boolean,
    listing character varying(5),
    isactive boolean DEFAULT true NOT NULL,
    masterattribute boolean DEFAULT true,
    subclassificationid integer,
    projectid integer NOT NULL
);


ALTER TABLE la_ext_resource_custom_attribute OWNER TO postgres;

--
-- Name: la_ext_resource_custom_attribute_customattributeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resource_custom_attribute_customattributeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resource_custom_attribute_customattributeid_seq OWNER TO postgres;

--
-- Name: la_ext_resource_custom_attribute_customattributeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_resource_custom_attribute_customattributeid_seq OWNED BY la_ext_resource_custom_attribute.customattributeid;


--
-- Name: la_ext_resourcecustomattributevalue_customattributevalueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourcecustomattributevalue_customattributevalueid_seq
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcecustomattributevalue_customattributevalueid_seq OWNER TO postgres;

--
-- Name: la_ext_resource_custom_attributevalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resource_custom_attributevalue (
    customattributevalueid integer DEFAULT nextval('la_ext_resourcecustomattributevalue_customattributevalueid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    customattributeid integer NOT NULL,
    subclassificationid integer,
    attributevalue character varying(1000) NOT NULL,
    geomtype character varying(50) NOT NULL,
    attributeoptionsid integer
);


ALTER TABLE la_ext_resource_custom_attributevalue OWNER TO postgres;

--
-- Name: la_ext_resource_documentdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resource_documentdetails (
    documentid integer NOT NULL,
    transactionid integer,
    landid bigint,
    partyid bigint,
    documentformatid integer,
    documentname character varying(50) NOT NULL,
    documentlocation character varying(100),
    recordationdate date,
    remarks character varying(250) NOT NULL,
    documenttypeid integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_resource_documentdetails OWNER TO postgres;

--
-- Name: la_ext_resource_documentdetails_documentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resource_documentdetails_documentid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resource_documentdetails_documentid_seq OWNER TO postgres;

--
-- Name: la_ext_resourceattributevalue_attributevalueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourceattributevalue_attributevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourceattributevalue_attributevalueid_seq OWNER TO postgres;

--
-- Name: la_ext_resourceattributevalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourceattributevalue (
    attributevalueid integer DEFAULT nextval('la_ext_resourceattributevalue_attributevalueid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    attributemasterid integer NOT NULL,
    attributevalue character varying(1000) NOT NULL,
    geomtype character varying(50) NOT NULL,
    groupid integer DEFAULT 1 NOT NULL
);


ALTER TABLE la_ext_resourceattributevalue OWNER TO postgres;

--
-- Name: la_ext_resourceclassification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourceclassification (
    classificationid integer NOT NULL,
    classificationname character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_resourceclassification OWNER TO postgres;

--
-- Name: la_ext_resourceclassification_classificationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourceclassification_classificationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourceclassification_classificationid_seq OWNER TO postgres;

--
-- Name: la_ext_resourceclassification_classificationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_resourceclassification_classificationid_seq OWNED BY la_ext_resourceclassification.classificationid;


--
-- Name: la_ext_resourcelandclassificationmapping_landclassmappingid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourcelandclassificationmapping_landclassmappingid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcelandclassificationmapping_landclassmappingid_seq OWNER TO postgres;

--
-- Name: la_ext_resourcelandclassificationmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourcelandclassificationmapping (
    landclassmappingid integer DEFAULT nextval('la_ext_resourcelandclassificationmapping_landclassmappingid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    classificationid integer NOT NULL,
    subclassificationid integer NOT NULL,
    geomtype character varying(50) NOT NULL,
    categoryid integer
);


ALTER TABLE la_ext_resourcelandclassificationmapping OWNER TO postgres;

--
-- Name: la_ext_resourcepoiattributemasterid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourcepoiattributemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcepoiattributemasterid_seq OWNER TO postgres;

--
-- Name: la_ext_resourcepoiattributemaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourcepoiattributemaster (
    poiattributemasterid integer DEFAULT nextval('la_ext_resourcepoiattributemasterid_seq'::regclass) NOT NULL,
    fieldname character varying(50) NOT NULL,
    fieldaliasname character varying(50),
    datatypemasterid integer NOT NULL,
    attributecategoryid integer,
    referencetable character varying(50) NOT NULL,
    size character varying(5) NOT NULL,
    mandatory boolean,
    listing character varying(5),
    isactive boolean DEFAULT true NOT NULL,
    masterattribute boolean DEFAULT true
);


ALTER TABLE la_ext_resourcepoiattributemaster OWNER TO postgres;

--
-- Name: la_ext_resourcepoiattributevalue_attributevalueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourcepoiattributevalue_attributevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcepoiattributevalue_attributevalueid_seq OWNER TO postgres;

--
-- Name: la_ext_resourcepoiattributevalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourcepoiattributevalue (
    poiattributevalueid integer DEFAULT nextval('la_ext_resourcepoiattributevalue_attributevalueid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    attributemasterid integer NOT NULL,
    attributevalue character varying(1000) NOT NULL,
    geomtype character varying(50) NOT NULL,
    groupid integer
);


ALTER TABLE la_ext_resourcepoiattributevalue OWNER TO postgres;

--
-- Name: la_ext_resourcesubclassification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_resourcesubclassification (
    subclassificationid integer NOT NULL,
    classificationid integer NOT NULL,
    geometrytypeid integer NOT NULL,
    subclassificationname character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_resourcesubclassification OWNER TO postgres;

--
-- Name: la_ext_resourcesubclassification_subclassificationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_resourcesubclassification_subclassificationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcesubclassification_subclassificationid_seq OWNER TO postgres;

--
-- Name: la_ext_resourcesubclassification_subclassificationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_resourcesubclassification_subclassificationid_seq OWNED BY la_ext_resourcesubclassification.subclassificationid;


--
-- Name: la_ext_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_role (
    roleid integer NOT NULL,
    roletype character varying(30) NOT NULL,
    roletype_en character varying(30) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_role OWNER TO postgres;

--
-- Name: la_ext_role_roleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_role_roleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_role_roleid_seq OWNER TO postgres;

--
-- Name: la_ext_role_roleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_role_roleid_seq OWNED BY la_ext_role.roleid;


--
-- Name: la_ext_rolemodulemapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_rolemodulemapping (
    rolemoduleid integer NOT NULL,
    roleid integer NOT NULL,
    moduleid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_rolemodulemapping OWNER TO postgres;

--
-- Name: la_ext_rolemodulemapping_rolemoduleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_rolemodulemapping_rolemoduleid_seq OWNER TO postgres;

--
-- Name: la_ext_rolemodulemapping_rolemoduleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq OWNED BY la_ext_rolemodulemapping.rolemoduleid;


--
-- Name: la_ext_slopevalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_slopevalue (
    slopevalueid integer NOT NULL,
    slopevalue character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_slopevalue OWNER TO postgres;

--
-- Name: la_ext_slopevalue_slopevalueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_slopevalue_slopevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_slopevalue_slopevalueid_seq OWNER TO postgres;

--
-- Name: la_ext_slopevalue_slopevalueid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_slopevalue_slopevalueid_seq OWNED BY la_ext_slopevalue.slopevalueid;


--
-- Name: la_ext_spatialunit_personwithinterest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_spatialunit_personwithinterest (
    id bigint NOT NULL,
    landid bigint NOT NULL,
    first_name character varying(200) NOT NULL,
    middle_name character varying(50),
    last_name character varying(50),
    address character varying(200),
    gender integer,
    relation integer,
    dob date,
    projectnameid bigint,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    typeid bigint,
    transactionid integer
);


ALTER TABLE la_ext_spatialunit_personwithinterest OWNER TO postgres;

--
-- Name: la_ext_spatialunit_personwithinterest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_spatialunit_personwithinterest_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_spatialunit_personwithinterest_id_seq OWNER TO postgres;

--
-- Name: la_ext_surveyprojectattributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_surveyprojectattributes (
    surveyprojectattributesid integer NOT NULL,
    projectnameid integer NOT NULL,
    attributemasterid integer NOT NULL,
    attributecategoryid integer NOT NULL,
    attributeorder integer DEFAULT 0 NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_surveyprojectattributes OWNER TO postgres;

--
-- Name: la_ext_surveyprojectattributes_surveyprojectattributesid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_surveyprojectattributes_surveyprojectattributesid_seq OWNER TO postgres;

--
-- Name: la_ext_surveyprojectattributes_surveyprojectattributesid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq OWNED BY la_ext_surveyprojectattributes.surveyprojectattributesid;


--
-- Name: la_ext_transactiondetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_transactiondetails (
    transactionid integer NOT NULL,
    processid integer,
    applicationstatusid integer NOT NULL,
    moduletransid integer,
    remarks character varying(500),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL
);


ALTER TABLE la_ext_transactiondetails OWNER TO postgres;

--
-- Name: la_ext_transactiondetails_transactionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_transactiondetails_transactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_transactiondetails_transactionid_seq OWNER TO postgres;

--
-- Name: la_ext_transactiondetails_transactionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_transactiondetails_transactionid_seq OWNED BY la_ext_transactiondetails.transactionid;


--
-- Name: la_transactionhistory_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_transactionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_transactionhistory_seq OWNER TO postgres;

--
-- Name: la_ext_transactionhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_transactionhistory (
    transactionhistoryid integer DEFAULT nextval('la_transactionhistory_seq'::regclass) NOT NULL,
    oldownerid character varying(100),
    newownerid character varying(100),
    landid bigint,
    transactionid integer,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_transactionhistory OWNER TO postgres;

--
-- Name: la_ext_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_unit (
    unitid integer NOT NULL,
    unit character varying(50) NOT NULL,
    unit_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_unit OWNER TO postgres;

--
-- Name: la_ext_unit_unitid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_unit_unitid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_unit_unitid_seq OWNER TO postgres;

--
-- Name: la_ext_unit_unitid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_unit_unitid_seq OWNED BY la_ext_unit.unitid;


--
-- Name: la_ext_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_user (
    userid integer NOT NULL,
    name character varying(100) NOT NULL,
    managername character varying(100),
    genderid integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    authenticationkey character varying(250) NOT NULL,
    emailid character varying(100) NOT NULL,
    contactno character varying(15),
    address character varying(100),
    passwordexpires date,
    lastactivitydate date,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    defaultproject character varying(25)
);


ALTER TABLE la_ext_user OWNER TO postgres;

--
-- Name: la_ext_user_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_user_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_user_userid_seq OWNER TO postgres;

--
-- Name: la_ext_user_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_user_userid_seq OWNED BY la_ext_user.userid;


--
-- Name: la_ext_userprojectmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_userprojectmapping (
    userprojectid integer NOT NULL,
    userid integer NOT NULL,
    projectnameid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_userprojectmapping OWNER TO postgres;

--
-- Name: la_ext_userprojectmapping_userprojectid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_userprojectmapping_userprojectid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_userprojectmapping_userprojectid_seq OWNER TO postgres;

--
-- Name: la_ext_userprojectmapping_userprojectid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_userprojectmapping_userprojectid_seq OWNED BY la_ext_userprojectmapping.userprojectid;


--
-- Name: la_ext_userrolemapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_userrolemapping (
    userroleid integer NOT NULL,
    userid integer NOT NULL,
    roleid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_ext_userrolemapping OWNER TO postgres;

--
-- Name: la_ext_userrolemapping_userroleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_userrolemapping_userroleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_userrolemapping_userroleid_seq OWNER TO postgres;

--
-- Name: la_ext_userrolemapping_userroleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_userrolemapping_userroleid_seq OWNED BY la_ext_userrolemapping.userroleid;


--
-- Name: la_ext_workflow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_workflow (
    workflowid integer NOT NULL,
    workflow character varying(50),
    workflow_en character varying(50),
    workfloworder integer,
    isactive boolean DEFAULT true,
    workflowdefid integer
);


ALTER TABLE la_ext_workflow OWNER TO postgres;

--
-- Name: la_ext_workflow_workflowid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_workflow_workflowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflow_workflowid_seq OWNER TO postgres;

--
-- Name: la_ext_workflow_workflowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_workflow_workflowid_seq OWNED BY la_ext_workflow.workflowid;


--
-- Name: la_ext_workflowactionmapping_workflowactionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_workflowactionmapping_workflowactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflowactionmapping_workflowactionid_seq OWNER TO postgres;

--
-- Name: la_ext_workflowactionmapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_workflowactionmapping (
    workflowactionid integer DEFAULT nextval('la_ext_workflowactionmapping_workflowactionid_seq'::regclass) NOT NULL,
    actionname character varying(200),
    actionname_en character varying(200),
    roleid integer,
    workflowid integer,
    worder integer,
    isactive boolean,
    action character(50)
);


ALTER TABLE la_ext_workflowactionmapping OWNER TO postgres;

--
-- Name: la_ext_workflowdef; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_workflowdef (
    workflowdefid integer NOT NULL,
    name character varying(50),
    type integer
);


ALTER TABLE la_ext_workflowdef OWNER TO postgres;

--
-- Name: la_ext_workflowdef_workflowdefid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_workflowdef_workflowdefid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflowdef_workflowdefid_seq OWNER TO postgres;

--
-- Name: la_ext_workflowdef_workflowdefid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_workflowdef_workflowdefid_seq OWNED BY la_ext_workflowdef.workflowdefid;


--
-- Name: la_layer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_layer (
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
    format character varying(255),
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


ALTER TABLE la_layer OWNER TO postgres;

--
-- Name: la_party; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_party (
    partyid bigint NOT NULL,
    persontypeid integer,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL
);


ALTER TABLE la_party OWNER TO postgres;

--
-- Name: la_party_deceasedperson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_party_deceasedperson (
    partyid bigint NOT NULL,
    persontypeid integer NOT NULL,
    landid bigint NOT NULL,
    firstname character varying(50),
    middlename character varying(50),
    lastname character varying(50),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);


ALTER TABLE la_party_deceasedperson OWNER TO postgres;

--
-- Name: la_party_organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_party_organization (
    organizationid bigint NOT NULL,
    organizationname character varying(100) NOT NULL,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer NOT NULL,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    identitytypeid integer,
    identityregistrationno character varying(50),
    contactno character varying(15),
    faxno character varying(15),
    emailid character varying(50),
    website character varying(50),
    grouptypeid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    address character varying(200),
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100)
);


ALTER TABLE la_party_organization OWNER TO postgres;

--
-- Name: la_party_partyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_party_partyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_party_partyid_seq OWNER TO postgres;

--
-- Name: la_party_partyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_party_partyid_seq OWNED BY la_party.partyid;


--
-- Name: la_party_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_party_person (
    personid bigint NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50),
    lastname character varying(50) NOT NULL,
    genderid integer NOT NULL,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer NOT NULL,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    occupationid integer,
    relationshiptypeid integer,
    maritalstatusid integer,
    educationlevelid integer,
    tenureclassid integer,
    identitytypeid integer NOT NULL,
    identityno character varying(50) NOT NULL,
    dateofbirth date,
    fathername character varying(100),
    husbandname character varying(100),
    mothername character varying(100),
    contactno character varying(15),
    address character varying(250),
    photo bytea,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    ownertype integer,
    ethnicity integer,
    citizenship integer,
    resident character varying(100)
);


ALTER TABLE la_party_person OWNER TO postgres;

--
-- Name: la_partygroup_citizenship_citizenshipid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_citizenship_citizenshipid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_citizenship_citizenshipid_seq OWNER TO postgres;

--
-- Name: la_partygroup_citizenship; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_citizenship (
    citizenshipid integer DEFAULT nextval('la_partygroup_citizenship_citizenshipid_seq'::regclass) NOT NULL,
    citizenship character varying(50) NOT NULL,
    citizenship_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_citizenship OWNER TO postgres;

--
-- Name: la_partygroup_educationlevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_educationlevel (
    educationlevelid integer NOT NULL,
    educationlevel character varying(50) NOT NULL,
    educationlevel_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_educationlevel OWNER TO postgres;

--
-- Name: la_partygroup_educationlevel_educationlevelid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_educationlevel_educationlevelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_educationlevel_educationlevelid_seq OWNER TO postgres;

--
-- Name: la_partygroup_educationlevel_educationlevelid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_educationlevel_educationlevelid_seq OWNED BY la_partygroup_educationlevel.educationlevelid;


--
-- Name: la_partygroup_ethnicity_ethnicityid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_ethnicity_ethnicityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_ethnicity_ethnicityid_seq OWNER TO postgres;

--
-- Name: la_partygroup_ethnicity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_ethnicity (
    ethnicityid integer DEFAULT nextval('la_partygroup_ethnicity_ethnicityid_seq'::regclass) NOT NULL,
    ethnicity character varying(50) NOT NULL,
    ethnicity_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_ethnicity OWNER TO postgres;

--
-- Name: la_partygroup_gender; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_gender (
    genderid integer NOT NULL,
    gender character varying(50) NOT NULL,
    gender_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_gender OWNER TO postgres;

--
-- Name: la_partygroup_gender_genderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_gender_genderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_gender_genderid_seq OWNER TO postgres;

--
-- Name: la_partygroup_gender_genderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_gender_genderid_seq OWNED BY la_partygroup_gender.genderid;


--
-- Name: la_partygroup_identitytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_identitytype (
    identitytypeid integer NOT NULL,
    identitytype character varying(50) NOT NULL,
    identitytype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_identitytype OWNER TO postgres;

--
-- Name: la_partygroup_identitytype_identitytypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_identitytype_identitytypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_identitytype_identitytypeid_seq OWNER TO postgres;

--
-- Name: la_partygroup_identitytype_identitytypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_identitytype_identitytypeid_seq OWNED BY la_partygroup_identitytype.identitytypeid;


--
-- Name: la_partygroup_maritalstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_maritalstatus (
    maritalstatusid integer NOT NULL,
    maritalstatus character varying(50) NOT NULL,
    maritalstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_maritalstatus OWNER TO postgres;

--
-- Name: la_partygroup_maritalstatus_maritalstatusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_maritalstatus_maritalstatusid_seq OWNER TO postgres;

--
-- Name: la_partygroup_maritalstatus_maritalstatusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq OWNED BY la_partygroup_maritalstatus.maritalstatusid;


--
-- Name: la_partygroup_occupation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_occupation (
    occupationid integer NOT NULL,
    occupation character varying(50) NOT NULL,
    occupation_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_occupation OWNER TO postgres;

--
-- Name: la_partygroup_occupation_occupationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_occupation_occupationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_occupation_occupationid_seq OWNER TO postgres;

--
-- Name: la_partygroup_occupation_occupationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_occupation_occupationid_seq OWNED BY la_partygroup_occupation.occupationid;


--
-- Name: la_partygroup_persontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_persontype (
    persontypeid integer NOT NULL,
    persontype character varying(50) NOT NULL,
    persontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_persontype OWNER TO postgres;

--
-- Name: la_partygroup_persontype_persontypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_persontype_persontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_persontype_persontypeid_seq OWNER TO postgres;

--
-- Name: la_partygroup_persontype_persontypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_persontype_persontypeid_seq OWNED BY la_partygroup_persontype.persontypeid;


--
-- Name: la_partygroup_relationshiptype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_relationshiptype (
    relationshiptypeid integer NOT NULL,
    relationshiptype character varying(50) NOT NULL,
    relationshiptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_relationshiptype OWNER TO postgres;

--
-- Name: la_partygroup_relationshiptype_relationshiptypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_relationshiptype_relationshiptypeid_seq OWNER TO postgres;

--
-- Name: la_partygroup_relationshiptype_relationshiptypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq OWNED BY la_partygroup_relationshiptype.relationshiptypeid;


--
-- Name: la_partygroup_resident_residentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_resident_residentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_resident_residentid_seq OWNER TO postgres;

--
-- Name: la_partygroup_resident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_resident (
    residentid integer DEFAULT nextval('la_partygroup_resident_residentid_seq'::regclass) NOT NULL,
    resident character varying(50) NOT NULL,
    resident_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_resident OWNER TO postgres;

--
-- Name: la_right_acquisitiontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_acquisitiontype (
    acquisitiontypeid integer NOT NULL,
    acquisitiontype character varying(50) NOT NULL,
    acquisitiontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_acquisitiontype OWNER TO postgres;

--
-- Name: la_right_acquisitiontype_acquisitiontypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_acquisitiontype_acquisitiontypeid_seq OWNER TO postgres;

--
-- Name: la_right_acquisitiontype_acquisitiontypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq OWNED BY la_right_acquisitiontype.acquisitiontypeid;


--
-- Name: la_right_claimtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_claimtype (
    claimtypeid integer NOT NULL,
    claimtype character varying(50) NOT NULL,
    claimtype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_claimtype OWNER TO postgres;

--
-- Name: la_right_claimtype_claimtypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_claimtype_claimtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_claimtype_claimtypeid_seq OWNER TO postgres;

--
-- Name: la_right_claimtype_claimtypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_claimtype_claimtypeid_seq OWNED BY la_right_claimtype.claimtypeid;


--
-- Name: la_right_landsharetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_landsharetype (
    landsharetypeid integer NOT NULL,
    landsharetype character varying(50) NOT NULL,
    landsharetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_landsharetype OWNER TO postgres;

--
-- Name: la_right_landsharetype_landsharetypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_landsharetype_landsharetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_landsharetype_landsharetypeid_seq OWNER TO postgres;

--
-- Name: la_right_landsharetype_landsharetypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_landsharetype_landsharetypeid_seq OWNED BY la_right_landsharetype.landsharetypeid;


--
-- Name: la_right_tenureclass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_tenureclass (
    tenureclassid integer NOT NULL,
    tenureclass character varying(50) NOT NULL,
    tenureclass_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_tenureclass OWNER TO postgres;

--
-- Name: la_right_tenureclass_tenureclassid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_tenureclass_tenureclassid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_tenureclass_tenureclassid_seq OWNER TO postgres;

--
-- Name: la_right_tenureclass_tenureclassid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_tenureclass_tenureclassid_seq OWNED BY la_right_tenureclass.tenureclassid;


--
-- Name: la_rrr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr (
    rrrid integer NOT NULL,
    rrrtype character varying(50),
    rrrtypeid integer NOT NULL
);


ALTER TABLE la_rrr OWNER TO postgres;

--
-- Name: la_rrr_lease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr_lease (
    leaseid integer NOT NULL,
    leaseyear integer,
    monthid integer,
    leaseamount double precision,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    personid bigint,
    landid bigint,
    ownerid bigint,
    leasestartdate date,
    leaseenddate date
);


ALTER TABLE la_rrr_lease OWNER TO postgres;

--
-- Name: la_rrr_mortgage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr_mortgage (
    mortgageid integer NOT NULL,
    financialagencyid integer NOT NULL,
    mortgagefrom date NOT NULL,
    mortgageto date NOT NULL,
    mortgageamount double precision NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    landid bigint,
    ownerid bigint
);


ALTER TABLE la_rrr_mortgage OWNER TO postgres;

--
-- Name: la_rrr_rrrid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_rrr_rrrid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_rrr_rrrid_seq OWNER TO postgres;

--
-- Name: la_rrr_surrenderlease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr_surrenderlease (
    leaseid integer NOT NULL,
    leaseyear integer NOT NULL,
    monthid integer NOT NULL,
    leaseamount double precision NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    personid bigint,
    landid bigint,
    ownerid bigint,
    leasestartdate timestamp without time zone,
    leaseenddate timestamp without time zone,
    surrenderreason character varying(250)
);


ALTER TABLE la_rrr_surrenderlease OWNER TO postgres;

--
-- Name: la_rrr_surrendermortgage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr_surrendermortgage (
    mortgageid integer NOT NULL,
    financialagencyid integer NOT NULL,
    mortgagefrom date NOT NULL,
    mortgageto date NOT NULL,
    mortgageamount double precision NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    landid bigint,
    ownerid bigint,
    surrenderreason character varying(250)
);


ALTER TABLE la_rrr_surrendermortgage OWNER TO postgres;

--
-- Name: la_spatialsource_layer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialsource_layer (
    layerid integer NOT NULL,
    layername character varying(50) NOT NULL,
    projectionid integer NOT NULL,
    unitid integer NOT NULL,
    documentformatid integer NOT NULL,
    layertypeid integer NOT NULL,
    minresolution double precision,
    maxresolution double precision,
    zoomlevelextent integer,
    minextent character varying(250),
    maxextent character varying(250),
    minscale integer,
    maxscale integer,
    location character varying(250),
    geometrytype character varying(30),
    buffer integer,
    displayname character varying(250),
    filter character varying(250),
    version character varying(250),
    displayinlayermanager boolean DEFAULT false,
    displayoutsidemaxextent boolean DEFAULT false,
    editable boolean DEFAULT false,
    exportable boolean DEFAULT false,
    isbaselayer boolean DEFAULT false,
    queryable boolean DEFAULT false,
    selectable boolean DEFAULT false,
    sphericalmercator boolean DEFAULT false,
    tiled boolean DEFAULT true,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    name character varying(400)
);


ALTER TABLE la_spatialsource_layer OWNER TO postgres;

--
-- Name: la_spatialsource_layer_layerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialsource_layer_layerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialsource_layer_layerid_seq OWNER TO postgres;

--
-- Name: la_spatialsource_layer_layerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialsource_layer_layerid_seq OWNED BY la_spatialsource_layer.layerid;


--
-- Name: la_spatialsource_projectname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialsource_projectname (
    projectnameid integer NOT NULL,
    projectname character varying(50) NOT NULL,
    projectionid integer NOT NULL,
    unitid integer NOT NULL,
    documentformatid integer NOT NULL,
    minresolution double precision,
    maxresolution double precision,
    zoomlevelextent integer,
    minextent character varying(250),
    maxextent character varying(250),
    activelayer character varying(30),
    overlaymap character varying(30),
    disclaimer character varying(250),
    description character varying(250),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    workflowdefid integer
);


ALTER TABLE la_spatialsource_projectname OWNER TO postgres;

--
-- Name: la_spatialsource_projectname_projectnameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialsource_projectname_projectnameid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialsource_projectname_projectnameid_seq OWNER TO postgres;

--
-- Name: la_spatialsource_projectname_projectnameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialsource_projectname_projectnameid_seq OWNED BY la_spatialsource_projectname.projectnameid;


--
-- Name: la_spatialunit_aoi_aoiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_aoi_aoiid_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_aoi_aoiid_seq OWNER TO postgres;

--
-- Name: la_spatialunit_aoi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_aoi (
    geometry geometry(Polygon,4326) NOT NULL,
    ogc_fid bigint,
    aoiid integer DEFAULT nextval('la_spatialunit_aoi_aoiid_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    projectnameid integer NOT NULL,
    applicationstatusid integer,
    createdby integer,
    createddate timestamp without time zone,
    modifiedby integer,
    modifieddate timestamp without time zone,
    aoiname character(50),
    isactive boolean DEFAULT true NOT NULL,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_aoi OWNER TO postgres;

--
-- Name: la_spatialunit_aoi_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_aoi_id_seq1
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_aoi_id_seq1 OWNER TO postgres;

--
-- Name: la_spatialunit_aoiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_aoiid_seq
    START WITH 25
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_aoiid_seq OWNER TO postgres;

--
-- Name: la_spatialunit_land; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_land (
    geometry geometry(Polygon,4326),
    ogc_fid bigint,
    landid integer NOT NULL,
    landno character varying(50) NOT NULL,
    projectnameid integer,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    landtypeid integer,
    landusetypeid integer,
    landsoilqualityid integer,
    acquisitiontypeid integer,
    claimtypeid integer,
    landsharetypeid integer,
    tenureclassid integer,
    slopevalueid integer,
    unitid integer NOT NULL,
    area double precision NOT NULL,
    neighbor_east character varying(100),
    neighbor_west character varying(100),
    neighbor_north character varying(100),
    neighbor_south character varying(100),
    surveydate date,
    geometrytype character varying(15) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    claimno integer,
    proposedused integer,
    oldlandid bigint,
    udparcelno character varying,
    isactive boolean DEFAULT true NOT NULL,
    other_use character varying(100),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_land OWNER TO postgres;

--
-- Name: la_spatialunit_land_landid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_land_landid_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_land_landid_seq OWNER TO postgres;

--
-- Name: la_spatialunit_land_landid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialunit_land_landid_seq OWNED BY la_spatialunit_land.landid;


--
-- Name: la_spatialunit_resource_land_landid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_resource_land_landid_seq
    START WITH 183
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_resource_land_landid_seq OWNER TO postgres;

--
-- Name: la_spatialunit_resource_land; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_resource_land (
    geometry geometry(Polygon,4326),
    ogc_fid bigint,
    landid integer DEFAULT nextval('la_spatialunit_resource_land_landid_seq'::regclass) NOT NULL,
    landno character varying(50) NOT NULL,
    projectnameid integer,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    landtypeid integer,
    landusetypeid integer,
    landsoilqualityid integer,
    acquisitiontypeid integer,
    claimtypeid integer,
    landsharetypeid integer,
    tenureclassid integer,
    slopevalueid integer,
    unitid integer NOT NULL,
    area double precision NOT NULL,
    neighbor_east character varying(100),
    neighbor_west character varying(100),
    neighbor_north character varying(100),
    neighbor_south character varying(100),
    surveydate date,
    geometrytype character varying(15) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    isactive boolean DEFAULT true NOT NULL,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_land OWNER TO postgres;

--
-- Name: la_spatialunit_resource_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_resource_line (
    geometry geometry(LineString,4326),
    ogc_fid bigint,
    landid integer DEFAULT nextval('la_spatialunit_resource_land_landid_seq'::regclass) NOT NULL,
    landno character varying(50) NOT NULL,
    projectnameid integer,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    landtypeid integer,
    landusetypeid integer,
    landsoilqualityid integer,
    acquisitiontypeid integer,
    claimtypeid integer,
    landsharetypeid integer,
    tenureclassid integer,
    slopevalueid integer,
    unitid integer NOT NULL,
    area double precision NOT NULL,
    neighbor_east character varying(100),
    neighbor_west character varying(100),
    neighbor_north character varying(100),
    neighbor_south character varying(100),
    surveydate date,
    geometrytype character varying(15) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    isactive boolean DEFAULT true NOT NULL,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'LINESTRING'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_line OWNER TO postgres;

--
-- Name: la_spatialunit_resource_point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_resource_point (
    geometry geometry(Point,4326),
    ogc_fid bigint,
    landid integer DEFAULT nextval('la_spatialunit_resource_land_landid_seq'::regclass) NOT NULL,
    landno character varying(50) NOT NULL,
    projectnameid integer,
    spatialunitgroupid1 integer NOT NULL,
    hierarchyid1 integer NOT NULL,
    spatialunitgroupid2 integer NOT NULL,
    hierarchyid2 integer NOT NULL,
    spatialunitgroupid3 integer,
    hierarchyid3 integer NOT NULL,
    spatialunitgroupid4 integer,
    hierarchyid4 integer,
    spatialunitgroupid5 integer,
    hierarchyid5 integer,
    spatialunitgroupid6 integer,
    hierarchyid6 integer,
    landtypeid integer,
    landusetypeid integer,
    landsoilqualityid integer,
    acquisitiontypeid integer,
    claimtypeid integer,
    landsharetypeid integer,
    tenureclassid integer,
    slopevalueid integer,
    unitid integer NOT NULL,
    area double precision NOT NULL,
    neighbor_east character varying(100),
    neighbor_west character varying(100),
    neighbor_north character varying(100),
    neighbor_south character varying(100),
    surveydate date,
    geometrytype character varying(15) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    isactive boolean DEFAULT true NOT NULL,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POINT'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_point OWNER TO postgres;

--
-- Name: la_spatialunitgroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunitgroup (
    spatialunitgroupid integer NOT NULL,
    hierarchy character varying(50) NOT NULL,
    hierarchy_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_spatialunitgroup OWNER TO postgres;

--
-- Name: la_spatialunitgroup_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunitgroup_hierarchy (
    hierarchyid integer NOT NULL,
    name character varying(50) NOT NULL,
    name_en character varying(50) NOT NULL,
    spatialunitgroupid integer,
    uperhierarchyid integer,
    isactive boolean DEFAULT true NOT NULL,
    code character varying(20)
);


ALTER TABLE la_spatialunitgroup_hierarchy OWNER TO postgres;

--
-- Name: la_spatialunitgroup_hierarchy_hierarchyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunitgroup_hierarchy_hierarchyid_seq OWNER TO postgres;

--
-- Name: la_spatialunitgroup_hierarchy_hierarchyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq OWNED BY la_spatialunitgroup_hierarchy.hierarchyid;


--
-- Name: la_spatialunitgroup_spatialunitgroupid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunitgroup_spatialunitgroupid_seq OWNER TO postgres;

--
-- Name: la_spatialunitgroup_spatialunitgroupid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq OWNED BY la_spatialunitgroup.spatialunitgroupid;


--
-- Name: la_surrendermortgage_mortgageid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_surrendermortgage_mortgageid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_surrendermortgage_mortgageid_seq OWNER TO postgres;

--
-- Name: media_attributes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW media_attributes AS
 SELECT DISTINCT spa.surveyprojectattributesid,
    a.parentuid,
    a.attributevalue,
    am.listing,
    am.datatypemasterid
   FROM ((la_ext_attribute a
     JOIN la_ext_surveyprojectattributes spa ON ((spa.surveyprojectattributesid = a.parentuid)))
     JOIN la_ext_attributemaster am ON ((spa.attributemasterid = am.attributemasterid)))
  WHERE (am.attributecategoryid = 3)
  ORDER BY am.listing;


ALTER TABLE media_attributes OWNER TO postgres;

--
-- Name: natural_person_attributes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW natural_person_attributes AS
 SELECT DISTINCT spa.surveyprojectattributesid,
    a.parentuid,
    a.attributevalue,
    am.listing,
    am.datatypemasterid
   FROM ((la_ext_attribute a
     JOIN la_ext_surveyprojectattributes spa ON ((spa.surveyprojectattributesid = a.parentuid)))
     JOIN la_ext_attributemaster am ON ((spa.attributemasterid = am.attributemasterid)))
  WHERE (am.attributecategoryid = 2)
  ORDER BY am.listing;


ALTER TABLE natural_person_attributes OWNER TO postgres;

--
-- Name: nonnatural_person_attributes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nonnatural_person_attributes AS
 SELECT DISTINCT spa.surveyprojectattributesid,
    a.parentuid,
    a.attributevalue,
    am.listing,
    am.datatypemasterid
   FROM ((la_ext_attribute a
     JOIN la_ext_surveyprojectattributes spa ON ((spa.surveyprojectattributesid = a.parentuid)))
     JOIN la_ext_attributemaster am ON ((spa.attributemasterid = am.attributemasterid)))
  WHERE (am.attributecategoryid = 5)
  ORDER BY am.listing;


ALTER TABLE nonnatural_person_attributes OWNER TO postgres;

--
-- Name: right_attributes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW right_attributes AS
 SELECT DISTINCT spa.surveyprojectattributesid,
    a.parentuid,
    a.attributevalue,
    am.listing,
    am.datatypemasterid
   FROM ((la_ext_attribute a
     JOIN la_ext_surveyprojectattributes spa ON ((spa.surveyprojectattributesid = a.parentuid)))
     JOIN la_ext_attributemaster am ON ((spa.attributemasterid = am.attributemasterid)))
  WHERE (am.attributecategoryid = 4)
  ORDER BY am.listing;


ALTER TABLE right_attributes OWNER TO postgres;

--
-- Name: spatial_unit_attributes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spatial_unit_attributes AS
 SELECT DISTINCT spa.surveyprojectattributesid,
    a.parentuid,
    a.attributevalue,
    am.listing,
    am.datatypemasterid
   FROM ((la_ext_attribute a
     JOIN la_ext_surveyprojectattributes spa ON ((spa.surveyprojectattributesid = a.parentuid)))
     JOIN la_ext_attributemaster am ON ((spa.attributemasterid = am.attributemasterid)))
  WHERE (am.attributecategoryid = ANY (ARRAY[1, 6, 7]))
  ORDER BY am.listing;


ALTER TABLE spatial_unit_attributes OWNER TO postgres;

--
-- Name: topology_checks_error_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE topology_checks_error_log (
    id integer DEFAULT nextval('error_log_seq'::regclass) NOT NULL,
    geometry geometry,
    error_message character varying(200),
    layer_name character varying(200),
    landid bigint,
    date timestamp without time zone DEFAULT now(),
    remarks character varying(200),
    statusfixed character varying(1) DEFAULT 'n'::character varying,
    CONSTRAINT chk_statusfixed CHECK (((statusfixed)::text = ANY (ARRAY[('y'::character varying)::text, ('n'::character varying)::text])))
);


ALTER TABLE topology_checks_error_log OWNER TO postgres;

--
-- Name: vertexlabel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vertexlabel (
    gid integer NOT NULL,
    the_geom geometry(Geometry,4326) NOT NULL
);


ALTER TABLE vertexlabel OWNER TO postgres;

--
-- Name: landsoilqualityid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landsoilquality ALTER COLUMN landsoilqualityid SET DEFAULT nextval('la_baunit_landsoilquality_landsoilqualityid_seq'::regclass);


--
-- Name: landtypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landtype ALTER COLUMN landtypeid SET DEFAULT nextval('la_baunit_landtype_landtypeid_seq'::regclass);


--
-- Name: landusetypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landusetype ALTER COLUMN landusetypeid SET DEFAULT nextval('la_baunit_landusetype_landusetypeid_seq'::regclass);


--
-- Name: applicationstatusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_applicationstatus ALTER COLUMN applicationstatusid SET DEFAULT nextval('la_ext_applicationstatus_applicationstatusid_seq'::regclass);


--
-- Name: attributeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attribute ALTER COLUMN attributeid SET DEFAULT nextval('la_ext_attribute_attributeid_seq'::regclass);


--
-- Name: attributecategoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributecategory ALTER COLUMN attributecategoryid SET DEFAULT nextval('la_ext_attributecategory_attributecategoryid_seq'::regclass);


--
-- Name: datatypemasterid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributedatatype ALTER COLUMN datatypemasterid SET DEFAULT nextval('la_ext_attributedatatype_datatypemasterid_seq'::regclass);


--
-- Name: attributemasterid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributemaster ALTER COLUMN attributemasterid SET DEFAULT nextval('la_ext_attributemaster_attributemasterid_seq'::regclass);


--
-- Name: attributeoptionsid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributeoptions ALTER COLUMN attributeoptionsid SET DEFAULT nextval('la_ext_attributeoptions_attributeoptionsid_seq'::regclass);


--
-- Name: baselayerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_baselayer ALTER COLUMN baselayerid SET DEFAULT nextval('la_ext_baselayer_baselayerid_seq'::regclass);


--
-- Name: bookmarkid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_bookmark ALTER COLUMN bookmarkid SET DEFAULT nextval('la_ext_bookmark_bookmarkid_seq'::regclass);


--
-- Name: categorytypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_categorytype ALTER COLUMN categorytypeid SET DEFAULT nextval('la_ext_categorytype_categorytypeid_seq'::regclass);


--
-- Name: disputelandid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping ALTER COLUMN disputelandid SET DEFAULT nextval('la_ext_disputelandmapping_disputelandid_seq'::regclass);


--
-- Name: disputestatusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputestatus ALTER COLUMN disputestatusid SET DEFAULT nextval('la_ext_disputestatus_disputestatusid_seq'::regclass);


--
-- Name: disputetypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputetype ALTER COLUMN disputetypeid SET DEFAULT nextval('la_ext_disputetype_disputetypeid_seq'::regclass);


--
-- Name: documentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails ALTER COLUMN documentid SET DEFAULT nextval('la_ext_documentdetails_documentid_seq'::regclass);


--
-- Name: documentformatid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentformat ALTER COLUMN documentformatid SET DEFAULT nextval('la_ext_documentformat_documentformatid_seq'::regclass);


--
-- Name: documenttypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documenttype ALTER COLUMN documenttypeid SET DEFAULT nextval('la_ext_documenttype_documenttypeid_seq'::regclass);


--
-- Name: financialagencyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_financialagency ALTER COLUMN financialagencyid SET DEFAULT nextval('la_ext_financialagency_financialagencyid_seq'::regclass);


--
-- Name: geometrytypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_geometrytype ALTER COLUMN geometrytypeid SET DEFAULT nextval('la_ext_geometrytype_geometryid_seq'::regclass);


--
-- Name: grouptypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_grouptype ALTER COLUMN grouptypeid SET DEFAULT nextval('la_ext_grouptype_grouptypeid_seq'::regclass);


--
-- Name: landworkflowhistoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landworkflowhistory ALTER COLUMN landworkflowhistoryid SET DEFAULT nextval('la_ext_landworkflowhistory_landworkflowhistoryid_seq'::regclass);


--
-- Name: layer_layergroupid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layer_layergroup ALTER COLUMN layer_layergroupid SET DEFAULT nextval('la_ext_layer_layergroup_layer_layergroupid_seq'::regclass);


--
-- Name: layerfieldid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layerfield ALTER COLUMN layerfieldid SET DEFAULT nextval('la_ext_layerfield_layerfieldid_seq'::regclass);


--
-- Name: layergroupid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layergroup ALTER COLUMN layergroupid SET DEFAULT nextval('la_ext_layergroup_layergroupid_seq'::regclass);


--
-- Name: layertypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layertype ALTER COLUMN layertypeid SET DEFAULT nextval('la_ext_layertype_layertypeid_seq'::regclass);


--
-- Name: moduleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_module ALTER COLUMN moduleid SET DEFAULT nextval('la_ext_module_moduleid_seq'::regclass);


--
-- Name: monthid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_month ALTER COLUMN monthid SET DEFAULT nextval('la_ext_month_monthid_seq'::regclass);


--
-- Name: personlandid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping ALTER COLUMN personlandid SET DEFAULT nextval('la_ext_personlandmapping_personlandid_seq'::regclass);


--
-- Name: processid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_process ALTER COLUMN processid SET DEFAULT nextval('la_ext_process_processid_seq'::regclass);


--
-- Name: projectadjudicatorid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectadjudicator ALTER COLUMN projectadjudicatorid SET DEFAULT nextval('la_ext_projectadjudicator_projectadjudicatorid_seq'::regclass);


--
-- Name: projectareaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea ALTER COLUMN projectareaid SET DEFAULT nextval('la_ext_projectarea_projectareaid_seq'::regclass);


--
-- Name: projectbaselayerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectbaselayermapping ALTER COLUMN projectbaselayerid SET DEFAULT nextval('la_ext_projectbaselayermapping_projectbaselayerid_seq'::regclass);


--
-- Name: projectfileid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectfile ALTER COLUMN projectfileid SET DEFAULT nextval('la_ext_projectfile_projectfileid_seq'::regclass);


--
-- Name: projecthamletid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projecthamlet ALTER COLUMN projecthamletid SET DEFAULT nextval('la_ext_projecthamlet_projecthamletid_seq'::regclass);


--
-- Name: projectionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projection ALTER COLUMN projectionid SET DEFAULT nextval('la_ext_projection_projectionid_seq'::regclass);


--
-- Name: projectlayergroupid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectlayergroupmapping ALTER COLUMN projectlayergroupid SET DEFAULT nextval('la_ext_projectlayergroupmapping_projectlayergroupid_seq'::regclass);


--
-- Name: customattributeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attribute ALTER COLUMN customattributeid SET DEFAULT nextval('la_ext_resource_custom_attribute_customattributeid_seq'::regclass);


--
-- Name: classificationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourceclassification ALTER COLUMN classificationid SET DEFAULT nextval('la_ext_resourceclassification_classificationid_seq'::regclass);


--
-- Name: subclassificationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcesubclassification ALTER COLUMN subclassificationid SET DEFAULT nextval('la_ext_resourcesubclassification_subclassificationid_seq'::regclass);


--
-- Name: roleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_role ALTER COLUMN roleid SET DEFAULT nextval('la_ext_role_roleid_seq'::regclass);


--
-- Name: rolemoduleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_rolemodulemapping ALTER COLUMN rolemoduleid SET DEFAULT nextval('la_ext_rolemodulemapping_rolemoduleid_seq'::regclass);


--
-- Name: slopevalueid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_slopevalue ALTER COLUMN slopevalueid SET DEFAULT nextval('la_ext_slopevalue_slopevalueid_seq'::regclass);


--
-- Name: surveyprojectattributesid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_surveyprojectattributes ALTER COLUMN surveyprojectattributesid SET DEFAULT nextval('la_ext_surveyprojectattributes_surveyprojectattributesid_seq'::regclass);


--
-- Name: transactionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_transactiondetails ALTER COLUMN transactionid SET DEFAULT nextval('la_ext_transactiondetails_transactionid_seq'::regclass);


--
-- Name: unitid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_unit ALTER COLUMN unitid SET DEFAULT nextval('la_ext_unit_unitid_seq'::regclass);


--
-- Name: userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_user ALTER COLUMN userid SET DEFAULT nextval('la_ext_user_userid_seq'::regclass);


--
-- Name: userprojectid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userprojectmapping ALTER COLUMN userprojectid SET DEFAULT nextval('la_ext_userprojectmapping_userprojectid_seq'::regclass);


--
-- Name: userroleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userrolemapping ALTER COLUMN userroleid SET DEFAULT nextval('la_ext_userrolemapping_userroleid_seq'::regclass);


--
-- Name: workflowid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflow ALTER COLUMN workflowid SET DEFAULT nextval('la_ext_workflow_workflowid_seq'::regclass);


--
-- Name: workflowdefid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflowdef ALTER COLUMN workflowdefid SET DEFAULT nextval('la_ext_workflowdef_workflowdefid_seq'::regclass);


--
-- Name: partyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party ALTER COLUMN partyid SET DEFAULT nextval('la_party_partyid_seq'::regclass);


--
-- Name: educationlevelid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_educationlevel ALTER COLUMN educationlevelid SET DEFAULT nextval('la_partygroup_educationlevel_educationlevelid_seq'::regclass);


--
-- Name: genderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_gender ALTER COLUMN genderid SET DEFAULT nextval('la_partygroup_gender_genderid_seq'::regclass);


--
-- Name: identitytypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_identitytype ALTER COLUMN identitytypeid SET DEFAULT nextval('la_partygroup_identitytype_identitytypeid_seq'::regclass);


--
-- Name: maritalstatusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_maritalstatus ALTER COLUMN maritalstatusid SET DEFAULT nextval('la_partygroup_maritalstatus_maritalstatusid_seq'::regclass);


--
-- Name: occupationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_occupation ALTER COLUMN occupationid SET DEFAULT nextval('la_partygroup_occupation_occupationid_seq'::regclass);


--
-- Name: persontypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_persontype ALTER COLUMN persontypeid SET DEFAULT nextval('la_partygroup_persontype_persontypeid_seq'::regclass);


--
-- Name: relationshiptypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_relationshiptype ALTER COLUMN relationshiptypeid SET DEFAULT nextval('la_partygroup_relationshiptype_relationshiptypeid_seq'::regclass);


--
-- Name: acquisitiontypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_acquisitiontype ALTER COLUMN acquisitiontypeid SET DEFAULT nextval('la_right_acquisitiontype_acquisitiontypeid_seq'::regclass);


--
-- Name: claimtypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_claimtype ALTER COLUMN claimtypeid SET DEFAULT nextval('la_right_claimtype_claimtypeid_seq'::regclass);


--
-- Name: landsharetypeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_landsharetype ALTER COLUMN landsharetypeid SET DEFAULT nextval('la_right_landsharetype_landsharetypeid_seq'::regclass);


--
-- Name: tenureclassid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_tenureclass ALTER COLUMN tenureclassid SET DEFAULT nextval('la_right_tenureclass_tenureclassid_seq'::regclass);


--
-- Name: layerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer ALTER COLUMN layerid SET DEFAULT nextval('la_spatialsource_layer_layerid_seq'::regclass);


--
-- Name: projectnameid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_projectname ALTER COLUMN projectnameid SET DEFAULT nextval('la_spatialsource_projectname_projectnameid_seq'::regclass);


--
-- Name: landid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land ALTER COLUMN landid SET DEFAULT nextval('la_spatialunit_land_landid_seq'::regclass);


--
-- Name: spatialunitgroupid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup ALTER COLUMN spatialunitgroupid SET DEFAULT nextval('la_spatialunitgroup_spatialunitgroupid_seq'::regclass);


--
-- Name: hierarchyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup_hierarchy ALTER COLUMN hierarchyid SET DEFAULT nextval('la_spatialunitgroup_hierarchy_hierarchyid_seq'::regclass);


--
-- Name: error_log_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('error_log_seq', 1756, true);


--
-- Data for Name: la_baunit_landsoilquality; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_baunit_landsoilquality (landsoilqualityid, landsoilqualitytype, landsoilqualitytype_en, isactive) VALUES (1, 'Very good', 'Very good', true);
INSERT INTO la_baunit_landsoilquality (landsoilqualityid, landsoilqualitytype, landsoilqualitytype_en, isactive) VALUES (2, 'Moderate good', 'Moderate good', true);
INSERT INTO la_baunit_landsoilquality (landsoilqualityid, landsoilqualitytype, landsoilqualitytype_en, isactive) VALUES (3, 'Poor', 'Poor', true);
INSERT INTO la_baunit_landsoilquality (landsoilqualityid, landsoilqualitytype, landsoilqualitytype_en, isactive) VALUES (4, 'Very poor', 'Very poor', true);


--
-- Name: la_baunit_landsoilquality_landsoilqualityid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_baunit_landsoilquality_landsoilqualityid_seq', 4, true);


--
-- Data for Name: la_baunit_landtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_baunit_landtype (landtypeid, landtype, landtype_en, isactive) VALUES (1, 'Flat/Plain', 'Flat/Plain', true);
INSERT INTO la_baunit_landtype (landtypeid, landtype, landtype_en, isactive) VALUES (2, 'Sloping', 'Sloping', true);
INSERT INTO la_baunit_landtype (landtypeid, landtype, landtype_en, isactive) VALUES (3, 'Mountainous', 'Mountainous', true);
INSERT INTO la_baunit_landtype (landtypeid, landtype, landtype_en, isactive) VALUES (4, 'Valley', 'Valley', true);
INSERT INTO la_baunit_landtype (landtypeid, landtype, landtype_en, isactive) VALUES (9999, 'Dummy', 'Dummy', false);


--
-- Name: la_baunit_landtype_landtypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_baunit_landtype_landtypeid_seq', 4, true);


--
-- Data for Name: la_baunit_landusetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (1, 'Agriculture', 'Agriculture', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (13, 'Industrial', 'Industrial', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (14, 'Conservation', 'Conservation', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (2, 'Settlement', 'Settlement', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (3, 'Livestock (intensive/ stationary)', 'Livestock (intensive/ stationary)', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (4, 'Livestock (pastoralism)', 'Livestock (pastoralism)', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (5, 'Forest/ Woodlands', 'Forest/ Woodlands', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (6, 'Forest Reserve', 'Forest Reserve', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (7, 'Grassland', 'Grassland', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (8, 'Facility (church/mosque/recreation)', 'Facility (church/mosque/recreation)', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (9, 'Commercial/Service ', 'Commercial/Service ', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (9999, 'Dummy', 'Dummy', false);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (10, 'Wildlife (hunting)', 'Wildlife (hunting)', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (11, 'Wildlife (tourism)', 'Wildlife (tourism)', true);
INSERT INTO la_baunit_landusetype (landusetypeid, landusetype, landusetype_en, isactive) VALUES (12, 'Minning', 'Minning', true);


--
-- Name: la_baunit_landusetype_landusetypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_baunit_landusetype_landusetypeid_seq', 15, true);


--
-- Data for Name: la_ext_applicationstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_applicationstatus (applicationstatusid, applicationstatus, applicationstatus_en, isactive) VALUES (1, 'New', 'New', true);
INSERT INTO la_ext_applicationstatus (applicationstatusid, applicationstatus, applicationstatus_en, isactive) VALUES (2, 'Approved', 'Approved', true);
INSERT INTO la_ext_applicationstatus (applicationstatusid, applicationstatus, applicationstatus_en, isactive) VALUES (3, 'Rejected', 'Rejected', true);
INSERT INTO la_ext_applicationstatus (applicationstatusid, applicationstatus, applicationstatus_en, isactive) VALUES (4, 'Pending', 'Pending', true);
INSERT INTO la_ext_applicationstatus (applicationstatusid, applicationstatus, applicationstatus_en, isactive) VALUES (5, 'Registered', 'Registered', true);


--
-- Name: la_ext_applicationstatus_applicationstatusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_applicationstatus_applicationstatusid_seq', 5, true);


--
-- Data for Name: la_ext_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_attribute_attributeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_attribute_attributeid_seq', 1, false);


--
-- Data for Name: la_ext_attributecategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (1, 'General', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (6, 'custom', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (7, 'General(Property)', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (3, 'Multimedia', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (4, 'Tenure', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (8, 'Person of Interest', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (2, 'Person', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (5, 'Organization', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (16, 'Add Person', 1, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (10, 'Private (individual)', 2, 1);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (17, 'Private (jointly)', 2, 2);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (18, 'Organization (informal)', 2, 3);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (14, 'Organization (formal)', 2, 4);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (12, 'Community', 2, 5);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (11, 'Collective', 2, 6);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (9, 'Open', 2, 7);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (13, 'Public', 2, 8);
INSERT INTO la_ext_attributecategory (attributecategoryid, categoryname, categorytypeid, categorydisplayorder) VALUES (15, 'Other', 2, 9);


--
-- Name: la_ext_attributecategory_attributecategoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_attributecategory_attributecategoryid_seq', 19, true);


--
-- Data for Name: la_ext_attributedatatype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (1, 'String');
INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (3, 'Boolean');
INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (2, 'Date');
INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (4, 'Number');
INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (5, 'Dropdown');
INSERT INTO la_ext_attributedatatype (datatypemasterid, datatype) VALUES (6, 'Multiselect');


--
-- Name: la_ext_attributedatatype_datatypemasterid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_attributedatatype_datatypemasterid_seq', 7, false);


--
-- Data for Name: la_ext_attributemaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1011, 'private', 'private', 1, 10, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1012, 'common', 'common', 1, 11, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1013, 'community', 'community', 1, 12, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1014, 'public_state', 'public_state', 1, 13, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (10, 'comments', 'Comments', 1, 3, 'la_spatialunit_land', '', false, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1055, 'Other details', 'Other details', 1, 15, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (11, 'documentname', 'Name', 1, 3, 'la_ext_documentdetails', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1010, 'open', 'open', 1, 9, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1052, 'Tenure Name', 'Tenure Name', 1, 9, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1054, 'Tenure Name', 'Tenure Name', 1, 15, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1056, 'Natural Person Type', 'Natural Person', 5, 16, 'asadadadaas', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1058, 'Proposed Use', 'Proposed Use', 5, 7, 'la_spatialunit_land', '100', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1015, 'open1', 'open1', 1, 9, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (37, 'Land Type', 'Land Type', 5, 7, 'la_spatialunit_land', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1042, 'Mobile No', 'Mobile number', 4, 14, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1040, 'Address', 'Region', 1, 14, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1027, 'Address', 'Community', 1, 10, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1053, 'Other details', 'Other details', 1, 9, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1028, 'Address', 'Region', 1, 10, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1029, 'Address', 'Country', 1, 10, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1041, 'Address', 'Country', 1, 14, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1043, 'Community or Parties', 'name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1044, 'firstname', 'First Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1049, 'Address', 'Region', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1050, 'Address', 'Country', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1039, 'Address', 'Community Area', 1, 14, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1057, 'Non- Natural Person Type', 'Non- Natural Person', 5, 16, 'asadadadaas', '100', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (13, 'Years of Occupancy', 'Years of Occupancy', 4, 4, 'la_ext_personlandmapping', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (9, 'proposed_use', 'Proposed Use', 5, 4, 'la_spatialunit_land', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1045, 'middlename', 'Middle Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1046, 'lastname', 'Last Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1047, 'Address', 'Community Area', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1051, 'Mobile No', 'Mobile number', 4, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (46, 'neighbor_east', 'Neighbor East', 1, 7, 'la_spatialunit_land', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (47, 'neighbor_west', 'Neighbor West', 1, 7, 'la_spatialunit_land', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (44, 'neighbor_north', 'Neighbor North', 1, 7, 'la_spatialunit_land', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (45, 'neighbor_south', 'Neighbor South', 1, 7, 'la_spatialunit_land', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (24, 'Type of Tenure /Occupancy ', 'Type of Tenure /Occupancy ', 5, 4, 'la_ext_personlandmapping', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (16, 'existing_use', 'Existing Use', 5, 7, 'la_spatialunit_land', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (15, 'total_househld_no', 'Number of signatory(s)', 4, 1, 'la_spatialunit_land', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (40, 'owner', 'Owner', 3, 2, 'la party person', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (41, 'administator', 'Administator', 1, 2, 'la party person', '', false, '5', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (53, 'Other Use', 'Other Use', 1, 7, 'la_spatialunit_land', '', false, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1072, 'Address', 'Community', 1, 17, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1075, 'Address', 'Region', 1, 17, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (7, 'Address', 'Address', 1, 5, 'la_party_organization', '', false, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (8, 'Mobile No.', 'Mobile No.', 4, 5, 'la_party_organization', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1076, 'Address', 'Country', 1, 17, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1031, 'Institution Name', 'Institution Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1017, 'firstname', 'First Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1032, 'Registration No', 'Registration Number', 4, 14, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1033, 'Registration Date', 'Registration Date', 2, 14, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1034, 'How many members?', 'How many members?', 4, 14, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1035, 'firstname', 'First Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1036, 'middlename', 'Middle Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1037, 'lastname', 'Last Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1038, 'Address', 'Address/Street', 1, 14, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1063, 'firstname', 'First Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1065, 'middlename', 'Middle Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1066, 'lastname', 'Last Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1067, 'genderid', 'Gender', 5, 17, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1064, 'Marital Status', 'Marital Status', 5, 17, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1069, 'Citizenship', 'Citizenship', 5, 17, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1070, 'Ethnicity', 'Ethnicity', 5, 17, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1071, 'Resident', 'Resident', 5, 17, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1, 'First Name', 'First Name', 1, 2, 'la party person', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (3, 'Middle Name', 'Middle Name', 1, 2, 'la party person', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (2, 'Last Name', 'Last Name', 1, 2, 'la party person', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (4, 'Gender', 'Gender', 5, 2, 'la party person', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (22, ' Marital Status', 'Marital Status', 5, 2, 'la party person', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (42, 'Citizenship', 'Citizenship', 5, 2, 'la party person', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (43, 'Resident', 'Resident', 3, 2, 'la party person', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1078, 'How many members?', 'How many members?', 4, 18, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1079, 'firstname', 'First Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1080, 'middlename', 'Middle Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1081, 'lastname', 'Last Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1082, 'Address', 'Address/Street', 1, 18, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1084, 'Address', 'Region', 1, 18, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1085, 'Address', 'Country', 1, 18, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1086, 'Mobile No', 'Mobile number', 4, 18, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1088, 'firstname', 'First Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1089, 'middlename', 'Middle Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1090, 'lastname', 'Last Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1091, 'Address', 'Address/Street', 1, 11, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1093, 'Address', 'Region', 1, 11, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1094, 'Address', 'Country', 1, 11, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1095, 'Mobile No', 'Mobile number', 4, 11, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1109, 'middlename', 'Middle Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1110, 'lastname', 'Last Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1097, 'firstname', 'First Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1098, 'middlename', 'Middle Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1099, 'lastname', 'Last Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1100, 'Address', 'Address/Street', 1, 12, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1103, 'Address', 'Region', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1104, 'Address', 'Country', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1105, 'Mobile No', 'Mobile number', 4, 12, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1108, 'firstname', 'First Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1111, 'Address', 'Address/Street', 1, 13, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1101, 'Address', 'Community Area', 1, 12, 'la_ext_resourceattributevalue', '', true, '9', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1113, 'Address', 'Region', 1, 13, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1114, 'Address', 'Country', 1, 13, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1102, 'Address', 'Community', 1, 12, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1112, 'Address', 'Community Area', 1, 13, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1124, 'Address-Own2', 'Community', 1, 17, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1127, 'Address-Own2', 'Region', 1, 17, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1128, 'Address-Own2', 'Country', 1, 17, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1092, 'Address', 'Community Area', 1, 11, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1083, 'Address', 'Community Area', 1, 18, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1048, 'Address', 'Community', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1087, 'How many members in collective organization?', 'How many members in collective organization?', 4, 11, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1145, 'Address', 'Community', 1, 1, 'General Attributes ', '', true, '3', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1130, 'Address', 'Community Area', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1107, 'Level of Authority', 'Level of Authority', 5, 13, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1132, 'Address', 'Region', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1133, 'Address', 'Country', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1142, 'Middle Name', 'Middle Name', 1, 8, 'Person of Interest', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1139, 'Relationship', 'Relationship', 1, 8, 'Person of Interest', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1140, 'First Name', 'First Name', 1, 8, 'Person of Interest', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1141, 'Last Name', 'Last Name', 1, 8, 'Person of Interest', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1143, 'Claim Number', 'Claim Number', 1, 1, 'General Attributes ', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1144, 'Claim date', 'Claim date', 2, 1, 'General Attributes ', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1149, 'Data Collection Witness 1', 'Data Collection Witness 1', 1, 1, 'General Attributes ', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1146, 'Address', 'Community Area', 1, 1, 'General Attributes ', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1147, 'Person Type ', 'Person Type ', 5, 1, 'General Attributes ', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1148, 'Claim Type', 'Claim Type', 5, 1, 'General Attributes ', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1150, 'Data Collection Witness 2', 'Data Collection Witness 2', 1, 1, 'General Attributes ', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1096, 'Community or Parties', 'Community or Parties', 1, 12, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1131, 'Address', 'Community', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1136, 'First Name', 'First Name', 1, 5, 'la_party_organization', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1137, 'Last Name', 'Last Name', 1, 5, 'la_party_organization', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1077, 'Institution Name', 'Institution Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1068, 'Dob', 'Dob', 2, 17, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1129, 'Dob', 'Dob', 2, 2, 'la_party_person', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1059, 'Clan/Tribe/Ethnicity', 'Clan/Tribe/Ethnicity', 5, 2, 'la party person', '100', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (5, 'Mobile No.', 'Mobile No.', 4, 2, 'la party person', '', false, '13', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1151, 'Address', 'Address', 1, 2, 'la_party_person', '100', true, '14', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1134, 'Education Level', 'Education Level', 5, 2, 'la_party_person', '', true, '15', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1135, 'Occupation', 'Occupation', 5, 2, 'la_party_person', '', true, '16', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1154, 'Institution Type', 'Institution Type', 5, 5, 'la_party_organization', '10', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (6, 'Institution name', 'Institution name', 1, 5, 'la_party_organization', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1138, 'Second Name ', 'Second Name ', 1, 5, 'la_party_organization', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (23, 'Type of Right/Claim', 'Type of Right/Claim', 5, 4, 'la_ext_personlandmapping', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1158, 'Owner Type', 'Owner Type', 5, 10, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1018, 'middlename', 'Middle Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1019, 'lastname', 'Last Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1020, 'genderid', 'Gender', 5, 10, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1021, 'Dob', 'Dob', 2, 10, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1022, 'Marital Status', 'Marital Status', 5, 10, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1023, 'Citizenship', 'Citizenship', 5, 10, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1024, 'Ethnicity', 'Ethnicity', 5, 10, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1025, 'Resident of Community', 'Resident of Community', 5, 10, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1026, 'Address', 'Address/Street', 1, 10, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1030, 'Mobile No', 'Mobile number', 4, 10, 'la_ext_resourceattributevalue', '', true, '12', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1159, 'Owner Type', 'Owner Type', 5, 11, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1160, 'Owner Type', 'Owner Type', 5, 12, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1161, 'Owner Type', 'Owner Type', 5, 14, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1060, 'How are concessions to land handled? ', 'How are concessions to land handled? ', 1, 14, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1162, 'Owner Type', 'Owner Type', 5, 18, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1163, 'Owner Type', 'Owner Type', 5, 17, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1074, 'Address', 'Address/Street', 1, 17, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1073, 'Mobile No', 'Mobile number', 4, 17, 'la_ext_resourceattributevalue', '', true, '12', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1115, 'firstname-Own2', 'First Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1117, 'middlename-Own2', 'Middle Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1118, 'lastname-Own2', 'Last Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1119, 'genderid-Own2', 'Gender', 5, 17, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1120, 'Dob-own2', 'Dob', 2, 17, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1116, 'Marital Status-Own2', 'Marital Status', 5, 17, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1121, 'Citizenship-Own2', 'Citizenship', 5, 17, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1122, 'Ethnicity-Own2', 'Ethnicity', 5, 17, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1123, 'Resident-Own2', 'Resident', 5, 17, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1126, 'Address-Own2', 'Address/Street', 1, 17, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1125, 'Mobile No-Own2', 'Mobile number', 4, 17, 'la_ext_resourceattributevalue', '', true, '12', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1152, 'Identification Type', 'Identification Type', 5, 2, 'la_party_person', '100', true, '11', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1153, 'Identification No', 'Identification No', 1, 2, 'la_party_person', '100', true, '12', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1155, 'Disputed PersonType', 'Disputed PersonType', 5, 2, 'la_party_person', '100', true, '17', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1156, 'Owner Type', 'Owner Type', 5, 2, 'la_party_person', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1165, 'Owner Type', 'Owner Type', 5, 13, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1106, 'Agency Name', 'Agency Name ', 1, 13, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1164, 'Owner Type-Own2', 'Owner Type', 5, 17, 'la_ext_resourceattributevalue', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1166, 'test_custom', 'Test Custom', 1, 15, 'custom', '24', false, '1', true, false);
INSERT INTO la_ext_attributemaster (attributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1167, 'test_custom', 'Test Custom', 4, 6, 'custom', '8', false, '1', true, false);


--
-- Name: la_ext_attributemaster_attributemasterid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_attributemaster_attributemasterid_seq', 1167, true);


--
-- Data for Name: la_ext_attributeoptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1005, 'male', 1020, 1005);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1006, 'female', 1020, 1006);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1007, 'married', 1022, 1007);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1008, 'divorced', 1022, 1008);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1009, 'widow', 1022, 1009);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1046, 'Ethnicity 1', 1059, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (11, 'Customary(Individual)', 24, 11);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (12, 'Customary(Collective)', 24, 12);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1021, 'Occupant/Owner', 1056, 1021);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1022, 'Administrator', 1056, 1022);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1023, 'Guardian', 1056, 1023);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1024, 'Person of Interest', 1056, 1024);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1025, 'Civic', 1057, 1025);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1026, 'Church', 1057, 1026);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1027, 'Mosque', 1057, 1027);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1028, 'Association (legal)', 1057, 1028);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1029, 'Cooperative', 1057, 1029);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1030, 'Informal Association (non-legal) ', 1057, 1030);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1031, 'Other', 1057, 1031);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1010, 'widower', 1022, 1010);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1011, 'un-married', 1022, 1011);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1012, 'Yes', 1025, 1012);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1013, 'No', 1025, 1013);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1084, 'New Claim', 1148, 1084);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1085, 'Existing Rights', 1148, 1085);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1105, 'Single Tenancy ', 24, 1105);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1106, 'Joint Tenency ', 24, 1106);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1107, 'Common Tenancy ', 24, 1107);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1050, 'male', 1067, 1050);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1051, 'female', 1067, 1051);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1052, 'male', 1119, 1052);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1053, 'female', 1119, 1053);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1054, 'married', 1064, 1054);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1055, 'divorced', 1064, 1055);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1057, 'widower', 1064, 1057);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1058, 'un-married', 1064, 1058);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1059, 'married', 1116, 1059);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1060, 'divorced', 1116, 1060);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1061, 'widow', 1116, 1061);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1062, 'widower', 1116, 1062);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1063, 'un-married', 1116, 1063);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1078, 'Yes', 1071, 1078);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1079, 'No', 1071, 1079);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1080, 'Yes', 1123, 1080);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1081, 'No', 1123, 1081);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1082, 'Natural', 1147, 1082);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1086, 'Unclaimed', 1148, 1086);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1047, 'Ethnicity 2', 1059, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1048, 'Ethnicity 3', 1059, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1108, 'Collective Tenancy ', 24, 1108);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1056, 'widow', 1064, 1056);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1083, 'Non-Natural ', 1147, 1083);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1, 'female', 4, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (4, 'un-married', 22, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (15, 'Derivative Right', 23, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (6, 'divorced', 22, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (7, 'widow', 22, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (5, 'widower', 22, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (13, 'Customary Right of Occupancy', 23, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (14, 'Right of Use', 23, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1110, 'Granted Right of Occupancy', 23, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1114, 'Right to Manage', 23, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1113, 'Right to Ownership ', 23, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (16, 'Agriculture', 16, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (17, 'Settlement', 16, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (18, 'Livestock (intensive/ stationary)', 16, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (19, 'Livestock (pastoralism)', 16, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (20, 'Forest/ Woodlands', 16, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (21, 'Forest Reserve', 16, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (22, 'Grassland', 16, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (23, 'Facility (church/mosque/recreation)', 16, 8);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (24, 'Commercial/Service ', 16, 9);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1089, 'Industrial', 16, 13);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1090, 'Conservation', 16, 14);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1104, 'Conservation', 9, 14);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1091, 'Agriculture', 9, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1092, 'Settlement', 9, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1094, 'Livestock (pastoralism)', 9, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1095, 'Forest/ Woodlands', 9, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1096, 'Forest Reserve', 9, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1097, 'Grassland', 9, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1098, 'Facility (church/mosque/recreation)', 9, 8);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1099, 'Commercial/Service', 9, 9);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1100, 'Wildlife (hunting)', 9, 10);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1101, 'Wildlife (tourism)', 9, 11);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1102, 'Mining', 9, 12);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1103, 'Industrial', 9, 13);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (35, 'Flat/Plain', 37, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (36, 'Mountainous', 37, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (37, 'Valley', 37, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (38, 'Sloping', 37, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1115, 'None', 1134, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1116, 'Primary', 1134, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1032, 'Agriculture', 1058, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1033, 'Settlement', 1058, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1034, 'Livestock (intensive/ stationary)', 1058, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1035, 'Livestock (pastoralism)', 1058, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1036, 'Forest/ Woodlands', 1058, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1037, 'Forest Reserve', 1058, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1038, 'Grassland', 1058, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1039, 'Facility (church/mosque/recreation)', 1058, 8);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1040, 'Commercial/Service', 1058, 9);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1041, 'Wildlife (hunting)', 1058, 10);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1042, 'Wildlife (tourism)', 1058, 11);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1043, 'Mining', 1058, 12);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1044, 'Industrial', 1058, 13);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1045, 'Conservation', 1058, 14);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1049, 'Ethnicity 4', 1059, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1145, 'National', 1107, 1145);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1146, 'Regional', 1107, 1146);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1147, 'District', 1107, 1147);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1148, 'Local ', 1107, 1148);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (2, 'male', 4, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (3, 'married', 22, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1111, 'Formal Ownership (Free-hold) ', 23, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1093, 'Livestock (intensive/ stationary)', 9, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1088, 'Mining', 16, 12);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1117, 'Secondary', 1134, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1118, 'University', 1134, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1151, 'Voter ID', 1152, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1152, 'Driving license', 1152, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1153, 'Passport', 1152, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1154, 'ID card', 1152, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1155, 'Other', 1152, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1156, 'None', 1152, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1158, 'Civic', 1154, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1159, 'Church', 1154, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1160, 'Mosque', 1154, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1161, 'Association (legal)', 1154, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1162, 'Cooperative', 1154, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1163, 'Informal Association (non-legal)', 1154, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1164, 'Other', 1154, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1149, 'Agriculture', 1135, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1150, 'Livestock/Pastoralist', 1135, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1180, 'Small Business', 1135, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1181, 'Skilled Labor (carpentry, masonry, etc)', 1135, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1182, 'Professional/administrative/office', 1135, 5);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1183, 'Public employee', 1135, 6);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1184, 'Homekeeper', 1135, 7);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1185, 'Other', 1135, 8);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1179, 'Disputed Person', 1155, 10);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1178, 'Owner', 1155, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (25, 'Wildlife (hunting)', 16, 10);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1087, 'Wildlife (tourism)', 16, 11);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1186, 'Primary occupant /Point of contact', 1156, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1187, 'Occupant', 1156, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1188, 'Primary occupant /Point of contact', 1158, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1189, 'occupant', 1158, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1190, 'Primary occupant /Point of contact', 1159, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1191, 'occupant', 1159, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1192, 'Primary occupant /Point of contact', 1160, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1193, 'occupant', 1160, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1194, 'Primary occupant /Point of contact', 1161, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1195, 'occupant', 1161, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1196, 'Primary occupant /Point of contact', 1162, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1197, 'occupant', 1162, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1198, 'Primary occupant /Point of contact', 1163, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1199, 'occupant', 1163, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1200, 'Primary occupant /Point of contact', 1164, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1201, 'occupant', 1164, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1202, 'Primary occupant /Point of contact', 1165, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1203, 'occupant', 1165, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (8, 'Country1', 42, 1);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (9, 'Country2', 42, 2);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (10, 'Country3', 42, 3);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1135, 'Country4', 42, 4);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1014, 'Country1', 1023, 1014);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1064, 'Country1', 1069, 1064);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1067, 'Country1', 1121, 1067);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1015, 'Country2', 1023, 1015);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1065, 'Country2', 1069, 1065);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1068, 'Country2', 1121, 1068);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1016, 'Country3', 1023, 1016);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1066, 'Country3', 1069, 1066);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1069, 'Country3', 1121, 1069);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1144, 'Country4', 1121, 1144);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1142, 'Country4', 1023, 1142);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1143, 'Country4', 1069, 1143);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1017, 'Ethnicity1', 1024, 1017);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1074, 'Ethnicity1', 1122, 1074);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1070, 'Ethnicity1', 1070, 1070);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1075, 'Ethnicity2', 1122, 1075);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1018, 'Ethnicity2', 1024, 1018);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1071, 'Ethnicity2', 1070, 1071);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1072, 'Ethnicity3', 1070, 1072);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1076, 'Ethnicity3', 1122, 1076);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1019, 'Ethnicity3', 1024, 1019);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1073, 'Ethnicity4', 1070, 1073);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1077, 'Ethnicity4', 1122, 1077);
INSERT INTO la_ext_attributeoptions (attributeoptionsid, optiontext, attributemasterid, parentid) VALUES (1020, 'Ethnicity4', 1024, 1020);


--
-- Name: la_ext_attributeoptions_attributeoptionsid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_attributeoptions_attributeoptionsid_seq', 1413, true);


--
-- Data for Name: la_ext_baselayer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (1, 'Bing_Aerial', 'Bing_Aerial', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (2, 'Bing_Road', 'Bing_Road', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (3, 'Google_Hybrid', 'Google_Hybrid', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (4, 'Google_Physical', 'Google_Physical', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (5, 'Google_Satellite', 'Google_Satellite', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (6, 'Google_Streets', 'Google_Streets', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (7, 'MapQuest_OSM', 'MapQuest_OSM', true);
INSERT INTO la_ext_baselayer (baselayerid, baselayer, baselayer_en, isactive) VALUES (8, 'Open_Street_Map', 'Open_Street_Map', true);


--
-- Name: la_ext_baselayer_baselayerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_baselayer_baselayerid_seq', 8, true);


--
-- Data for Name: la_ext_bookmark; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_bookmark_bookmarkid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_bookmark_bookmarkid_seq', 1, false);


--
-- Data for Name: la_ext_categorytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_categorytype (categorytypeid, typename, isactive) VALUES (1, 'Parcel', true);
INSERT INTO la_ext_categorytype (categorytypeid, typename, isactive) VALUES (2, 'Resource', true);


--
-- Name: la_ext_categorytype_categorytypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_categorytype_categorytypeid_seq', 2, true);


--
-- Data for Name: la_ext_customattributeoptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (101, 'Cultivated', 7, 101);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (102, 'Non-Cultivated', 7, 102);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (112, 'Average tree height', 6, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (113, 'No of wheather', 6, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (114, 'No of water source', 7, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (115, 'Water source Type', 7, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (116, 'Resource Attribute 1', 9, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (117, 'Resource Attribute 2', 9, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (118, 'Resource Attribute 3', 9, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (119, 'Sub Class Attribute 1', 10, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (120, 'Sub Class Attribute 2', 10, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (121, 'Sub Class Attribute 1', 11, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (122, 'Sub Class Attribute 2', 11, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (123, 'Sub Class Attribute 1', 12, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (124, 'Sub Class Attribute 2', 12, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (125, 'Sub Class Attribute 1', 13, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (126, 'Sub Class Attribute 2', 13, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (127, 'Sub Class Attribute 1', 14, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (128, 'Sub Class Attribute 2', 14, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (129, 'Sub Class Attribute 1', 15, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (130, 'Sub Class Attribute 2', 15, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (133, 'Sub Class Attribute 1', 17, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (134, 'Sub Class Attribute 2', 17, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (135, 'Sub Class Attribute 1', 18, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (136, 'Sub Class Attribute 2', 18, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (137, 'Sub Class Attribute 1', 19, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (138, 'Sub Class Attribute 2', 19, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (139, 'Sub Class Attribute 1', 20, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (140, 'Sub Class Attribute 2', 20, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (141, 'Sub Class Attribute 1', 21, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (142, 'Sub Class Attribute 2', 21, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (149, 'Sub Class Attribute 1', 25, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (150, 'Sub Class Attribute 2', 25, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (151, 'Sub Class Attribute 1', 26, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (152, 'Sub Class Attribute 2', 26, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (153, 'Sub Class Attribute 1', 27, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (154, 'Sub Class Attribute 2', 27, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (155, 'Sub Class Attribute 1', 28, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (156, 'Sub Class Attribute 2', 28, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (157, 'Sub Class Attribute 1', 29, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (158, 'Sub Class Attribute 2', 29, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (159, 'Sub Class Attribute 1', 30, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (160, 'Sub Class Attribute 2', 30, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (161, 'Sub Class Attribute 1', 31, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (162, 'Sub Class Attribute 2', 31, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (163, 'Sub Class Attribute 1', 32, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (164, 'Sub Class Attribute 2', 32, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (165, 'Sub Class Attribute 1', 33, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (166, 'Sub Class Attribute 2', 33, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (167, 'Sub Class Attribute 1', 34, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (168, 'Sub Class Attribute 2', 34, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (169, 'Sub Class Attribute 1', 35, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (170, 'Sub Class Attribute 2', 35, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (171, 'Sub Class Attribute 1', 36, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (172, 'Sub Class Attribute 2', 36, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (175, 'Sub Class Attribute 1', 38, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (176, 'Sub Class Attribute 2', 38, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (177, 'Sub Class Attribute 1', 39, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (178, 'Sub Class Attribute 2', 39, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (179, 'Sub Class Attribute 1', 40, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (180, 'Sub Class Attribute 2', 40, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (181, 'Sub Class Attribute 1', 41, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (182, 'Sub Class Attribute 2', 41, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (185, 'Sub Class Attribute 1', 43, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (186, 'Sub Class Attribute 2', 43, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (187, 'Sub Class Attribute 1', 44, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (188, 'Sub Class Attribute 2', 44, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (189, 'Sub Class Attribute 1', 45, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (190, 'Sub Class Attribute 2', 45, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (191, 'Sub Class Attribute 1', 46, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (192, 'Sub Class Attribute 2', 46, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (193, 'Sub Class Attribute 1', 47, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (194, 'Sub Class Attribute 2', 47, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (195, 'Sub Class Attribute 1', 48, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (196, 'Sub Class Attribute 2', 48, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (197, 'Sub Class Attribute 1', 49, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (198, 'Sub Class Attribute 2', 49, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (199, 'Sub Class Attribute 1', 50, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (200, 'Sub Class Attribute 2', 50, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (201, 'Sub Class Attribute 1', 51, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (202, 'Sub Class Attribute 2', 51, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (203, 'Sub Class Attribute 1', 52, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (204, 'Sub Class Attribute 2', 52, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (205, 'Sub Class Attribute 1', 53, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (206, 'Sub Class Attribute 2', 53, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (207, 'Sub Class Attribute 1', 54, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (208, 'Sub Class Attribute 2', 54, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (209, 'Sub Class Attribute 1', 55, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (210, 'Sub Class Attribute 2', 55, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (211, 'Sub Class Attribute 1', 56, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (212, 'Sub Class Attribute 2', 56, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (213, 'Sub Class Attribute 1', 57, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (214, 'Sub Class Attribute 2', 57, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (215, 'Sub Class Attribute 1', 58, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (216, 'Sub Class Attribute 2', 58, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (217, 'Sub Class Attribute 1', 59, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (218, 'Sub Class Attribute 2', 59, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (219, 'Sub Class Attribute 1', 60, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (220, 'Sub Class Attribute 2', 60, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (221, 'Sub Class Attribute 1', 61, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (222, 'Sub Class Attribute 2', 61, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (223, 'Sub Class Attribute 1', 62, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (224, 'Sub Class Attribute 2', 62, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (225, 'Sub Class Attribute 1', 63, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (103, 'Resource Attribute 1', 2, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (104, 'Resource Attribute 2', 2, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (105, 'Resource Attribute 3', 2, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (110, 'Sub Class Attribute 1', 5, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (111, 'Sub Class Attribute 2', 5, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (226, 'Sub Class Attribute 2', 63, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (227, 'Sub Class Attribute 1', 64, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (228, 'Sub Class Attribute 2', 64, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (229, 'Sub Class Attribute 1', 65, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (230, 'Sub Class Attribute 2', 65, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (231, 'Sub Class Attribute 1', 66, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (232, 'Sub Class Attribute 2', 66, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (233, 'Sub Class Attribute 1', 67, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (234, 'Sub Class Attribute 2', 67, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (235, 'Sub Class Attribute 1', 68, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (236, 'Sub Class Attribute 2', 68, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (237, 'Sub Class Attribute 1', 69, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (238, 'Sub Class Attribute 2', 69, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (239, 'Sub Class Attribute 1', 70, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (240, 'Sub Class Attribute 2', 70, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (241, 'Sub Class Attribute 1', 71, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (242, 'Sub Class Attribute 2', 71, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (243, 'Sub Class Attribute 1', 72, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (244, 'Sub Class Attribute 2', 72, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (245, 'Sub Class Attribute 1', 73, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (246, 'Sub Class Attribute 2', 73, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (247, 'Sub Class Attribute 1', 74, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (248, 'Sub Class Attribute 2', 74, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (249, 'Sub Class Attribute 1', 75, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (250, 'Sub Class Attribute 2', 75, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (251, 'Sub Class Attribute 1', 76, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (252, 'Sub Class Attribute 2', 76, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (253, 'Sub Class Attribute 1', 77, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (254, 'Sub Class Attribute 2', 77, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (255, 'Sub Class Attribute 1', 78, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (256, 'Sub Class Attribute 2', 78, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (257, 'Sub Class Attribute 1', 79, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (258, 'Sub Class Attribute 2', 79, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (259, 'Sub Class Attribute 1', 80, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (260, 'Sub Class Attribute 2', 80, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (261, 'Sub Class Attribute 1', 81, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (262, 'Sub Class Attribute 2', 81, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (263, 'Sub Class Attribute 1', 82, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (264, 'Sub Class Attribute 2', 82, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (265, 'Sub Class Attribute 1', 83, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (266, 'Sub Class Attribute 2', 83, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (267, 'Sub Class Attribute 1', 84, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (268, 'Sub Class Attribute 2', 84, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (269, 'Sub Class Attribute 1', 85, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (270, 'Sub Class Attribute 2', 85, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (271, 'Sub Class Attribute 1', 86, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (272, 'Sub Class Attribute 2', 86, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (273, 'Resource Attribute 1', 87, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (274, 'Resource Attribute 2', 87, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (275, 'Resource Attribute 3', 87, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (276, 'Sub Class Attribute 1', 88, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (277, 'Sub Class Attribute 2', 88, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (278, 'Sub Class Attribute 1', 89, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (279, 'Sub Class Attribute 2', 89, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (280, 'Sub Class Attribute 1', 90, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (281, 'Sub Class Attribute 2', 90, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (282, 'Sub Class Attribute 1', 91, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (283, 'Sub Class Attribute 2', 91, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (284, 'Sub Class Attribute 1', 92, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (285, 'Sub Class Attribute 2', 92, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (286, 'Sub Class Attribute 1', 93, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (287, 'Sub Class Attribute 2', 93, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (288, 'Sub Class Attribute 1', 94, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (289, 'Sub Class Attribute 2', 94, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (290, 'Sub Class Attribute 1', 95, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (291, 'Sub Class Attribute 2', 95, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (292, 'Sub Class Attribute 1', 96, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (293, 'Sub Class Attribute 2', 96, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (294, 'Sub Class Attribute 1', 97, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (295, 'Sub Class Attribute 2', 97, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (296, 'Sub Class Attribute 1', 98, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (297, 'Sub Class Attribute 2', 98, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (298, 'Sub Class Attribute 1', 99, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (299, 'Sub Class Attribute 2', 99, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (300, 'Sub Class Attribute 1', 100, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (301, 'Sub Class Attribute 2', 100, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (302, 'Sub Class Attribute 1', 101, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (303, 'Sub Class Attribute 2', 101, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (304, 'Sub Class Attribute 1', 102, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (305, 'Sub Class Attribute 2', 102, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (306, 'Sub Class Attribute 1', 103, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (307, 'Sub Class Attribute 2', 103, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (308, 'Sub Class Attribute 1', 104, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (309, 'Sub Class Attribute 2', 104, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (310, 'Sub Class Attribute 1', 105, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (311, 'Sub Class Attribute 2', 105, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (312, 'Sub Class Attribute 1', 106, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (313, 'Sub Class Attribute 2', 106, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (314, 'Sub Class Attribute 1', 107, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (315, 'Sub Class Attribute 2', 107, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (316, 'Sub Class Attribute 1', 108, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (317, 'Sub Class Attribute 2', 108, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (318, 'Sub Class Attribute 1', 109, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (319, 'Sub Class Attribute 2', 109, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (320, 'Sub Class Attribute 1', 110, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (321, 'Sub Class Attribute 2', 110, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (322, 'Sub Class Attribute 1', 111, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (323, 'Sub Class Attribute 2', 111, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (324, 'Sub Class Attribute 1', 112, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (325, 'Sub Class Attribute 2', 112, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (326, 'Sub Class Attribute 1', 113, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (327, 'Sub Class Attribute 2', 113, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (328, 'Sub Class Attribute 1', 114, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (329, 'Sub Class Attribute 2', 114, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (330, 'Sub Class Attribute 1', 115, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (331, 'Sub Class Attribute 2', 115, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (332, 'Sub Class Attribute 1', 116, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (333, 'Sub Class Attribute 2', 116, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (334, 'Sub Class Attribute 1', 117, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (335, 'Sub Class Attribute 2', 117, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (336, 'Sub Class Attribute 1', 118, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (337, 'Sub Class Attribute 2', 118, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (338, 'Sub Class Attribute 1', 119, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (339, 'Sub Class Attribute 2', 119, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (340, 'Sub Class Attribute 1', 120, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (341, 'Sub Class Attribute 2', 120, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (342, 'Sub Class Attribute 1', 121, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (343, 'Sub Class Attribute 2', 121, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (344, 'Sub Class Attribute 1', 122, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (345, 'Sub Class Attribute 2', 122, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (346, 'Sub Class Attribute 1', 123, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (347, 'Sub Class Attribute 2', 123, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (348, 'Sub Class Attribute 1', 124, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (349, 'Sub Class Attribute 2', 124, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (350, 'Sub Class Attribute 1', 125, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (351, 'Sub Class Attribute 2', 125, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (352, 'Sub Class Attribute 1', 126, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (353, 'Sub Class Attribute 2', 126, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (354, 'Sub Class Attribute 1', 127, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (355, 'Sub Class Attribute 2', 127, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (356, 'Resource Attribute 1', 128, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (357, 'Resource Attribute 2', 128, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (358, 'Resource Attribute 3', 128, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (359, 'Sub Class Attribute 1', 129, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (360, 'Sub Class Attribute 2', 129, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (361, 'Sub Class Attribute 1', 130, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (362, 'Sub Class Attribute 2', 130, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (363, 'Sub Class Attribute 1', 131, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (364, 'Sub Class Attribute 2', 131, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (365, 'Sub Class Attribute 1', 132, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (366, 'Sub Class Attribute 2', 132, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (367, 'Sub Class Attribute 1', 133, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (368, 'Sub Class Attribute 2', 133, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (369, 'Sub Class Attribute 1', 134, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (370, 'Sub Class Attribute 2', 134, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (371, 'Sub Class Attribute 1', 135, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (372, 'Sub Class Attribute 2', 135, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (373, 'Sub Class Attribute 1', 136, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (374, 'Sub Class Attribute 2', 136, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (375, 'Sub Class Attribute 1', 137, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (376, 'Sub Class Attribute 2', 137, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (377, 'Sub Class Attribute 1', 138, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (378, 'Sub Class Attribute 2', 138, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (379, 'Sub Class Attribute 1', 139, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (380, 'Sub Class Attribute 2', 139, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (381, 'Sub Class Attribute 1', 140, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (382, 'Sub Class Attribute 2', 140, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (383, 'Sub Class Attribute 1', 141, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (384, 'Sub Class Attribute 2', 141, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (385, 'Sub Class Attribute 1', 142, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (386, 'Sub Class Attribute 2', 142, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (387, 'Sub Class Attribute 1', 143, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (388, 'Sub Class Attribute 2', 143, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (389, 'Sub Class Attribute 1', 144, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (390, 'Sub Class Attribute 2', 144, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (391, 'Sub Class Attribute 1', 145, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (392, 'Sub Class Attribute 2', 145, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (393, 'Sub Class Attribute 1', 146, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (394, 'Sub Class Attribute 2', 146, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (395, 'Sub Class Attribute 1', 147, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (396, 'Sub Class Attribute 2', 147, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (397, 'Sub Class Attribute 1', 148, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (398, 'Sub Class Attribute 2', 148, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (399, 'Sub Class Attribute 1', 149, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (400, 'Sub Class Attribute 2', 149, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (401, 'Sub Class Attribute 1', 150, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (402, 'Sub Class Attribute 2', 150, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (403, 'Sub Class Attribute 1', 151, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (404, 'Sub Class Attribute 2', 151, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (405, 'Sub Class Attribute 2', 152, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (406, 'Sub Class Attribute 1', 153, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (407, 'Sub Class Attribute 2', 153, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (408, 'Sub Class Attribute 1', 154, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (409, 'Sub Class Attribute 2', 154, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (410, 'Sub Class Attribute 1', 155, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (411, 'Sub Class Attribute 2', 155, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (412, 'Sub Class Attribute 1', 156, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (413, 'Sub Class Attribute 2', 156, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (414, 'Sub Class Attribute 1', 157, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (415, 'Sub Class Attribute 2', 157, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (416, 'Sub Class Attribute 1', 158, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (417, 'Sub Class Attribute 2', 158, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (418, 'Sub Class Attribute 1', 159, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (419, 'Sub Class Attribute 2', 159, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (420, 'Sub Class Attribute 1', 160, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (421, 'Sub Class Attribute 2', 160, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (422, 'Sub Class Attribute 1', 161, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (423, 'Sub Class Attribute 2', 161, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (424, 'Sub Class Attribute 1', 162, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (425, 'Sub Class Attribute 2', 162, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (426, 'Sub Class Attribute 1', 163, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (427, 'Sub Class Attribute 2', 163, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (428, 'Sub Class Attribute 1', 164, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (429, 'Sub Class Attribute 2', 164, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (430, 'Sub Class Attribute 1', 165, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (431, 'Sub Class Attribute 2', 165, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (432, 'Sub Class Attribute 1', 166, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (433, 'Sub Class Attribute 2', 166, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (434, 'Sub Class Attribute 1', 167, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (435, 'Sub Class Attribute 2', 167, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (436, 'Sub Class Attribute 1', 168, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (437, 'Sub Class Attribute 2', 168, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (438, 'Sub Class Attribute 1', 152, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (439, 'Resource Attribute 1', 169, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (440, 'Resource Attribute 2', 169, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (441, 'Resource Attribute 3', 169, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (442, 'Sub Class Attribute 1', 170, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (443, 'Sub Class Attribute 2', 170, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (444, 'Sub Class Attribute 1', 171, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (445, 'Sub Class Attribute 2', 171, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (446, 'Sub Class Attribute 1', 172, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (447, 'Sub Class Attribute 2', 172, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (448, 'Sub Class Attribute 1', 173, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (449, 'Sub Class Attribute 2', 173, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (450, 'Sub Class Attribute 1', 174, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (451, 'Sub Class Attribute 2', 174, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (452, 'Sub Class Attribute 1', 175, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (453, 'Sub Class Attribute 2', 175, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (454, 'Sub Class Attribute 1', 176, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (455, 'Sub Class Attribute 2', 176, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (456, 'Sub Class Attribute 1', 177, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (457, 'Sub Class Attribute 2', 177, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (458, 'Sub Class Attribute 1', 178, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (459, 'Sub Class Attribute 2', 178, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (460, 'Sub Class Attribute 1', 179, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (461, 'Sub Class Attribute 2', 179, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (462, 'Sub Class Attribute 1', 170, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (463, 'Sub Class Attribute 2', 170, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (464, 'Sub Class Attribute 1', 171, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (465, 'Sub Class Attribute 2', 171, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (466, 'Sub Class Attribute 1', 172, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (467, 'Sub Class Attribute 2', 172, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (468, 'Sub Class Attribute 1', 173, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (469, 'Sub Class Attribute 2', 173, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (470, 'Sub Class Attribute 1', 174, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (471, 'Sub Class Attribute 2', 174, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (472, 'Sub Class Attribute 1', 175, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (473, 'Sub Class Attribute 2', 175, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (474, 'Sub Class Attribute 1', 176, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (475, 'Sub Class Attribute 2', 176, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (476, 'Sub Class Attribute 1', 177, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (477, 'Sub Class Attribute 2', 177, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (478, 'Sub Class Attribute 1', 178, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (479, 'Sub Class Attribute 2', 178, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (480, 'Sub Class Attribute 1', 179, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (481, 'Sub Class Attribute 2', 179, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (482, 'Sub Class Attribute 1', 180, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (483, 'Sub Class Attribute 2', 180, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (484, 'Sub Class Attribute 1', 181, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (485, 'Sub Class Attribute 2', 181, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (486, 'Sub Class Attribute 2', 182, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (487, 'Sub Class Attribute 1', 182, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (488, 'Sub Class Attribute 1', 183, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (489, 'Sub Class Attribute 2', 183, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (490, 'Sub Class Attribute 1', 184, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (491, 'Sub Class Attribute 2', 184, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (492, 'Sub Class Attribute 1', 185, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (493, 'Sub Class Attribute 2', 185, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (494, 'Sub Class Attribute 1', 186, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (495, 'Sub Class Attribute 2', 186, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (496, 'Sub Class Attribute 1', 187, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (497, 'Sub Class Attribute 2', 187, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (498, 'Sub Class Attribute 1', 188, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (499, 'Sub Class Attribute 2', 188, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (500, 'Sub Class Attribute 1', 189, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (501, 'Sub Class Attribute 2', 189, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (502, 'Sub Class Attribute 1', 190, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (503, 'Sub Class Attribute 2', 190, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (504, 'Sub Class Attribute 1', 191, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (505, 'Sub Class Attribute 2', 191, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (506, 'Sub Class Attribute 1', 192, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (507, 'Sub Class Attribute 2', 192, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (508, 'Sub Class Attribute 1', 193, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (509, 'Sub Class Attribute 2', 193, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (510, 'Sub Class Attribute 1', 194, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (511, 'Sub Class Attribute 2', 194, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (512, 'Sub Class Attribute 1', 195, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (513, 'Sub Class Attribute 2', 195, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (514, 'Sub Class Attribute 1', 196, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (515, 'Sub Class Attribute 2', 196, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (516, 'Sub Class Attribute 1', 197, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (517, 'Sub Class Attribute 2', 197, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (518, 'Sub Class Attribute 1', 198, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (519, 'Sub Class Attribute 2', 198, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (520, 'Sub Class Attribute 1', 199, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (521, 'Sub Class Attribute 2', 199, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (522, 'Sub Class Attribute 1', 200, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (523, 'Sub Class Attribute 2', 200, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (524, 'Sub Class Attribute 1', 201, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (525, 'Sub Class Attribute 2', 201, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (526, 'Sub Class Attribute 2', 202, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (527, 'Sub Class Attribute 1', 202, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (528, 'Sub Class Attribute 1', 203, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (529, 'Sub Class Attribute 2', 203, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (530, 'Sub Class Attribute 1', 204, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (531, 'Sub Class Attribute 2', 204, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (532, 'Sub Class Attribute 1', 205, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (533, 'Sub Class Attribute 2', 205, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (534, 'Sub Class Attribute 1', 206, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (535, 'Sub Class Attribute 2', 206, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (536, 'Sub Class Attribute 1', 207, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (537, 'Sub Class Attribute 2', 207, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (538, 'Sub Class Attribute 1', 208, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (539, 'Sub Class Attribute 2', 208, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (540, 'Sub Class Attribute 1', 209, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (541, 'Sub Class Attribute 2', 209, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (542, 'Resource Attribute 1', 210, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (543, 'Resource Attribute 2', 210, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (544, 'Resource Attribute 3', 210, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (545, 'Sub Class Attribute 1', 211, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (546, 'Sub Class Attribute 2', 211, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (547, 'Sub Class Attribute 1', 212, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (548, 'Sub Class Attribute 2', 212, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (549, 'Sub Class Attribute 1', 213, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (550, 'Sub Class Attribute 2', 213, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (551, 'Sub Class Attribute 1', 214, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (552, 'Sub Class Attribute 2', 214, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (553, 'Sub Class Attribute 1', 215, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (554, 'Sub Class Attribute 2', 215, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (555, 'Sub Class Attribute 1', 216, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (556, 'Sub Class Attribute 2', 216, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (557, 'Sub Class Attribute 1', 217, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (558, 'Sub Class Attribute 2', 217, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (559, 'Sub Class Attribute 1', 218, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (560, 'Sub Class Attribute 2', 218, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (561, 'Sub Class Attribute 1', 219, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (562, 'Sub Class Attribute 2', 219, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (563, 'Sub Class Attribute 1', 220, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (564, 'Sub Class Attribute 2', 220, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (565, 'Sub Class Attribute 1', 221, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (566, 'Sub Class Attribute 2', 221, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (567, 'Sub Class Attribute 1', 222, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (568, 'Sub Class Attribute 2', 222, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (569, 'Sub Class Attribute 1', 223, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (570, 'Sub Class Attribute 2', 223, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (571, 'Sub Class Attribute 1', 224, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (572, 'Sub Class Attribute 2', 224, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (573, 'Sub Class Attribute 1', 225, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (574, 'Sub Class Attribute 2', 225, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (575, 'Sub Class Attribute 1', 226, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (576, 'Sub Class Attribute 2', 226, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (577, 'Sub Class Attribute 1', 227, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (578, 'Sub Class Attribute 2', 227, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (579, 'Sub Class Attribute 1', 228, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (580, 'Sub Class Attribute 2', 228, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (581, 'Sub Class Attribute 1', 229, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (582, 'Sub Class Attribute 2', 229, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (583, 'Sub Class Attribute 1', 230, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (584, 'Sub Class Attribute 2', 230, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (585, 'Sub Class Attribute 1', 231, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (586, 'Sub Class Attribute 2', 231, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (587, 'Sub Class Attribute 1', 232, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (588, 'Sub Class Attribute 2', 232, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (589, 'Sub Class Attribute 1', 233, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (590, 'Sub Class Attribute 2', 233, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (591, 'Sub Class Attribute 1', 234, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (592, 'Sub Class Attribute 2', 234, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (593, 'Sub Class Attribute 1', 235, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (594, 'Sub Class Attribute 2', 235, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (595, 'Sub Class Attribute 1', 236, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (596, 'Sub Class Attribute 2', 236, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (597, 'Sub Class Attribute 1', 237, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (598, 'Sub Class Attribute 2', 237, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (599, 'Sub Class Attribute 1', 238, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (600, 'Sub Class Attribute 2', 238, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (601, 'Sub Class Attribute 1', 239, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (602, 'Sub Class Attribute 2', 239, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (603, 'Sub Class Attribute 1', 240, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (604, 'Sub Class Attribute 2', 240, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (605, 'Sub Class Attribute 1', 241, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (606, 'Sub Class Attribute 2', 241, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (607, 'Sub Class Attribute 1', 242, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (608, 'Sub Class Attribute 2', 242, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (609, 'Sub Class Attribute 1', 243, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (610, 'Sub Class Attribute 2', 243, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (611, 'Sub Class Attribute 1', 244, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (612, 'Sub Class Attribute 2', 244, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (613, 'Sub Class Attribute 1', 245, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (614, 'Sub Class Attribute 2', 245, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (615, 'Sub Class Attribute 1', 246, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (616, 'Sub Class Attribute 2', 246, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (617, 'Sub Class Attribute 1', 247, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (618, 'Sub Class Attribute 2', 247, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (619, 'Sub Class Attribute 1', 248, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (620, 'Sub Class Attribute 2', 248, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (621, 'Sub Class Attribute 1', 249, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (622, 'Sub Class Attribute 2', 249, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (623, 'Sub Class Attribute 1', 250, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (624, 'Sub Class Attribute 2', 250, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (625, 'Resource Attribute 1', 251, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (626, 'Resource Attribute 2', 251, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (627, 'Resource Attribute 3', 251, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (628, 'Sub Class Attribute 1', 252, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (629, 'Sub Class Attribute 2', 252, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (630, 'Sub Class Attribute 1', 253, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (631, 'Sub Class Attribute 2', 253, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (632, 'Sub Class Attribute 1', 254, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (633, 'Sub Class Attribute 2', 254, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (634, 'Sub Class Attribute 1', 255, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (635, 'Sub Class Attribute 2', 255, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (636, 'Sub Class Attribute 1', 256, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (637, 'Sub Class Attribute 2', 256, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (638, 'Sub Class Attribute 1', 257, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (639, 'Sub Class Attribute 2', 257, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (640, 'Sub Class Attribute 1', 258, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (641, 'Sub Class Attribute 2', 258, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (642, 'Sub Class Attribute 1', 259, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (643, 'Sub Class Attribute 2', 259, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (644, 'Sub Class Attribute 1', 260, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (645, 'Sub Class Attribute 2', 260, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (646, 'Sub Class Attribute 1', 261, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (647, 'Sub Class Attribute 2', 261, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (648, 'Sub Class Attribute 1', 262, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (649, 'Sub Class Attribute 2', 262, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (650, 'Sub Class Attribute 1', 263, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (651, 'Sub Class Attribute 2', 263, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (652, 'Sub Class Attribute 1', 264, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (653, 'Sub Class Attribute 2', 264, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (654, 'Sub Class Attribute 1', 265, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (655, 'Sub Class Attribute 2', 265, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (656, 'Sub Class Attribute 1', 266, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (657, 'Sub Class Attribute 2', 266, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (658, 'Sub Class Attribute 1', 267, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (659, 'Sub Class Attribute 2', 267, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (660, 'Sub Class Attribute 1', 268, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (661, 'Sub Class Attribute 2', 268, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (662, 'Sub Class Attribute 1', 269, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (663, 'Sub Class Attribute 2', 269, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (664, 'Sub Class Attribute 1', 270, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (665, 'Sub Class Attribute 2', 270, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (666, 'Sub Class Attribute 1', 271, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (667, 'Sub Class Attribute 2', 271, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (668, 'Sub Class Attribute 1', 272, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (669, 'Sub Class Attribute 2', 272, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (670, 'Sub Class Attribute 1', 273, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (671, 'Sub Class Attribute 2', 273, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (672, 'Sub Class Attribute 1', 274, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (673, 'Sub Class Attribute 2', 274, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (674, 'Sub Class Attribute 1', 275, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (675, 'Sub Class Attribute 2', 275, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (676, 'Sub Class Attribute 1', 276, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (677, 'Sub Class Attribute 2', 276, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (678, 'Sub Class Attribute 1', 277, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (679, 'Sub Class Attribute 2', 277, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (680, 'Sub Class Attribute 1', 278, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (681, 'Sub Class Attribute 2', 278, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (682, 'Sub Class Attribute 1', 279, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (683, 'Sub Class Attribute 2', 279, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (684, 'Sub Class Attribute 1', 280, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (685, 'Sub Class Attribute 2', 280, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (686, 'Sub Class Attribute 1', 281, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (687, 'Sub Class Attribute 2', 281, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (688, 'Sub Class Attribute 1', 282, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (689, 'Sub Class Attribute 2', 282, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (690, 'Sub Class Attribute 1', 283, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (691, 'Sub Class Attribute 2', 283, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (692, 'Sub Class Attribute 1', 284, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (693, 'Sub Class Attribute 2', 284, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (694, 'Sub Class Attribute 1', 285, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (695, 'Sub Class Attribute 2', 285, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (696, 'Sub Class Attribute 1', 286, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (697, 'Sub Class Attribute 2', 286, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (698, 'Sub Class Attribute 1', 287, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (699, 'Sub Class Attribute 2', 287, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (700, 'Sub Class Attribute 1', 288, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (701, 'Sub Class Attribute 2', 288, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (702, 'Sub Class Attribute 1', 289, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (703, 'Sub Class Attribute 2', 289, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (704, 'Sub Class Attribute 1', 290, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (705, 'Sub Class Attribute 2', 290, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (706, 'Sub Class Attribute 1', 291, 2);
INSERT INTO la_ext_customattributeoptions (attributeoptionsid, optiontext, customattributeid, parentid) VALUES (707, 'Sub Class Attribute 2', 291, 2);


--
-- Name: la_ext_customattributeoptionsid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_customattributeoptionsid_seq', 707, true);


--
-- Data for Name: la_ext_dispute; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_dispute_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_dispute_seq', 1, false);


--
-- Data for Name: la_ext_disputelandmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_disputelandmapping_disputelandid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_disputelandmapping_disputelandid_seq', 1, false);


--
-- Data for Name: la_ext_disputestatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_disputestatus (disputestatusid, disputestatus, disputestatus_en, isactive) VALUES (1, 'Active', 'Active', true);
INSERT INTO la_ext_disputestatus (disputestatusid, disputestatus, disputestatus_en, isactive) VALUES (2, 'Resolved', 'Resolved', true);


--
-- Name: la_ext_disputestatus_disputestatusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_disputestatus_disputestatusid_seq', 2, true);


--
-- Data for Name: la_ext_disputetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_disputetype (disputetypeid, disputetype, disputetype_en, isactive) VALUES (1, 'Boundary', 'Boundary', true);
INSERT INTO la_ext_disputetype (disputetypeid, disputetype, disputetype_en, isactive) VALUES (2, 'Counter claim (Inter family)', 'Counter claim (Inter family)', true);
INSERT INTO la_ext_disputetype (disputetypeid, disputetype, disputetype_en, isactive) VALUES (3, 'Counter claim (Intra family)', 'Counter claim (Intra family)', true);
INSERT INTO la_ext_disputetype (disputetypeid, disputetype, disputetype_en, isactive) VALUES (4, 'Counter claim (Others)', 'Counter claim (Others)', true);
INSERT INTO la_ext_disputetype (disputetypeid, disputetype, disputetype_en, isactive) VALUES (5, 'Other interests', 'Other interests', true);


--
-- Name: la_ext_disputetype_disputetypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_disputetype_disputetypeid_seq', 5, true);


--
-- Data for Name: la_ext_documentdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_documentdetails_documentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_documentdetails_documentid_seq', 1, false);


--
-- Data for Name: la_ext_documentformat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_documentformat (documentformatid, documentformat, documentformat_en, isactive) VALUES (1, 'image/gif', 'image/gif', true);
INSERT INTO la_ext_documentformat (documentformatid, documentformat, documentformat_en, isactive) VALUES (3, 'image/png', 'image/png', true);
INSERT INTO la_ext_documentformat (documentformatid, documentformat, documentformat_en, isactive) VALUES (2, 'Image/jpg', 'Image/jpg', true);
INSERT INTO la_ext_documentformat (documentformatid, documentformat, documentformat_en, isactive) VALUES (4, 'Video/mp4', 'Video/mp4', true);


--
-- Name: la_ext_documentformat_documentformatid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_documentformat_documentformatid_seq', 4, true);


--
-- Data for Name: la_ext_documenttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (5, 'Other', 'Other', true, 1);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (7, 'Other', 'Other', true, 3);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (8, 'Other', 'Other', true, 4);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (10, 'Application Letter', 'Application Letter ', true, 6);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (9, 'Application Letter', 'Application Letter ', true, 5);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (11, 'Application Letter ', 'Application Letter ', true, 4);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (1, 'Informal Receipt of Sale', 'Informal Receipt of Sale', true, 2);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (2, 'Formal Receipt of Sale', 'Formal Receipt of Sale', true, 2);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (3, 'Letter of Allocation', 'Letter of Allocation', true, 1);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (4, 'Probate Document', 'Probate Document', true, 3);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (6, 'Other', 'Other', true, 6);
INSERT INTO la_ext_documenttype (documenttypeid, documenttype, documenttype_en, isactive, processid) VALUES (12, 'Application Letter', 'Application Letter ', true, 7);


--
-- Name: la_ext_documenttype_documenttypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_documenttype_documenttypeid_seq', 13, true);


--
-- Data for Name: la_ext_existingclaim_documentdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_existingclaim_documentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_existingclaim_documentid_seq', 1, false);


--
-- Data for Name: la_ext_financialagency; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_financialagency (financialagencyid, financialagency, financialagency_en, isactive) VALUES (1, 'Bank', 'Bank', true);
INSERT INTO la_ext_financialagency (financialagencyid, financialagency, financialagency_en, isactive) VALUES (2, 'Rural Finance Institution', 'Rural Finance Institution', true);
INSERT INTO la_ext_financialagency (financialagencyid, financialagency, financialagency_en, isactive) VALUES (3, 'Mirco-Finance', 'Mirco-Finance', true);


--
-- Name: la_ext_financialagency_financialagencyid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_financialagency_financialagencyid_seq', 3, true);


--
-- Data for Name: la_ext_geometrytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_geometrytype (geometrytypeid, geometryname, isactive) VALUES (1, 'Point', true);
INSERT INTO la_ext_geometrytype (geometrytypeid, geometryname, isactive) VALUES (2, 'Line', true);
INSERT INTO la_ext_geometrytype (geometrytypeid, geometryname, isactive) VALUES (3, 'Polygon', true);


--
-- Name: la_ext_geometrytype_geometryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_geometrytype_geometryid_seq', 3, true);


--
-- Data for Name: la_ext_grouptype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (1, 'Civic', 'Civic', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (2, 'Mosque', 'Mosque', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (4, 'Cooperative', 'Cooperative', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (6, 'Other', 'Other', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (7, 'Church', 'Church', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (3, 'Association (legal)', 'Association (legal)', true);
INSERT INTO la_ext_grouptype (grouptypeid, grouptype, grouptype_en, isactive) VALUES (5, 'Informal Association (non-legal)', 'Informal Association (non-legal)', true);


--
-- Name: la_ext_grouptype_grouptypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_grouptype_grouptypeid_seq', 7, true);


--
-- Data for Name: la_ext_landapplicationstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_landapplicationstatus_landapplicationstatusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_landapplicationstatus_landapplicationstatusid_seq', 1, false);


--
-- Data for Name: la_ext_landworkflowhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_landworkflowhistory_landworkflowhistoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_landworkflowhistory_landworkflowhistoryid_seq', 1, false);


--
-- Data for Name: la_ext_layer_layergroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_layer_layergroup (layer_layergroupid, layerid, layergroupid, layerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (275, 31, 81, 1, true, 1, '2018-04-10 17:55:10.229', 1, '2018-04-10 17:55:10.229');
INSERT INTO la_ext_layer_layergroup (layer_layergroupid, layerid, layergroupid, layerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (276, 34, 81, 2, true, 1, '2018-04-10 17:55:10.251', 1, '2018-04-10 17:55:10.251');
INSERT INTO la_ext_layer_layergroup (layer_layergroupid, layerid, layergroupid, layerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (277, 35, 81, 3, true, 1, '2018-04-10 17:55:10.289', 1, '2018-04-10 17:55:10.289');
INSERT INTO la_ext_layer_layergroup (layer_layergroupid, layerid, layergroupid, layerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (278, 36, 81, 4, true, 1, '2018-04-10 17:55:10.332', 1, '2018-04-10 17:55:10.332');
INSERT INTO la_ext_layer_layergroup (layer_layergroupid, layerid, layergroupid, layerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (279, 33, 81, 5, true, 1, '2018-04-10 17:55:10.371', 1, '2018-04-10 17:55:10.371');


--
-- Name: la_ext_layer_layergroup_layer_layergroupid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_layer_layergroup_layer_layergroupid_seq', 282, true);


--
-- Data for Name: la_ext_layerfield; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (339, 34, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (340, 34, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (341, 34, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (342, 34, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (343, 34, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (344, 34, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (345, 34, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (346, 34, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (347, 34, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (348, 34, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (349, 34, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (350, 34, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (351, 34, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (352, 34, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (353, 34, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (354, 34, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (355, 34, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (356, 34, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (357, 34, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (358, 34, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (359, 34, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (360, 34, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (361, 34, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (362, 34, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (363, 34, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (364, 34, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (365, 34, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (366, 34, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (367, 34, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (368, 34, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (369, 34, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (370, 34, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (371, 34, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (372, 34, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (373, 34, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (374, 34, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (375, 34, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (376, 34, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (415, 36, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (416, 36, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (417, 36, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (418, 36, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (419, 36, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (420, 36, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (421, 36, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (422, 36, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (423, 36, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (424, 36, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (425, 36, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (426, 36, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (427, 36, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (428, 36, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (429, 36, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (430, 36, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (431, 36, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (432, 36, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (433, 36, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (434, 36, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (435, 36, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (436, 36, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (437, 36, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (438, 36, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (439, 36, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (440, 36, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (441, 36, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (442, 36, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (443, 36, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (444, 36, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (445, 36, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (446, 36, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (447, 36, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (448, 36, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (449, 36, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (450, 36, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (451, 36, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (452, 36, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (294, 31, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (295, 31, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (296, 31, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (297, 31, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (298, 31, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (299, 31, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (300, 31, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (301, 31, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (302, 31, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (303, 31, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (304, 31, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (305, 31, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (306, 31, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (307, 31, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (308, 31, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (309, 31, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (310, 31, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (311, 31, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (312, 31, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (313, 31, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (314, 31, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (315, 31, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (316, 31, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (317, 31, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (318, 31, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (319, 31, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (320, 31, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (321, 31, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (322, 31, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (323, 31, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (324, 31, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (325, 31, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (326, 31, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (327, 31, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (328, 31, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (329, 31, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (377, 35, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (378, 35, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (379, 35, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (380, 35, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (381, 35, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (382, 35, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (383, 35, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (384, 35, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (385, 35, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (386, 35, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (387, 35, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (388, 35, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (389, 35, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (390, 35, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (391, 35, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (392, 35, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (393, 35, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (394, 35, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (395, 35, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (396, 35, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (397, 35, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (398, 35, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (399, 35, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (400, 35, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (401, 35, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (402, 35, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (403, 35, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (404, 35, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (405, 35, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (406, 35, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (407, 35, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (408, 35, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (409, 35, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (410, 35, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (411, 35, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (412, 35, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (413, 35, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (414, 35, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (490, 33, 'createddate', 'createddate', 'aoiid', true, 'createddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (491, 33, 'aoiid', 'aoiid', 'aoiid', true, 'aoiid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (492, 33, 'applicationstatusid', 'applicationstatusid', 'aoiid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (493, 33, 'modifieddate', 'modifieddate', 'aoiid', true, 'modifieddate');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (494, 33, 'createdby', 'createdby', 'aoiid', true, 'createdby');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (495, 33, 'isactive', 'isactive', 'aoiid', true, 'isactive');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (496, 33, 'userid', 'userid', 'aoiid', true, 'userid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (497, 33, 'projectnameid', 'projectnameid', 'aoiid', true, 'projectnameid');
INSERT INTO la_ext_layerfield (layerfieldid, layerid, layerfield, layerfield_en, keyfield, isactive, alias) VALUES (498, 33, 'modifiedby', 'modifiedby', 'aoiid', true, 'modifiedby');


--
-- Name: la_ext_layerfield_layerfieldid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_layerfield_layerfieldid_seq', 498, true);


--
-- Data for Name: la_ext_layergroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_layergroup (layergroupid, layergroupname, remarks, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (81, 'projectLayerGroup', 'projectLayerGroup', true, 1, '2018-04-10 17:55:10.195', 1, '2018-04-10 17:55:10.195');


--
-- Name: la_ext_layergroup_layergroupid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_layergroup_layergroupid_seq', 81, true);


--
-- Data for Name: la_ext_layertype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_layertype (layertypeid, layertype, layertype_en, isactive) VALUES (1, 'WFS', 'WFS ', true);
INSERT INTO la_ext_layertype (layertypeid, layertype, layertype_en, isactive) VALUES (2, 'WMS', 'WMS ', true);


--
-- Name: la_ext_layertype_layertypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_layertype_layertypeid_seq', 2, true);


--
-- Data for Name: la_ext_module; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (1, 'bookmark', 'bookmark', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (2, 'clear_selection', 'clear_selection', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (3, 'complaint', 'complaint', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (4, 'dynalayer', 'dynalayer', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (5, 'editing', 'editing', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (6, 'export', 'export', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (7, 'fileupload', 'fileupload', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (8, 'fixedzoomin', 'fixedzoomin', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (9, 'fixedzoomout', 'fixedzoomout', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (10, 'fullview', 'fullview', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (11, 'geoprocessing', 'geoprocessing', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (12, 'importdata', 'importdata', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (13, 'info', 'info', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (14, 'intersection', 'intersection', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (15, 'magnetic', 'magnetic', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (16, 'markup', 'markup', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (17, 'measurelength', 'measurelength', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (18, 'openproject', 'openproject', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (19, 'pan', 'pan', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (20, 'print', 'print', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (21, 'query', 'query', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (22, 'radiometric', 'radiometric', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (23, 'report', 'report', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (24, 'saveproject', 'saveproject', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (25, 'search', 'search', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (26, 'selectbox', 'selectbox', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (27, 'selectfeature', 'selectfeature', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (28, 'selectpolygon', 'selectpolygon', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (29, 'textstyle', 'textstyle', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (30, 'thematic', 'thematic', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (31, 'zoomin', 'zoomin', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (32, 'zoomnext', 'zoomnext', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (33, 'zoomout', 'zoomout', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (34, 'zoomprevious', 'zoomprevious', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (35, 'zoomtolayer', 'zoomtolayer', '1', true);
INSERT INTO la_ext_module (moduleid, modulename, modulename_en, description, isactive) VALUES (36, 'zoomtoxy', 'zoomtoxy', '1', true);


--
-- Name: la_ext_module_moduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_module_moduleid_seq', 37, true);


--
-- Data for Name: la_ext_month; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_month (monthid, month, isactive) VALUES (11, '10', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (12, '11', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (1, '0', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (2, '1', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (3, '2', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (4, '3', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (5, '4', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (6, '5', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (7, '6', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (8, '7', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (9, '8', true);
INSERT INTO la_ext_month (monthid, month, isactive) VALUES (10, '9', true);


--
-- Name: la_ext_month_monthid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_month_monthid_seq', 1, false);


--
-- Data for Name: la_ext_parcelsplitland; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_parcelsplitland_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_parcelsplitland_seq', 1, false);


--
-- Data for Name: la_ext_personlandmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_personlandmapping_personlandid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_personlandmapping_personlandid_seq', 1, false);


--
-- Data for Name: la_ext_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (1, 'Lease', 'Lease', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (2, 'Sale', 'Sale', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (3, 'Mortgage', 'Mortgage', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (5, 'Surrender of Lease', 'Surrender of Lease', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (6, 'Gift/Inheritance', 'Gift/Inheritance', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (4, 'Change of Ownership', 'Change of Ownership', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (8, 'Parcel Split', 'Parcel Split', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (9, 'Surrender of Mortgage', 'Surrender of Mortgage', true);
INSERT INTO la_ext_process (processid, processname, processname_en, isactive) VALUES (7, 'Change of Joint Owner', 'Change of Joint Owner', false);


--
-- Name: la_ext_process_processid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_process_processid_seq', 7, true);


--
-- Data for Name: la_ext_projectadjudicator; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_projectadjudicator_projectadjudicatorid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projectadjudicator_projectadjudicatorid_seq', 1, false);


--
-- Data for Name: la_ext_projectarea; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_projectarea (projectareaid, projectnameid, spatialunitgroupid1, hierarchyid1, spatialunitgroupid2, hierarchyid2, spatialunitgroupid3, hierarchyid3, spatialunitgroupid4, hierarchyid4, spatialunitgroupid5, hierarchyid5, spatialunitgroupid6, hierarchyid6, initiationdate, description, vc_meetingdate, postalcode, authorizedmember, authorizedmembersignature, landofficer, landofficersignature, executiveofficer, executiveofficersignature, certificatenumber, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (104, 2, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, NULL, NULL, NULL, NULL, NULL, '', '', NULL, '', NULL, '', NULL, '', true, 1, '2018-04-10 17:04:15.231', 1, '2018-04-10 17:04:15.231');


--
-- Name: la_ext_projectarea_projectareaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projectarea_projectareaid_seq', 104, true);


--
-- Data for Name: la_ext_projectbaselayermapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_projectbaselayermapping (projectbaselayerid, baselayerid, projectnameid, baselayerorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (102, 5, 2, NULL, true, 1, '2018-04-10 00:00:00', NULL, NULL);


--
-- Name: la_ext_projectbaselayermapping_projectbaselayerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projectbaselayermapping_projectbaselayerid_seq', 102, true);


--
-- Data for Name: la_ext_projectfile; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_projectfile_projectfileid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projectfile_projectfileid_seq', 1, false);


--
-- Data for Name: la_ext_projecthamlet; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_projecthamlet_projecthamletid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projecthamlet_projecthamletid_seq', 1, false);


--
-- Data for Name: la_ext_projection; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_projection (projectionid, projection, description, isactive) VALUES (1, 'EPSG:4326', 'EPSG:4326', true);
INSERT INTO la_ext_projection (projectionid, projection, description, isactive) VALUES (2, 'EPSG:900913', 'EPSG:900913', true);


--
-- Name: la_ext_projection_projectionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projection_projectionid_seq', 1, false);


--
-- Data for Name: la_ext_projectlayergroupmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_projectlayergroupmapping (projectlayergroupid, layergroupid, projectnameid, grouporder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (84, 81, 2, NULL, true, 1, '2018-04-10 00:00:00', NULL, NULL);


--
-- Name: la_ext_projectlayergroupmapping_projectlayergroupid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_projectlayergroupmapping_projectlayergroupid_seq', 84, true);


--
-- Data for Name: la_ext_registrationsharetype; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_ext_resource_custom_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (2, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 10, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (7, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (5, 'Resource Custom Attribute Sub Class 3', 'Resource Custom Attribute Sub Class 3', 5, 10, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (6, 'Resource Custom Attribute Sub Class 4', 'Resource Custom Attribute Sub Class 4', 5, 10, 'Custom', '100', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (9, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 17, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (10, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (11, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (12, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (13, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (14, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (15, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (16, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (17, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (18, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (19, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (20, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (21, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (22, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (23, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (24, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (25, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (26, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (27, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (28, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (29, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (30, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (31, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (32, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (33, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (34, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (35, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (36, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (37, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (38, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (39, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (40, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (41, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (42, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (43, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (44, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (45, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (46, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (47, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (48, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (49, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (50, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (51, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (52, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (53, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (54, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (55, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (57, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (58, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (59, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (60, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (61, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (62, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (63, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (64, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (65, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (66, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (67, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (68, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (69, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (70, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (71, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (72, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (73, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (74, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (75, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (76, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (77, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (78, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (79, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (80, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (81, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (82, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (83, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (84, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (85, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (86, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (56, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 17, 'Custom', '170', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (87, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 18, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (88, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (89, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (90, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (91, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (92, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (93, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (94, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (95, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (96, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (97, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (98, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (99, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (100, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (101, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (102, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (103, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (104, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (105, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (106, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (107, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (108, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (109, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (110, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (111, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (112, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (113, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (114, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (115, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (116, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (117, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (118, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (119, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (120, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (121, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (122, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (123, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (124, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (125, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (126, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (127, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 18, 'Custom', '180', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (128, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 14, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (129, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (130, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (131, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (132, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (133, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (134, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (135, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (136, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (137, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (138, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (139, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (140, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (141, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (142, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (143, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (144, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (145, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (146, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (147, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (148, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (149, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (150, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (151, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (152, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (153, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (154, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (155, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (156, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (157, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (158, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (159, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (160, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (161, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (162, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (163, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (164, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (165, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (166, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (167, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (168, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 14, 'Custom', '140', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (169, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 12, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (170, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (171, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (172, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (173, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (174, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (175, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (176, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (177, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (178, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (179, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (180, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (181, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (182, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (183, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (184, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (185, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (186, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (187, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (188, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (189, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (190, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (191, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (192, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (193, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (194, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (195, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (196, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (197, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (198, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (199, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (200, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (201, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (202, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (203, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (204, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (205, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (206, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (207, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (208, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (209, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 12, 'Custom', '120', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (210, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 11, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (211, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (212, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (213, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (214, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (215, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (216, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (217, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (218, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (219, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (220, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (221, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (222, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (223, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (224, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (225, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (226, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (227, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (228, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (229, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (230, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (231, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (232, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (233, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (234, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (235, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (236, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (237, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (238, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (239, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (240, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (241, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (242, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (243, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (244, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (245, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (246, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (247, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (248, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (249, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (250, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 11, 'Custom', '110', true, '1', true, false, 40, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (251, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 13, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (252, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (253, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 2, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (254, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (255, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 4, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (256, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 5, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (257, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 6, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (258, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 7, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (259, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 8, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (260, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 9, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (261, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 10, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (262, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 11, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (263, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 12, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (264, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 13, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (265, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 14, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (266, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 15, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (267, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 16, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (268, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 17, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (269, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 18, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (270, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 19, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (271, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 20, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (272, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 21, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (273, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 22, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (274, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 23, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (275, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 24, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (276, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 25, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (277, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 26, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (278, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 27, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (279, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 28, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (280, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 29, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (281, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 30, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (282, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 31, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (283, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 32, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (284, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 33, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (285, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 34, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (286, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 35, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (287, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 36, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (288, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 37, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (289, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 38, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (290, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 39, 2);
INSERT INTO la_ext_resource_custom_attribute (customattributeid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute, subclassificationid, projectid) VALUES (291, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 13, 'Custom', '130', true, '1', true, false, 40, 2);


--
-- Name: la_ext_resource_custom_attribute_customattributeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resource_custom_attribute_customattributeid_seq', 1, false);


--
-- Data for Name: la_ext_resource_custom_attributevalue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_ext_resource_documentdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_resource_documentdetails_documentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resource_documentdetails_documentid_seq', 395, true);


--
-- Data for Name: la_ext_resourceattributevalue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_resourceattributevalue_attributevalueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourceattributevalue_attributevalueid_seq', 1, false);


--
-- Data for Name: la_ext_resourceclassification; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (1, 'Built-Up-Area', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (2, 'Community Facilities - Line', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (3, 'Community Facilities - Point', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (4, 'Agricultural Land', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (5, 'Forest-Woodlands', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (6, 'Barren Land', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (7, 'Cultural/Economic/Protected Areas', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (8, 'Wetland', true);
INSERT INTO la_ext_resourceclassification (classificationid, classificationname, isactive) VALUES (9, 'Water', true);


--
-- Name: la_ext_resourceclassification_classificationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourceclassification_classificationid_seq', 9, true);


--
-- Name: la_ext_resourcecustomattributevalue_customattributevalueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourcecustomattributevalue_customattributevalueid_seq', 1, false);


--
-- Data for Name: la_ext_resourcelandclassificationmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_resourcelandclassificationmapping_landclassmappingid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourcelandclassificationmapping_landclassmappingid_seq', 1, false);


--
-- Data for Name: la_ext_resourcepoiattributemaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (1, 'First Name', 'First Name', 1, NULL, 'resourcepoiattribute', '100', true, '1', true, true);
INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (2, 'Middle Name', 'Middle Name', 1, NULL, 'resourcepoiattribute', '100', true, '2', true, true);
INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (3, 'Last Name', 'Last Name', 1, NULL, 'resourcepoiattribute', '100', true, '3', true, true);
INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (4, 'DOB', 'DOB', 2, NULL, 'resourcepoiattribute', '100', true, '4', true, true);
INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (5, 'Relationship Type', 'Relationship Type', 5, NULL, 'resourcepoiattribute', '100', true, '5', true, true);
INSERT INTO la_ext_resourcepoiattributemaster (poiattributemasterid, fieldname, fieldaliasname, datatypemasterid, attributecategoryid, referencetable, size, mandatory, listing, isactive, masterattribute) VALUES (6, 'Gender', 'Gender', 5, NULL, 'resourcepoiattribute', '100', true, '6', true, true);


--
-- Name: la_ext_resourcepoiattributemasterid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourcepoiattributemasterid_seq', 1, false);


--
-- Data for Name: la_ext_resourcepoiattributevalue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_resourcepoiattributevalue_attributevalueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourcepoiattributevalue_attributevalueid_seq', 1, false);


--
-- Data for Name: la_ext_resourcesubclassification; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (1, 1, 3, 'Urban', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (2, 1, 3, 'Non-Urban', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (3, 2, 2, 'Road', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (4, 2, 2, 'Path', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (5, 3, 1, 'Bridge', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (6, 3, 1, 'Buildings', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (7, 3, 1, 'Churches', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (8, 3, 1, 'School', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (9, 3, 1, 'Clinic', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (10, 3, 1, 'Community meeting', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (11, 3, 1, 'Market', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (12, 3, 1, 'Others', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (13, 4, 3, 'Rain-fed small plot agriculture', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (14, 4, 3, 'Irrigated small plot agriculture ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (15, 4, 3, 'Grazing lands- pastures (stationary)', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (16, 4, 3, 'Grazing Lands -pastoralism', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (17, 4, 3, 'Agro-forestry ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (18, 4, 3, 'Aquaculture ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (19, 5, 3, 'Natural Forest ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (20, 5, 3, 'Mixed forest ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (21, 5, 3, 'Open woodland', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (22, 5, 3, 'Parks', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (23, 6, 3, 'Bare Rock', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (24, 6, 3, 'Sand or Desert or Plains', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (25, 6, 3, 'Sparsely Vegetalated', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (26, 6, 3, 'Others', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (27, 7, 3, 'Mining Sites', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (28, 7, 3, 'Hunting and gathering areas ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (29, 7, 3, 'Fishing areas ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (30, 7, 3, 'Wildlife areas ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (31, 7, 3, 'Protected/conservation areas', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (32, 7, 3, 'Cultural Areas', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (33, 8, 3, 'Inland wetland vegetation', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (34, 8, 3, 'Coastal wetland vegetation ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (35, 8, 3, 'Coastal woodland ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (36, 9, 3, 'Water Courses  River', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (37, 9, 2, 'Water Courses  Stream', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (38, 9, 3, 'Water Bodies ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (39, 9, 3, 'Lagoon ', true);
INSERT INTO la_ext_resourcesubclassification (subclassificationid, classificationid, geometrytypeid, subclassificationname, isactive) VALUES (40, 9, 3, 'Sea and Ocean', true);


--
-- Name: la_ext_resourcesubclassification_subclassificationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_resourcesubclassification_subclassificationid_seq', 40, true);


--
-- Data for Name: la_ext_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (2, 'DPI', 'DPI', 'DPI Land Official', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (3, 'PM', 'PM', 'Project Manager', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (4, 'PUBLIC USER', 'PUBLIC USER', 'Public User', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (5, 'SFR', 'SFR', 'SFR Land Official', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (6, 'TRUSTED INTERMEDIARY', 'TRUSTED INTERMEDIARY', 'CFV Agent', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (7, 'USER', 'USER', 'User', true);
INSERT INTO la_ext_role (roleid, roletype, roletype_en, description, isactive) VALUES (1, 'ROLE_ADMIN', 'ADMIN', 'System Administrator', true);


--
-- Name: la_ext_role_roleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_role_roleid_seq', 7, true);


--
-- Data for Name: la_ext_rolemodulemapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (4, 1, 4, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (7, 1, 7, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (11, 1, 11, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (12, 1, 12, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (14, 1, 14, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (15, 1, 15, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (16, 1, 16, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (22, 1, 22, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (23, 1, 23, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (24, 1, 24, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (28, 1, 28, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (29, 1, 29, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (30, 1, 30, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (3, 1, 3, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (1, 1, 1, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (2, 1, 2, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (5, 1, 5, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (6, 1, 6, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (9, 1, 9, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (10, 1, 10, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (13, 1, 13, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (17, 1, 17, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (18, 1, 18, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (19, 1, 19, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (20, 1, 20, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (21, 1, 21, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (25, 1, 25, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (26, 1, 26, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (27, 1, 27, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (31, 1, 31, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (32, 1, 32, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (33, 1, 33, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (34, 1, 34, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (35, 1, 35, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (36, 1, 36, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping (rolemoduleid, roleid, moduleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (8, 1, 8, true, 1, '0208-10-05 00:00:00', NULL, NULL);


--
-- Name: la_ext_rolemodulemapping_rolemoduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_rolemodulemapping_rolemoduleid_seq', 38, true);


--
-- Data for Name: la_ext_slopevalue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_slopevalue_slopevalueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_slopevalue_slopevalueid_seq', 1, false);


--
-- Data for Name: la_ext_spatialunit_personwithinterest; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_spatialunit_personwithinterest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_spatialunit_personwithinterest_id_seq', 21, true);


--
-- Data for Name: la_ext_surveyprojectattributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (101, 2, 1056, 16, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-11-22 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (57, 2, 1017, 10, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-11-22 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (58, 2, 1011, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (59, 2, 1013, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (1, 2, 1, 2, 1, true, 1, '2010-10-10 00:00:00', 1, '2011-10-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (2, 2, 2, 2, 1, true, 1, '2017-11-11 00:00:00', 1, '2017-12-18 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (3, 2, 3, 2, 1, true, 1, '2017-11-12 00:00:00', 1, '2017-12-17 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (4, 2, 4, 2, 1, true, 1, '2017-11-13 00:00:00', 1, '2017-12-16 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (5, 2, 5, 2, 1, true, 1, '2017-11-14 00:00:00', 1, '2017-12-15 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (6, 2, 6, 5, 1, true, 1, '2017-11-15 00:00:00', 1, '2017-12-14 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (7, 2, 7, 5, 1, true, 1, '2017-11-16 00:00:00', 1, '2017-12-13 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (8, 2, 8, 5, 1, true, 1, '2017-11-17 00:00:00', 1, '2017-12-12 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (9, 2, 9, 4, 1, true, 1, '2017-11-18 00:00:00', 1, '2017-12-11 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (10, 2, 10, 3, 1, true, 1, '2017-11-19 00:00:00', 1, '2017-12-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (11, 2, 11, 3, 1, true, 1, '2017-11-20 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (12, 2, 13, 4, 1, true, 1, '2017-11-21 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (15, 2, 22, 2, 1, true, 1, '2017-11-24 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (16, 2, 23, 4, 1, true, 1, '2017-11-25 00:00:00', 1, '2017-12-06 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (17, 2, 24, 4, 1, true, 1, '2017-11-26 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (19, 2, 40, 2, 1, true, 1, '2017-11-28 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (20, 2, 41, 2, 1, true, 1, '2017-11-29 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (21, 2, 42, 2, 1, true, 1, '2017-11-30 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (22, 2, 43, 2, 1, true, 1, '2017-12-01 00:00:00', 1, '2017-12-06 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (60, 2, 1015, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (13, 2, 15, 1, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (106, 2, 1053, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (107, 2, 1057, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (108, 2, 1063, 17, 1, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (61, 2, 1018, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (62, 2, 1019, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (63, 2, 1020, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (64, 2, 1021, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (65, 2, 1022, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (66, 2, 1023, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (67, 2, 1024, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (68, 2, 1025, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (69, 2, 1026, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (70, 2, 1027, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (71, 2, 1028, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (72, 2, 1029, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (73, 2, 1030, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (74, 2, 1031, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (75, 2, 1032, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (76, 2, 1033, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (77, 2, 1034, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (78, 2, 1035, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (79, 2, 1010, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (80, 2, 1036, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (81, 2, 1037, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (82, 2, 1038, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (83, 2, 1039, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (84, 2, 1040, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (85, 2, 1041, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (86, 2, 1042, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (87, 2, 1043, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (88, 2, 1044, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (89, 2, 1045, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (90, 2, 1046, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (91, 2, 1047, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (92, 2, 1048, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (93, 2, 1049, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (94, 2, 1050, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (95, 2, 1051, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (96, 2, 1052, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (98, 2, 1054, 15, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (99, 2, 1055, 15, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (109, 2, 1064, 17, 6, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (110, 2, 1065, 17, 2, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (111, 2, 1066, 17, 3, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (112, 2, 1067, 17, 4, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (113, 2, 1068, 17, 5, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (114, 2, 1069, 17, 7, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (115, 2, 1070, 17, 8, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (116, 2, 1071, 17, 9, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (117, 2, 1072, 17, 12, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (118, 2, 1073, 17, 10, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (119, 2, 1074, 17, 11, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (120, 2, 1075, 17, 13, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (121, 2, 1076, 17, 14, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (122, 2, 1115, 17, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (123, 2, 1116, 17, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (124, 2, 1117, 17, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (125, 2, 1118, 17, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (126, 2, 1119, 17, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (127, 2, 1120, 17, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (128, 2, 1121, 17, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (129, 2, 1122, 17, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (130, 2, 1123, 17, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (131, 2, 1124, 17, 12, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (132, 2, 1125, 17, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (133, 2, 1126, 17, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (134, 2, 1127, 17, 13, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (135, 2, 1128, 17, 14, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (138, 2, 1077, 18, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (139, 2, 1078, 18, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (140, 2, 1079, 18, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (141, 2, 1080, 18, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (142, 2, 1081, 18, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (143, 2, 1082, 18, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (147, 2, 1086, 18, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (148, 2, 1087, 11, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (149, 2, 1088, 11, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (150, 2, 1089, 11, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (151, 2, 1090, 11, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (152, 2, 1091, 11, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (183, 2, 1136, 5, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (184, 2, 1137, 5, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (185, 2, 1138, 5, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (156, 2, 1095, 11, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (157, 2, 1096, 12, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (158, 2, 1097, 12, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (159, 2, 1098, 12, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (160, 2, 1099, 12, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (161, 2, 1100, 12, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (166, 2, 1105, 12, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (167, 2, 1106, 13, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (168, 2, 1107, 13, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (169, 2, 1108, 13, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (170, 2, 1109, 13, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (171, 2, 1110, 13, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (172, 2, 1111, 13, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (186, 2, 1139, 8, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (187, 2, 1140, 8, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (188, 2, 1141, 8, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (189, 2, 1142, 8, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (190, 2, 1143, 1, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (191, 2, 1144, 1, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (146, 2, 1085, 18, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (192, 2, 1145, 1, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (193, 2, 1146, 1, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (194, 2, 1147, 1, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (173, 2, 1112, 13, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (174, 2, 1113, 13, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (175, 2, 1114, 13, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (162, 2, 1101, 12, 9, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (163, 2, 1102, 12, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (164, 2, 1103, 12, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (165, 2, 1104, 12, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (153, 2, 1092, 11, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (154, 2, 1093, 11, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (155, 2, 1094, 11, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (144, 2, 1083, 18, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (145, 2, 1084, 18, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (176, 2, 1129, 2, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (177, 2, 1130, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (178, 2, 1131, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (179, 2, 1132, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (180, 2, 1133, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (181, 2, 1134, 2, 12, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (182, 2, 1135, 2, 13, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (195, 2, 1148, 1, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (196, 2, 1149, 1, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (197, 2, 1150, 1, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (199, 2, 1151, 2, 10, true, 1, '2010-10-10 00:00:00', 1, '2010-10-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (200, 2, 1059, 2, 8, true, 1, '2018-01-25 19:13:05.002602', 1, '2018-01-25 19:13:05.002602');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (202, 2, 1152, 2, 10, true, 1, '2018-01-31 00:00:00', 1, '2018-01-31 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (203, 2, 1153, 2, 11, true, 1, '2018-01-31 00:00:00', 1, '2018-01-31 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (204, 2, 1154, 5, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (206, 2, 1155, 2, 14, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (207, 2, 1156, 2, 15, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (208, 2, 1158, 10, 20, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (209, 2, 1159, 11, 21, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (210, 2, 1160, 12, 22, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (211, 2, 1161, 14, 23, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (212, 2, 1162, 18, 24, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (213, 2, 1163, 17, 25, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (214, 2, 1164, 17, 26, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (215, 2, 1165, 13, 27, true, 1, '2018-01-24 00:00:00', 1, '2018-01-24 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (14, 2, 16, 7, 1, true, 1, '2017-11-23 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (27, 2, 53, 7, 2, true, 1, '2017-12-06 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (198, 2, 1058, 7, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (18, 2, 37, 7, 4, true, 1, '2017-11-27 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (25, 2, 46, 7, 5, true, 1, '2017-12-04 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (26, 2, 47, 7, 6, true, 1, '2017-12-05 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (23, 2, 44, 7, 7, true, 1, '2017-12-02 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (24, 2, 45, 7, 8, true, 1, '2017-12-03 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes (surveyprojectattributesid, projectnameid, attributemasterid, attributecategoryid, attributeorder, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (216, 2, 1167, 6, 1, true, 1, '2018-11-05 00:00:00', 1, '2018-11-05 00:00:00');


--
-- Name: la_ext_surveyprojectattributes_surveyprojectattributesid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_surveyprojectattributes_surveyprojectattributesid_seq', 216, true);


--
-- Data for Name: la_ext_transactiondetails; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_transactiondetails_transactionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_transactiondetails_transactionid_seq', 1, false);


--
-- Data for Name: la_ext_transactionhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_ext_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (1, 'Foot', 'Foot', true);
INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (2, 'Inches ', 'Inches ', true);
INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (3, 'Kilometer', 'Kilometer', true);
INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (4, 'Meter', 'Meter', true);
INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (5, 'Miles', 'Miles', true);
INSERT INTO la_ext_unit (unitid, unit, unit_en, isactive) VALUES (6, 'dd', 'dd', true);


--
-- Name: la_ext_unit_unitid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_unit_unitid_seq', 6, true);


--
-- Data for Name: la_ext_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_user (userid, name, managername, genderid, username, password, authenticationkey, emailid, contactno, address, passwordexpires, lastactivitydate, isactive, createdby, createddate, modifiedby, modifieddate, defaultproject) VALUES (24, 'MAST Demo', '1', 1, 'demo', 'KgnFtGiLYmK0f/GkHvViaQ==', 'hx%2BlM3SoPEQlXklbUDB7LLUY4LCrMe0JEkSeG05%2BCom1qqTnk0tWKf5qBpzhy6kYHDz%2B7OFOMMJSgQwTCMG%2FEg%3D%3D', 'demo@mast.org', '1234567890', '123 Anywhere', '2025-12-31', '2018-08-19', true, 1, '2018-08-19 20:46:30.017', 1, '2018-08-19 20:46:30.017', 'MAST Demo');


--
-- Name: la_ext_user_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_user_userid_seq', 25, true);


--
-- Data for Name: la_ext_userprojectmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_ext_userprojectmapping_userprojectid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_userprojectmapping_userprojectid_seq', 1, false);


--
-- Data for Name: la_ext_userrolemapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_userrolemapping (userroleid, userid, roleid, isactive, createdby, createddate, modifiedby, modifieddate) VALUES (52, 24, 1, true, 1, '2018-08-19 20:46:30.016', 0, NULL);


--
-- Name: la_ext_userrolemapping_userroleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_userrolemapping_userroleid_seq', 54, true);


--
-- Data for Name: la_ext_workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (1, 'New', 'New', 1, true, 1);
INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (2, 'Process Data for Field Verification', 'Process Data for Field Verification', 2, true, 1);
INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (3, 'Field Verification & Update Land Record ', 'Field Verification & Update Land Record ', 3, true, 1);
INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (4, 'Generate and Print Land Certificate', 'Generate and Print Land Certificate', 4, true, 1);
INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (5, 'Rejected', 'Rejected', 5, true, 1);
INSERT INTO la_ext_workflow (workflowid, workflow, workflow_en, workfloworder, isactive, workflowdefid) VALUES (6, 'Approved', 'Approved', 6, true, 1);


--
-- Name: la_ext_workflow_workflowid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_workflow_workflowid_seq', 6, false);


--
-- Data for Name: la_ext_workflowactionmapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (15, 'Print Land Certificate ', 'Print Land Certificate ', 1, 4, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (12, 'Move to "Generate and Print Land Certificate"', 'Move to "Generate and Print Land Certificate"', 1, 3, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (8, 'Move to "Field Verification" stage ', 'Move to "Field Verification" stage ', 1, 2, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (10, 'Edit Attributes ', 'Edit Attributes ', 1, 3, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (11, 'Print Land Record Verification Form', 'Print Land Record Verification Form', 1, 3, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (14, 'View  Attributes ', 'View  Attributes ', 1, 4, 2, true, 'view                                              ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (16, 'Finalize Land Certificate and Register', 'Finalize Land Certificate and Register', 1, 4, 4, true, 'register                                          ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (13, 'View Spatial ', 'View Spatial ', 1, 4, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (19, 'Data Correction Report', 'Data Correction Report', 1, 1, 6, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (2, 'Edit Attributes ', 'Edit Attributes ', 1, 1, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (3, 'Reject', 'Reject', 1, 1, 3, true, 'reject                                            ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (4, 'Move to "Process Data" ', 'Move to "Process Data" ', 1, 1, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (6, 'Edit Attributes ', 'Edit Attributes ', 1, 2, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (7, 'Generates Land Record Verification Form', 'Generates Land Record Verification Form', 1, 2, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (1, 'Edit Spatial ', 'Edit Spatial ', 1, 1, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (5, 'Edit Spatial ', 'Edit Spatial ', 1, 2, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (17, 'Edit Spatial', 'Edit Spatial', 1, 5, 1, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (18, 'Edit Spatial', 'Edit Spatial', 1, 5, 2, true, 'delete                                            ');
INSERT INTO la_ext_workflowactionmapping (workflowactionid, actionname, actionname_en, roleid, workflowid, worder, isactive, action) VALUES (9, 'Edit Spatial ', 'Edit Spatial', 1, 3, 1, true, 'edit  spatial                                     ');


--
-- Name: la_ext_workflowactionmapping_workflowactionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_workflowactionmapping_workflowactionid_seq', 1, false);


--
-- Data for Name: la_ext_workflowdef; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_ext_workflowdef (workflowdefid, name, type) VALUES (1, 'NewProjectWorkFlow', 2);


--
-- Name: la_ext_workflowdef_workflowdefid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_ext_workflowdef_workflowdefid_seq', 1, false);


--
-- Data for Name: la_layer; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_party; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_party_deceasedperson; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_party_organization; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_party_partyid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_party_partyid_seq', 1, false);


--
-- Data for Name: la_party_person; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_partygroup_citizenship; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_citizenship (citizenshipid, citizenship, citizenship_en, isactive) VALUES (1, 'Country 1', 'Country 1', true);
INSERT INTO la_partygroup_citizenship (citizenshipid, citizenship, citizenship_en, isactive) VALUES (2, 'Country 2', 'Country 2', true);
INSERT INTO la_partygroup_citizenship (citizenshipid, citizenship, citizenship_en, isactive) VALUES (3, 'Country 3', 'Country 3', true);
INSERT INTO la_partygroup_citizenship (citizenshipid, citizenship, citizenship_en, isactive) VALUES (4, 'Country 4', 'Country 4', true);


--
-- Name: la_partygroup_citizenship_citizenshipid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_citizenship_citizenshipid_seq', 4, true);


--
-- Data for Name: la_partygroup_educationlevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_educationlevel (educationlevelid, educationlevel, educationlevel_en, isactive) VALUES (2, 'Primary', 'Primary', true);
INSERT INTO la_partygroup_educationlevel (educationlevelid, educationlevel, educationlevel_en, isactive) VALUES (3, 'Secondary', 'Secondary', true);
INSERT INTO la_partygroup_educationlevel (educationlevelid, educationlevel, educationlevel_en, isactive) VALUES (4, 'University', 'University', true);
INSERT INTO la_partygroup_educationlevel (educationlevelid, educationlevel, educationlevel_en, isactive) VALUES (1, 'None', 'None', true);


--
-- Name: la_partygroup_educationlevel_educationlevelid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_educationlevel_educationlevelid_seq', 5, true);


--
-- Data for Name: la_partygroup_ethnicity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_ethnicity (ethnicityid, ethnicity, ethnicity_en, isactive) VALUES (1, 'Ethnicity 1', 'Ethnicity 1', true);
INSERT INTO la_partygroup_ethnicity (ethnicityid, ethnicity, ethnicity_en, isactive) VALUES (2, 'Ethnicity 2', 'Ethnicity 2', true);
INSERT INTO la_partygroup_ethnicity (ethnicityid, ethnicity, ethnicity_en, isactive) VALUES (3, 'Ethnicity 3', 'Ethnicity 3', true);
INSERT INTO la_partygroup_ethnicity (ethnicityid, ethnicity, ethnicity_en, isactive) VALUES (4, 'Ethnicity 4', 'Ethnicity 4', true);


--
-- Name: la_partygroup_ethnicity_ethnicityid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_ethnicity_ethnicityid_seq', 4, true);


--
-- Data for Name: la_partygroup_gender; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_gender (genderid, gender, gender_en, isactive) VALUES (1, 'Male', 'Male', true);
INSERT INTO la_partygroup_gender (genderid, gender, gender_en, isactive) VALUES (2, 'Female', 'Female', true);
INSERT INTO la_partygroup_gender (genderid, gender, gender_en, isactive) VALUES (3, 'Other', 'Other', false);


--
-- Name: la_partygroup_gender_genderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_gender_genderid_seq', 3, true);


--
-- Data for Name: la_partygroup_identitytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (1, 'Voter ID', 'Voter ID', true);
INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (2, 'Driving license', 'Driving license', true);
INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (3, 'Passport', 'Passport', true);
INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (4, 'ID card', 'ID card', true);
INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (5, 'Other', 'Other', true);
INSERT INTO la_partygroup_identitytype (identitytypeid, identitytype, identitytype_en, isactive) VALUES (6, 'None', 'None', true);


--
-- Name: la_partygroup_identitytype_identitytypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_identitytype_identitytypeid_seq', 6, true);


--
-- Data for Name: la_partygroup_maritalstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_maritalstatus (maritalstatusid, maritalstatus, maritalstatus_en, isactive) VALUES (2, 'Married', 'Married', true);
INSERT INTO la_partygroup_maritalstatus (maritalstatusid, maritalstatus, maritalstatus_en, isactive) VALUES (3, 'Divorced', 'Divorced', true);
INSERT INTO la_partygroup_maritalstatus (maritalstatusid, maritalstatus, maritalstatus_en, isactive) VALUES (4, 'Widow', 'Widow', true);
INSERT INTO la_partygroup_maritalstatus (maritalstatusid, maritalstatus, maritalstatus_en, isactive) VALUES (5, 'Widower', 'Widower', true);
INSERT INTO la_partygroup_maritalstatus (maritalstatusid, maritalstatus, maritalstatus_en, isactive) VALUES (1, 'un-married', 'un-married', true);


--
-- Name: la_partygroup_maritalstatus_maritalstatusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_maritalstatus_maritalstatusid_seq', 5, true);


--
-- Data for Name: la_partygroup_occupation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (1, 'Agriculture', 'Agriculture', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (2, 'Livestock/Pastoralist', 'Livestock/Pastoralist', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (3, 'Small Business', 'Small Business', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (4, 'Skilled Labor (carpentry, masonry, etc)', 'Skilled Labor (carpentry, masonry, etc)', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (5, 'Professional/administrative/office', 'Professional/administrative/office', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (6, 'Public employee', 'Public employee', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (7, 'Homekeeper', 'Homekeeper', true);
INSERT INTO la_partygroup_occupation (occupationid, occupation, occupation_en, isactive) VALUES (8, 'Other', 'Other', true);


--
-- Name: la_partygroup_occupation_occupationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_occupation_occupationid_seq', 7, true);


--
-- Data for Name: la_partygroup_persontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (1, 'Person (Natural)', 'Person (Natural)', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (2, 'Organization (Non-Natural)', 'Organization (Non-Natural)', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (4, 'Guardian', 'Guardian', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (5, 'Tenant', 'Tenant', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (6, 'Administrator', 'Administrator', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (7, 'Witness', 'Witness', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (8, 'Deceased Person', 'Deceased Person', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (9, 'Person of Intrest', 'Person of Intrest', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (3, 'Owner', 'Owner', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (10, 'dispute person', 'dispute person', true);
INSERT INTO la_partygroup_persontype (persontypeid, persontype, persontype_en, isactive) VALUES (11, 'Buyer', 'Buyer', true);


--
-- Name: la_partygroup_persontype_persontypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_persontype_persontypeid_seq', 10, true);


--
-- Data for Name: la_partygroup_relationshiptype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (2, 'Son', 'Son', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (3, 'Daughter', 'Daughter', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (4, 'Grandson', 'Grandson', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (5, 'Granddaughter', 'Granddaughter', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (6, 'Brother', 'Brother', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (7, 'Sister', 'Sister', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (8, 'Father', 'Father', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (9, 'Mother', 'Mother', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (10, 'Grandmother', 'Grandmother', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (11, 'Grandfather', 'Grandfather', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (12, 'Aunt', 'Aunt', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (13, 'Uncle', 'Uncle', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (14, 'Niece', 'Niece', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (15, 'Nephew', 'Nephew', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (16, 'Other', 'Other', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (1, 'Spouse', 'Spouse', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (18, 'Associate', 'Associate', true);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (17, 'Other relatives', 'Other relatives', false);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (19, 'Parents and children', 'Parents and children', false);
INSERT INTO la_partygroup_relationshiptype (relationshiptypeid, relationshiptype, relationshiptype_en, isactive) VALUES (20, 'Siblings', 'Siblings', false);


--
-- Name: la_partygroup_relationshiptype_relationshiptypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_relationshiptype_relationshiptypeid_seq', 20, true);


--
-- Data for Name: la_partygroup_resident; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_partygroup_resident (residentid, resident, resident_en, isactive) VALUES (1, 'Yes', 'Yes', true);
INSERT INTO la_partygroup_resident (residentid, resident, resident_en, isactive) VALUES (2, 'No', 'No', true);


--
-- Name: la_partygroup_resident_residentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_partygroup_resident_residentid_seq', 2, true);


--
-- Name: la_registrationsharetype_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_registrationsharetype_seq', 1, false);


--
-- Data for Name: la_right_acquisitiontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_right_acquisitiontype (acquisitiontypeid, acquisitiontype, acquisitiontype_en, isactive) VALUES (1, 'Allocated by community', 'Allocated by community', true);
INSERT INTO la_right_acquisitiontype (acquisitiontypeid, acquisitiontype, acquisitiontype_en, isactive) VALUES (2, 'Allocated by Family', 'Allocated by Family', true);
INSERT INTO la_right_acquisitiontype (acquisitiontypeid, acquisitiontype, acquisitiontype_en, isactive) VALUES (3, 'Gift', 'Gift', true);
INSERT INTO la_right_acquisitiontype (acquisitiontypeid, acquisitiontype, acquisitiontype_en, isactive) VALUES (4, 'Inheritance', 'Inheritance', true);
INSERT INTO la_right_acquisitiontype (acquisitiontypeid, acquisitiontype, acquisitiontype_en, isactive) VALUES (5, 'Purchase', 'Purchase', true);


--
-- Name: la_right_acquisitiontype_acquisitiontypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_right_acquisitiontype_acquisitiontypeid_seq', 5, true);


--
-- Data for Name: la_right_claimtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_right_claimtype (claimtypeid, claimtype, claimtype_en, isactive) VALUES (4, 'Unclaimed', 'Unclaimed', true);
INSERT INTO la_right_claimtype (claimtypeid, claimtype, claimtype_en, isactive) VALUES (2, 'Existing Claim or Right', 'Existing Claim or Right', true);
INSERT INTO la_right_claimtype (claimtypeid, claimtype, claimtype_en, isactive) VALUES (3, 'Disputed Claim', 'Disputed Claim', true);
INSERT INTO la_right_claimtype (claimtypeid, claimtype, claimtype_en, isactive) VALUES (5, 'No Claim', 'No Claim for resource', false);
INSERT INTO la_right_claimtype (claimtypeid, claimtype, claimtype_en, isactive) VALUES (1, 'New claim', 'New claim', true);


--
-- Name: la_right_claimtype_claimtypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_right_claimtype_claimtypeid_seq', 5, true);


--
-- Data for Name: la_right_landsharetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (6, 'Single Tenancy', 'Single Tenancy', true);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (7, 'Joint Tenancy', 'Joint Tenancy', true);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (1, 'Co-occupancy (Tenancy in Common)', 'Co-occupancy (Tenancy in Common)', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (2, 'Single Occupant', 'Single Occupant', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (3, 'Co-occupancy (Joint tenancy)', 'Co-occupancy (Joint tenancy)', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (4, 'Customary(Individual)', 'Customary(Individual)', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (5, 'Customary(Collective)', 'Customary(Collective)', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (9999, 'Dummy', 'Dummy', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (9, 'Collective Tenancy', 'Collective Tenancy', false);
INSERT INTO la_right_landsharetype (landsharetypeid, landsharetype, landsharetype_en, isactive) VALUES (8, 'Common/Collective Tenancy', 'Common/Collective Tenancy', true);


--
-- Name: la_right_landsharetype_landsharetypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_right_landsharetype_landsharetypeid_seq', 9, true);


--
-- Data for Name: la_right_tenureclass; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (1, 'Derivative Right', 'Derivative Right', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (2, 'Customary Right of Occupancy', 'Customary Right of Occupancy', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (4, 'Right of Use', 'Right of Use', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (5, 'Formal Ownership (Free-hold)', 'Formal Ownership (Free-hold)', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (6, 'Granted Right of Occupancy', 'Granted Right of Occupancy', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (7, 'Right to Manage', 'Right to Manage', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (3, 'Right to Ownership ', 'Cerificate of Occupany', true);
INSERT INTO la_right_tenureclass (tenureclassid, tenureclass, tenureclass_en, isactive) VALUES (9999, 'Dummy', 'Dummy', false);


--
-- Name: la_right_tenureclass_tenureclassid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_right_tenureclass_tenureclassid_seq', 7, true);


--
-- Data for Name: la_rrr; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_rrr_lease; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_rrr_mortgage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_rrr_rrrid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_rrr_rrrid_seq', 1, false);


--
-- Data for Name: la_rrr_surrenderlease; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_rrr_surrendermortgage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_spatialsource_layer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_spatialsource_layer (layerid, layername, projectionid, unitid, documentformatid, layertypeid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, minscale, maxscale, location, geometrytype, buffer, displayname, filter, version, displayinlayermanager, displayoutsidemaxextent, editable, exportable, isbaselayer, queryable, selectable, sphericalmercator, tiled, isactive, createdby, createddate, modifiedby, modifieddate, name) VALUES (31, 'spatialUnitLand', 1, 6, 2, 1, NULL, NULL, 2, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', 10, 1000, 'http://localhost:8080/geoserver/wfs?', NULL, 0, 'spatialUnitLand', NULL, NULL, true, true, true, true, false, false, true, NULL, false, true, 2, '2017-12-11 16:19:20.27', 2, '2017-12-11 16:19:20.27', 'Mast:la_spatialunit_land');
INSERT INTO la_spatialsource_layer (layerid, layername, projectionid, unitid, documentformatid, layertypeid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, minscale, maxscale, location, geometrytype, buffer, displayname, filter, version, displayinlayermanager, displayoutsidemaxextent, editable, exportable, isbaselayer, queryable, selectable, sphericalmercator, tiled, isactive, createdby, createddate, modifiedby, modifieddate, name) VALUES (34, 'Resource', 1, 5, 3, 1, NULL, NULL, NULL, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', 2, 10, 'http://localhost:8080/geoserver/wfs?', NULL, 0, 'LA_SPATIALUNIT_RESOURCE', NULL, NULL, true, false, true, true, false, true, true, NULL, true, true, 1, '2018-01-04 12:19:44.972', NULL, NULL, 'Mast:la_spatialunit_resource_land');
INSERT INTO la_spatialsource_layer (layerid, layername, projectionid, unitid, documentformatid, layertypeid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, minscale, maxscale, location, geometrytype, buffer, displayname, filter, version, displayinlayermanager, displayoutsidemaxextent, editable, exportable, isbaselayer, queryable, selectable, sphericalmercator, tiled, isactive, createdby, createddate, modifiedby, modifieddate, name) VALUES (35, 'Line', 1, 6, 2, 1, NULL, NULL, NULL, '35.0,-9.0,36.0,-7.0', '35.0,-9.0,36.0,-7.0', 2, 10, 'http://localhost:8080/geoserver/wfs?', NULL, 0, 'Line', NULL, NULL, true, false, true, true, false, true, false, NULL, false, true, 1, '2018-01-08 19:27:01.559', NULL, NULL, 'Mast:la_spatialunit_resource_line');
INSERT INTO la_spatialsource_layer (layerid, layername, projectionid, unitid, documentformatid, layertypeid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, minscale, maxscale, location, geometrytype, buffer, displayname, filter, version, displayinlayermanager, displayoutsidemaxextent, editable, exportable, isbaselayer, queryable, selectable, sphericalmercator, tiled, isactive, createdby, createddate, modifiedby, modifieddate, name) VALUES (36, 'point', 1, 6, 2, 1, NULL, NULL, NULL, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '35.0,-9.0,36.0,-7.0', 2, 10, 'http://localhost:8080/geoserver/wfs?', NULL, 0, 'point', NULL, NULL, true, false, true, true, false, false, true, NULL, false, true, 1, '2018-01-08 19:27:51.348', NULL, NULL, 'Mast:la_spatialunit_resource_point');
INSERT INTO la_spatialsource_layer (layerid, layername, projectionid, unitid, documentformatid, layertypeid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, minscale, maxscale, location, geometrytype, buffer, displayname, filter, version, displayinlayermanager, displayoutsidemaxextent, editable, exportable, isbaselayer, queryable, selectable, sphericalmercator, tiled, isactive, createdby, createddate, modifiedby, modifieddate, name) VALUES (33, 'AOI', 1, 6, 2, 1, NULL, NULL, NULL, '34.9862284585834,-8.3416087407727,37.6789802312851,-5.61527110433126', '34.9862284585834,-8.3416087407727,37.6789802312851,-5.61527110433126', 2, 10, 'http://localhost:8080/geoserver/wfs?', 'POLYGON', 0, 'LA_SPATIALUNIT_AOI', NULL, NULL, true, false, true, false, false, true, true, NULL, true, true, 1, '2018-01-04 12:17:45.898', 1, '2018-05-23 23:08:21.836', 'Mast:la_spatialunit_aoi');


--
-- Name: la_spatialsource_layer_layerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialsource_layer_layerid_seq', 45, true);


--
-- Data for Name: la_spatialsource_projectname; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_spatialsource_projectname (projectnameid, projectname, projectionid, unitid, documentformatid, minresolution, maxresolution, zoomlevelextent, minextent, maxextent, activelayer, overlaymap, disclaimer, description, isactive, createdby, createddate, modifiedby, modifieddate, workflowdefid) VALUES (2, 'MAST Demo', 1, 4, 2, 13, 14, 22, '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', 'spatialUnitLand', 'spatialUnitLand', 'abd', 'New Project', true, 1, '2018-04-10 00:00:00', 3, '2015-06-21 00:00:00', 1);


--
-- Name: la_spatialsource_projectname_projectnameid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialsource_projectname_projectnameid_seq', 36, true);


--
-- Data for Name: la_spatialunit_aoi; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_spatialunit_aoi_aoiid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunit_aoi_aoiid_seq', 1, false);


--
-- Name: la_spatialunit_aoi_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunit_aoi_id_seq1', 6, true);


--
-- Name: la_spatialunit_aoiid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunit_aoiid_seq', 26, true);


--
-- Data for Name: la_spatialunit_land; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_spatialunit_land_landid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunit_land_landid_seq', 1, false);


--
-- Data for Name: la_spatialunit_resource_land; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: la_spatialunit_resource_land_landid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunit_resource_land_landid_seq', 1, false);


--
-- Data for Name: la_spatialunit_resource_line; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_spatialunit_resource_point; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: la_spatialunitgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_spatialunitgroup (spatialunitgroupid, hierarchy, hierarchy_en, isactive) VALUES (1, 'Country', 'Country', true);
INSERT INTO la_spatialunitgroup (spatialunitgroupid, hierarchy, hierarchy_en, isactive) VALUES (2, 'Region', 'Region', true);
INSERT INTO la_spatialunitgroup (spatialunitgroupid, hierarchy, hierarchy_en, isactive) VALUES (3, 'Province', 'Province', true);
INSERT INTO la_spatialunitgroup (spatialunitgroupid, hierarchy, hierarchy_en, isactive) VALUES (4, 'Commune', 'Commune', true);
INSERT INTO la_spatialunitgroup (spatialunitgroupid, hierarchy, hierarchy_en, isactive) VALUES (5, 'Place', 'Place', true);


--
-- Data for Name: la_spatialunitgroup_hierarchy; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO la_spatialunitgroup_hierarchy (hierarchyid, name, name_en, spatialunitgroupid, uperhierarchyid, isactive, code) VALUES (3, 'MAST Province', 'MAST Province', 3, 2, true, 'MSP');
INSERT INTO la_spatialunitgroup_hierarchy (hierarchyid, name, name_en, spatialunitgroupid, uperhierarchyid, isactive, code) VALUES (2, 'MAST Region', 'MAST Region', 2, 1, true, 'MSR');
INSERT INTO la_spatialunitgroup_hierarchy (hierarchyid, name, name_en, spatialunitgroupid, uperhierarchyid, isactive, code) VALUES (1, 'Mast Country', 'Mast Country', 1, NULL, true, 'MST');
INSERT INTO la_spatialunitgroup_hierarchy (hierarchyid, name, name_en, spatialunitgroupid, uperhierarchyid, isactive, code) VALUES (4, 'MAST Community', 'MAST Community', 4, 3, true, 'MSC');
INSERT INTO la_spatialunitgroup_hierarchy (hierarchyid, name, name_en, spatialunitgroupid, uperhierarchyid, isactive, code) VALUES (5, 'MAST Place', 'MAST Place', 5, 4, true, 'MSL');


--
-- Name: la_spatialunitgroup_hierarchy_hierarchyid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunitgroup_hierarchy_hierarchyid_seq', 1, false);


--
-- Name: la_spatialunitgroup_spatialunitgroupid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_spatialunitgroup_spatialunitgroupid_seq', 5, true);


--
-- Name: la_surrendermortgage_mortgageid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_surrendermortgage_mortgageid_seq', 3, true);


--
-- Name: la_transactionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('la_transactionhistory_seq', 1, false);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: topology_checks_error_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: vertexlabel; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: error_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topology_checks_error_log
    ADD CONSTRAINT error_log_pkey PRIMARY KEY (id);


--
-- Name: la_ext_resource_custom_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT la_ext_resource_custom_attribute_pkey PRIMARY KEY (customattributeid);


--
-- Name: la_ext_resource_custom_attributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT la_ext_resource_custom_attributevalue_pkey PRIMARY KEY (customattributevalueid);


--
-- Name: la_ext_resource_documentdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_pkey PRIMARY KEY (documentid);


--
-- Name: la_ext_resourceattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT la_ext_resourceattributevalue_pkey PRIMARY KEY (attributevalueid);


--
-- Name: la_ext_resourcelandclassificationmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT la_ext_resourcelandclassificationmapping_pkey PRIMARY KEY (landclassmappingid);


--
-- Name: la_ext_resourcepoiattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT la_ext_resourcepoiattributevalue_pkey PRIMARY KEY (poiattributevalueid);


--
-- Name: la_ext_workflowdef_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflowdef
    ADD CONSTRAINT la_ext_workflowdef_pkey PRIMARY KEY (workflowdefid);


--
-- Name: la_spatialunit_aoi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_aoi
    ADD CONSTRAINT la_spatialunit_aoi_pkey PRIMARY KEY (aoiid);


--
-- Name: la_spatialunit_land_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT la_spatialunit_land_pkey PRIMARY KEY (landid);


--
-- Name: la_spatialunit_resource_land_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT la_spatialunit_resource_land_pkey PRIMARY KEY (landid);


--
-- Name: la_spatialunit_resource_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT la_spatialunit_resource_line_pkey PRIMARY KEY (landid);


--
-- Name: la_spatialunit_resource_point_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT la_spatialunit_resource_point_pkey PRIMARY KEY (landid);


--
-- Name: parcelsplitidpk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_parcelsplitland
    ADD CONSTRAINT parcelsplitidpk PRIMARY KEY (parcelsplitid);


--
-- Name: pk_la_baunit_landsoilquality; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landsoilquality
    ADD CONSTRAINT pk_la_baunit_landsoilquality PRIMARY KEY (landsoilqualityid);


--
-- Name: pk_la_baunit_landtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landtype
    ADD CONSTRAINT pk_la_baunit_landtype PRIMARY KEY (landtypeid);


--
-- Name: pk_la_baunit_landusetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_baunit_landusetype
    ADD CONSTRAINT pk_la_baunit_landusetype PRIMARY KEY (landusetypeid);


--
-- Name: pk_la_ext_applicationstatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_applicationstatus
    ADD CONSTRAINT pk_la_ext_applicationstatus PRIMARY KEY (applicationstatusid);


--
-- Name: pk_la_ext_attribute; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attribute
    ADD CONSTRAINT pk_la_ext_attribute PRIMARY KEY (attributeid);


--
-- Name: pk_la_ext_attributecategory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributecategory
    ADD CONSTRAINT pk_la_ext_attributecategory PRIMARY KEY (attributecategoryid);


--
-- Name: pk_la_ext_attributedatatype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributedatatype
    ADD CONSTRAINT pk_la_ext_attributedatatype PRIMARY KEY (datatypemasterid);


--
-- Name: pk_la_ext_attributemaster; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT pk_la_ext_attributemaster PRIMARY KEY (attributemasterid);


--
-- Name: pk_la_ext_attributeoptions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributeoptions
    ADD CONSTRAINT pk_la_ext_attributeoptions PRIMARY KEY (attributeoptionsid);


--
-- Name: pk_la_ext_baselayer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_baselayer
    ADD CONSTRAINT pk_la_ext_baselayer PRIMARY KEY (baselayerid);


--
-- Name: pk_la_ext_bookmark; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_bookmark
    ADD CONSTRAINT pk_la_ext_bookmark PRIMARY KEY (bookmarkid);


--
-- Name: pk_la_ext_categorytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_categorytype
    ADD CONSTRAINT pk_la_ext_categorytype PRIMARY KEY (categorytypeid);


--
-- Name: pk_la_ext_customattributeoptions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_customattributeoptions
    ADD CONSTRAINT pk_la_ext_customattributeoptions PRIMARY KEY (attributeoptionsid);


--
-- Name: pk_la_ext_disputeid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT pk_la_ext_disputeid PRIMARY KEY (disputeid);


--
-- Name: pk_la_ext_disputelandmapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT pk_la_ext_disputelandmapping PRIMARY KEY (disputelandid);


--
-- Name: pk_la_ext_disputestatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputestatus
    ADD CONSTRAINT pk_la_ext_disputestatus PRIMARY KEY (disputestatusid);


--
-- Name: pk_la_ext_disputetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputetype
    ADD CONSTRAINT pk_la_ext_disputetype PRIMARY KEY (disputetypeid);


--
-- Name: pk_la_ext_documentdetails; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT pk_la_ext_documentdetails PRIMARY KEY (documentid);


--
-- Name: pk_la_ext_documentformat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentformat
    ADD CONSTRAINT pk_la_ext_documentformat PRIMARY KEY (documentformatid);


--
-- Name: pk_la_ext_documenttype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documenttype
    ADD CONSTRAINT pk_la_ext_documenttype PRIMARY KEY (documenttypeid);


--
-- Name: pk_la_ext_existingclaim_documentdetails; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_existingclaim_documentdetails
    ADD CONSTRAINT pk_la_ext_existingclaim_documentdetails PRIMARY KEY (claimdocumentid);


--
-- Name: pk_la_ext_financialagency; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_financialagency
    ADD CONSTRAINT pk_la_ext_financialagency PRIMARY KEY (financialagencyid);


--
-- Name: pk_la_ext_geometrytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_geometrytype
    ADD CONSTRAINT pk_la_ext_geometrytype PRIMARY KEY (geometrytypeid);


--
-- Name: pk_la_ext_grouptype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_grouptype
    ADD CONSTRAINT pk_la_ext_grouptype PRIMARY KEY (grouptypeid);


--
-- Name: pk_la_ext_landapplicationstatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landapplicationstatus
    ADD CONSTRAINT pk_la_ext_landapplicationstatus PRIMARY KEY (landapplicationstatusid);


--
-- Name: pk_la_ext_landworkflowhistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT pk_la_ext_landworkflowhistory PRIMARY KEY (landworkflowhistoryid);


--
-- Name: pk_la_ext_layer_layergroup; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT pk_la_ext_layer_layergroup PRIMARY KEY (layer_layergroupid);


--
-- Name: pk_la_ext_layerfield; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layerfield
    ADD CONSTRAINT pk_la_ext_layerfield PRIMARY KEY (layerfieldid);


--
-- Name: pk_la_ext_layergroup; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layergroup
    ADD CONSTRAINT pk_la_ext_layergroup PRIMARY KEY (layergroupid);


--
-- Name: pk_la_ext_layertype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layertype
    ADD CONSTRAINT pk_la_ext_layertype PRIMARY KEY (layertypeid);


--
-- Name: pk_la_ext_module; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_module
    ADD CONSTRAINT pk_la_ext_module PRIMARY KEY (moduleid);


--
-- Name: pk_la_ext_month; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_month
    ADD CONSTRAINT pk_la_ext_month PRIMARY KEY (monthid);


--
-- Name: pk_la_ext_personlandmapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT pk_la_ext_personlandmapping PRIMARY KEY (personlandid);


--
-- Name: pk_la_ext_process; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_process
    ADD CONSTRAINT pk_la_ext_process PRIMARY KEY (processid);


--
-- Name: pk_la_ext_projectadjudicator; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectadjudicator
    ADD CONSTRAINT pk_la_ext_projectadjudicator PRIMARY KEY (projectadjudicatorid);


--
-- Name: pk_la_ext_projectarea; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT pk_la_ext_projectarea PRIMARY KEY (projectareaid);


--
-- Name: pk_la_ext_projectbaselayermapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT pk_la_ext_projectbaselayermapping PRIMARY KEY (projectbaselayerid);


--
-- Name: pk_la_ext_projectfile; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT pk_la_ext_projectfile PRIMARY KEY (projectfileid);


--
-- Name: pk_la_ext_projecthamlet; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projecthamlet
    ADD CONSTRAINT pk_la_ext_projecthamlet PRIMARY KEY (projecthamletid);


--
-- Name: pk_la_ext_projection; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projection
    ADD CONSTRAINT pk_la_ext_projection PRIMARY KEY (projectionid);


--
-- Name: pk_la_ext_projectlayergroupmapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT pk_la_ext_projectlayergroupmapping PRIMARY KEY (projectlayergroupid);


--
-- Name: pk_la_ext_resourceclassification; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourceclassification
    ADD CONSTRAINT pk_la_ext_resourceclassification PRIMARY KEY (classificationid);


--
-- Name: pk_la_ext_resourcepoiattributemaster; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcepoiattributemaster
    ADD CONSTRAINT pk_la_ext_resourcepoiattributemaster PRIMARY KEY (poiattributemasterid);


--
-- Name: pk_la_ext_resourcesubclassification; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT pk_la_ext_resourcesubclassification PRIMARY KEY (subclassificationid);


--
-- Name: pk_la_ext_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_role
    ADD CONSTRAINT pk_la_ext_role PRIMARY KEY (roleid);


--
-- Name: pk_la_ext_rolemodulemapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT pk_la_ext_rolemodulemapping PRIMARY KEY (rolemoduleid);


--
-- Name: pk_la_ext_slopevalue; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_slopevalue
    ADD CONSTRAINT pk_la_ext_slopevalue PRIMARY KEY (slopevalueid);


--
-- Name: pk_la_ext_surveyprojectattributes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT pk_la_ext_surveyprojectattributes PRIMARY KEY (surveyprojectattributesid);


--
-- Name: pk_la_ext_transactiondetails; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT pk_la_ext_transactiondetails PRIMARY KEY (transactionid);


--
-- Name: pk_la_ext_unit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_unit
    ADD CONSTRAINT pk_la_ext_unit PRIMARY KEY (unitid);


--
-- Name: pk_la_ext_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_user
    ADD CONSTRAINT pk_la_ext_user PRIMARY KEY (userid);


--
-- Name: pk_la_ext_userprojectmapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT pk_la_ext_userprojectmapping PRIMARY KEY (userprojectid);


--
-- Name: pk_la_ext_userrolemapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT pk_la_ext_userrolemapping PRIMARY KEY (userroleid);


--
-- Name: pk_la_ext_workflow; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflow
    ADD CONSTRAINT pk_la_ext_workflow PRIMARY KEY (workflowid);


--
-- Name: pk_la_ext_workflowactionmapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT pk_la_ext_workflowactionmapping PRIMARY KEY (workflowactionid);


--
-- Name: pk_la_lease; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_lease
    ADD CONSTRAINT pk_la_lease PRIMARY KEY (leaseid);


--
-- Name: pk_la_mortgage; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_mortgage
    ADD CONSTRAINT pk_la_mortgage PRIMARY KEY (mortgageid);


--
-- Name: pk_la_party; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party
    ADD CONSTRAINT pk_la_party PRIMARY KEY (partyid);


--
-- Name: pk_la_party_deceasedperson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT pk_la_party_deceasedperson PRIMARY KEY (partyid);


--
-- Name: pk_la_party_organization; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT pk_la_party_organization PRIMARY KEY (organizationid);


--
-- Name: pk_la_party_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT pk_la_party_person PRIMARY KEY (personid);


--
-- Name: pk_la_partygroup_citizenship; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_citizenship
    ADD CONSTRAINT pk_la_partygroup_citizenship PRIMARY KEY (citizenshipid);


--
-- Name: pk_la_partygroup_educationlevel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_educationlevel
    ADD CONSTRAINT pk_la_partygroup_educationlevel PRIMARY KEY (educationlevelid);


--
-- Name: pk_la_partygroup_ethnicity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_ethnicity
    ADD CONSTRAINT pk_la_partygroup_ethnicity PRIMARY KEY (ethnicityid);


--
-- Name: pk_la_partygroup_gender; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_gender
    ADD CONSTRAINT pk_la_partygroup_gender PRIMARY KEY (genderid);


--
-- Name: pk_la_partygroup_identitytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_identitytype
    ADD CONSTRAINT pk_la_partygroup_identitytype PRIMARY KEY (identitytypeid);


--
-- Name: pk_la_partygroup_maritalstatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_maritalstatus
    ADD CONSTRAINT pk_la_partygroup_maritalstatus PRIMARY KEY (maritalstatusid);


--
-- Name: pk_la_partygroup_occupation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_occupation
    ADD CONSTRAINT pk_la_partygroup_occupation PRIMARY KEY (occupationid);


--
-- Name: pk_la_partygroup_persontype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_persontype
    ADD CONSTRAINT pk_la_partygroup_persontype PRIMARY KEY (persontypeid);


--
-- Name: pk_la_partygroup_relationshiptype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_relationshiptype
    ADD CONSTRAINT pk_la_partygroup_relationshiptype PRIMARY KEY (relationshiptypeid);


--
-- Name: pk_la_partygroup_resident; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_partygroup_resident
    ADD CONSTRAINT pk_la_partygroup_resident PRIMARY KEY (residentid);


--
-- Name: pk_la_right_acquisitiontype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_acquisitiontype
    ADD CONSTRAINT pk_la_right_acquisitiontype PRIMARY KEY (acquisitiontypeid);


--
-- Name: pk_la_right_claimtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_claimtype
    ADD CONSTRAINT pk_la_right_claimtype PRIMARY KEY (claimtypeid);


--
-- Name: pk_la_right_landsharetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_landsharetype
    ADD CONSTRAINT pk_la_right_landsharetype PRIMARY KEY (landsharetypeid);


--
-- Name: pk_la_right_tenureclass; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_right_tenureclass
    ADD CONSTRAINT pk_la_right_tenureclass PRIMARY KEY (tenureclassid);


--
-- Name: pk_la_rrr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr
    ADD CONSTRAINT pk_la_rrr PRIMARY KEY (rrrid);


--
-- Name: pk_la_spatialsource_layer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT pk_la_spatialsource_layer PRIMARY KEY (layerid);


--
-- Name: pk_la_spatialsource_projectname; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT pk_la_spatialsource_projectname PRIMARY KEY (projectnameid);


--
-- Name: pk_la_spatialunitgroup; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup
    ADD CONSTRAINT pk_la_spatialunitgroup PRIMARY KEY (spatialunitgroupid);


--
-- Name: pk_la_spatialunitgroup_hierarchy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT pk_la_spatialunitgroup_hierarchy PRIMARY KEY (hierarchyid);


--
-- Name: pk_la_surrenderlease; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_surrenderlease
    ADD CONSTRAINT pk_la_surrenderlease PRIMARY KEY (leaseid);


--
-- Name: pk_layer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_layer
    ADD CONSTRAINT pk_layer PRIMARY KEY (alias);


--
-- Name: primary_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vertexlabel
    ADD CONSTRAINT primary_key PRIMARY KEY (gid);


--
-- Name: spatialunit_personwithinterest_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_spatialunit_personwithinterest
    ADD CONSTRAINT spatialunit_personwithinterest_pk PRIMARY KEY (id);


--
-- Name: PK_Layer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "PK_Layer" ON la_layer USING btree (alias);

ALTER TABLE la_layer CLUSTER ON "PK_Layer";


--
-- Name: client_update_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER client_update_trigger BEFORE UPDATE ON la_spatialunit_land FOR EACH ROW EXECUTE PROCEDURE check_id_change();


--
-- Name: update_area; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_area AFTER INSERT ON la_spatialunit_land FOR EACH ROW EXECUTE PROCEDURE update_area();


--
-- Name: update_geometryarea; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_geometryarea AFTER UPDATE ON la_spatialunit_land FOR EACH ROW EXECUTE PROCEDURE updatearea();


--
-- Name: update_geometryarea_resourceland; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_geometryarea_resourceland AFTER UPDATE ON la_spatialunit_resource_land FOR EACH ROW EXECUTE PROCEDURE updatearea_resourceland();


--
-- Name: fk_la_ext_attribute_attributemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attribute
    ADD CONSTRAINT fk_la_ext_attribute_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);


--
-- Name: fk_la_ext_attributecategory_categorytypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributecategory
    ADD CONSTRAINT fk_la_ext_attributecategory_categorytypeid FOREIGN KEY (categorytypeid) REFERENCES la_ext_categorytype(categorytypeid);


--
-- Name: fk_la_ext_attributemaster_attributecategoryid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);


--
-- Name: fk_la_ext_attributemaster_attributemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT fk_la_ext_attributemaster_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);


--
-- Name: fk_la_ext_attributemaster_datatypemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);


--
-- Name: fk_la_ext_attributeoptions_attributemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attributeoptions
    ADD CONSTRAINT fk_la_ext_attributeoptions_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);


--
-- Name: fk_la_ext_bookmark_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_bookmark
    ADD CONSTRAINT fk_la_ext_bookmark_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_customattributeoptions_customattributeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_customattributeoptions
    ADD CONSTRAINT fk_la_ext_customattributeoptions_customattributeid FOREIGN KEY (customattributeid) REFERENCES la_ext_resource_custom_attribute(customattributeid);


--
-- Name: fk_la_ext_disputeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputeid FOREIGN KEY (disputeid) REFERENCES la_ext_dispute(disputeid);


--
-- Name: fk_la_ext_disputelandmapping_disputetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_disputelandmapping_disputetypeid FOREIGN KEY (disputetypeid) REFERENCES la_ext_disputetype(disputetypeid);


--
-- Name: fk_la_ext_disputelandmapping_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_spatialunit_personwithinterest
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_disputelandmapping_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_disputelandmapping_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_disputelandmapping_partyid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


--
-- Name: fk_la_ext_disputelandmapping_persontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


--
-- Name: fk_la_ext_documentdetails_documentformatid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


--
-- Name: fk_la_ext_documentdetails_documenttypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_documenttypeid FOREIGN KEY (documenttypeid) REFERENCES la_ext_documenttype(documenttypeid);


--
-- Name: fk_la_ext_documentdetails_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_documentdetails_partyid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


--
-- Name: fk_la_ext_documentdetails_transactionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);


--
-- Name: fk_la_ext_existingclaim_documentdetails_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_existingclaim_documentdetails
    ADD CONSTRAINT fk_la_ext_existingclaim_documentdetails_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_la_ext_disputestatus; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_la_ext_disputestatus FOREIGN KEY (disputestatusid) REFERENCES la_ext_disputestatus(disputestatusid);


--
-- Name: fk_la_ext_landworkflowhistory_applicationstatusid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT fk_la_ext_landworkflowhistory_applicationstatusid FOREIGN KEY (applicationstatusid) REFERENCES la_ext_applicationstatus(applicationstatusid);


--
-- Name: fk_la_ext_landworkflowhistory_land; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT fk_la_ext_landworkflowhistory_land FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_layer_layergroup_layergroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT fk_la_ext_layer_layergroup_layergroupid FOREIGN KEY (layergroupid) REFERENCES la_ext_layergroup(layergroupid);


--
-- Name: fk_la_ext_layer_layergroup_layerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT fk_la_ext_layer_layergroup_layerid FOREIGN KEY (layerid) REFERENCES la_spatialsource_layer(layerid);


--
-- Name: fk_la_ext_layerfield_layerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_layerfield
    ADD CONSTRAINT fk_la_ext_layerfield_layerid FOREIGN KEY (layerid) REFERENCES la_spatialsource_layer(layerid);


--
-- Name: fk_la_ext_personlandmapping_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_ext_personlandmapping_partyid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


--
-- Name: fk_la_ext_personlandmapping_persontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


--
-- Name: fk_la_ext_personlandmapping_transactionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);


--
-- Name: fk_la_ext_personlandmapping_transactionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);


--
-- Name: fk_la_ext_projectarea_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_ext_projectarea_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_ext_projectarea_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_ext_projectarea_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_ext_projectarea_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_ext_projectarea_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_projectarea_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT fk_la_ext_projectarea_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_projectarea_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_ext_projectarea_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_ext_projectarea_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_ext_projectarea_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_ext_projectarea_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_ext_projectbaselayermapping_baselayerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT fk_la_ext_projectbaselayermapping_baselayerid FOREIGN KEY (baselayerid) REFERENCES la_ext_baselayer(baselayerid);


--
-- Name: fk_la_ext_projectbaselayermapping_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT fk_la_ext_projectbaselayermapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_projectfile_documentformatid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT fk_la_ext_projectfile_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


--
-- Name: fk_la_ext_projectlayergroupmapping_layergroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT fk_la_ext_projectlayergroupmapping_layergroupid FOREIGN KEY (layergroupid) REFERENCES la_ext_layergroup(layergroupid);


--
-- Name: fk_la_ext_projectlayergroupmapping_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT fk_la_ext_projectlayergroupmapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_resource_custom_attribute_attributecategoryid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);


--
-- Name: fk_la_ext_resource_custom_attribute_customattributeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_customattributeid FOREIGN KEY (customattributeid) REFERENCES la_ext_resource_custom_attribute(customattributeid);


--
-- Name: fk_la_ext_resource_custom_attribute_datatypemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);


--
-- Name: fk_la_ext_resource_custom_attribute_projectid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_resource_custom_attributevalue_projectid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT fk_la_ext_resource_custom_attributevalue_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_resourcelandclassificationmapping_classificationid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_classificationid FOREIGN KEY (classificationid) REFERENCES la_ext_resourceclassification(classificationid);


--
-- Name: fk_la_ext_resourcelandclassificationmapping_landclassmappingid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_landclassmappingid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_resourcelandclassificationmapping_subclassificationid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_subclassificationid FOREIGN KEY (subclassificationid) REFERENCES la_ext_resourcesubclassification(subclassificationid);


--
-- Name: fk_la_ext_resourcepoiattributemaster_datatypemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcepoiattributemaster
    ADD CONSTRAINT fk_la_ext_resourcepoiattributemaster_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);


--
-- Name: fk_la_ext_resourcepoiattributevalue_attributemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT fk_la_ext_resourcepoiattributevalue_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_resourcepoiattributemaster(poiattributemasterid);


--
-- Name: fk_la_ext_resourcepoiattributevalue_projectid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT fk_la_ext_resourcepoiattributevalue_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_resourcesubclassification_classificationid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT fk_la_ext_resourcesubclassification_classificationid FOREIGN KEY (classificationid) REFERENCES la_ext_resourceclassification(classificationid);


--
-- Name: fk_la_ext_resourcesubclassification_geometrytypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT fk_la_ext_resourcesubclassification_geometrytypeid FOREIGN KEY (geometrytypeid) REFERENCES la_ext_geometrytype(geometrytypeid);


--
-- Name: fk_la_ext_rolemodulemapping_moduleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT fk_la_ext_rolemodulemapping_moduleid FOREIGN KEY (moduleid) REFERENCES la_ext_module(moduleid);


--
-- Name: fk_la_ext_rolemodulemapping_roleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT fk_la_ext_rolemodulemapping_roleid FOREIGN KEY (roleid) REFERENCES la_ext_role(roleid);


--
-- Name: fk_la_ext_surveyprojectattributes_attributecategoryid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);


--
-- Name: fk_la_ext_surveyprojectattributes_attributemasterid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);


--
-- Name: fk_la_ext_surveyprojectattributes_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_transactiondetails_applicationstatusid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT fk_la_ext_transactiondetails_applicationstatusid FOREIGN KEY (applicationstatusid) REFERENCES la_ext_applicationstatus(applicationstatusid);


--
-- Name: fk_la_ext_transactiondetails_processid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT fk_la_ext_transactiondetails_processid FOREIGN KEY (processid) REFERENCES la_ext_process(processid);


--
-- Name: fk_la_ext_user_genderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_user
    ADD CONSTRAINT fk_la_ext_user_genderid FOREIGN KEY (genderid) REFERENCES la_partygroup_gender(genderid);


--
-- Name: fk_la_ext_userprojectmapping_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT fk_la_ext_userprojectmapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_ext_userprojectmapping_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT fk_la_ext_userprojectmapping_userid FOREIGN KEY (userid) REFERENCES la_ext_user(userid);


--
-- Name: fk_la_ext_userrolemapping_roleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT fk_la_ext_userrolemapping_roleid FOREIGN KEY (roleid) REFERENCES la_ext_role(roleid);


--
-- Name: fk_la_ext_userrolemapping_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT fk_la_ext_userrolemapping_userid FOREIGN KEY (userid) REFERENCES la_ext_user(userid);


--
-- Name: fk_la_ext_workflow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT fk_la_ext_workflow FOREIGN KEY (workflowid) REFERENCES la_ext_workflow(workflowid);


--
-- Name: fk_la_ext_workflow_workflowdefid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflow
    ADD CONSTRAINT fk_la_ext_workflow_workflowdefid FOREIGN KEY (workflowdefid) REFERENCES la_ext_workflowdef(workflowdefid);


--
-- Name: fk_la_ext_workflowactionmapping_workflowid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT fk_la_ext_workflowactionmapping_workflowid FOREIGN KEY (workflowid) REFERENCES la_ext_workflow(workflowid);


--
-- Name: fk_la_lease_monthid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_lease
    ADD CONSTRAINT fk_la_lease_monthid FOREIGN KEY (monthid) REFERENCES la_ext_month(monthid);


--
-- Name: fk_la_lease_monthid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_surrenderlease
    ADD CONSTRAINT fk_la_lease_monthid FOREIGN KEY (monthid) REFERENCES la_ext_month(monthid);


--
-- Name: fk_la_mortgage_mortgageid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_rrr_mortgage
    ADD CONSTRAINT fk_la_mortgage_mortgageid FOREIGN KEY (financialagencyid) REFERENCES la_ext_financialagency(financialagencyid);


--
-- Name: fk_la_party_deceasedperson_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: fk_la_party_deceasedperson_partyid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


--
-- Name: fk_la_party_deceasedperson_persontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


--
-- Name: fk_la_party_organization_grouptypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_grouptypeid FOREIGN KEY (grouptypeid) REFERENCES la_ext_grouptype(grouptypeid);


--
-- Name: fk_la_party_organization_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_organization_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_organization_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_organization_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_organization_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_organization_identitytypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_identitytypeid FOREIGN KEY (identitytypeid) REFERENCES la_partygroup_identitytype(identitytypeid);


--
-- Name: fk_la_party_organization_organizationid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_organizationid FOREIGN KEY (organizationid) REFERENCES la_party(partyid);


--
-- Name: fk_la_party_organization_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_organization_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_organization_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_organization_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_organization_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_educationlevelid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_educationlevelid FOREIGN KEY (educationlevelid) REFERENCES la_partygroup_educationlevel(educationlevelid);


--
-- Name: fk_la_party_person_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_person_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_person_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_person_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_person_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_party_person_identitytypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_identitytypeid FOREIGN KEY (identitytypeid) REFERENCES la_partygroup_identitytype(identitytypeid);


--
-- Name: fk_la_party_person_maritalstatusid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_maritalstatusid FOREIGN KEY (maritalstatusid) REFERENCES la_partygroup_maritalstatus(maritalstatusid);


--
-- Name: fk_la_party_person_occupationid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_occupationid FOREIGN KEY (occupationid) REFERENCES la_partygroup_occupation(occupationid);


--
-- Name: fk_la_party_person_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_personid FOREIGN KEY (personid) REFERENCES la_party(partyid);


--
-- Name: fk_la_party_person_relationshiptypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_relationshiptypeid FOREIGN KEY (relationshiptypeid) REFERENCES la_partygroup_relationshiptype(relationshiptypeid);


--
-- Name: fk_la_party_person_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_party_person_tenureclassid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


--
-- Name: fk_la_partygroup_persontype_persontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party
    ADD CONSTRAINT fk_la_partygroup_persontype_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


--
-- Name: fk_la_spatialsource_layer_documentformatid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


--
-- Name: fk_la_spatialsource_layer_layertypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_layertypeid FOREIGN KEY (layertypeid) REFERENCES la_ext_layertype(layertypeid);


--
-- Name: fk_la_spatialsource_layer_projectionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_projectionid FOREIGN KEY (projectionid) REFERENCES la_ext_projection(projectionid);


--
-- Name: fk_la_spatialsource_layer_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialsource_projectname_documentformatid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


--
-- Name: fk_la_spatialsource_projectname_projectid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT fk_la_spatialsource_projectname_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_spatialsource_projectname_projectionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_projectionid FOREIGN KEY (projectionid) REFERENCES la_ext_projection(projectionid);


--
-- Name: fk_la_spatialsource_projectname_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialunit_land_acquisitiontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);


--
-- Name: fk_la_spatialunit_land_acquisitiontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);


--
-- Name: fk_la_spatialunit_land_acquisitiontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);


--
-- Name: fk_la_spatialunit_land_acquisitiontypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);


--
-- Name: fk_la_spatialunit_land_claimtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);


--
-- Name: fk_la_spatialunit_land_claimtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);


--
-- Name: fk_la_spatialunit_land_claimtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);


--
-- Name: fk_la_spatialunit_land_claimtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);


--
-- Name: fk_la_spatialunit_land_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_hierarchyid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: fk_la_spatialunit_land_landsharetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);


--
-- Name: fk_la_spatialunit_land_landsharetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);


--
-- Name: fk_la_spatialunit_land_landsharetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);


--
-- Name: fk_la_spatialunit_land_landsharetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);


--
-- Name: fk_la_spatialunit_land_landsoilqualityid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


--
-- Name: fk_la_spatialunit_land_landsoilqualityid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


--
-- Name: fk_la_spatialunit_land_landsoilqualityid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


--
-- Name: fk_la_spatialunit_land_landsoilqualityid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


--
-- Name: fk_la_spatialunit_land_landtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


--
-- Name: fk_la_spatialunit_land_landtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


--
-- Name: fk_la_spatialunit_land_landtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


--
-- Name: fk_la_spatialunit_land_landtypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


--
-- Name: fk_la_spatialunit_land_landusetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);


--
-- Name: fk_la_spatialunit_land_landusetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);


--
-- Name: fk_la_spatialunit_land_landusetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);


--
-- Name: fk_la_spatialunit_land_landusetypeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);


--
-- Name: fk_la_spatialunit_land_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_spatialunit_land_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_spatialunit_land_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_spatialunit_land_projectnameid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


--
-- Name: fk_la_spatialunit_land_proposedused; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_proposedused FOREIGN KEY (proposedused) REFERENCES la_baunit_landusetype(landusetypeid);


--
-- Name: fk_la_spatialunit_land_slopevalueid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


--
-- Name: fk_la_spatialunit_land_slopevalueid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


--
-- Name: fk_la_spatialunit_land_slopevalueid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


--
-- Name: fk_la_spatialunit_land_slopevalueid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_spatialunitgroupid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_la_spatialunit_land_tenureclassid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


--
-- Name: fk_la_spatialunit_land_tenureclassid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


--
-- Name: fk_la_spatialunit_land_tenureclassid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


--
-- Name: fk_la_spatialunit_land_tenureclassid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


--
-- Name: fk_la_spatialunit_land_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialunit_land_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialunit_land_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialunit_land_unitid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


--
-- Name: fk_la_spatialunitgroup_hierarchy_spatialunitgroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT fk_la_spatialunitgroup_hierarchy_spatialunitgroupid FOREIGN KEY (spatialunitgroupid) REFERENCES la_spatialunitgroup(spatialunitgroupid);


--
-- Name: fk_pk_la_ext_landapplicationstatus_landid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_landapplicationstatus
    ADD CONSTRAINT fk_pk_la_ext_landapplicationstatus_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


--
-- Name: la_ext_resource_documentdetails_documentformatid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_documentformatid_fkey FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


--
-- Name: la_ext_resource_documentdetails_documenttypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_documenttypeid_fkey FOREIGN KEY (documenttypeid) REFERENCES la_ext_documenttype(documenttypeid);


--
-- Name: la_spatialunitgroup_hierarchy_uperhierarchy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT la_spatialunitgroup_hierarchy_uperhierarchy FOREIGN KEY (hierarchyid) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: la_baunit_landsoilquality; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_baunit_landsoilquality FROM PUBLIC;
REVOKE ALL ON TABLE la_baunit_landsoilquality FROM postgres;
GRANT ALL ON TABLE la_baunit_landsoilquality TO postgres;


--
-- Name: la_baunit_landtype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_baunit_landtype FROM PUBLIC;
REVOKE ALL ON TABLE la_baunit_landtype FROM postgres;
GRANT ALL ON TABLE la_baunit_landtype TO postgres;


--
-- Name: la_baunit_landusetype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_baunit_landusetype FROM PUBLIC;
REVOKE ALL ON TABLE la_baunit_landusetype FROM postgres;
GRANT ALL ON TABLE la_baunit_landusetype TO postgres;

--
-- Name: la_ext_applicationstatus; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_applicationstatus FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_applicationstatus FROM postgres;
GRANT ALL ON TABLE la_ext_applicationstatus TO postgres;


--
-- Name: la_ext_attribute; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_attribute FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_attribute FROM postgres;
GRANT ALL ON TABLE la_ext_attribute TO postgres;


--
-- Name: la_ext_attributecategory; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_attributecategory FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_attributecategory FROM postgres;
GRANT ALL ON TABLE la_ext_attributecategory TO postgres;


--
-- Name: la_ext_attributedatatype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_attributedatatype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_attributedatatype FROM postgres;
GRANT ALL ON TABLE la_ext_attributedatatype TO postgres;


--
-- Name: la_ext_attributemaster; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_attributemaster FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_attributemaster FROM postgres;
GRANT ALL ON TABLE la_ext_attributemaster TO postgres;

--
-- Name: la_ext_attributeoptions; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_attributeoptions FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_attributeoptions FROM postgres;
GRANT ALL ON TABLE la_ext_attributeoptions TO postgres;

--
-- Name: la_ext_baselayer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_baselayer FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_baselayer FROM postgres;
GRANT ALL ON TABLE la_ext_baselayer TO postgres;


--
-- Name: la_ext_bookmark; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_bookmark FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_bookmark FROM postgres;
GRANT ALL ON TABLE la_ext_bookmark TO postgres;

--
-- Name: la_ext_categorytype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_categorytype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_categorytype FROM postgres;
GRANT ALL ON TABLE la_ext_categorytype TO postgres;


--
-- Name: la_ext_customattributeoptions; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_customattributeoptions FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_customattributeoptions FROM postgres;
GRANT ALL ON TABLE la_ext_customattributeoptions TO postgres;


--
-- Name: la_ext_dispute; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_dispute FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_dispute FROM postgres;
GRANT ALL ON TABLE la_ext_dispute TO postgres;

--
-- Name: la_ext_disputelandmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_disputelandmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_disputelandmapping FROM postgres;
GRANT ALL ON TABLE la_ext_disputelandmapping TO postgres;

--
-- Name: la_ext_disputestatus; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_disputestatus FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_disputestatus FROM postgres;
GRANT ALL ON TABLE la_ext_disputestatus TO postgres;


--
-- Name: la_ext_disputetype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_disputetype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_disputetype FROM postgres;
GRANT ALL ON TABLE la_ext_disputetype TO postgres;

--
-- Name: la_ext_documentdetails; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_documentdetails FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_documentdetails FROM postgres;
GRANT ALL ON TABLE la_ext_documentdetails TO postgres;


--
-- Name: la_ext_documentformat; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_documentformat FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_documentformat FROM postgres;
GRANT ALL ON TABLE la_ext_documentformat TO postgres;


--
-- Name: la_ext_documenttype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_documenttype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_documenttype FROM postgres;
GRANT ALL ON TABLE la_ext_documenttype TO postgres;


--
-- Name: la_ext_existingclaim_documentdetails; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_existingclaim_documentdetails FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_existingclaim_documentdetails FROM postgres;
GRANT ALL ON TABLE la_ext_existingclaim_documentdetails TO postgres;


--
-- Name: la_ext_financialagency; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_financialagency FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_financialagency FROM postgres;
GRANT ALL ON TABLE la_ext_financialagency TO postgres;


--
-- Name: la_ext_geometrytype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_geometrytype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_geometrytype FROM postgres;
GRANT ALL ON TABLE la_ext_geometrytype TO postgres;


--
-- Name: la_ext_grouptype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_grouptype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_grouptype FROM postgres;
GRANT ALL ON TABLE la_ext_grouptype TO postgres;


--
-- Name: la_ext_landworkflowhistory; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_landworkflowhistory FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_landworkflowhistory FROM postgres;
GRANT ALL ON TABLE la_ext_landworkflowhistory TO postgres;

--
-- Name: la_ext_layer_layergroup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_layer_layergroup FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_layer_layergroup FROM postgres;
GRANT ALL ON TABLE la_ext_layer_layergroup TO postgres;

--
-- Name: la_ext_layerfield; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_layerfield FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_layerfield FROM postgres;
GRANT ALL ON TABLE la_ext_layerfield TO postgres;

--
-- Name: la_ext_layergroup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_layergroup FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_layergroup FROM postgres;
GRANT ALL ON TABLE la_ext_layergroup TO postgres;

--
-- Name: la_ext_layertype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_layertype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_layertype FROM postgres;
GRANT ALL ON TABLE la_ext_layertype TO postgres;
--
-- Name: la_ext_module; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_module FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_module FROM postgres;
GRANT ALL ON TABLE la_ext_module TO postgres;

--
-- Name: la_ext_month; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_month FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_month FROM postgres;
GRANT ALL ON TABLE la_ext_month TO postgres;

--
-- Name: la_ext_parcelsplitland; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_parcelsplitland FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_parcelsplitland FROM postgres;
GRANT ALL ON TABLE la_ext_parcelsplitland TO postgres;

--
-- Name: la_ext_personlandmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_personlandmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_personlandmapping FROM postgres;
GRANT ALL ON TABLE la_ext_personlandmapping TO postgres;

--
-- Name: la_ext_process; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_process FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_process FROM postgres;
GRANT ALL ON TABLE la_ext_process TO postgres;

--
-- Name: la_ext_projectadjudicator; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projectadjudicator FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projectadjudicator FROM postgres;
GRANT ALL ON TABLE la_ext_projectadjudicator TO postgres;

--
-- Name: la_ext_projectarea; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projectarea FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projectarea FROM postgres;
GRANT ALL ON TABLE la_ext_projectarea TO postgres;

--
-- Name: la_ext_projectbaselayermapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projectbaselayermapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projectbaselayermapping FROM postgres;
GRANT ALL ON TABLE la_ext_projectbaselayermapping TO postgres;

--
-- Name: la_ext_projectfile; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projectfile FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projectfile FROM postgres;
GRANT ALL ON TABLE la_ext_projectfile TO postgres;

--
-- Name: la_ext_projecthamlet; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projecthamlet FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projecthamlet FROM postgres;
GRANT ALL ON TABLE la_ext_projecthamlet TO postgres;

--
-- Name: la_ext_projection; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projection FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projection FROM postgres;
GRANT ALL ON TABLE la_ext_projection TO postgres;

--
-- Name: la_ext_projectlayergroupmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_projectlayergroupmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_projectlayergroupmapping FROM postgres;
GRANT ALL ON TABLE la_ext_projectlayergroupmapping TO postgres;

--
-- Name: la_ext_registrationsharetype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_registrationsharetype FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_registrationsharetype FROM postgres;
GRANT ALL ON TABLE la_ext_registrationsharetype TO postgres;

--
-- Name: la_ext_resource_custom_attribute; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resource_custom_attribute FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resource_custom_attribute FROM postgres;
GRANT ALL ON TABLE la_ext_resource_custom_attribute TO postgres;

--
-- Name: la_ext_resource_custom_attributevalue; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resource_custom_attributevalue FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resource_custom_attributevalue FROM postgres;
GRANT ALL ON TABLE la_ext_resource_custom_attributevalue TO postgres;

--
-- Name: la_ext_resource_documentdetails; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resource_documentdetails FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resource_documentdetails FROM postgres;
GRANT ALL ON TABLE la_ext_resource_documentdetails TO postgres;

--
-- Name: la_ext_resourceattributevalue; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourceattributevalue FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourceattributevalue FROM postgres;
GRANT ALL ON TABLE la_ext_resourceattributevalue TO postgres;

--
-- Name: la_ext_resourceclassification; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourceclassification FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourceclassification FROM postgres;
GRANT ALL ON TABLE la_ext_resourceclassification TO postgres;

--
-- Name: la_ext_resourcelandclassificationmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourcelandclassificationmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourcelandclassificationmapping FROM postgres;
GRANT ALL ON TABLE la_ext_resourcelandclassificationmapping TO postgres;

--
-- Name: la_ext_resourcepoiattributemaster; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourcepoiattributemaster FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourcepoiattributemaster FROM postgres;
GRANT ALL ON TABLE la_ext_resourcepoiattributemaster TO postgres;

--
-- Name: la_ext_resourcepoiattributevalue; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourcepoiattributevalue FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourcepoiattributevalue FROM postgres;
GRANT ALL ON TABLE la_ext_resourcepoiattributevalue TO postgres;

--
-- Name: la_ext_resourcesubclassification; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_resourcesubclassification FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_resourcesubclassification FROM postgres;
GRANT ALL ON TABLE la_ext_resourcesubclassification TO postgres;

--
-- Name: la_ext_role; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_role FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_role FROM postgres;
GRANT ALL ON TABLE la_ext_role TO postgres;

--
-- Name: la_ext_rolemodulemapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_rolemodulemapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_rolemodulemapping FROM postgres;
GRANT ALL ON TABLE la_ext_rolemodulemapping TO postgres;

--
-- Name: la_ext_slopevalue; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_slopevalue FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_slopevalue FROM postgres;
GRANT ALL ON TABLE la_ext_slopevalue TO postgres;

--
-- Name: la_ext_spatialunit_personwithinterest; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_spatialunit_personwithinterest FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_spatialunit_personwithinterest FROM postgres;
GRANT ALL ON TABLE la_ext_spatialunit_personwithinterest TO postgres;

--
-- Name: la_ext_surveyprojectattributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_surveyprojectattributes FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_surveyprojectattributes FROM postgres;
GRANT ALL ON TABLE la_ext_surveyprojectattributes TO postgres;

--
-- Name: la_ext_transactiondetails; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_transactiondetails FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_transactiondetails FROM postgres;
GRANT ALL ON TABLE la_ext_transactiondetails TO postgres;

--
-- Name: la_ext_transactionhistory; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_transactionhistory FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_transactionhistory FROM postgres;
GRANT ALL ON TABLE la_ext_transactionhistory TO postgres;

--
-- Name: la_ext_unit; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_unit FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_unit FROM postgres;
GRANT ALL ON TABLE la_ext_unit TO postgres;

--
-- Name: la_ext_user; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_user FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_user FROM postgres;
GRANT ALL ON TABLE la_ext_user TO postgres;

--
-- Name: la_ext_userprojectmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_userprojectmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_userprojectmapping FROM postgres;
GRANT ALL ON TABLE la_ext_userprojectmapping TO postgres;

--
-- Name: la_ext_userrolemapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_userrolemapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_userrolemapping FROM postgres;
GRANT ALL ON TABLE la_ext_userrolemapping TO postgres;

--
-- Name: la_ext_workflow; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_workflow FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_workflow FROM postgres;
GRANT ALL ON TABLE la_ext_workflow TO postgres;

--
-- Name: la_ext_workflowactionmapping; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_workflowactionmapping FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_workflowactionmapping FROM postgres;
GRANT ALL ON TABLE la_ext_workflowactionmapping TO postgres;

--
-- Name: la_ext_workflowdef; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_ext_workflowdef FROM PUBLIC;
REVOKE ALL ON TABLE la_ext_workflowdef FROM postgres;
GRANT ALL ON TABLE la_ext_workflowdef TO postgres;

--
-- Name: la_layer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_layer FROM PUBLIC;
REVOKE ALL ON TABLE la_layer FROM postgres;
GRANT ALL ON TABLE la_layer TO postgres;

--
-- Name: la_party; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_party FROM PUBLIC;
REVOKE ALL ON TABLE la_party FROM postgres;
GRANT ALL ON TABLE la_party TO postgres;

--
-- Name: la_party_deceasedperson; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_party_deceasedperson FROM PUBLIC;
REVOKE ALL ON TABLE la_party_deceasedperson FROM postgres;
GRANT ALL ON TABLE la_party_deceasedperson TO postgres;

--
-- Name: la_party_organization; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_party_organization FROM PUBLIC;
REVOKE ALL ON TABLE la_party_organization FROM postgres;
GRANT ALL ON TABLE la_party_organization TO postgres;

--
-- Name: la_party_person; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_party_person FROM PUBLIC;
REVOKE ALL ON TABLE la_party_person FROM postgres;
GRANT ALL ON TABLE la_party_person TO postgres;

--
-- Name: la_partygroup_educationlevel; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_educationlevel FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_educationlevel FROM postgres;
GRANT ALL ON TABLE la_partygroup_educationlevel TO postgres;

--
-- Name: la_partygroup_gender; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_gender FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_gender FROM postgres;
GRANT ALL ON TABLE la_partygroup_gender TO postgres;

--
-- Name: la_partygroup_identitytype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_identitytype FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_identitytype FROM postgres;
GRANT ALL ON TABLE la_partygroup_identitytype TO postgres;

--
-- Name: la_partygroup_maritalstatus; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_maritalstatus FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_maritalstatus FROM postgres;
GRANT ALL ON TABLE la_partygroup_maritalstatus TO postgres;

--
-- Name: la_partygroup_occupation; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_occupation FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_occupation FROM postgres;
GRANT ALL ON TABLE la_partygroup_occupation TO postgres;

--
-- Name: la_partygroup_persontype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_persontype FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_persontype FROM postgres;
GRANT ALL ON TABLE la_partygroup_persontype TO postgres;

--
-- Name: la_partygroup_relationshiptype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_partygroup_relationshiptype FROM PUBLIC;
REVOKE ALL ON TABLE la_partygroup_relationshiptype FROM postgres;
GRANT ALL ON TABLE la_partygroup_relationshiptype TO postgres;

--
-- Name: la_right_acquisitiontype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_right_acquisitiontype FROM PUBLIC;
REVOKE ALL ON TABLE la_right_acquisitiontype FROM postgres;
GRANT ALL ON TABLE la_right_acquisitiontype TO postgres;

--
-- Name: la_right_claimtype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_right_claimtype FROM PUBLIC;
REVOKE ALL ON TABLE la_right_claimtype FROM postgres;
GRANT ALL ON TABLE la_right_claimtype TO postgres;

--
-- Name: la_right_landsharetype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_right_landsharetype FROM PUBLIC;
REVOKE ALL ON TABLE la_right_landsharetype FROM postgres;
GRANT ALL ON TABLE la_right_landsharetype TO postgres;

--
-- Name: la_right_tenureclass; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_right_tenureclass FROM PUBLIC;
REVOKE ALL ON TABLE la_right_tenureclass FROM postgres;
GRANT ALL ON TABLE la_right_tenureclass TO postgres;

--
-- Name: la_rrr; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_rrr FROM PUBLIC;
REVOKE ALL ON TABLE la_rrr FROM postgres;
GRANT ALL ON TABLE la_rrr TO postgres;

--
-- Name: la_rrr_lease; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_rrr_lease FROM PUBLIC;
REVOKE ALL ON TABLE la_rrr_lease FROM postgres;
GRANT ALL ON TABLE la_rrr_lease TO postgres;

--
-- Name: la_rrr_mortgage; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_rrr_mortgage FROM PUBLIC;
REVOKE ALL ON TABLE la_rrr_mortgage FROM postgres;
GRANT ALL ON TABLE la_rrr_mortgage TO postgres;

--
-- Name: la_rrr_surrenderlease; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_rrr_surrenderlease FROM PUBLIC;
REVOKE ALL ON TABLE la_rrr_surrenderlease FROM postgres;
GRANT ALL ON TABLE la_rrr_surrenderlease TO postgres;

--
-- Name: la_rrr_surrendermortgage; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_rrr_surrendermortgage FROM PUBLIC;
REVOKE ALL ON TABLE la_rrr_surrendermortgage FROM postgres;
GRANT ALL ON TABLE la_rrr_surrendermortgage TO postgres;

--
-- Name: la_spatialsource_layer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialsource_layer FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialsource_layer FROM postgres;
GRANT ALL ON TABLE la_spatialsource_layer TO postgres;

--
-- Name: la_spatialsource_projectname; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialsource_projectname FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialsource_projectname FROM postgres;
GRANT ALL ON TABLE la_spatialsource_projectname TO postgres;

--
-- Name: la_spatialunit_aoi; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunit_aoi FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunit_aoi FROM postgres;
GRANT ALL ON TABLE la_spatialunit_aoi TO postgres;

--
-- Name: la_spatialunit_land; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunit_land FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunit_land FROM postgres;
GRANT ALL ON TABLE la_spatialunit_land TO postgres;

--
-- Name: la_spatialunit_resource_land; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunit_resource_land FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunit_resource_land FROM postgres;
GRANT ALL ON TABLE la_spatialunit_resource_land TO postgres;

--
-- Name: la_spatialunit_resource_line; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunit_resource_line FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunit_resource_line FROM postgres;
GRANT ALL ON TABLE la_spatialunit_resource_line TO postgres;

--
-- Name: la_spatialunit_resource_point; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunit_resource_point FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunit_resource_point FROM postgres;
GRANT ALL ON TABLE la_spatialunit_resource_point TO postgres;

--
-- Name: la_spatialunitgroup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunitgroup FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunitgroup FROM postgres;
GRANT ALL ON TABLE la_spatialunitgroup TO postgres;

--
-- Name: la_spatialunitgroup_hierarchy; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE la_spatialunitgroup_hierarchy FROM PUBLIC;
REVOKE ALL ON TABLE la_spatialunitgroup_hierarchy FROM postgres;
GRANT ALL ON TABLE la_spatialunitgroup_hierarchy TO postgres;

--
-- Name: media_attributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE media_attributes FROM PUBLIC;
REVOKE ALL ON TABLE media_attributes FROM postgres;
GRANT ALL ON TABLE media_attributes TO postgres;

--
-- Name: natural_person_attributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE natural_person_attributes FROM PUBLIC;
REVOKE ALL ON TABLE natural_person_attributes FROM postgres;
GRANT ALL ON TABLE natural_person_attributes TO postgres;

--
-- Name: nonnatural_person_attributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE nonnatural_person_attributes FROM PUBLIC;
REVOKE ALL ON TABLE nonnatural_person_attributes FROM postgres;
GRANT ALL ON TABLE nonnatural_person_attributes TO postgres;

--
-- Name: right_attributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE right_attributes FROM PUBLIC;
REVOKE ALL ON TABLE right_attributes FROM postgres;
GRANT ALL ON TABLE right_attributes TO postgres;

--
-- Name: spatial_unit_attributes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE spatial_unit_attributes FROM PUBLIC;
REVOKE ALL ON TABLE spatial_unit_attributes FROM postgres;
GRANT ALL ON TABLE spatial_unit_attributes TO postgres;

--
-- Name: topology_checks_error_log; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE topology_checks_error_log FROM PUBLIC;
REVOKE ALL ON TABLE topology_checks_error_log FROM postgres;
GRANT ALL ON TABLE topology_checks_error_log TO postgres;

--
-- Name: vertexlabel; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE vertexlabel FROM PUBLIC;
REVOKE ALL ON TABLE vertexlabel FROM postgres;
GRANT ALL ON TABLE vertexlabel TO postgres;
