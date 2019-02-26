#include "mdmrvec.h"

double array1[] = {0.0,-0.13954,-0.13634,-0.12969,-0.11907,-0.10357,-0.08173,-0.05129,-0.00871,0.05129,0.1356,0.24917,0.38271,0.50066,0.56857,0.59017,0.58772,0.57678,0.56429,0.55278,0.543,0.53502,0.52874,0.52397,0.52049,0.51806,0.51621,0.51402,0.50928,0.49651,0.46244,0.38168,0.2379,0.07321,-0.0559,-0.14132,-0.19661,-0.23362,-0.25954,-0.27848,-0.29285,-0.30409,-0.31311,-0.32051,-0.32666,-0.33182,-0.33612,-0.33961,-0.34219,-0.34358,-0.34314,-0.33948,-0.32967,-0.30758,0.0,0.0,-0.96131,-0.96295,-0.96624,-0.97117,-0.97766,-0.9854,-0.99357,-1.0,-0.99941,-0.97948,-0.91468,-0.76839,-0.53111,-0.26172,-0.02998,0.14382,0.27,0.3633,0.4349,0.4923,0.54044,0.58267,0.62143,0.6586,0.69578,0.73438,0.77544,0.81889,0.86059,0.88378,0.8437,0.68597,0.44798,0.23271,0.07811,-0.02643,-0.0973,-0.14606,-0.17981,-0.20285,-0.21781,-0.22623,-0.22899,-0.22644,-0.21852,-0.20476,-0.18416,-0.15505,-0.11476,-0.05908,0.01862,0.12847,0.28388,0.0,0.0,-0.24319,-0.23847,-0.22867,-0.21302,-0.19024,-0.15821,-0.11368,-0.05156,0.03571,0.15804,0.32251,0.5156,0.68556,0.78164,0.80841,0.79789,0.77276,0.74319,0.71276,0.68229,0.65147,0.6194,0.58482,0.54595,0.50024,0.44379,0.37041,0.26978,0.12486,-0.08836,-0.38109,-0.68963,-0.89257,-0.97235,-0.98826,-0.98152,-0.96886,-0.95605,-0.94491,-0.93585,-0.92888,-0.92386,-0.92064,-0.9191,-0.91917,-0.92078,-0.92384,-0.92822,-0.93355,-0.93888,-0.94188,-0.93678,-0.90969,0.0 };

size_t array1_len = 165;

int64_t array2[] = { 202, 303, 404, 505, 321, 210, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 101, };
size_t array2_len = 17;

//==============================================================================
// Usage example

mdmr_dataset_b64* create() {
    // create dataset with 2 blocks
    mdmr_dataset* dataset = mdmr_create(2);

    // create block 0
    mdmr_define_block(dataset, 0, float64, 165);
    mdmr_define_block(dataset, 1, int64, 17);

    // initialize dataset
    mdmr_dataset* initset = mdmr_init(dataset);

    // check
    if (initset == NULL) {
        free(dataset);
        return NULL;
    }
    dataset = initset;

    // set data
    mdmr_set_block(dataset, 0, array1);
    mdmr_set_block(dataset, 1, array2);

    // generate base64
    //   get size of base64-encoded string with: dataset_b64->size
    //   get base64-encoded string (char[]) with: dataset_b64->data
    mdmr_dataset_b64* dataset_b64 = mdmr_dataset_as_b64(dataset);

    // clean up the working area
    free(dataset);

    return dataset_b64;
}

//==============================================================================

void test_unpack(mdmr_dataset_b64* dataset_b64) {
    size_t decode_len = Base64decode_len(dataset_b64->data);

    mdmr_dataset* dataset = (mdmr_dataset*)malloc(decode_len);
    Base64decode((char*)dataset, dataset_b64->data);

    printf("dataset magic: %.*s\n", 4, dataset->magic);
    printf("dataset version: %.*s\n", 4, dataset->version);
    printf("dataset n_blocks: %d\n", dataset->n_blocks);


    char* testdata[] = { (char*)&array1, (char*)&array2 };
    size_t testlens[] = { array1_len, array2_len };

    for (size_t i = 0; i < dataset->n_blocks; i++) {
        printf("block: %ld\n", i);
        printf("  type: %ud\n", dataset->blockinfo[i].type);
        printf("  length: %lld\n", dataset->blockinfo[i].length);

        size_t offset = mdmr_block_offset(dataset, 1);
        void* test1 = (char*)( ((char*)dataset) + offset);
        void* test2 = (char*)testdata[i];
        size_t test_len = dataset->blockinfo[i].length * mdmr_dtype_size(dataset->blockinfo[i].type);
        int res = memcmp(test1, test2, test_len);
        printf("memcmp check (0 is good): %d\n", res);

// debug
/*
        if (false && i == 0) {
            for (size_t j = 0; j < dataset->blockinfo[i].length; j++) {
                printf("%f\n", ((double*)test1)[j]);
            }
        }

        if (true && i == 1) {
            for (size_t j = 0; j < dataset->blockinfo[i].length; j++) {
                printf("%lld\n", ((int64_t*)test1)[j]);
            }
        }
*/
    }
}

int main(int argc, char** argv) {

    mdmr_dataset_b64* dataset_b64 = create();

    printf("encoded size: %ld\n", dataset_b64->size);

    test_unpack(dataset_b64);
    mdmr_dataset_b64_free(dataset_b64);

    return 0;
}
