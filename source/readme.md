 # 目录结构说明

 
    backend   后端各种层(op,算子) 的各种硬件平台的不同实现(cpu arm gpu)

    core      mnn核心算法结构

    cv        计算机视觉处理算法
              灰度图转4通道RGBA  _gray2C4(source,dest, count)    r/g/b=gray  a=255   neon一次计算8个
              灰度图转3通道RGB   _gray2C3(source,dest, count)    r/g/b=gray  
              rgba 转 bgra      _rgba2bgra(source,dest, count)  r 和 b 交换swap      neon一次计算8个
              rgba 转 bgr       _rgba2bgr   去掉第四个通道       r 和 b 交换swap  
              rgb 转 bgr        _rgb2bgr
                                _bgra2bgr   去掉第四个通道  
              bgra 转 灰度图     _bgra2gray       gray = (19 * r + 38 * g + 7 * b) >> 6
              rgba 转 灰度图     _rgba2gray
                                _rgb2gray              
                                _bgr2gray
              NV21图像转RGBA     MNNNV21ToRGBA  一次计算16个  NEON计算
              NV21图像转RGB      MNNNV21ToRGB
              NV21图像转BGR      MNNNV21ToBGR   核心 MNNNV21ToBGRUnit函数 使用 汇编-NEON实现
                                source/backend/cpu/arm/arm32/MNNNV21ToBGRUnit.S 
              
              浮点数据
              _blitC1ToFloatC1  char类型单通道 减去均值 乘以归一化参数   neon 一次处理16个数据
                                一次读入 16个char数据 先转成16个16bit数据 再转成16个32bit的float数据
                                之后和float类型的 mean均值 和 normal归一化参数 惊喜计算
              _blitC3ToFloatC3  char类型三通道                   
                                
                                
    math      数学计算库  主要是 为了 Winograd 卷积运算
           1. 利用 Tensor 构建 矩阵Matrix
              提供二维矩阵乘法 Matrix::multi(C,A,B), 
                     先16个数向量计算，剩余4个向量计算，最后普通c语言单个数计算
              矩阵加法   Matrix::add(C,A,B) , 
                     先16个数向量计算，剩余4个向量计算，最后普通c语言单个数计算
              矩阵逆运算 Matrix::invert(Tensor* dst, const Tensor* src) 
              矩阵转置   Matrix::transpose(Tensor* dst, const Tensor* src)
              每一行乘一个数 Matrix::mulPerLine(Tensor* C, const Tensor* A, const Tensor* Line)
              每一行除一个数 Matrix::divPerLine(Tensor* C, const Tensor* A, const Tensor* Line)
              矩阵行列式的值 Matrix::matDet(const Tensor* A)
              
           2. 构建基本的 向量Vec4  各种实例化方法  各种运算符的重载 
              
           3. Winograd 因子生成器 WinogradGenerater::WinogradGenerater
              computeF(const float* a, int alpha);
              computeT(const float* a, int n);
              computeL(const float* a, int n);
              computeB(const float* a, int alpha);
              computeA(const float* a, int m, int n);
              computeFDiag(const float* a, int alpha);
              
              权重数据重排 WinogradGenerater::transformWeight(const Tensor* weightDest, const Tensor* source)
                  内存申请 WinogradGenerater::allocTransformWeight(const Tensor* source, int unitCi, int unitCo, bool alloc) 
                  
              nchw  ---> n c/4 h w*4
              
              
              
                
              
    shape     计算各种op的输入输出形状
    
            根据输入tensor的维度信息，计算输出tensor的维度信息，并设置输出tensor的数据类型。 
            继承基类SizeComputer，实现onComputeSize函数，若输入维度信息未知返回false，计算完成后返回true。
            
            
            
