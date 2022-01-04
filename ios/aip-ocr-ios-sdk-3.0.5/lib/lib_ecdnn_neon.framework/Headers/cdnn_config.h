/*
 * cdnn_config.h
 *
 *  Created on: 2015年10月16日
 *      Author: liuyiqun01
 */

#ifndef CDNN_CONFIG_H_
#define CDNN_CONFIG_H_

#define APP_TAG "EmbedCDNN"
#define TAG "EmbedCDNN"

#ifdef ANDROID
#include <malloc.h>
#include <android/log.h>
#include <android/asset_manager.h>

#if defined(__ARM_NEON__) || defined(__ARM_NEON) // || defined(__SSSE3__)
#define HAVE_NEON
#else /* !__ARM_NEON__ && !__SSSE3__ */
//#error "No support of NEON or SSSE3!"
#endif /* __ARM_NEON__ || __SSSE3__ */

#define PRINT_INFO(...) 	__android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__)
#define PRINT_WARN(...) 	__android_log_print(ANDROID_LOG_WARN, TAG, __VA_ARGS__)
#define PRINT_ERROR(...)	__android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

#define	BDIDL_DECL(func, ...)	func(AAssetManager *aassetManager, __VA_ARGS__)
#define	BDIDL_CALL(func, ...)	func(aassetManager, __VA_ARGS__)
#else /* !ANDROID */
#include <stdio.h>
#include <stdlib.h>

#ifdef __ARM_NEON
#define HAVE_NEON
#endif /* __ARM_NEON */

#define	PRINT_INFO(...)		fprintf(stdout, __VA_ARGS__)
#define	PRINT_WARN(...)		fprintf(stdout, __VA_ARGS__)
#define	PRINT_ERROR(...)	fprintf(stderr, __VA_ARGS__)

#define	BDIDL_DECL(func, ...)	func(__VA_ARGS__)
#define	BDIDL_CALL(func, ...)	func(__VA_ARGS__)

inline void *memalign(size_t align_width, size_t bytes) {
	void *ptr = NULL;

	posix_memalign(&ptr, align_width, bytes);

	return ptr;
}
#endif /* ANDROID */

#ifdef USE_EXCEPTION
#include <iostream>
#include <exception>
#define	SET_EXCEPTION	try {
#define	GET_EXCEPTION	} catch (std::exception& e) { PRINT_ERROR("Exception: %s, in %s\n", e.what(), __func__); }
#else /* !USE_EXCEPTION */
#define	SET_EXCEPTION
#define	GET_EXCEPTION
#endif /* USE_EXCEPTION */

#ifdef DEBUG
#define DEBUG_OUTPUT_1	PRINT_INFO("Enter %s\n", __func__)
#define DEBUG_OUTPUT_2	PRINT_INFO("Leave %s\n", __func__)
#else /* DEBUG */
#define DEBUG_OUTPUT_1
#define DEBUG_OUTPUT_2
#endif /* DEBUG */

#ifdef MEM_DEBUG
#define DEF_COUNTER int mem_allocs = 0
#define USE_COUNTER extern int mem_allocs
#define MEM_ALLOC   ++mem_allocs
#define MEM_FREE    --mem_allocs
#define MEM_INFO_1  PRINT_INFO("mem_allocs = %d, Enter %s\n", mem_allocs, __func__)
#define MEM_INFO_2  PRINT_INFO("mem_allocs = %d, Leave %s\n", mem_allocs, __func__)
#else /* MEM_DEBUG */
#define DEF_COUNTER
#define USE_COUNTER
#define MEM_ALLOC
#define MEM_FREE
#define MEM_INFO_1
#define MEM_INFO_2
#endif /* MEM_DEBUG */


#include <stdlib.h>

#ifdef ANDROID
#include <android/log.h>

#define LOGD(format, ...) __android_log_print(ANDROID_LOG_DEBUG, APP_TAG, \
        format "\n", ##__VA_ARGS__)
#define LOGI(format, ...) __android_log_print(ANDROID_LOG_INFO, APP_TAG, \
        format "\n", ##__VA_ARGS__)
#define LOGW(format, ...) __android_log_print(ANDROID_LOG_WARN, APP_TAG, \
        format "\n", ##__VA_ARGS__)
#define LOGE(format, ...) __android_log_print(ANDROID_LOG_ERROR, APP_TAG, \
        "Error: " format "\n", ##__VA_ARGS__)
#else /* ANDROID */
#define LOGD(format, ...) fprintf(stdout, "[%s %s] " format "\n", APP_TAG, \
        __func__, ##__VA_ARGS__)
#define LOGI(format, ...) fprintf(stdout, "[%s %s] " format "\n", APP_TAG, \
        __func__, ##__VA_ARGS__)
#define LOGW(format, ...) fprintf(stdout, "[%s %s] " format "\n", APP_TAG, \
        __func__, ##__VA_ARGS__)
#define LOGE(format, ...) fprintf(stderr, "[%s %s] Error: " format "\n", APP_TAG, \
        __func__, ##__VA_ARGS__)
#endif /* ADNROID */

#ifdef DEBUG
#define DLOWD(format, ...)  LOGD(format, __VA_ARGS__)
#define DLOGI(format, ...)  LOGI(format, __VA_ARGS__)
#define DLOGW(format, ...)  LOGW(format, __VA_ARGS__)
#define DLOWE(format, ...)  LOGD(format, __VA_ARGS__)

class EntryRaiiObject {
public:
    EntryRaiiObject(const char* func) : _func(func) {
        LOGW("Enter %s", _func);
    }
    ~EntryRaiiObject() {
        LOGW("Leave %s", _func);
    }
private:
    const char* _func;
};

#define BDIDL_ENTER(...)    __VA_ARGS__ { \
    EntryRaiiObject obj ## __LINE__ (__func__);
#define BDIDL_LEAVE         }
#else /* DEBUG */
#define DLOGD(format, ...)
#define DLOGI(format, ...)
#define DLOGW(format, ...)
#define DLOGE(format, ...)

#define BDIDL_ENTER(...)    __VA_ARGS__
#define BDIDL_LEAVE
#endif /* DEBUG */

#endif /* CDNN_CONFIG_H_ */
