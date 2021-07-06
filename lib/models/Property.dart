class Property {
  final int id;
  final String title;
  final Location location;
  final Price price;
  final String address;
  final String summary;
  final List<PropertyImage> images;

  Property(this.id, this.title, this.location, this.price, this.address,
      this.summary, this.images);

  Property.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['propertyTypeFullDescription'],
        location = Location.fromJson(json['location']),
        price = Price.fromJson(json['price']),
        address = json['displayAddress'],
        summary = json['summary'],
        images = json['propertyImages']['images']
            .map((json) => PropertyImage.fromJson(json))
            .toList()
            .cast<PropertyImage>();
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'];
}

class Price {
  final int amount;
  final String qualifier;
  final String currency;

  Price(this.amount, this.qualifier, this.currency);

  Price.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        qualifier = json['displayPrices'][0]['displayPriceQualifier'],
        currency = json['currencyCode'];
}

class PropertyImage {
  final String url;

  PropertyImage(this.url);

  PropertyImage.fromJson(Map<String, dynamic> json) : url = json['srcUrl'];
}
