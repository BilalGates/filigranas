# Filigranas

Kit de agentes y skills para trabajar con **Claude Code, Codex, OpenCode y Antigravity**. Incluye ocho roles, instrucciones compartidas y scripts para instalar y sincronizar sus configuraciones en otros repositorios.

## Requisitos

- Node.js 18 o superior.
- Git.

## Instalación en un proyecto

Clona este repositorio una vez y ejecuta el instalador **desde el proyecto de destino**:

```bash
git clone https://github.com/BilalGates/filigranas.git
cd /ruta/a/tu-proyecto
node /ruta/a/filigranas/kit-agentes/scripts/agentes/instalar.mjs
```

El instalador copia el kit a la raíz del repositorio, crea `CLAUDE.md` si falta, genera la configuración de los agentes y activa los hooks de Git si no hay otro gestor configurado. Si el proyecto ya tiene un `AGENTS.md` propio, lo traslada a `.agents/proyecto.md`; si este último también existe, pide resolver el conflicto antes de continuar. Puedes repetir el comando para actualizar el kit.

Después, abre el proyecto con una de las herramientas compatibles y pide: **«Pep, haz la inducción del proyecto»**. La inducción documenta el contexto y los comandos específicos en `.agents/proyecto.md`.

Las skills `impeccable` y `supabase-postgres-best-practices` son opcionales. Para incluirlas en la instalación, añade `impeccable` o `supabase` al comando:

```bash
node /ruta/a/filigranas/kit-agentes/scripts/agentes/instalar.mjs impeccable supabase
```

## Mantenimiento del kit instalado

Edita las fichas de agentes y las skills en `.agents/`; los archivos de `.claude/`, `.codex/` y `.opencode/` se generan a partir de esa fuente. Desde la raíz del proyecto donde instalaste el kit:

```bash
node scripts/agentes/sincronizar.mjs          # regenera la configuración
node scripts/agentes/sincronizar.mjs --check  # comprueba si está sincronizada
node scripts/agentes/agrupar-commits.mjs      # propone grupos sin modificar Git
```

Los hooks de Git avisan sobre reglas del proyecto y mensajes de commit, pero no bloquean el commit. El instalador no sustituye un gestor de hooks ya configurado.

## Documentación

Consulta [la guía del kit](kit-agentes/LEEME-KIT.md) para conocer los roles, la estructura de archivos y la forma de extenderlo. Las instrucciones que se copian a cada proyecto están en [AGENTS.md](kit-agentes/AGENTS.md).
