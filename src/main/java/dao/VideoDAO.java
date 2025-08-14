package dao;

import jakarta.persistence.EntityManager;
import model.Video;
import utils.XJPA;

import java.util.List;

public class VideoDAO implements BaseDAO<Video, String> {

    @Override
    public List<Video> findAll() {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.active = true";
            return em.createQuery(jpql, Video.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Video> findAllEdit() {
        EntityManager em = XJPA.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM Video v", Video.class).getResultList();
        } finally {
            em.close();
        }
    }

    // Tìm kiếm video active (user)
    public List<Video> searchByTitle(String keyword) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v " +
                          "WHERE v.active = true AND LOWER(v.title) LIKE :kw";
            return em.createQuery(jpql, Video.class)
                     .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                     .getResultList();
        } finally {
            em.close();
        }
    }

    // Tìm kiếm tất cả video (admin)
    public List<Video> searchAllByTitleOrId(String keyword) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v " +
                          "WHERE LOWER(v.title) LIKE :kw " +
                          "OR LOWER(v.id) LIKE :kw";
            return em.createQuery(jpql, Video.class)
                     .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                     .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Video findById(String id) {
        EntityManager em = XJPA.getEntityManager();
        try {
            return em.find(Video.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public void create(Video entity) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Video entity) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteById(String id) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            // Xoá bản ghi con tham chiếu trước (FK Favorite/Share -> Video)
            em.createQuery("DELETE FROM Favorite f WHERE f.video.id = :id")
              .setParameter("id", id).executeUpdate();
            em.createQuery("DELETE FROM Share s WHERE s.video.id = :id")
              .setParameter("id", id).executeUpdate();

            Video entity = em.find(Video.class, id);
            if (entity != null) em.remove(entity);

            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }
}
