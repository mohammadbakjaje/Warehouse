import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  // البيانات القابلة للتعديل
  String gender = 'أنثى';
  String facebookAccount = 'facebook.com/bessie.cooper';
  String address = '123 الشارع الرئيسي، نيويورك';
  DateTime birthDate = DateTime(1990, 5, 15);

  // قائمة الخيارات للنوع
  final List<String> genderOptions = ['ذكر', 'أنثى'];

  // عناصر التحكم للنماذج
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تهيئة عناصر التحكم بالقيم الحالية
    _facebookController.text = facebookAccount;
    _addressController.text = address;
  }

  @override
  void dispose() {
    // تنظيف عناصر التحكم
    _facebookController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // دالة لاختيار تاريخ الميلاد
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // اللون الأساسي للتقويم
              onPrimary: Colors.white, // لون النص على العناصر المختارة
              // لون خلفية التقويم
              onSurface: Colors.black, // لون النص في التقويم
            ),
            dialogBackgroundColor: Colors.white, // لون خلفية النافذة
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColors.orangeBasic, // لون نص الأزرار
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  void _toggleEditMode() {
    if (isEditing) {
      // حفظ التعديلات
      setState(() {
        facebookAccount = _facebookController.text;
        address = _addressController.text;
        isEditing = false;
      });

      // هنا يمكن إضافة كود لحفظ البيانات في قاعدة البيانات أو الخادم
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التعديلات بنجاح')));
    } else {
      // الدخول في وضع التعديل
      setState(() {
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'تعديل الملف الشخصي' : 'الملف الشخصي',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
          elevation: 0,
          actions: isEditing
              ? [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                  )
                ]
              : null,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // رأس الملف الشخصي
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/women/68.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'بيسي كوبر',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'مصمم ويب',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // معلومات الاتصال
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.email,
                      title: 'البريد الإلكتروني',
                      value: 'jessico.hanson@example.com',
                      editable: false,
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildInfoRow(
                      icon: Icons.phone,
                      title: 'رقم الهاتف',
                      value: '+917353476294',
                      editable: false,
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildInfoRow(
                      icon: Icons.facebook,
                      title: 'حساب الفيسبوك',
                      value: facebookAccount,
                      editable: isEditing,
                      controller: _facebookController,
                    ),
                    const Divider(height: 1, indent: 60),
                    // صف النوع مع القائمة المنسدلة
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'النوع',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                isEditing
                                    ? DropdownButtonFormField<String>(
                                        value: gender,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            gender = newValue!;
                                          });
                                        },
                                        items: genderOptions
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        dropdownColor: Colors.white,
                                      )
                                    : Text(
                                        gender,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      title: 'العنوان',
                      value: address,
                      editable: isEditing,
                      controller: _addressController,
                    ),
                    const Divider(height: 1, indent: 60),
                    // صف تاريخ الميلاد مع منتقي التاريخ
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cake, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'تاريخ الميلاد',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                isEditing
                                    ? InkWell(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Text(
                                            '${birthDate.day}/${birthDate.month}/${birthDate.year}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '${birthDate.day}/${birthDate.month}/${birthDate.year}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // زر تعديل الملف الشخصي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleEditMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.orangeBasic,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // إضافة ظل للزر
                      shadowColor: MyColors.orangeBasic.withOpacity(0.5),
                      elevation: 5,
                    ),
                    child: Text(
                      isEditing ? 'حفظ التغييرات' : 'تعديل الملف الشخصي',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    bool editable = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                editable
                    ? TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: value,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
