class Province{
  String province;

  Province({
    required this.province
  });

  factory Province.fromJSON(Map<String, dynamic> json){
     return Province(
      province: json['provincia']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provincia': province
    };
  }

  @override
  String toString() {
    return 'Province{provincia: $province}';
  }
}
