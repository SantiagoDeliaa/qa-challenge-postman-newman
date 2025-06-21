# QA API Challenge - Postman + Newman

Automatización de pruebas del recurso `/pet` de la API [Swagger Petstore](https://petstore.swagger.io/) usando **Postman** y **Newman** dentro de un Docker.

---

## Instalación y ejecución con Docker

### Prerequisitos
- **Docker** (version 20.x o superior)
- **Git** 

1. Clonar o descargar el repo y pararse en la carpeta raiz.
2. Ejecutar las pruebas con Docker:

```bash
# Construir la imagen Docker
docker build -t newman-html .

# Ejecutar las pruebas de la colección
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

> Notas: La API es bastante inconsistente, sobre todo en las consultas despues de una modificación.
---

## Explicación de cada caso de prueba

### Happy Path CRUD 
- Se utilizan datos validos.
- Se genera dinámicamente un ID en el `pre-request` para las pruebas.
- Se testea que se pueda:
  - Crear una mascota (`POST`)
    - Se verifica mediante asserts el object del response (status code, id, name, tag, etc)
  - El filtro por "Status" traiga el response correspondiente a lo que indica Swagger (`GET`)
    - Se verifica mediante un forEach que recorre el response que todos los status sean los filtrados ('pending')
  - Actualizar los datos de la mascota previamente creada (`PUT`)
    - Se verifica que los datos se actualizaron correctamente
  - Consultar mascota (`GET`)
    - Verificación de id creado
  - Eliminar (`DELETE`)
    - Se verifica en el script que el id eliminado sea el previamente generado
  - El recurso eliminado ya no se pueda encontrar (`GET`)
    - Se corrobora que id no exista (404 Not Found)
   
---

## CI/CD

### GitHub Actions (Validaciones Automatizadas)
- Integre este flujo a GitHub Actions para que corra la colección.
- Cada vez que se realiza un `push` o `pull request`, se ejecuta Newman sobre la colección de Postman dentro de un contenedor Docker.
- Publica el artefacto `report.html` con el resultado de las pruebas.
- Redultado: validar de forma continua la integridad del endpoint `/pet`.
- Archivo de workflow: .github/workflows/newman-tests.yml

---
