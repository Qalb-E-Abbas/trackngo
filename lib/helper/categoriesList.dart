class CategoriesList {
  static final categories = getCategories();

  static List<String> getCategories() {
    List<String> cats = [];
    cats.add("Car Parts");
    cats.add('Electronics');
    cats.add('HouseHold Items');
    return cats;
  }

  static List<String> getSuggestions(String query) {
    var auto = List.of(categories).where((category) {
      return category.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return auto;
  }
}
