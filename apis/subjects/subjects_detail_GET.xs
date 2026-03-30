// Retrieve a single subject by ID for the authenticated user
query "subjects/{id}" verb=GET {
  api_group = "subjects"
  auth = "user"

  input {
    // Subject UUID
    uuid id
  }

  stack {
    db.query subject {
      where = $db.subject.id == $input.id && $db.subject.account_id == $auth.account_id
      return = {type: "single"}
    } as $subject
  
    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found or access denied"
    }
  
    conditional {
      if ($auth.role != "admin") {
        precondition ($subject.user_id == $auth.id) {
          error_type = "forbidden"
          error = "Access denied"
        }
      }
    }
  }

  response = $subject
}