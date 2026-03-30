// Permanently delete a subject by its UUID, requires ownership verification
query "subjects/{id}" verb=DELETE {
  api_group = "subjects"
  auth = "user"

  input {
    // Subject UUID
    uuid id
  }

  stack {
    // Verify the subject exists and belongs to the authenticated account
    db.query subject {
      where = $db.subject.id == $input.id && $db.subject.account_id == $auth.account_id
      return = {type: "single"}
    } as $subject
  
    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found or does not belong to you."
    }
  
    conditional {
      if ($auth.role != "admin") {
        precondition ($subject.user_id == $auth.id) {
          error_type = "forbidden"
          error = "Access denied"
        }
      }
    }
  
    // Soft-delete by status = archived
    db.patch subject {
      field_name = "id"
      field_value = $input.id
      data = {status: "archived", updated_at: now}
    }
  
    // Log the deletion
    debug.log {
      value = {
        event     : "subject_deleted"
        subject_id: $input.id
        user_id   : $auth.id
        account_id: $auth.account_id
      }
    }
  }

  response = null
}