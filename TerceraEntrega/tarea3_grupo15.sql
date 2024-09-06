-- Table: public.carreras

-- DROP TABLE IF EXISTS public.carreras;

CREATE TABLE IF NOT EXISTS public.carreras
(
    id_institucion integer NOT NULL,
    id_carrera integer NOT NULL,
    carrera character varying(250) COLLATE pg_catalog."default" NOT NULL,
    acreditada integer NOT NULL,
    CONSTRAINT pk_carreras PRIMARY KEY (id_institucion, id_carrera),
    CONSTRAINT fk_carreras_acreditacion FOREIGN KEY (acreditada)
        REFERENCES public.acreditacion_carreras (id_acreditacion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_carreras_instituciones FOREIGN KEY (id_institucion)
        REFERENCES public.instituciones (id_institucion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.carreras (id_institucion, id_carrera, carrera, acreditada)
SELECT DISTINCT ON (cod_inst, cod_carrera)
    cod_inst::INTEGER,
    cod_carrera::INTEGER,
    nombre_carrera,
    CASE
        WHEN acreditada_carr = 'ACREDITADA' THEN 1385817
        WHEN acreditada_carr = 'NO ACREDITADA' THEN 1385818
        ELSE NULL
    END AS acreditada
FROM public.traspaso
WHERE acreditada_carr IN ('ACREDITADA', 'NO ACREDITADA')
ON CONFLICT (id_institucion, id_carrera) DO NOTHING;

-- Table: public.niveles_carreras

-- DROP TABLE IF EXISTS public.niveles_carreras;

CREATE TABLE IF NOT EXISTS public.niveles_carreras
(
    id_nivel integer NOT NULL DEFAULT nextval('niveles_carreras_id_nivel_seq'::regclass),
    nivel character(100) COLLATE pg_catalog."default" NOT NULL,
    id_nivel_sup integer,
    CONSTRAINT niveles_carreras_pkey PRIMARY KEY (id_nivel),
    CONSTRAINT fk_niveles_niveles FOREIGN KEY (id_nivel_sup)
        REFERENCES public.niveles_carreras (id_nivel) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.niveles_carreras (nivel)
SELECT DISTINCT nivel_carrera_1
FROM public.traspaso
WHERE nivel_carrera_1 IS NOT NULL;

WITH niveles_ordenados AS (
    SELECT id_nivel, nivel,
           LAG(id_nivel) OVER (ORDER BY nivel) AS id_nivel_sup
    FROM public.niveles_carreras
)
UPDATE public.niveles_carreras nc
SET id_nivel_sup = no.id_nivel_sup
FROM niveles_ordenados no
WHERE nc.id_nivel = no.id_nivel;

-- Table: public.provincias_sedes

-- DROP TABLE IF EXISTS public.provincias_sedes;

CREATE TABLE IF NOT EXISTS public.provincias_sedes
(
    id_provincia integer NOT NULL DEFAULT nextval('provincias_sedes_id_provincia_seq'::regclass),
    provincia_sede character varying(100) COLLATE pg_catalog."default" NOT NULL,
    id_region integer NOT NULL,
    CONSTRAINT provincias_sedes_pkey PRIMARY KEY (id_provincia),
    CONSTRAINT provincias_sedes_id_region_fkey FOREIGN KEY (id_region)
        REFERENCES public.regiones_sedes (id_region) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.provincias_sedes (provincia_sede, id_region)
SELECT DISTINCT t.provincia_sede, r.id_region
FROM public.traspaso t
JOIN public.regiones_sedes r ON t.region_sede = r.region_sede
WHERE t.provincia_sede IS NOT NULL AND t.region_sede IS NOT NULL;

-- Table: public.sedes

-- DROP TABLE IF EXISTS public.sedes;

CREATE TABLE IF NOT EXISTS public.sedes
(
    id_institucion integer NOT NULL,
    id_sede integer NOT NULL,
    sede character varying(150) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_sedes PRIMARY KEY (id_institucion, id_sede),
    CONSTRAINT fk_sedes_instituciones FOREIGN KEY (id_institucion)
        REFERENCES public.instituciones (id_institucion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

CREATE SEQUENCE IF NOT EXISTS sedes_id_sede_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

INSERT INTO public.sedes (id_institucion, id_sede, sede)
SELECT DISTINCT 1, nextval('sedes_id_sede_seq'), t.nombre_sede
FROM public.traspaso t
WHERE t.nombre_sede IS NOT NULL;

TABLESPACE pg_default;

-- Table: public.tipos_instituciones

-- DROP TABLE IF EXISTS public.tipos_instituciones;

CREATE TABLE IF NOT EXISTS public.tipos_instituciones
(
    id_tipo_institucion integer NOT NULL DEFAULT nextval('tipos_instituciones_id_tipo_institucion_seq'::regclass),
    tipo_institucion character varying(100) COLLATE pg_catalog."default" NOT NULL,
    id_tipo_inst_superior integer,
    CONSTRAINT tipos_instituciones_pkey PRIMARY KEY (id_tipo_institucion),
    CONSTRAINT tipos_instituciones_id_tipo_inst_superior_fkey FOREIGN KEY (id_tipo_inst_superior)
        REFERENCES public.tipos_instituciones (id_tipo_institucion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

CREATE SEQUENCE IF NOT EXISTS tipos_instituciones_id_tipo_institucion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

INSERT INTO public.tipos_instituciones (tipo_institucion)
SELECT DISTINCT t.tipo_inst1
FROM public.traspaso t
WHERE t.tipo_inst1 IS NOT NULL;

UPDATE public.tipos_instituciones ti
SET id_tipo_inst_superior = sub.id_tipo_institucion
FROM (
    SELECT t1.id_tipo_institucion, t2.id_tipo_institucion AS id_tipo_inst_superior
    FROM public.tipos_instituciones t1
    JOIN public.traspaso tr ON t1.tipo_institucion = tr.tipo_inst1
    JOIN public.tipos_instituciones t2 ON tr.tipo_inst2 = t2.tipo_institucion
    WHERE tr.tipo_inst2 IS NOT NULL
) sub
WHERE ti.id_tipo_institucion = sub.id_tipo_institucion;

-- Table: public.alumnos

-- DROP TABLE IF EXISTS public.alumnos;

CREATE TABLE IF NOT EXISTS public.alumnos
(
    rut character varying(20) COLLATE pg_catalog."default" NOT NULL,
    fecha_nacimiento date,
    rango_edad integer NOT NULL,
    genero integer NOT NULL,
    CONSTRAINT alumnos_pkey PRIMARY KEY (rut),
    CONSTRAINT alumnos_genero_fkey FOREIGN KEY (genero)
        REFERENCES public.generos (id_genero) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT alumnos_rango_edad_fkey FOREIGN KEY (rango_edad)
        REFERENCES public.rangos_edades (id_rango_edad) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;


CREATE TABLE IF NOT EXISTS public.alumnos_temp
(
    id_serial serial PRIMARY KEY,
    mrut character varying(20) COLLATE pg_catalog."default" NOT NULL,
    fech_nac_alumno date,
    rango_edad integer NOT NULL,
    genero integer NOT NULL
)
TABLESPACE pg_default;

INSERT INTO public.alumnos_temp (mrut, fech_nac_alumno, rango_edad, genero)
SELECT DISTINCT t.mrut, 
                TO_DATE(t.fech_nac_alumno, 'YYYYMMDD'), 
                re.id_rango_edad, 
                CAST(t.gen_alumno AS integer)
FROM public.traspaso t
JOIN public.rangos_edades re ON t.rango_edad = re.rango_edad
WHERE t.mrut IS NOT NULL 
  AND t.fech_nac_alumno IS NOT NULL 
  AND t.rango_edad IS NOT NULL 
  AND t.gen_alumno IS NOT NULL;

INSERT INTO public.alumnos (rut, fecha_nacimiento, rango_edad, genero)
SELECT DISTINCT ON (at.mrut) at.mrut, at.fech_nac_alumno, at.rango_edad, at.genero
FROM public.alumnos_temp at
ORDER BY at.mrut, at.fech_nac_alumno;


-- Table: public.comunas_sedes

-- DROP TABLE IF EXISTS public.comunas_sedes;

CREATE TABLE IF NOT EXISTS public.comunas_sedes
(
    id_comuna integer NOT NULL DEFAULT nextval('comunas_sedes_id_comuna_seq'::regclass),
    comuna_sede character varying(100) COLLATE pg_catalog."default" NOT NULL,
    id_provincia integer NOT NULL,
    CONSTRAINT comunas_sedes_pkey PRIMARY KEY (id_comuna),
    CONSTRAINT comunas_sedes_id_provincia_fkey FOREIGN KEY (id_provincia)
        REFERENCES public.provincias_sedes (id_provincia) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.comunas_sedes (comuna_sede, id_provincia)
SELECT DISTINCT t.comuna_sede, ps.id_provincia
FROM public.traspaso t
JOIN public.provincias_sedes ps ON t.provincia_sede = ps.provincia_sede
WHERE t.comuna_sede IS NOT NULL 
  AND t.provincia_sede IS NOT NULL;

-- Table: public.carreras_versiones_sedes

-- DROP TABLE IF EXISTS public.carreras_versiones_sedes;

CREATE TABLE IF NOT EXISTS public.carreras_versiones_sedes
(
    codigounico character varying(50) COLLATE pg_catalog."default" NOT NULL,
    id_institucion integer,
    id_carrera integer,
    id_sede integer,
    id_jornada integer,
    version integer,
    CONSTRAINT carreras_versiones_sedes_pkey PRIMARY KEY (codigounico),
    CONSTRAINT fk_carversedes_carreras FOREIGN KEY (id_institucion, id_carrera)
        REFERENCES public.carreras (id_institucion, id_carrera) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_carversedes_jornadas FOREIGN KEY (id_jornada)
        REFERENCES public.jornadas (id_jornada) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_carversedes_sedes FOREIGN KEY (id_institucion, id_sede)
        REFERENCES public.sedes (id_institucion, id_sede) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.carreras_versiones_sedes (codigounico, id_institucion, id_carrera, id_sede, id_jornada, version)
SELECT DISTINCT t.codigounico, 
                c.id_institucion, 
                c.id_carrera, 
                s.id_sede, 
                j.id_jornadas, 
                CAST(t.version AS integer)
FROM public.traspaso t
JOIN public.carreras c ON t.nombre_carrera = c.carrera
JOIN public.sedes s ON t.nombre_sede = s.sede AND c.id_institucion = s.id_institucion
JOIN public.jornadas j ON t.jornada = j.jornada
WHERE t.codigounico IS NOT NULL 
  AND t.version IS NOT NULL;

-- Table: public.matriculas

-- DROP TABLE IF EXISTS public.matriculas;

CREATE TABLE IF NOT EXISTS public.matriculas
(
    mrut character varying(20) COLLATE pg_catalog."default" NOT NULL,
    codigounico character varying(50) COLLATE pg_catalog."default" NOT NULL,
    anno_ing_carrera_ori integer NOT NULL,
    semestre_ing_carrera_ori integer NOT NULL,
    anno_ing_carrera_actual integer NOT NULL,
    sem_ing_carrera_actual integer NOT NULL,
    CONSTRAINT pk_matricula PRIMARY KEY (mrut, codigounico),
    CONSTRAINT fk_matriculas_alumnos FOREIGN KEY (mrut)
        REFERENCES public.alumnos (rut) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_matriculas_carrversedes FOREIGN KEY (codigounico)
        REFERENCES public.carreras_versiones_sedes (codigounico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

INSERT INTO public.matriculas (mrut, codigounico, anno_ing_carrera_ori, semestre_ing_carrera_ori, anno_ing_carrera_actual, sem_ing_carrera_actual)
SELECT DISTINCT a.rut, 
                cvs.codigounico, 
                CAST(t.anno_ing_carrera_ori AS integer), 
                CAST(t.semestre_ing_carrera_ori AS integer), 
                CAST(t.anno_ing_carrera_act AS integer), 
                CAST(t.sem_ing_carrera_act AS integer)
FROM public.traspaso t
JOIN public.alumnos a ON t.mrut = a.rut
JOIN public.carreras_versiones_sedes cvs ON t.codigounico = cvs.codigounico
WHERE t.codigounico IS NOT NULL 
  AND t.mrut IS NOT NULL;