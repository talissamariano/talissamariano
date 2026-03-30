// List all subjects for the authenticated account (admin or manager access)
query subjects_account verb=GET {
  api_group = "subjects"
  auth = "user"

  input {
  }

  stack {
    db.query subject {
      where = $db.subject.account_id == $auth.account_id
      return = {type: "list"}
    } as $subjects
  }

  response = $subjects
}