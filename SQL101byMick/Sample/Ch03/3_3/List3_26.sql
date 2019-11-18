SELECT product_type, COUNT(*)
  FROM Product
WHERE product_type = 'ÒÂ·þ'
 GROUP BY product_type;