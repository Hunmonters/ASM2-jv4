<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="index.jsp?page=login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Cập nhật hồ sơ</title>

<style>
:root{
  --brand:#0d6efd;
  --brand-dark:#0b5ed7;
  --bg-1:#f6f9ff;
  --bg-2:#eef2f9;
  --card:#ffffff;
  --text:#1f2937;
  --muted:#6b7280;
  --line:#e9eef7;
  --radius:16px;
  --shadow:0 12px 28px rgba(0,0,0,.06);
}

html,body{
  height:100%;
  margin:0;
  font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
  color:var(--text);
  background:
    radial-gradient(1000px 700px at 10% -10%, rgba(13,110,253,.10), transparent 42%),
    radial-gradient(800px 600px at 95% 0%, rgba(102,16,242,.10), transparent 40%),
    linear-gradient(180deg, var(--bg-1), var(--bg-2));
  background-attachment: fixed;
}

.center-wrapper{
  min-height:100vh;
  display:flex; align-items:center; justify-content:center;
  padding: 24px 12px;
}

.profile-box{
  width:min(620px, 94%);
  border:1px solid rgba(255,255,255,.5);
  border-radius: var(--radius);
  background: rgba(255,255,255,.85);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  box-shadow: var(--shadow);
  overflow:hidden;
}

/* Header */
.header{
  background: linear-gradient(90deg, var(--brand), #6610f2);
  color:#fff;
  padding:14px 18px;
  font-weight:800;
  font-size:18px;
}

/* Body */
.body{
  padding:18px;
  display:flex; flex-wrap:wrap; gap:20px;
}
.form-group{ flex:1 1 calc(50% - 20px); min-width: 240px; }
label{
  display:block; margin:0 0 6px 2px; font-weight:600; font-size:.95rem; color:var(--muted);
}
input[type="text"], input[type="email"], input[type="password"]{
  width:100%; padding:10px 12px; border:1px solid #dfe5f1; border-radius:12px;
  font-size:14px; background:#fff; outline:none;
  transition:border-color .15s ease, box-shadow .15s ease;
}
input:focus{ border-color:var(--brand); box-shadow:0 0 0 3px rgba(13,110,253,.12); }
input[readonly]{ background:#f8fafc; color:#6b7280; }

/* Messages */
.msg{
  text-align:center; font-weight:700; padding:10px 14px; margin:4px 18px 0;
  border-radius:12px; border:1px solid transparent;
}
.msg:empty{ display:none; }
.msg.ok{ color:#166534; background:#dcfce7; border-color:#bbf7d0; }
.msg.err{ color:#991b1b; background:#fee2e2; border-color:#fecaca; }

/* Footer */
.footer{
  padding:14px 18px; background:#f8fafc; border-top:1px solid var(--line);
  display:flex; justify-content:flex-end;
}
.btn-update{
  background: var(--brand); color:#fff; border:none; padding:10px 18px;
  border-radius:12px; font-size:15px; font-weight:800; cursor:pointer;
  box-shadow: 0 8px 20px rgba(13,110,253,.25);
}
.btn-update:hover{ background: var(--brand-dark); }

@media (max-width: 520px){
  .form-group{ flex:1 1 100%; }
}
</style>
</head>
<body>

<div class="center-wrapper">
  <form class="profile-box" action="profile" method="post">
    <div class="header">Cập nhật hồ sơ</div>

    <div class="body">
      <div class="form-group">
        <label for="username">Tên đăng nhập</label>
        <input type="text" name="id" id="username" value="${user.id}" readonly />
      </div>

      <div class="form-group">
        <label for="password">Mật khẩu</label>
        <input type="password" name="password" id="password" value="${user.password}" readonly />
      </div>

      <div class="form-group">
        <label for="fullname">Họ và tên</label>
        <input type="text" name="fullname" id="fullname" value="${user.fullname}" required />
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" name="email" id="email" value="${user.email}" required />
      </div>
    </div>

    <!-- Thông báo -->
    <div class="msg ok">${message}</div>
    <div class="msg err">${error}</div>

    <div class="footer">
      <button type="submit" class="btn-update">Cập nhật</button>
    </div>
  </form>
</div>

</body>
</html>
