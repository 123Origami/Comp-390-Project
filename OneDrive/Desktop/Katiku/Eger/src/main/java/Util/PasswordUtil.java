package Util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    /**
     * Hashes a plain-text password using SHA-256.
     *
     * @param password The plain-text password to hash.
     * @return The hashed password as a hexadecimal string.
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes(java.nio.charset.StandardCharsets.UTF_8)); // Use UTF-8 encoding explicitly
            byte[] hashed = md.digest();

            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            throw new RuntimeException("SHA-256 algorithm not found", ex);
        }
    }

    /**
     * Verifies a plain-text password against a hashed password.
     *
     * @param plainTextPassword The plain-text password provided by the user.
     * @param hashedPassword     The hashed password stored in the database.
     * @return True if the passwords match, false otherwise.
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || password.isEmpty() || hashedPassword == null || hashedPassword.isEmpty()) {
            throw new IllegalArgumentException("Password or hashed password cannot be null or empty");
        }

        // Hash the plain-text password and compare it with the stored hash
        String hashedInput = hashPassword(password);
        return hashedInput.equals(hashedPassword);
    }
}