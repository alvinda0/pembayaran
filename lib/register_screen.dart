import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
 @override
 _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
 final TextEditingController _nameController = TextEditingController();
 final TextEditingController _phoneController = TextEditingController();
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final TextEditingController _confirmPasswordController = TextEditingController();
 bool _obscurePassword = true;
 bool _obscureConfirmPassword = true;

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Color(0xFFF5F7FA),
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: Colors.blue),
         onPressed: () => Navigator.of(context).pop(),
       ),
     ),
     body: SafeArea(
       child: Center(
         child: SingleChildScrollView(
           padding: EdgeInsets.symmetric(horizontal: 32.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text(
                 'Create an Account',
                 style: TextStyle(
                   fontSize: 24,
                   fontWeight: FontWeight.bold,
                   color: Colors.blue.shade700,
                 ),
               ),
               SizedBox(height: 20),
               TextField(
                 controller: _nameController,
                 decoration: InputDecoration(
                   hintText: 'Full Name',
                   prefixIcon: Icon(Icons.person, color: Colors.blue),
                   filled: true,
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide.none,
                   ),
                 ),
               ),
               SizedBox(height: 16),
               TextField(
                 controller: _phoneController,
                 decoration: InputDecoration(
                   hintText: 'Phone Number',
                   prefixIcon: Icon(Icons.phone, color: Colors.blue),
                   filled: true,
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide.none,
                   ),
                 ),
                 keyboardType: TextInputType.phone,
               ),
               SizedBox(height: 16),
               TextField(
                 controller: _emailController,
                 decoration: InputDecoration(
                   hintText: 'Email',
                   prefixIcon: Icon(Icons.email, color: Colors.blue),
                   filled: true,
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide.none,
                   ),
                 ),
                 keyboardType: TextInputType.emailAddress,
               ),
               SizedBox(height: 16),
               TextField(
                 controller: _passwordController,
                 obscureText: _obscurePassword,
                 decoration: InputDecoration(
                   hintText: 'Password',
                   prefixIcon: Icon(Icons.lock, color: Colors.blue),
                   suffixIcon: IconButton(
                     icon: Icon(
                       _obscurePassword 
                           ? Icons.visibility_off 
                           : Icons.visibility,
                       color: Colors.blue,
                     ),
                     onPressed: () {
                       setState(() {
                         _obscurePassword = !_obscurePassword;
                       });
                     },
                   ),
                   filled: true,
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide.none,
                   ),
                 ),
               ),
               SizedBox(height: 16),
               TextField(
                 controller: _confirmPasswordController,
                 obscureText: _obscureConfirmPassword,
                 decoration: InputDecoration(
                   hintText: 'Confirm Password',
                   prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                   suffixIcon: IconButton(
                     icon: Icon(
                       _obscureConfirmPassword 
                           ? Icons.visibility_off 
                           : Icons.visibility,
                       color: Colors.blue,
                     ),
                     onPressed: () {
                       setState(() {
                         _obscureConfirmPassword = !_obscureConfirmPassword;
                       });
                     },
                   ),
                   filled: true,
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide.none,
                   ),
                 ),
               ),
               SizedBox(height: 24),
               Container(
                 width: double.infinity,
                 height: 56,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                       Colors.blue.shade500,
                       Colors.blue.shade700,
                     ],
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                   ),
                   borderRadius: BorderRadius.circular(30),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.blue.shade200,
                       blurRadius: 10,
                       offset: Offset(0, 5),
                     ),
                   ],
                 ),
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.transparent,
                     shadowColor: Colors.transparent,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30),
                     ),
                   ),
                   onPressed: _performRegister,
                   child: Text(
                     'Register',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                       letterSpacing: 1.1,
                     ),
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

 void _performRegister() {
   String name = _nameController.text.trim();
   String phone = _phoneController.text.trim();
   String email = _emailController.text.trim();
   String password = _passwordController.text;
   String confirmPassword = _confirmPasswordController.text;

   if (password != confirmPassword) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Passwords do not match')),
     );
     return;
   }

   // Add your registration logic here
   print('Name: $name, Phone: $phone, Email: $email, Password: $password');
 }

 @override
 void dispose() {
   _nameController.dispose();
   _phoneController.dispose();
   _emailController.dispose();
   _passwordController.dispose();
   _confirmPasswordController.dispose();
   super.dispose();
 }
}