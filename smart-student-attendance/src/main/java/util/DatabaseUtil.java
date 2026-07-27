package util;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

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

    private static HikariDataSource dataSource;

    static {

        HikariConfig config = new HikariConfig();

        config.setJdbcUrl(
                "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
                + "?sslMode=REQUIRED"
                + "&serverTimezone=UTC"
                + "&characterEncoding=UTF-8"
                + "&cachePrepStmts=true"
                + "&prepStmtCacheSize=250"
                + "&prepStmtCacheSqlLimit=2048");

        config.setUsername(DB_USER);
        config.setPassword(DB_PASSWORD);

        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Connection Pool Settings
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(300000);
        config.setMaxLifetime(1800000);
        config.setConnectionTimeout(10000);

        config.setPoolName("SSA-HikariPool");

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
