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
- `--agente <id>` (proyectos con el kit): antepone "Actúa según `.agents/agents/<id>/agent.md`" y usa el `nivel` de la ficha si no pasas `--nivel`.

## Modelos

El modelo de cada nivel y motor está en `scripts/niveles.json` (fuente única: léelo ahí, no lo copies aquí). `fuerte` y `maximo` de opencode necesitan saldo. `agy` usa siempre Gemini, para que aporte una forma de pensar distinta de la de Claude.

## Qué motor para qué (por defecto)

| Tarea | Nivel | Motor |
|---|---|---|
| Buscar, localizar, resumir | barato | subagente nativo `haiku` (o `opencode` gratis para no gastar cuota) |
| Construir, depurar con causa clara | medio | esta sesión |
| Revisión de un diff importante | fuerte | esta sesión + `codex` en paralelo |
| Auditoría completa | fuerte | esta sesión + `codex` en paralelo |
| Bug sin causa tras 2 hipótesis | fuerte | `codex` |
| Direcciones de diseño | fuerte | esta sesión + `codex` + `agy` (tres modelos distintos) |
| Arquitectura, datos, seguridad, decisiones irreversibles | maximo | subagente `fable` o `--motor claude --nivel maximo`, y `codex --nivel maximo` como contraste |

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
