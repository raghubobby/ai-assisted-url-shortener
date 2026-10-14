package com.aiassisted.urlshortener.api;

public class InvalidRequestException extends ApiException {
    private final String field;

    public InvalidRequestException(String field, String message) {
        super("INVALID_REQUEST", field + ": " + message);
        this.field = field;
    }

    public String field() { return field; }
}
