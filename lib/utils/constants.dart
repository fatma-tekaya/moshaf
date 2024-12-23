// final Map<String, int> sourates  = {
//   "الفاتحة": 13,
//   "البقرة": 12,
//   "آل عمران": 9,
//   "النساء": 2,
//   "المائدة": 1,
//   // Ajoutez ici les sourates restantes avec leur numéro de page.
// };
// final Map<int, int> ahzab = {
//   1: 13,
//   2: 9,
//   3: 3, // حزب 3 commence à la page 20
//   4: 1
//   // Ajoutez ici les autres Ahzab...
// };

// final Map<String, List<int>> sourates = {
//   'الفاتحة':[1, 1], // La plage des pages pour chaque sourate
//   'البقرة': [8, 2],
//   'آل عمران':[11, 9] ,
//   'النساء':  [13, 12],

//   // Ajouter les autres sourates...
// };

// final Map<int, List<int>> ahzab = {
//   1: [8, 1], // La plage des pages pour chaque hizb
//   2: [11, 9],
//   3: [13, 12] ,
//   // Ajouter les autres ahzab...
// };

// final Map<String, List<int>> sourates = {
//   'الفاتحة':[13, 13], // La plage des pages pour chaque sourate
//   'البقرة': [9, 12],
//   'آل عمران':[5, 8] ,
//   'النساء':  [1, 4],

//   // Ajouter les autres sourates...
// };

// final Map<int, List<int>> ahzab = {
//   1: [9, 13], // La plage des pages pour chaque hizb
//   2: [5, 8],
//   3: [1, 4] ,
//   // Ajouter les autres ahzab...
// };
final Map<String, List<int>> sourates = {
  'الفاتحة': [1, 1], // Sourate Al-Fatiha : page 1 uniquement
  'البقرة': [2, 8], // Sourate Al-Baqara : pages 2 à 49
  'آل عمران': [9, 13], // Sourate Al-Imran : pages 50 à 76
  // ...
};

final Map<int, List<int>> ahzab = {
  1: [1, 8],  // Hizb 1 : pages 1 à 10
  2: [9, 13], // Hizb 2 : pages 11 à 20
  // ...
};