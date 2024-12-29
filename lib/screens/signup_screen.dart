// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading spinner
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:resume/HELPER/helper_function.dart';
// import 'package:resume/SERVICES/auth_service.dart';
// import 'package:resume/screens/home_screen.dart';
// import 'package:resume/screens/resume_template_page.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController collegeNameController = TextEditingController();
//   final TextEditingController cgpaController = TextEditingController();
//   final TextEditingController githubController = TextEditingController();
//   final TextEditingController linkedinController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   String? specialization;
//   String? course;
//   String? branch;
//   String? gender;
//   DateTime? dob;
//   int? passOutYear;
//   List<String> preferredCountries = [];
//   List<String> preferredStates = [];
//   List<String> preferredCities = [];
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             size: 20,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 40),
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1000),
//                       child: Text(
//                         "Sign up",
//                         style: TextStyle(
//                             fontSize: 30, fontWeight: FontWeight.bold),
//                       )),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: Text(
//                         "Create an account, It's free",
//                         style: TextStyle(fontSize: 15, color: Colors.grey[700]),
//                       )),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1600),
//                       child: makeInput(
//                           label: "Email", controller: emailController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1700),
//                       child: makeInput(
//                           label: "Password",
//                           obscureText: true,
//                           controller: passwordController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "First Name",
//                           controller: firstNameController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "Last Name", controller: lastNameController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "College Name",
//                           controller: collegeNameController)),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1200),
//                     child: makeDropdown(
//                       label: "Specialization",
//                       items: ["Postgraduate", "Undergraduate"],
//                       onChanged: (value) => setState(() {
//                         specialization = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1300),
//                     child: makeDropdown(
//                       label: "Course",
//                       items: ["M.Tech", "B.Tech", "MBA"],
//                       onChanged: (value) => setState(() {
//                         course = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1400),
//                     child: makeDropdown(
//                       label: "Branch/Stream",
//                       items: ["Computer Science", "Mechanical", "Electrical"],
//                       onChanged: (value) => setState(() {
//                         branch = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1500),
//                       child: makeYearPicker(
//                           label: "Pass-out Year",
//                           context: context,
//                           onSelected: (value) => setState(() {
//                                 passOutYear = value;
//                               }))),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1800),
//                       child: makeInput(
//                           label: "CGPA or Percentage",
//                           controller: cgpaController)),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1900),
//                     child: makeDropdown(
//                       label: "Gender",
//                       items: ["Male", "Female", "Other"],
//                       onChanged: (value) => setState(() {
//                         gender = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2000),
//                       child: makeInput(
//                           label: "GitHub Profile",
//                           controller: githubController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2100),
//                       child: makeInput(
//                           label: "LinkedIn Profile",
//                           controller: linkedinController)),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 2200),
//                     child: makeMultiSelect(
//                       label: "Job Preferred Countries",
//                       items: ["India", "USA", "UK"],
//                       maxSelection: 3,
//                       context: context,
//                       onConfirm: (values) => setState(() {
//                         preferredCountries = values.cast<String>();
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 2300),
//                     child: makeMultiSelect(
//                       label: "Job Preferred States",
//                       items: ["California", "Karnataka", "New York"],
//                       maxSelection: 3,
//                       context: context,
//                       onConfirm: (values) => setState(() {
//                         preferredStates = values.cast<String>();
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 2400),
//                     child: makeMultiSelect(
//                       label: "Job Preferred Cities",
//                       items: ["Bangalore", "San Francisco", "London"],
//                       maxSelection: 6,
//                       context: context,
//                       onConfirm: (values) => setState(() {
//                         preferredCities = values.cast<String>();
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2500),
//                       child: makeDatePicker(
//                           label: "Date of Birth",
//                           context: context,
//                           onSelected: (date) => setState(() {
//                                 dob = date;
//                               }))),

//                   // Sign up button with loading indicator
//                   FadeInUp(
//                     duration: Duration(milliseconds: 2600),
//                     child: isLoading
//                         ? Center(
//                             child: SpinKitWave(
//                               color: Colors.greenAccent,
//                               size: 50,
//                             ),
//                           )
//                         : Container(
//                             padding: EdgeInsets.only(top: 3, left: 3),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: MaterialButton(
//                               minWidth: double.infinity,
//                               height: 60,
//                               onPressed: _signUp,
//                               color: Colors.greenAccent,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Text(
//                                 "Sign up",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // The sign-up method, including calling AuthService
//   void _signUp() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Assuming googleSignUp is a method in your AuthService that handles user sign-up
//       await AuthService().googleSignUp(
//           firstNameController.text,
//           lastNameController.text,
//           collegeNameController.text,
//           specialization,
//           course,
//           branch,
//           passOutYear,
//           cgpaController.text,
//           gender,
//           githubController.text,
//           linkedinController.text,
//           preferredCountries,
//           preferredStates,
//           preferredCities,
//           dob,
//           emailController.text,
//           passwordController.text);

