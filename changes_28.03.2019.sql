CREATE TABLE public.la_ext_boundary_feature_type
(
  id integer NOT NULL,
  name character varying(100) NOT NULL,
  name_en character varying(100) NOT NULL,
  isactive boolean NOT NULL DEFAULT true,
  CONSTRAINT pk_la_ext_boundary_feature_type PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_boundary_feature_type
  OWNER TO postgres;

INSERT INTO public.la_ext_boundary_feature_type(id, name, name_en, isactive) VALUES (1,'Natural', 'Natural', 't');
INSERT INTO public.la_ext_boundary_feature_type(id, name, name_en, isactive) VALUES (2,'Man Made', 'Man Made', 't');

  
ALTER TABLE public.la_ext_boundary_point DROP COLUMN feature_type;

ALTER TABLE public.la_ext_boundary_point ADD COLUMN feature_type integer;

ALTER TABLE public.la_ext_boundary_point
  ADD CONSTRAINT fk_la_ext_boundary_point_feature_type FOREIGN KEY (feature_type) REFERENCES public.la_ext_boundary_feature_type (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

update la_ext_boundary_point set feature_type = 1;

UPDATE public.la_ext_confidence_level SET name='High - No Conflict', name_en='High - No Conflict' WHERE id=3;
UPDATE public.la_ext_confidence_level SET name='Medium - Conflict under discussion', name_en='Medium - Conflict under discussion' WHERE id=2;
UPDATE public.la_ext_confidence_level SET name='Low - Elevated Conflict ', name_en='Low - Elevated Conflict ' WHERE id=1;

CREATE TABLE public.la_ext_project_neighbor_villages
(
   project_id integer NOT NULL, 
   village_id integer NOT NULL, 
   CONSTRAINT pk_la_ext_project_neighbor_villages PRIMARY KEY (project_id, village_id), 
   CONSTRAINT fk_project_neighbor_villages_project FOREIGN KEY (project_id) REFERENCES public.la_spatialsource_projectname (projectnameid) ON UPDATE NO ACTION ON DELETE NO ACTION, 
   CONSTRAINT fk_project_neighbor_villages_village FOREIGN KEY (village_id) REFERENCES public.la_spatialunitgroup_hierarchy (hierarchyid) ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
);


