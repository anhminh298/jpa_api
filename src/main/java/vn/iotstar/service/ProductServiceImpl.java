package vn.iotstar.service;

import java.util.List;
import vn.iotstar.dao.IProductDao;
import vn.iotstar.dao.ProductJpaDao;
import vn.iotstar.entity.Product;

public class ProductServiceImpl implements IProductService {

	public IProductDao productDao = new ProductJpaDao();

	@Override
	public void insert(Product product) {
		productDao.insert(product);
	}

	@Override
	public void update(Product product) {
		Product existing = productDao.findById(product.getId());
		if (existing != null) {
			productDao.update(product);
		}
	}

	@Override
	public void delete(int id) throws Exception {
		productDao.delete(id);
	}

	@Override
	public Product findById(int id) {
		return productDao.findById(id);
	}

	@Override
	public List<Product> findAll() {
		return productDao.findAll();
	}

	@Override
	public List<Product> findNewest(int limit) {
		return productDao.findNewest(limit);
	}

	@Override
	public List<Product> findAll(int page, int pagesize) {
		return productDao.findAll(page, pagesize);
	}

	@Override
	public List<Product> findByCategory(int categoryId) {
		return productDao.findByCategory(categoryId);
	}

	@Override
	public int count() {
		return productDao.count();
	}
}
