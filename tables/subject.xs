table subject {
  auth = false

  schema {
    // Unique identifier for the subject
    uuid id
  
    // Reference to the account (tenant) that owns this subject
    uuid account_id {
      table = "account"
    }

    // Reference to the user who owns this subject
    uuid user_id {
      table = "user"
    }
  
    // Name of the subject, unique per user
    text name filters=trim
  
    // Optional code for the subject, unique per user if provided
    text code? filters=trim
  
    // Optional description of the subject
    text description?
  
    // Optional instructor name
    text instructor? filters=trim
  
    // Optional start date of the subject
    date start_date?
  
    // Optional end date of the subject
    date end_date?
  
    // Status of the subject
    enum status?=active {
      values = ["active", "completed", "archived"]
    }
  
    // Optional hex color tag for the subject
    text color_tag?
  
    // Optional semester identifier (e.g. 2025.1)
    text semester?

    // Optional credits for the subject, between 0 and 12
    decimal credits? filters=min:0|max:12
  
    // Timestamp when the subject was created
    timestamp created_at?=now
  
    // Timestamp when the subject was last updated
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree|unique"
      field: [{name: "user_id"}, {name: "name"}]
    }
    {
      type : "btree|unique"
      field: [{name: "user_id"}, {name: "code"}]
    }
    {type: "btree", field: [{name: "account_id"}, {name: "user_id"}]}
    {type: "btree", field: [{name: "account_id"}, {name: "status"}]}
    {type: "btree", field: [{name: "user_id"}, {name: "status"}]}
    {type: "btree", field: [{name: "user_id"}]}
  ]
}