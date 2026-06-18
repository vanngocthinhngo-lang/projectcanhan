package com.cinema.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RuntimeException.class)
    public String handleRuntime(RuntimeException ex, Model model) {
        // Put a friendly message into the model to be shown on a generic error page
        model.addAttribute("errorMessage", ex.getMessage() != null ? ex.getMessage() : "Đã có lỗi xảy ra.");
        return "error/500"; // ensure there is a view for this or update as needed
    }
}
