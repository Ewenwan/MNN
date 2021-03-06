//
//  GLRelu.h
//  MNN
//
//  Created by MNN on 2019/01/31.
//  Copyright © 2018, Alibaba Group Holding Limited
//

#ifndef GLRelu_H
#define GLRelu_H
#include "Execution.hpp"
#include "GLProgram.hpp"
#include "GLTexture.hpp"
#include "MNN_generated.h"
namespace MNN {
namespace OpenGL {
class GLRelu : public MNN::Execution {
public:
    GLRelu(const std::vector<Tensor *> &inputs, const Op *op, Backend *bn);
    virtual ~GLRelu();
    ErrorCode onResize(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;
    virtual ErrorCode onExecute(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;

private:
    std::shared_ptr<GLProgram> mProgram;
    int mLocalSize[3];
    int mType;
    float mSlope;
};
} // namespace OpenGL
} // namespace MNN

#endif // GLRelu_H
