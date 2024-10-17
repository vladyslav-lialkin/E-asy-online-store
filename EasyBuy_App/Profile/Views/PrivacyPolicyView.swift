//
//  PrivacyPolicyView.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 14.10.2024.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        GeometryReader {
            let top = $0.safeAreaInsets.top
            let bottom = $0.safeAreaInsets.bottom
            
            ScrollView {
                Spacer(minLength: top)
                
                Text("""
This Privacy Policy describes how we collects, uses, and protects personal information that you provide when using our site.

**1. Information We Collect:**
We may collect the following types of data from users:
- Personal Data: Name, email address, phone number.
- Payment Information: Credit card details, transaction data.
- Order Data: Shipping address, purchase history.
- Technical Data: IP address, browser type, device information.

**2. How We Use Your Data:**
We use your data to:
- Process and fulfill orders.
- Improve the functionality of our store.
- Send important updates regarding your orders (confirmation, shipping, etc.).
- Send marketing messages (only with your consent).

**3. How We Protect Your Data:**
We take the security of your data seriously. We use:
- Encryption to protect sensitive information during transmission.
- Secure servers to store data.
- Access controls to ensure only authorized personnel can access your data.

Despite our efforts, no method of transmission over the Internet or method of storage is 100% secure. We strive to protect your data to the best of our ability.

**4. Third-Party Data Sharing:**
At this time, we do not share your data with any third-party companies or services. All collected data is used exclusively within our store.

**5. Your Rights:**
You have the right to:
- Request access to your personal data.
- Request correction or deletion of your data.
- Object to the processing of your data or request restrictions on its processing.

**6. Data Retention:**
We retain your personal data only as long as necessary to fulfill the purposes outlined in this policy or as required by law.

**7. Changes to This Privacy Policy:**
We may update this privacy policy from time to time. All changes will be posted on this page with the corresponding date.

""")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer(minLength: bottom)
            }
            .navigationTitle("Privacy Policy")
            .ignoresSafeArea()
        }
    }
}


#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
}
