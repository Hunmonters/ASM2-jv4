package servlet;

import dao.ShareDAO;
import dao.VideoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Share;
import model.User;
import model.Video;
import utils.Mailer;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet({"/share", "/admin/share"})
public class ShareServlet extends HttpServlet {
    private ShareDAO shareDAO = new ShareDAO();
    private VideoDAO videoDAO = new VideoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        if (videoId == null || videoId.isBlank()) {
            resp.sendRedirect("home");
            return;
        }

        req.setAttribute("videoId", videoId);

        String uri = req.getRequestURI();
        if (uri.contains("/admin/")) {
            req.setAttribute("view", "user/share");
            req.getRequestDispatcher("/admin.jsp").forward(req, resp);
        } else {
            req.setAttribute("includePage", "/user/share.jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User user = (User) req.getSession().getAttribute("user");
            String email = req.getParameter("email");
            String videoId = req.getParameter("videoId");

            if (user != null && videoId != null && email != null) {
                Video video = videoDAO.findById(videoId);
                if (video != null) {
                    Share s = new Share();
                    s.setUser(user);
                    s.setVideo(video);
                    s.setEmails(email.trim());
                    s.setShareDate(LocalDate.now());
                    shareDAO.create(s);

                    String subject = "🎬 " + user.getFullname() + " đã chia sẻ 1 video với bạn!";
                    // Ghép tiền tố & hậu tố để tạo link ảnh
                    String imgUrl = "https://i.ytimg.com/vi/" + video.getPoster() + "/hq720.jpg";
                    String body = ""
                            + "<h3>Chào bạn,</h3>"
                            + "<p><strong>" + user.getFullname() + "</strong> vừa chia sẻ một video với bạn trên PoLyOE Video!</p>"
                            + "<p><strong>Tiêu đề:</strong> " + video.getTitle() + "</p>"
                            + "<img src=\"" + imgUrl + "\" alt=\"poster\" style=\"max-width: 100%; height: auto; border: 1px solid #ccc;\"/>"
                            + "<p style=\"margin-top: 10px;\">Bạn có thể xem video bằng cách đăng nhập vào OE Video.</p>"
                            + "<hr><p style=\"color:gray;font-size:12px;\">OE Video - Nền tảng giải trí trực tuyến</p>";

                    Mailer.send(email.trim(), subject, body);
                }
            }

            resp.sendRedirect("home");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi chia sẻ video");
        }
    }
}
