//
//  TermsAndConditionsView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 14.10.2024.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        GeometryReader {
            let top = $0.safeAreaInsets.top
            let bottom = $0.safeAreaInsets.bottom
            
            ScrollView {
                Spacer(minLength: top)
                
                Text("""
Welcome to our store. By using our website and making a purchase, you agree to the following terms and conditions. Please read them carefully.

**1. General**
These terms and conditions ("Terms") govern your use of our website and the services we provide. By accessing our website, you agree to comply with and be bound by these Terms.

**2. Products**
We sell Apple products and related accessories. All products are subject to availability. We reserve the right to modify or discontinue products at any time without prior notice.

**3. Orders**
By placing an order, you agree that all information you provide is accurate and complete. We reserve the right to refuse or cancel any orders at our discretion. Prices are subject to change without notice.

**4. Payment**
We accept payments via [insert payment methods]. All transactions must be completed before we process and ship your order. We are not responsible for any issues related to third-party payment providers.

**5. Shipping**
We currently ship to customers worldwide. Shipping times and costs may vary depending on the destination. We will do our best to ensure timely delivery, but we are not responsible for delays caused by factors beyond our control, such as customs processing or shipping carrier issues.

**6. Returns and Refunds**
We offer returns and refunds on defective or damaged items within [insert number] days of receipt. To initiate a return, please contact us at [insert contact method]. All items must be returned in their original packaging and condition.

**7. Intellectual Property**
All content on our website, including text, images, and logos, is our intellectual property or the intellectual property of our partners. You may not use, copy, or distribute any content without our prior written consent.

**8. Limitation of Liability**
We are not responsible for any direct, indirect, or consequential damages resulting from the use of our website, products, or services. Our liability is limited to the maximum extent permitted by law.

**9. Governing Law**
These Terms are governed by and construed in accordance with the laws of Ukraine. Any disputes arising out of these Terms will be resolved exclusively in the courts of Ukraine.

**10. Changes to These Terms**
We reserve the right to update these Terms at any time without prior notice. All changes will be effective immediately upon posting on this page.

By continuing to use our website after any changes to these Terms, you agree to be bound by the updated terms and conditions.
""")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer(minLength: bottom)
            }
            .navigationTitle("Terms and conditions")
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TermsAndConditionsView()
}
