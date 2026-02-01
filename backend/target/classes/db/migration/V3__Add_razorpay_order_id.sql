-- Add razorpay_order_id column to payments table
ALTER TABLE payments ADD COLUMN razorpay_order_id VARCHAR(255);
