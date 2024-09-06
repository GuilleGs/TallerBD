----- Secuencias --------------------

CREATE SEQUENCE  public.acreditacion_carreras_id_acreditacion_seq;

CREATE SEQUENCE  public.acreditacion_programas_id_acreditacion_seq;

CREATE SEQUENCE  public.comunas_sedes_id_comuna_seq;

CREATE SEQUENCE  public.formatos_valores_id_formato_seq;

CREATE SEQUENCE  public.jornadas_id_jornada_seq;

CREATE SEQUENCE public.modalidades_id_modalidad_seq;

CREATE SEQUENCE  public.niveles_carreras_id_nivel_seq;

CREATE SEQUENCE  public.provincias_sedes_id_provincia_seq;

CREATE SEQUENCE  public.rangos_edades_id_rango_edad_seq;

CREATE SEQUENCE  public.regiones_sedes_id_region_seq;

CREATE SEQUENCE  public.requisitos_ingresos_id_requisitos_seq;

CREATE SEQUENCE public.tipos_instituciones_id_tipo_institucion_seq;

CREATE SEQUENCE  public.tipos_planes_id_tipo_plan_seq;

CREATE SEQUENCE  public.vigencias_id_vigencia_seq;
 

---- Tablas sin referencias ----



-- Table: public.acreditacion_carreras

-- DROP TABLE IF EXISTS public.acreditacion_carreras;

CREATE TABLE IF NOT EXISTS public.acreditacion_carreras
(
    id_acreditacion integer NOT NULL DEFAULT nextval('acreditacion_carreras_id_acreditacion_seq'::regclass),
    acreditacion character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT acreditacion_carreras_pkey PRIMARY KEY (id_acreditacion)
)

TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.acreditacion_instituciones
(
    id_acreditacion integer NOT NULL DEFAULT nextval('acreditacion_programas_id_acreditacion_seq'::regclass),
    acreditacion character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT acreditacion_programas_pkey PRIMARY KEY (id_acreditacion)
)

TABLESPACE pg_default;

-- Table: public.formas_ingresos

-- DROP TABLE IF EXISTS public.formas_ingresos;

CREATE TABLE IF NOT EXISTS public.formas_ingresos
(
    id_forma_ingreso integer NOT NULL,
    forma_ingreso character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT formas_ingresos_pkey PRIMARY KEY (id_forma_ingreso)
)

TABLESPACE pg_default;

-- Table: public.formatos_valores

-- DROP TABLE IF EXISTS public.formatos_valores;

CREATE TABLE IF NOT EXISTS public.formatos_valores
(
    id_formato integer NOT NULL DEFAULT nextval('formatos_valores_id_formato_seq'::regclass),
    formato character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT formatos_valores_pkey PRIMARY KEY (id_formato)
)

TABLESPACE pg_default;

-- Table: public.generos

CREATE TABLE IF NOT EXISTS public.generos
(
    id_genero integer NOT NULL,
    genero character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT generos_pkey PRIMARY KEY (id_genero)
)

TABLESPACE pg_default;

-- Table: public.instituciones

-- DROP TABLE IF EXISTS public.instituciones;

CREATE TABLE IF NOT EXISTS public.instituciones
(
    id_institucion integer NOT NULL,
    institucion character varying(150) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT instituciones_pkey PRIMARY KEY (id_institucion)
)

TABLESPACE pg_default;

-- Table: public.jornadas

-- DROP TABLE IF EXISTS public.jornadas;

CREATE TABLE IF NOT EXISTS public.jornadas
(
    id_jornada integer NOT NULL DEFAULT nextval('jornadas_id_jornada_seq'::regclass),
    jornada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT jornadas_pkey PRIMARY KEY (id_jornada)
)

TABLESPACE pg_default;

-- Table: public.modalidades

-- DROP TABLE IF EXISTS public.modalidades;

CREATE TABLE IF NOT EXISTS public.modalidades
(
    id_modalidad integer NOT NULL DEFAULT nextval('modalidades_id_modalidad_seq'::regclass),
    modalidad character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT modalidades_pkey PRIMARY KEY (id_modalidad)
)

TABLESPACE pg_default;

-- Table: public.rangos_edades

-- DROP TABLE IF EXISTS public.rangos_edades;

CREATE TABLE IF NOT EXISTS public.rangos_edades
(
    id_rango_edad integer NOT NULL DEFAULT nextval('rangos_edades_id_rango_edad_seq'::regclass),
    rango_edad character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT rangos_edades_pkey PRIMARY KEY (id_rango_edad)
)

TABLESPACE pg_default;

-- Table: public.regiones_sedes

-- DROP TABLE IF EXISTS public.regiones_sedes;

CREATE TABLE IF NOT EXISTS public.regiones_sedes
(
    id_region integer NOT NULL DEFAULT nextval('regiones_sedes_id_region_seq'::regclass),
    region_sede character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT regiones_sedes_pkey PRIMARY KEY (id_region)
)

