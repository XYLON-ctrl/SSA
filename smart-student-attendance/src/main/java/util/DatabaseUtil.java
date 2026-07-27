package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    private static final String DB_HOST =
            System.getenv().getOrDefault("DB_HOST", "localhost");

    private static final String DB_PORT =
            System.getenv().getOrDefault("DB_PORT", "3306");

    private static final String DB_NAME =
            System.getenv().getOrDefault("DB_NAME", "defaultdb");

    private static final String DB_USER =
            System.getenv().getOrDefault("DB_USER", "avnadmin");

    private static final String DB_PASSWORD =
            System.getenv().getOrDefault("DB_PASSWORD", "");

    private static final String URL =
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?sslMode=REQUIRED"
            + "&serverTimezone=UTC"
            + "&characterEncoding=UTF-8"
            + "&connectTimeout=30000"
            + "&socketTimeout=30000";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, DB_USER, DB_PASSWORD);
    }
}