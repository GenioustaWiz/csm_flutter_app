
"<uses-permission android:name="android.permission.INTERNET"/>" 
Added to: android/app/src/main/AndroidManifest.xml to allow internet access:

"http: ^0.13.4" should b added to pubspec.yaml dependencies
# used to pharse HTML and Extract CSRF Token
html: ^0.15.0
# used to pharse HTML and Extract CSRF Token
html: ^0.15.0
# used to share Auth Cookies
shared_preferences: ^2.0.0
# for Dashboard Chart display
fl_chart: ^0.69.0

if having Gradle conflict errors run this command: flutter config --jdk-dir=<here put the loctaion of your Java JDK folder>

update Gradle or Java version, sync the project by running:
    flutter clean
    flutter pub get

    flutter pub upgrade --major-versions


Use: "ipconfig" to generate IpAddress for using in Django Runserver for accessing the Project on other Devices within the network(Wifi Network).

