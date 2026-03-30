# Design: subjects-module

## Contexto do aplicativo
Sistema de acompanhamento de desempenho acadêmico para alunos individuais, onde cada usuário gerencia seu conjunto de disciplinas.

## Entidades
### User (Aluno)
- já fornecido pelo sistema de auth
- armazena identificação, email e credenciais

### Subject (Disciplina)
Campos propostos:
- id (uuid, PK)
- user_id (uuid, FK -> user)
- name (text, required)
- code (text, opcional)
- description (text, opcional)
- instructor (text, opcional)
- start_date (date, opcional)
- end_date (date, opcional)
- status (enum: active, completed, archived) default active
- color_tag (text, opcional, #RRGGBB)
- credits (decimal, opcional)
- created_at (timestamp)
- updated_at (timestamp)

Índices sugeridos:
- primary(id)
- unique(user_id, name)
- unique(user_id, code)
- btree(user_id, status)

## APIs
- GET /subjects (lista do user)
- POST /subjects (cria com user_id do auth)
- GET /subjects/{id} (detalhe de user)
- PATCH /subjects/{id} (atualiza se dono)
- DELETE /subjects/{id} (remove se dono)
- GET /subjects/summary (agregação por usuário)

## Fluxos de negócio
1. usuário autênticado cria uma disciplina => user_id preenchido pelo auth
2. usuário lista apenas disciplinas dele
3. não pode criar duas com mesmo name ou code no mesmo user
4. atualiza status/dados da disciplina
5. exclusão somente do owner

## Validações
- name: required, não vazio, max 255
- code: opcional, max 50
- end_date >= start_date (se ambos setados)
- color_tag: `^#[0-9A-Fa-f]{6}$` quando fornecido
- credits: 0..12

## Automatizações iniciais
- tarefa agendada para arquivar `active` expiradas por end_date
- endpoint de resumo com total/por status/credits

