-- =========================================================
-- PROJECT: MERCEDES-BENZ AUTOMOBILE MARKET ANALYSIS
-- =========================================================

-- 1. Table Creation
CREATE TABLE mercedes_listings (
    vehicle_name VARCHAR(255),
    model_year INT,
    vehicle_age INT,
    model_series VARCHAR(100),
    trim_level VARCHAR(100),
    body_type VARCHAR(50),
    is_amg INT,
    is_4matic INT,
    mileage_miles INT,
    mileage_category VARCHAR(50),
    price_usd DECIMAL(10, 2),
    price_category VARCHAR(50),
    price_per_mile DECIMAL(10, 4)
);

-- Note: Import your CSV file here using your SQL software import wizard.

-- 2. Average Price Analysis by Model Series (Top 10 Most Expensive)
SELECT 
    model_series, 
    ROUND(AVG(price_usd), 2) AS average_price,
    COUNT(*) AS total_listings
FROM mercedes_listings
GROUP BY model_series
ORDER BY average_price DESC
LIMIT 10;

-- 3. Depreciation Analysis: Impact of Vehicle Age on Market Price
SELECT 
    vehicle_age,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(mileage_miles), 0) AS avg_mileage
FROM mercedes_listings
GROUP BY vehicle_age
ORDER BY vehicle_age ASC;

-- 4. Premium Segmentation: AMG Performance vs Standard Models
SELECT 
    CASE WHEN is_amg = 1 THEN 'AMG Performance' ELSE 'Standard Model' END AS model_type,
    COUNT(*) AS total_units,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(price_per_mile), 2) AS avg_cost_per_mile
FROM mercedes_listings
GROUP BY is_amg;

-- 5. Market Deal Detection (Below Average Price with Low Mileage)
WITH global_stats AS (
    SELECT AVG(price_usd) AS avg_market_price FROM mercedes_listings
)
SELECT 
    vehicle_name, 
    price_usd, 
    mileage_miles, 
    mileage_category
FROM mercedes_listings, global_stats
WHERE price_usd < global_stats.avg_market_price 
AND mileage_category = 'Low (< 20K)'
ORDER BY price_usd ASC
LIMIT 5;