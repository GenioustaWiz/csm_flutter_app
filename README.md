**Centralized School Management System (CSM) Flutter App**

**Overview**
The CSM Flutter App serves as the mobile frontend for the Centralized School Management System, providing a seamless experience for parents to log in, view their child's performance, and receive real-time notifications about attendance, academic updates, and important school events.

**Key Features**
Parent Login: Secure login for parents to access personalized dashboards.
Child Performance Dashboard: View academic performance, attendance, and extracurricular activities in real-time.
Notifications: Receive instant notifications on important updates (attendance, performance, and school announcements).

**Backend Integration**
This app connects to a Django backend via API, which manages user authentication, student data, and notification services. For more details on the backend, check out the [CSM Django Backend](https://github.com/GenioustaWiz/centralized_school_management).

**Installation**
Clone the repository.
Install dependencies: **flutter pub get**.
Run the app: **flutter run**.

**API Endpoints**
The app communicates with the backend using the following API endpoints:

Login: /api/login/

Student list for the logged in parent: /api/student-list/?page=$currentPage&page_size=$pageSize

Student Dashboard: /api/student-dashboard/$studentId/

**Requirements**

Flutter SDK

API Access to the Django backend
