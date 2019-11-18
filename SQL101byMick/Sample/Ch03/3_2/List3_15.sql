SELECT purchase_price, COUNT(*)
  FROM Product
 WHERE product_type = 'ÒÂ·þ'
 GROUP BY purchase_price;