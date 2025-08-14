<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Quên mật khẩu</title>

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

.forgot-box{
  width:min(420px, 94%);
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
.body{ padding:18px; }
label{
  display:block;
  margin:0 0 6px 2px;
  font-weight:600;
  font-size:.95rem;
  color:var(--muted);
}
input[type="text"], input[type="email"]{
  width:100%;
  padding:10px 12px;
  border:1px solid #dfe5f1;
  border-radius:12px;
  font-size:14px;
  background:#fff;
  outline:none;
  transition: border-color .15s ease, box-shadow .15s ease;
  margin-bottom:14px;
}
input[type="text"]::placeholder, input[type="email"]::placeholder{ color:#9aa3af; }
input[type="text"]:focus, input[type="email"]:focus{
  border-color:var(--brand);
  box-shadow:0 0 0 3px rgba(13,110,253,.12);
}

/* Messages */
.msg{
  text-align:center; font-weight:700; padding:10px 14px; margin:6px 0 0;
  border-radius:12px; border:1px solid transparent;
}
.msg:empty{ display:none; }
.msg.ok{ color:#166534; background:#dcfce7; border-color:#bbf7d0; }
.msg.err{ color:#991b1b; background:#fee2e2; border-color:#fecaca; }

/* Footer */
.footer{
  padding:14px 18px;
  background:#f8fafc;
  border-top:1px solid var(--line);
  display:flex; justify-content:flex-end;
}
.btn-retrieve{
  background: var(--brand);
  color:#fff;
  border:none;
  padding:10px 18px;
  border-radius:12px;
  font-size:15px;
  font-weight:800;
  cursor:pointer;
  box-shadow: 0 8px 20px rgba(13,110,253,.25);
}
.btn-retrieve:hover{ background: var(--brand-dark); }
</style>
</head>
<body>

<div class="center-wrapper">
  <form class="forgot-box" action="forgot-password" method="post">
    <div class="header">Quên mật khẩu</div>

    <div class="body">
      <label for="username">Tên đăng nhập</label>
      <input type="text" name="username" id="username" placeholder="Nhập tên đăng nhập" required />

      <label for="email">Email</label>
      <input type="email" name="email" id="email" placeholder="you@example.com" required />

      <!-- Thông báo (ẩn nếu rỗng nhờ :empty) -->
      <div class="msg ok">${message}</div>
      <div class="msg err">${error}</div>
    </div>

    <div class="footer">
      <button type="submit" class="btn-retrieve">Lấy lại mật khẩu</button>
    </div>
  </form>
</div>

</body>
</html>
