class AccountModel {
  String iD;
  String email;
  String password;
  String firstName;
  String lastName;
  String phon;
  String bloodType;
  String birthday;
  String addDetail;
  String tombol;
  String district;
  String county;
  String urlPicture;
  String idCustom;

  AccountModel(
      {this.iD,
      this.email,
      this.password,
      this.idCustom,
      this.firstName,
      this.lastName,
      this.phon,
      this.bloodType,
      this.birthday,
      this.addDetail,
      this.tombol,
      this.district,
      this.county,
      this.urlPicture});

  AccountModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    email = json['Email'];
    password = json['Password'];
    idCustom = json['ID_costom'];
    firstName = json['First_name'];
    lastName = json['Last_name'];
    phon = json['Phon'];
    bloodType = json['Blood_type'];
    birthday = json['Birthday'];
    addDetail = json['Add_detail'];
    tombol = json['Tombol'];
    district = json['District'];
    county = json['County'];
    urlPicture = json['UrlPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['ID_costom'] = this.idCustom;
    data['First_name'] = this.firstName;
    data['Last_name'] = this.lastName;
    data['Phon'] = this.phon;
    data['Blood_type'] = this.bloodType;
    data['Birthday'] = this.birthday;
    data['Add_detail'] = this.addDetail;
    data['Tombol'] = this.tombol;
    data['District'] = this.district;
    data['County'] = this.county;
    data['UrlPicture'] = this.urlPicture;
    return data;
  }
}
