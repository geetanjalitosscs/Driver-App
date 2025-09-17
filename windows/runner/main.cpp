#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

// Application configuration constants
namespace {
  constexpr int kWindowWidth = 500;
  constexpr int kWindowHeight = 715;
  constexpr int kScreenMargin = 10;
  constexpr int kMinScreenMargin = 20;
  constexpr wchar_t kAppTitle[] = L"driver_app";
}

/**
 * @brief Calculates optimal window dimensions and position
 * @param screenWidth Screen width in pixels
 * @param screenHeight Screen height in pixels
 * @return Pair of (window_size, window_position)
 */
std::pair<Win32Window::Size, Win32Window::Point> CalculateWindowLayout(
    int screenWidth, int screenHeight) {
  
  // Initialize window dimensions
  int windowWidth = kWindowWidth;
  int windowHeight = kWindowHeight;
  
  // Ensure window fits within screen bounds
  if (windowWidth > screenWidth) {
    windowWidth = screenWidth - kMinScreenMargin;
  }
  if (windowHeight > screenHeight) {
    windowHeight = screenHeight - kMinScreenMargin;
  }
  
  // Position window on the left side, starting from top
  int x = kScreenMargin;
  int y = kScreenMargin;
  
  // Ensure window doesn't go off screen vertically
  if (y + windowHeight > screenHeight) {
    windowHeight = screenHeight - kMinScreenMargin;
  }
  
  return {
    Win32Window::Size(windowWidth, windowHeight),
    Win32Window::Point(x, y)
  };
}

/**
 * @brief Brings the window to front and makes it visible
 * @param window Reference to the Flutter window
 */
void ShowAndFocusWindow(FlutterWindow& window) {
  window.Show();
  
  HWND hwnd = window.GetHandle();
  if (hwnd) {
    SetForegroundWindow(hwnd);
    ShowWindow(hwnd, SW_SHOW);
    BringWindowToTop(hwnd);
  }
}

/**
 * @brief Main entry point for the Windows application
 * @param instance Application instance handle
 * @param prev Previous instance handle (unused)
 * @param command_line Command line arguments
 * @param show_command Show command (unused)
 * @return Exit code
 */
int APIENTRY wWinMain(_In_ HINSTANCE instance, 
                      _In_opt_ HINSTANCE prev,
                      _In_ wchar_t* command_line, 
                      _In_ int show_command) {
  
  // Initialize console for debugging
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM for library and plugin usage
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // Create Flutter project
  flutter::DartProject project(L"data");
  
  // Set up command line arguments
  std::vector<std::string> command_line_arguments = GetCommandLineArguments();
  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  // Create and configure window
  FlutterWindow window(project);
  
  // Get screen dimensions and calculate optimal window layout
  int screenWidth = GetSystemMetrics(SM_CXSCREEN);
  int screenHeight = GetSystemMetrics(SM_CYSCREEN);
  
  auto [windowSize, windowPosition] = CalculateWindowLayout(screenWidth, screenHeight);
  
  // Create the window
  if (!window.Create(kAppTitle, windowPosition, windowSize)) {
    return EXIT_FAILURE;
  }
  
  window.SetQuitOnClose(true);
  
  // Show and focus the window
  ShowAndFocusWindow(window);

  // Main message loop
  MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  // Cleanup
  ::CoUninitialize();
  return EXIT_SUCCESS;
}
