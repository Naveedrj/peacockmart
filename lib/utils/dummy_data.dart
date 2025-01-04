class DummyData {
  late final List<Company> companies;
  late final List<Distributor> distributors;
  late final List<Trader> traders;
  late final List<Shop> shops;

  DummyData() {
    companies = [
      Company(
        name: 'Tech Corp',
        location: 'New York, USA',
        image: 'assets/images/company1.png',
        description: 'A leading tech company specializing in AI solutions.',
      ),
      Company(
        name: 'Eco Innovators',
        location: 'San Francisco, USA',
        image: 'assets/images/company2.png',
        description: 'Developing eco-friendly technologies for a sustainable future.',
      ),
      Company(
        name: 'Global Industries',
        location: 'London, UK',
        image: 'assets/images/company3.png',
        description: 'A multinational conglomerate with diverse sectors.',
      ),
      Company(
        name: 'NextGen Solutions',
        location: 'Berlin, Germany',
        image: 'assets/images/company4.png',
        description: 'Innovative solutions in software development and cloud computing.',
      ),
      Company(
        name: 'Tech Hive',
        location: 'Sydney, Australia',
        image: 'assets/images/company5.png',
        description: 'A startup incubator for technology startups.',
      ),
      Company(
        name: 'Blue Wave',
        location: 'Toronto, Canada',
        image: 'assets/images/company6.png',
        description: 'Focused on sustainable energy and green initiatives.',
      ),
    ];

    distributors = [
      Distributor(
        name: 'Quick Distributors',
        location: 'Miami, USA',
        image: 'assets/images/distributor1.png',
      ),
      Distributor(
        name: 'Fast Tracks',
        location: 'London, UK',
        image: 'assets/images/distributor2.png',
      ),
      Distributor(
        name: 'Global Distribute',
        location: 'Paris, France',
        image: 'assets/images/distributor3.png',
      ),
      Distributor(
        name: 'Speedy Distributors',
        location: 'Berlin, Germany',
        image: 'assets/images/distributor4.png',
      ),
      Distributor(
        name: 'Direct Distributors',
        location: 'Tokyo, Japan',
        image: 'assets/images/distributor5.png',
      ),
      Distributor(
        name: 'Prime Distributors',
        location: 'Sydney, Australia',
        image: 'assets/images/distributor6.png',
      ),
    ];

    traders = [
      Trader(
        name: 'Trader A',
        location: 'New York, USA',
        image: 'assets/images/trader1.png',
      ),
      Trader(
        name: 'Trader B',
        location: 'Los Angeles, USA',
        image: 'assets/images/trader2.png',
      ),
      Trader(
        name: 'Trader C',
        location: 'London, UK',
        image: 'assets/images/trader3.png',
      ),
      Trader(
        name: 'Trader D',
        location: 'Berlin, Germany',
        image: 'assets/images/trader4.png',
      ),
      Trader(
        name: 'Trader E',
        location: 'Sydney, Australia',
        image: 'assets/images/trader5.png',
      ),
      Trader(
        name: 'Trader F',
        location: 'Toronto, Canada',
        image: 'assets/images/trader6.png',
      ),
    ];

    shops = [
      Shop(
        name: 'Shop One',
        location: 'Miami, USA',
        image: 'assets/images/shop1.png',
      ),
      Shop(
        name: 'Shop Two',
        location: 'Paris, France',
        image: 'assets/images/shop2.png',
      ),
      Shop(
        name: 'Shop Three',
        location: 'London, UK',
        image: 'assets/images/shop3.png',
      ),
      Shop(
        name: 'Shop Four',
        location: 'Tokyo, Japan',
        image: 'assets/images/shop4.png',
      ),
      Shop(
        name: 'Shop Five',
        location: 'Berlin, Germany',
        image: 'assets/images/shop5.png',
      ),
      Shop(
        name: 'Shop Six',
        location: 'Sydney, Australia',
        image: 'assets/images/shop6.png',
      ),
    ];
  }
}

class Company {
  final String name;
  final String location;
  final String image;
  final String description;

  Company({
    required this.name,
    required this.location,
    required this.image,
    required this.description,
  });
}

class Distributor {
  final String name;
  final String location;
  final String image;

  Distributor({
    required this.name,
    required this.location,
    required this.image,
  });
}

class Trader {
  final String name;
  final String location;
  final String image;

  Trader({
    required this.name,
    required this.location,
    required this.image,
  });
}

class Shop {
  final String name;
  final String location;
  final String image;

  Shop({
    required this.name,
    required this.location,
    required this.image,
  });
}
