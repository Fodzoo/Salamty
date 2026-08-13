import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    final sections = isArabic ? _arabicSections : _englishSections;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          const SizedBox(height: 24),

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: cs.onSurface),
                ),
                const SizedBox(width: 12),
                Text(
                  isArabic ? "شروط الخدمة" : "Terms of Service",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: cs.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? "سلامتي" : "Salamty",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic
                                    ? "آخر تحديث: يناير 2025"
                                    : "Last updated: January 2025",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onPrimaryContainer.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// SECTIONS
                  ...sections.map(
                    (section) => _buildSection(
                      cs: cs,
                      icon: section['icon'] as IconData,
                      title: section['title'] as String,
                      body: section['body'] as String,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required ColorScheme cs,
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cs.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static const _englishSections = [
    {
      'icon': Icons.handshake_outlined,
      'title': 'Agreement to Terms',
      'body':
          'By downloading or using Salamty, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our application. We reserve the right to update these terms at any time, and continued use of the app constitutes acceptance of any changes.',
    },
    {
      'icon': Icons.person_outline,
      'title': 'Eligibility',
      'body':
          'You must be at least 13 years of age to use Salamty. By using the app, you confirm that you meet this age requirement. If you are under 18, you should use the app only with the involvement and consent of a parent or guardian.',
    },
    {
      'icon': Icons.medical_services_outlined,
      'title': 'Medical Disclaimer',
      'body':
          'Salamty is an AI-powered health information tool and is NOT a substitute for professional medical advice, diagnosis, or treatment. The information provided by our AI — including drug interaction checks, lab analysis, radiology insights, and emergency guidance — is for informational purposes only. Always seek the advice of a qualified healthcare provider for any medical condition.',
    },
    {
      'icon': Icons.health_and_safety_outlined,
      'title': 'Emergency Situations',
      'body':
          'Salamty\'s Emergency AI feature is designed to provide general first-aid guidance only. In any life-threatening situation, please call emergency services immediately (123 in Egypt). Do not rely solely on the app in an emergency. Salamty is not responsible for outcomes arising from emergency situations.',
    },
    {
      'icon': Icons.manage_accounts_outlined,
      'title': 'Account Responsibilities',
      'body':
          'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate and complete information during registration and to keep your profile updated. Notify us immediately if you suspect unauthorized use of your account.',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'User-Uploaded Content',
      'body':
          'When you upload lab tests, radiology scans, or other medical documents, you confirm that you have the right to share this content. You grant Salamty a limited license to process and analyze this content solely for the purpose of providing you with AI-generated health insights within the app.',
    },
    {
      'icon': Icons.block_outlined,
      'title': 'Prohibited Activities',
      'body':
          'You agree not to misuse Salamty. Prohibited activities include: attempting to access other users\' data, uploading harmful or malicious content, using the app for any unlawful purpose, attempting to reverse-engineer or tamper with the app, and providing false medical information that could harm others.',
    },
    {
      'icon': Icons.workspace_premium_outlined,
      'title': 'Intellectual Property',
      'body':
          'All content, features, and functionality of Salamty — including the AI models, design, code, and branding — are the exclusive property of Salamty and are protected by applicable intellectual property laws. You may not copy, modify, or distribute any part of the app without our explicit written permission.',
    },
    {
      'icon': Icons.gpp_maybe_outlined,
      'title': 'Limitation of Liability',
      'body':
          'Salamty and its developers shall not be liable for any indirect, incidental, or consequential damages arising from your use of the app. This includes any harm resulting from reliance on AI-generated health information. Use of the app is at your own risk.',
    },
    {
      'icon': Icons.update_outlined,
      'title': 'Changes to the Service',
      'body':
          'We reserve the right to modify, suspend, or discontinue any part of Salamty at any time without prior notice. We may also update these Terms of Service periodically. Your continued use of the app after any changes constitutes your acceptance of the new terms.',
    },
    {
      'icon': Icons.contact_mail_outlined,
      'title': 'Contact Us',
      'body':
          'If you have any questions about these Terms of Service, please contact us at support@salamty.app. We are happy to address any concerns you may have about your rights and responsibilities as a Salamty user.',
    },
  ];

  static const _arabicSections = [
    {
      'icon': Icons.handshake_outlined,
      'title': 'الموافقة على الشروط',
      'body':
          'بتنزيلك أو استخدامك لتطبيق سلامتي، فإنك توافق على الالتزام بشروط الخدمة هذه. إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق. نحتفظ بالحق في تحديث هذه الشروط في أي وقت، ويُعدّ الاستمرار في استخدام التطبيق قبولاً لأي تغييرات.',
    },
    {
      'icon': Icons.person_outline,
      'title': 'شروط الأهلية',
      'body':
          'يجب أن يكون عمرك 13 عاماً على الأقل لاستخدام سلامتي. باستخدامك للتطبيق، فإنك تؤكد استيفاءك لهذا الشرط. إذا كنت دون 18 عاماً، يجب عليك استخدام التطبيق بمشاركة وموافقة أحد الوالدين أو الأوصياء.',
    },
    {
      'icon': Icons.medical_services_outlined,
      'title': 'إخلاء المسؤولية الطبية',
      'body':
          'سلامتي هو أداة معلومات صحية مدعومة بالذكاء الاصطناعي وليس بديلاً عن المشورة الطبية المتخصصة أو التشخيص أو العلاج. المعلومات التي يقدمها الذكاء الاصطناعي — بما في ذلك فحص التفاعلات الدوائية وتحليل التحاليل والأشعة وإرشادات الطوارئ — هي لأغراض إعلامية فقط. استشر دائماً مقدم رعاية صحية مؤهلاً لأي حالة طبية.',
    },
    {
      'icon': Icons.health_and_safety_outlined,
      'title': 'حالات الطوارئ',
      'body':
          'تم تصميم ميزة الطوارئ في سلامتي لتقديم إرشادات الإسعافات الأولية العامة فقط. في أي موقف يهدد الحياة، يرجى الاتصال بخدمات الطوارئ فوراً (123 في مصر). لا تعتمد على التطبيق وحده في حالات الطوارئ. سلامتي غير مسؤول عن النتائج الناجمة عن حالات الطوارئ.',
    },
    {
      'icon': Icons.manage_accounts_outlined,
      'title': 'مسؤوليات الحساب',
      'body':
          'أنت مسؤول عن الحفاظ على سرية بيانات اعتماد حسابك وعن جميع الأنشطة التي تتم تحت حسابك. توافق على تقديم معلومات دقيقة وكاملة أثناء التسجيل وتحديث ملفك الشخصي باستمرار. أخطرنا فوراً إذا اشتبهت في استخدام غير مصرح به لحسابك.',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'المحتوى الذي يحمله المستخدم',
      'body':
          'عند تحميل نتائج التحاليل أو الأشعة أو المستندات الطبية الأخرى، فإنك تؤكد أن لديك الحق في مشاركة هذا المحتوى. تمنح سلامتي ترخيصاً محدوداً لمعالجة هذا المحتوى وتحليله فقط بغرض تزويدك برؤى صحية مولّدة بالذكاء الاصطناعي داخل التطبيق.',
    },
    {
      'icon': Icons.block_outlined,
      'title': 'الأنشطة المحظورة',
      'body':
          'توافق على عدم إساءة استخدام سلامتي. تشمل الأنشطة المحظورة: محاولة الوصول إلى بيانات المستخدمين الآخرين، تحميل محتوى ضار أو خبيث، استخدام التطبيق لأي غرض غير قانوني، محاولة الهندسة العكسية أو التلاعب بالتطبيق، وتقديم معلومات طبية كاذبة قد تضر بالآخرين.',
    },
    {
      'icon': Icons.workspace_premium_outlined,
      'title': 'الملكية الفكرية',
      'body':
          'جميع محتويات وميزات ووظائف سلامتي — بما في ذلك نماذج الذكاء الاصطناعي والتصميم والكود والعلامة التجارية — هي الملكية الحصرية لسلامتي ومحمية بموجب قوانين الملكية الفكرية المعمول بها. لا يجوز لك نسخ أو تعديل أو توزيع أي جزء من التطبيق دون إذن كتابي صريح منا.',
    },
    {
      'icon': Icons.gpp_maybe_outlined,
      'title': 'تحديد المسؤولية',
      'body':
          'لن يكون سلامتي ومطوروه مسؤولين عن أي أضرار غير مباشرة أو عرضية أو تبعية ناجمة عن استخدامك للتطبيق. يشمل ذلك أي ضرر ناتج عن الاعتماد على المعلومات الصحية المولّدة بالذكاء الاصطناعي. استخدام التطبيق على مسؤوليتك الخاصة.',
    },
    {
      'icon': Icons.update_outlined,
      'title': 'التغييرات على الخدمة',
      'body':
          'نحتفظ بالحق في تعديل أو تعليق أو إيقاف أي جزء من سلامتي في أي وقت دون إشعار مسبق. قد نقوم أيضاً بتحديث شروط الخدمة هذه بشكل دوري. استمرارك في استخدام التطبيق بعد أي تغييرات يُعدّ قبولاً للشروط الجديدة.',
    },
    {
      'icon': Icons.contact_mail_outlined,
      'title': 'تواصل معنا',
      'body':
          'إذا كان لديك أي أسئلة حول شروط الخدمة هذه، يرجى التواصل معنا على support@salamty.app. يسعدنا معالجة أي مخاوف قد تكون لديك بشأن حقوقك ومسؤولياتك كمستخدم لسلامتي.',
    },
  ];
}
