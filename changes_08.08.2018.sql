CREATE TABLE public.la_ext_language
(
  code character varying(7) NOT NULL, 
  val character varying(250) NOT NULL, 
  active boolean NOT NULL DEFAULT true, 
  is_default boolean NOT NULL DEFAULT false, 
  item_order integer NOT NULL DEFAULT 1,
  ltr boolean NOT NULL DEFAULT true,
  CONSTRAINT ref_language_pkey PRIMARY KEY (code),
  CONSTRAINT ref_language_display_value_unique UNIQUE (val)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.la_ext_language
  OWNER TO postgres;
COMMENT ON TABLE public.la_ext_language
  IS 'Lists of languages supported in the system';
COMMENT ON COLUMN public.la_ext_language.code IS 'Langauge code.';
COMMENT ON COLUMN public.la_ext_language.val IS 'Language name.';
COMMENT ON COLUMN public.la_ext_language.active IS 'Boolean flag indicating if the language is active or not.';
COMMENT ON COLUMN public.la_ext_language.is_default IS 'Boolean flag indicating if the is set as default.';
COMMENT ON COLUMN public.la_ext_language.item_order IS 'Order of the langages in the list. This order is very important for localization and it should not be changed, without changing localizable strings.';
COMMENT ON COLUMN public.la_ext_language.ltr IS 'Boolean flag indicating text direction for the language. If true, then left to right should applied, otherwise right to left.';

INSERT INTO public.la_ext_language(code, val, active, is_default, item_order, ltr) VALUES ('en', 'English', true, true, 1, true);
INSERT INTO public.la_ext_language(code, val, active, is_default, item_order, ltr) VALUES ('fr', 'Français', true, false, 2, true);




