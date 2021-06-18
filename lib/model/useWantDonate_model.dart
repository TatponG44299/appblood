class UserWantDonate {
  String iDUseDonate;
  String nameUser;
  String contact;
  String bloodType;
  String lat;
  String lng;
  String iDUse;
  String quickDonate;
  String projectDonate;

  UserWantDonate(
      {this.iDUseDonate,
      this.nameUser,
      this.contact,
      this.bloodType,
      this.lat,
      this.lng,
      this.iDUse,
      this.quickDonate,
      this.projectDonate});

  UserWantDonate.fromJson(Map<String, dynamic> json) {
    iDUseDonate = json['ID_UseDonate'];
    nameUser = json['Name_User'];
    contact = json['Contact'];
    bloodType = json['Blood_Type'];
    lat = json['Lat'];
    lng = json['Lng'];
    iDUse = json['ID_Use'];
    quickDonate = json['Quick_Donate'];
    projectDonate = json['Project_Donate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_UseDonate'] = this.iDUseDonate;
    data['Name_User'] = this.nameUser;
    data['Contact'] = this.contact;
    data['Blood_Type'] = this.bloodType;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['ID_Use'] = this.iDUse;
    data['Quick_Donate'] = this.quickDonate;
    data['Project_Donate'] = this.projectDonate;
    return data;
  }
}
