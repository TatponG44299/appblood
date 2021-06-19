class ClusteringModel {
  List<Data> data;

  ClusteringModel({this.data});

  ClusteringModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  double lat;
  double lng;

  Data({this.lat, this.lng});

  Data.fromJson(Map<String, dynamic> json) {
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

// class ClusteringModel {
//   final String lat;
//   final String lng;
//   final List<String> locall;

//   ClusteringModel({this.lat, this.lng, this.locall});

//   factory ClusteringModel.fromJson(Map<String, dynamic> json) {
//     return ClusteringModel(
//         lat: json['lat'],
//         lng: json['lng'],
//         locall: locallLocation(json['locall']) //json['locall']
//         );
//   }

//   static List<String> locallLocation(locallJson) {
//     List<String> locallList = List<String>.from(locallJson);
//     return locallList;
//   }
// }
