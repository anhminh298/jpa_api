package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.configs.constants;

@WebServlet(urlPatterns = { "/image" })
public class ImageServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String fname = req.getParameter("fname");
		if (fname == null || fname.isEmpty()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String filePath = constants.DIR + "/" + fname;
		File file = new File(filePath);

		if (!file.exists()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		// Set content type based on file extension
		String ext = fname.substring(fname.lastIndexOf(".") + 1).toLowerCase();
		switch (ext) {
			case "jpg":
			case "jpeg":
				resp.setContentType("image/jpeg");
				break;
			case "png":
				resp.setContentType("image/png");
				break;
			case "gif":
				resp.setContentType("image/gif");
				break;
			case "webp":
				resp.setContentType("image/webp");
				break;
			default:
				resp.setContentType("application/octet-stream");
		}

		resp.setContentLengthLong(file.length());

		try (FileInputStream fis = new FileInputStream(file);
			 OutputStream os = resp.getOutputStream()) {
			byte[] buffer = new byte[4096];
			int bytesRead;
			while ((bytesRead = fis.read(buffer)) != -1) {
				os.write(buffer, 0, bytesRead);
			}
		}
	}
}
