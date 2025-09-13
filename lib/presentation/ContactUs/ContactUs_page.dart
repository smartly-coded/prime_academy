
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/validators.dart';
import 'package:prime_academy/features/contact_us/data/models/inquery_model.dart';
import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
import 'package:prime_academy/features/contact_us/logic/inquiry_state.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  final _formKey = GlobalKey<FormState>(); 
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return BlocConsumer<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إرسال الرسالة بنجاح ✅")),
          );
          _nameController.clear();
          _phoneController.clear();
          _messageController.clear();
        } else if (state is ContactUsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("فشل الإرسال: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildHeader(isMobile),
                      const SizedBox(height: 25),

                      _buildTitle(isMobile),
                      const SizedBox(height: 20),

                      _buildDescription(isMobile),
                      const SizedBox(height: 30),

                      _buildTextFieldWithIcon(
                        controller: _nameController,
                        hintText: "اسمك بالكامل",
                        icon: Icons.person,
                        isMobile: isMobile,
                        validator: Validators.validateFullName,
                      ),
                      const SizedBox(height: 20),

                      _buildTextFieldWithIcon(
                        controller: _phoneController,
                        hintText: "رقم هاتفك المحمول",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isMobile: isMobile,
                        validator: Validators.validateKuwaitPhone,
                      ),
                      const SizedBox(height: 20),

                      _buildMessageFieldWithSendIcon(
                        controller: _messageController,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 30),

                      _buildSendButton(context, state, isMobile),

                      const SizedBox(height: 40),
                      Image.asset(
                        "assets/Gifs/hellogirl.gif",
                        height: isMobile ? 120 : 160,
                      ),
                      const SizedBox(height: 30),

                      _buildSocialBox(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSendButton(
      BuildContext context, ContactUsState state, bool isMobile) {
    return GestureDetector(
      onTap: state is ContactUsLoading
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                
                final request = InquiryRequest(
                  fullname: _nameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  content: _messageController.text.trim(),
                );
                context.read<ContactUsCubit>().sendInquiry(request);
              }
            },
      child: Container(
        width: double.infinity,
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
            color: const Color.fromARGB(255, 38, 45, 58),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: state is ContactUsLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
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
    );
  }

  Widget _buildHeader(bool isMobile) => Container(
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
      );

  Widget _buildTitle(bool isMobile) => Text(
        "لديك أي أسئلة؟",
        style: TextStyle(
          fontSize: isMobile ? 20 : 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
      );

  Widget _buildDescription(bool isMobile) => Text(
        "نحن هنا لمساعدتك وإجابة على جميع استفساراتك واختياجاتك التعليمية.\nلا تتردد في الاتصال بنا للحصول على المساعدة وتقديم ملاحظاتك.",
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          color: Colors.white70,
          fontFamily: 'Cairo',
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      );

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isMobile,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
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
                controller: controller,
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
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFieldWithSendIcon({
    required TextEditingController controller,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 45 : 50,
            height: isMobile ? 90 : 100,
            child: const Icon(Icons.send, color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
              child: TextFormField(
                controller: controller,
                validator: Validators.validateMessage,
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

  Widget _buildSocialBox(bool isMobile) => Container(
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
      );

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
