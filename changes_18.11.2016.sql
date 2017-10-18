-- land use
ALTER TABLE public.land_use_type
 ADD COLUMN active boolean NOT NULL DEFAULT true;
COMMENT ON COLUMN public.land_use_type.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';

-- Marital status
update marital_status set maritalstatus_sw = 'talaka', maritalstatus='divorced' where maritalstatus_id=3;

update public.land_use_type set land_use_type = 'Forestry', land_use_type_sw = 'Hifadhi ya Misitu' where use_type_id = 2;
update public.land_use_type set land_use_type = 'Residential', land_use_type_sw = 'Makazi' where use_type_id = 3;
update public.land_use_type set land_use_type = 'Grazing', land_use_type_sw = 'Malisho' where use_type_id = 4;
insert into public.land_use_type (use_type_id, land_use_type, land_use_type_sw) values (15, 'Residential and agricultural', 'Makazi na kilimo');
insert into public.land_use_type (use_type_id, land_use_type, land_use_type_sw) values (16, 'Wildlife/Tourism', 'Hifadhi za wanyama na Utalii');
insert into public.land_use_type (use_type_id, land_use_type, land_use_type_sw) values (17, 'Social services', 'Huduma za jamii');
insert into public.land_use_type (use_type_id, land_use_type, land_use_type_sw) values (18, 'Mining', 'Maeneo ya madini');
update public.land_use_type set active = 'f' where use_type_id in (5,6,7,13);

-- Share type
update share_type set share_type = 'Co-occupancy (Tenancy in Common)', share_type_sw = 'Milki ya pamoja kwa Hisa' where gid = 1;
update share_type set share_type = 'Single Occupant', share_type_sw = 'Milki ya mmoja' where gid = 2;
update share_type set share_type = 'Co-occupancy (Joint tenancy)', share_type_sw = 'Milki ya pamoja isiyogawanyika' where gid = 3;
update share_type set share_type = 'Probate Administration', share_type_sw = 'Milki chini ya usimamizi wa Mirathi' where gid = 4;
update share_type set share_type = 'Guardian(Minor)', share_type_sw = 'Milki chini ya Mlezi' where gid = 5;
update share_type set share_type = 'Non-Natural/Institution', share_type_sw = 'Taasisi/Kampuni/Asasi' where gid = 6;


-- spatial unit status
update public.sunit_status set workflow_status = 'Denied' where workflow_status_id = 5;
update public.sunit_status set workflow_status = 'Validated' where workflow_status_id = 3;
update public.sunit_status set workflow_status = 'Referred to VC/VLC' where workflow_status_id = 4;
update public.sunit_status set workflow_status = 'Approved' where workflow_status_id = 2;
update public.sunit_workflow_status_history set workflow_status_id = 2 where workflow_status_id = 6;
update public.sunit_workflow_status_history set workflow_status_id = 2 where workflow_status_id = 7;
update public.sunit_workflow_status_history set workflow_status_id = 3 where workflow_status_id = 4;

update public.spatial_unit set current_workflow_status_id = 2 where current_workflow_status_id = 6;
update public.spatial_unit set current_workflow_status_id = 2 where current_workflow_status_id = 7;
update public.spatial_unit set current_workflow_status_id = 3 where current_workflow_status_id = 4;

delete from public.sunit_status where workflow_status_id in (6,7);

-- hamlet
ALTER TABLE public.project_hamlets
  ADD COLUMN hamlet_leader_name character varying(500);
COMMENT ON COLUMN public.project_hamlets.hamlet_leader_name IS 'Hamlet leader name(s)';

UPDATE public.project_hamlets SET hamlet_leader_name = '';
UPDATE project_region SET district_name='Iringa (Rural)' WHERE district_name='Iringa (Rural)';

