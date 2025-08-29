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
  String gender = 'Female';
  String facebookAccount = 'facebook.com/bessie.cooper';
  String address = '123 Main St, New York, NY 10001';
  String birthDate = 'May 15, 1990';

  // عناصر التحكم للنماذج
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تهيئة عناصر التحكم بالقيم الحالية
    _genderController.text = gender;
    _facebookController.text = facebookAccount;
    _addressController.text = address;
    _birthDateController.text = birthDate;
  }

  @override
  void dispose() {
    // تنظيف عناصر التحكم
    _genderController.dispose();
    _facebookController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (isEditing) {
      // حفظ التعديلات
      setState(() {
        gender = _genderController.text;
        facebookAccount = _facebookController.text;
        address = _addressController.text;
        birthDate = _birthDateController.text;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Profile' : 'Profile',
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
            // Profile Header
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/68.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bessie Cooper',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Web Designer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Contact Information
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
                    title: 'Email',
                    value: 'jessico.hanson@example.com',
                    editable: false,
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildInfoRow(
                    icon: Icons.phone,
                    title: 'Phone number',
                    value: '+917353476294',
                    editable: false,
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildInfoRow(
                    icon: Icons.facebook,
                    title: 'Facebook Account',
                    value: facebookAccount,
                    editable: isEditing,
                    controller: _facebookController,
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildInfoRow(
                    icon: Icons.person,
                    title: 'Gender',
                    value: gender,
                    editable: isEditing,
                    controller: _genderController,
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    title: 'Address',
                    value: address,
                    editable: isEditing,
                    controller: _addressController,
                  ),
                  const Divider(height: 1, indent: 60),
                  _buildInfoRow(
                    icon: Icons.cake,
                    title: 'Birth Date',
                    value: birthDate,
                    editable: isEditing,
                    controller: _birthDateController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _toggleEditMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isEditing ? Colors.green : MyColors.orangeBasic,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Edit profile',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
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
