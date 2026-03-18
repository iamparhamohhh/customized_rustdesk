// Stub librustdesk.dll - provides minimal exports so the Flutter app can load.
// Replace with the real Rust-built DLL for full functionality.
// Build: cl /LD /Fe:librustdesk.dll stub_librustdesk.cpp

#include <cstdint>
#include <cstring>

extern "C" {

// The only symbol looked up directly via DynamicLibrary.lookupFunction
// Signature: Pointer<Uint8> Function(Pointer<Utf8> sessionId, Int32 display)
__declspec(dllexport) uint8_t* session_get_rgba(const char* session_id, int32_t display) {
    return nullptr;
}

// Windows entry point - called from C runner
__declspec(dllexport) int rustdesk_core_main_args(int argc, const char** argv) {
    return 0;
}

__declspec(dllexport) void free_c_args(const char** args, int len) {
}

__declspec(dllexport) const char* get_rustdesk_app_name() {
    return "RustDesk";
}

} // extern "C"

// DLL entry point
#include <windows.h>
BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    return TRUE;
}
