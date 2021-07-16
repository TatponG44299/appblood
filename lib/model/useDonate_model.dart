class UseDonate {
  String iDRequest;
  String announceName;
  String receiverName;
  String bloodType;
  String hospitalName;
  String detail;
  String contact;
  String endTime;
  String lat;
  String lng;
  String iDUse;
  String status;

  UseDonate(
      {this.iDRequest,
      this.announceName,
      this.receiverName,
      this.bloodType,
      this.hospitalName,
      this.detail,
      this.contact,
      this.endTime,
      this.lat,
      this.lng,
      this.iDUse,
      this.status});

  UseDonate.fromJson(Map<String, dynamic> json) {
    iDRequest = json['ID_request'];
    announceName = json['AnnounceName'];
    receiverName = json['ReceiverName'];
    bloodType = json['BloodType'];
    hospitalName = json['HospitalName'];
    detail = json['Detail'];
    contact = json['Contact'];
    endTime = json['EndTime'];
    lat = json['Lat'];
    lng = json['Lng'];
    iDUse = json['ID_Use'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_request'] = this.iDRequest;
    data['AnnounceName'] = this.announceName;
    data['ReceiverName'] = this.receiverName;
    data['BloodType'] = this.bloodType;
    data['HospitalName'] = this.hospitalName;
    data['Detail'] = this.detail;
    data['Contact'] = this.contact;
    data['EndTime'] = this.endTime;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['ID_Use'] = this.iDUse;
    data['status'] = this.status;
    return data;
  }
}
