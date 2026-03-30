// List subjects for the authenticated user (my subjects)
query subjects_my verb=GET {
  api_group = "subjects"
  auth = "user"

  input {
  }

  stack {
    db.query subject {
      where = $db.subject.account_id == $auth.account_id && $db.subject.user_id == $auth.id && $db.subject.status != "archived"
      return = {type: "list"}
    } as $subjects
  }

  response = $subjects
}