# 🎓 Luar Sekolah LMS – Mobile Application  
**Flutter • Firebase • GetX • Modular Clean Architecture**

Luar Sekolah LMS is a mobile-based Learning Management System developed as the Final Project of a Project-Based Internship (PBI) in Mobile Software Engineering.  
The application allows students to browse courses, enroll, study materials, track progress, manage tasks, and give course reviews.  
Administrators can manage courses, materials, and moderate user comments.

This project is built using **Flutter**, **Firebase**, and **GetX**, following a **simple Clean Architecture modular structure**.

---

## 👨‍💻 Developer

**Samuel Jaden Gill Sahempa, S.Kom**  
Mobile Developer — Final Project (Project-Based Internship, 2025)

---

## 🌟 Key Features

### 🔐 1. Authentication Module
- Login & Register using Firebase Authentication  
- Form validation with custom rules  
- Automatic route redirection based on **User Role (Admin / Student)**  
- Local user session persistence  

---

### 📚 2. Course Module (Public)
- Display all published courses  
- Filter by categories: **SPL**, **Prakerja**, and **Top Courses**  
- View course details  
- **Enroll & Unenroll functionality**  
- View learning materials organized by chapters (lessons)  
- Average rating displayed on course cards  

---

### ⭐ 3. Rating & Comment System (Student)
- Students can submit:
  - ⭐ Course rating (1–5)
  - 💬 Written comments
- Users may review only after enrolling  
- Real-time update using Firestore streams  

---

### 🛡️ 4. Rating & Comment Monitoring (Admin)
- Admin can view all user ratings  
- Admin can read full comments  
- Admin can delete inappropriate or irrelevant comments  
- Helps maintain content quality and platform integrity  

---

### 🎒 5. MyCourse Module (Progress Tracking)
- Shows all enrolled courses  
- Displays user learning progress  
- Users can mark lessons as **Completed**  
- Progress bar updates automatically based on finished chapters  

---

### 📝 6. Todo Module (Learning Productivity)
- Add, edit, or delete learning tasks  
- Mark tasks as completed  
- Stored locally using SharedPreferences  
- Helps students organize personal study plans  

---

### 🛠️ 7. Admin Module
- Create, edit, publish, or delete courses  
- Upload/replace course thumbnails  
- Manage course information: description, price, categories  
- Add, edit, or delete chapters/lessons  
- Review user ratings & comments  

---

## 🧱 Project Architecture

The project uses a **feature-based modular structure** with a simplified Clean Architecture pattern (Data → Domain → Presentation).

![alt text](https://github.com/JadenSahempa/Project_Flutter/blob/main/lib/assets/images/Folder%20Structure.png?raw=true)


**Notes:**  
- No `core/` folder is used  
- No unit testing included  

---

## 🧰 Tech Stack

| Category            | Technology |
|---------------------|------------|
| Framework           | Flutter (Dart) |
| State Management    | GetX |
| Authentication      | Firebase Auth |
| Database            | Cloud Firestore |
| Local Storage       | SharedPreferences |
| Architecture        | Modular Clean Architecture |
| Firebase Setup      | FlutterFire CLI |

---

## 📱 Application Screens

| Login | Register | User Dashboard |
|------|----------|----------------|
| ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/AppLogin.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/AppRegister.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/DashboardUser.png?raw=true) |

| Admin Dashboard | Course | My Course |
|----------------|--------|-----------|
| ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/DashboardAdmin.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/ClassModule.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/MyClassModule.png?raw=true) |

| Todo | Admin Course | Account |
|------|--------------|---------|
| ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/TodoListModule.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/ClassCourseAdmin.png?raw=true) | ![](https://github.com/JadenSahempa/Project_Flutter/blob/feat/final-course-module-revision-and-refactoring/lib/assets/images/AccountModule.png?raw=true) |

---

## 🚀 Installation Guide

### 1️⃣ Clone Repository
```bash
git clone https://github.com/username/luar-sekolah-lms.git
cd luar_sekolah_lms
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Configure Firebase (Required)

To run this project with your own Firebase project, follow these steps:

1. Create a new project in Firebase Console
2. Add an Android app (and iOS app if needed)
3. Enable the following products:

    - Authentication → Email/Password
    - Cloud Firestore (in Production mode or with rules you prefer)

4. From the root of this Flutter project, run:
```bash
flutterfire configure
```

This command will:

- Link this Flutter app to your Firebase project
- Generate the lib/firebase_options.dart file
- Apply Android/iOS Firebase configuration automatically

### 4️⃣ Run Application
```bash
flutter run
```
Ensure that your emulator or physical device is connected before running.

📸 Screenshots


📲 Application Flow
Student Flow
- Register or Login
- Browse available courses
- Enroll into a course
- Access all enrolled courses in My Courses
- Study chapters and mark progress
- Submit ratings & comments


Admin Flow
- Login as an Admin
- Create or edit courses
- Manage chapters/lessons
- Publish courses for students
- Review and moderate user comments & ratings

🌱 Future Improvements

- Google Sign-In authentication
- Course payment system using credits/coins
- Dashboard metrics for Admin
- Push notifications via Firebase Cloud Messaging
- Improved analytics for user learning progress
