library generate;

import 'package:args/args.dart';
import 'package:gen_table/gen_table.dart';
import 'package:gen_table/src/print_tool.dart';

main(List<String> args) async{

  if(_isHelpCommand(args)){
    _printHelperDisplay();
  }
  else{
    ConfigOption configOption = _generateConfigOption(args);
    if(configOption.platform == null){
      printError('Argument "platform" is missing');
      return;
    }

    if(null == configOption.input){
      printError('Argument "input" is missing');
      return;
    }

    if(null == configOption.target){
      printError('Argument "target" is missing');
      return;
    }

    PlatformGenerator? platformGenerator = platformGeneratorFactory(configOption.platform!);
    if (platformGenerator == null){
      printError('platform [${configOption.platform}] is not supported');
    } else{
      String? errorMessage = platformGenerator.validArguments(configOption);
      if (errorMessage == null){
        printError(errorMessage);
      } else{
        platformGenerator.build(configOption);
      }
    }
  }
}

bool _isHelpCommand(List<String> args){
  return args.length == 1 && (args[0] == '--help' || args[0] == '-h');
}

void _printHelperDisplay(){
  ConfigOption? config = ConfigOption();
  var parser = _generateArgParser(config);
  print(parser.usage);
}

ConfigOption _generateConfigOption(List<String> args){
  ConfigOption option = ConfigOption();
  var parser = _generateArgParser(option);
  parser.parse(args);
  return option;
}


ArgParser _generateArgParser(ConfigOption config){
  var parser = new ArgParser();

  parser.addOption('platform',
      callback: (String? x) => config.platform = x,
      help: "[Required] The platform stores all localization strings. Suppoted platforms: 'airTable'");

  parser.addOption('input',
      callback: (String? x) => config.input = x,
      help: '[Required] The source of the strings');

  parser.addOption('target',
      callback: (String? x) => config.target = x,
      help: '[Required] Code generator for a target plaformat. Supported target: Flutter');

  parser.addOption('api-key',
      callback: (String? x) => config.apiKey = x,
      help: '[Optional] Usage of platform specific');

  parser.addOption('output-dir',
      defaultsTo: 'res/string',
      callback: (String? x) => config.outputDir = x,
      help: '[Optional] An output folder stores all generated json files');

  return parser;
}




