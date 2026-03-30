# Specs: subjects-module

## Objetivo do módulo
Especificar contratos de API, regras e comportamentos esperados para o gerenciamento de disciplinas por usuário.

## API: POST /subjects
Input:
- name: text, required, 1..255
- code?: text, opcional, 1..50
- description?: text, opcional
- instructor?: text, opcional
- start_date?: date, opcional
- end_date?: date, opcional, deve ser >= start_date
- status?: enum([active, completed, archived]), default active
- color_tag?: text, opcional, `#RRGGBB`
- credits?: decimal, opcional, 0..12

Output:
- objeto subject cadastrado com campos do sistema, incluindo `user_id`, `created_at`, `updated_at`

Validações:
- `name` não pode estar vazio
- `name` único por `user_id`
- `code` único por `user_id` quando presente
- `end_date >= start_date`
- `color_tag` no formato hex
- `credits` entre 0 e 12

Erros:
- 400 inputerror (violação de regras)

## API: GET /subjects
Input: nenhum
Output: lista de disciplines do usuário logado

## API: GET /subjects/{id}
Input: id (uuid)
Output: subject se encontrado e pertence ao usuário
Erros:
- 404 notfound se não existe ou não pertence

## API: PATCH /subjects/{id}
Input:
- id (uuid)
- name?: text
- code?: text
- description?: text
- instructor?: text
- start_date?: date
- end_date?: date
- status?: enum([active, completed, archived])
- color_tag?: text
- credits?: decimal

Output: objeto atualizado
Erros:
- 403/404 para acesso/registro não pertencente
- 400 para validações falhas

## API: DELETE /subjects/{id}
Input: id (uuid)
Output: null
Erros:
- 403/404 se não pertence ou não existe

## API: GET /subjects/summary
Output: resumo com totais:
- total_subjects, active, completed, archived, total_credits

## Regras de negócio gerais
- `user_id` de referencia a owner
- só o dono pode manipular seus subjects
- dados de cada usuário isolados (multitenancy por user)

## Erros gerais
- 400 inputerror
- 403 accessdenied
- 404 notfound

