import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MyModel.dart';

class ListDataku extends StatefulWidget {
  const ListDataku({Key key}) : super(key: key);

  @override
  _ListDatakuState createState() => _ListDatakuState();
}

class _ListDatakuState extends State<ListDataku> {

  MyModel model;

  Future<MyModel> fetchEbooks() async {
    var apiResult = await http.post("http://api.themoviedb.org/3/movie/now_playing?language=en&api_key=6ac7a042ac3b7599a689eb943fa0b6d0");
    if (apiResult.statusCode == 200) {
      var parsedRes = json.decode(apiResult.body);
      print(parsedRes.toString());
      // print("body " + body + "--" + apiResult.body.toString());
      return MyModel.fromJson(parsedRes);

    } else {
      print(apiResult.body.toString());
      return null;
      // throw Exception('Failed to load ');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchEbooks().then((value){
      model = value;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body : Container(
        child: FutureBuilder(
          future: fetchEbooks(),
          builder: (context,snapshots){
            if(snapshots.connectionState==ConnectionState.done){
              return ListView.builder(
                itemCount: model.results.length,
                //itemBuilder: _buildItemsForListView,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => DetailPage(index:  model.data.data[index].id,)),
                        // );
                      },
                      child : Container(
                        //CARD
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //LIST TILE
                              ListTile(
                                leading:
                                // CachedNetworkImage(
                                //   placeholder: (context, url) => CircularProgressIndicator(),
                                //   imageUrl:
                                //   // "http://image.tmdb.org/t/p/w342/"+model.results[index].posterPath,
                                //   "http://image.tmdb.org/t/p/w342/jTswp6KyDYKtvC52GbHagrZbGvD.jpg",
                                // )
                                Image.network(
                                  "http://image.tmdb.org/t/p/w342/"+model.results[index].posterPath,
                                  fit: BoxFit.contain,
                                )
                                ,
                                title: Text(
                                  model.results[index].title,
                                  style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // Text(
                                        //   'Language : ',
                                        //   style: TextStyle(fontWeight: FontWeight.bold),
                                        // ),
                                        Text(
                                          model.results[index].releaseDate.toString(),
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10.0),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Likes : ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(model.results[index].popularity.toString()),
                                        Icon(
                                          Icons.star,
                                          size: 20.0,
                                          color: Colors.yellow,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //BUTTON
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: const Text('Detail'),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      )

                  );
                },


              );
            }else{
              // return CircularProgressIndicator();
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )


      ,
    );
  }
}