-- ref data
CREATE TABLE public.claim_type
(
   code character varying(20) NOT NULL, 
   name character varying(200) NOT NULL, 
   name_other_lang character varying(200), 
   active boolean NOT NULL DEFAULT 't', 
   CONSTRAINT code_pk PRIMARY KEY (code)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.claim_type.code IS 'Claim type code - primary key';
COMMENT ON COLUMN public.claim_type.name IS 'Claim type name';
COMMENT ON COLUMN public.claim_type.name_other_lang IS 'Claim type name in other language';
COMMENT ON COLUMN public.claim_type.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';
COMMENT ON TABLE public.claim_type
  IS 'Reference data table for claim types';

INSERT INTO public.claim_type (code, name, name_other_lang, active) VALUES ('newClaim', 'New claim', 'Maombi Mapya', 't');
INSERT INTO public.claim_type (code, name, name_other_lang, active) VALUES ('existingClaim', 'Existing right', 'Eneo lenye Hati', 't');
INSERT INTO public.claim_type (code, name, name_other_lang, active) VALUES ('unclaimed', 'Unclaimed', 'Eneo ambalo halina taarifa', 't');
INSERT INTO public.claim_type (code, name, name_other_lang, active) VALUES ('dispute', 'Disputed claim', 'Eneo lenye mgogoro', 't');

ALTER TABLE public.tenure_class ADD COLUMN for_adjudication boolean DEFAULT 't';
ALTER TABLE public.tenure_class ADD COLUMN tenure_class_sw character varying;
COMMENT ON COLUMN public.tenure_class.for_adjudication IS 'Indicates whether type right should be processed through adjudication process.';
COMMENT ON COLUMN public.tenure_class.tenure_class_sw IS 'Name of tenure class in Swahili';

UPDATE public.tenure_class SET for_adjudication = 'f';
UPDATE public.tenure_class SET for_adjudication = 't' WHERE tenureclass_id = 2;
UPDATE public.tenure_class SET tenure_class = 'Cerificate of Occupany', tenure_class_sw = 'Hati ya Hatimiliki', active = 't', for_adjudication = 'f' WHERE tenureclass_id = 3;
UPDATE public.tenure_class SET tenure_class_sw = 'Hati ya Hakimiliki ya Kimila' WHERE tenureclass_id = 2;

CREATE TABLE public.acquisition_type
(
  code integer NOT NULL, -- Acquisition type code - primary key.
  name character varying(200) NOT NULL, -- Acquisition type name.
  name_other_lang character varying(200), -- Acquisition type name in other language.
  active boolean NOT NULL DEFAULT true, -- Boolean flag indicating whether the record is active and can be used for displaying on the forms.
  CONSTRAINT pk_code PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.acquisition_type
  OWNER TO postgres;
COMMENT ON TABLE public.acquisition_type
  IS 'Reference data table listing different type of land acquisition.';
COMMENT ON COLUMN public.acquisition_type.code IS 'Acquisition type code - primary key.';
COMMENT ON COLUMN public.acquisition_type.name IS 'Acquisition type name.';
COMMENT ON COLUMN public.acquisition_type.name_other_lang IS 'Acquisition type name in other language.';
COMMENT ON COLUMN public.acquisition_type.active IS 'Boolean flag indicating whether the record is active and can be used for displaying on the forms.';

INSERT INTO public.acquisition_type(code, name, name_other_lang, active) VALUES (1, 'Allocated by Village Council', 'Kupewa na Halmashauri ya Kijiji', 't');
INSERT INTO public.acquisition_type(code, name, name_other_lang, active) VALUES (2, 'Gift', 'Zawadi', 't');
INSERT INTO public.acquisition_type(code, name, name_other_lang, active) VALUES (3, 'Inheritance', 'Urithi', 't');
INSERT INTO public.acquisition_type(code, name, name_other_lang, active) VALUES (4, 'Purchase', 'Kununua', 't');

-- Spatial unit

ALTER TABLE public.spatial_unit ADD COLUMN claim_type character varying(20);
ALTER TABLE public.spatial_unit ADD COLUMN polygon_number character varying(20);

ALTER TABLE public.spatial_unit ADD CONSTRAINT fk_claim_type_code FOREIGN KEY (claim_type) REFERENCES public.claim_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN public.spatial_unit.claim_type IS 'Claim type code';
COMMENT ON COLUMN public.spatial_unit.polygon_number IS 'Polygon number assigned in the field manually. This value is supposed to be unique per village.';

UPDATE public.spatial_unit SET claim_type = 'newClaim';

ALTER TABLE public.spatial_unit ALTER COLUMN claim_type SET DEFAULT 'newClaim';
ALTER TABLE public.spatial_unit ALTER COLUMN claim_type SET NOT NULL;

ALTER TABLE public.spatial_unit_tmp ADD COLUMN claim_type character varying(20);
ALTER TABLE public.spatial_unit_tmp ADD COLUMN polygon_number character varying(20);

ALTER TABLE public.spatial_unit_tmp ADD CONSTRAINT fk_claim_type_code FOREIGN KEY (claim_type) REFERENCES public.claim_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN public.spatial_unit_tmp.claim_type IS 'Claim type code';
COMMENT ON COLUMN public.spatial_unit_tmp.polygon_number IS 'Polygon number assigned in the field manually. This value is supposed to be unique per village.';

CREATE TABLE public.id_type
(
   code integer NOT NULL, 
   name character varying(200) NOT NULL, 
   name_other_lang character varying(200), 
   active boolean NOT NULL DEFAULT 't', 
   CONSTRAINT id_type_pk_code PRIMARY KEY (code)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.id_type.code IS 'ID type code - primary key';
COMMENT ON COLUMN public.id_type.name IS 'ID type name';
COMMENT ON COLUMN public.id_type.name_other_lang IS 'ID type name in other language';
COMMENT ON COLUMN public.id_type.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';
COMMENT ON TABLE public.id_type
  IS 'Reference data table for ID types';

INSERT INTO public.id_type (code, name, name_other_lang, active) VALUES (1, 'Voter ID', 'Kitambulisho cha mpiga kura', 't');
INSERT INTO public.id_type (code, name, name_other_lang, active) VALUES (2, 'Driving license', 'Leseni ya udereva', 't');
INSERT INTO public.id_type (code, name, name_other_lang, active) VALUES (3, 'Passport', 'Pasi ya kusafiria', 't');
INSERT INTO public.id_type (code, name, name_other_lang, active) VALUES (4, 'ID card', 'Kitambulisho cha Mkazi', 't');
INSERT INTO public.id_type (code, name, name_other_lang, active) VALUES (5, 'Other', 'Nyingine', 't');

-- Person
CREATE TABLE public.relationship_type
(
  code integer NOT NULL, -- Relationship type code - primary key.
  name character varying(200) NOT NULL, -- Relationship type name.
  name_other_lang character varying(200), -- Relationship type name in other language.
  active boolean NOT NULL DEFAULT true, -- Boolean flag indicating whether the record is active and can be used for displaying on the forms.
  CONSTRAINT relationship_type_pk_code PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.relationship_type
  OWNER TO postgres;
COMMENT ON TABLE public.relationship_type
  IS 'Reference data table listing relationship types between persons.';
COMMENT ON COLUMN public.relationship_type.code IS 'Relationship type code - primary key.';
COMMENT ON COLUMN public.relationship_type.name IS 'Relationship type name.';
COMMENT ON COLUMN public.relationship_type.name_other_lang IS 'Relationship type name in other language.';
COMMENT ON COLUMN public.relationship_type.active IS 'Boolean flag indicating whether the record is active and can be used for displaying on the forms.';

INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (1, 'Father', 'Baba', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (2, 'Mother', 'Mama', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (3, 'Sister', 'Dada', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (4, 'Brother', 'Kaka', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (5, 'Son', 'Mwana', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (6, 'Daughter', 'Binti', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (7, 'Grandmother', 'Bibi', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (8, 'Grandfather', 'Babu', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (9, 'Grandson', 'Mjukuu', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (10, 'Granddaughter', 'Mjukuu', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (11, 'Uncle', 'Mjomba', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (12, 'Aunt', 'Shangazi', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (13, 'Niece', 'Mpwa', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (14, 'Nephew', 'Mpwa', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (15, 'Other relatives', 'Ndugu wengine', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (16, 'Partners', 'Washirika', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (17, 'Other', 'Nyingine', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (18, 'Spouses', 'Wanandoa', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (19, 'Parents and children', 'Wazazi na watoto', 't');
INSERT INTO public.relationship_type(code, name, name_other_lang, active) VALUES (20, 'Siblings', 'Ndugu', 't');

ALTER TABLE public.natural_person ADD COLUMN id_number character varying(50);
ALTER TABLE public.natural_person ADD COLUMN id_type integer;
ALTER TABLE public.natural_person ADD COLUMN dob date;
ALTER TABLE public.natural_person ADD COLUMN share character varying(100);
ALTER TABLE public.natural_person ADD COLUMN acquisition_type integer;
ALTER TABLE public.natural_person ADD CONSTRAINT fk_natural_person_id_type FOREIGN KEY (id_type) REFERENCES public.id_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE public.natural_person ADD CONSTRAINT natural_person_fk_acquisition_type FOREIGN KEY (acquisition_type) REFERENCES public.acquisition_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN public.natural_person.id_number IS 'Identification document number.';
COMMENT ON COLUMN public.natural_person.id_type IS 'Identification document type code.';
COMMENT ON COLUMN public.natural_person.dob IS 'Date of birth.';
COMMENT ON COLUMN public.natural_person.share IS 'Share size or share description in case of common ownership right';
COMMENT ON COLUMN public.natural_person.acquisition_type IS 'Acquisition type code. Mostly used for disputing parties';

ALTER TABLE public.spatialunit_personwithinterest ADD COLUMN dob date;
ALTER TABLE public.spatialunit_personwithinterest ADD COLUMN gender_id integer;
ALTER TABLE public.spatialunit_personwithinterest ADD COLUMN relationship_type integer;
ALTER TABLE public.spatialunit_personwithinterest ADD CONSTRAINT fk_poi_gender FOREIGN KEY (gender_id) REFERENCES public.gender (gender_id) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE public.spatialunit_personwithinterest ADD CONSTRAINT fk_poi_relationship_type FOREIGN KEY (relationship_type) REFERENCES public.relationship_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMENT ON COLUMN public.spatialunit_personwithinterest.dob IS 'Date of birth.';
COMMENT ON COLUMN public.spatialunit_personwithinterest.gender_id IS 'Gender code.';
COMMENT ON COLUMN public.spatialunit_personwithinterest.relationship_type IS 'Relationship type code.';

-- Ownership

ALTER TABLE public.social_tenure_relationship ALTER COLUMN person_gid DROP NOT NULL;
ALTER TABLE public.social_tenure_relationship ADD COLUMN relationship_type integer;
ALTER TABLE public.social_tenure_relationship ADD COLUMN cert_number character varying(30);
ALTER TABLE public.social_tenure_relationship ADD COLUMN juridical_area double precision;
ALTER TABLE public.social_tenure_relationship ADD COLUMN acquisition_type integer;
ALTER TABLE public.social_tenure_relationship ADD COLUMN file_number character varying(30);

ALTER TABLE public.social_tenure_relationship ADD CONSTRAINT fk_social_tenure_relationship_type FOREIGN KEY (relationship_type) REFERENCES public.relationship_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE public.social_tenure_relationship ADD CONSTRAINT fk_acquisition_type FOREIGN KEY (acquisition_type) REFERENCES public.acquisition_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN public.social_tenure_relationship.relationship_type IS 'Relationship type code.';
COMMENT ON COLUMN public.social_tenure_relationship.cert_number IS 'Certificate number. Used for new or existing CCROs or other existing right type.';
COMMENT ON COLUMN public.social_tenure_relationship.tenure_duration IS 'Length of parcel occupancy.';
COMMENT ON COLUMN public.social_tenure_relationship.juridical_area IS 'Parcel area according to the legal documents. Used for existing CCROs or other existing right type.';
COMMENT ON COLUMN public.social_tenure_relationship.acquisition_type IS 'Acquisition type code.';
COMMENT ON COLUMN public.social_tenure_relationship.file_number IS 'Physical archive file number';

-- Sequence for CCRO and file numbers generation
CREATE SEQUENCE public.ccro_number_seq
  INCREMENT 1
  MINVALUE 20000
  MAXVALUE 999999999999
  START 20000
  CACHE 1;
ALTER TABLE public.ccro_number_seq
  OWNER TO postgres;

-- Function to assign CCRO and file numbers

CREATE OR REPLACE FUNCTION public.f_for_trg_generate_ccro()
  RETURNS trigger AS
$BODY$
DECLARE 
  ccro_number bigint;
  village_code character varying(10);

BEGIN
   IF (NEW.current_workflow_status_id = 2 AND NEW.claim_type in ('newClaim','existingClaim') AND EXISTS(SELECT 1 FROM public.social_tenure_relationship WHERE (cert_number IS NULL OR cert_number = '') AND usin = NEW.usin AND isactive = 't')) THEN

      SELECT upper(pa.village_code) INTO village_code FROM public.project_area pa WHERE pa.name = NEW.project_name LIMIT 1;
      
      IF(village_code IS NULL) THEN
	RAISE EXCEPTION 'Village code must be assigned in the project settings';
      ELSE
        SELECT nextval('ccro_number_seq') INTO ccro_number;
        UPDATE public.social_tenure_relationship SET cert_number = village_code || '/' || ccro_number, ccro_issue_date = now(), file_number = 'IRD/HW/' || ccro_number 
	WHERE (cert_number IS NULL OR cert_number = '') AND usin = NEW.usin AND isactive = 't';
      END IF;
      
   END IF; 
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.f_for_trg_generate_ccro()
  OWNER TO postgres;
COMMENT ON FUNCTION public.f_for_trg_generate_ccro() IS 'This function generates CCRO and file number upon approval of the new claim.';

CREATE TRIGGER trg_generate_ccro
  BEFORE UPDATE
  ON public.spatial_unit
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_generate_ccro();

-- Project

ALTER TABLE public.project_area ADD COLUMN region_code character varying(20);
ALTER TABLE public.project_area ADD COLUMN vc_meeting_date date;
ALTER TABLE public.project_area ADD COLUMN village_chairman_signature character varying(255);
ALTER TABLE public.project_area ADD COLUMN village_executive_signature character varying(255);
ALTER TABLE public.project_area ADD COLUMN district_officer_signature character varying(255);

COMMENT ON COLUMN public.project_area.vc_meeting_date IS 'Village council meeting date. The date when CCRO requests were approved.';
COMMENT ON COLUMN public.project_area.village_chairman_signature IS 'Path to the village chairman scanned signature.';
COMMENT ON COLUMN public.project_area.village_executive_signature IS 'Path to the village executive officer scanned signature.';
COMMENT ON COLUMN public.project_area.district_officer_signature IS 'Path to the district land officer scanned signature.';
COMMENT ON COLUMN public.project_area.region_code IS 'Region code.';

UPDATE public.project_area SET region_code = '119IR';

-- DISPUTES

CREATE TABLE public.dispute_status
(
   code int NOT NULL, 
   name character varying(200) NOT NULL, 
   name_other_lang character varying(200), 
   active boolean NOT NULL DEFAULT 't', 
   CONSTRAINT dispute_status_pk_code PRIMARY KEY (code)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.dispute_status.code IS 'Dispute type code - primary key';
COMMENT ON COLUMN public.dispute_status.name IS 'Dispute type name';
COMMENT ON COLUMN public.dispute_status.name_other_lang IS 'Dispute type name in other language';
COMMENT ON COLUMN public.dispute_status.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';
COMMENT ON TABLE public.dispute_status
  IS 'Reference data table for Dispute types';

INSERT INTO public.dispute_status (code, name, name_other_lang, active) VALUES (1, 'Active', 'Haujasuluhishwa', 't');
INSERT INTO public.dispute_status (code, name, name_other_lang, active) VALUES (2, 'Resolved', 'Umesuluhishwa', 't');

CREATE TABLE public.dispute_type
(
   code int NOT NULL, 
   name character varying(200) NOT NULL, 
   name_other_lang character varying(200), 
   active boolean NOT NULL DEFAULT 't', 
   CONSTRAINT dispute_type_pk_code PRIMARY KEY (code)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.dispute_type.code IS 'Dispute type code - primary key';
COMMENT ON COLUMN public.dispute_type.name IS 'Dispute type name';
COMMENT ON COLUMN public.dispute_type.name_other_lang IS 'Dispute type name in other language';
COMMENT ON COLUMN public.dispute_type.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';
COMMENT ON TABLE public.dispute_type
  IS 'Reference data table for Dispute types';

INSERT INTO public.dispute_type (code, name, name_other_lang, active) VALUES (1, 'Boundary', 'Mpaka', 't');
INSERT INTO public.dispute_type (code, name, name_other_lang, active) VALUES (2, 'Counter-claim (Inter-family)', 'Mgogoro baina ya familia', 't');
INSERT INTO public.dispute_type (code, name, name_other_lang, active) VALUES (3, 'Counter-claim (Intra-family)', 'Mgogoro ndani ya familia', 't');
INSERT INTO public.dispute_type (code, name, name_other_lang, active) VALUES (4, 'Counter-claim (Others)', 'Mgogoro baina ya watu tofauti', 't');
INSERT INTO public.dispute_type (code, name, name_other_lang, active) VALUES (5, 'Other interests', 'Maslahi mengine', 't');

CREATE TABLE public.dispute
(
   id bigint NOT NULL, 
   usin bigint NOT NULL,
   dispute_type int NOT NULL, 
   description character varying(500), 
   reg_date date,
   resolution_text text,
   resolution_date date,
   status int NOT NULL DEFAULT 1, 
   deleted boolean DEFAULT false,
   CONSTRAINT dispute_pk_id PRIMARY KEY (id), 
   CONSTRAINT dispute_fk_spatial_unit FOREIGN KEY (usin) REFERENCES public.spatial_unit (usin) ON UPDATE NO ACTION ON DELETE CASCADE, 
   CONSTRAINT dispute_fk_dispute_type FOREIGN KEY (dispute_type) REFERENCES public.dispute_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION, 
   CONSTRAINT dispute_fk_status FOREIGN KEY (status) REFERENCES public.dispute_status (code) ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.dispute.id IS 'Primary key';
COMMENT ON COLUMN public.dispute.usin IS 'Parcel ID';
COMMENT ON COLUMN public.dispute.dispute_type IS 'Dispute type code';
COMMENT ON COLUMN public.dispute.description IS 'Dispute description';
COMMENT ON COLUMN public.dispute.reg_date IS 'Date when dispute was registered';
COMMENT ON COLUMN public.dispute.resolution_text IS 'Dispute resolution text';
COMMENT ON COLUMN public.dispute.resolution_date IS 'Date when dispute was resolved';
COMMENT ON COLUMN public.dispute.status IS 'Dispute status code';
COMMENT ON COLUMN public.dispute.deleted IS 'Indication whether record is deleted or not';

CREATE SEQUENCE public.dispute_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 6741
  CACHE 1;
ALTER TABLE public.dispute_id_seq
  OWNER TO postgres;
  
CREATE TABLE public.dispute_person
(
   dispute_id bigint NOT NULL, 
   person_id bigint NOT NULL, 
   CONSTRAINT dispute_person_pk_id PRIMARY KEY (dispute_id, person_id), 
   CONSTRAINT dispute_person_fk_dispute FOREIGN KEY (dispute_id) REFERENCES public.dispute (id) ON UPDATE NO ACTION ON DELETE CASCADE, 
   CONSTRAINT dispute_person_fk_person FOREIGN KEY (person_id) REFERENCES public.natural_person (gid) ON UPDATE NO ACTION ON DELETE CASCADE
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.dispute_person.dispute_id IS 'Dispute id';
COMMENT ON COLUMN public.dispute_person.person_id IS 'Person id';

-- Document type

CREATE TABLE public.document_type
(
   code integer NOT NULL, 
   name character varying(200) NOT NULL, 
   name_other_lang character varying(200), 
   active boolean NOT NULL DEFAULT 't', 
   CONSTRAINT document_type_pk_code PRIMARY KEY (code)
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN public.document_type.code IS 'Document type code - primary key';
COMMENT ON COLUMN public.document_type.name IS 'Document type name';
COMMENT ON COLUMN public.document_type.name_other_lang IS 'Document type name in other language';
COMMENT ON COLUMN public.document_type.active IS 'Boolean flag indicating whether the record is active and should be displayed on the forms.';
COMMENT ON TABLE public.document_type
  IS 'Reference data table for Document types';

INSERT INTO public.document_type (code, name, name_other_lang, active) VALUES (1, 'Informal Receipt of Sale', 'Hati ya manunuzi isiyo rasmi', 't');
INSERT INTO public.document_type (code, name, name_other_lang, active) VALUES (2, 'Formal Receipt of Sale', 'Hati ya manunuzi iliyo rasmi', 't');
INSERT INTO public.document_type (code, name, name_other_lang, active) VALUES (3, 'Letter of Allocation', 'Barua ya mgao', 't');
INSERT INTO public.document_type (code, name, name_other_lang, active) VALUES (4, 'Probate Document', 'Hati ya Mirathi', 't');
INSERT INTO public.document_type (code, name, name_other_lang, active) VALUES (5, 'Other', 'Nyingine', 't');

-- Document

ALTER TABLE public.source_document ADD COLUMN document_type integer;
ALTER TABLE public.source_document ADD COLUMN dispute_id bigint;
ALTER TABLE public.source_document ADD CONSTRAINT fk_document_document_type FOREIGN KEY (document_type) REFERENCES public.document_type (code) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE public.source_document ADD CONSTRAINT fk_document_dispute FOREIGN KEY (dispute_id) REFERENCES public.dispute (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMENT ON COLUMN public.source_document.document_type IS 'Document type code.';
COMMENT ON COLUMN public.source_document.dispute_id IS 'Dispute id.';

-- Master attributes
UPDATE public.attribute_master SET alias = 'Length of occupancy (years)', alias_second_language = 'Muda wa umiliki ardhi (miaka)' WHERE id = 13;
UPDATE public.attribute_master SET mandatory = true where id = 3;
UPDATE public.attribute_master SET alias_second_language = 'Matumizi yaliyopo' where id = 16;

INSERT INTO public.attribute_master(id, alias, alias_second_language, fieldname, datatype_id, attributecategoryid, reftable, size, mandatory, listing, active, master_attrib)
VALUES (300, 'Acquisition Type', 'Namna ardhi ilivyopatikana', 'acquisition_type', 5, 4, 'social_tenure_relationship', 20, true, 3, true, true);

INSERT INTO public.attribute_master(id, alias, alias_second_language, fieldname, datatype_id, attributecategoryid, reftable, size, mandatory, listing, active, master_attrib)
VALUES (310, 'ID number', 'Namba ya kitambulisho', 'id_number', 1, 2, 'natural_person', 50, true, 90, true, true);

INSERT INTO public.attribute_master(id, alias, alias_second_language, fieldname, datatype_id, attributecategoryid, reftable, size, mandatory, listing, active, master_attrib)
VALUES (320, 'ID type', 'Aina ya kitambulisho', 'id_type', 5, 2, 'natural_person', 20, true, 80, true, true);

INSERT INTO public.attribute_master(id, alias, alias_second_language, fieldname, datatype_id, attributecategoryid, reftable, size, mandatory, listing, active, master_attrib)
VALUES (330, 'Date of birth', 'Tarehe ya Kuzaliwa', 'dob', 2, 2, 'natural_person', 10, true, 60, true, true);

INSERT INTO public.attribute_master(id, alias, alias_second_language, fieldname, datatype_id, attributecategoryid, reftable, size, mandatory, listing, active, master_attrib)
VALUES (340, 'Document type', 'Aina ya nyaraka', 'document_type', 5, 3, 'source_document', 20, false, 20, true, true);

UPDATE public.attribute_master SET active = false WHERE id in (264,265,266,267,31,23,24);
UPDATE public.attribute_master SET listing = 10 WHERE id = 16; 
UPDATE public.attribute_master SET listing = 20 WHERE id = 9;
UPDATE public.attribute_master SET listing = 30 WHERE id = 44;
UPDATE public.attribute_master SET listing = 40 WHERE id = 45;
UPDATE public.attribute_master SET listing = 50 WHERE id = 46;
UPDATE public.attribute_master SET listing = 60 WHERE id = 47;
UPDATE public.attribute_master SET listing = 70 WHERE id = 50;
UPDATE public.attribute_master SET listing = 80 WHERE id = 51;
UPDATE public.attribute_master SET listing = 25 WHERE id = 37;
UPDATE public.attribute_master SET listing = 26 WHERE id = 39;
UPDATE public.attribute_master SET listing = 27 WHERE id = 38;
update public.attribute_master set listing = 10 where id = 1;
update public.attribute_master set listing = 20 where id = 2;
update public.attribute_master set listing = 30 where id = 3;
update public.attribute_master set listing = 40 where id = 4;
update public.attribute_master set listing = 50 where id = 42;
update public.attribute_master set listing = 70 where id = 21;
update public.attribute_master set listing = 100 where id = 22;
update public.attribute_master set listing = 110 where id = 5;
update public.attribute_master set listing = 120 where id = 19;
update public.attribute_master set listing = 30 where id = 10;
update public.attribute_master set listing = 10 where id = 11;
update public.attribute_master set listing = 1, attributecategoryid=4 where id = 9;

-- Master attribute options
-- acquisition
INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Allocated by Village Council', 300, 'Kupewa na Halmashauri ya Kijiji', 1);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Gift', 300, 'Zawadi', 2);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Inheritance', 300, 'Urithi', 3);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Purchase', 300, 'Kununua', 4);
-- id type
INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Voter ID', 320, 'Kadi ya mpiga kura', 1);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Driving license', 320, 'Leseni ya udereva', 2);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Passport', 320, 'Pasi ya kusafiria', 3);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'ID card', 320, 'Kitambulisho cha Mkazi', 4);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Other', 320, 'Nyingine', 5);

-- document type
INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Informal Receipt of Sale', 340, 'Hati ya mauzo isiyo rasmi', 1);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Formal Receipt of Sale', 340, 'Hati ya mauzo iliyo rasmi', 2);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Letter of Allocation', 340, 'Barua ya mgao', 3);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Probate Document', 340, 'Hati ya Mirathi', 4);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Other', 340, 'Nyingine', 5);

-- land use
delete from public.attribute_options where attribute_id = 9 and parent_id not in (1,2,3,4,14);
delete from public.attribute_options where attribute_id = 16 and parent_id not in (1,2,3,4,14);

update public.attribute_options set optiontext = 'Forestry', optiontext_second_language = 'Hifadhi ya Msitu' where attribute_id = 9 and parent_id = 2;
update public.attribute_options set optiontext = 'Residential', optiontext_second_language = 'Makazi' where attribute_id = 9 and parent_id = 3;
update public.attribute_options set optiontext = 'Grazing', optiontext_second_language = 'Malisho' where attribute_id = 9 and parent_id = 4;

update public.attribute_options set optiontext = 'Forestry', optiontext_second_language = 'Hifadhi ya Msitu' where attribute_id = 16 and parent_id = 2;
update public.attribute_options set optiontext = 'Residential', optiontext_second_language = 'Makazi' where attribute_id = 16 and parent_id = 3;
update public.attribute_options set optiontext = 'Grazing', optiontext_second_language = 'Malisho' where attribute_id = 16 and parent_id = 4;

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Residential and agricultural', 9, 'Makazi na kilimo', 15);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Wildlife/Tourism', 9, 'Hifadhi za wanyama na Utalii', 16);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Social services', 9, 'Huduma za jamii', 17);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Mining', 9, 'Maeneo ya madini', 18);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Residential and agricultural', 16, 'Makazi na kilimo', 15);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Wildlife/Tourism', 16, 'Hifadhi za wanyama na Utalii', 16);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Social services', 16, 'Huduma za jamii', 17);

INSERT INTO public.attribute_options(id, optiontext, attribute_id, optiontext_second_language, parent_id)
VALUES ((select max(id)+1 from public.attribute_options), 'Mining', 16, 'Maeneo ya madini', 18);


-- Report views and functions

-- Function to get adjudicators signature path
CREATE OR REPLACE FUNCTION public.get_adjudicator_signature(project character varying(100), person_name character varying(200)) 
RETURNS character varying(255) AS 
$$
DECLARE result character varying(255);
BEGIN

select signature_path from project_adjudicators where project_name = project and adjudicator_name = person_name into result;

IF (result is null or result = '') THEN
  select '0' into result;
END IF;
RETURN result;

END;
$$
LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.get_adjudicator_signature(project character varying(100), person_name character varying(200))
  OWNER TO postgres;
COMMENT ON FUNCTION public.get_adjudicator_signature(project character varying(100), person_name character varying(200)) IS 'This function for extracting adjudicator signature path';

-- POI

CREATE OR REPLACE VIEW public.view_pois AS
select 
  p.id,
  p.usin,
  p.person_name,
  rt.name_other_lang as relationship_type,
  (case when p.dob is null then null else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age,
  g.gender_sw as gender
  
from 
	(spatialunit_personwithinterest p left join relationship_type rt on p.relationship_type = rt.code)
	left join gender g on p.gender_id = g.gender_id;

-- natural persons

CREATE OR REPLACE VIEW public.view_natural_persons AS
select 
  p.gid,
  p.active as is_active,
  trim(p.first_name) as first_name,
  p.last_name,
  p.middle_name,
  pt.person_type_sw as person_type,
  g.gender_sw as gender,
  ms.maritalstatus_sw as marital_status,
  c.citizenname_sw as citizenship,
  p.mobile,
  p.id_number,
  p.share,
  it.name_other_lang as id_type,
  (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age,
  (case when p.resident_of_village then 'Ndiyo' else 'Hapana' end) as resident,
  coalesce(p.resident_of_village, true) as village_resident

from 
	((((
	natural_person p left join person_type pt on p.personsub_type = pt.person_type_gid)
	left join gender g on p.gender = g.gender_id)
	left join marital_status ms on p.marital_status = ms.maritalstatus_id)
	left join citizenship c on p.citizenship_id = c.id)
	left join id_type it on p.id_type = it.code

where p.active;

-- non natural person with right

CREATE OR REPLACE VIEW public.view_non_natural_persons_with_right AS
select 
  r.usin,
  p.non_natural_person_gid as gid,
  trim(p.instutution_name) as instutution_name,
  p.address,
  p.phone_number,
  gt.group_value_sw as institution_type,
  p.poc_gid as rep_gid

from 
	social_tenure_relationship r inner join (
	non_natural_person p left join group_type gt on p.group_type = gt.group_id
	) on r.person_gid = p.non_natural_person_gid

where r.isactive and p.active

order by trim(p.instutution_name);

-- natural person with right

CREATE OR REPLACE VIEW public.view_natural_persons_with_right AS
select 
  p.gid,
  p.active as is_active,
  r.usin,
  trim(p.first_name) as first_name,
  p.last_name,
  p.middle_name,
  pt.person_type_sw as person_type,
  pt.person_type_gid as person_type_id,
  g.gender_sw as gender,
  ms.maritalstatus_sw as marital_status,
  c.citizenname_sw as citizenship,
  p.mobile,
  p.id_number,
  p.share,
  it.name_other_lang as id_type,
  (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age,
  (case when p.resident_of_village then 'Ndiyo' else 'Hapana' end) as resident,
  coalesce(p.resident_of_village, true) as village_resident

from 
	social_tenure_relationship r inner join (
	((((
	natural_person p left join person_type pt on p.personsub_type = pt.person_type_gid)
	left join gender g on p.gender = g.gender_id)
	left join marital_status ms on p.marital_status = ms.maritalstatus_id)
	left join citizenship c on p.citizenship_id = c.id)
	left join id_type it on p.id_type = it.code
	) on r.person_gid = p.gid

where r.isactive and p.active

order by pt.person_type_gid, trim(p.first_name);

-- claims

CREATE OR REPLACE VIEW public.view_claims AS
select 
  su.usin, 
  su.usin_str, 
  su.uka_propertyno as uka, 
  round((st_area(st_transform(su.the_geom,32736))*0.000247105)::numeric, 3) as acres,
  h.hamlet_name_second_language as hamlet_name, 
  ux.land_use_type_sw as existing_use, 
  up.land_use_type_sw as proposed_use, 
  lt.landtype_value_sw as land_type,
  su.neighbor_north, 
  su.neighbor_south, 
  su.neighbor_east, 
  su.neighbor_west,
  su.witness_1 as adjudicator1,
  get_adjudicator_signature(su.project_name, su.witness_1) as adjudicator1_signature,
  su.witness_2 as adjudicator2,
  get_adjudicator_signature(su.project_name, su.witness_2) as adjudicator2_signature,
  su.survey_date as application_date,
  su.current_workflow_status_id as status_id,
  su.project_name,
  su.claim_type,
  su.workflow_status_update_time as status_date,
  sur.tenure_class,
  sur.ownership_type,
  sur.ownership_type_id,
  sur.duration,
  sur.cert_date,
  sur.cert_number,
  sur.acquisition_type,
  sur.file_number,
  sur.relationship_type,
  u.name as recorder

from (((((
	spatial_unit su
	left join project_hamlets h on su.hamlet_id = h.id) 
	left join land_use_type ux on su.existing_use = ux.use_type_id) 
	left join land_use_type up on su.proposed_use = up.use_type_id)
	left join land_type lt on su.type_name::integer = lt.landtype_id)
	left join users u on su.userid = u.id)
	left join (
		select 
		  distinct on (r.usin)
		  r.usin,
		  t.tenure_class,
		  sh.share_type_sw as ownership_type,
		  sh.gid as ownership_type_id,
		  r.tenure_duration as duration,
		  r.ccro_issue_date as cert_date,
		  r.cert_number,
		  a.name_other_lang as acquisition_type,
		  r.file_number,
		  rt.name_other_lang as relationship_type

		from (((
			social_tenure_relationship r left join acquisition_type a on r.acquisition_type = a.code) 
			left join relationship_type rt on r.relationship_type = rt.code)
			left join share_type sh on r.share = sh.gid)
			left join tenure_class t on r.tenureclass_id = t.tenureclass_id

		where r.isactive
	) sur on su.usin = sur.usin

where su.active

order by h.hamlet_name_second_language;


-- Registry book
CREATE OR REPLACE VIEW public.view_registry_book AS
select 
  p.gid,
  r.usin,
  su.project_name,
  su.uka_propertyno as uka, 
  round((st_area(st_transform(su.the_geom,32736))*0.000247105)::numeric, 3) as acres,
  h.hamlet_name_second_language as hamlet_name, 
  su.neighbor_north, 
  su.neighbor_south, 
  su.neighbor_east, 
  su.neighbor_west,
  r.ccro_issue_date as cert_date,
  r.cert_number,
  sh.share_type_sw as ownership_type,
  r.file_number,
  trim(p.first_name) as first_name,
  p.last_name,
  p.middle_name,
  pt.person_type_sw as person_type,
  pt.person_type_gid as person_type_id,
  p.mobile,
  p.id_number,
  p.share,
  (case when p.gender = 1 then 'kiume' else 'kike' end) as gender,
  (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age,
  it.name_other_lang as id_type,
  p.resident_of_village as resident

from 
	((social_tenure_relationship r left join share_type sh on r.share = sh.gid) inner join ((
	natural_person p left join person_type pt on p.personsub_type = pt.person_type_gid)
	left join id_type it on p.id_type = it.code) 
	on r.person_gid = p.gid)
	inner join (spatial_unit su left join project_hamlets h on su.hamlet_id = h.id) on r.usin = su.usin

where r.isactive and p.active and su.active and su.current_workflow_status_id = 2 and su.claim_type = 'newClaim' and r.share != 6

union

select 
  np.non_natural_person_gid as gid,
  r.usin,
  su.project_name,
  su.uka_propertyno as uka, 
  round((st_area(st_transform(su.the_geom,32736))*0.000247105)::numeric, 3) as acres,
  h.hamlet_name_second_language as hamlet_name, 
  su.neighbor_north, 
  su.neighbor_south, 
  su.neighbor_east, 
  su.neighbor_west,
  r.ccro_issue_date as cert_date,
  r.cert_number,
  sh.share_type_sw as ownership_type,
  r.file_number,
  trim(np.instutution_name) as first_name,
  '' as last_name,
  '' as middle_name,
  'Zisizo za' as person_type,
  2 as person_type_id,
  np.phone_number as mobile,
  '' as id_number,
  '' as share,
  '' as gender,
  0 as age,
  '' as id_type,
  true as resident

from 
	((social_tenure_relationship r left join share_type sh on r.share = sh.gid) 
	inner join non_natural_person np on r.person_gid = np.non_natural_person_gid)
	inner join (spatial_unit su left join project_hamlets h on su.hamlet_id = h.id) on r.usin = su.usin

where r.isactive and np.active and su.active and su.current_workflow_status_id = 2 and su.claim_type = 'newClaim' and r.share = 6

order by hamlet_name, cert_number, usin, first_name;

-- Owners for editing
CREATE OR REPLACE VIEW public.view_claimants_for_editing AS
select 
  row_number() over () as id,
  p.gid as person_id,
  su.usin,
  su.uka_propertyno as uka,
  su.hamlet_id,
  r.gid as right_id,
  su.survey_date as claim_date,
  su.polygon_number as claim_number,
  su.project_name,
  su.neighbor_north, 
  su.neighbor_south, 
  su.neighbor_east, 
  su.neighbor_west,
  su.current_workflow_status_id::int as claim_status,
  sh.share_type,
  p.first_name,
  p.last_name,
  p.middle_name,
  p.mobile,
  p.id_number,
  p.id_type,
  p.dob,
  p.age,
  p.gender,
  p.marital_status
from 
	((social_tenure_relationship r left join share_type sh on r.share = sh.gid) inner join natural_person p on r.person_gid = p.gid)
	inner join spatial_unit su on r.usin = su.usin

where r.isactive and p.active and su.active and p.active and su.current_workflow_status_id in (1,3,4) and r.share != 6
order by first_name;

-- Claims stat
CREATE OR REPLACE FUNCTION get_claims_stat(IN projectName character varying(100)) 
RETURNS TABLE(claim_type character varying(200), collected integer, approved integer, denied integer)
AS $$ 

select  ct.name as claim_type, 
	count(1)::int as collected,
	sum(case when su.current_workflow_status_id = 2 then 1 else 0 end)::int as approved, 
	sum(case when su.current_workflow_status_id = 5 then 1 else 0 end)::int as denied
from spatial_unit su left join claim_type ct on su.claim_type = ct.code
where su.active and (su.project_name = projectName or '' = projectName)
group by ct.name
order by ct.name

$$
LANGUAGE SQL;

-- Unique claimants 
CREATE OR REPLACE FUNCTION get_unique_claimants(IN projectName character varying(100)) 
RETURNS TABLE(male_count integer, female_count integer)
AS $$ 

select 
  sum(case when t.gender = 1 then 1 else 0 end)::int as male_count,
  sum(case when t.gender = 2 then 1 else 0 end)::int as female_count
from (
  select p.gender
  from natural_person p inner join (social_tenure_relationship r inner join spatial_unit su on r.usin = su.usin) on p.gid = r.person_gid
  where r.isactive and su.active and coalesce(p.personsub_type, 0) != 5 and (su.claim_type = 'newClaim' or su.claim_type = 'existingClaim') and (su.project_name = projectName or '' = projectName)
  group by coalesce(p.last_name, ''), coalesce(p.first_name, ''), coalesce(p.id_number, ''), p.gender, (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer
) t

$$
LANGUAGE SQL;

-- Unique claimants by age 
CREATE OR REPLACE FUNCTION get_unique_claimants_with_age(IN projectName character varying(100)) 
RETURNS TABLE(age_group character varying(20), male_count integer, female_count integer, total integer)
AS $$ 

select 
  (case when t.age < 35 then '<35' else '>=35' end) as age_group,
  sum(case when t.gender = 1 then 1 else 0 end)::int as male_count,
  sum(case when t.gender = 2 then 1 else 0 end)::int as female_count,
  count(1)::int as total
from (
  select p.gender, (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age
  from natural_person p inner join (social_tenure_relationship r inner join spatial_unit su on r.usin = su.usin) on p.gid = r.person_gid
  where r.isactive and su.active and coalesce(p.personsub_type, 0) != 5 and (su.claim_type = 'newClaim' or su.claim_type = 'existingClaim') and (su.project_name = projectName or '' = projectName)
  group by coalesce(p.last_name, ''), coalesce(p.first_name, ''), coalesce(p.id_number, ''), p.gender, (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer
) t
group by (case when t.age < 35 then '<35' else '>=35' end)

$$
LANGUAGE SQL;

-- Unique claimants denied
CREATE OR REPLACE FUNCTION get_unique_claimants_denied(IN projectName character varying(100)) 
RETURNS TABLE(male_count integer, female_count integer)
AS $$ 

select 
  sum(case when t.gender = 1 then 1 else 0 end)::int as male_count,
  sum(case when t.gender = 2 then 1 else 0 end)::int as female_count
from (
  select p.gender
  from natural_person p inner join (social_tenure_relationship r inner join spatial_unit su on r.usin = su.usin) on p.gid = r.person_gid
  where r.isactive and su.active and coalesce(p.personsub_type, 0) != 5 and su.current_workflow_status_id = 5 and (su.claim_type = 'newClaim' or su.claim_type = 'existingClaim') and (su.project_name = projectName or '' = projectName)
  group by coalesce(p.last_name, ''), coalesce(p.first_name, ''), coalesce(p.id_number, ''), p.gender, (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer
) t

$$
LANGUAGE SQL;


-- Approved CCROs by unique persons
CREATE OR REPLACE FUNCTION get_ccro_occurrence(IN projectName character varying(100)) 
RETURNS TABLE(occurrence integer, males integer, females integer, total integer)
AS $$ 

select t.occurrence::int, 
sum(case when t.gender = 1 then 1 else 0 end)::int as males,
sum(case when t.gender = 2 then 1 else 0 end)::int as females,
count(1)::int as total
from
(
select 
  count(1) as occurrence, 
  p.gender, 
  (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer as age
from natural_person p inner join (social_tenure_relationship r inner join spatial_unit su on r.usin = su.usin) on p.gid = r.person_gid
  where r.isactive and coalesce(p.personsub_type, 0) != 5 and su.active and su.current_workflow_status_id = 2 and r.share > 0
	and (su.claim_type = 'newClaim' or su.claim_type = 'existingClaim') 
	and (su.project_name = projectName or '' = projectName)
  group by coalesce(p.last_name, ''), coalesce(p.first_name, ''), coalesce(p.id_number, ''), p.gender, (case when p.dob is null then p.age else DATE_PART('year', now()) - DATE_PART('year', p.dob) end)::integer
  ) t
group by t.occurrence
order by t.occurrence

$$
LANGUAGE SQL;


-- By share type (approved)
CREATE OR REPLACE FUNCTION get_ownership_types_approved(IN projectName character varying(100)) 
RETURNS TABLE(ownership_type character varying, males integer, females integer, total integer)
AS $$ 

select 
  sh.share_type as ownership_type, 
  sum(case when p.gender = 1 then 1 else 0 end)::int as males,
  sum(case when p.gender = 2 then 1 else 0 end)::int as females,
  count(1)::int as total
from ((social_tenure_relationship r inner join natural_person p on r.person_gid = p.gid) 
	inner join share_type sh on r.share = sh.gid)
	inner join spatial_unit su on r.usin = su.usin
where r.isactive and su.active and coalesce(p.personsub_type, 0) != 5 and su.current_workflow_status_id = 2 and (su.claim_type = 'newClaim' or su.claim_type = 'existingClaim') and (su.project_name = projectName or '' = projectName)
group by sh.share_type
order by sh.share_type

$$
LANGUAGE SQL;

-- Disputes statistics
CREATE OR REPLACE FUNCTION get_disputes_stat(IN projectName character varying(100)) 
RETURNS TABLE(dispute_type character varying(200), resolved integer, unresolved integer, total integer)
AS $$

select 
  dt.name as dispute_type,
  sum(case when d.status = 1 or su.active = 'f' then 1 else 0 end)::int as resolved,
  sum(case when d.status = 2 then 1 else 0 end)::int as unresolved,
  count(1)::int as total
from (dispute d inner join dispute_type dt on d.dispute_type = dt.code) inner join spatial_unit su on d.usin = su.usin
where d.deleted = 'f' and (su.project_name = projectName or '' = projectName)
group by dt.name
order by dt.name;

$$
LANGUAGE SQL;

-- update natural person residency
update natural_person set resident_of_village = person.resident
from person where person.person_gid = natural_person.gid;

-- function to check date validity
create or replace function is_valid_date(text) returns boolean language plpgsql immutable as $$
begin
  return case when $1::date is null then false else true end;
exception when others then
  return false;
end;$$;

-- Migrate person IDs
update natural_person 
set id_number = attr.val
from
(select trim(a.value) as val, a.parentuid as gid
from attribute a inner join surveyprojectattributes pa on a.uid = pa.uid
where pa.id = 266) attr 
where natural_person.gid = attr.gid and attr.val is not null and attr.val != '';

update natural_person set id_type = (case when position('T-' in upper(id_number)) = 1 then 1 else 5 end) where id_type is null and id_number is not null and id_number != '';

-- Migrate person date of birth
update natural_person 
set dob = cast(attr.val as date)
from
(select trim(a.value) as val, a.parentuid as gid
from attribute a inner join surveyprojectattributes pa on a.uid = pa.uid
where pa.id = 267) attr 
where natural_person.gid = attr.gid and attr.val is not null and attr.val != '' and is_valid_date(attr.val);

-- Migrate claim numbers
update spatial_unit 
set polygon_number = attr.val
from
(select trim(a.value) as val, a.parentuid as gid
from attribute a inner join surveyprojectattributes pa on a.uid = pa.uid
where pa.id = 264) attr 
where spatial_unit.usin = attr.gid and attr.val is not null and attr.val != '';

-- Migrate claim date
update spatial_unit 
set survey_date = cast(attr.val as date)
from
(select trim(a.value) as val, a.parentuid as gid
from attribute a inner join surveyprojectattributes pa on a.uid = pa.uid
where pa.id = 265) attr 
where spatial_unit.usin = attr.gid and attr.val is not null and attr.val != '' and is_valid_date(attr.val);

-- Delete unused attributes
delete from attribute using surveyprojectattributes pa where attribute.uid = pa.uid and pa.id in (264,267,266,265);
delete from surveyprojectattributes where id in (264,267,266,265);
delete from attribute_master where id in (264,267,266,265);

-- Clean spatial unit geometry
update spatial_unit set the_geom = ST_GeometryN(the_geom,1) where ST_GeometryType(the_geom) = 'ST_MultiPolygon';
update spatial_unit set the_geom = null where ST_GeometryType(the_geom) = 'ST_LineString';
update spatial_unit set the_geom = null where ST_GeometryType(the_geom) = 'ST_Point';

-- Apply restrictions for the_geom geometry
ALTER TABLE spatial_unit ADD CONSTRAINT enforce_the_geom_type CHECK (geometrytype(the_geom) = 'POLYGON'::text OR the_geom IS NULL);

-- spatial_unit trigger to control modifications

CREATE OR REPLACE FUNCTION public.f_for_trg_change_spatial_unit()
  RETURNS trigger AS
$BODY$
BEGIN
   IF (OLD.current_workflow_status_id not in (1,3,4)) THEN
      RAISE EXCEPTION 'You cannot modify this record, because of its status';
   END IF; 

   IF (TG_OP = 'DELETE') THEN
     RETURN OLD;
   ELSE
     RETURN NEW;
   END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.f_for_trg_change_spatial_unit()
  OWNER TO postgres;
COMMENT ON FUNCTION public.f_for_trg_change_spatial_unit() IS 'This function controls spatial_unit table modifications, allowing modifications only on records with new status.';

CREATE TRIGGER trg_change_spatial_unit
  BEFORE UPDATE OR DELETE
  ON public.spatial_unit
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_change_spatial_unit();

-- Function to extract coordinates from geometry
CREATE OR REPLACE FUNCTION public.get_coordinates(geom Geometry) 
RETURNS TEXT AS 
$$
DECLARE result TEXT;
BEGIN

IF (geom is not null) THEN
  IF geometrytype(geom) = 'POLYGON' THEN
    select substring(left(st_astext(geom),-2),10) into result;
    IF position(')' in result) > 1 THEN
      select left(result, position(')' in result)-1) into result;
    END IF;
    RETURN result;
  ELSIF geometrytype(geom) = 'POINT' THEN
    RETURN substring(left(st_astext(geom),-1),6);
  ELSIF geometrytype(geom) = 'LINESTRING' THEN
    RETURN substring(left(st_astext(geom),-1),12);
  END IF;
END IF;
RETURN '';

END;
$$
LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.get_coordinates(geom Geometry)
  OWNER TO postgres;
COMMENT ON FUNCTION public.get_coordinates(geom Geometry) IS 'This function for extracting coordinates from provided geometry';

-- Attribute views

-- Attributes related to spatial unit
CREATE OR REPLACE VIEW public.spatial_unit_attributes AS
select distinct spa.id, a.parentuid as parent_id, a.value, am.listing, am.datatype_id 
from attribute a 
         inner join surveyprojectattributes spa on spa.uid = a.uid 
         inner join attribute_master am on spa.id = am.id 
where am.attributecategoryid in (1,6,7)
order by am.listing;

-- Attributes related to ownership right
CREATE OR REPLACE VIEW public.right_attributes AS
select distinct spa.id, a.parentuid as parent_id, a.value, am.listing, am.datatype_id 
from attribute a 
         inner join surveyprojectattributes spa on spa.uid = a.uid 
         inner join attribute_master am on spa.id = am.id 
where am.attributecategoryid in (4)
order by am.listing;

-- Attributes related to natural person
CREATE OR REPLACE VIEW public.natural_person_attributes AS
select distinct spa.id, a.parentuid as parent_id, a.value, am.listing, am.datatype_id 
from attribute a 
         inner join surveyprojectattributes spa on spa.uid = a.uid 
         inner join attribute_master am on spa.id = am.id 
where am.attributecategoryid in (2)
order by am.listing;

-- Attributes related to nonnatural person
CREATE OR REPLACE VIEW public.nonnatural_person_attributes AS
select distinct spa.id, a.parentuid as parent_id, a.value, am.listing, am.datatype_id 
from attribute a 
         inner join surveyprojectattributes spa on spa.uid = a.uid 
         inner join attribute_master am on spa.id = am.id 
where am.attributecategoryid in (5)
order by am.listing;

-- Attributes related to media
CREATE OR REPLACE VIEW public.media_attributes AS
select distinct spa.id, a.parentuid as parent_id, a.value, am.listing, am.datatype_id 
from attribute a 
         inner join surveyprojectattributes spa on spa.uid = a.uid 
         inner join attribute_master am on spa.id = am.id 
where am.attributecategoryid in (3)
order by am.listing;

-- Adjudicators
ALTER TABLE public.project_adjudicators ADD COLUMN signature_path character varying(255);
COMMENT ON COLUMN public.project_adjudicators.signature_path IS 'Path to adjudicator''s scanned signature';
