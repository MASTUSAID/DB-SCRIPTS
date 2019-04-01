CREATE SEQUENCE public.la_ext_boundary_point_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE public.la_ext_boundary_point_seq
  OWNER TO postgres;

CREATE TABLE public.la_ext_confidence_level
(
  id integer NOT NULL,
  name character varying(100) NOT NULL,
  name_en character varying(100) NOT NULL,
  isactive boolean NOT NULL DEFAULT true,
  CONSTRAINT pk_la_ext_confidence_level PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_confidence_level
  OWNER TO postgres;

INSERT INTO public.la_ext_confidence_level(id, name, name_en, isactive) VALUES (1, 'Low', 'Low', 't');
INSERT INTO public.la_ext_confidence_level(id, name, name_en, isactive) VALUES (2, 'Medium', 'Medium', 't');
INSERT INTO public.la_ext_confidence_level(id, name, name_en, isactive) VALUES (3, 'High', 'High', 't');

CREATE TABLE public.la_ext_boundary_point
(
  id integer NOT NULL DEFAULT nextval('la_ext_boundary_point_seq'::regclass),
  project_id integer,
  neighbor_village_id integer,
  feature_type character varying(500),
  feature_description character varying(500),
  isactive boolean NOT NULL DEFAULT('t'),
  approved boolean NOT NULL DEFAULT('f'),
  verified boolean NOT NULL DEFAULT ('f'),
  confidence_level integer,
  confidence_desc character varying(500),
  geometry geometry NOT NULL,
  created_by integer NOT NULL,
  create_date timestamp without time zone NOT NULL,
  modified_by integer,
  modify_date timestamp without time zone,
  CONSTRAINT pk_la_ext_boundary_point PRIMARY KEY (id),
  CONSTRAINT fk_confidence_level FOREIGN KEY (confidence_level)
      REFERENCES public.la_ext_confidence_level (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_la_ext_boundary_point_project_id FOREIGN KEY (project_id)
      REFERENCES public.la_spatialsource_projectname (projectnameid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_la_ext_boundary_point_neighbor_village_id FOREIGN KEY (neighbor_village_id)
      REFERENCES public.la_spatialunitgroup_hierarchy (hierarchyid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT enforce_geom_type CHECK (geometrytype(geometry) = 'POINT'::text)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_boundary_point
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fn_control_boundary_point_changes()
  RETURNS trigger AS
$BODY$
    BEGIN
    IF (select count(1) from public.la_ext_boundary_point where id = old.id and approved = 't') > 0 THEN
      RAISE EXCEPTION 'Boundary point is approved and cannot be changed or deleted';
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
ALTER FUNCTION public.fn_control_boundary_point_changes()
  OWNER TO postgres;

CREATE TRIGGER tg_control_boundary_point_changes
  BEFORE UPDATE OR DELETE
  ON public.la_ext_boundary_point
  FOR EACH ROW
  EXECUTE PROCEDURE public.fn_control_boundary_point_changes();
  
CREATE SEQUENCE public.la_ext_boundary_point_doc_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE public.la_ext_boundary_point_doc_seq
  OWNER TO postgres;

  
CREATE TABLE public.la_ext_boundary_point_doc
(
  id integer NOT NULL DEFAULT nextval('la_ext_boundary_point_doc_seq'::regclass),
  point_id integer NOT NULL,
  format_id integer,
  name character varying(50) NOT NULL,
  location character varying(250) NOT NULL,
  recordation_date date,
  remarks character varying(250) NOT NULL,
  created_by integer NOT NULL,
  create_date timestamp without time zone NOT NULL,
  modified_by integer,
  modify_date timestamp without time zone,
  CONSTRAINT pk_la_ext_boundary_point_doc PRIMARY KEY (id),
  CONSTRAINT fk_la_ext_boundary_point_doc_format_id FOREIGN KEY (format_id)
      REFERENCES public.la_ext_documentformat (documentformatid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_la_ext_boundary_point_doc_point_id FOREIGN KEY (point_id)
      REFERENCES public.la_ext_boundary_point (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_boundary_point_doc
  OWNER TO postgres;
  
-- boundary

CREATE SEQUENCE public.la_ext_boundary_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE public.la_ext_boundary_seq
  OWNER TO postgres;

CREATE TABLE public.la_ext_boundary
(
  id integer NOT NULL DEFAULT nextval('la_ext_boundary_seq'::regclass),
  project_id integer,
  village_leader character varying(500),
  quarters_num integer,
  population integer,
  survey_date date NOT NULL DEFAULT now(),
  isactive boolean NOT NULL DEFAULT('t'),
  approved boolean NOT NULL DEFAULT('f'),
  geometry geometry NOT NULL,
  created_by integer NOT NULL,
  create_date timestamp without time zone NOT NULL,
  modified_by integer,
  modify_date timestamp without time zone,
  CONSTRAINT pk_la_ext_boundary PRIMARY KEY (id),
  CONSTRAINT fk_la_ext_boundary_project_id FOREIGN KEY (project_id)
      REFERENCES public.la_spatialsource_projectname (projectnameid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT enforce_geom_type CHECK (geometrytype(geometry) = 'POLYGON'::text OR geometrytype(geometry) = 'MULTIPOLYGON'::text)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_boundary
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fn_control_boundary_changes()
  RETURNS trigger AS
$BODY$
    BEGIN
    IF (select count(1) from public.la_ext_boundary where id = old.id and approved = 't') > 0 THEN
      RAISE EXCEPTION 'Boundary is approved and cannot be changed or deleted';
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
ALTER FUNCTION public.fn_control_boundary_changes()
  OWNER TO postgres;

CREATE TRIGGER tg_control_boundary_changes
  BEFORE UPDATE OR DELETE
  ON public.la_ext_boundary
  FOR EACH ROW
  EXECUTE PROCEDURE public.fn_control_boundary_changes();

CREATE OR REPLACE FUNCTION public.fn_control_boundary_uniqueness()
  RETURNS trigger AS
$BODY$
    BEGIN
    IF (TG_OP = 'UPDATE' AND (select count(1) from public.la_ext_boundary where id = old.id and approved = 't') > 0) THEN
      RAISE EXCEPTION 'Boundary is approved and cannot be changed or deleted';
    END IF;
        
    IF (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.project_id != OLD.project_id)) THEN
        IF (select count(1) from public.la_ext_boundary where project_id = new.project_id and isactive) > 0 THEN
          RAISE EXCEPTION 'Boundary is already defined for this project.';
        END IF;
    END IF;
   
    RETURN NEW;

    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fn_control_boundary_uniqueness()
  OWNER TO postgres;

CREATE TRIGGER tg_control_boundary_uniqueness
  BEFORE UPDATE OR INSERT
  ON public.la_ext_boundary
  FOR EACH ROW
  EXECUTE PROCEDURE public.fn_control_boundary_uniqueness();
  
