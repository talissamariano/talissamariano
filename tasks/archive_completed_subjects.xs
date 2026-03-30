// Agendador diário para arquivar disciplinas concluídas
query archive_completed_subjects verb=SCHEDULE {
  api_group = "subjects"
  schedule = "0 0 * * *" // diário à meia-noite
  auth = "system"

  stack {
    // Atualiza todas as subjects ativas cujo end_date passou para archived
    db.query subject {
      where = $db.subject.status == "active" && $db.subject.end_date != null && $db.subject.end_date < now::date
      return = {type: "list"}
    } as $expired_subjects

    foreach $expired_subjects as $subject {
      db.patch subject {
        field_name = "id"
        field_value = $subject.id
        data = {status: "archived", updated_at: now}
      }
    }

    debug.log {
      value = {
        event          : "archive_completed_subjects",
        archived_count : $expired_subjects|count
      }
    }
  }

  response = {archived_count: $expired_subjects|count}
}
