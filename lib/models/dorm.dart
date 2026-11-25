class Dorm {
  final String name;
  final String address;
  final int price; // pesos per month
  final String roomType;
  final String? image; // asset path, optional

  const Dorm({
    required this.name,
    required this.address,
    required this.price,
    required this.roomType,
    this.image,
  });
}

const sampleDorms = <Dorm>[
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 3500,
    roomType: 'Single',
    image: 'assets/images/dorm1.jpg',
  ),
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 2800,
    roomType: 'Shared',
    image: 'assets/images/dorm2.jpg',
  ),
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 4500,
    roomType: 'Bedspace',
    image: 'assets/images/dorm3.jpg',
  ),
];