//       await HelperFunction.saveUserEmail(emailController.text.toString());
//       await HelperFunction.saveUserLoggedInStatus(true);

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//         (Route<dynamic> route) =>
//             false, // This condition removes all previous routes
//       );

//       // If the sign-up is successful, show a success message or navigate
//     } catch (e) {
//       // Handle any error that occurs during the sign-up process
//       print(e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Sign up failed. Please try again.")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget makeInput({
//     required String label,
//     bool obscureText = false,
//     required TextEditingController controller,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//           ),
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget makeDropdown({
//     required String label,
//     required List<String> items,
//     required Function(String?)? onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         SizedBox(height: 5),
//         DropdownButtonFormField(
//           decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//           ),
//           items: items
//               .map((item) => DropdownMenuItem(
//                     value: item,
//                     child: Text(item),
//                   ))
//               .toList(),
//           onChanged: onChanged,
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget makeMultiSelect({
//     required String label,
//     required List<String> items,
//     required int maxSelection,
//     required BuildContext context,
//     required Function(List) onConfirm,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         SizedBox(height: 5),
//         MultiSelectDialogField(
//           items: items.map((e) => MultiSelectItem(e, e)).toList(),
//           listType: MultiSelectListType.LIST,
//           onConfirm: onConfirm,
//           chipDisplay: MultiSelectChipDisplay(),
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget makeDatePicker({
//     required String label,
//     required BuildContext context,
//     required Function(DateTime?) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         SizedBox(height: 5),
//         ElevatedButton(
//           onPressed: () async {
//             DateTime? selectedDate = await showDatePicker(
//               initialDate: DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(DateTime.now().year + 5),
//               context: context, // Allow 5 years into the future
//             );

//             onSelected(selectedDate);
//           },
//           child: Text("Pick Date"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget makeYearPicker({
//     required String label,
//     required BuildContext context,
//     required Function(int?) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         SizedBox(height: 5),
//         ElevatedButton(
//           onPressed: () async {
//             final selectedYear = await showDialog<int>(
//                 context: context,
//                 builder: (context) {
//                   return SimpleDialog(
//                     title: Text('Select Year'),
//                     children: List.generate(10, (index) {
//                       final year = DateTime.now().year + index;
//                       return SimpleDialogOption(
//                         onPressed: () {
//                           Navigator.pop(context, year);
//                         },
//                         child: Text(year.toString()),
//                       );
//                     }),
//                   );
//                 });

//             if (selectedYear != null) {
//               onSelected(selectedYear);
//             }
//           },
//           child: Text("Pick Year"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }
// }
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading spinner
// import 'package:resume/HELPER/helper_function.dart';
// import 'package:resume/MODELS/cities_model.dart';
// import 'package:resume/MODELS/country_state_model.dart' as cs_model;
// import 'package:resume/SERVICES/auth_service.dart';
// import 'package:resume/screens/home_screen.dart';
// import '../repositories/country_state_city_repo.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController collegeNameController = TextEditingController();
//   final TextEditingController cgpaController = TextEditingController();
//   final TextEditingController githubController = TextEditingController();
//   final TextEditingController linkedinController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   String? specialization;
//   String? course;
//   String? branch;
//   String? gender;
//   DateTime? dob;
//   int? passOutYear;

//   List<String> preferredCountries = [];
//   List<String> preferredStates = [];
//   List<String> preferredCities = [];

//   final CountryStateCityRepo _countryStateCityRepo = CountryStateCityRepo();
//   List<String> countries = [];
//   List<String> states = [];
//   List<String> cities = [];
//   cs_model.CountryStateModel countryStateModel =
//       cs_model.CountryStateModel(error: false, msg: '', data: []);
//   CitiesModel citiesModel = CitiesModel(error: false, msg: '', data: []);

//   String selectedCountry = 'Select Country';
//   String selectedState = 'Select State';
//   String selectedCity = 'Select City';
//   bool isDataLoaded = false;

//   bool isLoading = false;

//   void _signUp() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Assuming googleSignUp is a method in your AuthService that handles user sign-up
//       await AuthService().googleSignUp(
//           firstNameController.text,
//           lastNameController.text,
//           collegeNameController.text,
//           specialization,
//           course,
//           branch,
//           passOutYear,
//           cgpaController.text,
//           gender,
//           githubController.text,
//           linkedinController.text,
//           preferredCountries,
//           preferredStates,
//           preferredCities,
//           dob,
//           emailController.text,
//           passwordController.text);

//       await HelperFunction.saveUserEmail(emailController.text.toString());
//       await HelperFunction.saveUserLoggedInStatus(true);

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//         (Route<dynamic> route) =>
//             false, // This condition removes all previous routes
//       );

//       // If the sign-up is successful, show a success message or navigate
//     } catch (e) {
//       // Handle any error that occurs during the sign-up process
//       print(e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Sign up failed. Please try again.")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCountries();
//   }

//   getCountries() async {
//     countryStateModel = (await _countryStateCityRepo.getCountriesStates())
//         as cs_model.CountryStateModel;
//     countries.add('Select Country');
//     states.add('Select State');
//     cities.add('Select City');
//     for (var element in countryStateModel.data) {
//       countries.add(element.name);
//     }
//     setState(() {
//       isDataLoaded = true;
//     });
//   }

//   getStates() async {
//     for (var element in countryStateModel.data) {
//       if (selectedCountry == element.name) {
//         resetStates();
//         resetCities();
//         for (var state in element.states) {
//           states.add(state.name);
//         }
//         break;
//       }
//     }
//     setState(() {});
//   }

//   getCities() async {
//     isDataLoaded = false;
//     citiesModel = (await _countryStateCityRepo.getCities(
//         country: selectedCountry, state: selectedState)) as CitiesModel;
//     resetCities();
//     for (var city in citiesModel.data) {
//       cities.add(city);
//     }
//     setState(() {
//       isDataLoaded = true;
//     });
//   }

//   resetCities() {
//     cities = ['Select City'];
//     selectedCity = 'Select City';
//   }

//   resetStates() {
//     states = ['Select State'];
//     selectedState = 'Select State';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             size: 20,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 40),
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1000),
//                       child: Text(
//                         "Sign up",
//                         style: TextStyle(
//                             fontSize: 30, fontWeight: FontWeight.bold),
//                       )),
//                   SizedBox(height: 20),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: Text(
//                         "Create an account, It's free",
//                         style: TextStyle(fontSize: 15, color: Colors.grey[700]),
//                       )),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1600),
//                       child: makeInput(
//                           label: "Email", controller: emailController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1700),
//                       child: makeInput(
//                           label: "Password",
//                           obscureText: true,
//                           controller: passwordController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "First Name",
//                           controller: firstNameController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "Last Name", controller: lastNameController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1200),
//                       child: makeInput(
//                           label: "College Name",
//                           controller: collegeNameController)),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1200),
//                     child: makeDropdown(
//                       label: "Specialization",
//                       items: ["Postgraduate", "Undergraduate"],
//                       onChanged: (value) => setState(() {
//                         specialization = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1300),
//                     child: makeDropdown(
//                       label: "Course",
//                       items: ["M.Tech", "B.Tech", "MBA"],
//                       onChanged: (value) => setState(() {
//                         course = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1400),
//                     child: makeDropdown(
//                       label: "Branch/Stream",
//                       items: ["Computer Science", "Mechanical", "Electrical"],
//                       onChanged: (value) => setState(() {
//                         branch = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1500),
//                       child: makeYearPicker(
//                           label: "Pass-out Year",
//                           context: context,
//                           onSelected: (value) => setState(() {
//                                 passOutYear = value;
//                               }))),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 1800),
//                       child: makeInput(
//                           label: "CGPA or Percentage",
//                           controller: cgpaController)),
//                   FadeInUp(
//                     duration: Duration(milliseconds: 1900),
//                     child: makeDropdown(
//                       label: "Gender",
//                       items: ["Male", "Female", "Other"],
//                       onChanged: (value) => setState(() {
//                         gender = value;
//                       }),
//                     ),
//                   ),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2000),
//                       child: makeInput(
//                           label: "GitHub Profile",
//                           controller: githubController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2100),
//                       child: makeInput(
//                           label: "LinkedIn Profile",
//                           controller: linkedinController)),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2200),
//                       child: makeDropdown(
//                         label: "Country",
//                         items: countries,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCountry = value!;
//                             if (selectedCountry != 'Select Country') {
//                               getStates();
//                             }
//                           });
//                         },
//                       )),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2300),
//                       child: makeDropdown(
//                         label: "State",
//                         items: states,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedState = value!;
//                             if (selectedState != 'Select State') {
//                               getCities();
//                             }
//                           });
//                         },
//                       )),
//                   FadeInUp(
//                       duration: Duration(milliseconds: 2400),
//                       child: makeDropdown(
//                         label: "City",
//                         items: cities,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCity = value!;
//                           });
//                         },
//                       )),
//                 ],
//               ),
//               SizedBox(height: 30),
//               isLoading
//                   ? SpinKitFadingCircle(color: Colors.blue)
//                   : FadeInUp(
//                       duration: Duration(milliseconds: 2500),
//                       child: MaterialButton(
//                         minWidth: double.infinity,
//                         height: 50,
//                         onPressed: () async {
//                           _signUp();
//                         },
//                         color: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           "Sign up",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget makeInput(
//       {required String label,
//       required TextEditingController controller,
//       bool obscureText = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//           ),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget makeDropdown({
//     required String label,
//     required List<String> items,
//     required void Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 5),
//         DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400)),
//           ),
//           value: items.first,
//           items: items
//               .map((item) => DropdownMenuItem(
//                     value: item,
//                     child: Text(item),
//                   ))
//               .toList(),
//           onChanged: onChanged,
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget makeYearPicker({
//     required String label,
//     required BuildContext context,
//     required void Function(int) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 5),
//         GestureDetector(
//           onTap: () async {
//             final currentYear = DateTime.now().year;
//             int? selectedYear = await showDialog<int>(
//               context: context,
//               builder: (context) => SimpleDialog(
//                 title: Text("Select Year"),
//                 children: List.generate(30, (index) {
//                   final year = currentYear - index;
//                   return SimpleDialogOption(
//                     onPressed: () => Navigator.pop(context, year),
//                     child: Text(year.toString()),
//                   );
//                 }),
//               ),
//             );
//             if (selectedYear != null) {
//               onSelected(selectedYear);
//             }
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade400),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Text(
//               passOutYear?.toString() ?? 'Select Year',
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart';
import 'package:resume/HELPER/helper_function.dart';
import 'package:resume/MODELS/cities_model.dart';
import 'package:resume/MODELS/country_state_model.dart' as cs_model;
import 'package:resume/SERVICES/auth_service.dart';
import 'package:resume/screens/home_screen.dart';
import '../repositories/country_state_city_repo.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Existing controllers...
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController cgpaController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  // Existing variables...
  String? specialization;
  String? course;
  String? branch;
  String? gender;
  DateTime? dob;
  int? passOutYear;

  // Modified location preferences
  List<String> selectedCountries = [];
  List<String> selectedStates = [];
  List<String> selectedCities = [];

  // Data source lists
  final CountryStateCityRepo _countryStateCityRepo = CountryStateCityRepo();
  List<String> countries = [];
  Map<String, List<String>> statesByCountry = {};
  Map<String, List<String>> citiesByState = {};

  bool isDataLoaded = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    setState(() => isDataLoaded = false);

    try {
      var countryStateModel = await _countryStateCityRepo.getCountriesStates();
      countries = countryStateModel.data.map((e) => e.name).toList();

      setState(() => isDataLoaded = true);
    } catch (e) {
      print('Error fetching countries: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load countries. Please try again.')),
      );
    }
  }

  Future<void> getStatesForCountry(String country) async {
    if (statesByCountry.containsKey(country)) return;

    try {
      var countryStateModel = await _countryStateCityRepo.getCountriesStates();
      var countryData =
          countryStateModel.data.firstWhere((e) => e.name == country);
      statesByCountry[country] = countryData.states.map((e) => e.name).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching states: $e');
    }
  }

  Future<void> getCitiesForState(String country, String state) async {
    final key = '$country-$state';
    if (citiesByState.containsKey(key)) return;

    try {
      var citiesModel = await _countryStateCityRepo.getCities(
        country: country,
        state: state,
      );
      citiesByState[key] = citiesModel.data;
      setState(() {});
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  Widget buildMultiSelectCountries(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    return Container(
      width: maxWidth,
      child: MultiSelectDialogField<String>(
        items: countries.map((e) => MultiSelectItem<String>(e, e)).toList(),
        title: Text("Select Countries (Max 3)"),
        selectedColor: Colors.blue,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        buttonText: Text("Preferred Countries"),
        onConfirm: (values) {
          if (values.length <= 3) {
            setState(() {
              selectedCountries = values;
              // Clear dependent selections
              selectedStates = [];
              selectedCities = [];
            });
            // Fetch states for selected countries
            for (var country in values) {
              getStatesForCountry(country);
            }
          }
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedCountries.remove(value);
            });
          },
        ),
        validator: (values) {
          if (values == null || values.length > 3)
            return "Maximum 3 countries allowed";
          return null;
        },
      ),
    );
  }

  Widget buildMultiSelectStates(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    // Get all available states for selected countries
    List<String> availableStates = [];
    for (var country in selectedCountries) {
      if (statesByCountry.containsKey(country)) {
        availableStates.addAll(statesByCountry[country]!);
      }
    }

    return Container(
      width: maxWidth,
      child: MultiSelectDialogField<String>(
        items:
            availableStates.map((e) => MultiSelectItem<String>(e, e)).toList(),
        title: Text("Select States (Max 3)"),
        selectedColor: Colors.blue,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        buttonText: Text("Preferred States"),
        onConfirm: (values) {
          if (values.length <= 3) {
            setState(() {
              selectedStates = values;
              selectedCities = [];
            });
            // Fetch cities for selected states
            for (var country in selectedCountries) {
              for (var state in values) {
                getCitiesForState(country, state);
              }
            }
          }
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedStates.remove(value);
            });
          },
        ),
        validator: (values) {
          if (values == null || values.length > 3)
            return "Maximum 3 states allowed";
          return null;
        },
      ),
    );
  }

  Widget buildMultiSelectCities(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    // Get all available cities for selected states
    List<String> availableCities = [];
    for (var country in selectedCountries) {
      for (var state in selectedStates) {
        final key = '$country-$state';
        if (citiesByState.containsKey(key)) {
          availableCities.addAll(citiesByState[key]!);
        }
      }
    }

    return Container(
      width: maxWidth,
      child: MultiSelectDialogField<String>(
        items:
            availableCities.map((e) => MultiSelectItem<String>(e, e)).toList(),
        title: Text("Select Cities (Max 6)"),
        selectedColor: Colors.blue,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        buttonText: Text("Preferred Cities"),
        onConfirm: (values) {
          if (values.length <= 6) {
            setState(() {
              selectedCities = values;
            });
          }
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedCities.remove(value);
            });
          },
        ),
        validator: (values) {
          if (values == null || values.length > 6)
            return "Maximum 6 cities allowed";
          return null;
        },
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    return Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date of Birth",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: dob ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != dob) {
                setState(() {
                  dob = picked;
                  dobController.text = DateFormat('dd-MM-yyyy').format(picked);
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: dobController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth > 600 ? (screenWidth - 600) / 2 : 20.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              // Header section
              Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: Text(
                      "Create an account, It's free",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Basic Information
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                child: makeInput(
                  label: "Email",
                  controller: emailController,
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1400),
                child: makeInput(
                  label: "Password",
                  controller: passwordController,
                  obscureText: true,
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: makeInput(
                  label: "First Name",
                  controller: firstNameController,
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1600),
                child: makeInput(
                  label: "Last Name",
                  controller: lastNameController,
                ),
              ),

              // Educational Information
              FadeInUp(
                duration: Duration(milliseconds: 1700),
                child: makeInput(
                  label: "College Name",
                  controller: collegeNameController,
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1800),
                child: makeDropdown(
                  label: "Specialization",
                  items: [
                    "Select Specialization",
                    "Postgraduate",
                    "Undergraduate"
                  ],
                  onChanged: (value) {
                    if (value != "Select Specialization") {
                      setState(() => specialization = value);
                    }
                  },
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1900),
                child: makeDropdown(
                  label: "Course",
                  items: ["Select Course", "M.Tech", "B.Tech", "MBA"],
                  onChanged: (value) {
                    if (value != "Select Course") {
                      setState(() => course = value);
                    }
                  },
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 2000),
                child: makeDropdown(
                  label: "Branch/Stream",
                  items: [
                    "Select Branch",
                    "Computer Science",
                    "Mechanical",
                    "Electrical"
                  ],
                  onChanged: (value) {
                    if (value != "Select Branch") {
                      setState(() => branch = value);
                    }
                  },
                ),
              ),

              // Year and Performance
              FadeInUp(
                duration: Duration(milliseconds: 2100),
                child: makeYearPicker(
                  label: "Pass-out Year",
                  context: context,
                  onSelected: (value) => setState(() => passOutYear = value),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 2200),
                child: makeInput(
                  label: "CGPA or Percentage",
                  controller: cgpaController,
                ),
              ),

              // Personal Information
              FadeInUp(
                duration: Duration(milliseconds: 2300),
                child: makeDropdown(
                  label: "Gender",
                  items: ["Select Gender", "Male", "Female", "Other"],
                  onChanged: (value) {
                    if (value != "Select Gender") {
                      setState(() => gender = value);
                    }
                  },
                ),
              ),

              // Professional Profiles
              FadeInUp(
                duration: Duration(milliseconds: 2400),
                child: makeInput(
                  label: "GitHub Profile",
                  controller: githubController,
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 2500),
                child: makeInput(
                  label: "LinkedIn Profile",
                  controller: linkedinController,
                ),
              ),

              // Location Preferences
              SizedBox(height: 20),
              FadeInUp(
                duration: Duration(milliseconds: 2600),
                child: buildMultiSelectCountries(context),
              ),
              SizedBox(height: 20),
              if (selectedCountries.isNotEmpty)
                FadeInUp(
                  duration: Duration(milliseconds: 2700),
                  child: buildMultiSelectStates(context),
                ),
              SizedBox(height: 20),
              if (selectedStates.isNotEmpty)
                FadeInUp(
                  duration: Duration(milliseconds: 2800),
                  child: buildMultiSelectCities(context),
                ),
              SizedBox(height: 20),

              // Date of Birth
              FadeInUp(
                duration: Duration(milliseconds: 2900),
                child: buildDatePicker(context),
              ),

              // Submit Button
              SizedBox(height: 30),
              isLoading
                  ? SpinKitFadingCircle(color: Colors.blue)
                  : FadeInUp(
                      duration: Duration(milliseconds: 3000),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: _validateAndSignUp,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {required String label,
      required TextEditingController controller,
      bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget makeDropdown({
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
          value: items.first,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget makeYearPicker({
    required String label,
    required BuildContext context,
    required void Function(int) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final currentYear = DateTime.now().year;
            int? selectedYear = await showDialog<int>(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text("Select Year"),
                children: List.generate(30, (index) {
                  final year = currentYear - index;
                  return SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, year),
                    child: Text(year.toString()),
                  );
                }),
              ),
            );
            if (selectedYear != null) {
              onSelected(selectedYear);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              passOutYear?.toString() ?? 'Select Year',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  void _validateAndSignUp() {
    // Basic validation
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        collegeNameController.text.isEmpty ||
        specialization == null ||
        course == null ||
        branch == null ||
        passOutYear == null ||
        cgpaController.text.isEmpty ||
        gender == null ||
        dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    // Validate age (must be at least 18 years old)
    final age = DateTime.now().difference(dob!).inDays ~/ 365;
    if (age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("You must be at least 18 years old to register")),
      );
      return;
    }

    // Validate location selections
    if (selectedCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one preferred country")),
      );
      return;
    }

    // If all validation passes, proceed with signup
    _signUp();
  }

  Future<void> _signUp() async {
    setState(() => isLoading = true);

    try {
      await AuthService().googleSignUp(
        firstNameController.text,
        lastNameController.text,
        collegeNameController.text,
        specialization,
        course,
        branch,
        passOutYear,
        cgpaController.text,
        gender,
        githubController.text,
        linkedinController.text,
        selectedCountries,
        selectedStates,
        selectedCities,
        dob,
        emailController.text,
        passwordController.text,
      );

      await HelperFunction.saveUserEmail(emailController.text);
      await HelperFunction.saveUserLoggedInStatus(true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Signup error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed. Please try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    firstNameController.dispose();
    lastNameController.dispose();
    collegeNameController.dispose();
    cgpaController.dispose();
    githubController.dispose();
    linkedinController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dobController.dispose();
    super.dispose();
  }

  // Your existing helper methods and sign up logic...
}
