import java.security.MessageDigest;

public class HashTest {
    public static void main(String[] args) {
        try {
            String password = "admin123";
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            System.out.println("Hash: " + hexString.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
