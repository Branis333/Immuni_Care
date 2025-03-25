class Dose {
  final int position;
  final int week;
  final bool isNormal;
  bool setReminder;

  Dose(this.position, this.week, this.isNormal, this.setReminder);
  
  Map<String, dynamic> toJson() => {
    'position': position,
    'week': week,
    'isNormal': isNormal,
    'setReminder': setReminder,
  };
  
  factory Dose.fromJson(Map<String, dynamic> json) {
    return Dose(
      json['position'] as int,
      json['week'] as int,
      json['isNormal'] as bool,
      json['setReminder'] as bool,
    );
  }
}

class Vaccine {
  final String name;
  final String code;
  final String description;
  // List of doses where each dose is described by the number of weeks after which it should be given
  // and boolean variable which denotes special prescription is required or not
  // True - normal, False = Only for specific children
  final List<Dose> doses;
  final int price;

  Vaccine(this.name, this.code, this.description, this.doses, this.price);
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'description': description,
    'doses': doses.map((dose) => dose.toJson()).toList(),
    'price': price,
  };
  
  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      json['name'] as String,
      json['code'] as String,
      json['description'] as String,
      (json['doses'] as List)
          .map((x) => Dose.fromJson(x as Map<String, dynamic>))
          .toList(),
      json['price'] as int,
    );
  }
}