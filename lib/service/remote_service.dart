import 'package:crypto_app/model/coin_post.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Coin>?> getPost() async{
    List<Coin>? coin;
    var client = http.Client();

    var uri = Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      coin = postFromJson(json);
    }
    return coin;
  }
}