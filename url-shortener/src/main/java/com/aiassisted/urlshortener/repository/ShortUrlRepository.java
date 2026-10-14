package com.aiassisted.urlshortener.repository;

import com.aiassisted.urlshortener.domain.ShortUrlEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ShortUrlRepository extends JpaRepository<ShortUrlEntity, UUID> {
    Optional<ShortUrlEntity> findByShortCode(String shortCode);
    Optional<ShortUrlEntity> findByIdempotencyKey(String idempotencyKey);
}
