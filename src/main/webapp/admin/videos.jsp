<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Quản lý video</title>

  <style>
    :root{
      --brand:#0d6efd; --brand2:#6610f2;
      --bg:#f7f9fc; --card:#fff; --text:#1f2937; --muted:#6b7280;
      --line:#e9eef7; --radius:16px; --shadow:0 12px 28px rgba(0,0,0,.06);
    }
    *{ box-sizing:border-box }
    html,body{ margin:0; padding:0; background:var(--bg); color:var(--text);
      font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; }
    .page{ width:min(1100px,94%); margin:18px auto; }

    /* Tabs tiêu đề */
    .tab-box{ display:flex; gap:10px; align-items:center; margin-bottom:12px; }
    .tab{
      padding:10px 14px; border-radius:12px; background:#fff; border:1px solid var(--line);
      font-weight:700; color:#374151;
    }
    .tab.active{
      color:#fff; background:linear-gradient(90deg,var(--brand),var(--brand2));
      border-color:transparent; box-shadow:0 6px 20px rgba(13,110,253,.25);
    }

    /* Thẻ nội dung */
    .card{
      background:var(--card); border:1px solid var(--line); border-radius:var(--radius);
      box-shadow:var(--shadow); padding:16px;
    }

    /* Form 2 cột */
    .form-row{ display:grid; grid-template-columns:1fr; gap:18px; }
    @media(min-width:768px){ .form-row{ grid-template-columns:420px 1fr; } }

    label{ display:block; font-size:.92rem; color:var(--muted); margin:0 0 6px 2px; }
    input[type="text"], textarea{
      width:100%; padding:10px 12px; border:1px solid #dfe5f1; border-radius:12px; background:#fff;
      font-size:14px; outline:none; transition:border-color .15s ease, box-shadow .15s ease;
    }
    input[type="text"]:focus, textarea:focus{ border-color:var(--brand); box-shadow:0 0 0 3px rgba(13,110,253,.12) }
    textarea{ resize:vertical; }

    /* Poster preview */
    .poster{
      width:100%; max-width:420px; aspect-ratio:16/9; border:1px dashed #dfe5f1; border-radius:12px;
      background: #f6f8fc; display:grid; place-items:center; overflow:hidden; margin-bottom:10px;
    }
    .poster img{ width:100%; height:100%; object-fit:cover; display:block; }

    /* Trạng thái */
    .status-box{ display:flex; align-items:center; gap:14px; margin-top:6px; flex-wrap:wrap; }
    .status-box label{ display:inline-flex; align-items:center; gap:6px; cursor:pointer; font-weight:600; }

    /* Actions */
    .actions{ margin-top:12px; display:flex; justify-content:center; gap:10px; flex-wrap:wrap; }
    .btn{ border:none; border-radius:12px; padding:10px 14px; cursor:pointer; font-weight:700; }
    .btn-primary{ background:var(--brand); color:#fff; box-shadow:0 6px 18px rgba(13,110,253,.25) }
    .btn-warning{ background:#f59e0b; color:#fff }
    .btn-danger{ background:#ef4444; color:#fff }
    .btn-ghost{ background:#fff; color:#374151; border:1px solid var(--line) }

    /* Toolbar tìm kiếm */
    .toolbar{ display:flex; align-items:center; justify-content:space-between; gap:12px }
    .search{ display:flex; align-items:center; gap:8px }
    .search input{
      padding:10px 12px; border:1px solid #dfe5f1; border-radius:12px; background:#fff; min-width:220px;
    }

    /* Bảng */
    .table-wrap{ margin-top:10px; overflow:auto; border-radius:12px }
    table{ width:100%; border-collapse:collapse; min-width:820px }
    th, td{ padding:10px 12px; text-align:center }
    thead th{
      background:linear-gradient(180deg,#f4f7ff,#eaf1ff);
      color:#1f2a44; font-weight:700; border-bottom:1px solid #dfe5f1; position:sticky; top:0; z-index:1;
    }
    tbody td{ border-bottom:1px solid #edf1f7 }
    tbody tr:nth-child(odd){ background:#fafcff }
    tbody tr:hover{ background:#f3f8ff }

    /* Badge trạng thái */
    .badge{ display:inline-block; padding:4px 10px; border-radius:999px; font-size:.85rem; font-weight:700 }
    .badge-on{ background:#dcfce7; color:#166534 }
    .badge-off{ background:#fee2e2; color:#991b1b }

    .link{ color:var(--brand); text-decoration:none; font-weight:700 }
    .link:hover{ text-decoration:underline }
    .muted{ color:var(--muted); font-size:.92rem; margin-top:6px }
  </style>

  <script>
    function updatePosterPreview() {
      var posterId = document.getElementById('posterId').value.trim();
      var img = document.getElementById('preview');
      if (posterId) {
        img.src = 'https://i.ytimg.com/vi/' + posterId + '/hq720.jpg';
        img.style.display = '';
      } else {
        img.src = '';
        img.style.display = 'none';
      }
    }
    window.onload = function(){ updatePosterPreview(); };
  </script>
</head>
<body>

<div class="page">
  <!-- Tiêu đề -->
  <div class="tab-box">
    <div class="tab active">Chỉnh sửa video</div>
  </div>

  <!-- Form chỉnh sửa/tạo -->
  <form class="card" method="post" action="${pageContext.request.contextPath}/admin/videos">
    <div class="form-row">
      <!-- Cột trái: Poster + ID Poster -->
      <div>
        <div class="poster">
          <c:choose>
            <c:when test="${not empty form.poster}">
              <img id="preview" src="https://i.ytimg.com/vi/${form.poster}/hq720.jpg" alt="Poster" />
            </c:when>
            <c:otherwise>
              <img id="preview" style="display:none" alt="Poster"/>
              <span class="muted">Xem trước poster (16:9)</span>
            </c:otherwise>
          </c:choose>
        </div>

        <label>ID poster (YouTube)</label>
        <input type="text" name="poster" id="posterId" value="${form.poster}" placeholder="VD: knyYkqYgFv4" oninput="updatePosterPreview()" />
        <small class="muted">Chỉ nhập ID YouTube, không nhập cả link.</small>
      </div>

      <!-- Cột phải: Thông tin chính -->
      <div>
        <label>ID YouTube</label>
        <input type="text" name="id" value="${form.id}" placeholder="Nhập ID YouTube" />

        <label>Tiêu đề video</label>
        <input type="text" name="title" value="${form.title}" placeholder="Nhập tiêu đề" />

        <label>Lượt xem</label>
        <input type="text" name="views" value="${form.views}" placeholder="Nhập số lượt xem" />

        <div class="status-box">
          <label><input type="radio" name="active" value="true"  ${form.active ? "checked" : ""}/> Hiển thị</label>
          <label><input type="radio" name="active" value="false" ${!form.active ? "checked" : ""}/> Ẩn</label>
        </div>
      </div>
    </div>

    <label>Mô tả</label>
    <textarea name="description" rows="4" placeholder="Mô tả ngắn...">${form.description}</textarea>

    <div class="actions">
      <button type="submit" class="btn btn-primary" name="action" value="create">Thêm mới</button>
      <button type="submit" class="btn btn-warning" name="action" value="update">Cập nhật</button>
      <button type="submit" class="btn btn-danger"  name="action" value="delete" onclick="return confirm('Xoá video này?')">Xoá</button>
      <button type="submit" class="btn btn-ghost"   name="action" value="reset">Làm mới</button>
    </div>
  </form>

  <!-- Danh sách -->
  <div class="tab-box" style="margin-top:22px;">
    <div class="toolbar" style="width:100%;">
      <div class="tab active" style="margin:0;">Danh sách video</div>

      <form method="get" action="${pageContext.request.contextPath}/admin/videos" class="search" style="margin:0;">
        <input type="text" name="keyword" placeholder="Tìm video..." value="${param.keyword}">
        <button type="submit" class="btn btn-ghost">Tìm</button>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Poster</th>
            <th>ID YouTube</th>
            <th>Tiêu đề</th>
            <th>Lượt xem</th>
            <th>Trạng thái</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="v" items="${videos}">
            <tr>
              <td>
                <c:if test="${not empty v.poster}">
                  <img src="https://i.ytimg.com/vi/${v.poster}/hq720.jpg" alt="Poster" style="height:60px;max-width:100px;border-radius:8px"/>
                </c:if>
              </td>
              <td>${v.id}</td>
              <td>${v.title}</td>
              <td>${v.views}</td>
              <td>
                <c:choose>
                  <c:when test="${v.active}">
                    <span class="badge badge-on">Hiển thị</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-off">Ẩn</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td><a href="${pageContext.request.contextPath}/admin/videos?id=${v.id}" class="link">Sửa</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="muted">${fn:length(videos)} video</div>
  </div>
</div>

</body>
</html>
