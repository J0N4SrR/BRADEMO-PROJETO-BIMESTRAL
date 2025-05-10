import '../models/item.dart';

class FakeDataService {
  static List<MeuItem> getItems() {
    return [
      MeuItem(
        id: '1',
        title: 'Painting Forest',
        description: 'Olha a Amazonia. Floresta tropical verde. Camadas de vegetação densa revelam uma floresta tropical vibrante e misteriosa. Folhagens exuberantes emolduram montanhas cobertas de vida selvagem.)',
        imageUrl: 'assets/images/painting_forest.png',
      ),
      MeuItem(
        id: '2',
        title: 'Mountaineers',
        description: 'Montanhas verdes e pôr do sol. O sol se põe atrás de montanhas distantes, criando uma silhueta suave de pinheiros. A cena transmite paz e contemplação natural.',
        imageUrl: 'assets/images/mountaineers.png',
      ),
      MeuItem(
        id: '3',
        title: 'Lovely Deserts',
        description: 'Parece o deseto do Atakama. Com cerca de 1 000 km de extensão, é considerado o deserto mais alto do mundo. ',
        imageUrl: 'assets/images/lovely_deserts.png',
      ),
      MeuItem(
        id: '4',
        title: 'The Hill Sides',
        description: 'Tons rosados, pássaros voando. Fim de tarde com vibe de música instrumental e ar de mistério no horizonte.',
        imageUrl: 'assets/images/the_hill_sides.png',
      ),
    ];
  }
}
