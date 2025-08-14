package dao;

import jakarta.persistence.*;
import model.User;
import utils.XJPA;

import java.util.List;

public class UserDAO implements BaseDAO<User, String> {
    EntityManager em = XJPA.getEntityManager();

    @Override
    public List<User> findAll() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    @Override
    public User findById(String id) {
        return em.find(User.class, id);
    }

    @Override
    public void create(User entity) {
        em.getTransaction().begin();
        em.persist(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }

    @Override
    public void update(User entity) {
        em.getTransaction().begin();
        em.merge(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }

    @Override
    public void deleteById(String id) {
        em.getTransaction().begin();
        User entity = em.find(User.class, id);
        if (entity != null) em.remove(entity);
        em.getTransaction().commit();
        em.clear(); // xoá cache
    }
    public List<User> search(String keyword) {
        return em.createQuery(
                "SELECT u FROM User u WHERE " +
                "LOWER(u.id) LIKE :kw OR " +
                "LOWER(u.fullname) LIKE :kw OR " +
                "LOWER(u.email) LIKE :kw", User.class)
                .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                .getResultList();
    }

}
