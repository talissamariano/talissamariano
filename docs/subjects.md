# Subjects API

Endpoints:
- GET /subjects/my
- GET /subjects/account
- POST /subjects
- GET /subjects/{id}
- PATCH /subjects/{id}
- DELETE /subjects/{id}
- GET /subjects/summary

Assegura que todos os requests usem `auth=user`.

Validações principais:
- `name` obrigatório e único por usuário
- `code` opcional e único por usuário
- `color_tag` no formato `#RRGGBB`
- `end_date >= start_date`
- `credits` de 0 a 12

Atributos:
- user_id (quando criado: $auth.id)
- status: active/completed/archived
