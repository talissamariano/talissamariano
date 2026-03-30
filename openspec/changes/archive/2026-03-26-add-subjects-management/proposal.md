# Proposal: subjects-module

## Objetivo
Construir a base do aplicativo de acompanhamento de desempenho acadêmico com foco em gestão de disciplinas por aluno.

## Visão
O sistema permitirá que estudantes registrem, atualizem e acompanhem suas disciplinas de estudo de forma isolada e segura, com dados segmentados por usuário.

## Justificativa
- Alunos precisam de uma vista centralizada das disciplinas em andamento e concluídas
- Cada aluno deve ter controle exclusivo de suas próprias disciplinas
- Sistema preparado para evolução em relatórios, indicadores de progresso e notificações

## Escopo inicial
- Definir tabela `subject` com relacionamento 1:N para `user`
- Criar APIs CRUD para `subject` (list, create, detail, update, delete)
- Garantir validações de dados essenciais (uniqueness, datas, formato)
- Preparar task agendada para status de conclusão/arquivamento
- Criar spec e tasks para implementação e testes

## Não escopo inicial
- Módulo de notas de avaliação (ainda não)
- Integrações externas (calendar, LMS)

## Critérios de aceitação
- Rotas funcionais com autenticação de usuário
- Propriedade do registro por `user_id`
- Isolamento de dados entre usuários
- Regras de validação aplicadas e documentadas
- Plano de testes definido em `workflow_tests`

