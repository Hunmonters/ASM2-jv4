package dao;
import jakarta.persistence.*;
import model.Favorite;
import utils.XJPA;

import java.time.LocalDate;
import java.util.List;

public class FavoriteDAO implements BaseDAO<Favorite, Long> {
    EntityManager em = XJPA.getEntityManager();

    @Override
    public List<Favorite> findAll() {
        return em.createQuery("SELECT f FROM Favorite f", Favorite.class).getResultList();
    }

    @Override
    public Favorite findById(Long id) {
        return em.find(Favorite.class, id);
    }

    @Override
    public void create(Favorite entity) {
        em.getTransaction().begin();
        em.persist(entity);
        em.getTransaction().commit();
    }

    @Override
    public void update(Favorite entity) {
        em.getTransaction().begin();
        em.merge(entity);
        em.getTransaction().commit();
    }

    @Override
    public void deleteById(Long id) {
        em.getTransaction().begin();
        Favorite entity = em.find(Favorite.class, id);
        if (entity != null) em.remove(entity);
        em.getTransaction().commit();
    }
    
    public List<Favorite> findByUserId(String userId) {
        return em.createQuery("SELECT f FROM Favorite f WHERE f.user.id = :uid", Favorite.class)
                 .setParameter("uid", userId)
                 .getResultList();
    }

    public void addIfNotExists(String userId, String videoId) {
        String jpql = "SELECT f FROM Favorite f WHERE f.user.id = :uid AND f.video.id = :vid";
        List<Favorite> list = em.createQuery(jpql, Favorite.class)
                                .setParameter("uid", userId)
                                .setParameter("vid", videoId)
                                .getResultList();
        if (list.isEmpty()) {
            Favorite f = new Favorite();
            f.setUser(em.find(model.User.class, userId));
            f.setVideo(em.find(model.Video.class, videoId));
            f.setLikeDate(LocalDate.now());
            create(f);
        }
    }
    
    public void deleteByUserAndVideo(String userId, String videoId) {
        em.getTransaction().begin();
        String jpql = "DELETE FROM Favorite f WHERE f.user.id = :uid AND f.video.id = :vid";
        em.createQuery(jpql)
          .setParameter("uid", userId)
          .setParameter("vid", videoId)
          .executeUpdate();
        em.getTransaction().commit();
    }

    public List<Object[]> reportFavoriteCount() {
        String jpql = """
            SELECT f.video.title, COUNT(f), MAX(f.likeDate), MIN(f.likeDate)
            FROM Favorite f
            GROUP BY f.video.title
            """;
        return em.createQuery(jpql, Object[].class).getResultList();
    }
    public List<Favorite> findByVideoId(String videoId) {
        String jpql = "SELECT f FROM Favorite f WHERE f.video.id = :vid";
        return em.createQuery(jpql, Favorite.class)
                 .setParameter("vid", videoId)
                 .getResultList();
    }
    
    

}
