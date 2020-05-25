class ProductModel {

  // Field
  String showName, showDetail, urlPicture;

  // Method
  ProductModel(this.showName, this.showDetail, this.urlPicture);


  ProductModel.fromMap(Map<String, dynamic> map){
    showName = map['NameShop'];
    showDetail = map['Detail'];
    urlPicture = map['Photo'];
  }

  
}