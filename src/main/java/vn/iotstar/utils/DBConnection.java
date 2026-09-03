package vn.iotstar.utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Lop tien ich quan ly ket noi database (JDBC).
 * Thuoc tang Data Access trong kien truc 3 tang.
 * 
 * Su dung file db.properties de doc thong tin ket noi,
 * giup de dang thay doi cau hinh ma khong can sua code.
 * 
 * Ket noi SQL Server voi Windows Authentication.
 */
public class DBConnection {

    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;
    private static String DRIVER;

    // Doc file cau hinh khi class duoc load
    static {
        try {
            Properties props = new Properties();
            InputStream input = DBConnection.class.getClassLoader()
                    .getResourceAsStream("db.properties");
            props.load(input);

            URL = props.getProperty("db.url");
            USERNAME = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
            DRIVER = props.getProperty("db.driver");

            // Dang ky JDBC Driver
            Class.forName(DRIVER);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Tao va tra ve mot ket noi moi den database.
     * Moi lan goi se tao connection moi -> nho dong sau khi dung xong.
     * 
     * Voi SQL Server Windows Auth (integratedSecurity=true),
     * khong can truyen username/password.
     */
    public static Connection getConnection() throws Exception {
        if (USERNAME != null && !USERNAME.isEmpty()) {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        }
        // Windows Authentication - khong can user/pass
        return DriverManager.getConnection(URL);
    }
}
