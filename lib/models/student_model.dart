class Student{
  // Defining the properties of the Student class
  final int id;
  final String firstName;
  final String? middleName; // Marked as nullable to handle it when empty
  final String lastName;
  final String schoolIdentification;
  final String studentNumber;

  // Constructor for the Student class
  Student({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.schoolIdentification,
    required this.studentNumber,
  });

  // Factory constructor for creating a Student instance from a JSON map
  // It extracts each property from the JSON map and assigns it to the corresponding property of the Student class.
  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      schoolIdentification: json['school_identification'],
      studentNumber: json['student_number'],
    );
  }
}