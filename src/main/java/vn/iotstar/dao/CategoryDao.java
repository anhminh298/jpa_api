package vn.iotstar.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JPAConfig;
import vn.iotstar.entity.Category;

/**
 * CategoryDao - Truy van database bang JPA/Hibernate.
 * Thuoc tang Data Access trong kien truc 3 tang.
 * 
 * Tat ca method deu phai dong EntityManager trong block finally
 * de tranh resource leak.
 */
public class CategoryDao implements ICategoryDao {

	@Override
	public void insert(Category category) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.persist(category); // insert vào bảng
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	}

	@Override
	public void update(Category category) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.merge(category); // update vào bảng
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	}

	@Override
	public void delete(int cateid) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			Category category = enma.find(Category.class, cateid);
			if (category != null) {
				enma.remove(category);
			} else {
				throw new Exception("Không tìm thấy");
			}
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	}

	@Override
	public Category findById(int cateid) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			return enma.find(Category.class, cateid);
		} finally {
			enma.close(); // FIX: truoc day khong dong EntityManager
		}
	}

	@Override
	public Category findByCategoryname(String name) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
		String jpql = "SELECT c FROM Category c WHERE c.categoryname =:catename";
		try {
			TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
			query.setParameter("catename", name);
			Category category = query.getSingleResult();
			if (category == null) {
				throw new Exception("Category Name đã tồn tại");
			}
			return category;
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Category> findAll() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
			return query.getResultList();
		} finally {
			enma.close(); // FIX: truoc day khong dong EntityManager
		}
	}

	@Override
	public List<Category> searchByName(String catname) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			String jpql = "SELECT c FROM Category c WHERE c.categoryname like :catname";
			TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
			query.setParameter("catname", "%" + catname + "%");
			return query.getResultList();
		} finally {
			enma.close(); // FIX: truoc day khong dong EntityManager
		}
	}

	@Override
	public List<Category> findAll(int page, int pagesize) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
			// FIX: (page - 1) * pagesize thay vi page * pagesize
			// De thong nhat voi ProductJpaDao
			query.setFirstResult((page - 1) * pagesize);
			query.setMaxResults(pagesize);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public int count() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			String jpql = "SELECT count(c) FROM Category c";
			Query query = enma.createQuery(jpql);
			return ((Long) query.getSingleResult()).intValue();
		} finally {
			enma.close(); // FIX: truoc day khong dong EntityManager
		}
	}

}
