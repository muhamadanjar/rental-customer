class Order {
  int orderId;
  String orderCode;
  int orderUserId;
  String orderAddressOrigin;
  String orderAddressOriginLat;
  String orderAddressOriginLng;
  String orderAddressDestination;
  String orderAddressDestinationLat;
  String orderAddressDestinationLng;
  Null orderDriverId;
  String orderJenis;
  int orderNominal;
  String orderTglPesanan;
  Null orderWaktuJemput;
  Null orderWaktuBerakhir;
  String orderKeterangan;
  int orderStatus;
  String createdBy;
  Null updatedBy;

  Order(
      {this.orderId,
      this.orderCode,
      this.orderUserId,
      this.orderAddressOrigin,
      this.orderAddressOriginLat,
      this.orderAddressOriginLng,
      this.orderAddressDestination,
      this.orderAddressDestinationLat,
      this.orderAddressDestinationLng,
      this.orderDriverId,
      this.orderJenis,
      this.orderNominal,
      this.orderTglPesanan,
      this.orderWaktuJemput,
      this.orderWaktuBerakhir,
      this.orderKeterangan,
      this.orderStatus,
      this.createdBy,
      this.updatedBy});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderCode = json['order_code'];
    orderUserId = json['order_user_id'];
    orderAddressOrigin = json['order_address_origin'];
    orderAddressOriginLat = json['order_address_origin_lat'];
    orderAddressOriginLng = json['order_address_origin_lng'];
    orderAddressDestination = json['order_address_destination'];
    orderAddressDestinationLat = json['order_address_destination_lat'];
    orderAddressDestinationLng = json['order_address_destination_lng'];
    orderDriverId = json['order_driver_id'];
    orderJenis = json['order_jenis'];
    orderNominal = json['order_nominal'];
    orderTglPesanan = json['order_tgl_pesanan'];
    orderWaktuJemput = json['order_waktu_jemput'];
    orderWaktuBerakhir = json['order_waktu_berakhir'];
    orderKeterangan = json['order_keterangan'];
    orderStatus = json['order_status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
  factory Order.initialData() {
    return Order(
      orderAddressOrigin: '',
      orderAddressDestination: '',
      orderAddressOriginLng: null,
      orderAddressOriginLat:null,
      orderAddressDestinationLat: null,
      orderAddressDestinationLng:null,
      orderNominal: 0,
      orderJenis: '1',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_code'] = this.orderCode;
    data['order_user_id'] = this.orderUserId;
    data['order_address_origin'] = this.orderAddressOrigin;
    data['order_address_origin_lat'] = this.orderAddressOriginLat;
    data['order_address_origin_lng'] = this.orderAddressOriginLng;
    data['order_address_destination'] = this.orderAddressDestination;
    data['order_address_destination_lat'] = this.orderAddressDestinationLat;
    data['order_address_destination_lng'] = this.orderAddressDestinationLng;
    data['order_driver_id'] = this.orderDriverId;
    data['order_jenis'] = this.orderJenis;
    data['order_nominal'] = this.orderNominal;
    data['order_tgl_pesanan'] = this.orderTglPesanan;
    data['order_waktu_jemput'] = this.orderWaktuJemput;
    data['order_waktu_berakhir'] = this.orderWaktuBerakhir;
    data['order_keterangan'] = this.orderKeterangan;
    data['order_status'] = this.orderStatus;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}