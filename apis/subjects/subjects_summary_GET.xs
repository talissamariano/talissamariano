// Resumo de subjects do usuário autenticado
query "subjects/summary" verb=GET {
  api_group = "subjects"
  auth = "user"

  input {
  }

  stack {
    db.query subject {
      where = $db.subject.account_id == $auth.account_id && $db.subject.user_id == $auth.id
      return = {type: "list"}
    } as $subjects
  }

  response = $subjects
}