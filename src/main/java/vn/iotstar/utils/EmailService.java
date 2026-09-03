package vn.iotstar.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

/**
 * Utility class gui email OTP qua Gmail SMTP.
 * Can cau hinh App Password trong Google Account.
 */
public class EmailService {

    // === CAU HINH EMAIL - THAY DOI THEO TAI KHOAN CUA BAN ===
    private static final String FROM_EMAIL = "nguyenanhminh29082k6@gmail.com";  // TODO: Thay bang email cua ban
    private static final String APP_PASSWORD = "guvj ciru vnlr fnfg";    // TODO: Thay bang App Password

    /**
     * Gui email OTP den nguoi dung.
     * @param toEmail dia chi email nguoi nhan
     * @param otp ma OTP 6 chu so
     * @param subject tieu de email
     */
    public static void sendOTP(String toEmail, String otp, String subject) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // Noi dung email HTML
        String htmlContent = """
            <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px;">
                <h2 style="color: #333;">Xac thuc tai khoan</h2>
                <p>Ma OTP cua ban la:</p>
                <div style="background: #f0f0f0; padding: 15px; text-align: center; font-size: 32px; 
                            font-weight: bold; letter-spacing: 8px; color: #2196F3; border-radius: 8px;">
                    %s
                </div>
                <p style="color: #666; margin-top: 15px;">Ma OTP co hieu luc trong <strong>5 phut</strong>.</p>
                <p style="color: #999; font-size: 12px;">Neu ban khong yeu cau ma nay, vui long bo qua email.</p>
            </div>
            """.formatted(otp);

        message.setContent(htmlContent, "text/html; charset=UTF-8");
        Transport.send(message);
    }
}
