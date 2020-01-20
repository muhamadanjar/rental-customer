class CarType {
  int id;
  String type;
  String image;
  String description;
  int status;
  int perMin;
  int perMiles;
  int personCapacity;
  int com;
  int minKm;
  int afterMinKm;
  int minRp;
  int afterMinRp;
  String createdAt;
  String updatedAt;
  Null pathUrl;

  CarType(
      {this.id,
      this.type,
      this.image,
      this.description,
      this.status,
      this.perMin,
      this.perMiles,
      this.personCapacity,
      this.com,
      this.minKm,
      this.afterMinKm,
      this.minRp,
      this.afterMinRp,
      this.createdAt,
      this.updatedAt,
      this.pathUrl});

  CarType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    image = json['image'];
    description = json['description'];
    status = json['status'];
    perMin = json['per_min'];
    perMiles = json['per_miles'];
    personCapacity = json['person_capacity'];
    com = json['com'];
    minKm = json['min_km'];
    afterMinKm = json['after_min_km'];
    minRp = json['min_rp'];
    afterMinRp = json['after_min_rp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pathUrl = json['path_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['image'] = this.image;
    data['description'] = this.description;
    data['status'] = this.status;
    data['per_min'] = this.perMin;
    data['per_miles'] = this.perMiles;
    data['person_capacity'] = this.personCapacity;
    data['com'] = this.com;
    data['min_km'] = this.minKm;
    data['after_min_km'] = this.afterMinKm;
    data['min_rp'] = this.minRp;
    data['after_min_rp'] = this.afterMinRp;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['path_url'] = this.pathUrl;
    return data;
  }
}