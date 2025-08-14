<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Báo cáo</title>

  <style>
    :root{
      --brand:#0d6efd;
      --brand-2:#6610f2;
      --bg:#f7f9fc;
      --card:#ffffff;
      --text:#1f2937;
      --muted:#6b7280;
      --radius:16px;
      --shadow:0 12px 28px rgba(0,0,0,.06);
    }

    *{ box-sizing: border-box; }
    html,body{ margin:0; padding:0; background:var(--bg); color:var(--text);
      font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; }

    .page{
      width:min(1100px,94%); margin:18px auto; 
    }

    /* --- TABS --- */
    .tab-header{
      display:flex; gap:10px; align-items:center;
      padding:8px; background:linear-gradient(180deg,#fff, #f3f6fc);
      border:1px solid #e9eef7; border-radius: var(--radius);
      box-shadow: var(--shadow);
      margin-bottom:12px;
      overflow-x:auto;
    }
    .tab{
      padding:10px 14px; border-radius:12px; cursor:pointer;
      color:#374151; border:1px solid transparent; background:#fff;
      font-weight:600; white-space:nowrap; transition: all .15s ease;
    }
    .tab:hover{ background:#f5f7fb; }
    .tab.active{
      color:#fff; 
      background: linear-gradient(90deg, var(--brand), var(--brand-2));
      border-color: transparent;
      box-shadow: 0 6px 20px rgba(13,110,253,.25);
    }

    /* --- CONTENT CARD --- */
    .tab-content{
      display:none;
      background: var(--card);
      border: 1px solid #e9eef7;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding:16px;
      margin-bottom:16px;
    }
    .tab-content.active{ display:block; }

    /* --- FORM SELECT --- */
    label{ display:block; font-size:.92rem; color:var(--muted); margin-bottom:6px; }
    select{
      padding:10px 12px; border:1px solid #dfe5f1; border-radius:12px;
      background:#fff; min-width:280px; outline:none;
      transition:border-color .15s ease, box-shadow .15s ease;
    }
    select:focus{ border-color:var(--brand); box-shadow:0 0 0 3px rgba(13,110,253,.12); }

    /* --- TABLE --- */
    .table-wrap{ overflow:auto; border-radius:12px; }
    table{ width:100%; border-collapse: collapse; min-width:700px; }
    th, td{ padding:10px 12px; text-align:center; }
    thead th{
      background: linear-gradient(180deg, #f4f7ff, #eaf1ff);
      color:#1f2a44; font-weight:700; border-bottom:1px solid #dfe5f1;
      position: sticky; top:0; z-index:1;
    }
    tbody td{ border-bottom:1px solid #edf1f7; }
    tbody tr:nth-child(odd){ background:#fafcff; }
    tbody tr:hover{ background:#f3f8ff; }

    /* Small screen */
    @media (max-width: 576px){
      select{ width:100%; min-width: unset; }
    }
  </style>

  <script>
    function showTab(index) {
      const tabs = document.querySelectorAll('.tab');
      const contents = document.querySelectorAll('.tab-content');
      tabs.forEach(t => t.classList.remove('active'));
      contents.forEach(c => c.classList.remove('active'));
      if (tabs[index]) tabs[index].classList.add('active');
      if (contents[index]) contents[index].classList.add('active');
    }
    function redirectTo(videoId, tabIndex) {
      window.location = "reports?videoId=" + videoId + "&tab=" + tabIndex;
    }
    window.onload = function () {
      const activeTab = ${tab != null ? tab : 0};
      showTab(activeTab);
    }
  </script>
</head>
<body>

<div class="page">
  <!-- Tabs -->
  <div class="tab-header">
    <div class="tab" onclick="showTab(0)">Thống kê yêu thích</div>
    <div class="tab" onclick="showTab(1)">Người dùng đã thích</div>
    <div class="tab" onclick="showTab(2)">Bạn bè đã chia sẻ</div>
  </div>

  <!-- Tab 1: Thống kê yêu thích -->
  <div class="tab-content">
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Tiêu đề video</th>
            <th>Số lượt thích</th>
            <th>Lần thích gần nhất</th>
            <th>Lần thích lâu nhất</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="row" items="${stats}">
            <tr>
              <td>${row[0]}</td>
              <td>${row[1]}</td>
              <td>${row[2]}</td>
              <td>${row[3]}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Tab 2: Người dùng đã thích -->
  <div class="tab-content">
    <label>Chọn video</label>
    <select onchange="redirectTo(this.value, 1)">
      <option value="">-- Chọn video --</option>
      <c:forEach var="v" items="${videos}">
        <option value="${v.id}" ${v.id == videoId ? "selected" : ""}>${v.title}</option>
      </c:forEach>
    </select>

    <c:if test="${not empty favoriteUsers}">
      <div class="table-wrap" style="margin-top:12px;">
        <table>
          <thead>
            <tr>
              <th>Mã người dùng</th>
              <th>Họ tên</th>
              <th>Email</th>
              <th>Ngày thích</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="f" items="${favoriteUsers}">
              <tr>
                <td>${f.user.id}</td>
                <td>${f.user.fullname}</td>
                <td>${f.user.email}</td>
                <td>${f.likeDate}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
  </div>

  <!-- Tab 3: Bạn bè đã chia sẻ -->
  <div class="tab-content">
    <label>Chọn video</label>
    <select onchange="redirectTo(this.value, 2)">
      <option value="">-- Chọn video --</option>
      <c:forEach var="v" items="${videos}">
        <option value="${v.id}" ${v.id == videoId ? "selected" : ""}>${v.title}</option>
      </c:forEach>
    </select>

    <c:if test="${not empty shared}">
      <div class="table-wrap" style="margin-top:12px;">
        <table>
          <thead>
            <tr>
              <th>Người gửi</th>
              <th>Email người gửi</th>
              <th>Email người nhận</th>
              <th>Ngày gửi</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="s" items="${shared}">
              <tr>
                <td>${s.user.fullname}</td>
                <td>${s.user.email}</td>
                <td>${s.emails}</td>
                <td>${s.shareDate}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
  </div>
</div>

</body>
</html>
