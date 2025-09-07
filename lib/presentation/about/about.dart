import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 36, 43, 56),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "من نحن",
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Text(
                "برايم أكاديمي",
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffa76433), Color(0xff4f2349)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 36, 43, 56),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "نبذة عنا",
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "المنصات التعليمية كثيره ومتعدده ولكن في برامم أكاديمي تقدم محتوي مختلف تماما عن طريق اتباع لأفضل الطرق الحديثه في توصيل المعلوماك واتباع انظمه الذكاء الاصطناعي التي تجذب الطلب نحو المذاكره والتحقيق والتطور.",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 36, 43, 56),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "انظمة برامم أكاديمي المبتكره",
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _buildFeatureItem(
                number: "1",
                title: "نظام الدوري التعليمي",
                content:
                    "وهو نظام يتبع للطالب التنافس من خلال المعلوماك الذين يكتسبونها من مُعلمين برامم أكاديمي وبالتالي تزداد ثقتهم في التسهم ويساعدهم هذا النظام على التأهيل على جو الامتحانات وكسر التوتر الذي يعاديهم أثناء تواجدهم في اللجنة.",
                isMobile: isMobile,
              ),

              const SizedBox(height: 25),

              _buildFeatureItem(
                number: "2",
                title: "الحصص المسجله واوراق العمل",
                content:
                    "يقوم المعلم بتسجيل الحصه ووضعها علي بروفليل الطالب حتى يكون مرجعا له في أي وقت بالإضافه التي أوراق العمل الذي يبتكرها المعلم بأسلوبه السفل والبسيط حتى يساعد الطالب علي المذاكره بشكل بسيط وسهل ويراعي المعلم وضع كل أفكار الامتحانات في أوراق العمل حتى نضمن للطالب العالمه الكاملة.",
                isMobile: isMobile,
              ),

              const SizedBox(height: 25),

              _buildFeatureItem(
                number: "3",
                title: "نظام المتابعه المستمره",
                content:
                    "يقوم المعلم بتصحيح الواجبات ومتابعه الطالب عبر المنصه وجروب الواتساب الخاص بالمجموعه حتى يبقى المعلم مع الطالب في كل الأوقات وليس وقت الحصه فقط.",
                isMobile: isMobile,
              ),

              const SizedBox(height: 25),

              _buildFeatureItem(
                number: "4",
                title: "الإداره والسيكرتاريه",
                content:
                    "تتميز إداره وسيكرتاريه برامم أكاديمي بالتعاون الدائم والمستمر والرد علي جميع الأسئلة في الحال وتسعيل أي عقبات لإولياء الأمور والطلاب.",
                isMobile: isMobile,
              ),

              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  "assets/Gifs/hellogirl.gif",
                  height: isMobile ? 120 : 160,
                ),
              ),

              const SizedBox(height: 30),

              Column(
                children: [
                  isMobile
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatCircle(
                                  value: "100%",
                                  label: "كفاءة المعلمين",
                                  icon: Icons.school,
                                  isMobile: isMobile,
                                ),
                                _buildStatCircle(
                                  value: "100%",
                                  label: "نتائج الطلاب",
                                  icon: Icons.emoji_events,
                                  isMobile: isMobile,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatCircle(
                                  value: "100%",
                                  label: "الكفاءة الإدارية",
                                  icon: Icons.manage_accounts,
                                  isMobile: isMobile,
                                ),
                                _buildStatCircle(
                                  value: "100%",
                                  label: "مهارة التواصل",
                                  icon: Icons.chat,
                                  isMobile: isMobile,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCircle(
                              value: "100%",
                              label: "كفاءة المعلمين",
                              icon: Icons.school,
                              isMobile: isMobile,
                            ),
                            _buildStatCircle(
                              value: "100%",
                              label: "نتائج الطلاب",
                              icon: Icons.emoji_events,
                              isMobile: isMobile,
                            ),
                            _buildStatCircle(
                              value: "100%",
                              label: "الكفاءة الإدارية",
                              icon: Icons.manage_accounts,
                              isMobile: isMobile,
                            ),
                            _buildStatCircle(
                              value: "100%",
                              label: "مهارة التواصل",
                              icon: Icons.chat,
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String number,
    required String title,
    required String content,
    required bool isMobile,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 43, 56),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 35 : 40,
            height: isMobile ? 35 : 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 16 : 18,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                    height: 1.6,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCircle({
    required String value,
    required String label,
    required IconData icon,
    required bool isMobile,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Container(
            width: isMobile ? 90 : 110,
            height: isMobile ? 90 : 110,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 36, 43, 56),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: isMobile ? 20 : 24),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.white70,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
