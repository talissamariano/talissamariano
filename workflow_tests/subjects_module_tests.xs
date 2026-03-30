// Testes básicos de subject com controle de usuário
// Obs: adapte ao framework de teste do projeto (Xano / custom). 
query test_subjects_module verb=TEST {
  api_group = "subjects"
  auth = "system"

  stack {
    // 1) Usuário A cria subject
    var $userA { value = {id: "00000000-0000-8000-000000000001", account_id: "00000000-0000-8000-000000000010", role: "user"} }

    api.call {
      path = "/subjects"
      method = "POST"
      data = {
        name       : "Cálculo I"
        code       : "CALC1"
        start_date : "2025-02-01"
        end_date   : "2025-06-01"
        credits    : 4
        color_tag  : "#00FF00"
        semester   : "2025.1"
      }
      auth = $userA
    } as $resp_create

    expect $resp_create.status == 200
    expect $resp_create.body.user_id == $userA.id

    // 2) Violação duplicação de name para mesmo usuário
    api.call {
      path = "/subjects"
      method = "POST"
      data = {name: "Cálculo I"}
      auth = $userA
    } as $dup_name

    expect $dup_name.status == 400

    // 3) Usuário B não vê subject do A
    var $userB { value = {id: "00000000-0000-8000-000000000002", account_id: "00000000-0000-8000-000000000010", role: "user"} }

    api.call {
      path = "/subjects/my"
      method = "GET"
      auth = $userB
    } as $list_b

    expect $list_b.status == 200
    expect $list_b.body|count == 0

    // 3.1) Admin na mesma conta acessa todos subjects
    var $admin { value = {id: "00000000-0000-4000-8000-000000000003", account_id: "00000000-0000-8000-000000000010", role: "admin"} }
    api.call {
      path = "/subjects/account"
      method = "GET"
      auth = $admin
    } as $list_admin

    expect $list_admin.status == 200
    expect $list_admin.body|count >= 1

    // 4) Usuário A executa PATCH no subject criado
    api.call {
      path = "/subjects/" ~ $resp_create.body.id
      method = "PATCH"
      data = {status: "completed"}
      auth = $userA
    } as $patch_resp

    expect $patch_resp.status == 200
    expect $patch_resp.body.status == "completed"

    // 5) Usuário B tenta DELETE do subject de A e espera erro
    api.call {
      path = "/subjects/" ~ $resp_create.body.id
      method = "DELETE"
      auth = $userB
    } as $delete_b

    expect $delete_b.status == 404
  }

  response = {result: "ok"}
}
