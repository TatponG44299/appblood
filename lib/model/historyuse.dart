class HistoryModel {
  String iDHistory;
  String iD;
  String firstName;
  String lastName;
  String bloodType;
  String iDProject;
  String projectName;
  String responsibleName;

  HistoryModel(
      {this.iDHistory,
      this.iD,
      this.firstName,
      this.lastName,
      this.bloodType,
      this.iDProject,
      this.projectName,
      this.responsibleName});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    iDHistory = json['ID_History'];
    iD = json['ID'];
    firstName = json['First_name'];
    lastName = json['Last_name'];
    bloodType = json['Blood_type'];
    iDProject = json['ID_Project'];
    projectName = json['Project_Name'];
    responsibleName = json['Responsible_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_History'] = this.iDHistory;
    data['ID'] = this.iD;
    data['First_name'] = this.firstName;
    data['Last_name'] = this.lastName;
    data['Blood_type'] = this.bloodType;
    data['ID_Project'] = this.iDProject;
    data['Project_Name'] = this.projectName;
    data['Responsible_Name'] = this.responsibleName;
    return data;
  }
}
