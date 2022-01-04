#ifndef CONVNET_H_
#define CONVNET_H_

#include <vector>
#include <string>
#include <math.h>
#include "cdnn_config.h"
#include "layer.h"
#include "util.h"

namespace ecdnn {

class Layer;

class ConvNet {
protected:
    std::vector<Layer*> _layers;
    std::vector<Layer*> _outputLayerV;
    std::vector<Layer*> _dataLayerV;
    Layer *_outputLayer;
    
    virtual Layer* initLayer(
            std::string& layerType, dictParam_t &paramsDict, int fixedMask);

public:
    ConvNet(listDictParam_t &layerParams, int fixedMask);

    ~ConvNet();

    /**
     * @brief Print the topology structure
     */
    void print();

    Layer* operator[](int idx);
    Layer* getLayer(int idx);

    int getNumLayers();

    int get_fixed_mask() const {
        return _fixed_mask;
    }

    int cnnScore(Matrix &data, Matrix &probs);
#ifndef IDCARD
    int cnnScore(Matrix &data, Matrix &probs,
            std::vector<std::string> &outlayer, MatrixV &feature);
#endif /* IDCARD */

    int initOutputMap(std::map<std::string, Matrix*> &outputMap);
    int releaseOutputMap(std::map<std::string, Matrix*> &outputMap);
    int setInputData(
            std::map<std::string, Matrix*> &outputMap,
            const std::vector<float*> &dataV,
            const std::vector<int> &imgWidthV,
            const std::vector<int> &imgHeighV,
            const std::vector<int> &imgChannelV,
            int dataNum);
    int setOutputData(
            std::map<std::string, Matrix*> &outputMap,
            std::vector<float*> &outputV,
            std::vector<int> &outputLen);

#ifndef IDCARD
    std::vector<int> getDataDimV();
    std::vector<int> getLabelsDimV();
#endif /* IDCARD */

#ifndef IDCARD
    int cnnVarsizeImageScore(
            const std::vector<std::string> &outlayer,
            std::map<std::string, Matrix*> &outputMap,
            MatrixV &feature);
#endif /* IDCARD */
    int cnnVarsizeImageScore(
            std::map<std::string, Matrix*> &outputMap);
#ifndef IDCARD
    int cnnVarsizeImageScore(
            std::map<std::string, Matrix*> &outputMap,
            std::vector<int>& label_mask);
#endif /* IDCARD */

protected:
    int _fixed_mask;
};

} // namespace ecdnn

#endif	/* CONVNET_H_ */
