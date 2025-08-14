<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>${video.title}</title>

  <style>
    :root{
      --brand:#0d6efd; --brand2:#6610f2;
      --bg:#f7f9fc; --card:#fff; --text:#1f2937; --muted:#6b7280;
      --line:#e9eef7; --shadow:0 12px 28px rgba(0,0,0,.06); --radius:16px;
    }

    *{ box-sizing:border-box; }
    html,body{ margin:0; font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; background:var(--bg); color:var(--text); }

    .container{
      width:min(1100px,94%); margin:18px auto;
      display:grid; grid-template-columns: 2fr 1fr; gap:22px;
    }
    @media (max-width: 900px){ .container{ grid-template-columns: 1fr; } }

    /* Thẻ card chung */
    .card{ background:var(--card); border:1px solid var(--line); border-radius:var(--radius); box-shadow:var(--shadow); }

    /* Khối chính */
    .main-video{ display:flex; flex-direction:column; gap:14px; }
    .video-frame{ aspect-ratio: 16/9; border-radius:12px; overflow:hidden; border:1px solid var(--line); background:#fff; }
    .video-frame iframe{ width:100%; height:100%; display:block; }

    .title{ font-size:20px; font-weight:800; }
    .description{ font-size:15px; color:var(--muted); line-height:1.6; }

    .actions{ display:flex; gap:10px; flex-wrap:wrap; }
    .btn{
      padding:10px 16px; font-size:14px; border:none; border-radius:12px; color:#fff; cursor:pointer;
      text-decoration:none; display:inline-flex; align-items:center; gap:8px;
      box-shadow:0 6px 18px rgba(0,0,0,.06); transition:transform .05s ease, filter .15s ease;
    }
    .btn:active{ transform: translateY(1px); }
    .btn-like{ background:#22c55e; }
    .btn-like:hover{ filter: brightness(.95); }
    .btn-share{ background:#f97316; }
    .btn-share:hover{ filter: brightness(.95); }

    /* Gợi ý xem thêm */
    .suggestions{ display:flex; flex-direction:column; gap:12px; }
    .suggestion-header{ font-weight:800; color:#1f2a44; }
    .suggestion-item{
      text-decoration:none; display:flex; gap:10px; align-items:center;
      padding:8px; border-radius:12px; background:#fff; border:1px solid var(--line);
      box-shadow:var(--shadow); transition: transform .12s ease, box-shadow .12s ease, background .12s ease;
    }
    .suggestion-item:hover{ transform: translateY(-2px); box-shadow:0 16px 36px rgba(0,0,0,.08); background:#fdfdff; }

    .suggestion-poster{
      width:120px; aspect-ratio: 16/9; border-radius:10px; overflow:hidden;
      border:1px solid #e5e7eb; background:#fff; flex-shrink:0;
    }
    .suggestion-poster img{ width:100%; height:100%; object-fit:cover; display:block; }

   .suggestion-title{
      flex:1; font-size:14px; font-weight:700; color:#111; line-height:1.35;
      display:-webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow:hidden;
    }
  </style>
</head>
<body>

<div class="container">
  <!-- Video chính -->
  <div class="main-video">
    <div class="video-frame card">
      <iframe
        src="https://www.youtube.com/embed/${video.poster}"
        title="${video.title}" frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen>
      </iframe>
    </div>

    <div class="title">${video.title}</div>
    <div class="description">${video.description}</div>

    <div class="actions">
      <a href="${pageContext.request.contextPath}/favorite?id=${video.id}" class="btn btn-like" aria-label="Thích video">❤️ Thích</a>
      <a href="${pageContext.request.contextPath}/share?id=${video.id}"    class="btn btn-share" aria-label="Chia sẻ video">🔗 Chia sẻ</a>
    </div>
  </div>

  <!-- Gợi ý -->
  <div class="suggestions">
    <div class="suggestion-header">Đã xem gần đây</div>

    <c:choose>
      <c:when test="${not empty historyList}">
        <c:forEach var="v" items="${historyList}">
          <a href="${pageContext.request.contextPath}/detail?id=${v.id}" class="suggestion-item">
            <div class="suggestion-poster">
              <img src="https://i.ytimg.com/vi/${v.poster}/hq720.jpg" alt="${v.title}"/>
            </div>
            <div class="suggestion-title">${v.title}</div>
          </a>
        </c:forEach>
      </c:when>

      <c:otherwise>
        <div style="color:#888;">Chưa có lịch sử xem</div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</body>
</html>
