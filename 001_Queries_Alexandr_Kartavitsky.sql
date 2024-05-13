--first query
INSERT INTO products (product_name, unit_price)
SELECT 
    p.product_name,
    COALESCE(pr.unit_price, default_price * 1.05) AS unit_price -- Using COALESCE to set default price
FROM 
    (
        SELECT 
            product_name,
            AVG(unit_price) OVER () AS default_price -- Calculating average price as default
        FROM 
            products
    ) AS p
LEFT JOIN products pr ON p.product_name = pr.product_name
WHERE
    pr.product_name IS NULL -- Inserting only new products
ON CONFLICT DO NOTHING; -- Ignoring conflicts



--second query
INSERT INTO shippers (shipper_id, company_name)
VALUES 
    (1, 'New Shipper')
ON CONFLICT (shipper_id) -- Specify the column to check for conflicts (shipper_id)
    company_name = EXCLUDED.company_name; -- Update the shipper name
