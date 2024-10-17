//
//  HelpAndSupportView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 14.10.2024.
//

import SwiftUI

struct HelpAndSupportView: View {
    var body: some View {
        GeometryReader {
            let top = $0.safeAreaInsets.top
            let bottom = $0.safeAreaInsets.bottom
            
            ScrollView {
                Spacer(minLength: top)
                
                Text("""
Welcome to our Help and Support section. We're here to assist you with any issues or questions you may have regarding our products and services. Below are common topics where we can help:

**1. Ordering Assistance**
If you need help placing an order or have questions about the products we offer, please feel free to reach out. You can find step-by-step guidance on how to make a purchase in the FAQ section or contact us directly for further support.

**2. Payment Issues**
Experiencing issues during checkout or with payment? Ensure that you’re using an accepted payment method. If problems persist, contact us for immediate assistance.

**3. Shipping Information**
You can track your order by entering your tracking number on our website. If you have questions about shipping times, costs, or if your package is delayed, please visit our Shipping Information page or reach out to our support team.

**4. Returns and Refunds**
Need to return a product? We accept returns within [insert number] days of receiving your order. Please visit the Returns and Refunds page for detailed instructions on how to initiate a return and receive a refund.

**5. Technical Support**
For any technical issues related to your products, such as setup or troubleshooting, please visit our Support Documentation page for detailed guides. If you still need help, our team is ready to assist.

**6. Product Warranty**
All Apple products purchased from our store come with a manufacturer's warranty. For more information about the warranty and how to make a claim, please refer to the warranty section of your product's documentation.

**7. Contact Us**
If you can’t find the answer to your question or need further help, our customer support team is available to assist you. You can reach us via email at [insert email] or by phone at [insert phone number].

**Customer Support Hours:**
- Monday to Friday: 9:00 AM - 6:00 PM (UTC+2)
- Saturday: 10:00 AM - 4:00 PM (UTC+2)
- Sunday: Closed

We’re committed to providing you with the best possible service. Don't hesitate to contact us for any assistance or support.
""")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer(minLength: bottom)
            }
            .navigationTitle("Help and support")
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HelpAndSupportView()
}
