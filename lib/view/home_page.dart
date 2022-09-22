import 'package:crypto_app/model/coin_post.dart';
import 'package:crypto_app/service/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Coin>? coin;
  var isLoaded = false;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    coin = await  RemoteService().getPost();
    if (coin != null) {
      setState(() {
        isLoaded = true;
        print(coin?.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = 'CoinCegko';
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.search),
          )
        ],
      ),
      drawer: const Drawer(),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator(),),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: (() => getData()),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: const [
                      SizedBox(width: 10),
                      Text('#'),
                      SizedBox(width: 20,),
                      Text('COIN'),
                      SizedBox(width: 30,),
                      Text('PRICE'),
                      SizedBox(width: 50,),
                      Text('24H'),
                      SizedBox(width: 50,),
                      Text('MARKET CAP'),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: coin?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${index+1} '),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(image: CachedNetworkImageProvider(coin![index].imageUrl), height: 20, width: 20,),
                                    Text(coin![index].symbol.toUpperCase())
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Text('\$${coin![index].price}', textAlign: TextAlign.end,),
                                const SizedBox(width: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    coin![index].change > 0 ? const Icon(Icons.arrow_drop_up, color: Colors.green,) : const Icon(Icons.arrow_drop_down, color: Colors.red,),
                                    Text('${coin![index].changePercentage.toStringAsFixed(1)}%', style: TextStyle(color: coin![index].change > 0 ? Colors.green : Colors.red),),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Text('\$${myFormat.format(coin![index].marketCap..toStringAsFixed(0))}'),
                            ],)
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}