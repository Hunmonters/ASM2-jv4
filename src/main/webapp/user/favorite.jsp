<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Danh sách yêu thích</title>

  <style>
    :root{
      --bg:#f7f9fc; --card:#fff; --text:#1f2937; --muted:#6b7280;
      --line:#e9eef7; --shadow:0 12px 28px rgba(0,0,0,.06); --radius:16px;
      --share:#f97316; --unlike:#3b82f6;
    }

    *{ box-sizing:border-box; }
    html,body{ margin:0; font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; background:var(--bg); color:var(--text); }

    /* Lưới responsive hiện đại */
    .video-grid{
      max-width:1200px; margin:20px auto; padding:0 16px 24px;
      display:grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap:16px;
    }

    /* Card */
    .video-card{
      background:var(--card);
      border:1px solid var(--line);
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      overflow:hidden;
      display:flex; flex-direction:column;
      transition: transform .18s ease, box-shadow .18s ease;
    }
    .video-card:hover{ transform: translateY(-4px); box-shadow:0 16px 40px rgba(0,0,0,.08); }

    /* Poster 16:9 */
    .poster{ width:100%; aspect-ratio:16/9; background:#fff; display:block; overflow:hidden; }
    .poster img{ width:100%; height:100%; object-fit:cover; display:block; }

    /* Tiêu đề */
    .title{
      padding:12px 14px 0; font-weight:700; font-size:15px; line-height:1.35;
      display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
    }

    /* Actions */
    .actions{
      margin-top:auto; padding:12px 14px 14px;
      display:flex; justify-content:center; gap:10px;
      background:#fafbff; border-top:1px solid var(--line);
    }
    .btn{
      padding:8px 14px; font-size:14px; border:none; border-radius:12px; color:#fff;
      cursor:pointer; text-decoration:none; display:inline-flex; align-items:center; gap:8px;
      box-shadow:0 6px 18px rgba(0,0,0,.06); transition: filter .15s ease, transform .05s ease;
    }
    .btn:active{ transform: translateY(1px); }
    .btn-unlike{ background:var(--unlike); }
    .btn-unlike:hover{ filter:brightness(.95); }
    .btn-share{ background:var(--share); }
    .btn-share:hover{ filter:brightness(.95); }
  </style>
</head>
<body>

<div class="video-grid">
  <c:forEach var="f" items="${favorites}">
    <div class="video-card">
      <a href="detail?id=${f.video.id}" class="poster" aria-label="Xem chi tiết: ${f.video.title}">
        <img src="https://i.ytimg.com/vi/${f.video.poster}/hq720.jpg" alt="${f.video.title}" />
      </a>

      <div class="title" title="${f.video.title}">${f.video.title}</div>

      <div class="actions">
        <a href="favorite?action=delete&id=${f.video.id}" class="btn btn-unlike" aria-label="Bỏ thích">💔 Bỏ thích</a>
        <a href="share?id=${f.video.id}" class="btn btn-share" aria-label="Chia sẻ">🔗 Chia sẻ</a>
      </div>
    </div>
  </c:forEach>
</div>

</body>
</html>
