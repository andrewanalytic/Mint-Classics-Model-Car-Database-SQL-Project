### Are we storing items that are not moving? Are any items candidates for being dropped from the product line?

# To address this question, I examined the “products” and “orderdetails” tables to identify products that have never received any orders. 

SELECT 
    p.productCode,
    p.productName,
    p.productLine,
    p.quantityInStock,
    sum(od.quantityOrdered) AS totalOrdered
FROM 
    products AS p
LEFT JOIN 
    orderdetails AS od ON p.productCode = od.productCode
GROUP BY 
    p.productCode,
    p.productName,
    p.productLine,
    p.quantityInStock
HAVING 
    totalOrdered IS NULL OR totalOrdered = 0
ORDER BY 
    p.quantityInStock DESC;

## Conclusion:
# “1985 Toyota Supra” from product line “Classic Cars” with inventory quantity of 7733 has had 0 orders. 
