package servlet;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String id = req.getParameter("id");
            if (id != null) {
                User user = userDAO.findById(id);
                req.setAttribute("form", user);
            }

            String keyword = req.getParameter("keyword");
            List<User> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = userDAO.search(keyword);
            } else {
                list = userDAO.findAll();
            }
            req.setAttribute("keyword", keyword);

            req.setAttribute("users", list);
            req.setAttribute("view", "admin/users");
            req.getRequestDispatcher("/admin.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi load danh sách user");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String id = req.getParameter("id");
            String fullname = req.getParameter("fullname");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            boolean admin = "true".equals(req.getParameter("admin"));

            if ("create".equals(action)) {
                if (userDAO.findById(id) == null) {
                    User u = new User(id, password, email, fullname, admin);
                    userDAO.create(u);
                }
            } else if ("update".equals(action)) {
                User u = new User(id, password, email, fullname, admin);
                userDAO.update(u);
            } else if ("delete".equals(action)) {
                userDAO.deleteById(id);
            }



            resp.sendRedirect("users");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi thao tác với user");
        }
    }
}
