// Update a subject
query "subjects/{id}" verb=PATCH {
  api_group = "subjects"
  auth = "user"

  input {
    // Subject UUID
    uuid id
  
    // Updated name of the subject
    text name? filters=trim
  
    // Updated status of the subject
    enum status? {
      values = ["active", "completed", "archived"]
    }
  }

  stack {
    // Check existence and account membership
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
  
    // Prepare update data
    var $update_data {
      value = {updated_at: now}
    }
  
    conditional {
      if ($input.name != null) {
        var.update $update_data {
          value = $update_data|set:"name":$input.name
        }
      }
    }
  
    conditional {
      if ($input.status != null) {
        var.update $update_data {
          value = $update_data|set:"status":$input.status
        }
      }
    }
  
    // Update the subject
    db.patch subject {
      field_name = "id"
      field_value = $input.id
      data = $update_data
    }
  
    // Return updated subject
    db.query subject {
      where = $db.subject.id == $input.id
      return = {type: "single"}
    } as $updated_subject
  }

  response = $updated_subject
}