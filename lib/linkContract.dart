import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class LinkContractController extends GetxController {
  final String _rpcUrl = "HTTP://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";
  final String _privateKey =
      "4132bc36633d2a6f860feb345132fe849d7530adbb1c2601c4db757be2cd28e5";

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late DeployedContract _contract;
  late ContractFunction _uploadImage;
  // ContractFunction _setName;

  late String deployedName;
}
