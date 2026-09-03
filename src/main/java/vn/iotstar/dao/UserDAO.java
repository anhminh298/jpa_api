package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import vn.iotstar.config.JPAConfig;
import vn.iotstar.entity.User;

/**
 * UserDAO - Truy van database bang JPA EntityManager.
 * Thuoc tang Data Access trong kien truc 3 tang.
 * 
 * Da chuyen tu JDBC sang JPA de ho tro Profile feature
 * va thong nhat cach truy cap DB trong toan bo project.
 */
public class UserDAO {

    /**
     * Tim user theo id.
     * Dung cho Profile: lay thong tin user hien tai.
     */
    public User findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Tim user theo username.
     * Dung cho dang nhap: tim user -> verify password hash o tang Service.
     */
    public User findByUsername(String username) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                     .setParameter("username", username)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Tim user theo email.
     */
    public User findByEmail(String email) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                     .setParameter("email", email)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Them user moi vao database (isActive = false, chua kich hoat).
     * Password phai duoc hash TRUOC khi goi method nay.
     */
    public void insert(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    /**
     * Cap nhat user (dung cho profile, OTP, password, ...).
     * Dung em.merge() de cap nhat entity da detach.
     */
    public User update(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User merged = em.merge(user);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Cap nhat OTP, thoi han, va loai OTP cho user.
     */
    public void updateOtp(String email, String otp, long expiredAt, String otpType) {
        User user = findByEmail(email);
        if (user != null) {
            user.setOtp(otp);
            user.setOtpExpiredAt(expiredAt);
            user.setOtpType(otpType);
            update(user);
        }
    }

    /**
     * Kich hoat tai khoan (set isActive = true, xoa OTP).
     */
    public void activateUser(String email) {
        User user = findByEmail(email);
        if (user != null) {
            user.setActive(true);
            user.setOtp(null);
            user.setOtpExpiredAt(null);
            user.setOtpType(null);
            update(user);
        }
    }

    /**
     * Cap nhat mat khau moi (da hash) va xoa OTP.
     */
    public void updatePassword(String email, String hashedPassword) {
        User user = findByEmail(email);
        if (user != null) {
            user.setPassword(hashedPassword);
            user.setOtp(null);
            user.setOtpExpiredAt(null);
            user.setOtpType(null);
            update(user);
        }
    }
}
