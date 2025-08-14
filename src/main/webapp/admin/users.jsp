<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Quản lý người dùng</title>

  <style>
    :root{
      --brand:#0d6efd;
      --brand2:#6610f2;
      --bg:#f7f9fc;
      --card:#ffffff;
      --muted:#6b7280;
      --text:#1f2937;
      --radius:16px;
      --shadow:0 12px 28px rgba(0,0,0,.06);
      --line:#e9eef7;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0;background:var(--bg);color:var(--text);font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif}

    .page{width:min(1100px,94%);margin:18px auto}

    /* Tiêu đề tab */
    .tab-box{
      display:flex;align-items:center;gap:10px;margin-bottom:12px
    }
    .tab{
      padding:10px 14px;border-radius:12px;background:#fff;border:1px solid var(--line);
      font-weight:700
    }
    .tab.active{
      color:#fff;background:linear-gradient(90deg,var(--brand),var(--brand2));
      border-color:transparent;box-shadow:0 6px 20px rgba(13,110,253,.25)
    }

    /* Thẻ nội dung */
    .card{
      background:var(--card);border:1px solid var(--line);border-radius:var(--radius);
      box-shadow:var(--shadow);padding:16px
    }

    /* Form */
    .form-row{display:grid;grid-template-columns:1fr;gap:18px}
    @media(min-width:768px){ .form-row{grid-template-columns:1fr 1fr} }
    label{display:block;font-size:.92rem;color:var(--muted);margin:0 0 6px 2px}
    input[type="text"],input[type="password"]{
      width:100%;padding:10px 12px;border:1px solid #dfe5f1;border-radius:12px;background:#fff;
      font-size:14px;outline:none;transition:border-color .15s ease, box-shadow .15s ease
    }
    input[type="text"]:focus,input[type="password"]:focus{
      border-color:var(--brand);box-shadow:0 0 0 3px rgba(13,110,253,.12)
    }
    .form-inline{display:flex;align-items:center;gap:8px;margin-top:6px}
    .form-inline input[type="checkbox"]{transform:translateY(1px)}
    .form-inline span{color:var(--text);font-weight:600}

    /* Actions */
    .actions{margin-top:12px;display:flex;justify-content:flex-end;gap:10px;flex-wrap:wrap}
    .btn{
      border:none;border-radius:12px;padding:10px 14px;cursor:pointer;font-weight:700;
      display:inline-flex;align-items:center;gap:8px;text-decoration:none
    }
    .btn:disabled{opacity:.5;cursor:not-allowed}
    .btn-primary{background:var(--brand);color:#fff;box-shadow:0 6px 18px rgba(13,110,253,.25)}
    .btn-warning{background:#f59e0b;color:#fff}
    .btn-danger{background:#ef4444;color:#fff}
    .btn-ghost{background:#fff;color:#374151;border:1px solid var(--line)}

    /* Tìm kiếm */
    .toolbar{display:flex;align-items:center;justify-content:space-between;gap:12px}
    .search{display:flex;align-items:center;gap:8px}
    .search input{
      padding:10px 12px;border:1px solid #dfe5f1;border-radius:12px;background:#fff;min-width:220px
    }
    .search button{ @apply; } /* no-op, chỉ để dễ đọc */
    .search .btn{padding:10px 12px}

    /* Bảng */
    .table-wrap{margin-top:10px;overflow:auto;border-radius:12px}
    table{width:100%;border-collapse:collapse;min-width:760px}
    th,td{padding:10px 12px;text-align:center}
    thead th{
      background:linear-gradient(180deg,#f4f7ff,#eaf1ff);
      color:#1f2a44;font-weight:700;border-bottom:1px solid #dfe5f1;position:sticky;top:0;z-index:1
    }
    tbody td{border-bottom:1px solid #edf1f7}
    tbody tr:nth-child(odd){background:#fafcff}
    tbody tr:hover{background:#f3f8ff}

    .badge{
      display:inline-block;padding:4px 10px;border-radius:999px;font-size:.85rem;font-weight:700
    }
    .badge-admin{background:#e9d5ff;color:#6b21a8}
    .badge-user{background:#dbeafe;color:#1e40af}

    .link{color:var(--brand);text-decoration:none;font-weight:700}
    .link:hover{text-decoration:underline}
    .muted{color:var(--muted);font-size:.92rem;margin-top:6px}
  </style>
</head>
<body>

<div class="page">

  <!-- Tab tiêu đề -->
  <div class="tab-box">
    <div class="tab active">Chỉnh sửa người dùng</div>
  </div>

  <!-- Form chỉnh sửa / tạo -->
  <form method="post" class="card">
    <div class="form-row">
      <div>
        <label>Tên đăng nhập</label>
        <input type="text" name="id" value="${form.id}" ${form.id != null ? "readonly" : ""} />

        <label>Họ và tên</label>
        <input type="text" name="fullname" value="${form.fullname}" />
      </div>

      <div>
        <label>Mật khẩu</label>
        <input type="password" name="password" value="${form.password}" />

        <label>Địa chỉ email</label>
        <input type="text" name="email" value="${form.email}" />

        <label class="form-inline" style="margin-top:6px;">
          <input type="checkbox" name="admin" value="true" ${form.admin ? "checked" : ""}/>
          <span>Quản trị</span>
        </label>
      </div>
    </div>

    <div class="actions">
      <button class="btn btn-primary" name="action" value="create" ${form.id != null ? "disabled" : ""}>Thêm mới</button>
      <button class="btn btn-warning" name="action" value="update" ${form.id == null ? "disabled" : ""}>Cập nhật</button>
      <button class="btn btn-danger"  name="action" value="delete" ${form.id == null ? "disabled" : ""}>Xoá</button>
      <a class="btn btn-ghost" href="users">Làm mới</a>
    </div>
  </form>

  <!-- Danh sách người dùng -->
  <div class="tab-box" style="margin-top: 22px;">
    <div class="toolbar" style="width:100%;">
      <div class="tab active" style="margin:0;">Danh sách người dùng</div>

      <form method="get" action="users" class="search" style="margin:0;">
        <input type="text" name="keyword" placeholder="Tìm người dùng..." value="${param.keyword}">
        <button type="submit" class="btn btn-ghost">Tìm</button>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Tên đăng nhập</th>
            <th>Mật khẩu</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>Vai trò</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="u" items="${users}">
            <tr>
              <td>${u.id}</td>
              <td>${u.password}</td>
              <td>${u.fullname}</td>
              <td>${u.email}</td>
              <td>
                <c:choose>
                  <c:when test="${u.admin}">
                    <span class="badge badge-admin">Quản trị</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-user">Người dùng</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td><a href="users?id=${u.id}" class="link">Sửa</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="muted">${fn:length(users)} người dùng</div>
  </div>

</div>

</body>
</html>
