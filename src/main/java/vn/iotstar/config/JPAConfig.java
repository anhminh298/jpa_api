package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Quan ly JPA EntityManagerFactory theo Singleton pattern.
 * 
 * EntityManagerFactory rat nang (doc persistence.xml, tao connection pool, ...).
 * Chi nen tao 1 lan duy nhat trong suot vong doi cua ung dung.
 * 
 * EntityManager thi nhe, tao moi cho moi thao tac va dong sau khi xong.
 */
public class JPAConfig {

	private static final String PERSISTENCE_UNIT_NAME = "jpa-hibernate-mysql";

	// Singleton: chi tao 1 lan, luu vao static field
	private static EntityManagerFactory factory;

	/**
	 * Lay EntityManagerFactory (tao lan dau neu chua co).
	 * Thread-safe nho synchronized.
	 */
	private static EntityManagerFactory getEntityManagerFactory() {
		if (factory == null || !factory.isOpen()) {
			synchronized (JPAConfig.class) {
				if (factory == null || !factory.isOpen()) {
					factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
				}
			}
		}
		return factory;
	}

	/**
	 * Tao EntityManager moi.
	 * Goi method nay moi khi can thao tac DB.
	 * Nho goi em.close() sau khi dung xong!
	 */
	public static EntityManager getEntityManager() {
		return getEntityManagerFactory().createEntityManager();
	}

	/**
	 * Dong EntityManagerFactory khi ung dung tat.
	 * Goi trong ServletContextListener hoac khi shutdown.
	 */
	public static void shutdown() {
		if (factory != null && factory.isOpen()) {
			factory.close();
		}
	}
}
