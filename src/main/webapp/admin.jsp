<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Bảng quản trị</title>

  <style>
    :root{
      --bg:#f5f7fb;
      --card:#fff;
      --text:#1f2937;
      --muted:#6b7280;
      --brand:#0d6efd;
      --brand-dark:#0b5ed7;
      --shadow:0 10px 28px rgba(0,0,0,.06);
      --radius:16px;
    }

    *{ box-sizing:border-box; }
    html,body{ height:100%; margin:0; font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color:var(--text); background:var(--bg); }

    .wrapper{ min-height:100vh; display:flex; flex-direction:column; }

    /* NAVBAR hiện đại (giữ link y hệt) */
    .admin-nav{
      background:#fff;
      border:1px solid #e5e7eb;
      border-radius:18px;
      padding:10px 14px;
      margin:16px auto 8px;
      width:min(1200px, 92%);
      box-shadow:var(--shadow);
      display:flex; align-items:center; gap:10px; flex-wrap:wrap;
    }
    .admin-logo{
      color:var(--brand);
      font-weight:800;
      font-size:18px;
      text-transform:none;
      margin-right:auto;
      text-decoration:none;
      letter-spacing:.2px;
      display:flex; align-items:center; gap:10px;
    }
    .admin-logo::before{
      content:"⚙️";
      font-size:16px;
      display:inline-block;
    }
    .admin-nav a{
      color:#374151;
      text-decoration:none;
      font-weight:600;
      font-size:14px;
      padding:8px 12px;
      border-radius:10px;
      transition: background .15s ease, color .15s ease;
    }
    .admin-nav a:hover{ background:#f3f4f6; color:#111827; }
    .admin-nav a:last-child{
      background:var(--brand); color:#fff;
    }
    .admin-nav a:last-child:hover{
      background:var(--brand-dark);
    }

    main{
      flex:1;
      width:min(1200px, 92%);
      margin:8px auto 18px;
    }

    /* Khung nội dung mặc định (nếu trang con cần) */
    .card{
      background:var(--card); border-radius:var(--radius);
      box-shadow:var(--shadow); border:0;
      padding:16px;
    }

    /* Footer */
    .admin-footer{
      background:#fff; color:#6b7280; text-align:center;
      border-top:1px solid #e5e7eb;
      padding:14px; font-size:13px;
      border-radius:18px;
      width:min(1200px, 92%);
      margin:0 auto 16px;
      box-shadow:var(--shadow);
    }

    /* Responsive nhỏ gọn */
    @media (max-width: 576px){
      .admin-nav{ gap:6px; padding:8px 10px; }
      .admin-nav a{ padding:8px 10px; font-size:13px; }
    }
  </style>
</head>
<body>

<div class="wrapper">

  <!-- Navbar (giữ nguyên href, chỉ đổi chữ hiển thị) -->
  <div class="admin-nav">
    <a href="home" class="admin-logo">Bảng quản trị</a>
    <a href="home">Trang chủ</a>
    <a href="videos">Video</a>
    <a href="users">Người dùng</a>
    <a href="reports">Báo cáo</a>
    <a href="logout">Đăng xuất</a>
  </div>

  <main>
    <!-- GIỮ Y NGUYÊN LOGIC INCLUDE -->
    <c:choose>
      <c:when test="${not empty view}">
        <jsp:include page="${view}.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="homelist.jsp" />
      </c:otherwise>
    </c:choose>
  </main>

  <!-- Footer (Việt hoá) -->
  <footer class="admin-footer">
    © 2025 Bảng quản trị. Đã đăng ký bản quyền.
  </footer>

</div>

</body>
</html>
