# 🌫️ Monitoreo de Calidad del Aire - Bogotá (RMCAB)

Aplicación interactiva desarrollada en **R Shiny** para la visualización y análisis técnico de datos de la Red de Monitoreo de Calidad del Aire de Bogotá (RMCAB).

El objetivo es facilitar la interpretación de contaminantes mediante herramientas de análisis ambiental y visualización avanzada.

---

# 🧱 Estructura del Proyecto

* **app.R** → Punto de entrada de la aplicación
* **functions/** → Lógica de descarga y procesamiento de datos
* **modules/** → Componentes de cada pestaña
* **renv.lock** → Control de versiones de librerías (CRÍTICO)

---

# ⚙️ Instalación y Configuración

## 1. Clonar el repositorio

### 🔹 Opción 1: RStudio

* File → New Project
* Version Control → Git
* Pegar la URL del repositorio (https://github.com/mateeof/App_Calidad_Aire.git)

### 🔹 Opción 2: Terminal

```bash
git clone https://github.com/mateeof/App_Calidad_Aire.git
```

---

## 2. Configurar el entorno

```r
install.packages("renv")
renv::restore()
```

---

# 📦 Importancia de `renv.lock`

El archivo `renv.lock` asegura que todos trabajen con **las mismas versiones de librerías**.

* ✅ Garantiza reproducibilidad
* ❌ Sin esto, el proyecto puede fallar en otras máquinas

---

# 🧪 Flujo de Trabajo con Git

👉 Puedes usar **RStudio o la terminal**, ambos hacen exactamente lo mismo.

---

## 🧭 1. Traer cambios (Pull)

### 🔹 En RStudio

* Click en **Pull (flecha azul)**

### 🔹 En terminal

```bash
git pull origin main
```

## 🌿 2. Crear una rama (Branch)

⚠️ Nunca trabajar directamente en `main`

### 🔹 En terminal

```bash
git checkout -b nombre_de_tu_rama
```

### 🔹 En RStudio

* Ir a pestaña Git
* New Branch
* Escribir: `nombre_de_tu_rama`

👉 Esto crea una copia de `main` donde puedes trabajar sin afectar el proyecto principal.


## 🧠 ¿Cómo funcionan las ramas?

* `main` → versión estable
* `nombre_de_tu_rama` → tu espacio de trabajo

Puedes experimentar sin romper nada del proyecto principal.

---

## 💾 3. Guardar cambios (Commit) y subir (Push)

### 🔹 En RStudio

1. En la pestaña **Git**, ubica el botón al lado de la flecha azul (Pull) llamado
   **“Commit (Commit pending changes)”** y haz clic ahí.

2. Se abrirá una ventana donde debes:

   * Seleccionar (✔️) los archivos modificados que quieres subir (*Stage*)
   * Revisar los cambios si es necesario

3. En el campo de mensaje, escribe una descripción clara de los cambios realizados.

4. Haz clic en el botón **Commit**.

5. Luego, vuelve a la ventana principal y haz clic en la flecha verde (**Push**) para subir los cambios al repositorio.

### 🔹 En terminal

```bash
git add .
git commit -m "Descripción de los cambios"
git push origin nombre_de_tu_rama
```

# ⚠️ Si agregas librerías (MUY IMPORTANTE)

Cada vez que instales una nueva librería, **debes actualizar el archivo `renv.lock`**.

👉 Si no haces esto, otras personas del equipo pueden tener errores al ejecutar el proyecto, porque no tendrán instaladas las mismas dependencias.

---

## 🔧 Pasos obligatorios

```r
install.packages("nuevo_paquete")
renv::snapshot()
```

Luego guarda los cambios en Git:

```bash
git add renv.lock
git commit -m "Actualiza dependencias"
```
## 🧠 ¿Por qué es tan importante?

* `renv.lock` guarda las versiones exactas de las librerías
* Permite que el proyecto funcione igual en todos los equipos
* Evita errores como “a mí sí me corre”

## 🚨 Regla clave del proyecto

👉 **Si agregas una librería y no actualizas `renv.lock`, puedes romper el entorno de los demás.**

## 🎯 Buen hábito

Cada vez que veas un `install.packages()` en tus cambios, pregúntate:
✔️ ¿ya hice `renv::snapshot()`?

---

# 🔄 Flujo completo de trabajo

1. **Pull (Actualizar tu proyecto)**
   Trae los últimos cambios desde `main` para trabajar siempre sobre la versión más reciente.

2. **Crear rama (Tu espacio de trabajo)**
   Crea una rama con el nombre `nombre_de_tu_rama`.
   👉 No necesitas crear una rama cada vez que abras el proyecto.
Si ya tienes una rama creada, simplemente vuelves a ella y continúas trabajando ahí hasta terminar esa tarea.

3. **Hacer cambios (Desarrollo)**
   Trabaja en tu rama: agrega funcionalidades, corrige errores o mejora el código sin afectar `main`.

4. **Commit (Guardar cambios)**
   Registra tus cambios con un mensaje claro y descriptivo.
   👉 Esto permite que el equipo entienda qué hiciste y por qué.

5. **Push (Subir cambios)**
   Envía tu rama al repositorio en GitHub para que otros puedan verla.

6. **Pull Request (Revisión y aprobación)**
   Abres un Pull Request en GitHub.
   👉 El líder del equipo revisa los cambios y decide si se integran a `main`.



# 📊 Funcionalidades de la Aplicación

La aplicación cuenta con diferentes módulos diseñados para analizar la calidad del aire desde múltiples perspectivas:

---

### 📍 Mapa Interactivo

Visualiza la ubicación de las estaciones de monitoreo en Bogotá.
Cada punto muestra el **contaminante predominante en las últimas 24 horas**, permitiendo identificar rápidamente las zonas más afectadas.

👉 Ideal para tener una visión espacial del estado actual del aire en la ciudad.

---

### 📈 Time Variation

Permite analizar cómo cambian las concentraciones de contaminantes a lo largo del tiempo.

👉 Puedes observar tendencias, picos de contaminación y patrones diarios o horarios.

---

### 🌹 Pollution Rose

Relaciona la **dirección del viento** con la concentración de contaminantes.

👉 Ayuda a entender hacia dónde se desplazan los contaminantes y posibles fuentes de emisión.

---

### 📉 Corplot

Muestra una **matriz de correlación** entre variables ambientales (contaminantes, clima, etc.).

👉 Permite identificar relaciones entre variables, como por ejemplo:

* Temperatura vs contaminantes
* Viento vs dispersión

---

### 🎬 Mapa Animado *(En desarrollo)*

Visualización dinámica que muestra cómo evoluciona la contaminación en el tiempo sobre el mapa.

👉 Permitirá analizar la **dispersión de contaminantes** de forma visual e intuitiva.

---


# 🎯 Objetivo

Crear una herramienta robusta, reproducible y colaborativa para analizar la calidad del aire en Bogotá.

---
