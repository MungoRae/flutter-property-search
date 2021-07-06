import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:property_search/AddProperty.dart';
import 'package:http/http.dart' as http;
import 'package:property_search/models/Property.dart';

class PropertiesList extends StatefulWidget {
  const PropertiesList({Key? key}) : super(key: key);

  @override
  _PropertiesListState createState() => _PropertiesListState();
}

class _PropertiesListState extends State<PropertiesList> {
  final List<Property> _properties = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    downloadProperties().then((value) {
      setState(() {
        _properties.clear();
        _properties.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    _properties.clear();
    super.dispose();
  }

  Future<List<Property>> downloadProperties() async {
    var url = Uri.parse(
        'https://www.rightmove.co.uk/api/_search?locationIdentifier=REGION%5E1231&minBedrooms=2&maxPrice=250000&numberOfPropertiesPerPage=24&radius=0.0&sortType=2&index=24&propertyTypes=detached%2Csemi-detached%2Cterraced&primaryDisplayPropertyType=houses&includeSSTC=true&viewType=LIST&channel=BUY&areaSizeUnit=sqft&currencyCode=GBP&isFetching=false');
    var response = await http.get(url);
    var json = jsonDecode(response.body);

    List<Property> properties = json['properties']
        .map((p) => Property.fromJson(p))
        .toList()
        .cast<Property>();

    print(properties[0].toString());

    return properties;
  }

  @override
  Widget build(BuildContext context) {
    int columns;
    double width = MediaQuery.of(context).size.width;
    if (width > 900) {
      columns = 4;
    } else if (width > 450) {
      columns = 2;
    } else {
      columns = 1;
    }
    return Scaffold(
        appBar: AppBar(title: Text("Properties List")),
        body: Container(
            child: _gridView(columns),
            color: Theme.of(context).backgroundColor),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Property",
          child: Icon(Icons.add),
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddProperty();
            }))
          },
        ));
  }

  GridView _gridView(int columns) => GridView.builder(
      itemCount: _properties.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
      itemBuilder: (BuildContext context, int position) {
        return _gridTile(context, _properties[position]);
      });

  Card _gridTile(BuildContext context, Property property) => Card(
        color: Theme.of(context).canvasColor,
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Image.network(
                property.images[0].url,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                flex: 5,
                child: Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          property.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ))),
          ],
        ),
      );

  ListTile _tile(Property property) => ListTile(
        title: Text(property.title),
        subtitle: Text(
          property.summary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
