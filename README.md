# Filigranas

Kit de agentes y skills para trabajar con **Claude Code, Codex, OpenCode y Antigravity**. Incluye ocho roles, instrucciones compartidas y scripts para instalar y sincronizar sus configuraciones en otros repositorios.

## Requisitos

- Node.js 18 o superior.
- Git.

## Instalar solo la skill `filigrana`

Un comando, en cualquier máquina con git (macOS o Linux). Queda disponible en todos los proyectos de Claude Code y repetirlo la actualiza:

```bash
curl -fsSL https://raw.githubusercontent.com/BilalGates/filigranas/main/instalar.sh | sh
```

Clona el repo en `~/.filigranas` (cámbialo con `FILIGRANAS_DIR`) y enlaza la skill en `~/.claude/skills` (o en `$CLAUDE_CONFIG_DIR/skills`). Si ya hay una carpeta `filigrana` propia, no la pisa. Sus scripts necesitan Node 18+.

## Usar `filigrana`

Claude Code la carga solo cuando el encargo es escribir o cambiar código no trivial; para preguntas, explicaciones o cambios de una línea no hace falta. También puedes llamarla tú con `/filigrana [modo] [encargo]` o nombrarla en el mensaje:

| Modo | Para qué | Ejemplo |
|---|---|---|
| `diseña` | UI nueva o rediseño con gusto propio, sin el aspecto por defecto de la IA | `/filigrana diseña la landing de precios` |
| `depura` | Bug, test rojo o CI roto, con el diff más pequeño posible | `/filigrana depura el test de login que falla` |
| `audita` | Rendimiento, código muerto y deuda, con medidas | `/filigrana audita por qué va lento el dashboard` |
| `revisa` | Revisar un diff o una PR | `/filigrana revisa la PR 12` |
| `delega` | Segunda opinión o tarea en paralelo en claude, codex, opencode o agy | `/filigrana delega a codex una revisión de auth` |

Si no dices el modo, lo deduce del encargo. En todos los modos aplica las mismas reglas:

- **Código mínimo (ponytail)**: antes de escribir comprueba si hace falta, si ya existe en el repo, en la librería estándar o en la plataforma. Los atajos deliberados quedan marcados con `ponytail:` para retomarlos luego (`/filigrana audita qué dejamos para luego`).
- **Ahorro de tokens**: busca antes de leer, no relee, recorta las salidas, lanza en paralelo las llamadas independientes y responde corto.

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
