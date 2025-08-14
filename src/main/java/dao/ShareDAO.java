package dao;

import jakarta.persistence.*;
import model.Share;
import utils.XJPA;

import java.util.List;

public class ShareDAO implements BaseDAO<Share, Long> {
    EntityManager em = XJPA.getEntityManager();

    @Override
    public List<Share> findAll() {
        return em.createQuery("SELECT s FROM Share s", Share.class).getResultList();
    }

    @Override
    public Share findById(Long id) {
        return em.find(Share.class, id);
    }

    @Override
    public void create(Share entity) {
        em.getTransaction().begin();
        em.persist(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }

    @Override
    public void update(Share entity) {
        em.getTransaction().begin();
        em.merge(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }

    @Override
    public void deleteById(Long id) {
        em.getTransaction().begin();
        Share entity = em.find(Share.class, id);
        if (entity != null) em.remove(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }

    public List<Share> findByVideoId(String videoId) {
        String jpql = "SELECT s FROM Share s WHERE s.video.id = :vid";
        return em.createQuery(jpql, Share.class)
                 .setParameter("vid", videoId)
                 .getResultList();
    }
}
