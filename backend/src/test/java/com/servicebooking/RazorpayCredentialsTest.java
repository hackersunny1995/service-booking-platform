package com.servicebooking;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import org.json.JSONObject;

/**
 * Standalone test to verify Razorpay credentials
 * Run this to test if your API keys work independently
 */
public class RazorpayCredentialsTest {

    public static void main(String[] args) {
        // Replace these with your actual credentials
        String keyId = "rzp_test_1DP5mmOlF5G5ag";
        String keySecret = "V5t3iIo0HuWte2UP1O4bnepJ";

        System.out.println("Testing Razorpay Credentials...");
        System.out.println("Key ID: " + keyId);
        System.out.println("Key Secret Length: " + keySecret.length());
        System.out.println("Key Secret (first 4 chars): " + keySecret.substring(0, 4) + "...");
        System.out.println();

        try {
            // Create Razorpay client
            RazorpayClient razorpayClient = new RazorpayClient(keyId, keySecret);
            System.out.println("✓ RazorpayClient created successfully");

            // Create a test order
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", 100); // 1 INR in paise
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "TEST_" + System.currentTimeMillis());

            System.out.println("\nCreating test order...");
            Order order = razorpayClient.orders.create(orderRequest);

            System.out.println("\n✓✓✓ SUCCESS! ✓✓✓");
            System.out.println("Order ID: " + order.get("id"));
            System.out.println("Amount: " + order.get("amount"));
            System.out.println("Currency: " + order.get("currency"));
            System.out.println("Status: " + order.get("status"));
            System.out.println("\nYour Razorpay credentials are working correctly!");

        } catch (RazorpayException e) {
            System.err.println("\n✗✗✗ FAILURE ✗✗✗");
            System.err.println("Error Code: " + e.getCode());
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("\nPossible causes:");
            System.err.println("1. Invalid API credentials");
            System.err.println("2. Razorpay account not activated");
            System.err.println("3. API keys revoked/expired");
            System.err.println("4. Network connectivity issues");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("\n✗✗✗ UNEXPECTED ERROR ✗✗✗");
            e.printStackTrace();
        }
    }
}
