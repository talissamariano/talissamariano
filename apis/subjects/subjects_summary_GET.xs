// Resumo de subjects do usuário autenticado
query subjects_summary verb=GET {
  api_group = "subjects"
  auth = "user"

  input {
  }

  stack {
    // Pega todas as subjects do usuário
    db.query subject {
      where = $db.subject.user_id == $auth.id
      return = {type: "list"}
    } as $subjects

    var $summary {
      value = {
        total_subjects: 0
        active         : 0
        completed      : 0
        archived       : 0
        total_credits  : 0
      }
    }

    foreach $subjects as $subject {
      var.update $summary {
        value = $summary|set:"total_subjects": $summary.total_subjects + 1
      }

      conditional {
        if ($subject.status == "active") {
          var.update $summary {
            value = $summary|set:"active": $summary.active + 1
          }
        }
      }
      conditional {
        if ($subject.status == "completed") {
          var.update $summary {
            value = $summary|set:"completed": $summary.completed + 1
          }
        }
      }
      conditional {
        if ($subject.status == "archived") {
          var.update $summary {
            value = $summary|set:"archived": $summary.archived + 1
          }
        }
      }

      conditional {
        if ($subject.credits != null) {
          var.update $summary {
            value = $summary|set:"total_credits": $summary.total_credits + $subject.credits
          }
        }
      }
    }
  }

  response = $summary
}