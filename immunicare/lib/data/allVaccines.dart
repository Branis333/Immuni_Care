import './vaccine.dart';

class AllVaccines {
  static List<Vaccine> allVaccines = [
    Vaccine(
        'Bacillus Calmette–Guérin',
        'BCG',
        'This vaccine protects from so and so disease',
        [Dose(1, 1, true, true)],
        100),
    Vaccine(
        'Hepatitis B',
        'Hep-B',
        'This vaccine protects from so and so disease',
        [
          Dose(1, 1, true, true),
          Dose(2, 4, true, true),
          Dose(3, 8, true, true),
          Dose(4, 12, false, false)
        ],
        1000),
    Vaccine(
        'Pneumococcal conjugate vaccine',
        'PCV',
        'This vaccine protects from so and so disease',
        [Dose(1, 1, true, true)],
        1495)
  ];
}
