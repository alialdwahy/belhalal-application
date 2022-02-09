import 'package:get/get.dart';
import 'package:halal/controllers/getx_network_manage.dart';

class NetworkBinding extends Bindings{

  // dependence injection attach our class.
  @override
  void dependencies() {
    Get.lazyPut<GetXNetworkManager>(() => GetXNetworkManager());
  }

}