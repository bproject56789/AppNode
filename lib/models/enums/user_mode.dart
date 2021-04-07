enum UserMode {
  User,
  Advocate,
}

enum Gender { Male, Female, Other }

extension Label on Gender {
  String get label => this.toString().split('.')[1];
}
