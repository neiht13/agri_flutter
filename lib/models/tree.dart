class Tree {
  final String id;
  final String name;
  final String image;
  final double price;
  final String age;
  final String type;
  final String height;
  final String canopyDiameter;
  final String averageYield;
  final String description;

  Tree({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.age,
    required this.type,
    required this.height,
    required this.canopyDiameter,
    required this.averageYield,
    required this.description,
  });
}

List<Tree> trees = [
  Tree(
    id: '1',
    name: 'Xoài Cát Chu - Cây 1',
    image: 'assets/mango.jpg',
    price: 5000000,
    age: '5 năm',
    type: 'Xoài Cát Chu',
    height: '3 mét',
    canopyDiameter: '2 mét',
    averageYield: '100kg/năm',
    description: 'Cây xoài khỏe mạnh, năng suất cao...',
  ),
  Tree(
    id: '2',
    name: 'Xoài Cát Chu - Cây 2',
    image: 'assets/mango.jpg',
    price: 4500000,
    age: '4 năm',
    type: 'Xoài Cát Chu',
    height: '2.8 mét',
    canopyDiameter: '1.8 mét',
    averageYield: '90kg/năm',
    description: 'Cây xoài sinh trưởng tốt, chất lượng trái ngon...',
  ),
  Tree(
    id: '3',
    name: 'Xoài Hòa Lộc - Cây 1',
    image: 'assets/mango.jpg',
    price: 6000000,
    age: '6 năm',
    type: 'Xoài Hòa Lộc',
    height: '3.2 mét',
    canopyDiameter: '2.5 mét',
    averageYield: '110kg/năm',
    description: 'Cây xoài Hòa Lộc đặc sản, trái ngọt và thơm...',
  ),
];

