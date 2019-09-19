#!/bin/bash
# run otp server
java -Xmx$HEAP -jar $OTP_JAR --graphs graphs --router default --server
