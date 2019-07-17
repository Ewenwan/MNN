![MNN](doc/banner.png)

AI科学家贾扬清如此评价道：“与 Tensorflow、Caffe2 等同时覆盖训练和推理的通用框架相比，MNN 更注重在推理时的加速和优化，解决在模型部署的阶段的效率问题，从而在移动端更高效地实现模型背后的业务。这和服务器端 TensorRT 等推理引擎的想法不谋而合。在大规模机器学习应用中，考虑到大规模的模型部署，机器学习的推理侧计算量往往是训练侧计算量的十倍以上，所以推理侧的优化尤其重要。”

MNN 是一个轻量级的深度学习端侧推理引擎，核心解决深度神经网络模型在端侧推理运行问题，涵盖深度神经网络模型的优化、转换和推理。目前，MNN已经在手淘、手猫、优酷、聚划算、UC、飞猪、千牛等 20 多个 App 中使用，覆盖直播、短视频、搜索推荐、商品图像搜索、互动营销、权益发放、安全风控等场景，每天稳定运行上亿次。此外，菜鸟自提柜等 IoT 设备中也有应用。在 2018 年双十一购物节中，MNN 在天猫晚会笑脸红包、扫一扫、明星猜拳大战等场景中使用。

[中文版本](README_CN.md)

[MNN使用教程](https://github.com/alibaba/MNN/blob/master/doc/Tutorial_CN.md)

[Benchmark 测试方法](https://github.com/alibaba/MNN/blob/master/doc/Benchmark_CN.md)

[MNN操作手册API](https://github.com/alibaba/MNN/blob/master/doc/OpList.md)

# MNN具备了以下的四大特点：

轻量性：针对端侧设备特点深度定制和裁剪，无任何依赖，可以方便地部署到移动设备和各种嵌入式设备中。

通用性：支持Tensorflow、Caffe、ONNX等主流模型文件格式，支持CNN、RNN、GAN等常用网络。

高性能：不依赖任何第三方计算库，依靠大量手写汇编实现核心运算，充分发挥ARM CPU的算力。比如，在iOS设备上，可以开启GPU加速（Metal），常用模型上快于苹果原生的CoreML。

易用性：有高效的图像处理模块，覆盖常见的形变、转换等需求，一般情况下，无需额外引入libyuv或opencv库处理图像。

MNN不仅支持回调机制，可以在网络运行中插入回调，提取数据或者控制运行走向；还支持只运行网络中的一部分，或者指定CPU和GPU间并行运行。
阿里巴巴提供了使用说明文档和基于图片、视频流的示例应用等等。




## Intro
MNN is a lightweight deep neural network inference engine. It loads models and do inference on devices. At present, MNN has been integrated in more than 20 apps of Alibaba-inc, such as Taobao, Tmall, Youku and etc., covering live broadcast, short video capture, search recommendation, product searching by image, interactive marketing, equity distribution, security risk control and other scenarios. In addition, MNN is also used on embedded devices, such as IoT.

## Features
### Lightweight
- Optimized for devices, no dependencies, can be easily deployed to mobile devices and a variety of embedded devices.
- iOS platform: static library size for armv7+arm64 platforms is about 5MB, size increase of linked executables is about 620KB, and metallib file is about 600KB.
- Android platform: core so size is about 400KB, OpenCL so is about 400KB, Vulkan so is about 400KB.

### Versatility
- Supports `Tensorflow`, `Caffe`, `ONNX`, and supports common neural networks such as `CNN`, `RNN`, `GAN`.
- Supports 86 `Tensorflow` ops, 34 `Caffe` ops; MNN ops: 71 for CPU, 55 for Metal, 29 for OpenCL, and 31 for Vulkan.
- Supports iOS 8.0+, Android 4.3+ and embedded devices with POSIX interface.
- Supports hybrid computing on multiple devices. Currently supports CPU and GPU. GPU op plugin can be loaded dynamically to replace default (CPU) op implementation.

### High performance
- Implements core computing with lots of optimized assembly code to make full use of the ARM CPU.
- For iOS, GPU acceleration (Metal) can be turned on, which is faster than Apple's native CoreML.
- For Android, `OpenCL`, `Vulkan`, and `OpenGL` are available and deep tuned for mainstream GPUs (`Adreno` and `Mali`).
- Convolution and transposition convolution algorithms are efficient and stable. The Winograd convolution algorithm is widely used to better symmetric convolutions such as 3x3 -> 7x7.
- Additional optimizations for the new architecture ARM v8.2 with half-precision calculation support.

### Easy to use
- Efficient image processing module, speeding up affine transform and color space transform without libyuv or opencv.
- Provides callbacks throughout the workflow to extract data or control the execution precisely.
- Provides options for selecting inference branch and paralleling branches on CPU and GPU.

## Architecture
![architecture](doc/architecture.png)

MNN can be divided into two parts: Converter and Interpreter.

Converter consists of Frontends and Graph Optimize. The former is responsible for supporting different training frameworks. MNN currently supports Tensorflow, Tensorflow Lite, Caffe and ONNX (PyTorch/MXNet); the latter optimizes graphs by operator fusion, operator substitution, and layout adjustment.

Interpreter consists of Engine and Backends. The former is responsible for the loading of the model and the scheduling of the calculation graph; the latter includes the memory allocation and the Op implementation under each computing device. In Engine and Backends, MNN applies a variety of optimization schemes, including applying Winograd algorithm in convolution and deconvolution, applying Strassen algorithm in matrix multiplication, low-precision calculation, Neon optimization, hand-written assembly, multi-thread optimization, memory reuse, heterogeneous computing, etc.

## Quick start
- [Install](doc/Install_EN.md)
- [Tutorial](doc/Tutorial_EN.md)
- [API](doc/API/API_index.html)
- [Demo](demo)
- [Model conversion](tools/converter/README.md)
- [Test tools](doc/Tools_EN.md)
- [Op list](doc/OpList.md)
- [Contributing](doc/Contributing_EN.md)
- [Model Compress](tools/quantization/README_CN.md)

## Benchmark
- [Benchmark](doc/Benchmark_EN.md)

## How to customize
- [Add custom op](doc/AddOp_EN.md)
- [Add custom backend](doc/AddBackend_EN.md)

## Feedbacks
- [FAQ](doc/FAQ.md)

Scan QR code to join DingDing discussion group.

<img src="doc/QRCodeDingDing.png" height="256"/>

## License
Apache 2.0

## Acknowledgement
MNN participants: Taobao Technology Department, Search Engineering Team, DAMO Team, Youku and other group employees.

MNN refers to the following projects:
- [Caffe](https://github.com/BVLC/caffe)
- [flatbuffer](https://github.com/google/flatbuffers)
- [gemmlowp](https://github.com/google/gemmlowp)
- [Google Vulkan demo](http://www.github.com/googlesamples/android-vulkan-tutorials)
- [Halide](https://github.com/halide/Halide)
- [Mace](https://github.com/XiaoMi/mace)
- [ONNX](https://github.com/onnx/onnx)
- [protobuffer](https://github.com/protocolbuffers/protobuf)
- [skia](https://github.com/google/skia)
- [Tensorflow](https://github.com/tensorflow/tensorflow)
- [ncnn](https://github.com/Tencent/ncnn)
- [paddle-mobile](https://github.com/PaddlePaddle/paddle-mobile)
- [stb](https://github.com/nothings/stb)
- [rapidjson](https://github.com/Tencent/rapidjson)

