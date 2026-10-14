package com.aiassisted.urlshortener.api;

import java.util.List;

public record DetailedAnalyticsResponse(
        String code,
        long totalClicks,
        List<ClickEventResponse> events
) {}
