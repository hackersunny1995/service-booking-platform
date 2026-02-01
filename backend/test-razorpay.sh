#!/bin/bash
# Quick Razorpay credentials test

echo "Building project..."
mvn clean compile -DskipTests -q

echo -e "\nRunning Razorpay credentials test..."
mvn exec:java -Dexec.mainClass="com.servicebooking.RazorpayCredentialsTest" -q

echo -e "\nIf you see 'SUCCESS' above, your credentials work!"
echo "If you see 'FAILURE', update the credentials in the test file and in Railway."
