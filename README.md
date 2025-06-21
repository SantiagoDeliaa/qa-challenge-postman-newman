# QA API Challenge - Swagger Petstore (Postman + Newman)

Automatización de pruebas del recurso `/pet` de la API [Swagger Petstore](https://petstore.swagger.io/), usando **Postman** y **Newman** dentro de un entorno Docker.

---

## Objetivo

- Validar mediante automation las operaciones CRUD del endpoint `/pet`:
  - `POST`, `GET`, `PUT`, `DELETE`
- Ejecución `Newman`
- Generar un **reporte HTML**
- Dejar preparado para integración con CI/CD

---

## Estructura del repositorio

```
qa-challenge-postman-newman/
├── CRUD-Challenge.postman_collection.json       
├── CRUD-Challenge.postman_environment.json      
├── Dockerfile                                   
├── report.html                                                               
└── README.md
```

---

## Instalación y ejecución con Docker

### Prerequisitos
- **Docker** (version 20.x o superior)
- **Git** 

1. Clonar o descargar el repo y pararse en la carpeta raiz.
2. Ejecutar las pruebas con Docker:

```bash
docker build -t newman-html .
docker run --rm -v "${PWD}:/etc/newman" newman-html \
  run /etc/newman/CRUD-Challenge.postman_collection.json \
  --environment /etc/newman/CRUD-Challenge.postman_environment.json \
  --reporters cli,html \
  --reporter-html-export /etc/newman/report.html \
  --delay-request 4000    # Añado este delay porque la api respondia bastante lento
```
> En PowerShell reemplazar `${PWD}` por `%cd%`

> Van a poder ver el resultado por consola y además genera `report.html` en la carpeta actual.

> No hace falta npm/node local: la imagen Docker ya incluye Newman + reporter HTML.

---

## Explicación de cada caso de prueba

- Se genera dinámicamente un ID en el `pre-request` para las pruebas.
- Se testea que se pueda:
  - Crear una mascota (`POST`)
  - Consultarla (`GET`)
  - Actualizar los datos (`PUT`)
  - Eliminarla (`DELETE`)
- También valido que:
  - El recurso eliminado ya no se pueda encontrar
  - El get por "Status" traiga el response correspondiente a lo que indica Swagger

---

## CI/CD

- Integrar este flujo a GitHub Actions.
- Seviria para ejecutar automáticamente en cada push o pull request.
- Publicar el artefacto `report.html` como evidencia.

---

> Challenge resuelto por Santi, saludos!!!
