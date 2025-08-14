package servlet;

import java.io.IOException;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import org.apache.commons.beanutils.BeanUtils;
import utils.Mailer;

@WebServlet({
    "/login", "/register", "/logout", "/admin/logout",
    "/change-password", "/forgot-password", "/profile"
})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("logout")) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }


        String page = null;
        if (uri.contains("login")) page = "login";
        else if (uri.contains("register")) page = "register";
        else if (uri.contains("change-password")) page = "change-password";
        else if (uri.contains("forgot-password")) page = "forgot-password";
        else if (uri.contains("profile")) page = "profile";

        if (page != null) {
            req.setAttribute("includePage", "/user/" + page + ".jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("register")) {
            try {
                User user = new User();
                BeanUtils.populate(user, req.getParameterMap());
                user.setAdmin(false);
                userDAO.create(user);

                Mailer.send(user.getEmail(), "Chào mừng đến với PoLyOE Video!",
                        "Xin chào " + user.getFullname() + ",\n\nTài khoản của bạn đã được đăng ký thành công.");

                req.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                req.setAttribute("includePage", "/user/login.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Đăng ký thất bại!");
                req.setAttribute("includePage", "/user/register.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }
        }

        if (uri.contains("login")) {
            try {
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String remember = req.getParameter("remember");

                User user = userDAO.findById(username);
                if (user != null && user.getPassword().equals(password)) {
                    req.getSession().setAttribute("user", user);

                    Cookie cookie = new Cookie("user", java.util.Base64.getEncoder()
                            .encodeToString((username + "|" + password).getBytes()));
                    cookie.setPath("/");
                    cookie.setMaxAge(remember != null ? 7 * 24 * 60 * 60 : 0);
                    resp.addCookie(cookie);

                    if (Boolean.TRUE.equals(user.getAdmin())) {
                        resp.sendRedirect("admin/home");
                    } else {
                        resp.sendRedirect("home");
                    }
                    return;
                } else {
                    req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                }
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi hệ thống khi đăng nhập!");
            }
            req.setAttribute("includePage", "/user/login.jsp");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }

        if (uri.contains("change-password")) {
            try {
                User user = (User) req.getSession().getAttribute("user");
                String current = req.getParameter("currentPassword");
                String newpass = req.getParameter("newPassword");
                String confirm = req.getParameter("confirmPassword");

                if (user == null) {
                    req.setAttribute("error", "Bạn chưa đăng nhập!");
                } else if (!user.getPassword().equals(current)) {
                    req.setAttribute("error", "Sai mật khẩu hiện tại!");
                } else if (!newpass.equals(confirm)) {
                    req.setAttribute("error", "Xác nhận mật khẩu không khớp!");
                } else {
                    user.setPassword(newpass);
                    userDAO.update(user);
                    req.setAttribute("message", "Đổi mật khẩu thành công!");
                }
                req.setAttribute("includePage", "/user/change-password.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi hệ thống khi đổi mật khẩu!");
                req.setAttribute("includePage", "/user/change-password.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }
        }

        if (uri.contains("forgot-password")) {
            try {
                String username = req.getParameter("username");
                String email = req.getParameter("email");

                User user = userDAO.findById(username);
                if (user == null || !user.getEmail().equals(email)) {
                    req.setAttribute("error", "Thông tin không đúng!");
                } else {
                    Mailer.send(user.getEmail(), "Khôi phục mật khẩu OE Video",
                            "Chào " + user.getFullname() + ",\n\nMật khẩu của bạn là: " + user.getPassword());
                    req.setAttribute("message", "Mật khẩu đã được gửi đến email!");
                }
                req.setAttribute("includePage", "/user/forgot-password.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi hệ thống khi gửi lại mật khẩu!");
                req.setAttribute("includePage", "/user/forgot-password.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }
        }

        if (uri.contains("profile")) {
            try {
                User user = (User) req.getSession().getAttribute("user");
                if (user == null) {
                    resp.sendRedirect("home");
                    return;
                }

                user.setFullname(req.getParameter("fullname"));
                user.setEmail(req.getParameter("email"));
                userDAO.update(user);

                req.setAttribute("message", "Cập nhật thành công!");
                req.getSession().setAttribute("user", user);
                req.setAttribute("includePage", "/user/profile.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi hệ thống khi cập nhật!");
                req.setAttribute("includePage", "/user/profile.jsp");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            }
        }
    }
}
