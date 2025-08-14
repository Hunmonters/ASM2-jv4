package servlet;

import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Video;

import java.io.IOException;
import java.util.List;

@WebServlet({"/detail", "/admin/detail"})
public class DetailServlet extends HttpServlet {
    private VideoDAO videoDAO = new VideoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String id = req.getParameter("id");
            if (id == null || id.isBlank()) {
                resp.sendRedirect("home");
                return;
            }

            String history = null;
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("history".equals(c.getName())) {
                        history = c.getValue();
                        break;
                    }
                }
            }

            List<String> list = new java.util.LinkedList<>();
            if (history != null && !history.isBlank()) {
                for (String s : history.split("-")) {
                    if (!s.equals(id) && !s.isBlank())
                        list.add(s);
                }
            }
            list.add(0, id); 
            if (list.size() > 5) list = list.subList(0, 5);

            String newHistory = String.join("-", list);
            Cookie cookie = new Cookie("history", newHistory);
            cookie.setMaxAge(7 * 24 * 60 * 60); 
            cookie.setPath("/");
            resp.addCookie(cookie);

            List<Video> historyList = new java.util.ArrayList<>();
            for (String vid : list) {
                if (!vid.equals(id)) {
                    Video v = videoDAO.findById(vid);
                    if (v != null)
                        historyList.add(v);
                }
            }

            Video current = videoDAO.findById(id);
            if (current == null) {
                resp.sendRedirect("home");
                return;
            }

            current.setViews(current.getViews() + 1);
            videoDAO.update(current);

            
            req.setAttribute("video", current);
            req.setAttribute("historyList", historyList);

            String uri = req.getRequestURI();
            if (uri.contains("/admin/")) {
                req.setAttribute("view", "user/detail");
                req.getRequestDispatcher("/admin.jsp").forward(req, resp);
            } else {
                req.setAttribute("includePage", "/user/detail.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi hiển thị video");
        }
    }
}

