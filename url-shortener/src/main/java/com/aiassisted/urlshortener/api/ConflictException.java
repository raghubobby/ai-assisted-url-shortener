package com.aiassisted.urlshortener.api;

public class ConflictException extends ApiException {
    public ConflictException(String code, String message) {
        super(code, message);
    }
}
