<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Danh sách video</title>
  <style>
    :root{
      --bg:#f8f9fa;
      --card:#fff;
      --text:#212529;
      --muted:#6c757d;
      --brand:#0d6efd;
      --like:#22c55e;       /* xanh lá dịu */
      --share:#f97316;      /* cam dịu */
      --shadow:0 10px 28px rgba(0,0,0,.06);
      --radius:16px;
    }

    *{ box-sizing:border-box; }
    html,body{ margin:0; background:var(--bg); color:var(--text); font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; }

    /* GRID hiện đại, responsive */
    .video-grid{
      max-width: 1200px;
      margin: 20px auto;
      padding: 0 16px;
      display: grid;
      grid-template-columns: repeat(12, 1fr);
      gap: 16px;
    }

    /* Card */
    .video-card{
      grid-column: span 12;
      background: var(--card);
      border: 0;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
      display: flex;
      flex-direction: column;
      transition: transform .18s ease, box-shadow .18s ease;
    }
    .video-card:hover{
      transform: translateY(-4px);
      box-shadow: 0 16px 38px rgba(0,0,0,.08);
    }

    /* Poster 16:9 */
    .poster{
      position: relative;
      width: 100%;
      aspect-ratio: 16/9;
      background: #f1f3f5;
      display: grid; place-items: center;
      overflow: hidden;
    }
    .poster img{
      width: 100%; height: 100%;
      object-fit: cover;
      display: block;
    }

    /* Tiêu đề */
    .title{
      padding: 12px 14px 0 14px;
      font-weight: 600;
      font-size: 15px;
      line-height: 1.35;
    }
    .subtitle{
      padding: 2px 14px 10px 14px;
      font-size: 12px;
      color: var(--muted);
    }

    /* Actions */
    .actions{
      margin-top: auto;
      padding: 12px 14px 16px 14px;
      display: flex;
      justify-content: center;
      gap: 10px;
      background: #fafafa;
      border-top: 1px solid #f0f0f0;
    }
    .btn{
      padding: 8px 14px;
      font-size: 14px;
      border: none;
      border-radius: 12px;
      color: #fff;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: filter .15s ease, transform .05s ease;
      box-shadow: 0 6px 18px rgba(0,0,0,.06);
    }
    .btn:active{ transform: translateY(1px); }
    .btn-like{ background: var(--like); }
    .btn-like:hover{ filter: brightness(.95); }
    .btn-share{ background: var(--share); }
    .btn-share:hover{ filter: brightness(.95); }

    /* Pagination */
    .pagination{
      max-width: 1200px;
      margin: 6px auto 28px auto;
      padding: 0 16px;
      display: flex;
      justify-content: center;
      gap: 8px;
      flex-wrap: wrap;
    }
    .pagination a, .pagination span{
      display: inline-block;
      background: #fff;
      color: var(--text);
      text-decoration: none;
      padding: 10px 14px;
      font-size: 14px;
      border-radius: 12px;
      box-shadow: var(--shadow);
      border: 1px solid #eee;
      min-width: 44px; text-align: center;
      transition: background .15s ease, transform .05s ease;
    }
    .pagination a:hover{ background: #f5f7fb; }
    .pagination .disabled{
      opacity: .5; pointer-events: none;
    }

    /* Responsive columns */
    @media (min-width: 576px){
      .video-card{ grid-column: span 6; }
    }
    @media (min-width: 992px){
      .video-card{ grid-column: span 4; }
    }
  </style>
</head>
<body>

<div class="video-grid">
  <c:forEach var="v" items="${videos}">
    <div class="video-card">
      <a href="detail?id=${v.id}" aria-label="Xem chi tiết: ${v.title}">
        <div class="poster">
          <%-- Giữ nguyên thumbnail YouTube theo poster=videoId --%>
          <img src="https://i.ytimg.com/vi/${v.poster}/hq720.jpg" alt="${v.title}">
        </div>
      </a>

      <div class="title" title="${v.title}">${v.title}</div>
      <div class="subtitle">
        <%-- Nếu có thêm thông tin (năm, lượt xem), bạn có thể hiển thị ở đây:
             Ví dụ: Năm ${v.year} • ${v.views} lượt xem --%>
      </div>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/favorite?id=${v.id}" class="btn btn-like" aria-label="Thích video">
          ❤️ <span>Thích</span>
        </a>
        <a href "${pageContext.request.contextPath}/share?id=${v.id}" class="btn btn-share" aria-label="Chia sẻ video">
          🔗 <span>Chia sẻ</span>
        </a>
      </div>
    </div>
  </c:forEach>
</div>

<div class="pagination">
  <c:choose>
    <c:when test="${page > 1}">
      <a href="home?p=1" title="Về đầu">|&lt;</a>
      <a href="home?p=${page - 1}" title="Trang trước">&lt;&lt;</a>
    </c:when>
    <c:otherwise>
      <span class="disabled">|&lt;</span>
      <span class="disabled">&lt;&lt;</span>
    </c:otherwise>
  </c:choose>

  <c:choose>
    <c:when test="${page < totalPage}">
      <a href="home?p=${page + 1}" title="Trang sau">&gt;&gt;</a>
      <a href="home?p=${totalPage}" title="Về cuối">&gt;|</a>
    </c:when>
    <c:otherwise>
      <span class="disabled">&gt;&gt;</span>
      <span class="disabled">&gt;|</span>
    </c:otherwise>
  </c:choose>
</div>

</body>
</html>