TABLESPACE pg_default;


-- Table: public.tipos_planes

-- DROP TABLE IF EXISTS public.tipos_planes;

CREATE TABLE IF NOT EXISTS public.tipos_planes
(
    id_tipo_plan integer NOT NULL DEFAULT nextval('tipos_planes_id_tipo_plan_seq'::regclass),
    tipo_plan character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT tipos_planes_pkey PRIMARY KEY (id_tipo_plan)
)

TABLESPACE pg_default;

-- Table: public.vigencias

-- DROP TABLE IF EXISTS public.vigencias;

CREATE TABLE IF NOT EXISTS public.vigencias
(
    id_vigencia integer NOT NULL DEFAULT nextval('vigencias_id_vigencia_seq'::regclass),
    vigencia character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT vigencias_pkey PRIMARY KEY (id_vigencia)
)

TABLESPACE pg_default;





----------- Tablas relacionadas ------------



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


----- Tablas  relacionadas a tablas que están relacioandas con otras 

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


---------------  TRASPASO -----------

CREATE TABLE IF NOT EXISTS public.traspaso
(
    periodo character varying(10) COLLATE pg_catalog."default",
    id character varying(20) COLLATE pg_catalog."default",
    codigounico character varying(50) COLLATE pg_catalog."default",
    mrut character varying(20) COLLATE pg_catalog."default",
    gen_alumno character varying(10) COLLATE pg_catalog."default",
    fech_nac_alumno character varying(15) COLLATE pg_catalog."default",
    rango_edad character varying(50) COLLATE pg_catalog."default",
    anno_ing_carrera_ori character varying(20) COLLATE pg_catalog."default",
    sem_ing_carrera_ori character varying(10) COLLATE pg_catalog."default",
    anno_ing_carrera_act character varying(20) COLLATE pg_catalog."default",
    sem_ing_carrera_act character varying(10) COLLATE pg_catalog."default",
    tipo_inst1 character varying(100) COLLATE pg_catalog."default",
    tipo_inst2 character varying(100) COLLATE pg_catalog."default",
    tipo_inst3 character varying(100) COLLATE pg_catalog."default",
    cod_inst character varying(15) COLLATE pg_catalog."default",
    nomb_inst character varying(150) COLLATE pg_catalog."default",
    cod_sede character varying(15) COLLATE pg_catalog."default",
    nombre_sede character varying(150) COLLATE pg_catalog."default",
    cod_carrera character varying(15) COLLATE pg_catalog."default",
    nombre_carrera character varying(250) COLLATE pg_catalog."default",
    modalidad character varying(100) COLLATE pg_catalog."default",
    jornada character varying(100) COLLATE pg_catalog."default",
    version character varying(15) COLLATE pg_catalog."default",
    tipo_plan_carr character varying(100) COLLATE pg_catalog."default",
    duracion_estudio_carrera character varying(10) COLLATE pg_catalog."default",
    dur_proc_tit character varying(10) COLLATE pg_catalog."default",
    dur_total_carr character varying(10) COLLATE pg_catalog."default",
    region_sede character varying(100) COLLATE pg_catalog."default",
    provincia_sede character varying(100) COLLATE pg_catalog."default",
    comuna_sede character varying(100) COLLATE pg_catalog."default",
    nivel_global character varying(100) COLLATE pg_catalog."default",
    nivel_carrera_1 character varying(150) COLLATE pg_catalog."default",
    nivel_carrera_2 character varying(150) COLLATE pg_catalog."default",
    requisito_ingreso character varying(150) COLLATE pg_catalog."default",
    vigencia_carrera character varying(100) COLLATE pg_catalog."default",
    formato_valores character varying(100) COLLATE pg_catalog."default",
    valor_matricula character varying(20) COLLATE pg_catalog."default",
    valor_arencel character varying(20) COLLATE pg_catalog."default",
    codigo_demre character varying(20) COLLATE pg_catalog."default",
    area_conocimiento character varying(100) COLLATE pg_catalog."default",
    cine_f_97_area character varying(100) COLLATE pg_catalog."default",
    cine_f_97_subarea character varying(100) COLLATE pg_catalog."default",
    area_carrera_generica character varying(100) COLLATE pg_catalog."default",
    cine_f_13_area character varying(100) COLLATE pg_catalog."default",
    cine_f_13_subarea character varying(100) COLLATE pg_catalog."default",
    acreditada_carr character varying(100) COLLATE pg_catalog."default",
    acreditada_inst character varying(100) COLLATE pg_catalog."default",
    acred_inst_desde character varying(100) COLLATE pg_catalog."default",
    acred_inst_anno character varying(10) COLLATE pg_catalog."default",
    costo_proc_acred character varying(10) COLLATE pg_catalog."default",
    costo_obt_tit_diploma character varying(10) COLLATE pg_catalog."default",
    forma_ingreso character varying(100) COLLATE pg_catalog."default"
)

TABLESPACE pg_default;
