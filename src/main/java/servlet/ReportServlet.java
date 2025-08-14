package servlet;

import dao.FavoriteDAO;
import dao.ShareDAO;
import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Favorite;
import model.Share;
import model.Video;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private FavoriteDAO favoriteDAO = new FavoriteDAO();
    private ShareDAO shareDAO = new ShareDAO();
    private VideoDAO videoDAO = new VideoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("videoId");

        List<Object[]> favoriteStats = favoriteDAO.reportFavoriteCount();
        List<Video> allVideos = videoDAO.findAll();

        List<Favorite> favoriteUsers = null;
        List<Share> sharedList = null;

        if (videoId != null && !videoId.isBlank()) {
            favoriteUsers = favoriteDAO.findByVideoId(videoId);
            sharedList = shareDAO.findByVideoId(videoId);
        }
        String tabParam = req.getParameter("tab");
        int tab = 0;
        try {
            tab = Integer.parseInt(tabParam);
        } catch (Exception ignored) {}
        req.setAttribute("tab", tab);


        req.setAttribute("stats", favoriteStats);
        req.setAttribute("videos", allVideos);
        req.setAttribute("videoId", videoId);
        req.setAttribute("favoriteUsers", favoriteUsers);
        req.setAttribute("shared", sharedList);
        req.setAttribute("view", "admin/reports");
        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }
}
