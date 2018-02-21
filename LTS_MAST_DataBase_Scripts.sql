CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';

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

CREATE SEQUENCE la_baunit_landtype_landtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_baunit_landtype_landtypeid_seq OWNER TO postgres;


ALTER SEQUENCE la_baunit_landtype_landtypeid_seq OWNED BY la_baunit_landtype.landtypeid;


CREATE TABLE la_baunit_landusetype (
    landusetypeid integer NOT NULL,
    landusetype character varying(50) NOT NULL,
    landusetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_baunit_landusetype OWNER TO postgres;


CREATE SEQUENCE la_baunit_landusetype_landusetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_baunit_landusetype_landusetypeid_seq OWNER TO postgres;


ALTER SEQUENCE la_baunit_landusetype_landusetypeid_seq OWNED BY la_baunit_landusetype.landusetypeid;


CREATE TABLE la_ext_applicationstatus (
    applicationstatusid integer NOT NULL,
    applicationstatus character varying(50) NOT NULL,
    applicationstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_applicationstatus OWNER TO postgres;


CREATE SEQUENCE la_ext_applicationstatus_applicationstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_applicationstatus_applicationstatusid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_applicationstatus_applicationstatusid_seq OWNED BY la_ext_applicationstatus.applicationstatusid;

CREATE TABLE la_ext_attribute (
    attributeid integer NOT NULL,
    attributevalue character varying(50) NOT NULL,
    attributemasterid integer NOT NULL,
    parentuid integer NOT NULL
);


ALTER TABLE la_ext_attribute OWNER TO postgres;

CREATE SEQUENCE la_ext_attribute_attributeid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attribute_attributeid_seq OWNER TO postgres;

ALTER SEQUENCE la_ext_attribute_attributeid_seq OWNED BY la_ext_attribute.attributeid;


CREATE TABLE la_ext_attributecategory (
    attributecategoryid integer NOT NULL,
    categoryname character varying(50) NOT NULL,
    categorytypeid integer,
    categorydisplayorder integer DEFAULT 1 NOT NULL
);


ALTER TABLE la_ext_attributecategory OWNER TO postgres;


CREATE SEQUENCE la_ext_attributecategory_attributecategoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributecategory_attributecategoryid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_attributecategory_attributecategoryid_seq OWNED BY la_ext_attributecategory.attributecategoryid;

CREATE TABLE la_ext_attributedatatype (
    datatypemasterid integer NOT NULL,
    datatype character varying(20) NOT NULL
);


ALTER TABLE la_ext_attributedatatype OWNER TO postgres;


CREATE SEQUENCE la_ext_attributedatatype_datatypemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributedatatype_datatypemasterid_seq OWNER TO postgres;

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
    listing character varying(5),
    isactive boolean DEFAULT true NOT NULL,
    masterattribute boolean DEFAULT true
);


ALTER TABLE la_ext_attributemaster OWNER TO postgres;


CREATE SEQUENCE la_ext_attributemaster_attributemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributemaster_attributemasterid_seq OWNER TO postgres;

ALTER SEQUENCE la_ext_attributemaster_attributemasterid_seq OWNED BY la_ext_attributemaster.attributemasterid;


CREATE TABLE la_ext_attributeoptions (
    attributeoptionsid integer NOT NULL,
    optiontext character varying(50),
    attributemasterid integer NOT NULL,
    parentid integer
);


ALTER TABLE la_ext_attributeoptions OWNER TO postgres;


CREATE SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_attributeoptions_attributeoptionsid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_attributeoptions_attributeoptionsid_seq OWNED BY la_ext_attributeoptions.attributeoptionsid;



CREATE TABLE la_ext_baselayer (
    baselayerid integer NOT NULL,
    baselayer character varying(50) NOT NULL,
    baselayer_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_baselayer OWNER TO postgres;


CREATE SEQUENCE la_ext_baselayer_baselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_baselayer_baselayerid_seq OWNER TO postgres;

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


ALTER TABLE la_ext_bookmark OWNER TO postgres;


CREATE SEQUENCE la_ext_bookmark_bookmarkid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_bookmark_bookmarkid_seq OWNER TO postgres;

ALTER SEQUENCE la_ext_bookmark_bookmarkid_seq OWNED BY la_ext_bookmark.bookmarkid;


CREATE TABLE la_ext_categorytype (
    categorytypeid integer NOT NULL,
    typename character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_categorytype OWNER TO postgres;

CREATE SEQUENCE la_ext_categorytype_categorytypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_categorytype_categorytypeid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_categorytype_categorytypeid_seq OWNED BY la_ext_categorytype.categorytypeid;


CREATE SEQUENCE la_ext_customattributeoptionsid_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_customattributeoptionsid_seq OWNER TO postgres;


CREATE TABLE la_ext_customattributeoptions (
    attributeoptionsid integer DEFAULT nextval('la_ext_customattributeoptionsid_seq'::regclass) NOT NULL,
    optiontext character varying(50),
    customattributeid integer NOT NULL,
    parentid integer
);


ALTER TABLE la_ext_customattributeoptions OWNER TO postgres;

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


CREATE SEQUENCE la_ext_dispute_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_dispute_seq OWNER TO postgres;


CREATE TABLE la_ext_disputelandmapping (
    disputelandid integer NOT NULL,
    partyid bigint,
    landid bigint NOT NULL,
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


CREATE SEQUENCE la_ext_disputelandmapping_disputelandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputelandmapping_disputelandid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_disputelandmapping_disputelandid_seq OWNED BY la_ext_disputelandmapping.disputelandid;


CREATE TABLE la_ext_disputestatus (
    disputestatusid integer NOT NULL,
    disputestatus character varying(50) NOT NULL,
    disputestatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_disputestatus OWNER TO postgres;



CREATE SEQUENCE la_ext_disputestatus_disputestatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputestatus_disputestatusid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_disputestatus_disputestatusid_seq OWNED BY la_ext_disputestatus.disputestatusid;


CREATE TABLE la_ext_disputetype (
    disputetypeid integer NOT NULL,
    disputetype character varying(50) NOT NULL,
    disputetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_disputetype OWNER TO postgres;


CREATE SEQUENCE la_ext_disputetype_disputetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_disputetype_disputetypeid_seq OWNER TO postgres;


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


ALTER TABLE la_ext_documentdetails OWNER TO postgres;



CREATE SEQUENCE la_ext_documentdetails_documentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documentdetails_documentid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_documentdetails_documentid_seq OWNED BY la_ext_documentdetails.documentid;


CREATE TABLE la_ext_documentformat (
    documentformatid integer NOT NULL,
    documentformat character varying(50) NOT NULL,
    documentformat_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_documentformat OWNER TO postgres;


CREATE SEQUENCE la_ext_documentformat_documentformatid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documentformat_documentformatid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_documentformat_documentformatid_seq OWNED BY la_ext_documentformat.documentformatid;


CREATE TABLE la_ext_documenttype (
    documenttypeid integer NOT NULL,
    documenttype character varying(50) NOT NULL,
    documenttype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    processid integer
);


ALTER TABLE la_ext_documenttype OWNER TO postgres;


CREATE SEQUENCE la_ext_documenttype_documenttypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_documenttype_documenttypeid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_documenttype_documenttypeid_seq OWNED BY la_ext_documenttype.documenttypeid;


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


CREATE SEQUENCE la_ext_existingclaim_documentid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_existingclaim_documentid_seq OWNER TO postgres;


CREATE TABLE la_ext_financialagency (
    financialagencyid integer NOT NULL,
    financialagency character varying(100) NOT NULL,
    financialagency_en character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_financialagency OWNER TO postgres;


CREATE SEQUENCE la_ext_financialagency_financialagencyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_financialagency_financialagencyid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_financialagency_financialagencyid_seq OWNED BY la_ext_financialagency.financialagencyid;



CREATE TABLE la_ext_geometrytype (
    geometrytypeid integer NOT NULL,
    geometryname character varying(20) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_geometrytype OWNER TO postgres;



CREATE SEQUENCE la_ext_geometrytype_geometryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_geometrytype_geometryid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_geometrytype_geometryid_seq OWNED BY la_ext_geometrytype.geometrytypeid;




CREATE TABLE la_ext_grouptype (
    grouptypeid integer NOT NULL,
    grouptype character varying(50) NOT NULL,
    grouptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_grouptype OWNER TO postgres;



CREATE SEQUENCE la_ext_grouptype_grouptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_grouptype_grouptypeid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_grouptype_grouptypeid_seq OWNED BY la_ext_grouptype.grouptypeid;


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


CREATE SEQUENCE la_ext_landworkflowhistory_landworkflowhistoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_landworkflowhistory_landworkflowhistoryid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_landworkflowhistory_landworkflowhistoryid_seq OWNED BY la_ext_landworkflowhistory.landworkflowhistoryid;




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



CREATE SEQUENCE la_ext_layer_layergroup_layer_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layer_layergroup_layer_layergroupid_seq OWNER TO postgres;



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


ALTER TABLE la_ext_layerfield OWNER TO postgres;


CREATE SEQUENCE la_ext_layerfield_layerfieldid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layerfield_layerfieldid_seq OWNER TO postgres;



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


ALTER TABLE la_ext_layergroup OWNER TO postgres;



CREATE SEQUENCE la_ext_layergroup_layergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layergroup_layergroupid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_layergroup_layergroupid_seq OWNED BY la_ext_layergroup.layergroupid;




CREATE TABLE la_ext_layertype (
    layertypeid integer NOT NULL,
    layertype character varying(50) NOT NULL,
    layertype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_layertype OWNER TO postgres;


CREATE SEQUENCE la_ext_layertype_layertypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_layertype_layertypeid_seq OWNER TO postgres;

ALTER SEQUENCE la_ext_layertype_layertypeid_seq OWNED BY la_ext_layertype.layertypeid;



CREATE TABLE la_ext_module (
    moduleid integer NOT NULL,
    modulename character varying(50) NOT NULL,
    modulename_en character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_module OWNER TO postgres;



CREATE SEQUENCE la_ext_module_moduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_module_moduleid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_module_moduleid_seq OWNED BY la_ext_module.moduleid;




CREATE TABLE la_ext_month (
    monthid integer NOT NULL,
    month character varying(10) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_month OWNER TO postgres;



CREATE SEQUENCE la_ext_month_monthid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_month_monthid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_month_monthid_seq OWNED BY la_ext_month.monthid;



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


CREATE SEQUENCE la_ext_personlandmapping_personlandid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_personlandmapping_personlandid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_personlandmapping_personlandid_seq OWNED BY la_ext_personlandmapping.personlandid;




CREATE TABLE la_ext_process (
    processid integer NOT NULL,
    processname character varying(50),
    processname_en character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_process OWNER TO postgres;


CREATE SEQUENCE la_ext_process_processid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_process_processid_seq OWNER TO postgres;


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


ALTER TABLE la_ext_projectadjudicator OWNER TO postgres;


CREATE SEQUENCE la_ext_projectadjudicator_projectadjudicatorid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectadjudicator_projectadjudicatorid_seq OWNER TO postgres;



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


ALTER TABLE la_ext_projectarea OWNER TO postgres;


CREATE SEQUENCE la_ext_projectarea_projectareaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectarea_projectareaid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_projectarea_projectareaid_seq OWNED BY la_ext_projectarea.projectareaid;



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


CREATE SEQUENCE la_ext_projectbaselayermapping_projectbaselayerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectbaselayermapping_projectbaselayerid_seq OWNER TO postgres;

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


ALTER TABLE la_ext_projectfile OWNER TO postgres;


CREATE SEQUENCE la_ext_projectfile_projectfileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectfile_projectfileid_seq OWNER TO postgres;


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


ALTER TABLE la_ext_projecthamlet OWNER TO postgres;



CREATE SEQUENCE la_ext_projecthamlet_projecthamletid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projecthamlet_projecthamletid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_projecthamlet_projecthamletid_seq OWNED BY la_ext_projecthamlet.projecthamletid;


CREATE TABLE la_ext_projection (
    projectionid integer NOT NULL,
    projection character varying(50) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_projection OWNER TO postgres;



CREATE SEQUENCE la_ext_projection_projectionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projection_projectionid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_projection_projectionid_seq OWNED BY la_ext_projection.projectionid;



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


CREATE SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_projectlayergroupmapping_projectlayergroupid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_projectlayergroupmapping_projectlayergroupid_seq OWNED BY la_ext_projectlayergroupmapping.projectlayergroupid;



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



CREATE SEQUENCE la_ext_resource_custom_attribute_customattributeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resource_custom_attribute_customattributeid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_resource_custom_attribute_customattributeid_seq OWNED BY la_ext_resource_custom_attribute.customattributeid;



CREATE SEQUENCE la_ext_resourcecustomattributevalue_customattributevalueid_seq
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcecustomattributevalue_customattributevalueid_seq OWNER TO postgres;


CREATE TABLE la_ext_resource_custom_attributevalue (
    customattributevalueid integer DEFAULT nextval('la_ext_resourcecustomattributevalue_customattributevalueid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    customattributeid integer NOT NULL,
    subclassificationid integer,
    attributevalue character varying(1000) NOT NULL,
    geomtype character varying(50) NOT NULL
);


ALTER TABLE la_ext_resource_custom_attributevalue OWNER TO postgres;


CREATE TABLE la_ext_resource_documentdetails (
    documentid integer NOT NULL,
    transactionid integer,
    landid bigint,
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


ALTER TABLE la_ext_resource_documentdetails OWNER TO postgres;


CREATE SEQUENCE la_ext_resource_documentdetails_documentid_seq
    START WITH 300
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resource_documentdetails_documentid_seq OWNER TO postgres;



CREATE SEQUENCE la_ext_resourceattributevalue_attributevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourceattributevalue_attributevalueid_seq OWNER TO postgres;


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


CREATE TABLE la_ext_resourceclassification (
    classificationid integer NOT NULL,
    classificationname character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_resourceclassification OWNER TO postgres;



CREATE SEQUENCE la_ext_resourceclassification_classificationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourceclassification_classificationid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_resourceclassification_classificationid_seq OWNED BY la_ext_resourceclassification.classificationid;


CREATE SEQUENCE la_ext_resourcelandclassificationmapping_landclassmappingid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcelandclassificationmapping_landclassmappingid_seq OWNER TO postgres;

CREATE TABLE la_ext_resourcelandclassificationmapping (
    landclassmappingid integer DEFAULT nextval('la_ext_resourcelandclassificationmapping_landclassmappingid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    classificationid integer NOT NULL,
    subclassificationid integer NOT NULL,
    geomtype character varying(50) NOT NULL
);


ALTER TABLE la_ext_resourcelandclassificationmapping OWNER TO postgres;


CREATE SEQUENCE la_ext_resourcepoiattributemasterid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcepoiattributemasterid_seq OWNER TO postgres;


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

CREATE SEQUENCE la_ext_resourcepoiattributevalue_attributevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcepoiattributevalue_attributevalueid_seq OWNER TO postgres;


CREATE TABLE la_ext_resourcepoiattributevalue (
    poiattributevalueid integer DEFAULT nextval('la_ext_resourcepoiattributevalue_attributevalueid_seq'::regclass) NOT NULL,
    projectid integer NOT NULL,
    landid integer NOT NULL,
    attributemasterid integer NOT NULL,
    attributevalue character varying(1000) NOT NULL,
    geomtype character varying(50) NOT NULL
);


ALTER TABLE la_ext_resourcepoiattributevalue OWNER TO postgres;


CREATE TABLE la_ext_resourcesubclassification (
    subclassificationid integer NOT NULL,
    classificationid integer NOT NULL,
    geometrytypeid integer NOT NULL,
    subclassificationname character varying(100) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_resourcesubclassification OWNER TO postgres;


CREATE SEQUENCE la_ext_resourcesubclassification_subclassificationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_resourcesubclassification_subclassificationid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_resourcesubclassification_subclassificationid_seq OWNED BY la_ext_resourcesubclassification.subclassificationid;




CREATE TABLE la_ext_role (
    roleid integer NOT NULL,
    roletype character varying(30) NOT NULL,
    roletype_en character varying(30) NOT NULL,
    description character varying(50),
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_role OWNER TO postgres;

CREATE SEQUENCE la_ext_role_roleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_role_roleid_seq OWNER TO postgres;


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


ALTER TABLE la_ext_rolemodulemapping OWNER TO postgres;



CREATE SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_rolemodulemapping_rolemoduleid_seq OWNER TO postgres;



ALTER SEQUENCE la_ext_rolemodulemapping_rolemoduleid_seq OWNED BY la_ext_rolemodulemapping.rolemoduleid;



CREATE TABLE la_ext_slopevalue (
    slopevalueid integer NOT NULL,
    slopevalue character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_slopevalue OWNER TO postgres;



CREATE SEQUENCE la_ext_slopevalue_slopevalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_slopevalue_slopevalueid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_slopevalue_slopevalueid_seq OWNED BY la_ext_slopevalue.slopevalueid;



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
    typeid bigint
);


ALTER TABLE la_ext_spatialunit_personwithinterest OWNER TO postgres;

CREATE SEQUENCE la_ext_spatialunit_personwithinterest_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_spatialunit_personwithinterest_id_seq OWNER TO postgres;


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


CREATE SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_surveyprojectattributes_surveyprojectattributesid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_surveyprojectattributes_surveyprojectattributesid_seq OWNED BY la_ext_surveyprojectattributes.surveyprojectattributesid;



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



CREATE SEQUENCE la_ext_transactiondetails_transactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_transactiondetails_transactionid_seq OWNER TO postgres;


ALTER SEQUENCE la_ext_transactiondetails_transactionid_seq OWNED BY la_ext_transactiondetails.transactionid;


CREATE TABLE la_ext_unit (
    unitid integer NOT NULL,
    unit character varying(50) NOT NULL,
    unit_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_ext_unit OWNER TO postgres;

CREATE SEQUENCE la_ext_unit_unitid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_unit_unitid_seq OWNER TO postgres;


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


ALTER TABLE la_ext_user OWNER TO postgres;


CREATE SEQUENCE la_ext_user_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_user_userid_seq OWNER TO postgres;

-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 310
-- Name: la_ext_user_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_user_userid_seq OWNED BY la_ext_user.userid;



-- TOC entry 311 (class 1259 OID 212008)
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


-- TOC entry 312 (class 1259 OID 212012)
-- Name: la_ext_userprojectmapping_userprojectid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_userprojectmapping_userprojectid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_userprojectmapping_userprojectid_seq OWNER TO postgres;


-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 312
-- Name: la_ext_userprojectmapping_userprojectid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_userprojectmapping_userprojectid_seq OWNED BY la_ext_userprojectmapping.userprojectid;


-- TOC entry 313 (class 1259 OID 212014)
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


-- TOC entry 314 (class 1259 OID 212018)
-- Name: la_ext_userrolemapping_userroleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_userrolemapping_userroleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_userrolemapping_userroleid_seq OWNER TO postgres;


-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 314
-- Name: la_ext_userrolemapping_userroleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_userrolemapping_userroleid_seq OWNED BY la_ext_userrolemapping.userroleid;



-- TOC entry 315 (class 1259 OID 212020)
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


CREATE SEQUENCE la_ext_workflow_workflowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflow_workflowid_seq OWNER TO postgres;


-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 316
-- Name: la_ext_workflow_workflowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_workflow_workflowid_seq OWNED BY la_ext_workflow.workflowid;


-- TOC entry 317 (class 1259 OID 212026)
-- Name: la_ext_workflowactionmapping_workflowactionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_workflowactionmapping_workflowactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflowactionmapping_workflowactionid_seq OWNER TO postgres;


-- TOC entry 318 (class 1259 OID 212028)
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


-- TOC entry 319 (class 1259 OID 212032)
-- Name: la_ext_workflowdef; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_ext_workflowdef (
    workflowdefid integer NOT NULL,
    name character varying(50),
    type integer
);


ALTER TABLE la_ext_workflowdef OWNER TO postgres;


-- TOC entry 320 (class 1259 OID 212035)
-- Name: la_ext_workflowdef_workflowdefid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_ext_workflowdef_workflowdefid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_ext_workflowdef_workflowdefid_seq OWNER TO postgres;


-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 320
-- Name: la_ext_workflowdef_workflowdefid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_ext_workflowdef_workflowdefid_seq OWNED BY la_ext_workflowdef.workflowdefid;



-- TOC entry 321 (class 1259 OID 212037)
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


-- TOC entry 322 (class 1259 OID 212054)
-- Name: la_lease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_lease (
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
    ownerid bigint
);


ALTER TABLE la_lease OWNER TO postgres;


-- TOC entry 323 (class 1259 OID 212058)
-- Name: la_lease_leaseid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_lease_leaseid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_lease_leaseid_seq OWNER TO postgres;


-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 323
-- Name: la_lease_leaseid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_lease_leaseid_seq OWNED BY la_lease.leaseid;



-- TOC entry 324 (class 1259 OID 212060)
-- Name: la_mortgage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_mortgage (
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


ALTER TABLE la_mortgage OWNER TO postgres;



CREATE SEQUENCE la_mortgage_mortgageid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_mortgage_mortgageid_seq OWNER TO postgres;


-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 325
-- Name: la_mortgage_mortgageid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_mortgage_mortgageid_seq OWNED BY la_mortgage.mortgageid;



-- TOC entry 326 (class 1259 OID 212066)
-- Name: la_party; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_party (
    partyid bigint NOT NULL,
    persontypeid integer,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL
);


ALTER TABLE la_party OWNER TO postgres;


-- TOC entry 327 (class 1259 OID 212069)
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


-- TOC entry 328 (class 1259 OID 212073)
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


-- TOC entry 329 (class 1259 OID 212080)
-- Name: la_party_partyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_party_partyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_party_partyid_seq OWNER TO postgres;


-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 329
-- Name: la_party_partyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_party_partyid_seq OWNED BY la_party.partyid;



-- TOC entry 330 (class 1259 OID 212082)
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
    modifieddate timestamp without time zone
);


ALTER TABLE la_party_person OWNER TO postgres;


-- TOC entry 331 (class 1259 OID 212089)
-- Name: la_partygroup_educationlevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_educationlevel (
    educationlevelid integer NOT NULL,
    educationlevel character varying(50) NOT NULL,
    educationlevel_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_educationlevel OWNER TO postgres;


-- TOC entry 332 (class 1259 OID 212093)
-- Name: la_partygroup_educationlevel_educationlevelid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_educationlevel_educationlevelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_educationlevel_educationlevelid_seq OWNER TO postgres;


-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 332
-- Name: la_partygroup_educationlevel_educationlevelid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_educationlevel_educationlevelid_seq OWNED BY la_partygroup_educationlevel.educationlevelid;



-- TOC entry 333 (class 1259 OID 212095)
-- Name: la_partygroup_gender; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_gender (
    genderid integer NOT NULL,
    gender character varying(50) NOT NULL,
    gender_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_gender OWNER TO postgres;


-- TOC entry 334 (class 1259 OID 212099)
-- Name: la_partygroup_gender_genderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_gender_genderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_gender_genderid_seq OWNER TO postgres;


-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 334
-- Name: la_partygroup_gender_genderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_gender_genderid_seq OWNED BY la_partygroup_gender.genderid;



-- TOC entry 335 (class 1259 OID 212101)
-- Name: la_partygroup_identitytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_identitytype (
    identitytypeid integer NOT NULL,
    identitytype character varying(50) NOT NULL,
    identitytype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_identitytype OWNER TO postgres;


-- TOC entry 336 (class 1259 OID 212105)
-- Name: la_partygroup_identitytype_identitytypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_identitytype_identitytypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_identitytype_identitytypeid_seq OWNER TO postgres;


-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 336
-- Name: la_partygroup_identitytype_identitytypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_identitytype_identitytypeid_seq OWNED BY la_partygroup_identitytype.identitytypeid;



-- TOC entry 337 (class 1259 OID 212107)
-- Name: la_partygroup_maritalstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_maritalstatus (
    maritalstatusid integer NOT NULL,
    maritalstatus character varying(50) NOT NULL,
    maritalstatus_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_maritalstatus OWNER TO postgres;


-- TOC entry 338 (class 1259 OID 212111)
-- Name: la_partygroup_maritalstatus_maritalstatusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_maritalstatus_maritalstatusid_seq OWNER TO postgres;


-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 338
-- Name: la_partygroup_maritalstatus_maritalstatusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_maritalstatus_maritalstatusid_seq OWNED BY la_partygroup_maritalstatus.maritalstatusid;



-- TOC entry 339 (class 1259 OID 212113)
-- Name: la_partygroup_occupation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_occupation (
    occupationid integer NOT NULL,
    occupation character varying(50) NOT NULL,
    occupation_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_occupation OWNER TO postgres;


-- TOC entry 340 (class 1259 OID 212117)
-- Name: la_partygroup_occupation_occupationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_occupation_occupationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_occupation_occupationid_seq OWNER TO postgres;


-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 340
-- Name: la_partygroup_occupation_occupationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_occupation_occupationid_seq OWNED BY la_partygroup_occupation.occupationid;



-- TOC entry 341 (class 1259 OID 212119)
-- Name: la_partygroup_persontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_persontype (
    persontypeid integer NOT NULL,
    persontype character varying(50) NOT NULL,
    persontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_persontype OWNER TO postgres;


-- TOC entry 342 (class 1259 OID 212123)
-- Name: la_partygroup_persontype_persontypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_persontype_persontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_persontype_persontypeid_seq OWNER TO postgres;


-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 342
-- Name: la_partygroup_persontype_persontypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_persontype_persontypeid_seq OWNED BY la_partygroup_persontype.persontypeid;



-- TOC entry 343 (class 1259 OID 212125)
-- Name: la_partygroup_relationshiptype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_partygroup_relationshiptype (
    relationshiptypeid integer NOT NULL,
    relationshiptype character varying(50) NOT NULL,
    relationshiptype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_partygroup_relationshiptype OWNER TO postgres;

-- TOC entry 344 (class 1259 OID 212129)
-- Name: la_partygroup_relationshiptype_relationshiptypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_partygroup_relationshiptype_relationshiptypeid_seq OWNER TO postgres;


-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 344
-- Name: la_partygroup_relationshiptype_relationshiptypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_partygroup_relationshiptype_relationshiptypeid_seq OWNED BY la_partygroup_relationshiptype.relationshiptypeid;



-- TOC entry 345 (class 1259 OID 212131)
-- Name: la_right_acquisitiontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_acquisitiontype (
    acquisitiontypeid integer NOT NULL,
    acquisitiontype character varying(50) NOT NULL,
    acquisitiontype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_acquisitiontype OWNER TO postgres;


-- TOC entry 346 (class 1259 OID 212135)
-- Name: la_right_acquisitiontype_acquisitiontypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_acquisitiontype_acquisitiontypeid_seq OWNER TO postgres;


-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 346
-- Name: la_right_acquisitiontype_acquisitiontypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_acquisitiontype_acquisitiontypeid_seq OWNED BY la_right_acquisitiontype.acquisitiontypeid;



-- TOC entry 347 (class 1259 OID 212137)
-- Name: la_right_claimtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_claimtype (
    claimtypeid integer NOT NULL,
    claimtype character varying(50) NOT NULL,
    claimtype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_claimtype OWNER TO postgres;


-- TOC entry 348 (class 1259 OID 212141)
-- Name: la_right_claimtype_claimtypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_claimtype_claimtypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_claimtype_claimtypeid_seq OWNER TO postgres;


-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 348
-- Name: la_right_claimtype_claimtypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_claimtype_claimtypeid_seq OWNED BY la_right_claimtype.claimtypeid;



-- TOC entry 349 (class 1259 OID 212143)
-- Name: la_right_landsharetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_landsharetype (
    landsharetypeid integer NOT NULL,
    landsharetype character varying(50) NOT NULL,
    landsharetype_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_landsharetype OWNER TO postgres;


-- TOC entry 350 (class 1259 OID 212147)
-- Name: la_right_landsharetype_landsharetypeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_landsharetype_landsharetypeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_landsharetype_landsharetypeid_seq OWNER TO postgres;


-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 350
-- Name: la_right_landsharetype_landsharetypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_landsharetype_landsharetypeid_seq OWNED BY la_right_landsharetype.landsharetypeid;



-- TOC entry 351 (class 1259 OID 212149)
-- Name: la_right_tenureclass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_right_tenureclass (
    tenureclassid integer NOT NULL,
    tenureclass character varying(50) NOT NULL,
    tenureclass_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_right_tenureclass OWNER TO postgres;


-- TOC entry 352 (class 1259 OID 212153)
-- Name: la_right_tenureclass_tenureclassid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_right_tenureclass_tenureclassid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_right_tenureclass_tenureclassid_seq OWNER TO postgres;

-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 352
-- Name: la_right_tenureclass_tenureclassid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_right_tenureclass_tenureclassid_seq OWNED BY la_right_tenureclass.tenureclassid;



-- TOC entry 353 (class 1259 OID 212155)
-- Name: la_rrr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_rrr (
    rrrid integer NOT NULL,
    rrrtype character varying(50) NOT NULL,
    rrrtypeid integer NOT NULL
);


ALTER TABLE la_rrr OWNER TO postgres;


-- TOC entry 354 (class 1259 OID 212158)
-- Name: la_rrr_rrrid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_rrr_rrrid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_rrr_rrrid_seq OWNER TO postgres;


-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 354
-- Name: la_rrr_rrrid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_rrr_rrrid_seq OWNED BY la_rrr.rrrid;



-- TOC entry 355 (class 1259 OID 212160)
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


-- TOC entry 356 (class 1259 OID 212176)
-- Name: la_spatialsource_layer_layerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialsource_layer_layerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialsource_layer_layerid_seq OWNER TO postgres;

-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 356
-- Name: la_spatialsource_layer_layerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialsource_layer_layerid_seq OWNED BY la_spatialsource_layer.layerid;



-- TOC entry 357 (class 1259 OID 212178)
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


-- TOC entry 358 (class 1259 OID 212185)
-- Name: la_spatialsource_projectname_projectnameid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialsource_projectname_projectnameid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialsource_projectname_projectnameid_seq OWNER TO postgres;


-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 358
-- Name: la_spatialsource_projectname_projectnameid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialsource_projectname_projectnameid_seq OWNED BY la_spatialsource_projectname.projectnameid;



-- TOC entry 359 (class 1259 OID 212187)
-- Name: la_spatialunit_aoi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE la_spatialunit_aoi (
    aoiid integer NOT NULL,
    userid integer NOT NULL,
    projectnameid integer NOT NULL,
    applicationstatusid integer,
    geometry geometry NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer,
    createddate timestamp without time zone,
    modifiedby integer,
    modifieddate timestamp without time zone,
    aoiname character(50),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_aoi OWNER TO postgres;


-- TOC entry 360 (class 1259 OID 212195)
-- Name: la_spatialunit_aoi_aoiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE la_spatialunit_aoi_aoiid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_aoi_aoiid_seq OWNER TO postgres;


-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 360
-- Name: la_spatialunit_aoi_aoiid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE la_spatialunit_aoi_aoiid_seq OWNED BY la_spatialunit_aoi.aoiid;



-- TOC entry 361 (class 1259 OID 212197)
-- Name: la_spatialunit_land; Type: TABLE; Schema: public; Owner: postgres
--

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
    geometry geometry,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    occupancylength integer,
    claimno integer DEFAULT 1 NOT NULL,
    proposedused integer NOT NULL,
    oldlandid bigint,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_land OWNER TO postgres;


CREATE SEQUENCE la_spatialunit_land_landid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_land_landid_seq OWNER TO postgres;


ALTER SEQUENCE la_spatialunit_land_landid_seq OWNED BY la_spatialunit_land.landid;




CREATE SEQUENCE la_spatialunit_resource_land_landid_seq
    START WITH 183
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_resource_land_landid_seq OWNER TO postgres;



CREATE TABLE la_spatialunit_resource_land (
    landid bigint DEFAULT nextval('la_spatialunit_resource_land_landid_seq'::regclass) NOT NULL,
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
    geometry geometry,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POLYGON'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_land OWNER TO postgres;


CREATE SEQUENCE la_spatialunit_resource_line_landid_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_resource_line_landid_seq OWNER TO postgres;


CREATE TABLE la_spatialunit_resource_line (
    landid bigint DEFAULT nextval('la_spatialunit_resource_line_landid_seq'::regclass) NOT NULL,
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
    geometry geometry,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'LINESTRING'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_line OWNER TO postgres;


CREATE SEQUENCE la_spatialunit_resource_point_landid_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunit_resource_point_landid_seq OWNER TO postgres;



CREATE TABLE la_spatialunit_resource_point (
    landid bigint DEFAULT nextval('la_spatialunit_resource_point_landid_seq'::regclass) NOT NULL,
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
    geometry geometry,
    isactive boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp without time zone NOT NULL,
    modifiedby integer,
    modifieddate timestamp without time zone,
    applicationstatusid integer,
    workflowstatusid integer,
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geometry) = 'POINT'::text) OR (geometry IS NULL)))
);


ALTER TABLE la_spatialunit_resource_point OWNER TO postgres;



CREATE TABLE la_spatialunitgroup (
    spatialunitgroupid integer NOT NULL,
    hierarchy character varying(50) NOT NULL,
    hierarchy_en character varying(50) NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_spatialunitgroup OWNER TO postgres;



CREATE TABLE la_spatialunitgroup_hierarchy (
    hierarchyid integer NOT NULL,
    name character varying(50) NOT NULL,
    name_en character varying(50) NOT NULL,
    spatialunitgroupid integer,
    uperhierarchyid integer,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE la_spatialunitgroup_hierarchy OWNER TO postgres;



CREATE SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunitgroup_hierarchy_hierarchyid_seq OWNER TO postgres;


ALTER SEQUENCE la_spatialunitgroup_hierarchy_hierarchyid_seq OWNED BY la_spatialunitgroup_hierarchy.hierarchyid;



CREATE SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_spatialunitgroup_spatialunitgroupid_seq OWNER TO postgres;



ALTER SEQUENCE la_spatialunitgroup_spatialunitgroupid_seq OWNED BY la_spatialunitgroup.spatialunitgroupid;



CREATE SEQUENCE la_surrenderlease_leaseid_seq
    START WITH 35
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE la_surrenderlease_leaseid_seq OWNER TO postgres;


CREATE TABLE la_surrenderlease (
    leaseid integer DEFAULT nextval('la_surrenderlease_leaseid_seq'::regclass) NOT NULL,
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
    ownerid bigint
);


ALTER TABLE la_surrenderlease OWNER TO postgres;



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


ALTER TABLE view_claimants_for_editing OWNER TO postgres;



ALTER TABLE ONLY la_baunit_landsoilquality ALTER COLUMN landsoilqualityid SET DEFAULT nextval('la_baunit_landsoilquality_landsoilqualityid_seq'::regclass);



ALTER TABLE ONLY la_baunit_landtype ALTER COLUMN landtypeid SET DEFAULT nextval('la_baunit_landtype_landtypeid_seq'::regclass);




ALTER TABLE ONLY la_baunit_landusetype ALTER COLUMN landusetypeid SET DEFAULT nextval('la_baunit_landusetype_landusetypeid_seq'::regclass);



-- TOC entry 3946 (class 2604 OID 212293)
-- Name: applicationstatusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_applicationstatus ALTER COLUMN applicationstatusid SET DEFAULT nextval('la_ext_applicationstatus_applicationstatusid_seq'::regclass);



-- TOC entry 3947 (class 2604 OID 212294)
-- Name: attributeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_attribute ALTER COLUMN attributeid SET DEFAULT nextval('la_ext_attribute_attributeid_seq'::regclass);



ALTER TABLE ONLY la_ext_attributecategory ALTER COLUMN attributecategoryid SET DEFAULT nextval('la_ext_attributecategory_attributecategoryid_seq'::regclass);



ALTER TABLE ONLY la_ext_attributedatatype ALTER COLUMN datatypemasterid SET DEFAULT nextval('la_ext_attributedatatype_datatypemasterid_seq'::regclass);




ALTER TABLE ONLY la_ext_attributemaster ALTER COLUMN attributemasterid SET DEFAULT nextval('la_ext_attributemaster_attributemasterid_seq'::regclass);




ALTER TABLE ONLY la_ext_attributeoptions ALTER COLUMN attributeoptionsid SET DEFAULT nextval('la_ext_attributeoptions_attributeoptionsid_seq'::regclass);




ALTER TABLE ONLY la_ext_baselayer ALTER COLUMN baselayerid SET DEFAULT nextval('la_ext_baselayer_baselayerid_seq'::regclass);



ALTER TABLE ONLY la_ext_bookmark ALTER COLUMN bookmarkid SET DEFAULT nextval('la_ext_bookmark_bookmarkid_seq'::regclass);




ALTER TABLE ONLY la_ext_categorytype ALTER COLUMN categorytypeid SET DEFAULT nextval('la_ext_categorytype_categorytypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_disputelandmapping ALTER COLUMN disputelandid SET DEFAULT nextval('la_ext_disputelandmapping_disputelandid_seq'::regclass);




ALTER TABLE ONLY la_ext_disputestatus ALTER COLUMN disputestatusid SET DEFAULT nextval('la_ext_disputestatus_disputestatusid_seq'::regclass);




ALTER TABLE ONLY la_ext_disputetype ALTER COLUMN disputetypeid SET DEFAULT nextval('la_ext_disputetype_disputetypeid_seq'::regclass);




ALTER TABLE ONLY la_ext_documentdetails ALTER COLUMN documentid SET DEFAULT nextval('la_ext_documentdetails_documentid_seq'::regclass);



ALTER TABLE ONLY la_ext_documentformat ALTER COLUMN documentformatid SET DEFAULT nextval('la_ext_documentformat_documentformatid_seq'::regclass);



ALTER TABLE ONLY la_ext_documenttype ALTER COLUMN documenttypeid SET DEFAULT nextval('la_ext_documenttype_documenttypeid_seq'::regclass);




ALTER TABLE ONLY la_ext_financialagency ALTER COLUMN financialagencyid SET DEFAULT nextval('la_ext_financialagency_financialagencyid_seq'::regclass);



ALTER TABLE ONLY la_ext_geometrytype ALTER COLUMN geometrytypeid SET DEFAULT nextval('la_ext_geometrytype_geometryid_seq'::regclass);



ALTER TABLE ONLY la_ext_grouptype ALTER COLUMN grouptypeid SET DEFAULT nextval('la_ext_grouptype_grouptypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_landworkflowhistory ALTER COLUMN landworkflowhistoryid SET DEFAULT nextval('la_ext_landworkflowhistory_landworkflowhistoryid_seq'::regclass);




ALTER TABLE ONLY la_ext_layer_layergroup ALTER COLUMN layer_layergroupid SET DEFAULT nextval('la_ext_layer_layergroup_layer_layergroupid_seq'::regclass);




ALTER TABLE ONLY la_ext_layerfield ALTER COLUMN layerfieldid SET DEFAULT nextval('la_ext_layerfield_layerfieldid_seq'::regclass);




ALTER TABLE ONLY la_ext_layergroup ALTER COLUMN layergroupid SET DEFAULT nextval('la_ext_layergroup_layergroupid_seq'::regclass);


ALTER TABLE ONLY la_ext_layertype ALTER COLUMN layertypeid SET DEFAULT nextval('la_ext_layertype_layertypeid_seq'::regclass);



ALTER TABLE ONLY la_ext_module ALTER COLUMN moduleid SET DEFAULT nextval('la_ext_module_moduleid_seq'::regclass);



ALTER TABLE ONLY la_ext_month ALTER COLUMN monthid SET DEFAULT nextval('la_ext_month_monthid_seq'::regclass);



ALTER TABLE ONLY la_ext_personlandmapping ALTER COLUMN personlandid SET DEFAULT nextval('la_ext_personlandmapping_personlandid_seq'::regclass);



ALTER TABLE ONLY la_ext_process ALTER COLUMN processid SET DEFAULT nextval('la_ext_process_processid_seq'::regclass);




ALTER TABLE ONLY la_ext_projectadjudicator ALTER COLUMN projectadjudicatorid SET DEFAULT nextval('la_ext_projectadjudicator_projectadjudicatorid_seq'::regclass);




ALTER TABLE ONLY la_ext_projectarea ALTER COLUMN projectareaid SET DEFAULT nextval('la_ext_projectarea_projectareaid_seq'::regclass);



ALTER TABLE ONLY la_ext_projectbaselayermapping ALTER COLUMN projectbaselayerid SET DEFAULT nextval('la_ext_projectbaselayermapping_projectbaselayerid_seq'::regclass);




ALTER TABLE ONLY la_ext_projectfile ALTER COLUMN projectfileid SET DEFAULT nextval('la_ext_projectfile_projectfileid_seq'::regclass);



ALTER TABLE ONLY la_ext_projecthamlet ALTER COLUMN projecthamletid SET DEFAULT nextval('la_ext_projecthamlet_projecthamletid_seq'::regclass);




ALTER TABLE ONLY la_ext_projection ALTER COLUMN projectionid SET DEFAULT nextval('la_ext_projection_projectionid_seq'::regclass);



ALTER TABLE ONLY la_ext_projectlayergroupmapping ALTER COLUMN projectlayergroupid SET DEFAULT nextval('la_ext_projectlayergroupmapping_projectlayergroupid_seq'::regclass);




ALTER TABLE ONLY la_ext_resource_custom_attribute ALTER COLUMN customattributeid SET DEFAULT nextval('la_ext_resource_custom_attribute_customattributeid_seq'::regclass);




ALTER TABLE ONLY la_ext_resourceclassification ALTER COLUMN classificationid SET DEFAULT nextval('la_ext_resourceclassification_classificationid_seq'::regclass);




ALTER TABLE ONLY la_ext_resourcesubclassification ALTER COLUMN subclassificationid SET DEFAULT nextval('la_ext_resourcesubclassification_subclassificationid_seq'::regclass);




ALTER TABLE ONLY la_ext_role ALTER COLUMN roleid SET DEFAULT nextval('la_ext_role_roleid_seq'::regclass);





ALTER TABLE ONLY la_ext_rolemodulemapping ALTER COLUMN rolemoduleid SET DEFAULT nextval('la_ext_rolemodulemapping_rolemoduleid_seq'::regclass);




ALTER TABLE ONLY la_ext_slopevalue ALTER COLUMN slopevalueid SET DEFAULT nextval('la_ext_slopevalue_slopevalueid_seq'::regclass);




ALTER TABLE ONLY la_ext_surveyprojectattributes ALTER COLUMN surveyprojectattributesid SET DEFAULT nextval('la_ext_surveyprojectattributes_surveyprojectattributesid_seq'::regclass);




ALTER TABLE ONLY la_ext_transactiondetails ALTER COLUMN transactionid SET DEFAULT nextval('la_ext_transactiondetails_transactionid_seq'::regclass);



ALTER TABLE ONLY la_ext_unit ALTER COLUMN unitid SET DEFAULT nextval('la_ext_unit_unitid_seq'::regclass);



ALTER TABLE ONLY la_ext_user ALTER COLUMN userid SET DEFAULT nextval('la_ext_user_userid_seq'::regclass);



ALTER TABLE ONLY la_ext_userprojectmapping ALTER COLUMN userprojectid SET DEFAULT nextval('la_ext_userprojectmapping_userprojectid_seq'::regclass);




ALTER TABLE ONLY la_ext_userrolemapping ALTER COLUMN userroleid SET DEFAULT nextval('la_ext_userrolemapping_userroleid_seq'::regclass);



ALTER TABLE ONLY la_ext_workflow ALTER COLUMN workflowid SET DEFAULT nextval('la_ext_workflow_workflowid_seq'::regclass);



ALTER TABLE ONLY la_ext_workflowdef ALTER COLUMN workflowdefid SET DEFAULT nextval('la_ext_workflowdef_workflowdefid_seq'::regclass);



ALTER TABLE ONLY la_lease ALTER COLUMN leaseid SET DEFAULT nextval('la_lease_leaseid_seq'::regclass);




ALTER TABLE ONLY la_mortgage ALTER COLUMN mortgageid SET DEFAULT nextval('la_mortgage_mortgageid_seq'::regclass);




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


ALTER TABLE ONLY la_spatialunit_aoi ALTER COLUMN aoiid SET DEFAULT nextval('la_spatialunit_aoi_aoiid_seq'::regclass);




ALTER TABLE ONLY la_spatialunit_land ALTER COLUMN landid SET DEFAULT nextval('la_spatialunit_land_landid_seq'::regclass);




ALTER TABLE ONLY la_spatialunitgroup ALTER COLUMN spatialunitgroupid SET DEFAULT nextval('la_spatialunitgroup_spatialunitgroupid_seq'::regclass);


ALTER TABLE ONLY la_spatialunitgroup_hierarchy ALTER COLUMN hierarchyid SET DEFAULT nextval('la_spatialunitgroup_hierarchy_hierarchyid_seq'::regclass);



INSERT INTO la_baunit_landsoilquality VALUES (1, 'Very good', 'Very good', true);
INSERT INTO la_baunit_landsoilquality VALUES (2, 'Moderate good', 'Moderate good', true);
INSERT INTO la_baunit_landsoilquality VALUES (3, 'Poor', 'Poor', true);
INSERT INTO la_baunit_landsoilquality VALUES (4, 'Very poor', 'Very poor', true);



SELECT pg_catalog.setval('la_baunit_landsoilquality_landsoilqualityid_seq', 4, true);



INSERT INTO la_baunit_landtype VALUES (1, 'Flat/Plain', 'Flat/Plain', true);
INSERT INTO la_baunit_landtype VALUES (2, 'Sloping', 'Sloping', true);
INSERT INTO la_baunit_landtype VALUES (3, 'Mountainous', 'Mountainous', true);
INSERT INTO la_baunit_landtype VALUES (4, 'Valley', 'Valley', true);
INSERT INTO la_baunit_landtype VALUES (9999, 'Dummy', 'Dummy', true);

SELECT pg_catalog.setval('la_baunit_landtype_landtypeid_seq', 4, true);




INSERT INTO la_baunit_landusetype VALUES (1, 'Agriculture', 'Agriculture', true);
INSERT INTO la_baunit_landusetype VALUES (10, 'Minning', 'Minning', true);
INSERT INTO la_baunit_landusetype VALUES (11, 'Wildlife (hunting)', 'Wildlife (hunting)', true);
INSERT INTO la_baunit_landusetype VALUES (12, 'Wildlife (tourism)', 'Wildlife (tourism)', true);
INSERT INTO la_baunit_landusetype VALUES (13, 'Industrial', 'Industrial', true);
INSERT INTO la_baunit_landusetype VALUES (14, 'Conservation', 'Conservation', true);
INSERT INTO la_baunit_landusetype VALUES (2, 'Settlement', 'Settlement', true);
INSERT INTO la_baunit_landusetype VALUES (3, 'Livestock (intensive/ stationary)', 'Livestock (intensive/ stationary)', true);
INSERT INTO la_baunit_landusetype VALUES (4, 'Livestock (pastoralism)', 'Livestock (pastoralism)', true);
INSERT INTO la_baunit_landusetype VALUES (5, 'Forest/ Woodlands', 'Forest/ Woodlands', true);
INSERT INTO la_baunit_landusetype VALUES (6, 'Forest Reserve', 'Forest Reserve', true);
INSERT INTO la_baunit_landusetype VALUES (7, 'Grassland', 'Grassland', true);
INSERT INTO la_baunit_landusetype VALUES (8, 'Facility (church/mosque/recreation)', 'Facility (church/mosque/recreation)', true);
INSERT INTO la_baunit_landusetype VALUES (9, 'Commercial/Service ', 'Commercial/Service ', true);
INSERT INTO la_baunit_landusetype VALUES (9999, 'Dummy', 'Dummy', true);




SELECT pg_catalog.setval('la_baunit_landusetype_landusetypeid_seq', 15, true);




INSERT INTO la_ext_applicationstatus VALUES (1, 'New', 'New', true);
INSERT INTO la_ext_applicationstatus VALUES (2, 'Approved', 'Approved', true);
INSERT INTO la_ext_applicationstatus VALUES (3, 'Rejected', 'Rejected', true);
INSERT INTO la_ext_applicationstatus VALUES (4, 'Pending', 'Pending', true);
INSERT INTO la_ext_applicationstatus VALUES (5, 'Registered', 'Registered', true);




SELECT pg_catalog.setval('la_ext_applicationstatus_applicationstatusid_seq', 5, true);


SELECT pg_catalog.setval('la_ext_attribute_attributeid_seq', 3239, true);




INSERT INTO la_ext_attributecategory VALUES (1, 'General', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (6, 'custom', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (7, 'General(Property)', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (3, 'Multimedia', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (4, 'Tenure', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (8, 'Person of Interest', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (2, 'Person', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (5, 'Organization', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (16, 'Add Person', 1, 1);
INSERT INTO la_ext_attributecategory VALUES (10, 'Private (individual)', 2, 1);
INSERT INTO la_ext_attributecategory VALUES (17, 'Private (jointly)', 2, 2);
INSERT INTO la_ext_attributecategory VALUES (18, 'Organization (informal)', 2, 3);
INSERT INTO la_ext_attributecategory VALUES (14, 'Organization (formal)', 2, 4);
INSERT INTO la_ext_attributecategory VALUES (12, 'Community', 2, 5);
INSERT INTO la_ext_attributecategory VALUES (11, 'Collective', 2, 6);
INSERT INTO la_ext_attributecategory VALUES (9, 'Open', 2, 7);
INSERT INTO la_ext_attributecategory VALUES (13, 'Public', 2, 8);
INSERT INTO la_ext_attributecategory VALUES (15, 'Other', 2, 9);




SELECT pg_catalog.setval('la_ext_attributecategory_attributecategoryid_seq', 19, true);




INSERT INTO la_ext_attributedatatype VALUES (1, 'String');
INSERT INTO la_ext_attributedatatype VALUES (3, 'Boolean');
INSERT INTO la_ext_attributedatatype VALUES (2, 'Date');
INSERT INTO la_ext_attributedatatype VALUES (4, 'Number');
INSERT INTO la_ext_attributedatatype VALUES (5, 'Dropdown');
INSERT INTO la_ext_attributedatatype VALUES (6, 'Multiselect');




SELECT pg_catalog.setval('la_ext_attributedatatype_datatypemasterid_seq', 7, false);



INSERT INTO la_ext_attributemaster VALUES (1011, 'private', 'private', 1, 10, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1012, 'common', 'common', 1, 11, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1013, 'community', 'community', 1, 12, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1014, 'public_state', 'public_state', 1, 13, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1017, 'firstname', 'First Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (10, 'comments', 'Comments', 1, 3, 'la_spatialunit_land', '', false, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1055, 'Other details', 'Other details', 1, 15, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (3, 'Middle Name', 'Middle Name', 1, 2, 'la party person', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (4, 'Gender', 'Gender', 5, 2, 'la party person', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (22, ' Marital Status', 'Marital Status', 5, 2, 'la party person', '', false, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (11, 'documentname', 'Name', 1, 3, 'la_ext_documentdetails', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (2, 'Last Name', 'Last Name', 1, 2, 'la party person', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1010, 'open', 'open', 1, 9, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1052, 'Tenure Name', 'Tenure Name', 1, 9, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1054, 'Tenure Name', 'Tenure Name', 1, 15, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1022, 'Marital Status', 'Marital Status', 5, 10, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1056, 'Natural Person Type', 'Natural Person', 5, 16, 'asadadadaas', '100', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1058, 'Proposed Use', 'Proposed Use', 5, 7, 'la_spatialunit_land', '100', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1018, 'middlename', 'Middle Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1015, 'open1', 'open1', 1, 9, 'custom', '100', true, '1', true, false);
INSERT INTO la_ext_attributemaster VALUES (1019, 'lastname', 'Last Name', 1, 10, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1020, 'genderid', 'Gender', 5, 10, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1023, 'Citizenship', 'Citizenship', 5, 10, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1024, 'Ethnicity', 'Ethnicity', 5, 10, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (37, 'Land Type', 'Land Type', 5, 7, 'la_spatialunit_land', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1042, 'Mobile No', 'Mobile number', 4, 14, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1035, 'firstname', 'First Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1040, 'Address', 'Region', 1, 14, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1027, 'Address', 'Community', 1, 10, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster VALUES (1053, 'Other details', 'Other details', 1, 9, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1030, 'Mobile No', 'Mobile number', 4, 10, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1028, 'Address', 'Region', 1, 10, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster VALUES (1029, 'Address', 'Country', 1, 10, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster VALUES (1041, 'Address', 'Country', 1, 14, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1031, 'Institution Name', 'Institution Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1043, 'Community or Parties', 'name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1032, 'Registration No', 'Registration Number', 4, 14, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1033, 'Registration Date', 'Registration Date', 2, 14, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1044, 'firstname', 'First Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1036, 'middlename', 'Middle Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1037, 'lastname', 'Last Name', 1, 14, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1038, 'Address', 'Address/Street', 1, 14, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1025, 'Resident of Community', 'Resident of Community', 5, 10, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1063, 'firstname', 'First Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1064, 'Marital Status', 'Marital Status', 5, 17, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1049, 'Address', 'Region', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1050, 'Address', 'Country', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1039, 'Address', 'Community Area', 1, 14, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1057, 'Non- Natural Person Type', 'Non- Natural Person', 5, 16, 'asadadadaas', '100', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (13, 'Years of Occupancy', 'Years of Occupancy', 4, 4, 'la_ext_personlandmapping', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (9, 'proposed_use', 'Proposed Use', 5, 4, 'la_spatialunit_land', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster VALUES (23, 'Type of Right ', 'Type of Right ', 5, 4, 'la_ext_personlandmapping', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (42, 'Citizenship', 'Citizenship', 5, 2, 'la party person', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (43, 'Resident', 'Resident', 3, 2, 'la party person', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1, 'First Name', 'First Name', 1, 2, 'la party person', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1034, 'How many members?', 'How many members?', 4, 14, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1045, 'middlename', 'Middle Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1046, 'lastname', 'Last Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1047, 'Address', 'Community Area', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1051, 'Mobile No', 'Mobile number', 4, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1026, 'Address', 'Address/Street', 1, 10, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster VALUES (46, 'neighbor_east', 'Neighbor East', 1, 7, 'la_spatialunit_land', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (47, 'neighbor_west', 'Neighbor West', 1, 7, 'la_spatialunit_land', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (44, 'neighbor_north', 'Neighbor North', 1, 7, 'la_spatialunit_land', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (45, 'neighbor_south', 'Neighbor South', 1, 7, 'la_spatialunit_land', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (24, 'Type of Tenure /Occupancy ', 'Type of Tenure /Occupancy ', 5, 4, 'la_ext_personlandmapping', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (16, 'existing_use', 'Existing Use', 5, 7, 'la_spatialunit_land', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (15, 'total_househld_no', 'Number of signatory(s)', 4, 1, 'la_spatialunit_land', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (40, 'owner', 'Owner', 3, 2, 'la party person', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster VALUES (41, 'administator', 'Administator', 1, 2, 'la party person', '', false, '5', false, true);
INSERT INTO la_ext_attributemaster VALUES (53, 'Other Use', 'Other Use', 1, 7, 'la_spatialunit_land', '', false, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1065, 'middlename', 'Middle Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1066, 'lastname', 'Last Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1067, 'genderid', 'Gender', 5, 17, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1069, 'Citizenship', 'Citizenship', 5, 17, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1070, 'Ethnicity', 'Ethnicity', 5, 17, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1071, 'Resident', 'Resident', 5, 17, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1072, 'Address', 'Community', 1, 17, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster VALUES (1021, 'Dob', 'Dob', 2, 10, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (7, 'Address', 'Address', 1, 5, 'la_party_organization', '', false, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (8, 'Mobile No.', 'Mobile No.', 4, 5, 'la_party_organization', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1075, 'Address', 'Region', 1, 17, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster VALUES (1076, 'Address', 'Country', 1, 17, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster VALUES (1073, 'Mobile No', 'Mobile number', 4, 17, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1074, 'Address', 'Address/Street', 1, 17, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster VALUES (1077, 'Institution Name', 'Institution Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1078, 'How many members?', 'How many members?', 4, 18, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1079, 'firstname', 'First Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1080, 'middlename', 'Middle Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1081, 'lastname', 'Last Name', 1, 18, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1082, 'Address', 'Address/Street', 1, 18, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1084, 'Address', 'Region', 1, 18, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1085, 'Address', 'Country', 1, 18, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1086, 'Mobile No', 'Mobile number', 4, 18, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1088, 'firstname', 'First Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1089, 'middlename', 'Middle Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1090, 'lastname', 'Last Name', 1, 11, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1091, 'Address', 'Address/Street', 1, 11, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1093, 'Address', 'Region', 1, 11, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1094, 'Address', 'Country', 1, 11, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1095, 'Mobile No', 'Mobile number', 4, 11, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1109, 'middlename', 'Middle Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1110, 'lastname', 'Last Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1097, 'firstname', 'First Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1098, 'middlename', 'Middle Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1099, 'lastname', 'Last Name', 1, 12, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1100, 'Address', 'Address/Street', 1, 12, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1103, 'Address', 'Region', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1104, 'Address', 'Country', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1105, 'Mobile No', 'Mobile number', 4, 12, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1108, 'firstname', 'First Name', 1, 13, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1111, 'Address', 'Address/Street', 1, 13, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1101, 'Address', 'Community Area', 1, 12, 'la_ext_resourceattributevalue', '', true, '9', false, true);
INSERT INTO la_ext_attributemaster VALUES (1113, 'Address', 'Region', 1, 13, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1114, 'Address', 'Country', 1, 13, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1102, 'Address', 'Community', 1, 12, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1112, 'Address', 'Community Area', 1, 13, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster VALUES (1115, 'firstname-Own2', 'First Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1116, 'Marital Status-Own2', 'Marital Status', 5, 17, 'la_ext_resourceattributevalue', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1117, 'middlename-Own2', 'Middle Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1118, 'lastname-Own2', 'Last Name', 1, 17, 'la_ext_resourceattributevalue', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1119, 'genderid-Own2', 'Gender', 5, 17, 'la_ext_resourceattributevalue', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1121, 'Citizenship-Own2', 'Citizenship', 5, 17, 'la_ext_resourceattributevalue', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1122, 'Ethnicity-Own2', 'Ethnicity', 5, 17, 'la_ext_resourceattributevalue', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1123, 'Resident-Own2', 'Resident', 5, 17, 'la_ext_resourceattributevalue', '', true, '9', true, true);
INSERT INTO la_ext_attributemaster VALUES (1124, 'Address-Own2', 'Community', 1, 17, 'la_ext_resourceattributevalue', '', true, '12', false, true);
INSERT INTO la_ext_attributemaster VALUES (1127, 'Address-Own2', 'Region', 1, 17, 'la_ext_resourceattributevalue', '', true, '13', false, true);
INSERT INTO la_ext_attributemaster VALUES (1128, 'Address-Own2', 'Country', 1, 17, 'la_ext_resourceattributevalue', '', true, '14', false, true);
INSERT INTO la_ext_attributemaster VALUES (1092, 'Address', 'Community Area', 1, 11, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1083, 'Address', 'Community Area', 1, 18, 'la_ext_resourceattributevalue', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1048, 'Address', 'Community', 1, 12, 'la_ext_resourceattributevalue', '', true, '1', false, true);
INSERT INTO la_ext_attributemaster VALUES (1087, 'How many members in collective organization?', 'How many members in collective organization?', 4, 11, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1145, 'Address', 'Community', 1, 1, 'General Attributes ', '', true, '3', false, true);
INSERT INTO la_ext_attributemaster VALUES (1130, 'Address', 'Community Area', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1107, 'Level of Authority', 'Level of Authority', 5, 13, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1132, 'Address', 'Region', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1133, 'Address', 'Country', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1142, 'Middle Name', 'Middle Name', 1, 8, 'Person of Interest', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1139, 'Relationship', 'Relationship', 1, 8, 'Person of Interest', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1140, 'First Name', 'First Name', 1, 8, 'Person of Interest', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1141, 'Last Name', 'Last Name', 1, 8, 'Person of Interest', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1143, 'Claim Number', 'Claim Number', 1, 1, 'General Attributes ', '', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (1144, 'Claim date', 'Claim date', 2, 1, 'General Attributes ', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1149, 'Data Collection Witness 1', 'Data Collection Witness 1', 1, 1, 'General Attributes ', '', true, '7', true, true);
INSERT INTO la_ext_attributemaster VALUES (1146, 'Address', 'Community Area', 1, 1, 'General Attributes ', '', true, '4', false, true);
INSERT INTO la_ext_attributemaster VALUES (1125, 'Mobile No-Own2', 'Mobile number', 4, 17, 'la_ext_resourceattributevalue', '', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (1147, 'Person Type ', 'Person Type ', 5, 1, 'General Attributes ', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1148, 'Claim Type', 'Claim Type', 5, 1, 'General Attributes ', '', true, '6', true, true);
INSERT INTO la_ext_attributemaster VALUES (1150, 'Data Collection Witness 2', 'Data Collection Witness 2', 1, 1, 'General Attributes ', '', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1126, 'Address-Own2', 'Address/Street', 1, 17, 'la_ext_resourceattributevalue', '', true, '10', true, true);
INSERT INTO la_ext_attributemaster VALUES (1135, 'Occupation', 'Occupation', 5, 2, 'la_party_person', '', true, '15', true, true);
INSERT INTO la_ext_attributemaster VALUES (1134, 'Education Level', 'Education Level', 5, 2, 'la_party_person', '', true, '14', true, true);
INSERT INTO la_ext_attributemaster VALUES (1060, 'How are concessions to land handled? ', 'How are concessions to land handled? ', 1, 14, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1068, 'Dob', 'Dob', 2, 17, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1096, 'Community or Parties', 'Community or Parties', 1, 12, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1136, 'First Name', 'First Name', 1, 5, 'la_party_organization', '', true, '3', true, true);
INSERT INTO la_ext_attributemaster VALUES (1138, 'Second Name ', 'Second Name ', 1, 5, 'la_party_organization', '', true, '4', true, true);
INSERT INTO la_ext_attributemaster VALUES (1137, 'Last Name', 'Last Name', 1, 5, 'la_party_organization', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1131, 'Address', 'Community', 1, 2, 'la_party_person', '', true, '10', false, true);
INSERT INTO la_ext_attributemaster VALUES (1153, 'IdentityNo', 'IdentityNo', 1, 2, 'la_party_person', '100', true, '11', true, true);
INSERT INTO la_ext_attributemaster VALUES (5, 'Mobile No.', 'Mobile No.', 4, 2, 'la party person', '', false, '12', true, true);
INSERT INTO la_ext_attributemaster VALUES (1151, 'Address', 'Address', 1, 2, 'la_party_person', '100', true, '13', true, true);
INSERT INTO la_ext_attributemaster VALUES (1059, 'Clan/Tribe/Ethnicity', 'Clan/Tribe/Ethnicity', 5, 2, 'la party person', '100', true, '8', true, true);
INSERT INTO la_ext_attributemaster VALUES (1129, 'Dob', 'Dob', 2, 2, 'la_party_person', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1120, 'Dob-own2', 'Dob', 2, 17, 'la_ext_resourceattributevalue', '', true, '5', true, true);
INSERT INTO la_ext_attributemaster VALUES (1152, 'IdentityType', 'IdentityType', 5, 2, 'la_party_person', '100', true, '10', true, true);
INSERT INTO la_ext_attributemaster VALUES (1154, 'Institution Type', 'Institution Type', 5, 5, 'la_party_organization', '10', true, '1', true, true);
INSERT INTO la_ext_attributemaster VALUES (6, 'Institution name', 'Institution name', 1, 5, 'la_party_organization', '', true, '2', true, true);
INSERT INTO la_ext_attributemaster VALUES (1106, 'Agency Name', 'Agency Name ', 1, 13, 'la_ext_resourceattributevalue', '', true, '1', true, true);




SELECT pg_catalog.setval('la_ext_attributemaster_attributemasterid_seq', 1154, true);



INSERT INTO la_ext_attributeoptions VALUES (1005, 'male', 1020, 1005);
INSERT INTO la_ext_attributeoptions VALUES (1006, 'female', 1020, 1006);
INSERT INTO la_ext_attributeoptions VALUES (1007, 'married', 1022, 1007);
INSERT INTO la_ext_attributeoptions VALUES (1008, 'divorced', 1022, 1008);
INSERT INTO la_ext_attributeoptions VALUES (1009, 'widow', 1022, 1009);
INSERT INTO la_ext_attributeoptions VALUES (1014, 'Not Known', 1023, 1014);
INSERT INTO la_ext_attributeoptions VALUES (8, 'Not Known', 42, 8);
INSERT INTO la_ext_attributeoptions VALUES (1016, 'Country2', 1023, 1016);
INSERT INTO la_ext_attributeoptions VALUES (1066, 'Country2', 1069, 1066);
INSERT INTO la_ext_attributeoptions VALUES (11, 'Customary(Individual)', 24, 11);
INSERT INTO la_ext_attributeoptions VALUES (12, 'Customary(Collective)', 24, 12);
INSERT INTO la_ext_attributeoptions VALUES (1021, 'Occupant/Owner', 1056, 1021);
INSERT INTO la_ext_attributeoptions VALUES (1022, 'Administrator', 1056, 1022);
INSERT INTO la_ext_attributeoptions VALUES (1023, 'Guardian', 1056, 1023);
INSERT INTO la_ext_attributeoptions VALUES (1024, 'Person of Interest', 1056, 1024);
INSERT INTO la_ext_attributeoptions VALUES (1025, 'Civic', 1057, 1025);
INSERT INTO la_ext_attributeoptions VALUES (1026, 'Church', 1057, 1026);
INSERT INTO la_ext_attributeoptions VALUES (1027, 'Mosque', 1057, 1027);
INSERT INTO la_ext_attributeoptions VALUES (1028, 'Association (legal)', 1057, 1028);
INSERT INTO la_ext_attributeoptions VALUES (1029, 'Cooperative', 1057, 1029);
INSERT INTO la_ext_attributeoptions VALUES (1030, 'Informal Association (non-legal) ', 1057, 1030);
INSERT INTO la_ext_attributeoptions VALUES (1031, 'Other', 1057, 1031);
INSERT INTO la_ext_attributeoptions VALUES (1010, 'widower', 1022, 1010);
INSERT INTO la_ext_attributeoptions VALUES (1011, 'un-married', 1022, 1011);
INSERT INTO la_ext_attributeoptions VALUES (1012, 'Yes', 1025, 1012);
INSERT INTO la_ext_attributeoptions VALUES (1013, 'No', 1025, 1013);
INSERT INTO la_ext_attributeoptions VALUES (1084, 'New Claim', 1148, 1084);
INSERT INTO la_ext_attributeoptions VALUES (1085, 'Existing Rights', 1148, 1085);
INSERT INTO la_ext_attributeoptions VALUES (1105, 'Single Tenancy ', 24, 1105);
INSERT INTO la_ext_attributeoptions VALUES (1106, 'Joint Tenency ', 24, 1106);
INSERT INTO la_ext_attributeoptions VALUES (1107, 'Common Tenancy ', 24, 1107);
INSERT INTO la_ext_attributeoptions VALUES (1050, 'male', 1067, 1050);
INSERT INTO la_ext_attributeoptions VALUES (1051, 'female', 1067, 1051);
INSERT INTO la_ext_attributeoptions VALUES (1052, 'male', 1119, 1052);
INSERT INTO la_ext_attributeoptions VALUES (1053, 'female', 1119, 1053);
INSERT INTO la_ext_attributeoptions VALUES (1054, 'married', 1064, 1054);
INSERT INTO la_ext_attributeoptions VALUES (1055, 'divorced', 1064, 1055);
INSERT INTO la_ext_attributeoptions VALUES (1057, 'widower', 1064, 1057);
INSERT INTO la_ext_attributeoptions VALUES (1058, 'un-married', 1064, 1058);
INSERT INTO la_ext_attributeoptions VALUES (1059, 'married', 1116, 1059);
INSERT INTO la_ext_attributeoptions VALUES (1060, 'divorced', 1116, 1060);
INSERT INTO la_ext_attributeoptions VALUES (1061, 'widow', 1116, 1061);
INSERT INTO la_ext_attributeoptions VALUES (1062, 'widower', 1116, 1062);
INSERT INTO la_ext_attributeoptions VALUES (1063, 'un-married', 1116, 1063);
INSERT INTO la_ext_attributeoptions VALUES (1064, 'Not Known', 1069, 1064);
INSERT INTO la_ext_attributeoptions VALUES (1015, 'Country1', 1023, 1015);
INSERT INTO la_ext_attributeoptions VALUES (1065, 'Country1', 1069, 1065);
INSERT INTO la_ext_attributeoptions VALUES (1067, 'Not Known', 1121, 1067);
INSERT INTO la_ext_attributeoptions VALUES (1017, 'Ethnicity 1', 1024, 1017);
INSERT INTO la_ext_attributeoptions VALUES (1072, 'Ethnicity 3', 1070, 1072);
INSERT INTO la_ext_attributeoptions VALUES (1073, 'Ethnicity 4', 1070, 1073);
INSERT INTO la_ext_attributeoptions VALUES (1074, 'Ethnicity 1', 1122, 1074);
INSERT INTO la_ext_attributeoptions VALUES (1075, 'Ethnicity 2', 1122, 1075);
INSERT INTO la_ext_attributeoptions VALUES (1076, 'Ethnicity 3', 1122, 1076);
INSERT INTO la_ext_attributeoptions VALUES (1077, 'Ethnicity 4', 1122, 1077);
INSERT INTO la_ext_attributeoptions VALUES (1078, 'Yes', 1071, 1078);
INSERT INTO la_ext_attributeoptions VALUES (1079, 'No', 1071, 1079);
INSERT INTO la_ext_attributeoptions VALUES (1080, 'Yes', 1123, 1080);
INSERT INTO la_ext_attributeoptions VALUES (1081, 'No', 1123, 1081);
INSERT INTO la_ext_attributeoptions VALUES (1082, 'Natural', 1147, 1082);
INSERT INTO la_ext_attributeoptions VALUES (1086, 'Unclaimed', 1148, 1086);
INSERT INTO la_ext_attributeoptions VALUES (9, 'Country1', 42, 9);
INSERT INTO la_ext_attributeoptions VALUES (1068, 'Country1', 1121, 1068);
INSERT INTO la_ext_attributeoptions VALUES (10, 'Country2', 42, 10);
INSERT INTO la_ext_attributeoptions VALUES (1018, 'Ethnicity 2', 1024, 1018);
INSERT INTO la_ext_attributeoptions VALUES (1019, 'Ethnicity 3', 1024, 1019);
INSERT INTO la_ext_attributeoptions VALUES (1020, 'Ethnicity 4', 1024, 1020);
INSERT INTO la_ext_attributeoptions VALUES (1046, 'Ethnicity 1', 1059, 1046);
INSERT INTO la_ext_attributeoptions VALUES (1047, 'Ethnicity 2', 1059, 1047);
INSERT INTO la_ext_attributeoptions VALUES (1048, 'Ethnicity 3', 1059, 1048);
INSERT INTO la_ext_attributeoptions VALUES (1070, 'Ethnicity 1', 1070, 1070);
INSERT INTO la_ext_attributeoptions VALUES (1071, 'Ethnicity 2', 1070, 1071);
INSERT INTO la_ext_attributeoptions VALUES (1108, 'Collective Tenancy ', 24, 1108);
INSERT INTO la_ext_attributeoptions VALUES (1056, 'widow', 1064, 1056);
INSERT INTO la_ext_attributeoptions VALUES (1083, 'Non-Natural ', 1147, 1083);
INSERT INTO la_ext_attributeoptions VALUES (1, 'female', 4, 2);
INSERT INTO la_ext_attributeoptions VALUES (4, 'un-married', 22, 1);
INSERT INTO la_ext_attributeoptions VALUES (15, 'Derivative Right', 23, 1);
INSERT INTO la_ext_attributeoptions VALUES (6, 'divorced', 22, 3);
INSERT INTO la_ext_attributeoptions VALUES (7, 'widow', 22, 4);
INSERT INTO la_ext_attributeoptions VALUES (5, 'widower', 22, 5);
INSERT INTO la_ext_attributeoptions VALUES (13, 'Customary Right of Occupancy', 23, 2);
INSERT INTO la_ext_attributeoptions VALUES (14, 'Right of Use', 23, 4);
INSERT INTO la_ext_attributeoptions VALUES (1110, 'Granted Right of Occupancy', 23, 6);
INSERT INTO la_ext_attributeoptions VALUES (1114, 'Right to Manage', 23, 7);
INSERT INTO la_ext_attributeoptions VALUES (1113, 'Right to Ownership ', 23, 3);
INSERT INTO la_ext_attributeoptions VALUES (16, 'Agriculture', 16, 1);
INSERT INTO la_ext_attributeoptions VALUES (17, 'Settlement', 16, 2);
INSERT INTO la_ext_attributeoptions VALUES (18, 'Livestock (intensive/ stationary)', 16, 3);
INSERT INTO la_ext_attributeoptions VALUES (19, 'Livestock (pastoralism)', 16, 4);
INSERT INTO la_ext_attributeoptions VALUES (20, 'Forest/ Woodlands', 16, 5);
INSERT INTO la_ext_attributeoptions VALUES (21, 'Forest Reserve', 16, 6);
INSERT INTO la_ext_attributeoptions VALUES (22, 'Grassland', 16, 7);
INSERT INTO la_ext_attributeoptions VALUES (23, 'Facility (church/mosque/recreation)', 16, 8);
INSERT INTO la_ext_attributeoptions VALUES (24, 'Commercial/Service ', 16, 9);
INSERT INTO la_ext_attributeoptions VALUES (25, 'Mining', 16, 10);
INSERT INTO la_ext_attributeoptions VALUES (1087, 'Wildlife (hunting)', 16, 11);
INSERT INTO la_ext_attributeoptions VALUES (1088, 'Wildlife (tourism)', 16, 12);
INSERT INTO la_ext_attributeoptions VALUES (1089, 'Industrial', 16, 13);
INSERT INTO la_ext_attributeoptions VALUES (1090, 'Conservation', 16, 14);
INSERT INTO la_ext_attributeoptions VALUES (1104, 'Conservation', 9, 14);
INSERT INTO la_ext_attributeoptions VALUES (1091, 'Agriculture', 9, 1);
INSERT INTO la_ext_attributeoptions VALUES (1092, 'Settlement', 9, 2);
INSERT INTO la_ext_attributeoptions VALUES (1094, 'Livestock (pastoralism)', 9, 4);
INSERT INTO la_ext_attributeoptions VALUES (1095, 'Forest/ Woodlands', 9, 5);
INSERT INTO la_ext_attributeoptions VALUES (1096, 'Forest Reserve', 9, 6);
INSERT INTO la_ext_attributeoptions VALUES (1097, 'Grassland', 9, 7);
INSERT INTO la_ext_attributeoptions VALUES (1098, 'Facility (church/mosque/recreation)', 9, 8);
INSERT INTO la_ext_attributeoptions VALUES (1099, 'Commercial/Service', 9, 9);
INSERT INTO la_ext_attributeoptions VALUES (1100, 'Wildlife (hunting)', 9, 10);
INSERT INTO la_ext_attributeoptions VALUES (1101, 'Wildlife (tourism)', 9, 11);
INSERT INTO la_ext_attributeoptions VALUES (1102, 'Mining', 9, 12);
INSERT INTO la_ext_attributeoptions VALUES (1103, 'Industrial', 9, 13);
INSERT INTO la_ext_attributeoptions VALUES (35, 'Flat/Plain', 37, 1);
INSERT INTO la_ext_attributeoptions VALUES (36, 'Mountainous', 37, 3);
INSERT INTO la_ext_attributeoptions VALUES (37, 'Valley', 37, 4);
INSERT INTO la_ext_attributeoptions VALUES (38, 'Sloping', 37, 2);
INSERT INTO la_ext_attributeoptions VALUES (1115, 'None', 1134, 1);
INSERT INTO la_ext_attributeoptions VALUES (1116, 'Primary', 1134, 2);
INSERT INTO la_ext_attributeoptions VALUES (1032, 'Agriculture', 1058, 1);
INSERT INTO la_ext_attributeoptions VALUES (1033, 'Settlement', 1058, 2);
INSERT INTO la_ext_attributeoptions VALUES (1034, 'Livestock (intensive/ stationary)', 1058, 3);
INSERT INTO la_ext_attributeoptions VALUES (1035, 'Livestock (pastoralism)', 1058, 4);
INSERT INTO la_ext_attributeoptions VALUES (1036, 'Forest/ Woodlands', 1058, 5);
INSERT INTO la_ext_attributeoptions VALUES (1037, 'Forest Reserve', 1058, 6);
INSERT INTO la_ext_attributeoptions VALUES (1038, 'Grassland', 1058, 7);
INSERT INTO la_ext_attributeoptions VALUES (1039, 'Facility (church/mosque/recreation)', 1058, 8);
INSERT INTO la_ext_attributeoptions VALUES (1040, 'Commercial/Service', 1058, 9);
INSERT INTO la_ext_attributeoptions VALUES (1041, 'Wildlife (hunting)', 1058, 10);
INSERT INTO la_ext_attributeoptions VALUES (1042, 'Wildlife (tourism)', 1058, 11);
INSERT INTO la_ext_attributeoptions VALUES (1043, 'Mining', 1058, 12);
INSERT INTO la_ext_attributeoptions VALUES (1044, 'Industrial', 1058, 13);
INSERT INTO la_ext_attributeoptions VALUES (1045, 'Conservation', 1058, 14);
INSERT INTO la_ext_attributeoptions VALUES (1135, 'Others', 42, 1135);
INSERT INTO la_ext_attributeoptions VALUES (1144, 'Others', 1121, 1144);
INSERT INTO la_ext_attributeoptions VALUES (1142, 'Others', 1023, 1142);
INSERT INTO la_ext_attributeoptions VALUES (1143, 'Others', 1069, 1143);
INSERT INTO la_ext_attributeoptions VALUES (1069, 'Country2', 1121, 1069);
INSERT INTO la_ext_attributeoptions VALUES (1049, 'Ethnicity 4', 1059, 1049);
INSERT INTO la_ext_attributeoptions VALUES (1145, 'National', 1107, 1145);
INSERT INTO la_ext_attributeoptions VALUES (1146, 'Regional', 1107, 1146);
INSERT INTO la_ext_attributeoptions VALUES (1147, 'District', 1107, 1147);
INSERT INTO la_ext_attributeoptions VALUES (1148, 'Local ', 1107, 1148);
INSERT INTO la_ext_attributeoptions VALUES (2, 'male', 4, 1);
INSERT INTO la_ext_attributeoptions VALUES (3, 'married', 22, 2);
INSERT INTO la_ext_attributeoptions VALUES (1111, 'Formal Ownership (Free-hold) ', 23, 5);
INSERT INTO la_ext_attributeoptions VALUES (1093, 'Livestock (intensive/ stationary)', 9, 3);
INSERT INTO la_ext_attributeoptions VALUES (1117, 'Secondary', 1134, 3);
INSERT INTO la_ext_attributeoptions VALUES (1118, 'University', 1134, 4);
INSERT INTO la_ext_attributeoptions VALUES (1149, 'Government Employee', 1135, 1);
INSERT INTO la_ext_attributeoptions VALUES (1150, 'Private Employee', 1135, 2);
INSERT INTO la_ext_attributeoptions VALUES (1151, 'Voter ID', 1152, 1);
INSERT INTO la_ext_attributeoptions VALUES (1152, 'Driving license', 1152, 2);
INSERT INTO la_ext_attributeoptions VALUES (1153, 'Passport', 1152, 3);
INSERT INTO la_ext_attributeoptions VALUES (1154, 'ID card', 1152, 4);
INSERT INTO la_ext_attributeoptions VALUES (1155, 'Other', 1152, 5);
INSERT INTO la_ext_attributeoptions VALUES (1156, 'None', 1152, 6);
INSERT INTO la_ext_attributeoptions VALUES (1158, 'Civic', 1154, 1);
INSERT INTO la_ext_attributeoptions VALUES (1159, 'Church', 1154, 7);
INSERT INTO la_ext_attributeoptions VALUES (1160, 'Mosque', 1154, 2);
INSERT INTO la_ext_attributeoptions VALUES (1161, 'Association (legal)', 1154, 3);
INSERT INTO la_ext_attributeoptions VALUES (1162, 'Cooperative', 1154, 4);
INSERT INTO la_ext_attributeoptions VALUES (1163, 'Informal Association (non-legal)', 1154, 5);
INSERT INTO la_ext_attributeoptions VALUES (1164, 'Other', 1154, 6);




SELECT pg_catalog.setval('la_ext_attributeoptions_attributeoptionsid_seq', 1164, true);




INSERT INTO la_ext_baselayer VALUES (1, 'Bing_Aerial', 'Bing_Aerial', true);
INSERT INTO la_ext_baselayer VALUES (2, 'Bing_Road', 'Bing_Road', true);
INSERT INTO la_ext_baselayer VALUES (3, 'Google_Hybrid', 'Google_Hybrid', true);
INSERT INTO la_ext_baselayer VALUES (4, 'Google_Physical', 'Google_Physical', true);
INSERT INTO la_ext_baselayer VALUES (5, 'Google_Satellite', 'Google_Satellite', true);
INSERT INTO la_ext_baselayer VALUES (6, 'Google_Streets', 'Google_Streets', true);
INSERT INTO la_ext_baselayer VALUES (7, 'MapQuest_OSM', 'MapQuest_OSM', true);
INSERT INTO la_ext_baselayer VALUES (8, 'Open_Street_Map', 'Open_Street_Map', true);



SELECT pg_catalog.setval('la_ext_baselayer_baselayerid_seq', 8, true);




INSERT INTO la_ext_bookmark VALUES (9, 'kamal', 2, 'kamal', 34.402931649237928, -8.4079634797761322, 36.498573739081678, -7.7336775911042572, true, 1, '2017-12-15 00:00:00', NULL, NULL);
INSERT INTO la_ext_bookmark VALUES (11, 'virat bookmark', 2, 'virat bookmark', -10.220786612480836, -27.124804223794687, 57.542885262519164, 6.9767582762053131, true, 1, '2018-01-12 00:00:00', NULL, NULL);



SELECT pg_catalog.setval('la_ext_bookmark_bookmarkid_seq', 11, true);




INSERT INTO la_ext_categorytype VALUES (1, 'Parcel', true);
INSERT INTO la_ext_categorytype VALUES (2, 'Resource', true);




SELECT pg_catalog.setval('la_ext_categorytype_categorytypeid_seq', 2, true);




INSERT INTO la_ext_customattributeoptions VALUES (101, 'Cultivated', 7, 101);
INSERT INTO la_ext_customattributeoptions VALUES (102, 'Non-Cultivated', 7, 102);
INSERT INTO la_ext_customattributeoptions VALUES (103, 'Color of sky', 2, 2);
INSERT INTO la_ext_customattributeoptions VALUES (104, 'Color of bear', 2, 2);
INSERT INTO la_ext_customattributeoptions VALUES (105, 'Color of soil', 2, 2);
INSERT INTO la_ext_customattributeoptions VALUES (110, 'Potential Value', 5, 2);
INSERT INTO la_ext_customattributeoptions VALUES (111, 'Number of animals', 5, 2);
INSERT INTO la_ext_customattributeoptions VALUES (112, 'Average tree height', 6, 2);
INSERT INTO la_ext_customattributeoptions VALUES (113, 'No of wheather', 6, 2);
INSERT INTO la_ext_customattributeoptions VALUES (114, 'No of water source', 7, 2);
INSERT INTO la_ext_customattributeoptions VALUES (115, 'Water source Type', 7, 2);




SELECT pg_catalog.setval('la_ext_customattributeoptionsid_seq', 115, true);


SELECT pg_catalog.setval('la_ext_dispute_seq', 19, true);


SELECT pg_catalog.setval('la_ext_disputelandmapping_disputelandid_seq', 31, true);




INSERT INTO la_ext_disputestatus VALUES (1, 'Active', 'Active', true);
INSERT INTO la_ext_disputestatus VALUES (2, 'Resolved', 'Resolved', true);




SELECT pg_catalog.setval('la_ext_disputestatus_disputestatusid_seq', 2, true);




INSERT INTO la_ext_disputetype VALUES (1, 'Boundary', 'Boundary', true);
INSERT INTO la_ext_disputetype VALUES (2, 'Counter claim (Inter family)', 'Counter claim (Inter family)', true);
INSERT INTO la_ext_disputetype VALUES (3, 'Counter claim (Intra family)', 'Counter claim (Intra family)', true);
INSERT INTO la_ext_disputetype VALUES (4, 'Counter claim (Others)', 'Counter claim (Others)', true);
INSERT INTO la_ext_disputetype VALUES (5, 'Other interests', 'Other interests', true);




SELECT pg_catalog.setval('la_ext_disputetype_disputetypeid_seq', 5, true);

SELECT pg_catalog.setval('la_ext_documentdetails_documentid_seq', 2, true);




INSERT INTO la_ext_documentformat VALUES (1, 'image/gif', 'image/gif', true);
INSERT INTO la_ext_documentformat VALUES (3, 'image/png', 'image/png', true);
INSERT INTO la_ext_documentformat VALUES (2, 'Image/jpg', 'Image/jpg', true);




SELECT pg_catalog.setval('la_ext_documentformat_documentformatid_seq', 3, true);




INSERT INTO la_ext_documenttype VALUES (5, 'Other', 'Other', true, 1);
INSERT INTO la_ext_documenttype VALUES (7, 'Other', 'Other', true, 3);
INSERT INTO la_ext_documenttype VALUES (8, 'Other', 'Other', true, 4);
INSERT INTO la_ext_documenttype VALUES (10, 'Application Letter', 'Application Letter ', true, 6);
INSERT INTO la_ext_documenttype VALUES (9, 'Application Letter', 'Application Letter ', true, 5);
INSERT INTO la_ext_documenttype VALUES (11, 'Application Letter ', 'Application Letter ', true, 4);
INSERT INTO la_ext_documenttype VALUES (1, 'Informal Receipt of Sale', 'Informal Receipt of Sale', true, 2);
INSERT INTO la_ext_documenttype VALUES (2, 'Formal Receipt of Sale', 'Formal Receipt of Sale', true, 2);
INSERT INTO la_ext_documenttype VALUES (3, 'Letter of Allocation', 'Letter of Allocation', true, 1);
INSERT INTO la_ext_documenttype VALUES (4, 'Probate Document', 'Probate Document', true, 3);
INSERT INTO la_ext_documenttype VALUES (6, 'Other', 'Other', true, 6);
INSERT INTO la_ext_documenttype VALUES (12, 'Application Letter', ' Application Letter ', true, 7);



SELECT pg_catalog.setval('la_ext_documenttype_documenttypeid_seq', 13, true);








SELECT pg_catalog.setval('la_ext_existingclaim_documentid_seq', 300, false);




INSERT INTO la_ext_financialagency VALUES (1, 'ICICI Bank', 'ICICI Bank', true);
INSERT INTO la_ext_financialagency VALUES (2, 'HDFC Bank', 'HDFC Bank', true);
INSERT INTO la_ext_financialagency VALUES (3, 'SBI Bank', 'SBI Bank', true);




SELECT pg_catalog.setval('la_ext_financialagency_financialagencyid_seq', 3, true);



INSERT INTO la_ext_geometrytype VALUES (1, 'Point', true);
INSERT INTO la_ext_geometrytype VALUES (2, 'Line', true);
INSERT INTO la_ext_geometrytype VALUES (3, 'Polygon', true);




SELECT pg_catalog.setval('la_ext_geometrytype_geometryid_seq', 3, true);



INSERT INTO la_ext_grouptype VALUES (1, 'Civic', 'Civic', true);
INSERT INTO la_ext_grouptype VALUES (2, 'Mosque', 'Mosque', true);
INSERT INTO la_ext_grouptype VALUES (3, 'Association', 'Association', true);
INSERT INTO la_ext_grouptype VALUES (4, 'Cooperative', 'Cooperative', true);
INSERT INTO la_ext_grouptype VALUES (5, 'Informal', 'Informal', true);
INSERT INTO la_ext_grouptype VALUES (6, 'Other', 'Other', true);
INSERT INTO la_ext_grouptype VALUES (7, 'Church', 'Church', true);




SELECT pg_catalog.setval('la_ext_grouptype_grouptypeid_seq', 7, true);

SELECT pg_catalog.setval('la_ext_landworkflowhistory_landworkflowhistoryid_seq', 364, true);




INSERT INTO la_ext_layer_layergroup VALUES (193, 31, 81, 1, true, 1, '2018-02-05 11:50:41.373', 1, '2018-02-05 11:50:41.373');
INSERT INTO la_ext_layer_layergroup VALUES (194, 34, 81, 2, true, 1, '2018-02-05 11:50:41.382', 1, '2018-02-05 11:50:41.382');
INSERT INTO la_ext_layer_layergroup VALUES (195, 35, 81, 3, true, 1, '2018-02-05 11:50:41.396', 1, '2018-02-05 11:50:41.396');
INSERT INTO la_ext_layer_layergroup VALUES (196, 36, 81, 4, true, 1, '2018-02-05 11:50:41.405', 1, '2018-02-05 11:50:41.405');
INSERT INTO la_ext_layer_layergroup VALUES (197, 33, 81, 5, true, 1, '2018-02-05 11:50:41.416', 1, '2018-02-05 11:50:41.416');
INSERT INTO la_ext_layer_layergroup VALUES (198, 40, 81, 6, true, 1, '2018-02-05 11:50:41.422', 1, '2018-02-05 11:50:41.422');
INSERT INTO la_ext_layer_layergroup VALUES (199, 41, 81, 7, true, 1, '2018-02-05 11:50:41.428', 1, '2018-02-05 11:50:41.428');
INSERT INTO la_ext_layer_layergroup VALUES (200, 37, 81, 8, true, 1, '2018-02-05 11:50:41.433', 1, '2018-02-05 11:50:41.433');
INSERT INTO la_ext_layer_layergroup VALUES (201, 38, 81, 9, true, 1, '2018-02-05 11:50:41.439', 1, '2018-02-05 11:50:41.439');




SELECT pg_catalog.setval('la_ext_layer_layergroup_layer_layergroupid_seq', 201, true);



INSERT INTO la_ext_layerfield VALUES (330, 33, 'userid', 'userid', 'aoiid', true, 'userid');
INSERT INTO la_ext_layerfield VALUES (331, 33, 'createddate', 'createddate', 'aoiid', true, 'createddate');
INSERT INTO la_ext_layerfield VALUES (332, 33, 'modifiedby', 'modifiedby', 'aoiid', true, 'modifiedby');
INSERT INTO la_ext_layerfield VALUES (333, 33, 'createdby', 'createdby', 'aoiid', true, 'createdby');
INSERT INTO la_ext_layerfield VALUES (334, 33, 'applicationstatusid', 'applicationstatusid', 'aoiid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield VALUES (335, 33, 'projectnameid', 'projectnameid', 'aoiid', true, 'projectnameid');
INSERT INTO la_ext_layerfield VALUES (336, 33, 'isactive', 'isactive', 'aoiid', true, 'isactive');
INSERT INTO la_ext_layerfield VALUES (337, 33, 'modifieddate', 'modifieddate', 'aoiid', true, 'modifieddate');
INSERT INTO la_ext_layerfield VALUES (338, 33, 'aoiid', 'aoiid', 'aoiid', true, 'aoiid');
INSERT INTO la_ext_layerfield VALUES (339, 34, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield VALUES (340, 34, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield VALUES (341, 34, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield VALUES (342, 34, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield VALUES (343, 34, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield VALUES (344, 34, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield VALUES (345, 34, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield VALUES (346, 34, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield VALUES (347, 34, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield VALUES (348, 34, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield VALUES (349, 34, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield VALUES (350, 34, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield VALUES (351, 34, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield VALUES (352, 34, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield VALUES (353, 34, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield VALUES (354, 34, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield VALUES (355, 34, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield VALUES (356, 34, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield VALUES (357, 34, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield VALUES (358, 34, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield VALUES (359, 34, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield VALUES (360, 34, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield VALUES (361, 34, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield VALUES (362, 34, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield VALUES (363, 34, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield VALUES (364, 34, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield VALUES (365, 34, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield VALUES (366, 34, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield VALUES (367, 34, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield VALUES (368, 34, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield VALUES (369, 34, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield VALUES (370, 34, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield VALUES (371, 34, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield VALUES (372, 34, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield VALUES (373, 34, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield VALUES (374, 34, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield VALUES (375, 34, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield VALUES (376, 34, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield VALUES (415, 36, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield VALUES (416, 36, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield VALUES (417, 36, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield VALUES (418, 36, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield VALUES (419, 36, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield VALUES (420, 36, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield VALUES (421, 36, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield VALUES (422, 36, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield VALUES (423, 36, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield VALUES (424, 36, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield VALUES (425, 36, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield VALUES (426, 36, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield VALUES (427, 36, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield VALUES (428, 36, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield VALUES (429, 36, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield VALUES (430, 36, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield VALUES (431, 36, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield VALUES (432, 36, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield VALUES (433, 36, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield VALUES (434, 36, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield VALUES (435, 36, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield VALUES (436, 36, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield VALUES (437, 36, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield VALUES (438, 36, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield VALUES (439, 36, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield VALUES (440, 36, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield VALUES (441, 36, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield VALUES (442, 36, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield VALUES (443, 36, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield VALUES (444, 36, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield VALUES (445, 36, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield VALUES (446, 36, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield VALUES (447, 36, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield VALUES (448, 36, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield VALUES (449, 36, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield VALUES (450, 36, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield VALUES (451, 36, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield VALUES (452, 36, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield VALUES (294, 31, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield VALUES (295, 31, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield VALUES (296, 31, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield VALUES (297, 31, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield VALUES (298, 31, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield VALUES (299, 31, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');
INSERT INTO la_ext_layerfield VALUES (300, 31, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield VALUES (301, 31, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield VALUES (302, 31, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield VALUES (303, 31, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield VALUES (304, 31, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield VALUES (305, 31, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield VALUES (306, 31, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield VALUES (307, 31, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield VALUES (308, 31, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield VALUES (309, 31, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield VALUES (310, 31, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield VALUES (311, 31, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield VALUES (312, 31, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield VALUES (313, 31, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield VALUES (314, 31, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield VALUES (315, 31, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield VALUES (316, 31, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield VALUES (317, 31, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield VALUES (318, 31, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield VALUES (319, 31, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield VALUES (320, 31, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield VALUES (321, 31, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield VALUES (322, 31, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield VALUES (323, 31, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield VALUES (324, 31, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield VALUES (325, 31, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield VALUES (326, 31, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield VALUES (327, 31, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield VALUES (328, 31, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield VALUES (329, 31, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield VALUES (377, 35, 'spatialunitgroupid2', 'spatialunitgroupid2', 'landid', true, 'spatialunitgroupid2');
INSERT INTO la_ext_layerfield VALUES (378, 35, 'unitid', 'unitid', 'landid', true, 'unitid');
INSERT INTO la_ext_layerfield VALUES (379, 35, 'hierarchyid4', 'hierarchyid4', 'landid', true, 'hierarchyid4');
INSERT INTO la_ext_layerfield VALUES (380, 35, 'slopevalueid', 'slopevalueid', 'landid', true, 'slopevalueid');
INSERT INTO la_ext_layerfield VALUES (381, 35, 'landusetypeid', 'landusetypeid', 'landid', true, 'landusetypeid');
INSERT INTO la_ext_layerfield VALUES (382, 35, 'claimtypeid', 'claimtypeid', 'landid', true, 'claimtypeid');
INSERT INTO la_ext_layerfield VALUES (383, 35, 'createdby', 'createdby', 'landid', true, 'createdby');
INSERT INTO la_ext_layerfield VALUES (384, 35, 'landno', 'landno', 'landid', true, 'landno');
INSERT INTO la_ext_layerfield VALUES (385, 35, 'projectnameid', 'projectnameid', 'landid', true, 'projectnameid');
INSERT INTO la_ext_layerfield VALUES (386, 35, 'landtypeid', 'landtypeid', 'landid', true, 'landtypeid');
INSERT INTO la_ext_layerfield VALUES (387, 35, 'spatialunitgroupid5', 'spatialunitgroupid5', 'landid', true, 'spatialunitgroupid5');
INSERT INTO la_ext_layerfield VALUES (388, 35, 'createddate', 'createddate', 'landid', true, 'createddate');
INSERT INTO la_ext_layerfield VALUES (389, 35, 'landid', 'landid', 'landid', true, 'landid');
INSERT INTO la_ext_layerfield VALUES (390, 35, 'hierarchyid2', 'hierarchyid2', 'landid', true, 'hierarchyid2');
INSERT INTO la_ext_layerfield VALUES (391, 35, 'tenureclassid', 'tenureclassid', 'landid', true, 'tenureclassid');
INSERT INTO la_ext_layerfield VALUES (392, 35, 'spatialunitgroupid1', 'spatialunitgroupid1', 'landid', true, 'spatialunitgroupid1');
INSERT INTO la_ext_layerfield VALUES (393, 35, 'neighbor_south', 'neighbor_south', 'landid', true, 'neighbor_south');
INSERT INTO la_ext_layerfield VALUES (394, 35, 'isactive', 'isactive', 'landid', true, 'isactive');
INSERT INTO la_ext_layerfield VALUES (395, 35, 'geometrytype', 'geometrytype', 'landid', true, 'geometrytype');
INSERT INTO la_ext_layerfield VALUES (396, 35, 'modifiedby', 'modifiedby', 'landid', true, 'modifiedby');
INSERT INTO la_ext_layerfield VALUES (397, 35, 'hierarchyid6', 'hierarchyid6', 'landid', true, 'hierarchyid6');
INSERT INTO la_ext_layerfield VALUES (398, 35, 'landsharetypeid', 'landsharetypeid', 'landid', true, 'landsharetypeid');
INSERT INTO la_ext_layerfield VALUES (399, 35, 'workflowstatusid', 'workflowstatusid', 'landid', true, 'workflowstatusid');
INSERT INTO la_ext_layerfield VALUES (400, 35, 'hierarchyid1', 'hierarchyid1', 'landid', true, 'hierarchyid1');
INSERT INTO la_ext_layerfield VALUES (401, 35, 'applicationstatusid', 'applicationstatusid', 'landid', true, 'applicationstatusid');
INSERT INTO la_ext_layerfield VALUES (402, 35, 'hierarchyid5', 'hierarchyid5', 'landid', true, 'hierarchyid5');
INSERT INTO la_ext_layerfield VALUES (403, 35, 'neighbor_west', 'neighbor_west', 'landid', true, 'neighbor_west');
INSERT INTO la_ext_layerfield VALUES (404, 35, 'spatialunitgroupid3', 'spatialunitgroupid3', 'landid', true, 'spatialunitgroupid3');
INSERT INTO la_ext_layerfield VALUES (405, 35, 'area', 'area', 'landid', true, 'area');
INSERT INTO la_ext_layerfield VALUES (406, 35, 'neighbor_north', 'neighbor_north', 'landid', true, 'neighbor_north');
INSERT INTO la_ext_layerfield VALUES (407, 35, 'landsoilqualityid', 'landsoilqualityid', 'landid', true, 'landsoilqualityid');
INSERT INTO la_ext_layerfield VALUES (408, 35, 'neighbor_east', 'neighbor_east', 'landid', true, 'neighbor_east');
INSERT INTO la_ext_layerfield VALUES (409, 35, 'modifieddate', 'modifieddate', 'landid', true, 'modifieddate');
INSERT INTO la_ext_layerfield VALUES (410, 35, 'hierarchyid3', 'hierarchyid3', 'landid', true, 'hierarchyid3');
INSERT INTO la_ext_layerfield VALUES (411, 35, 'spatialunitgroupid6', 'spatialunitgroupid6', 'landid', true, 'spatialunitgroupid6');
INSERT INTO la_ext_layerfield VALUES (412, 35, 'acquisitiontypeid', 'acquisitiontypeid', 'landid', true, 'acquisitiontypeid');
INSERT INTO la_ext_layerfield VALUES (413, 35, 'surveydate', 'surveydate', 'landid', true, 'surveydate');
INSERT INTO la_ext_layerfield VALUES (414, 35, 'spatialunitgroupid4', 'spatialunitgroupid4', 'landid', true, 'spatialunitgroupid4');



SELECT pg_catalog.setval('la_ext_layerfield_layerfieldid_seq', 452, true);




INSERT INTO la_ext_layergroup VALUES (81, 'projectLayerGroup', 'projectLayerGroup', true, 1, '2018-02-05 11:50:41.345', 1, '2018-02-05 11:50:41.345');



SELECT pg_catalog.setval('la_ext_layergroup_layergroupid_seq', 81, true);



INSERT INTO la_ext_layertype VALUES (1, 'WFS', 'WFS ', true);
INSERT INTO la_ext_layertype VALUES (2, 'WMS', 'WMS ', true);


SELECT pg_catalog.setval('la_ext_layertype_layertypeid_seq', 2, true);




INSERT INTO la_ext_module VALUES (1, 'bookmark', 'bookmark', '1', true);
INSERT INTO la_ext_module VALUES (2, 'clear_selection', 'clear_selection', '1', true);
INSERT INTO la_ext_module VALUES (3, 'complaint', 'complaint', '1', true);
INSERT INTO la_ext_module VALUES (4, 'dynalayer', 'dynalayer', '1', true);
INSERT INTO la_ext_module VALUES (5, 'editing', 'editing', '1', true);
INSERT INTO la_ext_module VALUES (6, 'export', 'export', '1', true);
INSERT INTO la_ext_module VALUES (7, 'fileupload', 'fileupload', '1', true);
INSERT INTO la_ext_module VALUES (8, 'fixedzoomin', 'fixedzoomin', '1', true);
INSERT INTO la_ext_module VALUES (9, 'fixedzoomout', 'fixedzoomout', '1', true);
INSERT INTO la_ext_module VALUES (10, 'fullview', 'fullview', '1', true);
INSERT INTO la_ext_module VALUES (11, 'geoprocessing', 'geoprocessing', '1', true);
INSERT INTO la_ext_module VALUES (12, 'importdata', 'importdata', '1', true);
INSERT INTO la_ext_module VALUES (13, 'info', 'info', '1', true);
INSERT INTO la_ext_module VALUES (14, 'intersection', 'intersection', '1', true);
INSERT INTO la_ext_module VALUES (15, 'magnetic', 'magnetic', '1', true);
INSERT INTO la_ext_module VALUES (16, 'markup', 'markup', '1', true);
INSERT INTO la_ext_module VALUES (17, 'measurelength', 'measurelength', '1', true);
INSERT INTO la_ext_module VALUES (18, 'openproject', 'openproject', '1', true);
INSERT INTO la_ext_module VALUES (19, 'pan', 'pan', '1', true);
INSERT INTO la_ext_module VALUES (20, 'print', 'print', '1', true);
INSERT INTO la_ext_module VALUES (21, 'query', 'query', '1', true);
INSERT INTO la_ext_module VALUES (22, 'radiometric', 'radiometric', '1', true);
INSERT INTO la_ext_module VALUES (23, 'report', 'report', '1', true);
INSERT INTO la_ext_module VALUES (24, 'saveproject', 'saveproject', '1', true);
INSERT INTO la_ext_module VALUES (25, 'search', 'search', '1', true);
INSERT INTO la_ext_module VALUES (26, 'selectbox', 'selectbox', '1', true);
INSERT INTO la_ext_module VALUES (27, 'selectfeature', 'selectfeature', '1', true);
INSERT INTO la_ext_module VALUES (28, 'selectpolygon', 'selectpolygon', '1', true);
INSERT INTO la_ext_module VALUES (29, 'textstyle', 'textstyle', '1', true);
INSERT INTO la_ext_module VALUES (30, 'thematic', 'thematic', '1', true);
INSERT INTO la_ext_module VALUES (31, 'zoomin', 'zoomin', '1', true);
INSERT INTO la_ext_module VALUES (32, 'zoomnext', 'zoomnext', '1', true);
INSERT INTO la_ext_module VALUES (33, 'zoomout', 'zoomout', '1', true);
INSERT INTO la_ext_module VALUES (34, 'zoomprevious', 'zoomprevious', '1', true);
INSERT INTO la_ext_module VALUES (35, 'zoomtolayer', 'zoomtolayer', '1', true);
INSERT INTO la_ext_module VALUES (36, 'zoomtoxy', 'zoomtoxy', '1', true);



SELECT pg_catalog.setval('la_ext_module_moduleid_seq', 37, true);




INSERT INTO la_ext_month VALUES (11, '10', true);
INSERT INTO la_ext_month VALUES (12, '11', true);
INSERT INTO la_ext_month VALUES (1, '0', true);
INSERT INTO la_ext_month VALUES (2, '1', true);
INSERT INTO la_ext_month VALUES (3, '2', true);
INSERT INTO la_ext_month VALUES (4, '3', true);
INSERT INTO la_ext_month VALUES (5, '4', true);
INSERT INTO la_ext_month VALUES (6, '5', true);
INSERT INTO la_ext_month VALUES (7, '6', true);
INSERT INTO la_ext_month VALUES (8, '7', true);
INSERT INTO la_ext_month VALUES (9, '8', true);
INSERT INTO la_ext_month VALUES (10, '9', true);




SELECT pg_catalog.setval('la_ext_month_monthid_seq', 1, false);


SELECT pg_catalog.setval('la_ext_personlandmapping_personlandid_seq', 267, true);




INSERT INTO la_ext_process VALUES (1, 'Lease', 'Lease', true);
INSERT INTO la_ext_process VALUES (2, 'Sale', 'Sale', true);
INSERT INTO la_ext_process VALUES (3, 'Mortgage', 'Mortgage', true);
INSERT INTO la_ext_process VALUES (6, 'Gift/Inheritance', 'Gift/Inheritance', true);
INSERT INTO la_ext_process VALUES (4, 'Change of Ownership', 'Change of Ownership', true);
INSERT INTO la_ext_process VALUES (5, 'Surrender of Lease', 'Surrender of Lease', true);
INSERT INTO la_ext_process VALUES (7, 'Change of Joint Owner', 'Change of Joint Owner', true);




SELECT pg_catalog.setval('la_ext_process_processid_seq', 7, true);






SELECT pg_catalog.setval('la_ext_projectadjudicator_projectadjudicatorid_seq', 1, false);



INSERT INTO la_ext_projectarea VALUES (84, 1, 1, 1, 2, 2, 3, 7, 4, 44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '2cc9e22c-54d7-4fe7-8c12-9d16a3734166', '', '12ca5cd1-8d0d-418f-88d5-aeb9bba8c793', '', '5db7dda2-ad08-47b1-9764-d3fa1f354d8b', '', true, 1, '2018-01-26 01:18:38.533', 1, '2018-01-26 01:18:38.533');
INSERT INTO la_ext_projectarea VALUES (88, 2, 1, 1, 2, 2, 3, 5, 4, 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '31ca7e41-874e-42c3-a956-074f34953c2b', 'Officer', '9d6bc1b9-aac8-4df8-ae3a-b7fead74d2d7', '', '681df1ea-1e58-47f3-b33a-b2a422f00a32', '', true, 1, '2018-01-30 20:13:26.08', 1, '2018-01-30 20:13:26.08');



SELECT pg_catalog.setval('la_ext_projectarea_projectareaid_seq', 88, true);




INSERT INTO la_ext_projectbaselayermapping VALUES (76, 3, 1, NULL, true, 1, '2018-01-26 00:00:00', NULL, NULL);
INSERT INTO la_ext_projectbaselayermapping VALUES (80, 5, 2, NULL, true, 1, '2018-01-30 00:00:00', NULL, NULL);


SELECT pg_catalog.setval('la_ext_projectbaselayermapping_projectbaselayerid_seq', 80, true);



INSERT INTO la_ext_projectfile VALUES (3, 'kakay.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (4, 'zolowee.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (5, 'blei.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (6, 'gba_boundary.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (7, 'zor_cf_boundary.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (2, 'gayeplay.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'jkfity', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (1, 'barpa.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'khtrtiy', true, 1, '2010-10-10 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (8, 'B-Donnie.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (9, 'B-kokeph.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (10, 'B-paye.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');
INSERT INTO la_ext_projectfile VALUES (11, 'B-varyoncon.mbtiles', 2, 'resources/documents/Liberia/mbtiles', 1, 12828, 'test', true, 1, '2011-11-11 00:00:00', 1, '2011-11-11 00:00:00');




SELECT pg_catalog.setval('la_ext_projectfile_projectfileid_seq', 100, true);






SELECT pg_catalog.setval('la_ext_projecthamlet_projecthamletid_seq', 1, false);




INSERT INTO la_ext_projection VALUES (1, 'EPSG:4326', 'EPSG:4326', true);
INSERT INTO la_ext_projection VALUES (2, 'EPSG:900913', 'EPSG:900913', true);




SELECT pg_catalog.setval('la_ext_projection_projectionid_seq', 1, false);




INSERT INTO la_ext_projectlayergroupmapping VALUES (58, 81, 1, NULL, true, 1, '2018-01-26 00:00:00', NULL, NULL);
INSERT INTO la_ext_projectlayergroupmapping VALUES (62, 81, 2, NULL, true, 1, '2018-01-30 00:00:00', NULL, NULL);



SELECT pg_catalog.setval('la_ext_projectlayergroupmapping_projectlayergroupid_seq', 62, true);



INSERT INTO la_ext_resource_custom_attribute VALUES (2, 'Resource Custom Attribute', 'Resource Custom Attribute', 5, 10, 'Custom', '100', true, '1', true, false, NULL, 2);
INSERT INTO la_ext_resource_custom_attribute VALUES (7, 'Resource Custom Attribute Sub Class 5', 'Resource Custom Attribute Sub Class 5', 5, 10, 'Custom', '100', true, '1', true, false, 3, 2);
INSERT INTO la_ext_resource_custom_attribute VALUES (5, 'Resource Custom Attribute Sub Class 3', 'Resource Custom Attribute Sub Class 3', 5, 10, 'Custom', '100', true, '1', true, false, 1, 2);
INSERT INTO la_ext_resource_custom_attribute VALUES (6, 'Resource Custom Attribute Sub Class 4', 'Resource Custom Attribute Sub Class 4', 5, 10, 'Custom', '100', true, '1', true, false, 2, 2);




SELECT pg_catalog.setval('la_ext_resource_custom_attribute_customattributeid_seq', 7, true);


SELECT pg_catalog.setval('la_ext_resource_documentdetails_documentid_seq', 311, true);

SELECT pg_catalog.setval('la_ext_resourceattributevalue_attributevalueid_seq', 621, true);



INSERT INTO la_ext_resourceclassification VALUES (1, 'Built-Up-Area', true);
INSERT INTO la_ext_resourceclassification VALUES (2, 'Community Facilities - Line', true);
INSERT INTO la_ext_resourceclassification VALUES (3, 'Community Facilities - Point', true);
INSERT INTO la_ext_resourceclassification VALUES (4, 'Agricultural Land', true);
INSERT INTO la_ext_resourceclassification VALUES (5, 'Forest-Woodlands', true);
INSERT INTO la_ext_resourceclassification VALUES (6, 'Barren Land', true);
INSERT INTO la_ext_resourceclassification VALUES (7, 'Cultural/Economic/Protected Areas', true);
INSERT INTO la_ext_resourceclassification VALUES (8, 'Wetland', true);
INSERT INTO la_ext_resourceclassification VALUES (9, 'Water', true);



SELECT pg_catalog.setval('la_ext_resourceclassification_classificationid_seq', 9, true);



SELECT pg_catalog.setval('la_ext_resourcecustomattributevalue_customattributevalueid_seq', 139, true);

SELECT pg_catalog.setval('la_ext_resourcelandclassificationmapping_landclassmappingid_seq', 74, true);



INSERT INTO la_ext_resourcepoiattributemaster VALUES (1, 'First Name', 'First Name', 1, NULL, 'resourcepoiattribute', '100', true, '1', true, true);
INSERT INTO la_ext_resourcepoiattributemaster VALUES (2, 'Middle Name', 'Middle Name', 1, NULL, 'resourcepoiattribute', '100', true, '2', true, true);
INSERT INTO la_ext_resourcepoiattributemaster VALUES (3, 'Last Name', 'Last Name', 1, NULL, 'resourcepoiattribute', '100', true, '3', true, true);
INSERT INTO la_ext_resourcepoiattributemaster VALUES (4, 'DOB', 'DOB', 2, NULL, 'resourcepoiattribute', '100', true, '4', true, true);
INSERT INTO la_ext_resourcepoiattributemaster VALUES (5, 'Relationship Type', 'Relationship Type', 5, NULL, 'resourcepoiattribute', '100', true, '5', true, true);
INSERT INTO la_ext_resourcepoiattributemaster VALUES (6, 'Gender', 'Gender', 5, NULL, 'resourcepoiattribute', '100', true, '6', true, true);



SELECT pg_catalog.setval('la_ext_resourcepoiattributemasterid_seq', 6, true);




SELECT pg_catalog.setval('la_ext_resourcepoiattributevalue_attributevalueid_seq', 76, true);




INSERT INTO la_ext_resourcesubclassification VALUES (1, 1, 3, 'Urban', true);
INSERT INTO la_ext_resourcesubclassification VALUES (2, 1, 3, 'Non-Urban', true);
INSERT INTO la_ext_resourcesubclassification VALUES (3, 2, 2, 'Road', true);
INSERT INTO la_ext_resourcesubclassification VALUES (4, 2, 2, 'Path', true);
INSERT INTO la_ext_resourcesubclassification VALUES (5, 3, 1, 'Bridge', true);
INSERT INTO la_ext_resourcesubclassification VALUES (6, 3, 1, 'Buildings', true);
INSERT INTO la_ext_resourcesubclassification VALUES (7, 3, 1, 'Churches', true);
INSERT INTO la_ext_resourcesubclassification VALUES (8, 3, 1, 'School', true);
INSERT INTO la_ext_resourcesubclassification VALUES (9, 3, 1, 'Clinic', true);
INSERT INTO la_ext_resourcesubclassification VALUES (10, 3, 1, 'Community meeting', true);
INSERT INTO la_ext_resourcesubclassification VALUES (11, 3, 1, 'Market', true);
INSERT INTO la_ext_resourcesubclassification VALUES (12, 3, 1, 'Others', true);
INSERT INTO la_ext_resourcesubclassification VALUES (13, 4, 3, 'Rain-fed small plot agriculture', true);
INSERT INTO la_ext_resourcesubclassification VALUES (14, 4, 3, 'Irrigated small plot agriculture ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (15, 4, 3, 'Grazing lands- pastures (stationary)', true);
INSERT INTO la_ext_resourcesubclassification VALUES (16, 4, 3, 'Grazing Lands -pastoralism', true);
INSERT INTO la_ext_resourcesubclassification VALUES (17, 4, 3, 'Agro-forestry ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (18, 4, 3, 'Aquaculture ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (19, 5, 3, 'Natural Forest ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (20, 5, 3, 'Mixed forest ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (21, 5, 3, 'Open woodland', true);
INSERT INTO la_ext_resourcesubclassification VALUES (22, 5, 3, 'Parks', true);
INSERT INTO la_ext_resourcesubclassification VALUES (23, 6, 3, 'Bare Rock', true);
INSERT INTO la_ext_resourcesubclassification VALUES (24, 6, 3, 'Sand or Desert or Plains', true);
INSERT INTO la_ext_resourcesubclassification VALUES (25, 6, 3, 'Sparsely Vegetalated', true);
INSERT INTO la_ext_resourcesubclassification VALUES (26, 6, 3, 'Others', true);
INSERT INTO la_ext_resourcesubclassification VALUES (27, 7, 3, 'Mining Sites', true);
INSERT INTO la_ext_resourcesubclassification VALUES (28, 7, 3, 'Hunting and gathering areas ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (29, 7, 3, 'Fishing areas ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (30, 7, 3, 'Wildlife areas ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (31, 7, 3, 'Protected/conservation areas', true);
INSERT INTO la_ext_resourcesubclassification VALUES (32, 7, 3, 'Cultural Areas', true);
INSERT INTO la_ext_resourcesubclassification VALUES (33, 8, 3, 'Inland wetland vegetation', true);
INSERT INTO la_ext_resourcesubclassification VALUES (34, 8, 3, 'Coastal wetland vegetation ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (35, 8, 3, 'Coastal woodland ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (36, 9, 3, 'Water Courses  River', true);
INSERT INTO la_ext_resourcesubclassification VALUES (37, 9, 2, 'Water Courses  Stream', true);
INSERT INTO la_ext_resourcesubclassification VALUES (38, 9, 3, 'Water Bodies ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (39, 9, 3, 'Lagoon ', true);
INSERT INTO la_ext_resourcesubclassification VALUES (40, 9, 3, 'Sea and Ocean', true);




SELECT pg_catalog.setval('la_ext_resourcesubclassification_subclassificationid_seq', 40, true);




INSERT INTO la_ext_role VALUES (2, 'DPI', 'DPI', 'DPI Land Official', true);
INSERT INTO la_ext_role VALUES (3, 'PM', 'PM', 'Project Manager', true);
INSERT INTO la_ext_role VALUES (4, 'PUBLIC USER', 'PUBLIC USER', 'Public User', true);
INSERT INTO la_ext_role VALUES (5, 'SFR', 'SFR', 'SFR Land Official', true);
INSERT INTO la_ext_role VALUES (6, 'TRUSTED INTERMEDIARY', 'TRUSTED INTERMEDIARY', 'CFV Agent', true);
INSERT INTO la_ext_role VALUES (7, 'USER', 'USER', 'User', true);
INSERT INTO la_ext_role VALUES (1, 'ROLE_ADMIN', 'ADMIN', 'System Administrator', true);




SELECT pg_catalog.setval('la_ext_role_roleid_seq', 7, true);




INSERT INTO la_ext_rolemodulemapping VALUES (4, 1, 4, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (7, 1, 7, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (8, 1, 8, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (11, 1, 11, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (12, 1, 12, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (14, 1, 14, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (15, 1, 15, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (16, 1, 16, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (22, 1, 22, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (23, 1, 23, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (24, 1, 24, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (28, 1, 28, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (29, 1, 29, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (30, 1, 30, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (3, 1, 3, false, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (1, 1, 1, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (2, 1, 2, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (5, 1, 5, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (6, 1, 6, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (9, 1, 9, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (10, 1, 10, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (13, 1, 13, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (17, 1, 17, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (18, 1, 18, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (19, 1, 19, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (20, 1, 20, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (21, 1, 21, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (25, 1, 25, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (26, 1, 26, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (27, 1, 27, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (31, 1, 31, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (32, 1, 32, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (33, 1, 33, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (34, 1, 34, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (35, 1, 35, true, 1, '0208-10-05 00:00:00', NULL, NULL);
INSERT INTO la_ext_rolemodulemapping VALUES (36, 1, 36, true, 1, '0208-10-05 00:00:00', NULL, NULL);




SELECT pg_catalog.setval('la_ext_rolemodulemapping_rolemoduleid_seq', 38, true);



INSERT INTO la_ext_slopevalue VALUES (1, 'vfgdvd', true);




SELECT pg_catalog.setval('la_ext_slopevalue_slopevalueid_seq', 1, false);

SELECT pg_catalog.setval('la_ext_spatialunit_personwithinterest_id_seq', 37, true);




INSERT INTO la_ext_surveyprojectattributes VALUES (100, 1, 4, 2, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (101, 2, 1056, 16, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-11-22 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (52, 1, 1011, 7, 1, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (53, 1, 1012, 7, 1, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (54, 1, 1013, 7, 1, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (55, 1, 1014, 7, 1, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (56, 1, 1015, 7, 1, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (51, 1, 1010, 7, 2, true, 1, '2017-12-27 00:00:00', 1, '2017-12-27 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (57, 2, 1017, 10, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-11-22 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (58, 2, 1011, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (59, 2, 1013, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (1, 2, 1, 2, 1, true, 1, '2010-10-10 00:00:00', 1, '2011-10-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (2, 2, 2, 2, 1, true, 1, '2017-11-11 00:00:00', 1, '2017-12-18 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (3, 2, 3, 2, 1, true, 1, '2017-11-12 00:00:00', 1, '2017-12-17 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (4, 2, 4, 2, 1, true, 1, '2017-11-13 00:00:00', 1, '2017-12-16 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (5, 2, 5, 2, 1, true, 1, '2017-11-14 00:00:00', 1, '2017-12-15 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (6, 2, 6, 5, 1, true, 1, '2017-11-15 00:00:00', 1, '2017-12-14 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (7, 2, 7, 5, 1, true, 1, '2017-11-16 00:00:00', 1, '2017-12-13 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (8, 2, 8, 5, 1, true, 1, '2017-11-17 00:00:00', 1, '2017-12-12 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (9, 2, 9, 4, 1, true, 1, '2017-11-18 00:00:00', 1, '2017-12-11 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (10, 2, 10, 3, 1, true, 1, '2017-11-19 00:00:00', 1, '2017-12-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (11, 2, 11, 3, 1, true, 1, '2017-11-20 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (12, 2, 13, 4, 1, true, 1, '2017-11-21 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (15, 2, 22, 2, 1, true, 1, '2017-11-24 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (16, 2, 23, 4, 1, true, 1, '2017-11-25 00:00:00', 1, '2017-12-06 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (17, 2, 24, 4, 1, true, 1, '2017-11-26 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (19, 2, 40, 2, 1, true, 1, '2017-11-28 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (20, 2, 41, 2, 1, true, 1, '2017-11-29 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (21, 2, 42, 2, 1, true, 1, '2017-11-30 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (22, 2, 43, 2, 1, true, 1, '2017-12-01 00:00:00', 1, '2017-12-06 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (60, 2, 1015, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (13, 2, 15, 1, 1, true, 1, '2017-11-22 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (103, 1, 16, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (104, 1, 53, 7, 2, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (105, 1, 1052, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (106, 2, 1053, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (107, 2, 1057, 7, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (108, 2, 1063, 17, 1, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (18, 2, 37, 7, 4, true, 1, '2017-11-27 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (61, 2, 1018, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (62, 2, 1019, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (63, 2, 1020, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (64, 2, 1021, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (65, 2, 1022, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (66, 2, 1023, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (67, 2, 1024, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (68, 2, 1025, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (25, 2, 46, 7, 5, true, 1, '2017-12-04 00:00:00', 1, '2017-12-03 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (24, 2, 45, 7, 8, true, 1, '2017-12-03 00:00:00', 1, '2017-12-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (14, 2, 16, 7, 1, true, 1, '2017-11-23 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (26, 2, 47, 7, 6, true, 1, '2017-12-05 00:00:00', 1, '2017-12-04 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (69, 2, 1026, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (70, 2, 1027, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (71, 2, 1028, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (72, 2, 1029, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (73, 2, 1030, 10, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (74, 2, 1031, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (75, 2, 1032, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (76, 2, 1033, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (77, 2, 1034, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (78, 2, 1035, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (79, 2, 1010, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (80, 2, 1036, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (81, 2, 1037, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (82, 2, 1038, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (83, 2, 1039, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (84, 2, 1040, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (85, 2, 1041, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (86, 2, 1042, 14, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (87, 2, 1043, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (88, 2, 1044, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (89, 2, 1045, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (90, 2, 1046, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (91, 2, 1047, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (92, 2, 1048, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (93, 2, 1049, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (94, 2, 1050, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (95, 2, 1051, 12, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (96, 2, 1052, 9, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (98, 2, 1054, 15, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (99, 2, 1055, 15, 1, true, 1, '2018-01-02 00:00:00', 1, '2018-01-02 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (23, 2, 44, 7, 7, true, 1, '2017-12-02 00:00:00', 1, '2017-12-01 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (27, 2, 53, 7, 3, true, 1, '2017-12-06 00:00:00', 1, '2017-12-05 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (109, 2, 1064, 17, 6, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (110, 2, 1065, 17, 2, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (111, 2, 1066, 17, 3, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (112, 2, 1067, 17, 4, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (113, 2, 1068, 17, 5, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (114, 2, 1069, 17, 7, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (115, 2, 1070, 17, 8, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (116, 2, 1071, 17, 9, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (117, 2, 1072, 17, 12, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (118, 2, 1073, 17, 10, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (119, 2, 1074, 17, 11, true, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (120, 2, 1075, 17, 13, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (121, 2, 1076, 17, 14, false, 1, '2018-01-09 11:43:37.177624', 1, '2018-01-09 11:43:37.177624');
INSERT INTO la_ext_surveyprojectattributes VALUES (122, 2, 1115, 17, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (123, 2, 1116, 17, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (124, 2, 1117, 17, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (125, 2, 1118, 17, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (126, 2, 1119, 17, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (127, 2, 1120, 17, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (128, 2, 1121, 17, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (129, 2, 1122, 17, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (130, 2, 1123, 17, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (131, 2, 1124, 17, 12, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (132, 2, 1125, 17, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (133, 2, 1126, 17, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (134, 2, 1127, 17, 13, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (135, 2, 1128, 17, 14, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (138, 2, 1077, 18, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (139, 2, 1078, 18, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (140, 2, 1079, 18, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (141, 2, 1080, 18, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (142, 2, 1081, 18, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (143, 2, 1082, 18, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (147, 2, 1086, 18, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (148, 2, 1087, 11, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (149, 2, 1088, 11, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (150, 2, 1089, 11, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (151, 2, 1090, 11, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (152, 2, 1091, 11, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (183, 2, 1136, 5, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (184, 2, 1137, 5, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (185, 2, 1138, 5, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (156, 2, 1095, 11, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (157, 2, 1096, 12, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (158, 2, 1097, 12, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (159, 2, 1098, 12, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (160, 2, 1099, 12, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (161, 2, 1100, 12, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (166, 2, 1105, 12, 11, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (167, 2, 1106, 13, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (168, 2, 1107, 13, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (169, 2, 1108, 13, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (170, 2, 1109, 13, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (171, 2, 1110, 13, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (172, 2, 1111, 13, 9, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (186, 2, 1139, 8, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (187, 2, 1140, 8, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (188, 2, 1141, 8, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (189, 2, 1142, 8, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (190, 2, 1143, 1, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (191, 2, 1144, 1, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (146, 2, 1085, 18, 1, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (192, 2, 1145, 1, 3, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (193, 2, 1146, 1, 4, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (194, 2, 1147, 1, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (173, 2, 1112, 13, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (174, 2, 1113, 13, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (175, 2, 1114, 13, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (162, 2, 1101, 12, 9, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (163, 2, 1102, 12, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (164, 2, 1103, 12, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (165, 2, 1104, 12, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (153, 2, 1092, 11, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (154, 2, 1093, 11, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (155, 2, 1094, 11, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (144, 2, 1083, 18, 10, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (145, 2, 1084, 18, 1, false, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (176, 2, 1129, 2, 5, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (177, 2, 1130, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (178, 2, 1131, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (179, 2, 1132, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (180, 2, 1133, 2, 10, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (181, 2, 1134, 2, 12, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (182, 2, 1135, 2, 13, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (195, 2, 1148, 1, 6, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (196, 2, 1149, 1, 7, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (197, 2, 1150, 1, 8, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (198, 2, 1058, 7, 2, true, 1, '2018-01-09 12:45:40.849537', 1, '2018-01-09 12:45:40.849537');
INSERT INTO la_ext_surveyprojectattributes VALUES (199, 2, 1151, 2, 10, true, 1, '2010-10-10 00:00:00', 1, '2010-10-10 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (200, 2, 1059, 2, 8, true, 1, '2018-01-25 19:13:05.002602', 1, '2018-01-25 19:13:05.002602');
INSERT INTO la_ext_surveyprojectattributes VALUES (202, 2, 1152, 2, 10, true, 1, '2018-01-31 00:00:00', 1, '2018-01-31 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (203, 2, 1153, 2, 11, true, 1, '2018-01-31 00:00:00', 1, '2018-01-31 00:00:00');
INSERT INTO la_ext_surveyprojectattributes VALUES (204, 2, 1154, 5, 1, true, 1, '2018-01-04 00:00:00', 1, '2018-01-04 00:00:00');




SELECT pg_catalog.setval('la_ext_surveyprojectattributes_surveyprojectattributesid_seq', 204, true);

SELECT pg_catalog.setval('la_ext_transactiondetails_transactionid_seq', 359, true);




INSERT INTO la_ext_unit VALUES (1, 'Foot', 'Foot', true);
INSERT INTO la_ext_unit VALUES (2, 'Inches ', 'Inches ', true);
INSERT INTO la_ext_unit VALUES (3, 'Kilometer', 'Kilometer', true);
INSERT INTO la_ext_unit VALUES (4, 'Meter', 'Meter', true);
INSERT INTO la_ext_unit VALUES (5, 'Miles', 'Miles', true);
INSERT INTO la_ext_unit VALUES (6, 'dd', 'dd', true);



SELECT pg_catalog.setval('la_ext_unit_unitid_seq', 6, true);




INSERT INTO la_ext_user VALUES (8, 'kamal upreti', '1', 1, 'kamal', 'fKWj6MUZPAUPUSlBH0QTKw==', 'woRwTpht7aHCW3g3sTzzMJBgP5%2BJznXPG5H2ta6nArWLoRqOn0oLv6yKeTiXL%2FXd', 'kamal@rmsi.com', '9545478220', 'test address ', '2019-06-15', '2018-01-22', true, 1, '2018-01-22 21:38:10.048', 1, '2018-01-22 21:38:10.048', 'CB_Proj');
INSERT INTO la_ext_user VALUES (23, 'Rmsi  user', '1', 1, 'Rmsi', 'oRaVJ22dC9+yi6jk7HEeKA==', 'b5NHiwWKMYpXP9jco9k057AIuQtAaMHRCgOCF50zEAng62B0yt62Ch0%2FykVCbJ1v', 'test@rmsi.com', '1234567890', 'Test Address', '2017-12-13', '2018-01-09', true, 1, '2018-01-09 14:20:16.932', 1, '2018-01-09 14:20:16.932', 'CB_Proj');
INSERT INTO la_ext_user VALUES (1, 'abc', '', 1, 'admin', 'SV/eJ0xo8TzVg4bi0K9BOA==', '8FK404N4zYblR3x7mlca3J2IfU8roeQGw13Oh6uiW9Un%2BsBBotoguQeAR0od6w%2Fc', 'abc@gmail.com', '8475988148', 'Test Address ', '2018-10-12', '2018-02-07', true, 1, '2018-02-07 16:15:12.479', 1, '2018-02-07 16:15:12.479', 'New Project');



SELECT pg_catalog.setval('la_ext_user_userid_seq', 23, true);




INSERT INTO la_ext_userprojectmapping VALUES (139, 1, 1, true, 1, '2018-01-26 00:00:00', 0, NULL);
INSERT INTO la_ext_userprojectmapping VALUES (143, 1, 2, true, 1, '2018-01-30 00:00:00', 0, NULL);


SELECT pg_catalog.setval('la_ext_userprojectmapping_userprojectid_seq', 143, true);



INSERT INTO la_ext_userrolemapping VALUES (26, 23, 1, true, 1, '2018-01-09 14:20:16.932', 0, NULL);
INSERT INTO la_ext_userrolemapping VALUES (30, 8, 1, true, 1, '2018-01-22 21:38:10.044', 0, NULL);
INSERT INTO la_ext_userrolemapping VALUES (42, 1, 1, true, 1, '2018-02-07 16:15:12.478', 0, NULL);



SELECT pg_catalog.setval('la_ext_userrolemapping_userroleid_seq', 42, true);



INSERT INTO la_ext_workflow VALUES (1, 'New', 'New', 1, true, 1);
INSERT INTO la_ext_workflow VALUES (2, 'Process Data for Field Verification', 'Process Data for Field Verification', 2, true, 1);
INSERT INTO la_ext_workflow VALUES (3, 'Field Verification & Update Land Record ', 'Field Verification & Update Land Record ', 3, true, 1);
INSERT INTO la_ext_workflow VALUES (4, 'Generate and Print Land Certificate', 'Generate and Print Land Certificate', 4, true, 1);
INSERT INTO la_ext_workflow VALUES (5, 'Rejected', 'Rejected', 5, true, 1);
INSERT INTO la_ext_workflow VALUES (6, 'Approved', 'Approved', 6, true, 1);




SELECT pg_catalog.setval('la_ext_workflow_workflowid_seq', 6, false);



INSERT INTO la_ext_workflowactionmapping VALUES (15, 'Print Land Certificate ', 'Print Land Certificate ', 1, 4, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping VALUES (12, 'Move to "Generate and Print Land Certificate"', 'Move to "Generate and Print Land Certificate"', 1, 3, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping VALUES (8, 'Move to "Field Verification" stage ', 'Move to "Field Verification" stage ', 1, 2, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping VALUES (10, 'Edit Attributes ', 'Edit Attributes ', 1, 3, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping VALUES (11, 'Print Land Record Verification Form', 'Print Land Record Verification Form', 1, 3, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping VALUES (14, 'View  Attributes ', 'View  Attributes ', 1, 4, 2, true, 'view                                              ');
INSERT INTO la_ext_workflowactionmapping VALUES (16, 'Finalize Land Certificate and Register', 'Finalize Land Certificate and Register', 1, 4, 4, true, 'register                                          ');
INSERT INTO la_ext_workflowactionmapping VALUES (13, 'View Spatial ', 'View Spatial ', 1, 4, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping VALUES (19, 'Data Correction Report', 'Data Correction Report', 1, 1, 6, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping VALUES (2, 'Edit Attributes ', 'Edit Attributes ', 1, 1, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping VALUES (3, 'Reject', 'Reject', 1, 1, 3, true, 'reject                                            ');
INSERT INTO la_ext_workflowactionmapping VALUES (4, 'Move to "Process Data" ', 'Move to "Process Data" ', 1, 1, 4, true, 'approve                                           ');
INSERT INTO la_ext_workflowactionmapping VALUES (6, 'Edit Attributes ', 'Edit Attributes ', 1, 2, 2, true, 'edit                                              ');
INSERT INTO la_ext_workflowactionmapping VALUES (7, 'Generates Land Record Verification Form', 'Generates Land Record Verification Form', 1, 2, 3, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping VALUES (1, 'Edit Spatial ', 'Edit Spatial ', 1, 1, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping VALUES (5, 'Edit Spatial ', 'Edit Spatial ', 1, 2, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping VALUES (9, 'Edit Spatial ', 'View Spatial ', 1, 3, 1, true, 'edit  spatial                                     ');
INSERT INTO la_ext_workflowactionmapping VALUES (17, 'Edit Spatial', 'Edit Spatial', 1, 5, 1, true, 'print                                             ');
INSERT INTO la_ext_workflowactionmapping VALUES (18, 'Edit Spatial', 'Edit Spatial', 1, 5, 2, true, 'delete                                            ');



SELECT pg_catalog.setval('la_ext_workflowactionmapping_workflowactionid_seq', 1, false);



INSERT INTO la_ext_workflowdef VALUES (1, 'NewProjectWorkFlow', 2);



SELECT pg_catalog.setval('la_ext_workflowdef_workflowdefid_seq', 1, false);







SELECT pg_catalog.setval('la_lease_leaseid_seq', 1, true);

SELECT pg_catalog.setval('la_mortgage_mortgageid_seq', 1, true);



SELECT pg_catalog.setval('la_party_partyid_seq', 1, true);

INSERT INTO la_partygroup_educationlevel VALUES (2, 'Primary', 'Primary', true);
INSERT INTO la_partygroup_educationlevel VALUES (3, 'Secondary', 'Secondary', true);
INSERT INTO la_partygroup_educationlevel VALUES (4, 'University', 'University', true);
INSERT INTO la_partygroup_educationlevel VALUES (1, 'None', 'None', true);




SELECT pg_catalog.setval('la_partygroup_educationlevel_educationlevelid_seq', 5, true);


INSERT INTO la_partygroup_gender VALUES (1, 'Male', 'Male', true);
INSERT INTO la_partygroup_gender VALUES (2, 'Female', 'Female', true);
INSERT INTO la_partygroup_gender VALUES (3, 'Other', 'Other', true);



SELECT pg_catalog.setval('la_partygroup_gender_genderid_seq', 3, true);


INSERT INTO la_partygroup_identitytype VALUES (1, 'Voter ID', 'Voter ID', true);
INSERT INTO la_partygroup_identitytype VALUES (2, 'Driving license', 'Driving license', true);
INSERT INTO la_partygroup_identitytype VALUES (3, 'Passport', 'Passport', true);
INSERT INTO la_partygroup_identitytype VALUES (4, 'ID card', 'ID card', true);
INSERT INTO la_partygroup_identitytype VALUES (5, 'Other', 'Other', true);
INSERT INTO la_partygroup_identitytype VALUES (6, 'None', 'None', true);



SELECT pg_catalog.setval('la_partygroup_identitytype_identitytypeid_seq', 6, true);



INSERT INTO la_partygroup_maritalstatus VALUES (2, 'Married', 'Married', true);
INSERT INTO la_partygroup_maritalstatus VALUES (3, 'Divorced', 'Divorced', true);
INSERT INTO la_partygroup_maritalstatus VALUES (4, 'Widow', 'Widow', true);
INSERT INTO la_partygroup_maritalstatus VALUES (5, 'Widower', 'Widower', true);
INSERT INTO la_partygroup_maritalstatus VALUES (1, 'un-married', 'un-married', true);



SELECT pg_catalog.setval('la_partygroup_maritalstatus_maritalstatusid_seq', 5, true);



INSERT INTO la_partygroup_occupation VALUES (2, 'Private Employee', 'Private Employee', true);
INSERT INTO la_partygroup_occupation VALUES (1, 'Public Employee', 'Public Employee', true);
INSERT INTO la_partygroup_occupation VALUES (3, 'Farmer', 'Farmer', true);
INSERT INTO la_partygroup_occupation VALUES (4, 'Carpenter', 'Carpenter', true);
INSERT INTO la_partygroup_occupation VALUES (5, 'Grazing', 'Grazing', true);
INSERT INTO la_partygroup_occupation VALUES (6, 'Ley farming', 'Ley farming', true);
INSERT INTO la_partygroup_occupation VALUES (7, 'Massion', 'Massionh', true);




SELECT pg_catalog.setval('la_partygroup_occupation_occupationid_seq', 7, true);



INSERT INTO la_partygroup_persontype VALUES (1, 'Person (Natural)', 'Person (Natural)', true);
INSERT INTO la_partygroup_persontype VALUES (2, 'Organization (Non-Natural)', 'Organization (Non-Natural)', true);
INSERT INTO la_partygroup_persontype VALUES (4, 'Guardian', 'Guardian', true);
INSERT INTO la_partygroup_persontype VALUES (5, 'Tenant', 'Tenant', true);
INSERT INTO la_partygroup_persontype VALUES (6, 'Administrator', 'Administrator', true);
INSERT INTO la_partygroup_persontype VALUES (7, 'Witness', 'Witness', true);
INSERT INTO la_partygroup_persontype VALUES (8, 'Deceased Person', 'Deceased Person', true);
INSERT INTO la_partygroup_persontype VALUES (9, 'Person of Intrest', 'Person of Intrest', true);
INSERT INTO la_partygroup_persontype VALUES (3, 'Owner', 'Owner', true);
INSERT INTO la_partygroup_persontype VALUES (10, 'dispute person', 'dispute person', true);



SELECT pg_catalog.setval('la_partygroup_persontype_persontypeid_seq', 10, true);




INSERT INTO la_partygroup_relationshiptype VALUES (1, 'Father', 'Father', true);
INSERT INTO la_partygroup_relationshiptype VALUES (2, 'Mother', 'Mother', true);
INSERT INTO la_partygroup_relationshiptype VALUES (3, 'Sister', 'Sister', true);
INSERT INTO la_partygroup_relationshiptype VALUES (4, 'Brother', 'Brother', true);
INSERT INTO la_partygroup_relationshiptype VALUES (5, 'Son', 'Son', true);
INSERT INTO la_partygroup_relationshiptype VALUES (6, 'Daughter', 'Daughter', true);
INSERT INTO la_partygroup_relationshiptype VALUES (7, 'Grandmother', 'Grandmother', true);
INSERT INTO la_partygroup_relationshiptype VALUES (8, 'Grandfather', 'Grandfather', true);
INSERT INTO la_partygroup_relationshiptype VALUES (9, 'Grandson', 'Grandson', true);
INSERT INTO la_partygroup_relationshiptype VALUES (10, 'Granddaughter', 'Granddaughter', true);
INSERT INTO la_partygroup_relationshiptype VALUES (11, 'Uncle', 'Uncle', true);
INSERT INTO la_partygroup_relationshiptype VALUES (12, 'Aunt', 'Aunt', true);
INSERT INTO la_partygroup_relationshiptype VALUES (13, 'Niece', 'Niece', true);
INSERT INTO la_partygroup_relationshiptype VALUES (14, 'Nephew', 'Nephew', true);
INSERT INTO la_partygroup_relationshiptype VALUES (15, 'Other relatives', 'Other relatives', true);
INSERT INTO la_partygroup_relationshiptype VALUES (16, 'Partners', 'Partners', true);
INSERT INTO la_partygroup_relationshiptype VALUES (17, 'Other', 'Other', true);
INSERT INTO la_partygroup_relationshiptype VALUES (18, 'Spouses', 'Spouses', true);
INSERT INTO la_partygroup_relationshiptype VALUES (19, 'Parents and children', 'Parents and children', true);
INSERT INTO la_partygroup_relationshiptype VALUES (20, 'Siblings', 'Siblings', true);



SELECT pg_catalog.setval('la_partygroup_relationshiptype_relationshiptypeid_seq', 20, true);




INSERT INTO la_right_acquisitiontype VALUES (1, 'Kupewa na Halmashauri ya Kijiji', 'Allocated by Village Council', true);
INSERT INTO la_right_acquisitiontype VALUES (2, 'Zawadi', 'Gift', true);
INSERT INTO la_right_acquisitiontype VALUES (3, 'Urithi', 'Inheritance', true);
INSERT INTO la_right_acquisitiontype VALUES (4, 'Kununua', 'Purchase', true);




SELECT pg_catalog.setval('la_right_acquisitiontype_acquisitiontypeid_seq', 4, false);




INSERT INTO la_right_claimtype VALUES (4, 'Unclaimed', 'Unclaimed', true);
INSERT INTO la_right_claimtype VALUES (2, 'Existing Claim or Right', 'Existing Claim or Right', true);
INSERT INTO la_right_claimtype VALUES (3, 'Disputed Claim', 'Disputed Claim', true);
INSERT INTO la_right_claimtype VALUES (5, 'No Claim', 'No Claim for resource', false);
INSERT INTO la_right_claimtype VALUES (1, 'New claim', 'New claim', true);




SELECT pg_catalog.setval('la_right_claimtype_claimtypeid_seq', 5, true);




INSERT INTO la_right_landsharetype VALUES (6, 'Single Tenancy', 'Single Tenancy', true);
INSERT INTO la_right_landsharetype VALUES (7, 'Joint Tenancy', 'Joint Tenancy', true);
INSERT INTO la_right_landsharetype VALUES (8, 'Common Tenancy', 'Common Tenancy', true);
INSERT INTO la_right_landsharetype VALUES (9, 'Collective Tenancy', 'Collective Tenancy', true);
INSERT INTO la_right_landsharetype VALUES (1, 'Co-occupancy (Tenancy in Common)', 'Co-occupancy (Tenancy in Common)', false);
INSERT INTO la_right_landsharetype VALUES (2, 'Single Occupant', 'Single Occupant', false);
INSERT INTO la_right_landsharetype VALUES (3, 'Co-occupancy (Joint tenancy)', 'Co-occupancy (Joint tenancy)', false);
INSERT INTO la_right_landsharetype VALUES (4, 'Customary(Individual)', 'Customary(Individual)', false);
INSERT INTO la_right_landsharetype VALUES (5, 'Customary(Collective)', 'Customary(Collective)', false);
INSERT INTO la_right_landsharetype VALUES (9999, 'Dummy', 'Dummy', true);




SELECT pg_catalog.setval('la_right_landsharetype_landsharetypeid_seq', 9, true);



INSERT INTO la_right_tenureclass VALUES (1, 'Derivative Right', 'Derivative Right', true);
INSERT INTO la_right_tenureclass VALUES (2, 'Customary Right of Occupancy', 'Customary Right of Occupancy', true);
INSERT INTO la_right_tenureclass VALUES (4, 'Right of Use', 'Right of Use', true);
INSERT INTO la_right_tenureclass VALUES (5, 'Formal Ownership (Free-hold)', 'Formal Ownership (Free-hold)', true);
INSERT INTO la_right_tenureclass VALUES (6, 'Granted Right of Occupancy', 'Granted Right of Occupancy', true);
INSERT INTO la_right_tenureclass VALUES (7, 'Right to Manage', 'Right to Manage', true);
INSERT INTO la_right_tenureclass VALUES (3, 'Right to Ownership ', 'Cerificate of Occupany', true);
INSERT INTO la_right_tenureclass VALUES (9999, 'Dummy', 'Dummy', true);



SELECT pg_catalog.setval('la_right_tenureclass_tenureclassid_seq', 7, true);





SELECT pg_catalog.setval('la_rrr_rrrid_seq', 1, false);



INSERT INTO la_spatialsource_layer VALUES (44, 'LaberiaUpperNimba', 1, 3, 3, 2, NULL, NULL, 18, '-8.723872,7.337482,-8.422441,7.687455', '-8.723872,7.337482,-8.422441,7.687455', 100, 10000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'LaberiaUpperNimba', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:26:50.859', NULL, NULL, 'Mast:Towns__UpperNimba');
INSERT INTO la_spatialsource_layer VALUES (32, 'pyramid', 1, 2, 2, 2, NULL, NULL, 10, '35.739998,-7.900000999970367,35.83000249996666,-7.82', '35.739998,-7.900000999970367,35.83000249996666,-7.82', 10, 10, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'pyramid', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 2, '2017-12-11 17:08:16.943', 2, '2017-12-11 17:08:16.943', 'Mast:pyramids');
INSERT INTO la_spatialsource_layer VALUES (33, 'AOI', 1, 4, 3, 1, NULL, NULL, NULL, '34.9862284585834,-8.3416087407727,37.6789802312851,-5.61527110433126', '34.9862284585834,-8.3416087407727,37.6789802312851,-5.61527110433126', 2, 10, 'http://52.15.254.146/geoserver/wfs?', NULL, 0, 'LA_SPATIALUNIT_AOI', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-04 12:17:45.898', NULL, NULL, 'Mast:la_spatialunit_aoi');
INSERT INTO la_spatialsource_layer VALUES (34, 'Resource', 1, 5, 3, 1, NULL, NULL, NULL, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', 2, 10, 'http://52.15.254.146/geoserver/wfs?', NULL, 0, 'LA_SPATIALUNIT_RESOURCE', NULL, NULL, true, false, true, true, false, true, true, NULL, true, true, 1, '2018-01-04 12:19:44.972', NULL, NULL, 'Mast:la_spatialunit_resource_land');
INSERT INTO la_spatialsource_layer VALUES (35, 'Line', 1, 6, 2, 1, NULL, NULL, NULL, '35.0,-9.0,36.0,-7.0', '35.0,-9.0,36.0,-7.0', 2, 10, 'http://52.15.254.146/geoserver/wfs?', NULL, 0, 'Line', NULL, NULL, true, false, true, true, false, true, false, NULL, false, true, 1, '2018-01-08 19:27:01.559', NULL, NULL, 'Mast:la_spatialunit_resource_line');
INSERT INTO la_spatialsource_layer VALUES (36, 'point', 1, 6, 2, 1, NULL, NULL, NULL, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '35.0,-9.0,36.0,-7.0', 2, 10, 'http://52.15.254.146/geoserver/wfs?', NULL, 0, 'point', NULL, NULL, true, false, true, true, false, false, true, NULL, false, true, 1, '2018-01-08 19:27:51.348', NULL, NULL, 'Mast:la_spatialunit_resource_point');
INSERT INTO la_spatialsource_layer VALUES (38, 'LiberiaDisctrict', 1, 3, 3, 2, NULL, NULL, 18, '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', 100, 1000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'Liberia Disctrict', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 13:01:03.041', NULL, NULL, 'Mast:LBR_district');
INSERT INTO la_spatialsource_layer VALUES (31, 'spatialUnitLand', 1, 6, 2, 1, NULL, NULL, 2, '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', '34.9655456095934,-8.57657546620732,35.9042312577367,-7.83167176245347', 10, 1000, 'http://52.15.254.146/geoserver/wfs?', NULL, 0, 'spatialUnitLand', NULL, NULL, true, true, true, true, false, false, true, NULL, false, true, 2, '2017-12-11 16:19:20.27', 2, '2017-12-11 16:19:20.27', 'Mast:la_spatialunit_land');
INSERT INTO la_spatialsource_layer VALUES (37, 'lbr_rdsl_unmil', 1, 3, 3, 2, NULL, NULL, 18, '-11.468869999999924,4.355470000000082,-7.444569999999922,8.52425000000007', '-11.468869999999924,4.355470000000082,-7.444569999999922,8.52425000000007', 100, 10000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'lbr_rdsl_unmil', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 12:59:37.05', NULL, NULL, 'Mast:lbr_rdsl_unmil');
INSERT INTO la_spatialsource_layer VALUES (39, 'LiberiaBuchanan', 1, 3, 3, 2, NULL, NULL, 18, '-10.24205,5.82119,-9.55522,6.23263', '-10.24205,5.82119,-9.55522,6.23263', 100, 10000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'Liberia Buchanan', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:22:03.757', NULL, NULL, 'Mast:Buchanan_4barconnie');
INSERT INTO la_spatialsource_layer VALUES (40, 'LiberiaClan', 1, 3, 3, 2, NULL, NULL, 18, '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000021', '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000021', 100, 10000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'Liberia clan', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:23:22.53', NULL, NULL, 'Mast:LBR_clan');
INSERT INTO la_spatialsource_layer VALUES (41, 'LiberiaCountry', 1, 3, 3, 2, NULL, NULL, 18, '-11.485694999999964,4.35291600000005,-7.365112999999951,8.551790000000096', '-11.485694999999964,4.35291600000005,-7.365112999999951,8.551790000000096', 100, 1000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'LiberiaCountry', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:24:19.843', NULL, NULL, 'Mast:LBR_country');
INSERT INTO la_spatialsource_layer VALUES (42, 'LiberiaLowerNimba', 1, 3, 3, 2, NULL, NULL, 18, '-8.861252,6.456943000000001,-8.457089,6.80382', '-8.861252,6.456943000000001,-8.457089,6.80382', 100, 10000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'LiberiaLowerNimba', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:25:06.387', NULL, NULL, 'Mast:Towns_LowerNimba');
INSERT INTO la_spatialsource_layer VALUES (43, 'LiberiaMatroDistrict', 1, 3, 3, 2, NULL, NULL, 18, '-9.593999643,6.118729247,-9.411057576,6.200041665', '-9.593999643,6.118729247,-9.411057576,6.200041665', 100, 100000000, 'http://52.15.254.146/geoserver/wms?', NULL, 0, 'LiberiaMatroDistrict', NULL, NULL, true, false, false, false, false, false, false, NULL, true, true, 1, '2018-01-25 23:26:01.754', NULL, NULL, 'Mast:Towns_MatroKortro_District4');


SELECT pg_catalog.setval('la_spatialsource_layer_layerid_seq', 44, true);




INSERT INTO la_spatialsource_projectname VALUES (1, 'CB_Proj', 1, 4, 1, 11, 12, 2, '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004,-8.57657546620732,35.9042312577367,-7.83167176245347', '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', 'spatialUnitLand', 'spatialUnitLand', 'abc', 'CB_Proj', true, 1, '2018-01-26 00:00:00', 1, '2012-02-20 00:00:00', NULL);
INSERT INTO la_spatialsource_projectname VALUES (2, 'New Project', 1, 4, 2, 13, 14, 22, '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', '-11.485694999999907,4.3529159999999365,-7.365112999999894,8.55179000000004', 'spatialUnitLand', 'spatialUnitLand', 'abd', 'New Project', true, 1, '2018-01-30 00:00:00', 3, '2015-06-21 00:00:00', 1);


SELECT pg_catalog.setval('la_spatialsource_projectname_projectnameid_seq', 36, true);



SELECT pg_catalog.setval('la_spatialunit_aoi_aoiid_seq', 1, true);


SELECT pg_catalog.setval('la_spatialunit_land_landid_seq', 1, true);

SELECT pg_catalog.setval('la_spatialunit_resource_land_landid_seq', 1, true);






SELECT pg_catalog.setval('la_spatialunit_resource_line_landid_seq', 109, true);




SELECT pg_catalog.setval('la_spatialunit_resource_point_landid_seq', 1, true);




INSERT INTO la_spatialunitgroup VALUES (1, 'Country', 'Country', true);
INSERT INTO la_spatialunitgroup VALUES (2, 'Region', 'Region', true);
INSERT INTO la_spatialunitgroup VALUES (3, 'Province', 'Province', true);
INSERT INTO la_spatialunitgroup VALUES (4, 'Commune', 'Commune', true);
INSERT INTO la_spatialunitgroup VALUES (5, 'Place', 'Place', true);


INSERT INTO la_spatialunitgroup_hierarchy VALUES (3, 'Balé', 'Balé', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (9, 'Bagassi', 'Bagassi', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (10, 'Bana', 'Bana', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (11, 'Boromo', 'Boromo', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (12, 'Fara', 'Fara', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (13, 'Ouri', 'Ouri', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (14, 'Pa', 'Pa', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (2, 'Boucle du Mouhoun', 'Boucle du Mouhoun', 2, 1, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (4, 'Banwa', 'Banwa', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (56, 'Assio', 'Assio', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (57, 'Bagassi', 'Bagassi', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (58, 'Bandio', 'Bandio', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (59, 'Bounou', 'Bounou', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (60, 'Doussi', 'Doussi', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (61, 'Haho', 'Haho', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (62, 'Heredougou', 'Heredougou', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (63, 'Kahin', 'Kahin', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (64, 'Kaho', 'Kaho', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (65, 'Koussaro', 'Koussaro', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (66, 'Niaga', 'Niaga', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (67, 'Niakongo', 'Niakongo', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (68, 'Pahin', 'Pahin', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (69, 'Sipohin', 'Sipohin', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (70, 'Yaramoko', 'Yaramoko', 5, 9, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (71, 'Bassana', 'Bassana', 5, 10, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (72, 'Ouona', 'Ouona', 5, 10, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (73, 'Soma', 'Soma', 5, 10, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (74, 'Boromo    ', 'Boromo    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (75, 'Kalanbouli    ', 'Kalanbouli    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (76, 'Nanou    ', 'Nanou    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (77, 'Ouahabou    ', 'Ouahabou    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (78, 'Ouroubono    ', 'Ouroubono    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (79, 'Petit Balé    ', 'Petit Balé    ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (80, 'Virou ', 'Virou ', 5, 11, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (81, 'Bilatio', 'Bilatio', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (82, 'Bouzourou', 'Bouzourou', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (83, 'Daho', 'Daho', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (84, 'Fitien', 'Fitien', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (85, 'Kabourou', 'Kabourou', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (86, 'Kapa', 'Kapa', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (87, 'Karaba', 'Karaba', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (88, 'Konzena', 'Konzena', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (89, 'Koundi', 'Koundi', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (90, 'Laro', 'Laro', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (91, 'Nanano', 'Nanano', 5, 12, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (92, 'Lasso', 'Lasso', 5, 13, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (93, 'Oury', 'Oury', 5, 13, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (94, 'Seyou', 'Seyou', 5, 13, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (95, 'Siou', 'Siou', 5, 13, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (96, 'Soubouy', 'Soubouy', 5, 13, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (97, 'Boro', 'Boro', 5, 14, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (98, 'Pa', 'Pa', 5, 14, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (1, 'Burkina Faso', 'Burkina Faso', 1, NULL, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (5, 'Kossi', 'Kossi', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (6, 'Mouhoun', 'Mouhoun', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (7, 'Nayala', 'Nayala', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (8, 'Sourou', 'Sourou', 3, 2, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (15, 'Pompoi', 'Pompoi', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (16, 'Poura', 'Poura', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (17, 'Siby', 'Siby', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (18, 'Yaho', 'Yaho', 4, 3, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (19, 'Balavé', 'Balavé', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (20, 'Kouka', 'Kouka', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (21, 'Sami', 'Sami', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (22, 'Sanaba', 'Sanaba', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (23, 'Solenzo', 'Solenzo', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (24, 'Tansila', 'Tansila', 4, 4, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (25, 'Barani', 'Barani', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (26, 'Bomborokui', 'Bomborokui', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (27, 'Bourasso', 'Bourasso', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (28, 'Djibasso', 'Djibasso', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (29, 'Dokui', 'Dokui', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (30, 'Doumbala', 'Doumbala', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (31, 'Kombori', 'Kombori', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (32, 'Madouba', 'Madouba', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (33, 'Nouna', 'Nouna', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (34, 'Sono', 'Sono', 4, 5, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (35, 'Bondoukui', 'Bondoukui', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (36, 'Dédougou', 'Dédougou', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (37, 'Douroula', 'Douroula', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (38, 'Kona', 'Kona', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (39, 'Ouarkoye', 'Ouarkoye', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (40, 'Safane', 'Safane', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (41, 'Tchériba', 'Tchériba', 4, 6, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (42, 'Gassan', 'Gassan', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (43, 'Gossina', 'Gossina', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (44, 'Kougny', 'Kougny', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (45, 'Toma', 'Toma', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (46, 'Yaba', 'Yaba', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (47, 'Yé', 'Yé', 4, 7, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (48, 'Di', 'Di', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (49, 'Gomboro', 'Gomboro', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (50, 'Kassoum', 'Kassoum', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (51, 'Kiémbara', 'Kiémbara', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (52, 'Lanfiéra', 'Lanfiéra', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (53, 'Lankoué', 'Lankoué', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (54, 'Toéni', 'Toéni', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (55, 'Tougan', 'Tougan', 4, 8, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (99, 'Voho', 'Voho', 5, 14, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (100, 'Konkoliko', 'Konkoliko', 5, 15, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (101, 'Pompoi', 'Pompoi', 5, 15, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (102, 'San', 'San', 5, 15, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (103, 'Poura', 'Poura', 5, 16, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (104, 'Bitiako', 'Bitiako', 5, 17, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (105, 'Ouako', 'Ouako', 5, 17, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (106, 'Siby', 'Siby', 5, 17, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (107, 'Bondo', 'Bondo', 5, 18, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (108, 'Fobiri', 'Fobiri', 5, 18, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (109, 'Mamou', 'Mamou', 5, 18, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (110, 'Maoula', 'Maoula', 5, 18, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (111, 'Yaho', 'Yaho', 5, 18, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (112, 'Balawé', 'Balawé', 5, 19, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (113, 'Tangouna', 'Tangouna', 5, 19, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (114, 'Yasso', 'Yasso', 5, 19, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (115, 'Diontala', 'Diontala', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (116, 'Fini', 'Fini', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (117, 'Kotou', 'Kotou', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (118, 'Kouka', 'Kouka', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (119, 'Liaba', 'Liaba', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (120, 'Sama', 'Sama', 5, 20, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (121, 'Dima', 'Dima', 5, 21, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (122, 'Sami', 'Sami', 5, 21, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (123, 'Bendougou', 'Bendougou', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (124, 'Founa', 'Founa', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (125, 'Koba', 'Koba', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (126, 'Kossoba', 'Kossoba', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (127, 'Nemena', 'Nemena', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (128, 'Ouarakuy', 'Ouarakuy', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (129, 'Pekuy', 'Pekuy', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (130, 'Sanaba', 'Sanaba', 5, 22, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (131, 'Béna', 'Béna', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (132, 'Daboura', 'Daboura', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (133, 'Denkoro', 'Denkoro', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (134, 'Dira', 'Dira', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (135, 'Dissankuy', 'Dissankuy', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (136, 'Masso', 'Masso', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (137, 'Moussakongo', 'Moussakongo', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (138, 'Solenzo', 'Solenzo', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (139, 'Ben', 'Ben', 5, 23, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (140, 'Dema', 'Dema', 5, 24, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (141, 'Nangouna', 'Nangouna', 5, 24, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (142, 'Tansila', 'Tansila', 5, 24, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (143, 'Barani', 'Barani', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (144, 'Berma', 'Berma', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (145, 'Boulemporo', 'Boulemporo', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (146, 'Diallo', 'Diallo', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (147, 'Illa', 'Illa', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (148, 'Kolonkan Goure Ba', 'Kolonkan Goure Ba', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (149, 'Konkoro', 'Konkoro', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (150, 'Mantamou', 'Mantamou', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (151, 'Nabasso', 'Nabasso', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (152, 'Niako', 'Niako', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (153, 'Sisse', 'Sisse', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (154, 'Soudogo', 'Soudogo', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (155, 'Tira', 'Tira', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (156, 'Torokoto', 'Torokoto', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (157, 'Yalankoro', 'Yalankoro', 5, 25, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (158, 'Yallo', 'Yallo', 5, 26, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (159, 'Bagala', 'Bagala', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (160, 'Bourasso', 'Bourasso', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (161, 'Kerena', 'Kerena', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (162, 'Kodougou', 'Kodougou', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (163, 'Labarani', 'Labarani', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (164, 'Lemini', 'Lemini', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (165, 'Sikoro', 'Sikoro', 5, 27, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (166, 'Ba', 'Ba', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (167, 'Banana', 'Banana', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (168, 'Bokoro', 'Bokoro', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (169, 'Diena', 'Diena', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (170, 'Djibasso', 'Djibasso', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (171, 'Donkoro', 'Donkoro', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (172, 'Ira', 'Ira', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (173, 'Kolonzo', 'Kolonzo', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (174, 'Senoulo', 'Senoulo', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (175, 'Voro', 'Voro', 5, 28, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (176, 'Ayoubakolon', 'Ayoubakolon', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (177, 'Dokuy', 'Dokuy', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (178, 'Goni', 'Goni', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (179, 'Karasso', 'Karasso', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (180, 'Nereko', 'Nereko', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (181, 'Toni', 'Toni', 5, 29, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (182, 'Doumbala', 'Doumbala', 5, 30, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (183, 'Kini-Kini', 'Kini-Kini', 5, 30, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (184, 'Teni', 'Teni', 5, 30, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (185, 'Wa', 'Wa', 5, 30, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (186, 'Lonani', 'Lonani', 5, 31, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (187, 'Sanakadougou', 'Sanakadougou', 5, 31, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (188, 'Siekoro', 'Siekoro', 5, 31, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (189, 'Siewali', 'Siewali', 5, 31, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (190, 'Kolokan', 'Kolokan', 5, 32, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (191, 'Yourouna', 'Yourouna', 5, 32, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (192, 'Bisso', 'Bisso', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (193, 'Damandigui', 'Damandigui', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (194, 'Dara', 'Dara', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (195, 'Dembo', 'Dembo', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (196, 'Dina', 'Dina', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (197, 'Diondougou', 'Diondougou', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (198, 'Karekuy', 'Karekuy', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (199, 'Konankoira', 'Konankoira', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (200, 'Lei', 'Lei', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (201, 'Mourdie', 'Mourdie', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (202, 'Nouna', 'Nouna', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (203, 'Seriba', 'Seriba', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (204, 'Sobon', 'Sobon', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (205, 'Soin', 'Soin', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (206, 'Tenou', 'Tenou', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (207, 'Tonkoroni', 'Tonkoroni', 5, 33, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (208, 'Sono', 'Sono', 5, 34, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (209, 'Bondoukuy', 'Bondoukuy', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (210, 'Dampan', 'Dampan', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (211, 'Kera', 'Kera', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (212, 'Koumana', 'Koumana', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (213, 'Ouakara', 'Ouakara', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (214, 'Syn bekuy', 'Syn bekuy', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (215, 'Tankuy', 'Tankuy', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (216, 'Tia', 'Tia', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (217, 'Toun', 'Toun', 5, 35, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (218, 'Apirikiti', 'Apirikiti', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (219, 'Dedougou', 'Dedougou', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (220, 'Fakouna', 'Fakouna', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (221, 'Kamanbera', 'Kamanbera', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (222, 'Kamandena', 'Kamandena', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (223, 'Kari', 'Kari', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (224, 'Kassakongo', 'Kassakongo', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (225, 'Koran', 'Koran', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (226, 'Kore', 'Kore', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (227, 'Koukatenga', 'Koukatenga', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (228, 'Massala', 'Massala', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (229, 'Oulani', 'Oulani', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (230, 'Parade', 'Parade', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (231, 'Passakongo', 'Passakongo', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (232, 'Sagala', 'Sagala', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (233, 'Soukuy', 'Soukuy', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (234, 'Souri', 'Souri', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (235, 'Wetina', 'Wetina', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (236, 'Zakuy', 'Zakuy', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (237, 'Zeoula', 'Zeoula', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (238, 'Zeoule', 'Zeoule', 5, 36, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (239, 'Douroula', 'Douroula', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (240, 'Kankono', 'Kankono', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (241, 'Karo', 'Karo', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (242, 'Kirikongo', 'Kirikongo', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (243, 'Sa', 'Sa', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (244, 'Toroba', 'Toroba', 5, 37, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (245, 'Dangouna', 'Dangouna', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (246, 'Goulo', 'Goulo', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (247, 'Kona', 'Kona', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (248, 'Lah', 'Lah', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (249, 'Nana', 'Nana', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (250, 'Sanfle', 'Sanfle', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (251, 'Tona', 'Tona', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (252, 'Yoana', 'Yoana', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (253, 'Zina', 'Zina', 5, 38, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (254, 'Bekuy', 'Bekuy', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (255, 'Darou', 'Darou', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (256, 'Fakena', 'Fakena', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (257, 'Kamako', 'Kamako', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (258, 'Kekaba', 'Kekaba', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (259, 'Kosso', 'Kosso', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (260, 'Lokinde', 'Lokinde', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (261, 'Miana', 'Miana', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (262, 'Monkuy', 'Monkuy', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (263, 'Ouarkoy', 'Ouarkoy', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (264, 'Oubli du E', 'Oubli du E', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (265, 'Poundou', 'Poundou', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (266, 'Soana', 'Soana', 5, 39, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (267, 'Biforo', 'Biforo', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (268, 'Bilakongo', 'Bilakongo', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (269, 'Bossien', 'Bossien', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (270, 'Datomo', 'Datomo', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (271, 'Kira', 'Kira', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (272, 'Kokoun', 'Kokoun', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (273, 'Kongosso', 'Kongosso', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (274, 'Makongo', 'Makongo', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (275, 'Nounou', 'Nounou', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (276, 'Pakoro', 'Pakoro', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (277, 'Safane', 'Safane', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (278, 'Sikorosso', 'Sikorosso', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (279, 'Sirakorosso', 'Sirakorosso', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (280, 'Sodien', 'Sodien', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (281, 'Tiekuy', 'Tiekuy', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (282, 'Yamou', 'Yamou', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (283, 'Yankasso', 'Yankasso', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (284, 'Yankoro', 'Yankoro', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (285, 'Ziasso', 'Ziasso', 5, 40, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (286, 'Bissanderou', 'Bissanderou', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (287, 'Douroukou', 'Douroukou', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (288, 'Labien', 'Labien', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (289, 'Saho', 'Saho', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (290, 'Tigan', 'Tigan', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (291, 'Tikan', 'Tikan', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (292, 'Youlou', 'Youlou', 5, 41, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (293, 'Djimbara', 'Djimbara', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (294, 'Gassan', 'Gassan', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (295, 'Soni', 'Soni', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (296, 'Soroni', 'Soroni', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (297, 'Toubani', 'Toubani', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (298, 'Warou', 'Warou', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (299, 'Zaba', 'Zaba', 5, 42, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (300, 'Boun', 'Boun', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (301, 'Gossina', 'Gossina', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (302, 'Kalabo', 'Kalabo', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (303, 'Koayo', 'Koayo', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (304, 'Kwon', 'Kwon', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (305, 'Madamao', 'Madamao', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (306, 'Massako', 'Massako', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (307, 'Naboro', 'Naboro', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (308, 'Sui', 'Sui', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (309, 'Tandou', 'Tandou', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (310, 'Youloupo', 'Youloupo', 5, 43, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (311, 'Goin', 'Goin', 5, 44, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (312, 'Kamba', 'Kamba', 5, 44, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (313, 'Kibiri', 'Kibiri', 5, 44, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (314, 'Nimina', 'Nimina', 5, 44, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (315, 'Goa', 'Goa', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (316, 'Koin', 'Koin', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (317, 'Nyon', 'Nyon', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (318, 'Raotenga', 'Raotenga', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (319, 'Sawa', 'Sawa', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (320, 'Semba', 'Semba', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (321, 'Toma', 'Toma', 5, 45, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (322, 'Biba', 'Biba', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (323, 'Biena', 'Biena', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (324, 'Logue', 'Logue', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (325, 'Pangogo', 'Pangogo', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (326, 'Sapala', 'Sapala', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (327, 'Saran', 'Saran', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (328, 'Siena', 'Siena', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (329, 'Tiema', 'Tiema', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (330, 'Toba', 'Toba', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (331, 'Yaba', 'Yaba', 5, 46, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (332, 'Goersa', 'Goersa', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (333, 'Massala', 'Massala', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (334, 'Niempourou', 'Niempourou', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (335, 'Saoura', 'Saoura', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (336, 'Touri', 'Touri', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (337, 'Yé', 'Yé', 5, 47, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (338, 'Debe', 'Debe', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (339, 'Di', 'Di', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (340, 'Donon', 'Donon', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (341, 'Niassan', 'Niassan', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (342, 'Niassari', 'Niassari', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (343, 'Poro', 'Poro', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (344, 'Tourou', 'Tourou', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (345, 'Touroukoro', 'Touroukoro', 5, 48, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (346, 'Bambara', 'Bambara', 5, 49, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (347, 'Gala', 'Gala', 5, 49, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (348, 'Gomboro', 'Gomboro', 5, 49, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (349, 'Bao', 'Bao', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (350, 'Bonro', 'Bonro', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (351, 'Dianra', 'Dianra', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (352, 'Douban', 'Douban', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (353, 'Doussoula', 'Doussoula', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (354, 'Kassoum', 'Kassoum', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (355, 'Kourani', 'Kourani', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (356, 'Pini', 'Pini', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (357, 'Sorona', 'Sorona', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (358, 'Soumarani', 'Soumarani', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (359, 'Tianra', 'Tianra', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (360, 'Tiao', 'Tiao', 5, 50, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (361, 'Gan', 'Gan', 5, 51, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (362, 'Kiembara', 'Kiembara', 5, 51, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (363, 'Kirio', 'Kirio', 5, 51, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (364, 'Niassono', 'Niassono', 5, 51, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (365, 'Bissan', 'Bissan', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (366, 'Gouran', 'Gouran', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (367, 'Kamina', 'Kamina', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (368, 'Kamona', 'Kamona', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (369, 'Lanfiera', 'Lanfiera', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (370, 'Toumani', 'Toumani', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (371, 'Unknown', 'Unknown', 5, 52, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (372, 'Lankoué', 'Lankoué', 5, 53, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (373, 'Dagale', 'Dagale', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (374, 'Domoni', 'Domoni', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (375, 'Dounkou', 'Dounkou', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (376, 'Ganagoulo', 'Ganagoulo', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (377, 'Gome', 'Gome', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (378, 'Loroni', 'Loroni', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (379, 'Louta', 'Louta', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (380, 'Nehourou', 'Nehourou', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (381, 'Seme', 'Seme', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (382, 'Sindie', 'Sindie', 5, 54, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (383, 'Boussoum', 'Boussoum', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (384, 'Daka', 'Daka', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (385, 'Diouroum', 'Diouroum', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (386, 'Dissi', 'Dissi', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (387, 'Gorombouli', 'Gorombouli', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (388, 'Goron', 'Goron', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (389, 'Gosson', 'Gosson', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (390, 'Kassan', 'Kassan', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (391, 'Kouy', 'Kouy', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (392, 'Largogo', 'Largogo', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (393, 'Nassan', 'Nassan', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (394, 'Niankore', 'Niankore', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (395, 'Rabouglitenga', 'Rabouglitenga', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (396, 'Tougan', 'Tougan', 5, 55, true);
INSERT INTO la_spatialunitgroup_hierarchy VALUES (397, 'Toungare', 'Toungare', 5, 55, true);



SELECT pg_catalog.setval('la_spatialunitgroup_hierarchy_hierarchyid_seq', 1, false);



SELECT pg_catalog.setval('la_spatialunitgroup_spatialunitgroupid_seq', 5, true);



SELECT pg_catalog.setval('la_surrenderlease_leaseid_seq', 1, false);




ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT la_ext_resource_custom_attribute_pkey PRIMARY KEY (customattributeid);


ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT la_ext_resource_custom_attributevalue_pkey PRIMARY KEY (customattributevalueid);



ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_pkey PRIMARY KEY (documentid);




ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT la_ext_resourceattributevalue_pkey PRIMARY KEY (attributevalueid);



ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT la_ext_resourcelandclassificationmapping_pkey PRIMARY KEY (landclassmappingid);



ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT la_ext_resourcepoiattributevalue_pkey PRIMARY KEY (poiattributevalueid);



ALTER TABLE ONLY la_ext_workflowdef
    ADD CONSTRAINT la_ext_workflowdef_pkey PRIMARY KEY (workflowdefid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT la_spatialunit_resource_land_pkey PRIMARY KEY (landid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT la_spatialunit_resource_line_pkey PRIMARY KEY (landid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT la_spatialunit_resource_point_pkey PRIMARY KEY (landid);



ALTER TABLE ONLY la_spatialunit_aoi
    ADD CONSTRAINT pk_aoiid PRIMARY KEY (aoiid);



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



ALTER TABLE ONLY la_ext_categorytype
    ADD CONSTRAINT pk_la_ext_categorytype PRIMARY KEY (categorytypeid);



ALTER TABLE ONLY la_ext_customattributeoptions
    ADD CONSTRAINT pk_la_ext_customattributeoptions PRIMARY KEY (attributeoptionsid);




ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT pk_la_ext_disputeid PRIMARY KEY (disputeid);



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



ALTER TABLE ONLY la_ext_existingclaim_documentdetails
    ADD CONSTRAINT pk_la_ext_existingclaim_documentdetails PRIMARY KEY (claimdocumentid);



ALTER TABLE ONLY la_ext_financialagency
    ADD CONSTRAINT pk_la_ext_financialagency PRIMARY KEY (financialagencyid);




ALTER TABLE ONLY la_ext_geometrytype
    ADD CONSTRAINT pk_la_ext_geometrytype PRIMARY KEY (geometrytypeid);



ALTER TABLE ONLY la_ext_grouptype
    ADD CONSTRAINT pk_la_ext_grouptype PRIMARY KEY (grouptypeid);


ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT pk_la_ext_landworkflowhistory PRIMARY KEY (landworkflowhistoryid);



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




ALTER TABLE ONLY la_ext_month
    ADD CONSTRAINT pk_la_ext_month PRIMARY KEY (monthid);



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




ALTER TABLE ONLY la_ext_resourceclassification
    ADD CONSTRAINT pk_la_ext_resourceclassification PRIMARY KEY (classificationid);




ALTER TABLE ONLY la_ext_resourcepoiattributemaster
    ADD CONSTRAINT pk_la_ext_resourcepoiattributemaster PRIMARY KEY (poiattributemasterid);




ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT pk_la_ext_resourcesubclassification PRIMARY KEY (subclassificationid);



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



-- TOC entry 4246 (class 2606 OID 212485)
-- Name: pk_la_ext_userprojectmapping; Type: CONSTRAINT; Schema: public; Owner: postgre

ALTER TABLE ONLY la_ext_userprojectmapping
    ADD CONSTRAINT pk_la_ext_userprojectmapping PRIMARY KEY (userprojectid);



-- TOC entry 4248 (class 2606 OID 212487)
-- Name: pk_la_ext_userrolemapping; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY la_ext_userrolemapping
    ADD CONSTRAINT pk_la_ext_userrolemapping PRIMARY KEY (userroleid);




ALTER TABLE ONLY la_ext_workflow
    ADD CONSTRAINT pk_la_ext_workflow PRIMARY KEY (workflowid);




ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT pk_la_ext_workflowactionmapping PRIMARY KEY (workflowactionid);


ALTER TABLE ONLY la_lease
    ADD CONSTRAINT pk_la_lease PRIMARY KEY (leaseid);



ALTER TABLE ONLY la_mortgage
    ADD CONSTRAINT pk_la_mortgage PRIMARY KEY (mortgageid);


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




ALTER TABLE ONLY la_surrenderlease
    ADD CONSTRAINT pk_la_surrenderlease PRIMARY KEY (leaseid);



ALTER TABLE ONLY la_layer
    ADD CONSTRAINT pk_layer PRIMARY KEY (alias);




ALTER TABLE ONLY la_ext_spatialunit_personwithinterest
    ADD CONSTRAINT spatialunit_personwithinterest_pk PRIMARY KEY (id);




CREATE UNIQUE INDEX "PK_Layer" ON la_layer USING btree (alias);

ALTER TABLE la_layer CLUSTER ON "PK_Layer";



ALTER TABLE ONLY la_ext_attribute
    ADD CONSTRAINT fk_la_ext_attribute_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);



ALTER TABLE ONLY la_ext_attributecategory
    ADD CONSTRAINT fk_la_ext_attributecategory_categorytypeid FOREIGN KEY (categorytypeid) REFERENCES la_ext_categorytype(categorytypeid);




ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);




ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT fk_la_ext_attributemaster_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);



ALTER TABLE ONLY la_ext_attributemaster
    ADD CONSTRAINT fk_la_ext_attributemaster_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);



ALTER TABLE ONLY la_ext_attributeoptions
    ADD CONSTRAINT fk_la_ext_attributeoptions_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_attributemaster(attributemasterid);



ALTER TABLE ONLY la_ext_bookmark
    ADD CONSTRAINT fk_la_ext_bookmark_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_ext_customattributeoptions
    ADD CONSTRAINT fk_la_ext_customattributeoptions_customattributeid FOREIGN KEY (customattributeid) REFERENCES la_ext_resource_custom_attribute(customattributeid);




ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputeid FOREIGN KEY (disputeid) REFERENCES la_ext_dispute(disputeid);




ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_disputelandmapping_disputetypeid FOREIGN KEY (disputetypeid) REFERENCES la_ext_disputetype(disputetypeid);




ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);



ALTER TABLE ONLY la_ext_spatialunit_personwithinterest
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);




ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_disputelandmapping_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);




ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_partyid FOREIGN KEY (partyid) REFERENCES la_party(partyid);




ALTER TABLE ONLY la_ext_disputelandmapping
    ADD CONSTRAINT fk_la_ext_disputelandmapping_persontypeid FOREIGN KEY (persontypeid) REFERENCES la_partygroup_persontype(persontypeid);



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


ALTER TABLE ONLY la_ext_existingclaim_documentdetails
    ADD CONSTRAINT fk_la_ext_existingclaim_documentdetails_landid FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);



ALTER TABLE ONLY la_ext_dispute
    ADD CONSTRAINT fk_la_ext_la_ext_disputestatus FOREIGN KEY (disputestatusid) REFERENCES la_ext_disputestatus(disputestatusid);




ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT fk_la_ext_landworkflowhistory_applicationstatusid FOREIGN KEY (applicationstatusid) REFERENCES la_ext_applicationstatus(applicationstatusid);



ALTER TABLE ONLY la_ext_landworkflowhistory
    ADD CONSTRAINT fk_la_ext_landworkflowhistory_land FOREIGN KEY (landid) REFERENCES la_spatialunit_land(landid);



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



ALTER TABLE ONLY la_ext_disputelandmapping
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




ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_attributecategoryid FOREIGN KEY (attributecategoryid) REFERENCES la_ext_attributecategory(attributecategoryid);


ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_customattributeid FOREIGN KEY (customattributeid) REFERENCES la_ext_resource_custom_attribute(customattributeid);




ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);



ALTER TABLE ONLY la_ext_resource_custom_attribute
    ADD CONSTRAINT fk_la_ext_resource_custom_attribute_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_ext_resource_custom_attributevalue
    ADD CONSTRAINT fk_la_ext_resource_custom_attributevalue_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_classificationid FOREIGN KEY (classificationid) REFERENCES la_ext_resourceclassification(classificationid);


ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_landclassmappingid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_ext_resourcelandclassificationmapping
    ADD CONSTRAINT fk_la_ext_resourcelandclassificationmapping_subclassificationid FOREIGN KEY (subclassificationid) REFERENCES la_ext_resourcesubclassification(subclassificationid);




ALTER TABLE ONLY la_ext_resourcepoiattributemaster
    ADD CONSTRAINT fk_la_ext_resourcepoiattributemaster_datatypemasterid FOREIGN KEY (datatypemasterid) REFERENCES la_ext_attributedatatype(datatypemasterid);




ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT fk_la_ext_resourcepoiattributevalue_attributemasterid FOREIGN KEY (attributemasterid) REFERENCES la_ext_resourcepoiattributemaster(poiattributemasterid);




ALTER TABLE ONLY la_ext_resourcepoiattributevalue
    ADD CONSTRAINT fk_la_ext_resourcepoiattributevalue_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);


ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT fk_la_ext_resourcesubclassification_classificationid FOREIGN KEY (classificationid) REFERENCES la_ext_resourceclassification(classificationid);



ALTER TABLE ONLY la_ext_resourcesubclassification
    ADD CONSTRAINT fk_la_ext_resourcesubclassification_geometrytypeid FOREIGN KEY (geometrytypeid) REFERENCES la_ext_geometrytype(geometrytypeid);



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
    ADD CONSTRAINT fk_la_ext_transactiondetails_processid FOREIGN KEY (processid) REFERENCES la_ext_process(processid);



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



ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT fk_la_ext_workflow FOREIGN KEY (workflowid) REFERENCES la_ext_workflow(workflowid);




ALTER TABLE ONLY la_ext_workflow
    ADD CONSTRAINT fk_la_ext_workflow_workflowdefid FOREIGN KEY (workflowdefid) REFERENCES la_ext_workflowdef(workflowdefid);


ALTER TABLE ONLY la_ext_workflowactionmapping
    ADD CONSTRAINT fk_la_ext_workflowactionmapping_workflowid FOREIGN KEY (workflowid) REFERENCES la_ext_workflow(workflowid);




ALTER TABLE ONLY la_lease
    ADD CONSTRAINT fk_la_lease_monthid FOREIGN KEY (monthid) REFERENCES la_ext_month(monthid);



ALTER TABLE ONLY la_surrenderlease
    ADD CONSTRAINT fk_la_lease_monthid FOREIGN KEY (monthid) REFERENCES la_ext_month(monthid);




ALTER TABLE ONLY la_mortgage
    ADD CONSTRAINT fk_la_mortgage_mortgageid FOREIGN KEY (financialagencyid) REFERENCES la_ext_financialagency(financialagencyid);




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



ALTER TABLE ONLY la_ext_resourceattributevalue
    ADD CONSTRAINT fk_la_spatialsource_projectname_projectid FOREIGN KEY (projectid) REFERENCES la_spatialsource_projectname(projectnameid);




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
    ADD CONSTRAINT fk_la_spatialunit_land_proposedused FOREIGN KEY (proposedused) REFERENCES la_baunit_landusetype(landusetypeid);



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



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);


ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);

ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);



ALTER TABLE ONLY la_spatialunit_resource_land
    ADD CONSTRAINT fk_la_spatialunit_resource_land_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);


ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);

ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);


ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);



ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);




ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_line_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);


ALTER TABLE ONLY la_spatialunit_resource_line
    ADD CONSTRAINT fk_la_spatialunit_resource_point_acquisitiontypeid FOREIGN KEY (acquisitiontypeid) REFERENCES la_right_acquisitiontype(acquisitiontypeid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_claimtypeid FOREIGN KEY (claimtypeid) REFERENCES la_right_claimtype(claimtypeid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid1 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid2 FOREIGN KEY (hierarchyid2) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid3 FOREIGN KEY (hierarchyid3) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid4 FOREIGN KEY (hierarchyid4) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid5 FOREIGN KEY (hierarchyid5) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_hierarchyid6 FOREIGN KEY (hierarchyid1) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_landsharetypeid FOREIGN KEY (landsharetypeid) REFERENCES la_right_landsharetype(landsharetypeid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_landsoilqualityid FOREIGN KEY (landsoilqualityid) REFERENCES la_baunit_landsoilquality(landsoilqualityid);


ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_landtypeid FOREIGN KEY (landtypeid) REFERENCES la_baunit_landtype(landtypeid);


ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_landusetypeid FOREIGN KEY (landusetypeid) REFERENCES la_baunit_landusetype(landusetypeid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_projectnameid FOREIGN KEY (projectnameid) REFERENCES la_spatialsource_projectname(projectnameid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_slopevalueid FOREIGN KEY (slopevalueid) REFERENCES la_ext_slopevalue(slopevalueid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid1 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);



ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid2 FOREIGN KEY (spatialunitgroupid2) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid3 FOREIGN KEY (spatialunitgroupid3) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid4 FOREIGN KEY (spatialunitgroupid4) REFERENCES la_spatialunitgroup(spatialunitgroupid);


ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid5 FOREIGN KEY (spatialunitgroupid5) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_spatialunitgroupid6 FOREIGN KEY (spatialunitgroupid1) REFERENCES la_spatialunitgroup(spatialunitgroupid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_tenureclassid FOREIGN KEY (tenureclassid) REFERENCES la_right_tenureclass(tenureclassid);




ALTER TABLE ONLY la_spatialunit_resource_point
    ADD CONSTRAINT fk_la_spatialunit_resource_point_unitid FOREIGN KEY (unitid) REFERENCES la_ext_unit(unitid);




ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT fk_la_spatialunitgroup_hierarchy_spatialunitgroupid FOREIGN KEY (spatialunitgroupid) REFERENCES la_spatialunitgroup(spatialunitgroupid);



ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_documentformatid_fkey FOREIGN KEY (documentformatid) REFERENCES la_ext_documentformat(documentformatid);


ALTER TABLE ONLY la_ext_resource_documentdetails
    ADD CONSTRAINT la_ext_resource_documentdetails_documenttypeid_fkey FOREIGN KEY (documenttypeid) REFERENCES la_ext_documenttype(documenttypeid);




ALTER TABLE ONLY la_spatialunitgroup_hierarchy
    ADD CONSTRAINT la_spatialunitgroup_hierarchy_uperhierarchy FOREIGN KEY (hierarchyid) REFERENCES la_spatialunitgroup_hierarchy(hierarchyid);



