package dao;
import java.util.List;

public interface BaseDAO<T, K> {
    List<T> findAll();
    T findById(K id);
    void create(T entity);
    void update(T entity);
    void deleteById(K id);
}
