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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE la_baunit_landsoilquality (
    landsoilqualityid integer NOT NULL,
    landsoilqualitytype character varying(50) NOT NULL,
    landsoilqualitytype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_baunit_landsoilquality_landsoilqualityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_baunit_landsoilquality_landsoilqualityid_seq OWNED BY la_baunit_landsoilquality.landsoilqualityid;



CREATE TABLE la_baunit_landtype (
    landtypeid integer NOT NULL,
    landtype character varying(50) NOT NULL,
    landtype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_baunit_landtype_landtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE la_baunit_landtype_landtypeid_seq OWNED BY la_baunit_landtype.landtypeid;


CREATE TABLE la_baunit_landusetype (
    landusetypeid integer NOT NULL,
    landusetype character varying(50) NOT NULL,
    landusetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_baunit_landusetype_landusetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_baunit_landusetype_landusetypeid_seq OWNED BY la_baunit_landusetype.landusetypeid;

CREATE TABLE la_ext_applicationstatus (
    applicationstatusid integer NOT NULL,
    applicationstatus character varying(50) NOT NULL,
    applicationstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_applicationstatus_applicationstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_applicationstatus_applicationstatusid_seq OWNED BY la_ext_applicationstatus.applicationstatusid;


CREATE TABLE la_ext_attribute (
    attributeid integer NOT NULL,
    attributevalue character varying(50) NOT NULL,
    attributemasterid integer NOT NULL,
    parentuid integer NOT NULL
);



CREATE SEQUENCE la_ext_attribute_attributeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_attribute_attributeid_seq OWNED BY la_ext_attribute.attributeid;


CREATE TABLE la_ext_attributecategory (
    attributecategoryid integer NOT NULL,
    categoryname character varying(50) NOT NULL
);



CREATE SEQUENCE la_ext_attributecategory_attributecategoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_attributecategory_attributecategoryid_seq OWNED BY la_ext_attributecategory.attributecategoryid;




CREATE TABLE la_ext_attributedatatype (
    datatypemasterid integer NOT NULL,
    datatype character varying(20) NOT NULL
);



CREATE SEQUENCE la_ext_attributedatatype_datatypemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_attributedatatype_datatypemasterid_seq OWNED BY la_ext_attributedatatype.datatypemasterid;


CREATE TABLE la_ext_attributemaster (
    attributemasterid integer NOT NULL,
    fieldname character varying(50) NOT NULL,
    fieldaliasname character varying(50),
    datatypemasterid integer NOT NULL,
    attributecategoryid integer,
    referencetable character varying(50) NOT NULL,
    size character varying(5) NOT NULL,
    mandatory boolean,
    listing character varying(5) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_attributemaster_attributemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_attributemaster_attributemasterid_seq OWNED BY la_ext_attributemaster.attributemasterid;


CREATE TABLE la_ext_attributeoptions (
    attributeoptionsid integer NOT NULL,
    optiontext character varying(50),
    attributemasterid integer NOT NULL,
    parentid integer
);




CREATE SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq OWNED BY la_ext_attributeoptions.attributeoptionsid;



CREATE TABLE la_ext_baselayer (
    baselayerid integer NOT NULL,
    baselayer character varying(50) NOT NULL,
    baselayer_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);




CREATE SEQUENCE la_ext_baselayer_baselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_baselayer_baselayerid_seq OWNED BY la_ext_baselayer.baselayerid;


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


CREATE SEQUENCE la_ext_bookmark_bookmarkid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_bookmark_bookmarkid_seq OWNED BY la_ext_bookmark.bookmarkid;



CREATE TABLE la_ext_disputelandmapping (
    disputelandid integer NOT NULL,
    partyid bigint,
    landid bigint NOT NULL,
    persontypeid integer NOT NULL,
    disputetypeid integer NOT NULL,
    transactionid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);



CREATE SEQUENCE la_ext_disputelandmapping_disputelandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_disputelandmapping_disputelandid_seq OWNED BY la_ext_disputelandmapping.disputelandid;


CREATE TABLE la_ext_disputestatus (
    disputestatusid integer NOT NULL,
    disputestatus character varying(50) NOT NULL,
    disputestatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);




CREATE SEQUENCE la_ext_disputestatus_disputestatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_disputestatus_disputestatusid_seq OWNED BY la_ext_disputestatus.disputestatusid;


CREATE TABLE la_ext_disputetype (
    disputetypeid integer NOT NULL,
    disputetype character varying(50) NOT NULL,
    disputetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);




CREATE SEQUENCE la_ext_disputetype_disputetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_disputetype_disputetypeid_seq OWNED BY la_ext_disputetype.disputetypeid;



CREATE TABLE la_ext_documentdetails (
    documentid integer NOT NULL,
    transactionid integer NOT NULL,
    landid bigint NOT NULL,
    partyid bigint NOT NULL,
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




CREATE SEQUENCE la_ext_documentdetails_documentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_documentdetails_documentid_seq OWNED BY la_ext_documentdetails.documentid;


CREATE TABLE la_ext_documentformat (
    documentformatid integer NOT NULL,
    documentformat character varying(50) NOT NULL,
    documentformat_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_documentformat_documentformatid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_documentformat_documentformatid_seq OWNED BY la_ext_documentformat.documentformatid;


CREATE TABLE la_ext_documenttype (
    documenttypeid integer NOT NULL,
    documenttype character varying(50) NOT NULL,
    documenttype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_documenttype_documenttypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_documenttype_documenttypeid_seq OWNED BY la_ext_documenttype.documenttypeid;



CREATE TABLE la_ext_grouptype (
    grouptypeid integer NOT NULL,
    grouptype character varying(50) NOT NULL,
    grouptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_grouptype_grouptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_grouptype_grouptypeid_seq OWNED BY la_ext_grouptype.grouptypeid;



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



CREATE SEQUENCE la_ext_layer_layergroup_layer_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_layer_layergroup_layer_layergroupid_seq OWNED BY la_ext_layer_layergroup.layer_layergroupid;



CREATE TABLE la_ext_layerfield (
    layerfieldid integer NOT NULL,
    layerid integer NOT NULL,
    layerfield character varying(255) NOT NULL,
    layerfield_en character varying(255) NOT NULL,
    keyfield character varying(50),
    isactive boolean DEFAULT true NOT NULL,
    alias character varying(255)
);



CREATE SEQUENCE la_ext_layerfield_layerfieldid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_ext_layerfield_layerfieldid_seq OWNED BY la_ext_layerfield.layerfieldid;


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


CREATE SEQUENCE la_ext_layergroup_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_layergroup_layergroupid_seq OWNED BY la_ext_layergroup.layergroupid;



CREATE TABLE la_ext_layertype (
    layertypeid integer NOT NULL,
    layertype character varying(50) NOT NULL,
    layertype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_layertype_layertypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_layertype_layertypeid_seq OWNED BY la_ext_layertype.layertypeid;


CREATE TABLE la_ext_module (
    moduleid integer NOT NULL,
    modulename character varying(50) NOT NULL,
    modulename_en character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_module_moduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_ext_module_moduleid_seq OWNED BY la_ext_module.moduleid;


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


CREATE SEQUENCE la_ext_personlandmapping_personlandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_personlandmapping_personlandid_seq OWNED BY la_ext_personlandmapping.personlandid;


CREATE TABLE la_ext_process (
    processid integer NOT NULL,
    processname character varying(50),
    processname_en character varying(50),
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_process_processid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_process_processid_seq OWNED BY la_ext_process.processid;


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


CREATE SEQUENCE la_ext_projectadjudicator_projectadjudicatorid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_ext_projectadjudicator_projectadjudicatorid_seq OWNED BY la_ext_projectadjudicator.projectadjudicatorid;



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



CREATE SEQUENCE la_ext_projectarea_projectareaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projectarea_projectareaid_seq OWNED BY la_ext_projectarea.projectareaid;



CREATE TABLE la_ext_projectbaselayermapping (
    projectbaselayerid integer NOT NULL,
    baselayerid integer NOT NULL,
    projectnameid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);



CREATE SEQUENCE la_ext_projectbaselayermapping_projectbaselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projectbaselayermapping_projectbaselayerid_seq OWNED BY la_ext_projectbaselayermapping.projectbaselayerid;



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


CREATE SEQUENCE la_ext_projectfile_projectfileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projectfile_projectfileid_seq OWNED BY la_ext_projectfile.projectfileid;

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

CREATE SEQUENCE la_ext_projecthamlet_projecthamletid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projecthamlet_projecthamletid_seq OWNED BY la_ext_projecthamlet.projecthamletid;


CREATE TABLE la_ext_projection (
    projectionid integer NOT NULL,
    projection character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_projection_projectionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projection_projectionid_seq OWNED BY la_ext_projection.projectionid;


CREATE TABLE la_ext_projectlayergroupmapping (
    projectlayergroupid integer NOT NULL,
    layergroupid integer NOT NULL,
    projectnameid integer NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone
);

CREATE SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq OWNED BY la_ext_projectlayergroupmapping.projectlayergroupid;



CREATE TABLE la_ext_role (
    roleid integer NOT NULL,
    roletype character varying(30) NOT NULL,
    roletype_en character varying(30) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_role_roleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_role_roleid_seq OWNED BY la_ext_role.roleid;



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




CREATE SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq OWNED BY la_ext_rolemodulemapping.rolemoduleid;


CREATE TABLE la_ext_slopevalue (
    slopevalueid integer NOT NULL,
    slopevalue character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_ext_slopevalue_slopevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_slopevalue_slopevalueid_seq OWNED BY la_ext_slopevalue.slopevalueid;


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



CREATE SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq OWNED BY la_ext_surveyprojectattributes.surveyprojectattributesid;

CREATE TABLE la_ext_transactiondetails (
    transactionid integer NOT NULL,
    processid integer NOT NULL,
    applicationstatusid integer NOT NULL,
    moduletransid integer,
    remarks character varying(500),
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL
);



CREATE SEQUENCE la_ext_transactiondetails_transactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_ext_transactiondetails_transactionid_seq OWNED BY la_ext_transactiondetails.transactionid;


CREATE TABLE la_ext_unit (
    unitid integer NOT NULL,
    unit character varying(50) NOT NULL,
    unit_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_ext_unit_unitid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_unit_unitid_seq OWNED BY la_ext_unit.unitid;


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


CREATE SEQUENCE la_ext_user_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_user_userid_seq OWNED BY la_ext_user.userid;


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



CREATE SEQUENCE la_ext_userprojectmapping_userprojectid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_userprojectmapping_userprojectid_seq OWNED BY la_ext_userprojectmapping.userprojectid;



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


CREATE SEQUENCE la_ext_userrolemapping_userroleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_ext_userrolemapping_userroleid_seq OWNED BY la_ext_userrolemapping.userroleid;


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



CREATE TABLE la_party (
    partyid bigint NOT NULL,
    persontypeid integer,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL
);




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
    identitytypeid integer NOT NULL,
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
    modifieddate timestamp without time zone
);



CREATE SEQUENCE la_party_partyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_party_partyid_seq OWNED BY la_party.partyid;

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
    modifieddate timestamp without time zone
);



CREATE TABLE la_partygroup_educationlevel (
    educationlevelid integer NOT NULL,
    educationlevel character varying(50) NOT NULL,
    educationlevel_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_partygroup_educationlevel_educationlevelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_partygroup_educationlevel_educationlevelid_seq OWNED BY la_partygroup_educationlevel.educationlevelid;



CREATE TABLE la_partygroup_gender (
    genderid integer NOT NULL,
    gender character varying(50) NOT NULL,
    gender_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);




CREATE SEQUENCE la_partygroup_gender_genderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_partygroup_gender_genderid_seq OWNED BY la_partygroup_gender.genderid;



CREATE TABLE la_partygroup_identitytype (
    identitytypeid integer NOT NULL,
    identitytype character varying(50) NOT NULL,
    identitytype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_partygroup_identitytype_identitytypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_partygroup_identitytype_identitytypeid_seq OWNED BY la_partygroup_identitytype.identitytypeid;

CREATE TABLE la_partygroup_maritalstatus (
    maritalstatusid integer NOT NULL,
    maritalstatus character varying(50) NOT NULL,
    maritalstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq OWNED BY la_partygroup_maritalstatus.maritalstatusid;


CREATE TABLE la_partygroup_occupation (
    occupationid integer NOT NULL,
    occupation character varying(50) NOT NULL,
    occupation_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_partygroup_occupation_occupationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_partygroup_occupation_occupationid_seq OWNED BY la_partygroup_occupation.occupationid;


CREATE TABLE la_partygroup_persontype (
    persontypeid integer NOT NULL,
    persontype character varying(50) NOT NULL,
    persontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_partygroup_persontype_persontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




ALTER SEQUENCE la_partygroup_persontype_persontypeid_seq OWNED BY la_partygroup_persontype.persontypeid;


CREATE TABLE la_partygroup_relationshiptype (
    relationshiptypeid integer NOT NULL,
    relationshiptype character varying(50) NOT NULL,
    relationshiptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq OWNED BY la_partygroup_relationshiptype.relationshiptypeid;



CREATE TABLE la_right_acquisitiontype (
    acquisitiontypeid integer NOT NULL,
    acquisitiontype character varying(50) NOT NULL,
    acquisitiontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq OWNED BY la_right_acquisitiontype.acquisitiontypeid;


CREATE TABLE la_right_claimtype (
    claimtypeid integer NOT NULL,
    claimtype character varying(50) NOT NULL,
    claimtype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE la_right_claimtype_claimtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_right_claimtype_claimtypeid_seq OWNED BY la_right_claimtype.claimtypeid;


CREATE TABLE la_right_landsharetype (
    landsharetypeid integer NOT NULL,
    landsharetype character varying(50) NOT NULL,
    landsharetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE la_right_landsharetype_landsharetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_right_landsharetype_landsharetypeid_seq OWNED BY la_right_landsharetype.landsharetypeid;

CREATE TABLE la_right_tenureclass (
    tenureclassid integer NOT NULL,
    tenureclass character varying(50) NOT NULL,
    tenureclass_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_right_tenureclass_tenureclassid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_right_tenureclass_tenureclassid_seq OWNED BY la_right_tenureclass.tenureclassid;


CREATE TABLE la_rrr (
    rrrid integer NOT NULL,
    rrrtype character varying(50) NOT NULL,
    rrrtypeid integer NOT NULL
);



CREATE SEQUENCE la_rrr_rrrid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_rrr_rrrid_seq OWNED BY la_rrr.rrrid;


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



CREATE SEQUENCE la_spatialsource_layer_layerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_spatialsource_layer_layerid_seq OWNED BY la_spatialsource_layer.layerid;


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
    modifieddate timestamp without time zone
);




CREATE SEQUENCE la_spatialsource_projectname_projectnameid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_spatialsource_projectname_projectnameid_seq OWNED BY la_spatialsource_projectname.projectnameid;



CREATE TABLE la_spatialunit_land (
    landid bigint NOT NULL,
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
    geometry geometry NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);



CREATE SEQUENCE la_spatialunit_land_landid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_spatialunit_land_landid_seq OWNED BY la_spatialunit_land.landid;



CREATE TABLE la_spatialunitgroup (
    spatialunitgroupid integer NOT NULL,
    hierarchy character varying(50) NOT NULL,
    hierarchy_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);



CREATE TABLE la_spatialunitgroup_hierarchy (
    hierarchyid integer NOT NULL,
    name character varying(50) NOT NULL,
    name_en character varying(50) NOT NULL,
    spatialunitgroupid integer,
    uperhierarchyid integer,
    isactive boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq OWNED BY la_spatialunitgroup_hierarchy.hierarchyid;



CREATE SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq OWNED BY la_spatialunitgroup.spatialunitgroupid;


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


CREATE VIEW view_claimants_for_editing AS
 SELECT row_number() OVER () AS id,
    p.personid AS person_id,
    su.landid,
    su.landno AS uka,
    su.projectnameid,
    r.personlandid AS right_id,
    su.claimtypeid AS claim_number,
    su.neighbor_north,
    su.neighbor_south,
    su.neighbor_east,
    su.neighbor_west,
    sh.landsharetype_en,
    p.firstname,
    p.lastname,
    p.middlename,
    p.contactno,
    p.identityno,
    p.identitytypeid,
    p.dateofbirth,
    p.genderid,
    p.maritalstatusid,
    prj.projectname
   FROM ((((la_ext_personlandmapping r
     LEFT JOIN la_party_person p ON ((r.persontypeid = p.personid)))
     JOIN la_spatialunit_land su ON ((r.landid = su.landid)))
     JOIN la_spatialsource_projectname prj ON ((prj.projectnameid = su.projectnameid)))
     JOIN la_right_landsharetype sh ON ((su.landsharetypeid = sh.landsharetypeid)))
  WHERE (r.isactive AND p.isactive AND su.isactive AND p.isactive)
  ORDER BY p.firstname;


ALTER TABLE ONLY la_baunit_landsoilquality ALTER COLUMN landsoilqualityid SET DEFAULT nextval('la_baunit_landsoilquality_landsoilqualityid_seq'::regclass);


ALTER TABLE ONLY la_baunit_landtype ALTER COLUMN landtypeid SET DEFAULT nextval('la_baunit_landtype_landtypeid_seq'::regclass);


ALTER TABLE ONLY la_baunit_landusetype ALTER COLUMN landusetypeid SET DEFAULT nextval('la_baunit_landusetype_landusetypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_applicationstatus ALTER COLUMN applicationstatusid SET DEFAULT nextval('la_ext_applicationstatus_applicationstatusid_seq'::regclass);



ALTER TABLE ONLY la_ext_attribute ALTER COLUMN attributeid SET DEFAULT nextval('la_ext_attribute_attributeid_seq'::regclass);

ALTER TABLE ONLY la_ext_attributecategory ALTER COLUMN attributecategoryid SET DEFAULT nextval('la_ext_attributecategory_attributecategoryid_seq'::regclass);


ALTER TABLE ONLY la_ext_attributedatatype ALTER COLUMN datatypemasterid SET DEFAULT nextval('la_ext_attributedatatype_datatypemasterid_seq'::regclass);


ALTER TABLE ONLY la_ext_attributemaster ALTER COLUMN attributemasterid SET DEFAULT nextval('la_ext_attributemaster_attributemasterid_seq'::regclass);

ALTER TABLE ONLY la_ext_attributeoptions ALTER COLUMN attributeoptionsid SET DEFAULT nextval('la_ext_attributeoptions_attributeoptionsid_seq'::regclass);


ALTER TABLE ONLY la_ext_baselayer ALTER COLUMN baselayerid SET DEFAULT nextval('la_ext_baselayer_baselayerid_seq'::regclass);


ALTER TABLE ONLY la_ext_bookmark ALTER COLUMN bookmarkid SET DEFAULT nextval('la_ext_bookmark_bookmarkid_seq'::regclass);


ALTER TABLE ONLY la_ext_disputelandmapping ALTER COLUMN disputelandid SET DEFAULT nextval('la_ext_disputelandmapping_disputelandid_seq'::regclass);



ALTER TABLE ONLY la_ext_disputestatus ALTER COLUMN disputestatusid SET DEFAULT nextval('la_ext_disputestatus_disputestatusid_seq'::regclass);



ALTER TABLE ONLY la_ext_disputetype ALTER COLUMN disputetypeid SET DEFAULT nextval('la_ext_disputetype_disputetypeid_seq'::regclass);


ALTER TABLE ONLY la_ext_documentdetails ALTER COLUMN documentid SET DEFAULT nextval('la_ext_documentdetails_documentid_seq'::regclass);



ALTER TABLE ONLY la_ext_documentformat ALTER COLUMN documentformatid SET DEFAULT nextval('la_ext_documentformat_documentformatid_seq'::regclass);



ALTER TABLE ONLY la_ext_documenttype ALTER COLUMN documenttypeid SET DEFAULT nextval('la_ext_documenttype_documenttypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_grouptype ALTER COLUMN grouptypeid SET DEFAULT nextval('la_ext_grouptype_grouptypeid_seq'::regclass);


ALTER TABLE ONLY la_ext_layer_layergroup ALTER COLUMN layer_layergroupid SET DEFAULT nextval('la_ext_layer_layergroup_layer_layergroupid_seq'::regclass);



ALTER TABLE ONLY la_ext_layerfield ALTER COLUMN layerfieldid SET DEFAULT nextval('la_ext_layerfield_layerfieldid_seq'::regclass);



ALTER TABLE ONLY la_ext_layergroup ALTER COLUMN layergroupid SET DEFAULT nextval('la_ext_layergroup_layergroupid_seq'::regclass);


ALTER TABLE ONLY la_ext_layertype ALTER COLUMN layertypeid SET DEFAULT nextval('la_ext_layertype_layertypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_module ALTER COLUMN moduleid SET DEFAULT nextval('la_ext_module_moduleid_seq'::regclass);



ALTER TABLE ONLY la_ext_personlandmapping ALTER COLUMN personlandid SET DEFAULT nextval('la_ext_personlandmapping_personlandid_seq'::regclass);



ALTER TABLE ONLY la_ext_process ALTER COLUMN processid SET DEFAULT nextval('la_ext_process_processid_seq'::regclass);


ALTER TABLE ONLY la_ext_projectadjudicator ALTER COLUMN projectadjudicatorid SET DEFAULT nextval('la_ext_projectadjudicator_projectadjudicatorid_seq'::regclass);


ALTER TABLE ONLY la_ext_projectarea ALTER COLUMN projectareaid SET DEFAULT nextval('la_ext_projectarea_projectareaid_seq'::regclass);


ALTER TABLE ONLY la_ext_projectbaselayermapping ALTER COLUMN projectbaselayerid SET DEFAULT nextval('la_ext_projectbaselayermapping_projectbaselayerid_seq'::regclass);


ALTER TABLE ONLY la_ext_projectfile ALTER COLUMN projectfileid SET DEFAULT nextval('la_ext_projectfile_projectfileid_seq'::regclass);


ALTER TABLE ONLY la_ext_projecthamlet ALTER COLUMN projecthamletid SET DEFAULT nextval('la_ext_projecthamlet_projecthamletid_seq'::regclass);


ALTER TABLE ONLY la_ext_projection ALTER COLUMN projectionid SET DEFAULT nextval('la_ext_projection_projectionid_seq'::regclass);


ALTER TABLE ONLY la_ext_projectlayergroupmapping ALTER COLUMN projectlayergroupid SET DEFAULT nextval('la_ext_projectlayergroupmapping_projectlayergroupid_seq'::regclass);



ALTER TABLE ONLY la_ext_role ALTER COLUMN roleid SET DEFAULT nextval('la_ext_role_roleid_seq'::regclass);



ALTER TABLE ONLY la_ext_rolemodulemapping ALTER COLUMN rolemoduleid SET DEFAULT nextval('la_ext_rolemodulemapping_rolemoduleid_seq'::regclass);


ALTER TABLE ONLY la_ext_slopevalue ALTER COLUMN slopevalueid SET DEFAULT nextval('la_ext_slopevalue_slopevalueid_seq'::regclass);

ALTER TABLE ONLY la_ext_surveyprojectattributes ALTER COLUMN surveyprojectattributesid SET DEFAULT nextval('la_ext_surveyprojectattributes_surveyprojectattributesid_seq'::regclass);


ALTER TABLE ONLY la_ext_transactiondetails ALTER COLUMN transactionid SET DEFAULT nextval('la_ext_transactiondetails_transactionid_seq'::regclass);


ALTER TABLE ONLY la_ext_unit ALTER COLUMN unitid SET DEFAULT nextval('la_ext_unit_unitid_seq'::regclass);


ALTER TABLE ONLY la_ext_user ALTER COLUMN userid SET DEFAULT nextval('la_ext_user_userid_seq'::regclass);

ALTER TABLE ONLY la_ext_userprojectmapping ALTER COLUMN userprojectid SET DEFAULT nextval('la_ext_userprojectmapping_userprojectid_seq'::regclass);


ALTER TABLE ONLY la_ext_userrolemapping ALTER COLUMN userroleid SET DEFAULT nextval('la_ext_userrolemapping_userroleid_seq'::regclass);


ALTER TABLE ONLY la_party ALTER COLUMN partyid SET DEFAULT nextval('la_party_partyid_seq'::regclass);


ALTER TABLE ONLY la_partygroup_educationlevel ALTER COLUMN educationlevelid SET DEFAULT nextval('la_partygroup_educationlevel_educationlevelid_seq'::regclass);


ALTER TABLE ONLY la_partygroup_gender ALTER COLUMN genderid SET DEFAULT nextval('la_partygroup_gender_genderid_seq'::regclass);

ALTER TABLE ONLY la_partygroup_identitytype ALTER COLUMN identitytypeid SET DEFAULT nextval('la_partygroup_identitytype_identitytypeid_seq'::regclass);

ALTER TABLE ONLY la_partygroup_maritalstatus ALTER COLUMN maritalstatusid SET DEFAULT nextval('la_partygroup_maritalstatus_maritalstatusid_seq'::regclass);


ALTER TABLE ONLY la_partygroup_occupation ALTER COLUMN occupationid SET DEFAULT nextval('la_partygroup_occupation_occupationid_seq'::regclass);


ALTER TABLE ONLY la_partygroup_persontype ALTER COLUMN persontypeid SET DEFAULT nextval('la_partygroup_persontype_persontypeid_seq'::regclass);


ALTER TABLE ONLY la_partygroup_relationshiptype ALTER COLUMN relationshiptypeid SET DEFAULT nextval('la_partygroup_relationshiptype_relationshiptypeid_seq'::regclass);


ALTER TABLE ONLY la_right_acquisitiontype ALTER COLUMN acquisitiontypeid SET DEFAULT nextval('la_right_acquisitiontype_acquisitiontypeid_seq'::regclass);


ALTER TABLE ONLY la_right_claimtype ALTER COLUMN claimtypeid SET DEFAULT nextval('la_right_claimtype_claimtypeid_seq'::regclass);


ALTER TABLE ONLY la_right_landsharetype ALTER COLUMN landsharetypeid SET DEFAULT nextval('la_right_landsharetype_landsharetypeid_seq'::regclass);


ALTER TABLE ONLY la_right_tenureclass ALTER COLUMN tenureclassid SET DEFAULT nextval('la_right_tenureclass_tenureclassid_seq'::regclass);


ALTER TABLE ONLY la_rrr ALTER COLUMN rrrid SET DEFAULT nextval('la_rrr_rrrid_seq'::regclass);


ALTER TABLE ONLY la_spatialsource_layer ALTER COLUMN layerid SET DEFAULT nextval('la_spatialsource_layer_layerid_seq'::regclass);


ALTER TABLE ONLY la_spatialsource_projectname ALTER COLUMN projectnameid SET DEFAULT nextval('la_spatialsource_projectname_projectnameid_seq'::regclass);


ALTER TABLE ONLY la_spatialunit_land ALTER COLUMN landid SET DEFAULT nextval('la_spatialunit_land_landid_seq'::regclass);


ALTER TABLE ONLY la_spatialunitgroup ALTER COLUMN spatialunitgroupid SET DEFAULT nextval('la_spatialunitgroup_spatialunitgroupid_seq'::regclass);

ALTER TABLE ONLY la_spatialunitgroup_hierarchy ALTER COLUMN hierarchyid SET DEFAULT nextval('la_spatialunitgroup_hierarchy_hierarchyid_seq'::regclass);


ALTER TABLE ONLY la_baunit_landsoilquality
    ADD CONSTRAINT pk_la_baunit_landsoilquality PRIMARY KEY (landsoilqualityid);



ALTER TABLE ONLY la_baunit_landtype
    ADD CONSTRAINT pk_la_baunit_landtype PRIMARY KEY (landtypeid);



ALTER TABLE ONLY la_baunit_landusetype
    ADD CONSTRAINT pk_la_baunit_landusetype PRIMARY KEY (landusetypeid);



ALTER TABLE ONLY la_ext_applicationstatus
    ADD CONSTRAINT pk_la_ext_applicationstatus PRIMARY KEY (applicationstatusid);



ALTER TABLE ONLY la_ext_attribute
    ADD CONSTRAINT pk_la_ext_attribute PRIMARY KEY (attributeid);


ALTER TABLE ONLY la_ext_attributecategory
    ADD CONSTRAINT pk_la_ext_attributecategory PRIMARY KEY (attributecategoryid);



ALTER TABLE ONLY la_ext_attributedatatype
    ADD CONSTRAINT pk_la_ext_attributedatatype PRIMARY KEY (datatypemasterid);


ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT pk_la_ext_attributemaster PRIMARY KEY (attributemasterid);


ALTER TABLE ONLY la_ext_attributeoptions
    ADD CONSTRAINT pk_la_ext_attributeoptions PRIMARY KEY (attributeoptionsid);


ALTER TABLE ONLY la_ext_baselayer
    ADD CONSTRAINT pk_la_ext_baselayer PRIMARY KEY (baselayerid);



ALTER TABLE ONLY la_ext_bookmark
    ADD CONSTRAINT pk_la_ext_bookmark PRIMARY KEY (bookmarkid);


ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT pk_la_ext_disputelandmapping PRIMARY KEY (disputelandid);



ALTER TABLE ONLY la_ext_disputestatus
    ADD CONSTRAINT pk_la_ext_disputestatus PRIMARY KEY (disputestatusid);



ALTER TABLE ONLY la_ext_disputetype
    ADD CONSTRAINT pk_la_ext_disputetype PRIMARY KEY (disputetypeid);



ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT pk_la_ext_documentdetails PRIMARY KEY (documentid);


ALTER TABLE ONLY la_ext_documentformat
    ADD CONSTRAINT pk_la_ext_documentformat PRIMARY KEY (documentformatid);



ALTER TABLE ONLY la_ext_documenttype
    ADD CONSTRAINT pk_la_ext_documenttype PRIMARY KEY (documenttypeid);


ALTER TABLE ONLY la_ext_grouptype
    ADD CONSTRAINT pk_la_ext_grouptype PRIMARY KEY (grouptypeid);



ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT pk_la_ext_layer_layergroup PRIMARY KEY (layer_layergroupid);



ALTER TABLE ONLY la_ext_layerfield
    ADD CONSTRAINT pk_la_ext_layerfield PRIMARY KEY (layerfieldid);



ALTER TABLE ONLY la_ext_layergroup
    ADD CONSTRAINT pk_la_ext_layergroup PRIMARY KEY (layergroupid);


ALTER TABLE ONLY la_ext_layertype
    ADD CONSTRAINT pk_la_ext_layertype PRIMARY KEY (layertypeid);


ALTER TABLE ONLY la_ext_module
    ADD CONSTRAINT pk_la_ext_module PRIMARY KEY (moduleid);


ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT pk_la_ext_personlandmapping PRIMARY KEY (personlandid);



ALTER TABLE ONLY la_ext_process
    ADD CONSTRAINT pk_la_ext_process PRIMARY KEY (processid);


ALTER TABLE ONLY la_ext_projectadjudicator
    ADD CONSTRAINT pk_la_ext_projectadjudicator PRIMARY KEY (projectadjudicatorid);



ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT pk_la_ext_projectarea PRIMARY KEY (projectareaid);


ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT pk_la_ext_projectbaselayermapping PRIMARY KEY (projectbaselayerid);



ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT pk_la_ext_projectfile PRIMARY KEY (projectfileid);



ALTER TABLE ONLY la_ext_projecthamlet
    ADD CONSTRAINT pk_la_ext_projecthamlet PRIMARY KEY (projecthamletid);


ALTER TABLE ONLY la_ext_projection
    ADD CONSTRAINT pk_la_ext_projection PRIMARY KEY (projectionid);


ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT pk_la_ext_projectlayergroupmapping PRIMARY KEY (projectlayergroupid);



ALTER TABLE ONLY la_ext_role
    ADD CONSTRAINT pk_la_ext_role PRIMARY KEY (roleid);


ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT pk_la_ext_rolemodulemapping PRIMARY KEY (rolemoduleid);



ALTER TABLE ONLY la_ext_slopevalue
    ADD CONSTRAINT pk_la_ext_slopevalue PRIMARY KEY (slopevalueid);



ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT pk_la_ext_surveyprojectattributes PRIMARY KEY (surveyprojectattributesid);


ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT pk_la_ext_transactiondetails PRIMARY KEY (transactionid);



ALTER TABLE ONLY la_ext_unit
    ADD CONSTRAINT pk_la_ext_unit PRIMARY KEY (unitid);


ALTER TABLE ONLY la_ext_user
    ADD CONSTRAINT pk_la_ext_user PRIMARY KEY (userid);

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT pk_la_ext_userprojectmapping PRIMARY KEY (userprojectid);


ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT pk_la_ext_userrolemapping PRIMARY KEY (userroleid);


ALTER TABLE ONLY la_party
    ADD CONSTRAINT pk_la_party PRIMARY KEY (partyid);


ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT pk_la_party_deceasedperson PRIMARY KEY (partyid);



ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT pk_la_party_organization PRIMARY KEY (organizationid);



ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT pk_la_party_person PRIMARY KEY (personid);



ALTER TABLE ONLY la_partygroup_educationlevel
    ADD CONSTRAINT pk_la_partygroup_educationlevel PRIMARY KEY (educationlevelid);


ALTER TABLE ONLY la_partygroup_gender
    ADD CONSTRAINT pk_la_partygroup_gender PRIMARY KEY (genderid);


ALTER TABLE ONLY la_partygroup_identitytype
    ADD CONSTRAINT pk_la_partygroup_identitytype PRIMARY KEY (identitytypeid);



ALTER TABLE ONLY la_partygroup_maritalstatus
    ADD CONSTRAINT pk_la_partygroup_maritalstatus PRIMARY KEY (maritalstatusid);



ALTER TABLE ONLY la_partygroup_occupation
    ADD CONSTRAINT pk_la_partygroup_occupation PRIMARY KEY (occupationid);



ALTER TABLE ONLY la_partygroup_persontype
    ADD CONSTRAINT pk_la_partygroup_persontype PRIMARY KEY (persontypeid);



ALTER TABLE ONLY la_partygroup_relationshiptype
    ADD CONSTRAINT pk_la_partygroup_relationshiptype PRIMARY KEY (relationshiptypeid);



ALTER TABLE ONLY la_right_acquisitiontype
    ADD CONSTRAINT pk_la_right_acquisitiontype PRIMARY KEY (acquisitiontypeid);


ALTER TABLE ONLY la_right_claimtype
    ADD CONSTRAINT pk_la_right_claimtype PRIMARY KEY (claimtypeid);



ALTER TABLE ONLY la_right_landsharetype
    ADD CONSTRAINT pk_la_right_landsharetype PRIMARY KEY (landsharetypeid);



ALTER TABLE ONLY la_right_tenureclass
    ADD CONSTRAINT pk_la_right_tenureclass PRIMARY KEY (tenureclassid);



ALTER TABLE ONLY la_rrr
    ADD CONSTRAINT pk_la_rrr PRIMARY KEY (rrrid);

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT pk_la_spatialsource_layer PRIMARY KEY (layerid);


ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT pk_la_spatialsource_projectname PRIMARY KEY (projectnameid);



ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT pk_la_spatialunit_land PRIMARY KEY (landid);



ALTER TABLE ONLY la_spatialunitgroup
    ADD CONSTRAINT pk_la_spatialunitgroup PRIMARY KEY (spatialunitgroupid);



ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT pk_la_spatialunitgroup_hierarchy PRIMARY KEY (hierarchyid);


ALTER TABLE ONLY la_layer
    ADD CONSTRAINT pk_layer PRIMARY KEY (alias);



CREATE UNIQUE INDEX "PK_Layer" ON la_layer USING btree (alias);

ALTER TABLE la_layer CLUSTER ON "PK_Layer";


ALTER TABLE ONLY la_ext_attribute
    ADD CONSTRAINT fk_la_ext_attribute_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);



ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);


ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);



ALTER TABLE ONLY la_ext_attributeoptions
    ADD CONSTRAINT fk_la_ext_attributeoptions_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);


ALTER TABLE ONLY la_ext_bookmark
    ADD CONSTRAINT fk_la_ext_bookmark_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_disputetypeid FOREIGN KEY (disputetypeid) REFERENCES la_ext_disputetype(disputetypeid);


ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);



ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_documenttypeid FOREIGN KEY (documenttypeid) REFERENCES la_ext_documenttype(documenttypeid);

ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);



ALTER TABLE ONLY la_ext_documentdetails
    ADD CONSTRAINT fk_la_ext_documentdetails_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);



ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT fk_la_ext_layer_layergroup_layergroupid FOREIGN KEY (layergroupid) REFERENCES la_ext_layergroup(layergroupid);


ALTER TABLE ONLY la_ext_layer_layergroup
    ADD CONSTRAINT fk_la_ext_layer_layergroup_layerid FOREIGN KEY (layerid) REFERENCES la_spatialsource_layer(layerid);


ALTER TABLE ONLY la_ext_layerfield
    ADD CONSTRAINT fk_la_ext_layerfield_layerid FOREIGN KEY (layerid) REFERENCES la_spatialsource_layer(layerid);


ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);



ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);


ALTER TABLE ONLY la_ext_personlandmapping
    ADD CONSTRAINT fk_la_ext_personlandmapping_transactionid FOREIGN KEY (transactionid) REFERENCES la_ext_transactiondetails(transactionid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT fk_la_ext_projectarea_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_ext_projectarea_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT fk_la_ext_projectbaselayermapping_baselayerid FOREIGN KEY (baselayerid) REFERENCES la_ext_baselayer(baselayerid);


ALTER TABLE ONLY la_ext_projectbaselayermapping
    ADD CONSTRAINT fk_la_ext_projectbaselayermapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


ALTER TABLE ONLY la_ext_projectfile
    ADD CONSTRAINT fk_la_ext_projectfile_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);

ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT fk_la_ext_projectlayergroupmapping_layergroupid FOREIGN KEY (layergroupid) REFERENCES la_ext_layergroup(layergroupid);


ALTER TABLE ONLY la_ext_projectlayergroupmapping
    ADD CONSTRAINT fk_la_ext_projectlayergroupmapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);

ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT fk_la_ext_rolemodulemapping_moduleid FOREIGN KEY (moduleid) REFERENCES la_ext_module(moduleid);

ALTER TABLE ONLY la_ext_rolemodulemapping
    ADD CONSTRAINT fk_la_ext_rolemodulemapping_roleid FOREIGN KEY (roleid) REFERENCES la_ext_role(roleid);


ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);

ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);



ALTER TABLE ONLY la_ext_surveyprojectattributes
    ADD CONSTRAINT fk_la_ext_surveyprojectattributes_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);


ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT fk_la_ext_transactiondetails_applicationstatusid FOREIGN KEY (applicationstatusid) REFERENCES la_ext_applicationstatus(applicationstatusid);

ALTER TABLE ONLY la_ext_transactiondetails
    ADD CONSTRAINT fk_la_ext_transactiondetails_moduleid FOREIGN KEY (processid) REFERENCES la_ext_module(moduleid);

ALTER TABLE ONLY la_ext_user
    ADD CONSTRAINT fk_la_ext_user_genderid FOREIGN KEY (genderid) REFERENCES la_partygroup_gender(genderid);


ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT fk_la_ext_userprojectmapping_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT fk_la_ext_userprojectmapping_userid FOREIGN KEY (userid) REFERENCES la_ext_user(userid);


ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT fk_la_ext_userrolemapping_roleid FOREIGN KEY (roleid) REFERENCES la_ext_role(roleid);

ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT fk_la_ext_userrolemapping_userid FOREIGN KEY (userid) REFERENCES la_ext_user(userid);


ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);


ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);


ALTER TABLE ONLY la_party_deceasedperson
    ADD CONSTRAINT fk_la_party_deceasedperson_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_grouptypeid FOREIGN KEY (grouptypeid) REFERENCES la_ext_grouptype(grouptypeid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_identitytypeid FOREIGN KEY (identitytypeid) REFERENCES la_partygroup_identitytype(identitytypeid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_organizationid FOREIGN KEY (organizationid) REFERENCES la_party(partyid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_party_organization_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_educationlevelid FOREIGN KEY (educationlevelid) REFERENCES la_partygroup_educationlevel(educationlevelid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_identitytypeid FOREIGN KEY (identitytypeid) REFERENCES la_partygroup_identitytype(identitytypeid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_maritalstatusid FOREIGN KEY (maritalstatusid) REFERENCES la_partygroup_maritalstatus(maritalstatusid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_occupationid FOREIGN KEY (occupationid) REFERENCES la_partygroup_occupation(occupationid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_personid FOREIGN KEY (personid) REFERENCES la_party(partyid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_relationshiptypeid FOREIGN KEY (relationshiptypeid) REFERENCES la_partygroup_relationshiptype(relationshiptypeid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_party_person_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


ALTER TABLE ONLY la_party
    ADD CONSTRAINT fk_la_partygroup_persontype_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_layertypeid FOREIGN KEY (layertypeid) REFERENCES la_ext_layertype(layertypeid);

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_projectionid FOREIGN KEY (projectionid) REFERENCES la_ext_projection(projectionid);

ALTER TABLE ONLY la_spatialsource_layer
    ADD CONSTRAINT fk_la_spatialsource_layer_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_documentformatid FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_projectionid FOREIGN KEY (projectionid) REFERENCES la_ext_projection(projectionid);

ALTER TABLE ONLY la_spatialsource_projectname
    ADD CONSTRAINT fk_la_spatialsource_projectname_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);

ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_spatialunit_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);



ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_ext_projectarea
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_party_organization
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_party_person
    ADD CONSTRAINT fk_la_spatialunit_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);

ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);


ALTER TABLE ONLY la_spatialunit_land
    ADD CONSTRAINT fk_la_spatialunit_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);


ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT fk_la_spatialunitgroup_hierarchy_spatialunitgroupid FOREIGN KEY (spatialunitgroupid) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT la_spatialunitgroup_hierarchy_uperhierarchy FOREIGN KEY (hierarchyid) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


