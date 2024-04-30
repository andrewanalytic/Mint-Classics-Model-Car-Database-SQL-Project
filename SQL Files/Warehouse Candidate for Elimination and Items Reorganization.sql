### Where are items stored and if they were rearranged, could a warehouse be eliminated?

# To determine the viability of eliminating a warehouse, I've assessed three key factors: warehouse capacity, sales generated from each warehouse's inventory, and the inventory levels within each warehouse. Subsequently, I've analyzed the ratios of sales to inventory and inventory to capacity.

# total orders from each warehouse
CREATE TABLE IF NOT EXISTS `warehouse_orders` AS
SELECT subquery.warehouseCode,
	   sum(subquery.totalOrdered) AS total_orders
FROM 
(	
    SELECT p.productCode,
		   p.warehouseCode,
		   sum(od.quantityOrdered) as totalOrdered
	FROM products as p
	LEFT JOIN orderdetails as od ON p.productCode = od.productCode
	GROUP BY p.productCode, P.warehouseCode
    ) as subquery
GROUP BY subquery.warehouseCode;

# the inventory quantity in each warehouse
CREATE TABLE IF NOT EXISTS `warehouse_inventory` AS
SELECT warehouseCode,
	   sum(quantityInStock)
FROM products
GROUP BY warehouseCode;    

# ware house quantity
SELECT * FROM mintclassics.warehouses;


## Conclusion:
# To ensure that any warehouse elimination does not disrupt operational efficiency or customer satisfaction, comprehensive data on warehouse logistics and transportation is essential. However, based on the available data, a plausible conclusion can be drawn.
# Warehouse D exhibits the highest sales-to-inventory ratio, despite having fewer total orders compared to other warehouses. Moreover, although Warehouse D maintains a smaller inventory quantity, it utilizes 75% of its capacity, indicating efficient capacity utilization. Conversely, Warehouse C operates at only 50% capacity, suggesting inefficiency in resource utilization.
# While Warehouse D's higher capacity utilization suggests operational efficiency, Warehouse C's suboptimal capacity usage presents an opportunity for improvement. Eliminating Warehouse C could yield cost savings and capitalize on underutilized space.
# However, the final decision between Warehouse C and D should consider additional factors such as supply chain efficiency, transportation costs, customer proximity, and transportation services availability. Evaluating these factors comprehensively will inform the optimal course of action.

# In addition, analyzing specific product lines within each warehouse further supports this decision:
SELECT count(productCode),
	   productLine,
	   warehouseCode
FROM products
GROUP BY warehouseCode, productLine;

## Conclusion:
# Considering that Warehouse D stores larger vehicle products, which may incur higher transportation costs, Warehouse C emerges as the more optimal candidate for elimination. Furthermore, given the similarity between vintage and classic cars, consolidating Warehouse C's inventory into Warehouse B appears feasible. This consolidation, coupled with the liquidation of excess inventory, would free up warehouse space, which also mitigates concerns about capacity constraints.
