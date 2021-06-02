class ProjectModel {
  String iDProject;
  String projectName;
  String responsibleName;
  String place;
  String date;
  String lat;
  String lng;
  String iDUse;

  ProjectModel(
      {this.iDProject,
      this.projectName,
      this.responsibleName,
      this.place,
      this.date,
      this.lat,
      this.lng,
      this.iDUse});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    iDProject = json['ID_Project'];
    projectName = json['Project_Name'];
    responsibleName = json['Responsible_Name'];
    place = json['Place'];
    date = json['Date'];
    lat = json['Lat'];
    lng = json['Lng'];
    iDUse = json['ID_Use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_Project'] = this.iDProject;
    data['Project_Name'] = this.projectName;
    data['Responsible_Name'] = this.responsibleName;
    data['Place'] = this.place;
    data['Date'] = this.date;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['ID_Use'] = this.iDUse;
    return data;
  }
}
