package com.servicebooking;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;

public class RazorpayApiTest {

    @Test
    public void testRazorpayCredentials() {
        String keyId = "rzp_test_SAnYf1YwWqJZD1";
        String keySecret = "aC1OPW6x3tX0r0sYbTQ3RbLr";

        System.out.println("Testing Razorpay Credentials...");
        System.out.println("Key ID: " + keyId);
        System.out.println("Key Secret Length: " + keySecret.length());
        System.out.println();

        try {
            RazorpayClient razorpayClient = new RazorpayClient(keyId, keySecret);
            System.out.println("✓ RazorpayClient created successfully");

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", 100);
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
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("\nPossible causes:");
            System.err.println("1. Invalid API credentials");
            System.err.println("2. Razorpay account not activated");
            System.err.println("3. API keys revoked/expired");
            System.err.println("4. Network connectivity issues");
            e.printStackTrace();
            throw new RuntimeException("Razorpay test failed", e);
        }
    }
}
