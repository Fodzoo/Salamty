import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                  isArabic ? "سياسة الخصوصية" : "Privacy Policy",
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
                          Icons.privacy_tip_outlined,
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
      'icon': Icons.info_outline,
      'title': 'Introduction',
      'body':
          'Welcome to Salamty, your AI-powered health assistant. We are committed to protecting your personal and medical information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our application.',
    },
    {
      'icon': Icons.folder_outlined,
      'title': 'Information We Collect',
      'body':
          'We collect information you provide during registration, including your name, email, phone number, date of birth, gender, height, weight, blood type, chronic diseases, and allergies. We also collect health-related data you share through our AI chat, lab test uploads, radiology scans, and drug interaction checks.',
    },
    {
      'icon': Icons.medical_services_outlined,
      'title': 'How We Use Your Data',
      'body':
          'Your data is used to provide personalized AI health assistance, analyze lab tests and radiology scans, check drug interactions, and improve emergency guidance. We use your health profile to deliver more accurate and relevant medical insights.',
    },
    {
      'icon': Icons.lock_outline,
      'title': 'Data Security',
      'body':
          'All your data is stored securely using Supabase infrastructure with industry-standard encryption. Your medical records, chat history, and uploaded files are protected and accessible only to you. We never sell your data to third parties.',
    },
    {
      'icon': Icons.share_outlined,
      'title': 'Data Sharing',
      'body':
          'We do not share your personal or medical information with any third parties. Your data is only used within the Salamty application to provide you with the best possible health assistance.',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'Medical Files & Records',
      'body':
          'Lab test results, radiology scans, and other medical documents you upload are stored securely in our cloud storage. These files are used solely for AI analysis within the app and are never shared or sold.',
    },
    {
      'icon': Icons.psychology_outlined,
      'title': 'AI & Medical Advice',
      'body':
          'Salamty uses AI to provide health insights and guidance. Please note that all information provided by our AI is for informational purposes only and does not replace professional medical advice. Always consult a qualified healthcare provider for medical decisions.',
    },
    {
      'icon': Icons.person_outline,
      'title': 'Your Rights',
      'body':
          'You have the right to access, update, or delete your personal data at any time through the Profile and Settings sections of the app. You may also request complete data deletion by contacting us directly.',
    },
    {
      'icon': Icons.child_care_outlined,
      'title': "Children's Privacy",
      'body':
          'Salamty is not intended for use by children under the age of 13. We do not knowingly collect personal information from children. If you believe a child has provided us with their data, please contact us immediately.',
    },
    {
      'icon': Icons.contact_mail_outlined,
      'title': 'Contact Us',
      'body':
          'If you have any questions or concerns about this Privacy Policy or your data, please contact us at support@salamty.app. We are committed to addressing your concerns promptly and transparently.',
    },
  ];

  static const _arabicSections = [
    {
      'icon': Icons.info_outline,
      'title': 'مقدمة',
      'body':
          'مرحباً بك في سلامتي، مساعدك الصحي المدعوم بالذكاء الاصطناعي. نحن ملتزمون بحماية معلوماتك الشخصية والطبية. توضح سياسة الخصوصية هذه كيفية جمع بياناتك واستخدامها وحمايتها عند استخدام تطبيقنا.',
    },
    {
      'icon': Icons.folder_outlined,
      'title': 'المعلومات التي نجمعها',
      'body':
          'نجمع المعلومات التي تقدمها أثناء التسجيل، بما في ذلك اسمك وبريدك الإلكتروني ورقم هاتفك وتاريخ ميلادك وجنسك وطولك ووزنك وفصيلة دمك والأمراض المزمنة والحساسية. كما نجمع البيانات الصحية التي تشاركها من خلال محادثات الذكاء الاصطناعي وتحميل نتائج التحاليل والأشعة وفحص التفاعلات الدوائية.',
    },
    {
      'icon': Icons.medical_services_outlined,
      'title': 'كيف نستخدم بياناتك',
      'body':
          'تُستخدم بياناتك لتقديم مساعدة صحية مخصصة بالذكاء الاصطناعي، وتحليل نتائج التحاليل والأشعة، وفحص التفاعلات الدوائية، وتحسين التوجيه في حالات الطوارئ. نستخدم ملفك الصحي لتقديم رؤى طبية أكثر دقة وملاءمة.',
    },
    {
      'icon': Icons.lock_outline,
      'title': 'أمان البيانات',
      'body':
          'يتم تخزين جميع بياناتك بأمان باستخدام بنية Supabase التحتية مع التشفير المعتمد في الصناعة. سجلاتك الطبية وسجل المحادثات والملفات المحملة محمية ولا يمكن الوصول إليها إلا لك. لا نبيع بياناتك أبداً لأطراف ثالثة.',
    },
    {
      'icon': Icons.share_outlined,
      'title': 'مشاركة البيانات',
      'body':
          'لا نشارك معلوماتك الشخصية أو الطبية مع أي أطراف ثالثة. تُستخدم بياناتك فقط داخل تطبيق سلامتي لتزويدك بأفضل مساعدة صحية ممكنة.',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'الملفات والسجلات الطبية',
      'body':
          'يتم تخزين نتائج التحاليل والأشعة والوثائق الطبية التي تحملها بأمان في سحابتنا. تُستخدم هذه الملفات فقط للتحليل بالذكاء الاصطناعي داخل التطبيق ولا يتم مشاركتها أو بيعها أبداً.',
    },
    {
      'icon': Icons.psychology_outlined,
      'title': 'الذكاء الاصطناعي والنصائح الطبية',
      'body':
          'تستخدم سلامتي الذكاء الاصطناعي لتقديم رؤى وإرشادات صحية. يرجى ملاحظة أن جميع المعلومات المقدمة من الذكاء الاصطناعي هي لأغراض إعلامية فقط ولا تحل محل المشورة الطبية المتخصصة. استشر دائماً مقدم رعاية صحية مؤهلاً للقرارات الطبية.',
    },
    {
      'icon': Icons.person_outline,
      'title': 'حقوقك',
      'body':
          'يحق لك الوصول إلى بياناتك الشخصية وتحديثها أو حذفها في أي وقت من خلال قسمي الملف الشخصي والإعدادات في التطبيق. يمكنك أيضاً طلب حذف البيانات الكامل بالتواصل معنا مباشرة.',
    },
    {
      'icon': Icons.child_care_outlined,
      'title': 'خصوصية الأطفال',
      'body':
          'لا يُخصص تطبيق سلامتي للأطفال دون سن 13 عاماً. لا نجمع معلومات شخصية من الأطفال عن قصد. إذا كنت تعتقد أن طفلاً قد زودنا ببياناته، يرجى التواصل معنا فوراً.',
    },
    {
      'icon': Icons.contact_mail_outlined,
      'title': 'تواصل معنا',
      'body':
          'إذا كان لديك أي أسئلة أو مخاوف بشأن سياسة الخصوصية هذه أو بياناتك، يرجى التواصل معنا على support@salamty.app. نحن ملتزمون بمعالجة مخاوفك بسرعة وشفافية.',
    },
  ];
}
