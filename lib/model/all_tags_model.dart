class AllTagsModel {
  List<String>? tags;

  AllTagsModel({this.tags});

  AllTagsModel.fromJson(List<dynamic> json) {
    tags = json.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tags'] = this.tags;
    return data;
  }
}