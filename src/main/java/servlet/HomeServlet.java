package servlet;

import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Video;

import java.io.IOException;
import java.util.List;

@WebServlet({"/home", "/admin/home"})
public class HomeServlet extends HttpServlet {
    private VideoDAO videoDAO = new VideoDAO();
    private final int pageSize = 6;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int page = 1;
            String pageParam = req.getParameter("p");
            if (pageParam != null) page = Integer.parseInt(pageParam);

            String keyword = req.getParameter("q"); // từ khóa tìm kiếm
            List<Video> all;

            if (keyword != null && !keyword.trim().isEmpty()) {
                all = videoDAO.searchByTitle(keyword); // gọi DAO tìm kiếm
            } else {
                all = videoDAO.findAll();
            }

            int total = all.size();
            int totalPage = (int) Math.ceil((double) total / pageSize);

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, total);
            List<Video> videos = all.subList(start, end);

            req.setAttribute("videos", videos);
            req.setAttribute("page", page);
            req.setAttribute("totalPage", totalPage);
            req.setAttribute("q", keyword); // giữ lại giá trị tìm kiếm trong view

            String uri = req.getRequestURI();

            if (uri.contains("/admin/")) {
                req.setAttribute("view", "homelist"); 
                req.getRequestDispatcher("/admin.jsp").forward(req, resp);
            } else {
                req.setAttribute("includePage", "homelist.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi hệ thống");
        }
    }
}
