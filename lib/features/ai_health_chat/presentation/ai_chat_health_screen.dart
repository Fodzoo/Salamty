import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme_provider/theme_provider.dart';

class AiChatHealthScreen extends StatefulWidget {
  const AiChatHealthScreen({super.key});

  @override
  State<AiChatHealthScreen> createState() => _AiChatHealthScreenState();
}

class _AiChatHealthScreenState extends State<AiChatHealthScreen> {
  final TextEditingController text = TextEditingController();
  final ScrollController scroll = ScrollController();

  List<Map<String, String>> chat = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return;

    setState(() => isLoading = true);

    try {
      final response = await client
          .from('chat_history')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', ascending: true);

      if (response != null && response is List) {
        List<Map<String, String>> loadedChat = [];
        for (var row in response) {
          if (row['user_message'] != null) {
            loadedChat.add({"message": row['user_message'].toString(), "sender": "user"});
          }
          if (row['ai_response'] != null) {
            loadedChat.add({"message": row['ai_response'].toString(), "sender": "ai"});
          }
        }
        setState(() => chat = loadedChat);
        autoScroll();
      }
    } catch (e) {
      print("Error loading history: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<String> sendMessageToAI(String message) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    final session = client.auth.currentSession;
    final token = session?.accessToken;

    if (user == null || token == null) return "User not logged in";

    try {
      final res = await http.post(
        Uri.parse("https://emdrsbvdwazingirktby.supabase.co/functions/v1/ai-medical-chat"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"message": message, "user_id": user.id}),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) return "Server error: ${res.body}";

      final data = jsonDecode(res.body);
      return data['reply'] ?? data['data']?['reply'] ?? "No response from AI";
    } catch (e) {
      return "Connection error: $e";
    }
  }

  void autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() async {
    if (text.text.trim().isEmpty || isLoading) return;

    final message = text.text.trim();
    setState(() {
      chat.add({"message": message, "sender": "user"});
      text.clear();
      isLoading = true;
    });

    autoScroll();
    final reply = await sendMessageToAI(message);

    setState(() {
      chat.add({"message": reply, "sender": "ai"});
      isLoading = false;
    });

    autoScroll();
  }

  @override
  void dispose() {
    text.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isArabic ? "مساعد الذكاء الطبي" : "AI Health Assistant",                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.health_and_safety,
                      color: cs.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            /// CHAT
            Expanded(
              child: ListView.builder(
                controller: scroll,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: chat.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == chat.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          isArabic ? "الذكاء الاصطناعي يكتب..." : "AI is typing...",
                          style: TextStyle(color: cs.onSurfaceVariant),
                        ),
                      ),
                    );
                  }

                  final item = chat[index];
                  final isUser = item['sender'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? cs.primary : cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(18),

                      ),
                      child: Text(
                        item['message'] ?? "",
                        style: TextStyle(
                          color: isUser ? cs.onPrimary : cs.onSurface,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// INPUT
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cs.surfaceContainer,
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: text,
                      onSubmitted: (_) => sendMessage(),
                      style: TextStyle(color: cs.onSurface),
                      decoration: InputDecoration(
                        hintText: isArabic ? "اسأل أي شيء..." : "Ask anything...",
                        hintStyle: TextStyle(color: cs.onSurfaceVariant),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary,
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: cs.onPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}