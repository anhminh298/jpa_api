package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.CharBuffer;

/**
 * Filter cấu hình SiteMesh Decorator 3 cho toàn bộ ứng dụng Java Servlet / Jakarta EE 10 / Tomcat 11.
 * Tích hợp 01 Template Bootstrap 5 duy nhất (/WEB-INF/decorators/web.jsp).
 */
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected boolean reloadRequired() {
        return false;
    }

    @Override
    protected Filter setup() throws ServletException {
        SiteMeshFilterBuilder builder = new SiteMeshFilterBuilder();
        builder.setDecoratorPrefix("")
               .addDecoratorPath("/*", "/WEB-INF/decorators/web.jsp")
               .addExcludedPath("/WEB-INF/*")
               .addExcludedPath("/views/decorators/*")
               .addExcludedPath("/image*")
               .addExcludedPath("/uploads/*")
               .addExcludedPath("/assets/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("*.css")
               .addExcludedPath("*.js")
               .addExcludedPath("*.png")
               .addExcludedPath("*.jpg")
               .addExcludedPath("*.jpeg")
               .addExcludedPath("*.webp");

        return new org.sitemesh.webapp.SiteMeshFilter(
                builder.getSelector(),
                builder.getContentProcessor(),
                builder.getDecoratorSelector(),
                builder.isIncludeErrorPages()) {

            @Override
            protected boolean postProcess(String contentType, CharBuffer buffer,
                                          HttpServletRequest request, HttpServletResponse response,
                                          org.sitemesh.webapp.contentfilter.ResponseMetaData metaData)
                    throws IOException, ServletException {
                org.sitemesh.webapp.WebAppContext context = createContext(contentType, request, response, metaData);
                org.sitemesh.content.Content content = getContentProcessor().build(buffer, context);
                if (content == null) {
                    return false;
                }

                String[] decoratorPaths = getDecoratorSelector().selectDecoratorPaths(content, context);
                for (String decoratorPath : decoratorPaths) {
                    content = context.decorate(decoratorPath, content);
                }

                if (content == null) {
                    return false;
                }

                if (response.containsHeader("Content-Length")) {
                    response.setContentLength(-1);
                }

                try {
                    content.getData().writeValueTo(response.getWriter());
                    response.getWriter().flush();
                } catch (IllegalStateException ise) {
                    content.getData().writeValueTo(new PrintStream(response.getOutputStream()));
                    response.getOutputStream().flush();
                }
                return true;
            }

            @Override
            protected org.sitemesh.webapp.WebAppContext createContext(String contentType, HttpServletRequest request,
                                                  HttpServletResponse response, org.sitemesh.webapp.contentfilter.ResponseMetaData metaData) {
                return new org.sitemesh.webapp.WebAppContext(contentType, request, response,
                        getFilterConfig().getServletContext(), getContentProcessor(), metaData, builder.isIncludeErrorPages()) {
                    @Override
                    protected void dispatch(HttpServletRequest req, HttpServletResponse resp, String path)
                            throws ServletException, IOException {
                        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(path);
                        if (dispatcher == null) {
                            throw new ServletException("Decorator view not found: " + path);
                        }
                        dispatcher.include(req, resp);
                    }
                };
            }
        };
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        String uri = req.getRequestURI();
        DispatcherType dispatcher = req.getDispatcherType();

        // Nếu là REQUEST tới Servlet (không phải file .jsp), cho Servlet xử lý trực tiếp và forward tới JSP,
        // nơi SiteMesh FORWARD sẽ decorate trước khi response được commit.
        if (dispatcher == DispatcherType.REQUEST && !uri.endsWith(".jsp") && !uri.endsWith("/")) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        super.doFilter(servletRequest, servletResponse, filterChain);
    }
}
