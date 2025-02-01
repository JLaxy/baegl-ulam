import 'dart:convert';

class Car {
  late String make;
  late int model;
  late Map<String, dynamic> specs;

  Car(this.make, this.model, this.specs);

  /// Converts Json to Car Object
  Car.fromJson(Map<String, dynamic> json) {
    make = json["make"];
    model = json["model"];
    specs = json["specs"];
  }

  /// Returns Object as Map to be converted as Json String
  Map toJson() => {"make": make, "model": model, "specs": specs};

  showSpecs() {
    print(make);
    print(model);
    print(specs);
  }
}

void main() {
  Car myCar = Car(
      "Lexus", 2023, {"engine": "RB122", "horsepower": 626, "wheel size": 20});
  String text = jsonEncode(myCar);
  print(text);

  var carRead = jsonDecode(text) as Map<String, dynamic>;
  var newCar = Car.fromJson(carRead);

  newCar.showSpecs();
}
