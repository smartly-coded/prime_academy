import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 40,
          horizontal: isMobile ? 20 : width * 0.1,
        ),
        color: const Color(0xFF0f1217),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffa76433), Color(0xff4f2349)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 38, 45, 58),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "تواصل معنا",
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    "لديك أي أسئلة؟",
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "نحن هنا لمساعدتك وإجابة على جميع استفساراتك واختياجاتك التعليمية.\nلا تتردد في الاتصال بنا للحصول على المساعدة وتقديم ملاحظاتك.",
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                _buildTextFieldWithIcon(
                  hintText: "اسمك بالكامل",
                  icon: Icons.person,
                  isMobile: isMobile,
                ),

                const SizedBox(height: 20),

                _buildTextFieldWithIcon(
                  hintText: "رقم هاتفك المحمول",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  isMobile: isMobile,
                ),

                const SizedBox(height: 20),

                _buildMessageFieldWithSendIcon(isMobile: isMobile),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffa76433), Color(0xff4f2349)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 38, 45, 58),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "إرسال",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Image.asset(
                    "assets/Gifs/hellogirl.gif",
                    height: isMobile ? 120 : 160,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffa76433), Color(0xff4f2349)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 38, 45, 58),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "أو راسلنا عبر مواقع التواصل الاجتماعي",
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialIcon(Icons.facebook, 'Facebook'),
                            const SizedBox(width: 15),
                            _buildSocialIcon(Icons.chat, 'WhatsApp'),
                            const SizedBox(width: 15),
                            _buildSocialIcon(Icons.camera_alt, 'Instagram'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required String hintText,
    required IconData icon,
    required bool isMobile,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 45 : 50,
            height: maxLines > 1 ? (isMobile ? 90 : 100) : (isMobile ? 45 : 50),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: isMobile ? 20 : 24),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Cairo',
                    fontSize: isMobile ? 14 : 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: maxLines > 1 ? 16 : (isMobile ? 12 : 0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: isMobile ? 14 : 16,
                ),
                keyboardType: keyboardType,
                maxLines: maxLines,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFieldWithSendIcon({required bool isMobile}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 45 : 50,
            height: isMobile ? 90 : 100,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: isMobile ? 20 : 24,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "اكتب رسالتك",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Cairo',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: isMobile ? 14 : 16,
                ),
                maxLines: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2a2d34),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: () {},
        tooltip: tooltip,
      ),
    );
  }
}
