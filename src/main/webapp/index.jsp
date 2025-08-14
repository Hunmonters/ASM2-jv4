<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Giải trí trực tuyến</title>

<style>
:root{
  --brand:#0d6efd;
  --brand-dark:#0b5ed7;
  --bg:#f8f9fa;
  --text:#212529;
  --muted:#6c757d;
  --card: #ffffff;
  --shadow: 0 10px 28px rgba(0,0,0,.06);
}

*{ box-sizing:border-box; }
html,body{ height:100%; margin:0; padding:0; font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color:var(--text); background:var(--bg); }

.wrapper{ min-height:100vh; display:flex; flex-direction:column; }

/* NAVBAR */
nav{
  background: #fff;
  border-bottom: 1px solid #e9ecef;
  position: sticky; top:0; z-index:1000;
  box-shadow: 0 2px 14px rgba(0,0,0,.05);
}
.nav-inner{
  max-width: 1100px;
  margin: 0 auto;
  display:flex; align-items:center; gap:12px;
  padding: 10px 16px;
  flex-wrap:wrap;
}
.logo{
  color: #e95fc1;
  font-weight: 700;
  font-size: 18px;
  margin-right:auto;
  text-decoration:none;
  letter-spacing:.2px;
  display:flex; align-items:center; gap:8px;
}
.logo::before{
  content:"🤡";
  font-size:14px;
  background:var(--brand);
  color:#fff;
  width:20px;height:20px; display:inline-grid; place-items:center;
  border-radius:6px;
}

/* Search */
.search-form{ display:flex; gap:8px; align-items:center; }
.search-form input{
  padding:10px 12px;
  border-radius:12px;
  border:1px solid #dee2e6;
  min-width: 230px;
  background:#fff;
}
.search-form input:focus{ outline:none; border-color:var(--brand); box-shadow:0 0 0 3px rgba(13,110,253,.1); }
.search-form button{
  padding:10px 14px; border:0; border-radius:12px;
  background:var(--brand); color:#fff; cursor:pointer;
}
.search-form button:hover{ background:var(--brand-dark); }

/* Nav items */
.nav-list{
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;            /* đã có trước, giữ lại nếu có */
  align-items: center;
  gap: 14px;
}
.nav-item{ position:relative; }
.nav-item>a{
  text-decoration:none; color:#343a40; padding:10px 12px; border-radius:10px;
  display:block; white-space:nowrap; transition: background .2s;
}
.nav-item>a:hover{ background:#f1f3f5; }

/* Dropdown */
.dropdown {
    display: none;
    position: absolute;
    top: 100%;
    left: -99px;
    background-color: white;
    min-width: 200px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    z-index: 1000;
}

.dropdown a {
    color: black;
    padding: 10px 15px;
    display: block;
    text-decoration: none;
    border-bottom: 1px solid #eee;
    white-space: nowrap;
}

.dropdown a:hover {
    background-color: #f5f5f5;
}
.nav-item:has(.dropdown):hover .dropdown{ display:block; }

/* Main */
main{
  flex:1;
  max-width:1100px;
  margin: 18px auto;
  padding: 0 16px 24px;
}

/* Footer */
.user-footer{
  background:#fff; color:#6c757d; text-align:center;
  padding:16px; font-size:14px; border-top:1px solid #e9ecef;
}

/* Cards (nếu trang con dùng) */
.card{
  background:var(--card); border-radius:16px; box-shadow:var(--shadow); border:0;
}
@media (max-width: 576px){
  .search-form input{ min-width: 140px; }
  .nav-list{ width:100%; justify-content:flex-start; }
}
</style>
</head>
<body>
<div class="wrapper">

  <nav>
    <div class="nav-inner">
      <!-- GIỮ NGUYÊN LINK CỦA BẠN -->
      <a href="home" class="logo">YOUTUBE FAKE</a>

      <!-- Thanh tìm kiếm: GIỮ action & name -->
      <form action="home" method="get" class="search-form">
        <input type="text" name="q" placeholder="Tìm kiếm video..." value="${param.q}">
        <button type="submit" aria-label="Tìm kiếm">🔍</button>
      </form>

      <ul class="nav-list">
        <c:if test="${not empty sessionScope.user}">
          <li class="nav-item"><a href="favorite">Yêu thích của tôi</a></li>
        </c:if>

        <li class="nav-item">
          <a href="javascript:void(0)">Tài khoản</a>
          <div class="dropdown">
            <c:choose>
              <c:when test="${empty sessionScope.user}">
                <a href="login">Đăng nhập</a>
                <a href="register">Đăng ký</a>
                <a href="forgot-password">Quên mật khẩu</a>
              </c:when>
              <c:otherwise>
                <a href="change-password">Đổi mật khẩu</a>
                <a href="profile">Cập nhật tài khoản</a>
                <a href="logout">Đăng xuất (về trang chủ)</a>
              </c:otherwise>
            </c:choose>
          </div>
        </li>
      </ul>
    </div>
  </nav>

  <main>
    <c:choose>
      <c:when test="${not empty includePage}">
        <jsp:include page="${includePage}" />
      </c:when>
      <c:otherwise>
        <jsp:include page="homelist.jsp" />
      </c:otherwise>
    </c:choose>
  </main>

  <footer class="user-footer">
    © 2025 Giải trí trực tuyến. Đã đăng ký bản quyền.
  </footer>
</div>
</body>
</html>
