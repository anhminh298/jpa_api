package vn.iotstar.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JPAConfig;
import vn.iotstar.entity.Product;

public class ProductJpaDao implements IProductDao {

	@Override
	public void insert(Product product) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.persist(product);
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
	public void update(Product product) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.merge(product);
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
	public void delete(int id) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			Product product = enma.find(Product.class, id);
			if (product != null) {
				enma.remove(product);
			} else {
				throw new Exception("Khong tim thay san pham voi id: " + id);
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
	public Product findById(int id) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			Product product = enma.find(Product.class, id);
			return product;
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Product> findAll() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Product> query = enma.createNamedQuery("Product.findAll", Product.class);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Product> findNewest(int limit) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			String jpql = "SELECT p FROM Product p ORDER BY p.createdDate DESC";
			TypedQuery<Product> query = enma.createQuery(jpql, Product.class);
			query.setMaxResults(limit);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Product> findAll(int page, int pagesize) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Product> query = enma.createNamedQuery("Product.findAll", Product.class);
			query.setFirstResult((page - 1) * pagesize);
			query.setMaxResults(pagesize);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Product> findByCategory(int categoryId) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			String jpql = "SELECT p FROM Product p WHERE p.category.categoryid = :catId";
			TypedQuery<Product> query = enma.createQuery(jpql, Product.class);
			query.setParameter("catId", categoryId);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public int count() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			String jpql = "SELECT count(p) FROM Product p";
			Query query = enma.createQuery(jpql);
			return ((Long) query.getSingleResult()).intValue();
		} finally {
			enma.close();
		}
	}
}
