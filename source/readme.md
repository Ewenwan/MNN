# 目录结构说明

 
    backend   后端各种层(op,算子) 的各种硬件平台的不同实现(cpu arm gpu)

    core      mnn核心算法结构

    cv        计算机视觉处理算法

    math      数学计算库  利用 Tensor 构建 矩阵Matrix
              提供二维矩阵乘法 Matrix::multi(C,A,B), 先16个数向量计算，剩余4个向量计算，最后普通c语言单个数计算
              矩阵加法   Matrix::add(C,A,B) , 先16个数向量计算，剩余4个向量计算，最后普通c语言单个数计算
              矩阵逆运算 Matrix::invert(Tensor* dst, const Tensor* src) 
              矩阵转置   Matrix::transpose(Tensor* dst, const Tensor* src)
              每一行乘一个数 Matrix::mulPerLine(Tensor* C, const Tensor* A, const Tensor* Line)
              每一行除一个数 Matrix::divPerLine(Tensor* C, const Tensor* A, const Tensor* Line)
              矩阵行列式的值 Matrix::matDet(const Tensor* A)
              
              构建基本的 向量Vec4  各种实例化方法  各种运算符的重载 
              
              
              
    shape     计算各种op的输入输出形状
