class EntregaDetail {
  String? entregaImage;

  EntregaDetail ({
    required this.entregaImage,
  });

  factory EntregaDetail.fromJSON(Map<String, dynamic> json){
     return EntregaDetail (
      entregaImage: json['entregaImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entregaImage': entregaImage,
    };
  }

  @override
  String toString() {
    return 'OrderDetail{entregaImage: $entregaImage}';
  }
}
