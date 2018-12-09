#include "stddef.h"
#include "stdlib.h"
#include "string.h"

#include "base64_all.h"

#define MDMR_SUCC  0
#define MDMR_FAIL -1
const char mdmr_magic[]   = "MDMR";
const char mdmr_version[] = "0001";

typedef enum e_mdmr_dtype {
    char_t,
    int32,
    int64,
    float32,
    float64,
} mdmr_dtype;

#pragma pack(1)
typedef struct mdmr_block {
    mdmr_dtype  type;
    int64_t     length;
} mdmr_block;

#pragma pack(1)
typedef struct mdmr_dataset {
    char        magic[4];
    char        version[4];
    int32_t     n_blocks;
    mdmr_block  blockinfo[];
} mdmr_dataset;

#pragma pack(1)
typedef struct mdmr_dataset_b64 {
    size_t size;
    char* data;
} mdmr_dataset_b64;

//============================================================================

size_t mdmr_dtype_size(mdmr_dtype type) {
    switch (type) {
        case char_t:
            return 1;
        case int32:
        case float32:
            return 4;
        case int64:
        case float64:
            return 8;
    }
    return 0;
}

// return the offset to block from the start of dataset
size_t mdmr_block_offset(mdmr_dataset* dataset, size_t blockidx) {
    if (blockidx < 0 || blockidx > dataset->n_blocks) {
        return 0;
    }

    size_t offset = sizeof(mdmr_dataset) + sizeof(mdmr_block) * dataset->n_blocks;
    for (size_t i = 0; i < blockidx; i++) {
        mdmr_block* block = &dataset->blockinfo[i];
        offset += mdmr_dtype_size(block->type) * block->length;
    }
    return offset;
}

size_t mdmr_dataset_size(mdmr_dataset* dataset) {
    size_t size = sizeof(mdmr_dataset) + sizeof(mdmr_block) * dataset->n_blocks;
    for (size_t i = 0; i < dataset->n_blocks; i++) {
        mdmr_block* block = &(dataset->blockinfo[i]);
        size += mdmr_dtype_size(block->type) * block->length;
    }
    return size;
}

mdmr_dataset* mdmr_create(size_t n_blocks) {
    mdmr_dataset* dataset = (mdmr_dataset*)
                            malloc( sizeof(mdmr_dataset)
                                  + sizeof(mdmr_block) * n_blocks);

    if (dataset == NULL) return NULL;

    dataset->n_blocks = n_blocks;
    strncpy(dataset->magic,   (char*)mdmr_magic, 4);
    strncpy(dataset->version, (char*)mdmr_version, 4);

    return dataset;
}

mdmr_dataset* mdmr_init(mdmr_dataset* dataset) {
    size_t size = mdmr_dataset_size(dataset);
    mdmr_dataset* new_p = (mdmr_dataset*)realloc(dataset, size);

    if (new_p == NULL) return NULL;
    return new_p;
}

void mdmr_define_block(mdmr_dataset* dataset, size_t blockidx,
                       mdmr_dtype type, size_t length) {

    dataset->blockinfo[blockidx].type = type;
    dataset->blockinfo[blockidx].length = length;
}

void mdmr_set_block(mdmr_dataset* dataset, size_t blockidx, void* data) {
    ptrdiff_t offset = mdmr_block_offset(dataset, blockidx);
    mdmr_block* block = &dataset->blockinfo[blockidx];
    size_t datalen = block->length * mdmr_dtype_size(block->type);
    memcpy((char*)dataset + offset, data, datalen);
}

void* mdmr_block_ptr(mdmr_dataset* dataset, size_t blockidx) {
    ptrdiff_t offset = mdmr_block_offset(dataset, blockidx);
    return dataset + offset;
}

mdmr_dataset_b64* mdmr_dataset_as_b64(mdmr_dataset* dataset) {
    size_t dataset_size = mdmr_dataset_size(dataset);
    size_t encode_size = Base64encode_len(dataset_size);
    char* dest = (char*)malloc(encode_size);
    int res = Base64encode(dest, (char*)dataset, dataset_size);

    mdmr_dataset_b64* b64data = (mdmr_dataset_b64*)malloc(sizeof(mdmr_dataset_b64));
    b64data->size = encode_size;
    b64data->data = dest;
    return b64data;
}

void mdmr_dataset_b64_free(mdmr_dataset_b64* b64data) {
    free(b64data->data);
    free(b64data);
}
