# Delegar

Más razonamiento → mejor modelo. Otro motor → otra forma de pensar (útil para revisiones y diseño).

## Dos vías

1. **Subagente nativo** (Agent tool, en esta sesión): rápido y comparte el entorno. `model`: `haiku` (barato), `sonnet` (medio), `opus` (fuerte), `fable` (máximo). Úsalo para buscar y para trabajo paralelo con Claude.
2. **Otra sesión** (`delegar.mjs`): otro motor u otro modelo, en frío. Úsalo para segundas opiniones, direcciones de diseño alternativas o para repartir cuota.

```bash
node DIR/scripts/delegar.mjs --nivel <barato|medio|fuerte|maximo> --motor <claude|codex|opencode|agy> [--agente <id>] [--escribir] [--dir <ruta>] [--dry] "encargo"
```
- **Solo lectura por defecto.** `--escribir` crea un `git worktree` nuevo (`../<repo>.filigrana/<id>`, rama `filigrana/<id>`) y trabaja ahí: nunca toca el árbol actual. El merge lo hace el usuario.
- Imprime solo la respuesta final; la salida completa queda en el log que indica.
- Para paralelizar, lánzalos con Bash en segundo plano (`run_in_background`) y espera a la notificación; no hagas polling.
- `--dry` muestra el comando sin ejecutarlo.
- `--agente <id>` (proyectos con el kit): antepone "Actúa según `.agents/agents/<id>/agent.md`" y usa el `nivel` de la ficha si no pasas `--nivel`. Si la ficha tiene `nivel_codex`, ese manda cuando el motor es `codex` (y en los `.codex/agents/*.toml` generados).

## Modelos

El modelo de cada nivel y motor está en `scripts/niveles.json` (fuente única: léelo ahí, no lo copies aquí). `fuerte` y `maximo` de opencode necesitan saldo. `agy` usa siempre Gemini, para que aporte una forma de pensar distinta de la de Claude.

En Codex, con el plan Plus (20 $) la cuota se agota antes que el dinero. Estimaciones de OpenAI en mensajes cada 5 h: Luna 350–3.000, Sol 15–160, Astra 5–45; consulta la tuya con `/status`.

- **Luna** para buscar, resumir y commits: su cuota es unas 20 veces la de Sol. Además, 6.2 Sol rinde peor que 6.1 contestando preguntas sobre el código (se le escapan datos clave).
- **Sol** para todo lo demás. En código queda a medio punto de Astra por una quinta parte del coste.
- **Astra** solo a esfuerzo `low`: cada token cuesta 4 veces lo de Sol y en Plus se agota en pocos turnos. Nunca `xhigh`.

## Qué motor para qué (por defecto)

| Tarea | Nivel | Motor |
|---|---|---|
| Buscar, localizar, resumir | barato | subagente nativo `haiku` (o `opencode` gratis para no gastar cuota) |
| Construir, depurar con causa clara | medio | esta sesión |
| Revisión de un diff | fuerte | esta sesión. Añade `codex` en paralelo **solo** si el diff toca BD, seguridad o credenciales, o si lo pide el usuario |
| Auditoría completa | fuerte | esta sesión. `codex` en paralelo con la misma condición |
| Bug sin causa tras 2 hipótesis | fuerte | `codex` |
| Direcciones de diseño | fuerte | esta sesión + `codex` + `agy` (tres modelos distintos) |
| Arquitectura, datos, seguridad, decisiones irreversibles | maximo | subagente `fable` o `--motor claude --nivel maximo`; como contraste, **una** llamada a `codex --nivel maximo` por decisión |

## Ahorro de cuota (pensado para planes de 20 $)

- Antes de lanzar `maximo` en Codex, mira `/status`. Si queda poca cuota, baja a `fuerte`.
- Escribe el encargo con un prefijo fijo (objetivo, rutas, restricciones) y no lo reescribas entre llamadas: así se reaprovecha la caché.
- No pases de 272K tokens de entrada: por encima, Astra cobra el doble por la entrada y 1,5 veces por la salida en toda la petición. Pasa rutas, no ficheros enteros.
- Esfuerzo `low` salvo que la tarea pida más. Un esfuerzo más alto gasta más cuota y no siempre mejora el resultado.

## Encargo autocontenido

La sesión nueva no sabe nada de esta conversación. Incluye siempre:
1. **Objetivo** en una frase.
2. **Dónde**: rutas y líneas concretas.
3. **Lo ya sabido o descartado** (no le hagas repetir trabajo).
4. **Restricciones**: solo lectura, sin refactors, reglas del proyecto que apliquen.
5. **Formato de entrega** corto y concreto (tabla, una línea por hallazgo, máximo N líneas).

## Notas por motor

- **claude**: `-p --permission-mode plan` en solo lectura.
- **codex**: sandbox `read-only`; deja su último mensaje en un fichero, que es lo que se imprime.
- **opencode**: agente `plan`. Los modelos de pago de OpenCode Zen fallan con "Insufficient balance" si no hay saldo: en ese caso usa `barato`/`medio`, o cambia el modelo en `niveles.json`.
- **agy**: modo `plan`. En headless, cualquier comando de terminal se deniega y **aborta sin salida**; el script ya le pide que solo lea ficheros. Si devuelve "sin respuesta", mira el log.

Lo que devuelve otro modelo es su opinión, no la verdad: verifica con evidencia antes de actuar.
