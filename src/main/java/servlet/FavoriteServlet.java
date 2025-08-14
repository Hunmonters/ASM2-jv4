package servlet;

import dao.FavoriteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Favorite;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    private FavoriteDAO favoriteDAO = new FavoriteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User user = (User) req.getSession().getAttribute("user");

            String videoId = req.getParameter("id");
            String action = req.getParameter("action");

            if (user != null && videoId != null) {
                if ("delete".equals(action)) {
                    favoriteDAO.deleteByUserAndVideo(user.getId(), videoId);
                } else {
                    favoriteDAO.addIfNotExists(user.getId(), videoId);
                }
                resp.sendRedirect("favorite");
                return;
            }

            if (user != null) {
                List<Favorite> list = favoriteDAO.findByUserId(user.getId());
                req.setAttribute("favorites", list);
                req.setAttribute("includePage", "/user/favorite.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("login");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi xử lý yêu thích");
        }
    }
}
