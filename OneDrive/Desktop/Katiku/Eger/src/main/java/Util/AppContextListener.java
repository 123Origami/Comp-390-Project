package Util;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialization logic (if any) can be added here
        System.out.println("Application initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Shut down MySQL AbandonedConnectionCleanupThread
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("AbandonedConnectionCleanupThread has been shut down successfully.");
        } catch (Exception e) {
            System.err.println("Error shutting down AbandonedConnectionCleanupThread: " + e.getMessage());
        }

        // Deregister JDBC drivers to prevent memory leaks
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("Deregistered JDBC driver: " + driver);
            } catch (Exception e) {
                System.err.println("Error deregistering JDBC driver: " + driver + ", Error: " + e.getMessage());
            }
        }

        System.out.println("Application shutdown completed.");
    }
}