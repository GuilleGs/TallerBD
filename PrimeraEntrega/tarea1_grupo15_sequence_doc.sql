-- Tabla que almacena las regiones
CREATE SEQUENCE regiones_sedes_id_seq;
CREATE TABLE regiones_sedes (
    id_region INTEGER PRIMARY KEY DEFAULT nextval('regiones_sedes_id_seq'),
    region_sed VARCHAR(100) NOT NULL
);

-- Tabla que almacena las provincias y su relación con las regiones
CREATE SEQUENCE provincias_sedes_id_seq;
CREATE TABLE provincias_sedes (
    id_provincia INTEGER PRIMARY KEY DEFAULT nextval('provincias_sedes_id_seq'),
    provincia_sede VARCHAR(100) NOT NULL,
    id_region INTEGER NOT NULL,
    CONSTRAINT provincias_fk FOREIGN KEY (id_region) REFERENCES regiones_sedes (id_region)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena las comunas y su relación con las provincias
CREATE SEQUENCE comunas_sedes_id_seq;
CREATE TABLE comunas_sedes (
    id_comuna INTEGER PRIMARY KEY DEFAULT nextval('comunas_sedes_id_seq'),
    comuna_sede VARCHAR(100),
    id_provincia INTEGER NOT NULL,
    CONSTRAINT comuna_fk FOREIGN KEY (id_provincia) REFERENCES provincias_sedes (id_provincia)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena las jornadas
CREATE SEQUENCE jornadas_id_seq;
CREATE TABLE jornadas (
    id_jornadas INTEGER PRIMARY KEY DEFAULT nextval('jornadas_id_seq'),
    jornada VARCHAR(50) NOT NULL
);

-- Tabla que almacena las formas de ingreso
CREATE TABLE formas_ingresos (
    id_forma_ingreso INTEGER PRIMARY KEY,
    forma_ingreso VARCHAR(100) NOT NULL
);

-- Tabla que almacena las vigencias
CREATE SEQUENCE vigencias_id_seq;
CREATE TABLE vigencias (
    id_vigencia INTEGER PRIMARY KEY DEFAULT nextval('vigencias_id_seq'),
    vigencia VARCHAR(100) NOT NULL
);

-- Tabla que almacena los tipos de planes
CREATE SEQUENCE tipos_planes_id_seq;
CREATE TABLE tipos_planes (
    id_tipo_plan INTEGER PRIMARY KEY DEFAULT nextval('tipos_planes_id_seq'),
    tipo_plan VARCHAR(100) NOT NULL
);

-- Tabla que almacena los rangos de edades
CREATE SEQUENCE rango_edades_id_seq;
CREATE TABLE rango_edades (
    id_rango_edad INTEGER PRIMARY KEY DEFAULT nextval('rango_edades_id_seq'),
    rango_edad VARCHAR(50) NOT NULL
);

-- Tabla que almacena los géneros
CREATE SEQUENCE generos_id_seq;
CREATE TABLE generos (
    id_genero INTEGER PRIMARY KEY DEFAULT nextval('generos_id_seq'),
    genero VARCHAR(20) NOT NULL
);

-- Tabla que almacena los alumnos y sus relaciones con rangos de edad y géneros
CREATE TABLE alumnos (
    mrut VARCHAR(20) PRIMARY KEY,
    fecha_nacimiento DATE NOT NULL CHECK (fecha_nacimiento BETWEEN '1900-01-01' AND '2100-12-31'),
    rango_edad INTEGER NOT NULL,
    genero INTEGER NOT NULL,
    CONSTRAINT alumno_edad_fk FOREIGN KEY (rango_edad) REFERENCES rango_edades (id_rango_edad)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT alumno_genero_fk FOREIGN KEY (genero) REFERENCES generos (id_genero)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena la acreditación de carreras
CREATE TABLE acreditacion_carreras (
    id_acreditacion_carrera INTEGER PRIMARY KEY,
    acreditacion VARCHAR(50)
);

-- Tabla que almacena los niveles de carreras y su relación jerárquica
CREATE SEQUENCE niveles_carreras_id_seq;
CREATE TABLE niveles_carreras (
    id_nivel INTEGER PRIMARY KEY DEFAULT nextval('niveles_carreras_id_seq'),
    nivel CHAR(100),
    id_nivel_sup INTEGER NOT NULL,
    CONSTRAINT nivel_carrera_fk FOREIGN KEY (id_nivel_sup) REFERENCES niveles_carreras (id_nivel)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena la acreditación de instituciones
CREATE SEQUENCE acreditacion_instituciones_id_seq;
CREATE TABLE acreditacion_instituciones (
    id_acreditacion INTEGER PRIMARY KEY DEFAULT nextval('acreditacion_instituciones_id_seq'),
    acreditacion VARCHAR(50) NOT NULL
);

-- Tabla que almacena las modalidades
CREATE SEQUENCE modalidades_id_seq;
CREATE TABLE modalidades (
    id_modalidades INTEGER PRIMARY KEY DEFAULT nextval('modalidades_id_seq'),
    modalida VARCHAR(50) NOT NULL
);

-- Tabla que almacena los requisitos de ingreso
CREATE SEQUENCE requisitos_ingresos_id_seq;
CREATE TABLE requisitos_ingresos (
    id_requisitos INTEGER PRIMARY KEY DEFAULT nextval('requisitos_ingresos_id_seq'),
    requisitos VARCHAR(100) NOT NULL
);

-- Tabla que almacena los formatos de valores
CREATE SEQUENCE formatos_valores_id_seq;
CREATE TABLE formatos_valores (
    id_formato_valor INTEGER PRIMARY KEY DEFAULT nextval('formatos_valores_id_seq'),
    formato_valor VARCHAR(50) NOT NULL
);

-- Tabla que almacena los tipos de instituciones y su relación jerárquica
CREATE SEQUENCE tipos_instituciones_id_seq;
CREATE TABLE tipos_instituciones (
    id_tipo_institucion INTEGER PRIMARY KEY DEFAULT nextval('tipos_instituciones_id_seq'),
    tipo_institucion VARCHAR(100),
    id_tipo_inst_superior INTEGER NOT NULL,
    CONSTRAINT tipo_institucion_fk FOREIGN KEY (id_tipo_inst_superior) REFERENCES tipos_instituciones (id_tipo_institucion)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena las instituciones y sus relaciones con acreditaciones y tipos de instituciones
CREATE TABLE instituciones (
    id_institucion INTEGER PRIMARY KEY CHECK (id_institucion >= 0),
    institucion VARCHAR(150) NOT NULL,
    acreditada INTEGER NOT NULL CHECK (acreditada BETWEEN 0 AND 10),
    tipo_institucion INTEGER,
    CONSTRAINT institucion_acreditacion_fk FOREIGN KEY (acreditada) REFERENCES acreditacion_instituciones (id_acreditacion)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT institucion_tipo_fk FOREIGN KEY (tipo_institucion) REFERENCES tipos_instituciones (id_tipo_institucion)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Tabla que almacena las sedes y sus relaciones con instituciones y comunas
CREATE TABLE sedes (
    id_institucion INTEGER CHECK (id_institucion >= 0),
    id_sede INTEGER,
    sede VARCHAR(150),
    id_comuna INTEGER NOT NULL,
    CONSTRAINT sede_pk PRIMARY KEY (id_sede, id_institucion),
    CONSTRAINT sed_institucion_fk FOREIGN KEY (id_institucion) REFERENCES instituciones (id_institucion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT sede_fk FOREIGN KEY (id_comuna) REFERENCES comunas_sedes (id_comuna)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena las carreras y sus relaciones con instituciones, acreditaciones y niveles
CREATE TABLE carreras (
    id_institucion INTEGER NOT NULL CHECK (id_institucion >= 0),
    id_carrera INTEGER CHECK (id_carrera >= 0),
    carrera VARCHAR(250),
    acreditada INTEGER NOT NULL CHECK (acreditada BETWEEN 0 AND 10),
    nivel INTEGER NOT NULL,
    CONSTRAINT carrera_pk PRIMARY KEY (id_institucion, id_carrera),
    CONSTRAINT carrera_institucion_fk FOREIGN KEY (id_institucion) REFERENCES instituciones (id_institucion),
    CONSTRAINT carrera_acreditacion_fk FOREIGN KEY (acreditada) REFERENCES acreditacion_carreras (id_acreditacion_carrera)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_nivel_fk FOREIGN KEY (nivel) REFERENCES niveles_carreras (id_nivel)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena las versiones de carreras en sedes y sus relaciones con varias entidades
CREATE TABLE carreras_versiones_sedes (
    codigounico VARCHAR(50),
    id_institucion INTEGER NOT NULL CHECK (id_institucion >= 0),
    id_carrera INTEGER CHECK (id_carrera >= 0),
    id_sede INTEGER NOT NULL,
    id_jornada INTEGER NOT NULL,
    version INTEGER,
    formaingreso INTEGER NOT NULL,
    modalidad INTEGER NOT NULL,
    vigente INTEGER NOT NULL,
    tipoplan INTEGER NOT NULL,
    requisitoingreso INTEGER NOT NULL,
    CONSTRAINT carrera_sedes_pk PRIMARY KEY (codigounico),
    CONSTRAINT carrera_institucion_fk FOREIGN KEY (id_institucion, id_carrera) REFERENCES carreras (id_institucion, id_carrera)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_sede_fk FOREIGN KEY (id_sede, id_institucion) REFERENCES sedes (id_sede, id_institucion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_jornada_fk FOREIGN KEY (id_jornada) REFERENCES jornadas (id_jornadas)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_ingreso_fk FOREIGN KEY (formaingreso) REFERENCES formas_ingresos (id_forma_ingreso)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_modalidad_fk FOREIGN KEY (modalidad) REFERENCES modalidades (id_modalidades)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_vigente_fk FOREIGN KEY (vigente) REFERENCES vigencias (id_vigencia)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_plan_fk FOREIGN KEY (tipoplan) REFERENCES tipos_planes (id_tipo_plan)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT carrera_requisito_fk FOREIGN KEY (requisitoingreso) REFERENCES requisitos_ingresos (id_requisitos)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabla que almacena los costos de las carreras en versiones de sedes y sus relaciones con varias entidades
CREATE TABLE costos_carrvrsedes (
    periodo INTEGER NOT NULL,
    codigounico VARCHAR(50) NOT NULL,
    valormatricula INTEGER NOT NULL CHECK (valormatricula >= 0),
    valorarancel INTEGER NOT NULL CHECK (valorarancel >= 0),
    costoprocacred INTEGER NOT NULL CHECK (costoprocacred >= 0),
    costodiplomas INTEGER NOT NULL CHECK (costodiplomas >= 0),
    tipomoneda INTEGER NOT NULL,
    CONSTRAINT costo_pk PRIMARY KEY (periodo),
    CONSTRAINT costo_codigo_fk FOREIGN KEY (codigounico) REFERENCES carreras_versiones_sedes (codigounico)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT costo_moneda_fk FOREIGN KEY (tipomoneda) REFERENCES formatos_valores (id_formato_valor)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Tabla que almacena las matrículas y sus relaciones con alumnos y versiones de carreras en sedes
CREATE TABLE matriculas (
    mrut VARCHAR(20),
    codigounico VARCHAR(50),
    anno_ing_carrera_ori INTEGER CHECK (anno_ing_carrera_ori > 2024),
    semestre_ing_carrera_ori INTEGER CHECK (semestre_ing_carrera_ori BETWEEN 1 AND 5),
    anno_ing_carrera_actual INTEGER CHECK (anno_ing_carrera_actual >= anno_ing_carrera_ori),
    sem_ing_carrera_actual INTEGER CHECK (sem_ing_carrera_actual BETWEEN 1 AND 5),
    CONSTRAINT matriculas_pk PRIMARY KEY (mrut, codigounico),
    CONSTRAINT matriculas_alumno_fk FOREIGN KEY (mrut) REFERENCES alumnos (mrut)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT matriculas_curso_fk FOREIGN KEY (codigounico) REFERENCES carreras_versiones_sedes (codigounico)
        ON UPDATE CASCADE ON DELETE RESTRICT
);