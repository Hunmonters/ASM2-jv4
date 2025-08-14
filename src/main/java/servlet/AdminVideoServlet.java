package servlet;

import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Video;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/videos")
public class AdminVideoServlet extends HttpServlet {
    private final VideoDAO videoDAO = new VideoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id != null && !id.isBlank()) {
            Video video = videoDAO.findById(id);
            req.setAttribute("form", video);
        }

        String keyword = req.getParameter("keyword");
        List<Video> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = videoDAO.searchAllByTitleOrId(keyword.trim());
        } else {
            list = videoDAO.findAllEdit(); // admin xem tất cả, không lọc active
        }

        req.setAttribute("videos", list);
        req.setAttribute("keyword", keyword); // giữ lại keyword
        req.setAttribute("view", "admin/videos");
        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        String id = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String poster = req.getParameter("poster");

        int views = 0;
        try {
            String viewsStr = req.getParameter("views");
            if (viewsStr != null && !viewsStr.isBlank()) {
                views = Integer.parseInt(viewsStr.trim());
            }
        } catch (NumberFormatException ignore) {
            views = 0;
        }

        // Checkbox gửi "on" khi tick; đôi lúc dự án khác gửi "true"
        boolean active = "on".equalsIgnoreCase(req.getParameter("active"))
                || "true".equalsIgnoreCase(req.getParameter("active"));

        try {
            if ("create".equals(action)) {
                if (id == null || id.isBlank()) {
                    req.getSession().setAttribute("error", "Thiếu ID");
                } else if (videoDAO.findById(id) != null) {
                    req.getSession().setAttribute("error", "ID đã tồn tại");
                } else {
                    String posterVal = (poster != null && !poster.isBlank()) ? poster.trim() : "poster.jpg";
                    Video v = new Video(id.trim(), title, posterVal, views, description, active);
                    videoDAO.create(v);
                    req.getSession().setAttribute("message", "Tạo mới thành công");
                }
            } else if ("update".equals(action)) {
                if (id == null || id.isBlank()) {
                    req.getSession().setAttribute("error", "Thiếu ID để cập nhật");
                } else {
                    Video v = videoDAO.findById(id);
                    if (v == null) {
                        req.getSession().setAttribute("error", "Không tìm thấy video để cập nhật");
                    } else {
                        v.setTitle(title);
                        v.setDescription(description);
                        v.setViews(views);
                        v.setActive(active);
                        if (poster != null && !poster.isBlank()) {
                            v.setPoster(poster.trim());
                        }
                        videoDAO.update(v);
                        req.getSession().setAttribute("message", "Cập nhật thành công");
                    }
                }
            } else if ("delete".equals(action)) {
                if (id == null || id.isBlank()) {
                    req.getSession().setAttribute("error", "Thiếu ID để xoá");
                } else {
                    videoDAO.deleteById(id);
                    req.getSession().setAttribute("message", "Xoá thành công");
                }
            } else if ("reset".equals(action)) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            } else {
                req.getSession().setAttribute("error", "Action không hợp lệ");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        // Redirect tuyệt đối để tránh lệch path
        resp.sendRedirect(req.getContextPath() + "/admin/videos");
    }
}
