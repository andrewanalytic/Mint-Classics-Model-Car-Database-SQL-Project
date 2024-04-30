### How are inventory numbers related to sales figures? Do the inventory counts seem appropriate for each item?
# In order to answer this question, I've conducted an analysis comparing the total quantity of products within each product line to the overall number of orders associated with those lines. By examining this relationship, we can determine whether inventory levels align appropriately with sales figures. If a particular product line demonstrates low sales relative to its inventory, we can consider lowering stock levels for that entire line.
# Step1:

CREATE TABLE IF NOT EXISTS `product_orders` AS
SELECT productCode,
	   sum(quantityOrdered) as totalQuantityOrdered
FROM orderdetails
GROUP BY productCode;

SELECT p.productLine,
	   count(p.productCode) numProduct,
       sum(p.quantityInStock) as totalInStock,
       sum(po.totalQuantityOrdered) as totalOrdered,
       sum(po.totalQuantityOrdered)/sum(p.quantityInStock)*100 AS salesPercent
FROM products as p
LEFT JOIN product_orders as po on p.productCode = po.productCode
GROUP BY p.productLine;

## Conclusion: 
# Trains and Classic Cars seem to register the lowest sales percentages relative to the stocked quantity of products. The substantial inventory of Classic Cars can be somewhat justified, given Mint Classics' specialization in classic automobiles. However, there's potential for further investigation into individual product performance within this category to identify any slow-selling items warranting inventory reduction. 
# Similarly, the modest number of orders for Trains may be attributed to the limited variety within this product line. Therefore, a closer examination of both lines is necessary to pinpoint specific products with sluggish sales and consider adjusting their inventory levels accordingly.
# Step 2:
# Continuing the analysis, I'll examine the quantity of stock and total order quantity for all products, focusing on the inventory-to-order ratio. Subsequently, I'll narrow down the investigation to the two product lines exhibiting slower sales.

SELECT p.productName,
       p.quantityInStock,
       sum(o.quantityOrdered) AS totalQuantityOrdered,
       p.quantityInStock/sum(o.quantityOrdered) AS remainingStock
FROM products AS p
JOIN orderdetails AS O ON p.productCode = o.productCode
GROUP BY p.warehouseCode, p.productCode, p.productName, p.quantityInStock
ORDER BY p.quantityInStock/sum(o.quantityOrdered) DESC;

## Conclusion:
# The query results reveal that many products exhibit significantly high inventory-to-order ratios, with some exceeding 8, 9, or even 10 times the order quantity. Liquidating excess inventory for these products could optimize inventory space and unlock capital for the business. As a preliminary measure, I suggest refraining from restocking products with remaining stock levels exceeding 5000 units, although this threshold may vary depending on stakeholder preferences.

# To delve deeper into the analysis, I'll focus on the "Trains" and "Classic Cars" product lines to assess individual items contributing to lower sales-to-inventory ratios. I'll apply a WHERE clause to filter the results accordingly, starting with "Trains" and subsequently examining "Classic Cars."

SELECT p.productName,
       p.quantityInStock,
       sum(o.quantityOrdered) AS totalQuantityOrdered,
       p.quantityInStock/sum(o.quantityOrdered) AS remainingStock
FROM products AS p
JOIN orderdetails AS O ON p.productCode = o.productCode
WHERE p.productLine = “Trains”
GROUP BY p.warehouseCode, p.productCode, p.productName, p.quantityInStock
ORDER BY p.quantityInStock/sum(o.quantityOrdered) DESC;


## Conclusion:
# Based on the analysis findings, it appears that the products "1950's Chicago Surface Lines Streetcar" and "Collectable Wooden Train" have excessive quantities stored relative to the number of orders received. Conversely, the product "1962 City of Detroit Streetcar" demonstrates stronger sales performance compared to other train-related items, despite having a significantly lower quantity available in stock. Considering this, a slight increase in the inventory for "1962 City of Detroit Streetcar" could potentially capitalize on its higher sales demand.
SELECT p.productName,
       p.quantityInStock,
       sum(o.quantityOrdered) AS totalQuantityOrdered,
       p.quantityInStock/sum(o.quantityOrdered) AS remainingStock
FROM products AS p
JOIN orderdetails AS O ON p.productCode = o.productCode
WHERE p.productLine = “Classic Cars”
GROUP BY p.warehouseCode, p.productCode, p.productName, p.quantityInStock
ORDER BY p.quantityInStock/sum(o.quantityOrdered) DESC;

## Conclusion:
# As evident from the results, all Classic Cars products have recorded sales ranging from 767 to 1808 units, with the majority hovering around the 1000-unit mark. Despite this, the remaining quantity in stock for most of these products remains notably high, reaching up to 9770 units. Reducing these quantities to approximately 5000 to 6000 units per product will optimize inventory space. This adjustment would help alleviate excess inventory and better align stock levels with sales figures.
