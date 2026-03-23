// Stub librustdesk.dll - provides minimal exports so the Flutter app can load.
// Replace with the real Rust-built DLL for full functionality.
// Build (MSVC):  cl /LD /Fe:librustdesk.dll stub_librustdesk.cpp
// Build (clang): clang++ -shared -o librustdesk.dll stub_librustdesk.cpp -target x86_64-pc-windows-msvc

#include <cstdint>
#include <cstring>
#include <windows.h>

// ── Signatures must match exactly what main.cpp expects via GetProcAddress ──
//
// typedef char** (*FUNC_RUSTDESK_CORE_MAIN)(int*);
//   → returns non-null char** to allow Flutter to start; null to abort.
//
// typedef void   (*FUNC_RUSTDESK_FREE_ARGS)(char**, int);
//   → frees the array returned by rustdesk_core_main_args.
//
// typedef int    (*FUNC_RUSTDESK_GET_APP_NAME)(wchar_t*, int);
//   → returns 0 if it wrote the name into the buffer; non-0 to use default.

extern "C" {

// Return a valid (empty) argv so Flutter launches.
static char* g_empty_argv[1] = { nullptr };

__declspec(dllexport) char** rustdesk_core_main_args(int* out_argc) {
    if (out_argc) *out_argc = 0;
    return g_empty_argv;   // non-null → Flutter will start
}

__declspec(dllexport) void free_c_args(char** args, int len) {
    // stub: nothing to free
    (void)args; (void)len;
}

// Return non-0 → caller keeps its default app name ("Rahbar Desk").
__declspec(dllexport) int get_rustdesk_app_name(wchar_t* buf, int size) {
    (void)buf; (void)size;
    return 1;
}

// flutter_rust_bridge store_dart_post_cobject – needed by generated bridge
__declspec(dllexport) void store_dart_post_cobject(void* ptr) {
    (void)ptr;
}

} // extern "C"

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    (void)hModule; (void)ul_reason_for_call; (void)lpReserved;
    return TRUE;
}
