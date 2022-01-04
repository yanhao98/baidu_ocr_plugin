#ifndef CDNNSCORE_H_
#define	CDNNSCORE_H_

#include <vector>
#include <string>
#ifdef ANDROID
#include <android/asset_manager.h>
#endif /* ANDROID */

#include "cdnn_config.h"

namespace ecdnn {

enum FixedMask {
    FIXED_NO_LAYER = 0x0,	/* Default */

    /* Convert the weights of ConvLayer into fixed-precision. */
    FIXED_CONV_LAYER = 0x1,

    /* Convert the weights of FCLayer into fixed-precision. */
    FIXED_FC_LAYER = 0x2,

    /* Fixed options. */
    OP_FIXED8_C16 = 0x10, /* Default */
    OP_FIXED8_C32 = 0x20,
    OP_FIXED16_C32 = 0x40,

    /* When the model is stored in fixed precision. */
    LOAD_FIXED_CONV_LAYER = 0x100,
    LOAD_FIXED_FC_LAYER = 0x200
};

enum ModelType {
    OTHER_MODEL = 0,
    CAFFE_MODEL = 1
};

int checkNeonSupport();

int setNumberOfThreads(int numberOfThreads);

#ifdef ANDROID
int cdnnInitModel(AAssetManager *aassetManager,
        const char *filePath,
        void *&model,
        ModelType modelType,
        FixedMask fixedMask=FIXED_NO_LAYER);
#else /* !ANDROID */
int cdnnInitModel(const char *filePath,
        void *&model,
        ModelType modelType,
        FixedMask fixedMask=FIXED_NO_LAYER);
#endif /* ANDROID */

int cdnnReleaseModel(void **model);

int cdnnGetDataDim(void *model);
int cdnnGetLabelsDim(void *model);
#ifndef IDCARD
int cdnnGetDataDimV(void *model, std::vector<int> &dataDimV);
int cdnnGetLabelsDimV(void *model, std::vector<int> &labelsDimV);
#endif /* IDCARD */

#ifndef IDCARD
int cdnnFeatExtract(float *data, void *model, int dataNum, int dataDim,
        std::vector<std::string> &outlayer, float *&outFeat, int &outFeatDim,
        bool isVarsize = false);
int cdnnVarsizeFeatExtract(
        void *model,
        int dataNum,
        const std::vector<float *> &dataV,
        const std::vector<int> &imgWidthV,
        const std::vector<int> &imgHeightV,
        const std::vector<int> &imgChannelV,
        const std::vector<std::string> &outlayer,
        float *&outFeat,
        int &outFeatDim);
#endif /* IDCARD */

// TODO cdnnScoreMultiPatch

// TODO cdnnGetSlideWinSize
// TODO cdnnGetSlideWinNum
// TODO cdnnGetSlideWin

int cdnnScore(float *data, void *model, int dataNum, int dataDim, float *probs, bool isVarsize = false);
int cdnnVarsizeImageScore(
        const std::vector<float*> &dataV,
        void *model,
        const std::vector<int> &imgWidthV,
        const std::vector<int> &imgHeightV,
        const std::vector<int> &imgChannelV,
        int dataNum,
        std::vector<float*> &outValV,
        std::vector<int> &outLenV);

#ifndef IDCARD
int cdnnVarsizeImageScore(
        const std::vector<float*> &dataV,
        void *model,
        const std::vector<int> &imgWidthV,
        const std::vector<int> &imgHeightV,
        const std::vector<int> &imgChannelV,
        int dataNum,
        std::vector<int>& label_mask,
        std::vector<float*> &outValV,
        std::vector<int> &outLenV);
#endif /* IDCARD */

} // namespace ecdnn

#endif	/* CDNNSCORE_H_ */
