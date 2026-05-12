import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BMI Calculator",
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Poppins'),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  double? bmi;
  String category = "";
  String gender = "Male";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ─── Colors ───────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFF0D0D1A);
  static const Color _card = Color(0xFF1A1A2E);
  static const Color _accent = Color(0xFF7C4DFF);
  static const Color _accentLight = Color(0xFFB47AFF);
  static const Color _teal = Color(0xFF00E5CC);
  static const Color _textPrimary = Color(0xFFEEEEFF);
  static const Color _textSecondary = Color(0xFF9999BB);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // ─── BMI Logic ────────────────────────────────────────────────────────────
  void calculateBMI() {
    final heightText = heightController.text.trim();
    final weightText = weightController.text.trim();

    if (heightText.isEmpty || weightText.isEmpty) {
      _showSnackBar("Please fill in both height and weight.");
      return;
    }

    try {
      final double heightCm = double.parse(heightText);
      final double weightKg = double.parse(weightText);

      if (heightCm <= 0 || weightKg <= 0) {
        _showSnackBar("Values must be greater than zero.");
        return;
      }

      final double heightM = heightCm / 100;
      final double result = weightKg / pow(heightM, 2);

      setState(() {
        bmi = result;
        if (result < 18.5) {
          category = "Underweight";
        } else if (result < 25.0) {
          category = "Normal Weight";
        } else if (result < 30.0) {
          category = "Overweight";
        } else {
          category = "Obese";
        }
      });

      _animationController.forward(from: 0);
    } catch (_) {
      _showSnackBar("Please enter valid numeric values.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: _accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color get _categoryColor {
    if (bmi == null) return _accent;
    if (bmi! < 18.5) return const Color(0xFF64B5F6); // blue – underweight
    if (bmi! < 25.0) return _teal; // teal  – normal
    if (bmi! < 30.0) return const Color(0xFFFFB74D); // amber – overweight
    return const Color(0xFFEF5350); // red   – obese
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildGenderToggle(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildInputCard(
                      controller: heightController,
                      label: "Height",
                      unit: "cm",
                      icon: Icons.straighten,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputCard(
                      controller: weightController,
                      label: "Weight",
                      unit: "kg",
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildCalculateButton(),
              const SizedBox(height: 28),
              if (bmi != null) ...[
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildResultCard(),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_accent, _accentLight]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.monitor_heart,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "BMI Calculator",
              style: TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Track your body mass index\nand stay on top of your health.",
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.6),
        ),
      ],
    );
  }

  // ─── Gender Toggle ────────────────────────────────────────────────────────
  Widget _buildGenderToggle() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          _genderOption("Male", Icons.male_rounded),
          _genderOption("Female", Icons.female_rounded),
        ],
      ),
    );
  }

  Widget _genderOption(String label, IconData icon) {
    final bool selected = gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => gender = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [_accent, _accentLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _accent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : _textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected ? Colors.white : _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Input Card ───────────────────────────────────────────────────────────
  Widget _buildInputCard({
    required TextEditingController controller,
    required String label,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: _accentLight),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Color(0xFF444466),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Calculate Button ─────────────────────────────────────────────────────
  Widget _buildCalculateButton() {
    return GestureDetector(
      onTap: calculateBMI,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_accent, _accentLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Calculate BMI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Result Card ──────────────────────────────────────────────────────────
  Widget _buildResultCard() {
    final Color color = _categoryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Your Result",
            style: TextStyle(
              color: _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          // BMI gauge arc
          _buildBMIGauge(color),
          const SizedBox(height: 20),
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Info row
          Row(
            children: [
              _infoTile("Gender", gender, Icons.person_outline_rounded),
              const SizedBox(width: 12),
              _infoTile(
                "Healthy Range",
                "18.5 – 24.9",
                Icons.favorite_border_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAdvice(color),
        ],
      ),
    );
  }

  Widget _buildBMIGauge(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: CircularProgressIndicator(
            value: ((bmi! - 10) / 30).clamp(0.0, 1.0),
            strokeWidth: 10,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bmi!.toStringAsFixed(1),
              style: TextStyle(
                color: color,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              "BMI",
              style: TextStyle(
                color: _textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: _accentLight),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvice(Color color) {
    final Map<String, String> advice = {
      "Underweight":
          "Consider increasing calorie intake with nutrient-rich foods and consult a nutritionist.",
      "Normal Weight":
          "Great work! Maintain your healthy lifestyle with balanced diet and regular exercise.",
      "Overweight":
          "Focus on portion control, daily movement, and whole foods to reach a healthier range.",
      "Obese":
          "Consulting a healthcare provider for a personalised plan is strongly recommended.",
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              advice[category] ?? "",
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
