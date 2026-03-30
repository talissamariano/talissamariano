// Create a new subject for the authenticated user
query subjects_create verb=POST {
  api_group = "subjects"
  auth = "user"

  input {
    // Name of the subject, required and unique per user
    text name filters=trim|min:1|max:255
  
    // Optional code for the subject, unique per user if provided
    text code? filters=trim|min:1|max:50
  
    // Optional description of the subject
    text description? filters=max:2000
  
    // Optional instructor name
    text instructor? filters=trim|min:1|max:255
  
    // Optional start date of the subject
    date start_date?
  
    // Optional end date of the subject, must be >= start_date if both provided
    date end_date?
  
    // Optional credits for the subject, between 0 and 12
    decimal credits? filters=min:0|max:12
  
    // Optional hex color tag for the subject (#RRGGBB)
    text color_tag?
  }

  stack {
    // Validate color_tag if provided
    conditional {
      if ($input.color_tag != null) {
        // Validate color_tag is a valid hex color
        precondition ($input.color_tag|regex_matches:"^#[0-9A-Fa-f]{6}$") {
          error_type = "inputerror"
          error = "color_tag must be a valid hex color in format #RRGGBB"
        }
      }
    }
  
    // Validate end_date >= start_date if both provided
    conditional {
      if ($input.start_date != null && $input.end_date != null) {
        // Validate end_date is not before start_date
        precondition ($input.end_date >= $input.start_date) {
          error_type = "inputerror"
          error = "end_date must be on or after start_date"
        }
      }
    }
  
    // Check uniqueness of name for this user
    db.query subject {
      where = $db.subject.user_id == $auth.id && $db.subject.name == $input.name
      return = {type: "exists"}
    } as $name_exists
  
    // Ensure name is unique per user
    precondition ($name_exists == false) {
      error_type = "inputerror"
      error = "A subject with this name already exists for your account"
    }
  
    // Check uniqueness of code for this user if provided
    conditional {
      if ($input.code != null) {
        db.query subject {
          where = $db.subject.user_id == $auth.id && $db.subject.code == $input.code
          return = {type: "exists"}
        } as $code_exists
      
        // Ensure code is unique per user if provided
        precondition ($code_exists == false) {
          error_type = "inputerror"
          error = "A subject with this code already exists for your account"
        }
      }
    }
  
    // Insert the new subject
    db.add subject {
      data = {
        account_id : $auth.account_id
        user_id    : $auth.id
        name       : $input.name
        code       : $input.code
        description: $input.description
        instructor : $input.instructor
        start_date : $input.start_date
        end_date   : $input.end_date
        status     : "active"
        credits    : $input.credits
        color_tag  : $input.color_tag
        created_at : now
        updated_at : now
      }
    } as $new_subject
  
    // Log the creation
    debug.log {
      value = {
        event     : "subject_created"
        subject_id: $new_subject.id
        user_id   : $auth.id
        name      : $input.name
      }
    }
  }

  response = $new_subject
  history = false
}