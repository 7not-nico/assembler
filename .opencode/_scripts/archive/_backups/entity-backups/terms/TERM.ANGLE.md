**ANGLE** (**Almost Native Graphics Layer Engine**) — an open-source, cross-platform graphics abstraction layer developed by **Google** that translates **OpenGL ES** API calls to native platform-specific APIs. Originally created to standardize WebGL rendering in Chromium on Windows — where it translates ES 2.0/3.0 calls to **Direct3D 9/11** — ANGLE now supports **Vulkan**, **desktop OpenGL**, **Metal**, and native **OpenGL ES** as backend renderers, covering Windows, Linux, macOS, iOS, Android, Chrome OS, and Fuchsia. Its shader compiler is used as the canonical GLSL ES validator across **Chrome**, **Firefox**, and other browsers, ensuring consistent shader acceptance across platforms. Chromium uses ANGLE for all GPU-accelerated content on Windows, including WebGL, Canvas2D, and **Native Client**. The project is hosted under the Chromium umbrella at `chromium.googlesource.com/angle/angle`.


---
reference:
---
