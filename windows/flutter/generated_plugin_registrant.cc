//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_desktop_scanner/flutter_desktop_scanner_plugin_c_api.h>
#include <printing/printing_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterDesktopScannerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterDesktopScannerPluginCApi"));
  PrintingPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PrintingPlugin"));
}
