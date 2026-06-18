package com.cinema.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class RequestLoggingFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        try {
            StringBuilder sb = new StringBuilder();
            sb.append("Incoming request: ")
              .append(request.getMethod())
              .append(" ")
              .append(request.getRequestURI());
            String query = request.getQueryString();
            if (query != null) sb.append('?').append(query);

            sb.append(" from ").append(request.getRemoteAddr());

            sb.append("\nHeaders:\n");
            Collections.list(request.getHeaderNames()).forEach(name -> {
                String value = request.getHeader(name);
                sb.append(name).append(": ").append(value).append("\n");
            });

            log.info(sb.toString());
        } catch (Exception ex) {
            log.warn("Failed to log request headers", ex);
        }

        filterChain.doFilter(request, response);
    }
}
